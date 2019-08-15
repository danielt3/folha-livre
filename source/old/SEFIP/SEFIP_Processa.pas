unit SEFIP_Processa;

interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls, ADODB, Gauges, Forms, Controls;

function ProcessaSEFIP( Conexao: TADOConnection;
                        Ano, Mes, CR,
                        Indicador_FGTS, Indicador_PS, Indice_PS: SmallInt;
                        Data_FGTS, Data_PS: TDateTime;
                        Empresa, Lotacao, Tipo, Saida: String; Gauge:TGauge):Boolean;

implementation

uses
  SEFIP, SEFIP_Resumo, Util2;

const
  CCA_BASE_INSS = 490;
  CCA_BASE_FTGS = 92;
  CCA_FGTS = 89;
  CCA_SALARIO_FAMILIA = 100;
  CCA_SALARIO_MATERNIDADE = 22;
  TPF_13_SALARIO = '3';
  TPF_NORMAL = 'N';

(* Retorna atraves da Query a relacao de funcionarios com os
   respectivos totais de rubricas de determinado grupo *)

procedure PesquisaValor( Conexao: TADOConnection; Query: TADOQuery; Ano, Mes: SmallInt;
  Empresa, Lotacao, Tipo, Grupo:String; Totalizar: Boolean);
var
  sAno, sMes: String;
begin

  sAno := Format('%.4d',[Ano]);
  sMes := Format('%.2d',[Mes]);

  with Query do begin

    Connection  := Conexao;
    Close;

    SQL.Clear;
    SQL.BeginUpdate;
    SQL.Add('SELECT');

    if not Totalizar then
      SQL.Add('  LF.co_funcionario, SUM(LF.vr_calculado)')
    else
      SQL.Add('  SUM(LF.vr_calculado)');

    SQL.Add('FROM');
    SQL.Add('  folha_pagamento FP, lancamento_folha LF, funcionario F');
    SQL.Add('WHERE');
    SQL.Add('  FP.co_empresa = '+QuotedStr(Empresa) ) ;
    SQL.Add('  AND FP.ano_folha = '+QuotedStr(sAno) ) ;
    SQL.Add('  AND FP.mes_folha = '+QuotedStr(sMes) ) ;
    SQL.Add('  AND (LF.co_empresa = FP.co_empresa)');
    SQL.Add('  AND (LF.co_folha = FP.co_folha)');
    SQL.Add('  AND (LF.vr_calculado > 0)');
    SQL.Add('  AND LF.co_rubrica IN (');
    SQL.Add('       SELECT co_rubrica');
    SQL.Add('       FROM   grupo_rubricas G, rubricas_especiais R');
    SQL.Add('       WHERE  G.ds_grupo_rubrica = '+QuotedStr(Grupo));
    SQL.Add('              AND R.co_grupo_rubrica = G.co_grupo_rubrica )');
    SQL.Add('  AND (F.co_empresa = LF.co_empresa)');
    SQL.Add('  AND (F.co_funcionario = LF.co_funcionario)' );

    if Length(Lotacao) > 0 then
      SQL.Add('  AND F.co_lotacao = '+QuotedStr(Lotacao) );

    if Length(Tipo) > 0 then
      SQL.Add('  AND F.co_tipo_funcionario = '+QuotedStr(Tipo) );

    if not Totalizar then begin
      SQL.Add('GROUP BY');
      SQL.Add('  LF.co_funcionario');
    end; // if not Totalizar

    SQL.EndUpdate;

    Open;

  end;  // with Query do

end;  // procedure PesquisaValor

procedure PesquisaCodigoCalculo( Conexao: TADOConnection;
  Query: TADOQuery; Ano, Mes, CodigoCalculo: SmallInt;
  TipoFolha, Empresa, Lotacao, TipoFuncionario:String; Totalizar: Boolean);
var
  sAno, sMes: String;
begin

  sAno := Format('%.4d',[Ano]);
  sMes := Format('%.2d',[Mes]);

  with Query do begin

    Connection  := Conexao;
    Close;

    SQL.Clear;
    SQL.BeginUpdate;
    SQL.Add('SELECT');

    if not Totalizar then
      SQL.Add('  LF.co_funcionario, SUM(LF.vr_calculado)')
    else
      SQL.Add('  SUM(LF.vr_calculado)');

    SQL.Add('FROM');
    SQL.Add('  folha_pagamento FP, lancamento_folha LF, rubrica R');

    if not Totalizar then
      SQL.Add('  ,funcionario F');

    SQL.Add('WHERE');
    SQL.Add('  FP.co_empresa = '+QuotedStr(Empresa) ) ;
    SQL.Add('  AND FP.ano_folha = '+QuotedStr(sAno) ) ;
    SQL.Add('  AND FP.mes_folha = '+QuotedStr(sMes) ) ;

    if TipoFolha <> 'X' then
      SQL.Add('  AND FP.tp_folha = '+QuotedStr(TipoFolha) );
      
    SQL.Add('  AND (LF.co_empresa = FP.co_empresa)');
    SQL.Add('  AND (LF.co_folha = FP.co_folha)');
    SQL.Add('  AND (LF.vr_calculado > 0)');
    SQL.Add('  AND (R.co_empresa = LF.co_empresa)');
    SQL.Add('  AND (R.codigocalculo = '+IntToStr(CodigoCalculo)+')');

    if not Totalizar then begin
      SQL.Add('  AND (F.co_empresa = LF.co_empresa)');
      SQL.Add('  AND (F.co_funcionario = LF.co_funcionario)' );
    end;

    if Length(Lotacao) > 0 then
      SQL.Add('  AND F.co_lotacao = '+QuotedStr(Lotacao) );

    if Length(TipoFuncionario) > 0 then
      SQL.Add('  AND F.co_tipo_funcionario = '+QuotedStr(TipoFuncionario) );

    if not Totalizar then begin
      SQL.Add('GROUP BY');
      SQL.Add('  LF.co_funcionario');
    end; // if not Totalizar

    SQL.EndUpdate;

    Open;

  end;  // with Query do

end;  // procedure PesquisaCodigoCalculo

// CR - Codigo de Recolhimento

function ProcessaSEFIP( Conexao: TADOConnection;
                        Ano, Mes, CR,
                        Indicador_FGTS, Indicador_PS, Indice_PS: SmallInt;
                        Data_FGTS, Data_PS: TDateTime;
                        Empresa, Lotacao, Tipo, Saida: String; Gauge:TGauge):Boolean;
var

  Query, QryTrabalhador: TADOQuery;

  Qry_Sem_13, Qry_Com_13: TADOQuery;
  Qry_Retido, Qry_Base: TADOQuery;
  Qry_Base_13, Qry_Rem_13: TADOQuery;

  Qry_Familia, Qry_Maternidade: TADOQuery;
  Qry_Contribuicao, Qry_ValorDevido: TADOQuery;

  stRegxx, stReg00, stReg10, stReg14, stReg30: TStringList;

  sLinha, sAno, sMes: String;

  sTipo, sInscricao, sNome, sEndereco, sBairro: String;
  sCEP, sCidade, sUF, sTelefone, sEmail: String;
  sContato: String;

  sCNAE, sCCentral, sTerceiros: String;
  sPag_GPS, sFPAS, sSimples: String;

  iFuncionario: Integer;
  cFGTS: Currency;

  cSAT, cFilantropia, cTotalSalarioFamilia: Currency;
  cTotalSalarioMaternidade: Currency;
  cTotalContribDescEmpregado, cTotalValorDevido: Currency;

  cTotalBaseFGTS, cTotalBaseFGTS13, cTotalFGTS, cTotalFGTS13: Currency;

  // ------ Dados do Funcionario - registro 30
  dAdmissao, dOpcao, dNascimento: TDateTime;
  sPIS, sMatricula, sCTPS, sSerie, sCBO: String;
  iCategoria, iQtde: Integer;

  cSem13, cSobre13, cRetido, cBase, cBase13, cRem13: Currency;
  sClasse, sOcorrencia: String;

  // --------- Dados de inclusao/alteracao de endereco - 14 registro ------
  dEndereco: TDateTime;
  tempCursor: TCursor;

begin

  Gauge.Progress             := 0;

  cTotalSalarioFamilia       := 0;
  cTotalSalarioMaternidade   := 0;
  cTotalContribDescEmpregado := 0;
  cTotalValorDevido          := 0;

  stRegxx := TStringList.Create;  // Lista de String Fantasma

  stReg00 := TStringList.Create;
  stReg10 := TStringList.Create;
  stReg14 := TStringList.Create;
  stReg30 := TStringList.Create;

  Query := TADOQuery.Create(nil);
  QryTrabalhador := TADOQuery.Create(nil);

  Qry_Sem_13  := TADOQuery.Create(nil);
  Qry_Com_13  := TADOQuery.Create(nil);

  Qry_Retido  := TADOQuery.Create(nil);

  Qry_Base    := TADOQuery.Create(nil);
  Qry_Base_13 := TADOQuery.Create(nil);
  Qry_Rem_13  := TADOQuery.Create(nil);

  Qry_Familia     := TADOQuery.Create(nil);
  Qry_Maternidade := TADOQuery.Create(nil);

  Qry_Contribuicao := TADOQuery.Create(nil);
  Qry_ValorDevido  := TADOQuery.Create(nil);

  tempCursor    := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try try

    sAno := Format( '%.4d', [Ano] ) ;
    sMes := Format( '%.2d', [Mes] ) ;

    if Saida = 'R' then begin

      PesquisaCodigoCalculo( Conexao, Query, Ano, Mes, CCA_BASE_FTGS,
                     TPF_NORMAL, Empresa,
                     Lotacao, Tipo, True);

      cTotalBaseFGTS := Query.Fields[0].AsCurrency;

      // ---------------------------------------------

      PesquisaCodigoCalculo( Conexao, Query, Ano, Mes, CCA_BASE_FTGS,
                             TPF_13_SALARIO, Empresa,
                             Lotacao, Tipo, True);

      cTotalBaseFGTS13 := Query.Fields[0].AsCurrency;

      // ---------------------------------------------------

      PesquisaCodigoCalculo( Conexao, Query, Ano, Mes, CCA_FGTS,
                             TPF_NORMAL, Empresa, Lotacao, Tipo, True);

      cTotalFGTS := Query.Fields[0].AsCurrency;

      // -----------------------------------------------------

      PesquisaCodigoCalculo( Conexao, Query, Ano, Mes, CCA_FGTS,
                             TPF_13_SALARIO, Empresa, Lotacao, Tipo, True);

      cTotalFGTS13 := Query.Fields[0].AsCurrency;

      // -------------------------------------------------------

      PesquisaCodigoCalculo( Conexao, Query, Ano, Mes, CCA_BASE_FTGS,
                             TPF_NORMAL, Empresa, Lotacao, Tipo, False);

      iQtde := Query.RecordCount;

      ProcessaSEFIP_Resumo( Empresa, Ano, Mes, iQtde,
                        cTotalBaseFGTS, cTotalFGTS, cTotalBaseFGTS13, cTotalFGTS13);

      Exit;

    end;  // if sSaida = 'R'

    (* Obtem o total de valores pago no mes das rubricas
       tipo 'SALARIO FAMILIA' - Campo 22 - Registro 10 *)
    if (sMes <> '13') then
      case CR of
        130, 145, 150, 155, 317, 337, 345, 608, 640, 650,
        660, 904, 907..911:
        else begin
          PesquisaCodigoCalculo( Conexao, Qry_Familia, Ano, Mes, CCA_SALARIO_FAMILIA,
                         'X', Empresa, Lotacao, Tipo, True);
          cTotalSalarioFamilia := Qry_Familia.Fields[0].AsCurrency;
        end;
      end;

    (* Obtem o total de valores pago no mes das rubricas
       tipo 'SALARIO MATERNIDADE' - Campo 23 - Registro 10 *)
    if (sMes <> '13') then
      case CR of
        130, 145, 345, 640, 650, 660, 904, 909, 911:
        else begin
          PesquisaCodigoCalculo( Conexao, Qry_Maternidade, Ano, Mes,
                         CCA_SALARIO_MATERNIDADE, 'X', Empresa,
                         Lotacao, Tipo, True);
          cTotalSalarioMaternidade := Qry_Maternidade.Fields[0].AsCurrency;
        end;
      end;

    (* Obtem o total de valores pago no mes das rubricas
       tipo 'CONTRIB. DESC. EMPREGADO' - Campo 24 - Registro 10 *)
    if (sMes = '12') then
      case CR of
        145, 345, 640, 660:
        else begin
          PesquisaValor( Conexao, Qry_Contribuicao, Ano, Mes, Empresa,
                         Lotacao, Tipo, 'CONTRIB. EMPREGADO', True);
          cTotalContribDescEmpregado := Qry_Contribuicao.Fields[0].AsCurrency;
        end;
      end;

    (* Obtem o total de valores pago no mes das rubricas
       tipo 'VALOR DEVIDO A PREVIDENCIA' - Campo 26 - Registro 10 *)
    if (sMes = '12') then
      case CR of
        145, 345, 640, 660:
        else begin
          PesquisaValor( Conexao, Qry_ValorDevido, Ano, Mes, Empresa,
                         Lotacao, Tipo, 'VALOR DEVIDO PREV.', True);
          cTotalValorDevido := Qry_ValorDevido.Fields[0].AsCurrency;
        end;
      end;

    (* Obtem a relacao dos funcionarios e o total das rubricas
       tipo 'REMUNERACAO SEM 13' - Campo 16 - Registro 30 *)
    PesquisaCodigoCalculo( Conexao, Qry_Sem_13, Ano, Mes,
                           CCA_BASE_FTGS, TPF_NORMAL,
                           Empresa, Lotacao, Tipo, False);

    (* Obtem a relacao dos funcionarios e o total das rubricas
       tipo 'REMUNERACAO COM 13' - Campo 17 - Registro 30 *)
    PesquisaCodigoCalculo( Conexao, Qry_Com_13, Ano, Mes,
                           CCA_BASE_FTGS, TPF_13_SALARIO,
                           Empresa, Lotacao, Tipo, False);

    (*
       Obtem a relacao dos funcionarios e o total das rubricas
       tipo 'VALOR RETIDO SEGURADO' - Campo 20 - Registro 30
    PesquisaValor( Conexao, Qry_Retido, Ano, Mes, Empresa, Lotacao, Tipo,
                   'VALOR RETIDO SEG.', False);
     *)

    (* Obtem a relacao dos funcionarios e o total das rubricas tipo
       'REMUNERACAO BASE DE CALCULO DA CONTRIBUICAO PREVIDENCIA' - Campo 21 - Registro 30 *)
    PesquisaCodigoCalculo( Conexao, Qry_Base, Ano, Mes, CCA_BASE_INSS,
                           'X', Empresa, Lotacao, Tipo, False);

    (* Obtem a relacao dos funcionarios e o total das rubricas tipo
       'BASE DE CALCULO 13 SALARIO PREVIDENCIA SOCIAL' - Campo 22 - Registro 30 *)
    PesquisaCodigoCalculo( Conexao, Qry_Base_13, Ano, Mes, CCA_BASE_INSS,
                           TPF_13_SALARIO, Empresa, Lotacao, Tipo, False);

    (* Obtem a relacao dos funcionarios e o total das rubricas tipo
      'REMUNERACAO 13 SALARIO PREV. SOCIAL - BASE DE CALCULO PARA A COMPETENCIA 13' - Campo 23 - Registro 30 *)
    PesquisaCodigoCalculo( Conexao, Qry_Rem_13, Ano, Mes, CCA_BASE_INSS,
                           TPF_13_SALARIO, Empresa, Lotacao, Tipo, False);

    (* Obtem as informacoes de um determindado trabalhador *)
    with QryTrabalhador do begin
      Connection := Conexao;
      SQL.Clear;
      SQL.BeginUpdate;
      SQL.Add('SELECT');
      SQL.Add('  F.*, C.* FROM FUNCIONARIO F, CARGO C');
      SQL.Add('WHERE');
      SQL.Add('  co_empresa = '+QuotedStr(Empresa) );
      SQL.Add('  AND F.co_funcionario = :codigo');
      SQL.Add('  AND C.co_cargo = F.co_cargo');
      SQL.EndUpdate;
    end;

    (* Obtem as informacoes da empresa que estah fornecendo a informacao
       e do responsavel pelas informacoes da folha *)
    with Query do begin

      Connection := Conexao;

      SQL.Clear;
      SQL.BeginUpdate;
      SQL.Add('SELECT * FROM EMPRESA');
      SQL.Add('WHERE co_empresa = '+QuotedStr(Empresa) );
      SQL.EndUpdate;
      Open;

      sTipo := FieldByName('resp_co_tipo_pessoa').AsString;

      if sTipo = '1' then // CNPJ
        sInscricao := FieldByName('resp_num_cgc').AsString
      else   // CPF
        sInscricao := FieldByName('resp_num_cpf').AsString;

      sNome     := FieldByName('Responsavel').AsString;
      sContato  := FieldByName('Contato').AsString;
      sEndereco := FieldByName('resp_ds_endereco').AsString;
      sBairro   := FieldByName('resp_ds_bairro').AsString;
      sCEP      := FieldByName('resp_num_cep').AsString;
      sCidade   := FieldByName('resp_ds_cidade').AsString;
      sUF       := FieldByName('resp_sg_uf').AsString;
      sTelefone := FieldByName('resp_num_telefone').AsString;
      sEmail    := FieldByName('resp_ds_email').AsString;

      // INFORMACOES PARA O REGISTRO 00 - INFORMACOES DO RESPONSAVEL
      SetResponsavel( sTipo, sInscricao, sNome, sContato,
                      sEndereco, sBairro, sCEP, sCidade, sUF,
                      sTelefone, sEmail);

      // TECNOINF - TECNOLOGIA EM INFORMATICA LTDA
      // CGC-CNPJ: 15.340.060/0001-20
      // RUA JERONIMO PIMENTEL, 299 - UMARIZAL - BELEM - PA - CEP 66055-000
      SetFornecedor( '1', '15340060000120');

      SetCompetencia( Ano, Mes);
      SetRecolhimento( CR, Indicador_FGTS, 1, Indicador_PS, Indice_PS,
                       Data_FGTS, Data_PS );

      sLinha := Header_Arquivo;  // Gerando Registro 00 - Informacoes do resp.
      stReg00.Add( sLinha);

      // INFORMACOES PARA O REGISTRO 10 - INFORMACOES DA EMPRESA

      sTipo := '1';
      sInscricao := FieldByName('num_cgc').AsString;

      sNome     := FieldByName('no_razao_social').AsString;
      sEndereco := FieldByName('ds_endereco').AsString;
      sBairro   := FieldByName('ds_bairro').AsString;
      sCEP      := FieldByName('num_cep').AsString;
      sCidade   := FieldByName('ds_cidade').AsString;
      sUF       := FieldByName('sg_uf').AsString;
      sTelefone := FieldByName('telefone').AsString;

      // codigo de centralizacao 0, 1, 2
      sCCentral  := FieldByName('CodigoCentralizacao').AsString;
      sCNAE      := FieldByName('co_atividade').AsString;
      sTerceiros := FieldByName('grps_co_terceiro').AsString;
      sPag_GPS   := FieldByName('grps_co_gps').AsString;
      sFPAS      := FieldByName('grps_co_fpas').AsString;
      sSimples   := FieldByName('st_simples').AsString;

      cSAT           := FieldByName('Aliquota_SAT').AsCurrency;
      cFilantropia   := 0;

      SetEmpresa_SEFIP( sTipo, sInscricao, sNome, sEndereco, sBairro,
                  sCEP, sCidade, sUF, sTelefone, 'N');

      Set10Codigo( sCNAE, 'N', sCCentral, sSimples, sFPAS,
                   sTerceiros, sPag_GPS);

      Set10Valor( cSAT, cFilantropia, cTotalSalarioFamilia,
                  cTotalSalarioMaternidade, cTotalContribDescEmpregado,
                  cTotalValorDevido );

      sLinha := Header_Empresa; // Gerando registro 10 - Informacoes da empresa
      stReg10.Add( sLinha);

      Close;

      // Obtem a relacao de funcionarios participantes da folha
      SQL.Clear;
      SQL.BeginUpdate;
      SQL.Add('SELECT');
      SQL.Add('  DISTINCT LF.co_funcionario, F.num_pispasep');
      SQL.Add('FROM');
      SQL.Add('  folha_pagamento FP, lancamento_folha LF,');
      SQL.Add('  funcionario F');
      SQL.Add('WHERE');
      SQL.Add('  FP.co_empresa = '+QuotedStr(Empresa) );
      SQL.Add('  AND FP.ano_folha = '+QuotedStr(sAno) ) ;
      SQL.Add('  AND FP.mes_folha = '+QuotedStr(sMes) ) ;
      SQL.Add('  AND (LF.co_empresa = FP.co_empresa)');
      SQL.Add('  AND (LF.co_folha = FP.co_folha)');
      SQL.Add('  AND (LF.vr_calculado > 0)');
      SQL.Add('  AND (F.co_empresa = LF.co_empresa)');
      SQL.Add('  AND (F.co_funcionario = LF.co_funcionario)');

      if Length(Lotacao) > 0 then
        SQL.Add('  AND F.co_lotacao = '+QuotedStr(Lotacao) );

      if Length(Tipo) > 0 then
        SQL.Add('  AND F.co_tipo_funcionario = '+QuotedStr(Tipo) );

      SQL.Add('ORDER BY');
      SQL.Add('  F.num_pispasep');
      SQL.EndUpdate;
      Open;

      Gauge.MaxValue := RecordCount;

      First;

      while not EOF do begin

        Gauge.AddProgress(1);

        iFuncionario := Fields[0].AsInteger;

        cSem13 := 0; cSobre13 := 0; cRetido := 0;
        cBase  := 0; cBase13  := 0; cRem13  := 0;

        if Qry_Sem_13.Locate( 'co_funcionario', iFuncionario, []) then
          cSem13 := Qry_Sem_13.Fields[1].AsCurrency;

        if Qry_Com_13.Locate( 'co_funcionario', iFuncionario, []) then
          cSobre13 := Qry_Com_13.Fields[1].AsCurrency;

        (*
        if Qry_Retido.Locate( 'co_funcionario', iFuncionario, []) then
          cRetido := Qry_Retido.Fields[1].AsCurrency;
        *)
        
        if Qry_Base.Locate( 'co_funcionario', iFuncionario, []) then
          cBase := Qry_Base.Fields[1].AsCurrency;

        if Qry_Base_13.Locate( 'co_funcionario', iFuncionario, []) then
          cBase13 := Qry_Base_13.Fields[1].AsCurrency;

        if Qry_Rem_13.Locate( 'co_funcionario', iFuncionario, []) then
          cRem13 := Qry_Rem_13.Fields[1].AsCurrency;

        if ( cSem13 + cSobre13 + cRetido + cBase + cBase13 + cRem13 ) > 0 then
        with QryTrabalhador do begin

          Close;
          Parameters[0].Value := iFuncionario;
          Open;

          // =========== REGISTRO TIPO 30 - REGISTRO DO TRABALHADOR =========

          sNome  := FieldByName('no_funcionario').AsString;

          dOpcao      := FieldByName('dt_opcao_fgts').AsDateTime;
          dNascimento := FieldByName('dt_nascimento').AsDateTime;
          dAdmissao   := FieldByName('dt_admissao').AsDateTime;
          iCategoria  := FieldByName('CategoriaTrabalhador').AsInteger;

          sPIS        := FieldByName('num_pispasep').AsString;
          sMatricula  := FieldByName('co_funcionario').AsString;
          sCTPS       := FieldByName('ctps_num_ctps').AsString;
          sSerie      := FieldByName('ctps_num_serie').AsString;
          sCBO        := FieldByName('co_CBO').AsString;
          sOcorrencia := FieldByName('co_ocorrencias_fgts').AsString;
          sClasse     := FieldByName('co_classe_fgts').AsString;

          SetFuncionario( sPIS, dAdmissao, dOpcao, dNascimento, iCategoria,
                          sNome, sMatricula, sCTPS, sSerie, sCBO );

          Set30Valor( cSem13, cSobre13, cRetido, cBase, cBase13, cRem13,
                      sClasse, sOcorrencia);

          // Gera o registro 30 =============================
          sLinha := Registro30;
          if Length(sLinha) > 0 then
            stReg30.Add( sLinha);

          // == REGISTRO TIPO 14 - INCLUSAO/ALTERACAO ENDERECO TRABALHADOR ====
          dEndereco := FieldByName('dt_endereco_alt').AsDateTime;

          sEndereco := FieldByName('ds_endereco').AsString;
          sBairro   := FieldByName('ds_bairro').AsString;
          sCEP      := FieldByName('num_cep').AsString;
          sCidade   := FieldByName('ds_cidade').AsString;
          sUF       := FieldByName('sg_uf').AsString;

          SetFuncionarioEndereco( dEndereco,
                                  sEndereco, sBairro, sCEP, sCidade, sUF);

          sLinha := Registro14;
          if Length(sLinha) > 0 then
            stReg14.Add(sLinha);

        end;  // with QryTrabalhador

        Next;

      end;

      if qryTrabalhador.Active then
        qryTrabalhador.Close;

    end;  // with

    GeraArquivoSEFIP( stReg00, stReg10, stRegxx, stRegxx,
                      stReg14, stRegxx, stRegxx, stReg30,
                      stRegxx, stRegxx, stRegxx, stRegxx );

  finally

    Query.Free;
    qryTrabalhador.Free;

    Qry_Sem_13.Free;
    Qry_Com_13.Free;

    Qry_Retido.Free;
    Qry_Base.Free;
    Qry_Base_13.Free;
    Qry_Rem_13.Free;

    Qry_Familia.Free;
    Qry_Maternidade.Free;

    Qry_ValorDevido.Free;
    Qry_Contribuicao.Free;
    
    stReg00.Free;
    stReg10.Free;
    stReg14.Free;
    stReg30.Free;

    Screen.Cursor := tempCursor;

  end;
  except
    on E:Exception do
      MsgErro( 'Erro em SEFIP.DLL - ProcessaSEFIF'+#13+E.Message);
  end;

end;

end.
