unit CAGED_Processa;

interface

uses
  Windows, Messages, SysUtils, Classes, StdCtrls, ADODB, Gauges, Forms, Controls;

function ProcessaCAGED( Conexao: TADOConnection;
                        Ano, Mes: Word; Primeira: Boolean;
                        Alteracao, Meio, Empresa, Lotacao, Tipo: String;
                        Gauge:TGauge):Boolean;

implementation

uses
  CAGED;

(* Retorna atraves da Query a relacao de funcionarios admitidos e demitidos
   no mes/ano informado *)

procedure PesquisaFunc( Query: TADOQuery;
  Ano, Mes: SmallInt; Empresa, Lotacao, Tipo: String);
begin

  with Query do begin

    Close;

    SQL.Clear;
    SQL.BeginUpdate;
    SQL.Add('SELECT F.*, C.* FROM FUNCIONARIO F, CARGO C');
    SQL.Add('WHERE');
    SQL.Add('  F.co_empresa = '+QuotedStr(Empresa) ) ;

    if Length(Lotacao) > 0 then
      SQL.Add('  AND F.co_lotacao = '+QuotedStr(Lotacao) );

    if Length(Tipo) > 0 then
      SQL.Add('  AND F.co_tipo_funcionario = '+QuotedStr(Tipo) );

    SQL.Add('  AND (');
    SQL.Add('     ( MONTH(F.dt_admissao) = '+IntToStr(Mes) );
    SQL.Add('       AND YEAR(F.dt_admissao) = '+IntToStr(Ano) + ')' );

    SQL.Add('  OR ( MONTH(F.dt_rescisao) = '+IntToStr(Mes) );
    SQL.Add('       AND YEAR(F.dt_rescisao) = '+IntToStr(Ano) + ')' );
    SQL.Add('      )');
    SQL.Add(' AND C.co_cargo = F.co_cargo');

    SQL.Add('ORDER BY F.dt_rescisao, F.dt_admissao');

    SQL.EndUpdate;

    Open;

  end;  // with Query do

end;  // procedure PesquisaValor

// CR - Codigo de Recolhimento

function ProcessaCAGED( Conexao: TADOConnection;
                        Ano, Mes: Word; Primeira: Boolean;
                        Alteracao, Meio, Empresa, Lotacao, Tipo: String;
                        Gauge:TGauge):Boolean;
var

  Query: TADOQuery;

  stRegX, stRegA, stRegB, stRegC : TStringList;

  sLinha,
  sAutorizao_MTE, sAtividadeEconomica,
  sTipo, sInscricao, sNome, sEndereco, sBairro: String;
  sCEP, sCidade, sUF, sDDD, sTelefone, sRamal: String;

  cSalario: Currency;

  dAdmissao, dRescisao, dNascimento: TDateTime;
  sPIS, sCTPS, sCTPS_Serie, sCTPS_UF, sCBO: String;
  sRaca, sSexo, sInstrucao, sCodigoAdmissao, sCodigoRescisao: String;
  iQtdeEmpregados: Integer;

  iCargaSemana: Byte;
  bPequenoPorte, bDeficiente: Boolean;

  tempCursor: TCursor;

begin

  Result := True;
  
  Gauge.Progress := 0;
  stRegA := TStringList.Create;
  stRegB := TStringList.Create;
  stRegC := TStringList.Create;
  stRegX := TStringList.Create;

  Query := TADOQuery.Create(nil);

  tempCursor    := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try try

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
      else   // CPF?
        sInscricao := StringOfChar( '0', 14);

      sNome     := FieldByName('resp_no_responsavel').AsString;
      sEndereco := FieldByName('resp_ds_endereco').AsString;
      sBairro   := FieldByName('resp_ds_bairro').AsString;
      sCEP      := FieldByName('resp_num_cep').AsString;
      sCidade   := FieldByName('resp_ds_cidade').AsString;
      sUF       := FieldByName('resp_sg_uf').AsString;
      sTelefone := FieldByName('resp_num_telefone').AsString;

      // INFORMACOES PARA O REGISTRO A - INFORMACOES DO RESPONSAVEL
      SetCAGED_A( Meio, sAutorizao_MTE, sInscricao, sNome,
                  sEndereco, sUF, sCEP, sDDD, sTelefone, sRamal,
                  Mes, Ano);

      // INFORMACOES PARA O REGISTRO B - INFORMACOES DA EMPRESA

      iQtdeEmpregados := 0;
      sTipo := '1';
      sInscricao := FieldByName('num_cgc').AsString;

      sAtividadeEconomica := FieldByName('co_atividade').AsString;
      bPequenoPorte       := (FieldByName('st_pequeno_porte').AsString = '1');

      sNome     := FieldByName('no_razao_social').AsString;
      sEndereco := FieldByName('ds_endereco').AsString;
      sBairro   := FieldByName('ds_bairro').AsString;
      sCEP      := FieldByName('num_cep').AsString;
      sCidade   := FieldByName('ds_cidade').AsString;
      sUF       := FieldByName('sg_uf').AsString;
      sTelefone := FieldByName('telefone').AsString;

      SetCAGED_B( sInscricao, sAtividadeEconomica, Alteracao, sNome,
                  sEndereco, sBairro, sCEP, sUF,
                  Primeira, bPequenoPorte, iQtdeEmpregados );

      sLinha := CAGED_REG_B; // Gerando registro B - Informacoes da empresa
      stRegB.Add( sLinha);

      Close;

      PesquisaFunc( Query, Ano, Mes, Empresa, Lotacao, Tipo);
      Gauge.MaxValue := RecordCount;

      First;

      while not EOF do begin

        Gauge.AddProgress(1);

        // = REGISTRO TIPO C - REGISTRO DO TRABALHADOR MOVIMENTADO =

        sPIS         := FieldByName('num_pispasep').AsString;
        sCBO         := FieldByName('co_CBO').AsString;
        sNome        := FieldByName('no_funcionario').AsString;
        sCTPS        := FieldByName('ctps_num_ctps').AsString;
        sCTPS_Serie  := FieldByName('ctps_num_serie').AsString;
        sCTPS_UF     := FieldByName('ctps_sg_uf').AsString;

        sSexo        := FieldByName('sg_sexo').AsString;
        sInstrucao   := FieldByName('co_grau_intrucao_rais').AsString;
        sRaca        := FieldByName('co_tipo_raca_rais').AsString;

        sCodigoAdmissao := FieldByName('co_caged_adm').AsString;
        sCodigoRescisao := FieldByName('co_caged_dem').AsString;

        dNascimento  := FieldByName('dt_nascimento').AsDateTime;
        dAdmissao    := FieldByName('dt_admissao').AsDateTime;
        dRescisao    := FieldByName('dt_rescisao').AsDateTime;

        iCargaSemana := FieldByName('num_horas_semanais').AsInteger;
        cSalario     := FieldByName('vr_salario').AsCurrency;
        bDeficiente  := (FieldByName('flag_deficiente').AsString = '1');

        SetCAGED_C( sPIS, sCBO, sNome, sCTPS, sCTPS_Serie, sCTPS_UF,
                    sSexo, sInstrucao, sRaca,
                    sCodigoAdmissao, sCodigoRescisao,
                    dNascimento, dAdmissao, dRescisao,
                    iCargaSemana, cSalario, bDeficiente);

        // Gera o registro 30 =============================
        sLinha := CAGED_REG_C;

        if Length(sLinha) > 0 then
          stRegC.Add( sLinha);

        Next;

      end;

    end;  // with

    sLinha := CAGED_REG_A;  // Gerando Registro A - Informacoes do resp.
    stRegA.Add( sLinha);

    GeraArquivoCAGED( stRegA, stRegB, stRegC, stRegX);

  finally

    Query.Free;

    stRegX.Free;
    stRegA.Free;
    stRegB.Free;
    stRegC.Free;

    Screen.Cursor := tempCursor;

  end;
  except
    Result := False;
  end;

end;

end.
