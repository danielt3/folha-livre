{
Projeto FolhaLivre - Folha de Pagamento Livre
Calculador Geral do FolhaLivre

Copyright (c) 2002-2008 Allan Lima.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

{
Histórico das alterações
========================

* 25/05/2005 - Adicionado situação de funcionários por tipo de folha:
               Tabela: F_FOLHA_TIPO_SITUACAO, Unidade: ffolha_tipo.pas;
* 06/06/2005 - Adicionado as funções XE e XI;
* 19/06/2005 - Adicionado o cálculo de folha complementar;
* 10/07/2005 - Adicionado o evento complementar;
* 23/08/2006 - Adicionado a função DSR() para suporte ao calculo do "Descanso Semanal Remunerado";
* 01/03/2007 - Bug Fix: 1666112 - Testar Valores Minimo e Maximo;
* 01/03/2007 - Bug fix: 1672060 - Salário Mensal e Salário;
* 03/03/2007 - Adicionado a função MAA() - Meses de Admissão no Ano;
* 03/03/2007 - Adicionado a função MM() - Meses para Média;
* 06/03/2007 - Adicionado a função GN() - Gratificação Natalina;
* 08/03/2007 - Adicionado a função PDF() - Domingos e Feriados no Periodo;
* 08/03/2007 - Adicionado a função PDU() - Dias Uteis no Periodo;
* 18/03/2007 - Adicionado a função SN() - Salario Normal;
* 01/04/2007 - Adicionado Eventos Programados.
               Tabela: F_PROGRAMADO, Unidade: fprogramado.pas;
* 04/10/2007 - Adicionado o recurso de transação (start/rollback/commit);
* 07/01/2008 - Reimplementação da função Totalizador();
* 27/02/2008 - Função IRRF();
* 12/03/2008 - Seleção de Funcionários para o cálculo através da tabela F_FOLHA_FUNCIONARIO;
* 12/05/2008 - Adicionado filtro "CATEGORIA DE FGTS" para os eventos padroes na tabela F_PADRAO_FGTS;
* 20/05/2008 - Adicionado filtro "TIPO DE FUNCIONARIO" para os eventos padroes na tabela F_PADRAO_TIPO;
* 21/05/2008 - Adicionado filtro "SITUACAO DE FUNCIONARIO" para os eventos padroes na tabela F_PADRAO_SITUACAO;
* 21/05/2008 - Adicionado filtro "VINCULO EMPREGATICIO DE FUNCIONARIO" para os eventos padroes na tabela F_PADRAO_VINCULO;
* 21/05/2008 - Adicionado filtro "TIPO DE SALARIO DE FUNCIONARIO" para os eventos padroes na tabela F_PADRAO_SALARIO;
* 23/05/2008 - Implementado a sequência de cálculo especifica dos eventos padroes,
               independentemente da sequência de cálulo do grupo de pagamento;
}

{$IFNDEF QFLIVRE}
unit fcalculador;
{$ENDIF}

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}QControls, QDialogs,{$ENDIF}
  {$IFDEF VCL}Controls, Dialogs,{$ENDIF}
  {$IFNDEF DEBUG}fprogress,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient, Variants, AKExpression;

type
  TkCalculador = class
  protected
    {$IFNDEF DEBUG}
    FProgresso: TFrmProgress;
    {$ENDIF}
    FExpression: TAKExpression;
    cdSequencia, cdInformado, cdAutomatico, cdProgramado, cdPadrao: TClientDataSet;
    cdFolha, cdFuncionario, cdDependenteTipo: TClientDataSet;
    cdCentralFunc, cdCentral, cdIncidencias: TClientDataSet;
    cdValorGlobal, cdValorLocal, cdTabelaGlobal, cdTabelaLocal: TClientDataSet;
    cdTabelaGlobalItem, cdTabelaLocalItem: TClientDataSet;
    cdRescisao, cdRescisaoEvento: TClientDataSet;
    cdFerias: TClientDataSet; { 14/03/2008 - allan_lima }
    cdFeriasEvento: TClientDataSet; { 14/03/2008 - allan_lima }
    procedure LocalEvaluate(Sender: TObject; Eval: String;
      Args: array of Variant; ArgCount: Integer; var Value: Variant; var Done: Boolean);
    procedure LocalVariable(Sender: TObject; Eval: String;
      var Value: Variant; var Done: Boolean);
  private

    pvStartTransaction: Boolean;
    pvTipoFolha, pvSituacaoFunc, pvTipoFunc, pvVinculoFunc,
    pvTipoSalario, pvEventoEntrada: String;
    pvEventoNome: String; { 06/06/2005 - allan_lima }
    pvCausaRescisao: String;  { 28/05/2005 - allan_lima }
    pvMesAno: String; { 13/03/2008 - allan_lima }
    pvFGTSFunc: String; { 19/05/2008 - allan_lima }
    pvSequenciaCalculo: Boolean; { 23/05/2008 - allan_lima }

    pvCargaHoraria, pvCompetencia, pvEmpresa, pvFolha,
    pvGE, pvGP, pvEvento, pvFuncionario: Integer;
    pvSindicato: Integer; { 29/05/2005 - allan_lima }
    pvTabelaIRRF: Integer; { 27/02/2008 - allan_lima }

    pvInicio, pvFim, pvAdmissao, pvDemissao: TDateTime;
    pvCredito: TDateTime; { 06/06/2005 - allan_lima }

    pvPadraoFGTS,     { 12/05/2008 by allan_lima }
    pvPadraoTipo,     { 20/05/2008 by allan_lima }
    pvPadraoSituacao, { 21/05/2008 by allan_lima }
    pvPadraoVinculo,  { 21/05/2008 by allan_lima }
    pvPadraoSalario: TStringList; { 21/05/2008 by allan_lima }

    pvFolhaComplementar: Boolean; { 19/06/2005 - allan_lima }

    pvDiasInativo, pvDiasPagamento: SmallInt;

    pvReferencia, pvTotalizado, pvMultiplicador,
    pvBase, pvDesconto, pvProvento, pvTaxa, pvInformado: Double;

    pvDSR: Double;
    pvDiasUteis: Double;
    pvDiasNaoUteis: Double;

    pvSQL: TStringList;

    function Delete:Boolean;
    procedure Commit;
    procedure AtualizaIncidencia( const Valor: Double);

    // funcoes de manipulacao de Valores
    function ValorLocal( Codigo: Integer): Double; overload; // Valor Local
    function ValorGlobal( Codigo: Integer): Double; overload; // Valor Global
    function ValorGeral( Codigo: Integer): Double; overload;

    function ValorLocal( Nome: String): Double; overload; // Valor Local
    function ValorGlobal( Nome: String): Double; overload; // Valor Global
    function ValorGeral( Nome: String): Double; overload;

    // funcoes de manipulacao de indices
    function Indices( Empresa, Indice: Integer; Data: TDateTime;
                      Erro: Boolean = False): Double;
    function IndiceGeral( Indice: Integer): Double;  // Indice Local ou Global
    function IndiceLocal( Indice: Integer): Double;  // Indice Local
    function IndiceGlobal( Indice: Integer): Double;  // Indice Global

    // funcoes de manipulacao de tabelas
    function TabelaLocal( Tabela: Integer; Valor: Double): Double; // Tabela Local
    function TabelaLocalItem( Tabela, Item: Integer): Double;
    function TabelaGlobal( Tabela: Integer; Valor: Double): Double;  // Tabela Global
    function TabelaGlobalItem( Tabela, Item: Integer): Double;
    function TabelaGeral( Tabela: Integer; Valor: Double): Double; // Tabela Local ou Global
    function TabelaGeralItem( Tabela, Item: Integer): Double;

    function Evento( Codigo: Integer; Folha: Integer;  Campo: String = 'CALCULADO'): Double; overload;
    function Evento( Codigo: Integer; Campo: String = 'CALCULADO'): Double; overload;

    function ValorMaximoEvento: Double;
    function ValorMinimoEvento: Double;

    function TotalIncidencia( Incidencia: Integer): Double; overload;
    function TotalIncidencia( Incidencia: String): Double; overload;
    function TotalIncidenciaNome( Nome: String): Double;

    function ContraPartida( Evento: Integer): Double; overload;
    function ContraPartida( Evento: String): Double; overload;
    function TempoServico():Integer;

    function Dependente( const Tipo: String = '';
                         const Sexo: String = '';
                         const Invalido: String = ''): Integer;
    function DependenteGeral( const Tipo: String = '';
                              const Sexo: String = '';
                              const Invalido: String = ''): Integer;

    function TempoNascimento():Integer;

    function Proporcional( Valor: Double):Double; overload;
    function Proporcional( Valor: Integer):Integer; overload;

    function HoraNormal():Double;
    function SalarioNormal: Double;
    function SalarioMensal():Double;
    function PesquisaValorInformado( var Formula: String):Boolean;
    procedure NumeroDiasInativos();

    function SetInformado( Value: Currency): Currency;
    function SetReferencia( Value: Currency): Currency;
    function SetTotalizado( Value: Currency): Currency;

    // função XI<i> ou XI(<i>,<mes>,<ano>)
    function XI( Incidencia, Mes, Ano: Integer): Double;

    // função XE<e> ou XE(<e>,<mes>,<ano>)
    function XE( Evento, Mes, Ano: Integer): Double;

    function ValorBase( const Evento: Integer): Double; { 19/06/2005 - allan_lima }

    { Descanso Semanal Remunerado }
    function DSR():Double; { 23/08/2006 - allan_lima }
    { Meses de Admissao no Ano }
    function MAA(): Double; { 03/03/2007 - allan_lima }
    { Meses para Media }
    function MM(): Double; { 03/03/2007 - allan_lima }
    { Gratificacao Natalina - 13o. salario }
    function GN(): Double;
    function DiasNaoUteis: Double;  { 03/03/2007 - allan_lima }
    function DiasUteis: Double;
    function IRRF(Incidencia: Integer): Double;
    function Ferias: Double;

  public
    constructor Create;
    destructor Destroy; override;
    function doCalculate: Boolean;
    procedure InitDatabase( DataSet: TDataSet);
  end;

function kCalculador( DataSet: TDataSet;
 const Empresa, Folha: Integer;
 const Limpar:Boolean; const IniciarTransacao: Boolean ): Boolean;

function TotalizadorPadrao(
  Valor, Calculo: String;
  Empresa, Funcionario, Evento: Integer;
  Inicio, Fim: TDateTime;
  TipoFolha: String;
  Totalizado: Boolean; const IniciarTransacao: Boolean): Double;

function Totalizador( Empresa, Total, Funcionario, Evento: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean): Double;

function BaseAcumulacao( GE, Empresa, Folha, Base, Funcionario, Evento: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean): Double;

implementation

uses fdb, ftext, cDateTime, fdata, Math, fsystem, DateUtils;

const
  C_EV_NAO_CALCULAR = 0; { Não calcular para folha complementar }
  C_EV_COMPLEMENTAR = 1; { Paga apenas a diferença }
  C_EV_TOTAL        = 2; { Paga o total calculado }
  C_ERRO_PARAMETRO  = 'Número de parametros incorreto';
  C_COMPETENCIAS: array[1..13] of String =
    ( 'JANEIRO_X',  'FEVEREIRO_X', 'MARCO_X',  'ABRIL_X',    'MAIO_X',
      'JUNHO_X',    'JULHO_X',     'AGOSTO_X', 'SETEMBRO_X', 'OUTUBRO_X',
      'NOVEMBRO_X', 'DEZEMBRO_X',  'SALARIO13_X');

  // Tipo de Salário
  TS_SALARIO_FIXO = 'F';
  TS_SALARIO_VARIAVEL = 'V';
  TS_PRODUCAO = 'P';
  // Tipo de Cálculo
  TC_CONTRA_PARTIDA = 'C';
  TC_VALOR_INFORMADO = 'I';
  TC_HORA_TRABALHADA = 'H';
  TC_DIA_TRABALHADO = 'D';
  TC_FORMULA = 'F';

function kCalculador( DataSet: TDataSet; const Empresa, Folha: Integer;
  const Limpar:Boolean; const IniciarTransacao: Boolean ): Boolean;
var
  Frm: TkCalculador;
  iTabela: Integer;
begin

  Result := True;

  iTabela := StrToInt( kGetSystem('IRRF_TABELA', '2'));

  // Cria o objeto interno de calculo
  Frm := TkCalculador.Create;

  if IniciarTransacao then
    kStartTransaction();

  try try

    with Frm do
    begin

      pvStartTransaction := IniciarTransacao;

      pvEmpresa := Empresa;
      pvFolha   := Folha;
      pvTabelaIRRF := iTabela;

      InitDatabase(DataSet);

      {$IFNDEF DEBUG}
      FProgresso.MaxValue := DataSet.RecordCount;
      {$ENDIF}

      DataSet.First;

      while not DataSet.EOF do
      begin

        {$IFNDEF DEBUG}
        // Apresenta o progresso do calculo por funcionários
        {
        FProgresso.Mensagem :=
           DataSet.FieldByName('NOME').AsString+' - '+
             'De '+IntToStr(DataSet.RecNo)+' a '+IntToStr(FProgresso.MaxValue);
        }
        FProgresso.AddProgress(1);
        {$ENDIF}

        if (DataSet.Fields[DataSet.FieldCount-1].AsInteger = 1) then
        begin

          pvFuncionario := DataSet.Fields[0].AsInteger;

          if Limpar then
            Delete()
          else if not doCalculate() then
            raise Exception.Create('kCalculador()');

        end;

        DataSet.Next;

      end; // while

    end;

  except
    on E:Exception do
    begin
      if kInTransaction() then
        kRollbackTransaction();
      kErro( E, EmptyStr, 'fcalculador', 'kCalculador()');
    end;
  end;

  finally
    if kInTransaction() then
      kCommitTransaction();
    Frm.Free;
  end;

end;

constructor TkCalculador.Create;
begin

  inherited;

  cdDependenteTipo   := TClientDataSet.Create(NIL);
  cdCentral          := TClientDataSet.Create(NIL);
  cdCentralFunc      := TClientDataSet.Create(NIL);
  cdFolha            := TClientDataSet.Create(NIL);
  cdFuncionario      := TClientDataSet.Create(NIL);

  cdIncidencias      := TClientDataSet.Create(NIL);

  cdSequencia        := TClientDataSet.Create(NIL);
  cdInformado        := TClientDataSet.Create(NIL);
  cdAutomatico       := TClientDataSet.Create(NIL);
  cdProgramado       := TClientDataSet.Create(NIL); { 01/04/2007 - allan_lima }
  cdPadrao           := TClientDataSet.Create(NIL);

  cdRescisao         := TClientDataSet.Create(NIL); { 28/05/2005 - allan_lima }
  cdRescisaoEvento   := TClientDataSet.Create(NIL); { 28/05/2005 - allan_lima }

  cdFerias           := TClientDataSet.Create(NIL); { 14/03/2008 - allan_lima }
  cdFeriasEvento     := TClientDataSet.Create(NIL); { 14/03/2008 - allan_lima }

  cdValorGlobal      := TClientDataSet.Create(NIL);
  cdValorLocal       := TClientDataSet.Create(NIL);

  cdTabelaGlobal     := TClientDataSet.Create(NIL);
  cdTabelaLocal      := TClientDataSet.Create(NIL);

  cdTabelaGlobalItem := TClientDataSet.Create(NIL);
  cdTabelaLocalItem  := TClientDataSet.Create(NIL);

  FExpression := TAKExpression.Create(NIL);

  with FExpression do
  begin
    OnEvaluate    := LocalEvaluate;
    OnVariable    := LocalVariable;
    DataSetList.E := cdSequencia;
    DataSetList.F := cdFuncionario;
    DataSetList.L := cdFolha;
    DataSetList.R := cdRescisao;  { 29/05/2005 - allan_lima }
  end;

  pvSQL := TStringList.Create;

  pvDSR := -1;
  pvDiasUteis := -1;
  pvDiasNaoUteis := -1;

  {$IFNDEF DEBUG}
  FProgresso := CriaProgress(EmptyStr);
  FProgresso.Rotulo.Visible := False;
  FProgresso.Bar.Align := alClient;
  FProgresso.Bar.Font.Size := FProgresso.Bar.Font.Size * 2;
  {$ENDIF}

  pvPadraoFGTS := TStringList.Create;
  pvPadraoTipo := TStringList.Create;
  pvPadraoSituacao := TStringList.Create;
  pvPadraoVinculo := TStringList.Create;
  pvPadraoSalario := TStringList.Create;
  
end; // create

procedure TkCalculador.InitDatabase( DataSet: TDataSet);
var
  iCount: Integer;
begin

  pvSQL.BeginUpdate;
  pvSQL.Clear;
  pvSQL.Add('SELECT F.*, GP.IDGE, T.SEQUENCIA_X');
  pvSQL.Add('FROM F_FOLHA F, F_GRUPO_PAGAMENTO GP, F_FOLHA_TIPO T');
  pvSQL.Add('WHERE');
  pvSQL.Add('  F.IDEMPRESA = :E AND F.IDFOLHA = :F AND GP.IDGP = F.IDGP');
  pvSQL.Add('  AND T.IDFOLHA_TIPO = F.IDFOLHA_TIPO');
  pvSQL.EndUpdate;

  kOpenSQL( cdFolha, pvSQL.Text, [pvEmpresa, pvFolha], not pvStartTransaction);

  if Assigned(cdFolha.FindField('ARQUIVAR_X')) and
     (cdFolha.FieldByName('ARQUIVAR_X').AsInteger = 1) then
  begin
    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add('A folha de pagamento já está arquivada,');
    pvSQL.Add('por isso não pode ser calculada.');
    pvSQL.Add('');
    pvSQL.Add('Verifique o cadastro da folha.');
    pvSQL.EndUpdate;
    raise Exception.Create(pvSQL.Text);
  end;

  kSQLSelectFrom( cdDependenteTipo, 'F_DEPENDENTE_TIPO', EmptyStr, not pvStartTransaction);
  kSQLSelectFrom( cdCentral, 'F_CENTRAL', 'IDEMPRESA IS NULL', not pvStartTransaction);
  kSQLSelectFrom( cdCentralFunc, 'F_CENTRAL_FUNCIONARIO', 0, EmptyStr, not pvStartTransaction);

  cdIncidencias.FieldDefs.Add('IDINCIDENCIA', ftInteger);
  cdIncidencias.FieldDefs.Add('NOME', ftString, 30);
  cdIncidencias.FieldDefs.Add('TOTAL', ftCurrency);

  kOpenSQL( cdIncidencias, 'F_INCIDENCIA', EmptyStr, [], not pvStartTransaction);

  with cdFolha do
  begin
    pvTipoFolha         := FieldByName('IDFOLHA_TIPO').AsString;
    pvInicio            := FieldByName('PERIODO_INICIO').AsDateTime;
    pvFim               := FieldByName('PERIODO_FIM').AsDateTime;
    pvCompetencia       := FieldByName('COMPETENCIA').AsInteger;
    pvGE                := FieldByName('IDGE').AsInteger;
    pvGP                := FieldByName('IDGP').AsInteger;
    pvCredito           := FieldByName('DATA_CREDITO').AsDateTime; { 06/06/2005 - allan_lima }
    pvFolhaComplementar := (FieldByName('COMPLEMENTAR_X').AsInteger = 1); { 19/06/2005 - allan_lima }
    pvMesAno            := FieldByName('MES_ANO').AsString; { 13/03/2005 - allan_lima }
    pvSequenciaCalculo  := (FieldByName('SEQUENCIA_X').AsInteger = 1); { 23/05/2008 - allan_lima }
  end;  // with cdFolha

  if (DataSet.RecordCount = 0) then
  begin

    // Limpa da folha atual todos os funcionários já calculados

    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add( 'DELETE FROM F_CENTRAL_FUNCIONARIO');
    pvSQL.Add( 'WHERE IDEMPRESA = :EMPRESA AND IDFOLHA = :FOLHA');
    pvSQL.EndUpdate;

    kExecSQL( pvSQL.Text, [pvEmpresa, pvFolha], not pvStartTransaction);

    // Conta a qtde de situações de funcionario para o tipo da folha
    // Considera apenas os funcionários com situações listadas para o tipo da folha

    iCount := 0;

    if kExistTable('F_FOLHA_TIPO_SITUACAO', not pvStartTransaction) then  { 25/05/2005 - allan_lima }
      iCount := kCountSQL( 'F_FOLHA_TIPO_SITUACAO',
                           'IDFOLHA_TIPO = :TIPO', [pvTipoFolha], not pvStartTransaction);


    if kExistTable('F_FOLHA_FUNCIONARIO', not pvStartTransaction) then
    begin

      pvSQL.BeginUpdate;
      pvSQL.Clear;
      pvSQL.Add('SELECT');
      pvSQL.Add('  F.IDFUNCIONARIO, P.NOME, 1 AS X');
      pvSQL.Add('FROM');
      pvSQL.Add('  F_FOLHA_FUNCIONARIO F, PESSOA P');
      pvSQL.Add('WHERE');
      pvSQL.Add('  F.IDEMPRESA = :E AND F.IDFOLHA = :F');
      pvSQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
      pvSQL.Add('  AND P.IDPESSOA = F.IDFUNCIONARIO');
      pvSQL.EndUpdate;

      kOpenSQL( DataSet, pvSQL.Text, [pvEmpresa, pvFolha], not pvStartTransaction);

    end;

    if (DataSet.RecordCount = 0) then
    begin

      // Seleciona os funcionários para o cálculo

      pvSQL.BeginUpdate;
      pvSQL.Clear;
      pvSQL.Add('SELECT');
      pvSQL.Add('  F.IDFUNCIONARIO, P.NOME, 1 AS X');
      pvSQL.Add('FROM');
      pvSQL.Add('  FUNCIONARIO F, PESSOA P');

      if (pvTipoFolha = 'R') then  { 28/05/2005 - allan_lima }
        pvSQL.Add('  , F_RESCISAO_CONTRATO RC')
      else if (iCount = 0) then
        pvSQL.Add('  , F_SITUACAO S');

      pvSQL.Add('WHERE');
      pvSQL.Add('  F.IDEMPRESA = :EMPRESA');
      pvSQL.Add('  AND F.IDGP = :GP');

      if (pvTipoFolha = 'R') then  // Folha de Rescisao
      begin  { 28/05/2005 - allan_lima }
        pvSQL.Add('  AND RC.IDEMPRESA = F.IDEMPRESA');
        pvSQL.Add('  AND RC.IDFUNCIONARIO = F.IDFUNCIONARIO');
        pvSQL.Add('  AND RC.IDFOLHA = '+IntToStr(pvFolha));
      end else if (iCount = 0) then
      begin  { 07/12/2004 - allan_lima }
        pvSQL.Add('  AND S.IDSITUACAO = F.IDSITUACAO');
        pvSQL.Add('  AND S.CALCULAR_X = 1');
      end else
      begin  { 25/05/2005 - allan_lima }
        pvSQL.Add('  AND F.IDSITUACAO IN');
        pvSQL.Add('    (SELECT S.IDSITUACAO FROM F_FOLHA_TIPO_SITUACAO S');
        pvSQL.Add('     WHERE S.IDFOLHA_TIPO = '+QuotedStr(pvTipoFolha)+')');
      end;

      pvSQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
      pvSQL.Add('  AND P.IDPESSOA = F.IDPESSOA');

      pvSQL.EndUpdate;

      kOpenSQL( DataSet, pvSQL.Text, [pvEmpresa, pvGP], not pvStartTransaction);

    end;

  end;

  if (pvTipoFolha = 'F') then { Férias }
  begin

    // Folha de Férias, obtém informações sobre período e pagamento

    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add('SELECT');
    pvSQL.Add('  F.*, P.* FROM F_FERIAS F, F_PERIODO P');
    pvSQL.Add('WHERE');
    pvSQL.Add('  F.IDEMPRESA = :E AND F.IDFOLHA = :F AND P.IDEMPRESA = F.IDEMPRESA');
    pvSQL.Add('  AND P.IDFUNCIONARIO = F.IDFUNCIONARIO AND P.PERIODO = F.PERIODO');
    pvSQL.Add('ORDER BY');
    pvSQL.Add('  F.IDFUNCIONARIO');
    pvSQL.EndUpdate;

    kOpenSQL( cdFerias, pvSQL.Text, [pvEmpresa, pvFolha], not pvStartTransaction);

    // Seleciona todos os eventos que incidem sobre as ferias

    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add('SELECT');
    pvSQL.Add('  E.*, F.FORMULA AS FORMULA_EVENTO');
    pvSQL.Add('FROM');
    pvSQL.Add('  F_EVENTO E, F_FORMULA F');
    pvSQL.Add('WHERE');
    pvSQL.Add('  E.INC_14_X = 1 AND E.ATIVO_X = 1 AND F.IDFORMULA = E.IDFORMULA');
    pvSQL.EndUpdate;

    kOpenSQL( cdFeriasEvento, pvSQL.Text, not pvStartTransaction);

  end;

  if pvSequenciaCalculo then
  begin
    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add('SELECT');
    pvSQL.Add('  S.*, E.*, E.NOME AS EVENTO,');
    pvSQL.Add('  FS.FORMULA AS FORMULA_SEQUENCIA,');
    pvSQL.Add('  FE.FORMULA AS FORMULA_EVENTO');
    pvSQL.Add('FROM');
    pvSQL.Add('  F_SEQUENCIA S, F_FORMULA FS, F_EVENTO E, F_FORMULA FE');
    pvSQL.Add('WHERE');
    pvSQL.Add('  S.IDGP = :IDGP');
    pvSQL.Add('  AND FS.IDFORMULA = S.IDFORMULA');
    pvSQL.Add('  AND E.IDEVENTO = S.IDEVENTO AND E.ATIVO_X = 1');
    pvSQL.Add('  AND FE.IDFORMULA = E.IDFORMULA');
    pvSQL.Add('ORDER BY');
    pvSQL.Add('  S.SEQUENCIA, S.IDEVENTO');
    pvSQL.EndUpdate;
  end else
  begin
    // Sequência de cálculo independente: Específica para a lista de eventos-padroes
    { 23/05/2008 by allan_lima }
    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add('SELECT');
    pvSQL.Add('  S.*, E.*, E.NOME AS EVENTO,');
    pvSQL.Add('  FE.FORMULA AS FORMULA_EVENTO');
    pvSQL.Add('FROM');
    pvSQL.Add('  F_PADRAO S, F_EVENTO E, F_FORMULA FE');
    pvSQL.Add('WHERE');
    pvSQL.Add('  S.IDGP = :IDGP');
    pvSQL.Add('  AND E.IDEVENTO = S.IDEVENTO AND E.ATIVO_X = 1');
    pvSQL.Add('  AND FE.IDFORMULA = E.IDFORMULA');
    pvSQL.Add('ORDER BY');
    pvSQL.Add('  S.SEQUENCIA, S.IDEVENTO');
    pvSQL.EndUpdate;
  end;

  kOpenSQL( cdSequencia, pvSQL.Text, [pvGP], not pvStartTransaction);

  // Eventos padrao para tipo de folha

  pvSQL.BeginUpdate;
  pvSQL.Clear;
  pvSQL.Add('SELECT * FROM F_PADRAO');
  pvSQL.Add('WHERE IDGP = :IDGP');
  pvSQL.Add('  AND IDFOLHA_TIPO = :IDTIPO_FOLHA');
  pvSQL.Add('  AND '+C_COMPETENCIAS[pvCompetencia]+' = 1');
  pvSQL.Add('ORDER BY');
  pvSQL.Add('  IDEVENTO, IDPADRAO');
  pvSQL.EndUpdate;

  kOpenSQL( cdPadrao, pvSQL.Text, [pvGP, pvTipoFolha], not pvStartTransaction);

  kOpenSQL( cdValorGlobal, 'F_VALOR_FIXO', 'IDEMPRESA = :EMPRESA', [0], not pvStartTransaction);
  kOpenSQL( cdValorLocal,  'F_VALOR_FIXO', 'IDEMPRESA = :EMPRESA', [pvEmpresa], not pvStartTransaction);

  pvSQL.BeginUpdate;
  pvSQL.Clear;
  pvSQL.Add('SELECT T.* FROM F_TABELA_FAIXA T');
  pvSQL.Add('WHERE');
  pvSQL.Add('  T.IDEMPRESA = :IDEMPRESA');
  pvSQL.Add('  AND T.COMPETENCIA =');
  pvSQL.Add('    (SELECT MAX(COMPETENCIA) FROM F_TABELA_FAIXA');
  pvSQL.Add('     WHERE IDEMPRESA = T.IDEMPRESA AND');
  pvSQL.Add('           IDTABELA = T.IDTABELA AND COMPETENCIA <= :DATA)');
  pvSQL.Add('ORDER BY');
  pvSQL.Add('  T.IDTABELA, T.FAIXA');  // DESC edimilson
  pvSQL.EndUpdate;

  kOpenSQL( cdTabelaGlobal, pvSQL.Text, [0, pvFim], not pvStartTransaction);
  kOpenSQL( cdTabelaLocal,  pvSQL.Text, [pvEmpresa, pvFim], not pvStartTransaction);

  { Bug corrigido em 07/06/2005 - allan_lima }

  pvSQL.BeginUpdate;
  pvSQL.Clear;
  pvSQL.Add('SELECT');
  pvSQL.Add('  I.IDTABELA, I.ITEM, I.VALOR');
  pvSQL.Add('FROM');
  pvSQL.Add('  F_TABELA_ITEM I');
  pvSQL.Add('WHERE');
  pvSQL.Add('  I.IDEMPRESA = :IDEMPRESA');
  pvSQL.Add('  AND I.COMPETENCIA =');
  pvSQL.Add('    (SELECT MAX(COMPETENCIA) FROM F_TABELA_ITEM');
  pvSQL.Add('     WHERE IDEMPRESA = I.IDEMPRESA AND');
  pvSQL.Add('           IDTABELA = I.IDTABELA AND COMPETENCIA <= :DATA)');
  pvSQL.Add('ORDER BY');
  pvSQL.Add('  I.IDTABELA, I.ITEM');
  pvSQL.EndUpdate;

  kOpenSQL( cdTabelaGlobalItem, pvSQL.Text, [0, pvFim], not pvStartTransaction);
  kOpenSQL( cdTabelaLocalItem,  pvSQL.Text, [pvEmpresa, pvFim], not pvStartTransaction);

end;  // proc InitDataBase

{ Funcoes de Valores Fixos }

function TkCalculador.ValorLocal( Codigo: Integer): Double;
begin
  if cdValorLocal.Locate( 'IDVFIXO', Codigo, []) then
    Result := cdValorLocal.FieldByName('VALOR').AsCurrency
  else
    raise Exception.CreateFmt('Valor Fixo %d não existe.', [Codigo]);
end;  // function ValorLocal

function TkCalculador.ValorLocal( Nome: String): Double;
begin
  if cdValorLocal.Locate( 'NOME', Nome, []) then
    Result := cdValorLocal.FieldByName('VALOR').AsCurrency
  else
    raise Exception.CreateFmt('Valor Fixo %s não existe.', [Nome]);
end;  // function ValorLocal

function TkCalculador.ValorGlobal( Codigo: Integer): Double;
begin
  if cdValorGlobal.Locate( 'IDVFIXO', Codigo, []) then
    Result := cdValorGlobal.FieldByName('VALOR').AsCurrency
  else
    raise Exception.CreateFmt('Valor Fixo %d não existe.', [Codigo]);
end;  // function ValorGlobal

function TkCalculador.ValorGlobal( Nome: String): Double;
begin
  if cdValorGlobal.Locate( 'NOME', Nome, []) then
    Result := cdValorGlobal.FieldByName('VALOR').AsCurrency
  else
    raise Exception.CreateFmt('Valor Fixo %s não existe.', [Nome]);
end;  // function ValorGlobal

function TkCalculador.ValorGeral( Codigo: Integer): Double;
begin
  if cdValorLocal.Locate( 'IDVFIXO', Codigo, []) then
    Result := cdValorLocal.FieldByName('VALOR').AsCurrency
  else if cdValorGlobal.Locate( 'IDVFIXO', Codigo, []) then
    Result := cdValorGlobal.FieldByName('VALOR').AsCurrency
  else
    raise Exception.CreateFmt('Valor Fixo %d não existe.', [Codigo]);
end;  // function ValorGeral

function TkCalculador.ValorGeral( Nome: String): Double;
begin
  if cdValorLocal.Locate( 'NOME', Nome, []) then
    Result := cdValorLocal.FieldByName('VALOR').AsCurrency
  else if cdValorGlobal.Locate( 'NOME', Nome, []) then
    Result := cdValorGlobal.FieldByName('VALOR').AsCurrency
  else
    raise Exception.CreateFmt('Valor Fixo %s não existe.', [Nome]);
end;  // function ValorGeral

{ Funcoes de Indices }

function TkCalculador.Indices( Empresa, Indice: Integer; Data: TDateTime;
  Erro: Boolean = False): Double;
var
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  if Erro and
     ( kCountSQL( 'F_INDICE',
                  'IDEMPRESA = :EMPRESA AND IDINDICE = :INDICE',
                  [Empresa, Indice], not pvStartTransaction) = 0 ) then
    raise Exception.Create('Índice '+IntToStr(Indice)+' não existe');

  Result   := 0.00;
  SQL      := TStringList.Create;
  DataSet1 := TClientDataSet.Create(NIL);

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT VALOR');
    SQL.Add('FROM F_INDICE_VALOR V');
    SQL.Add('WHERE');
    SQL.Add('  V.IDEMPRESA = :IDEMPRESA');
    SQL.Add('  AND V.IDINDICE = :INDICE');
    SQL.Add('  AND V.COMPETENCIA =');
    SQL.Add('    ( SELECT MAX(I.COMPETENCIA)');
    SQL.Add('      FROM F_INDICE_VALOR I');
    SQL.Add('      WHERE I.IDEMPRESA = V.IDEMPRESA');
    SQL.Add('            AND I.IDINDICE = V.IDINDICE');
    SQL.Add('            AND I.COMPETENCIA <= :DATA )');
    SQL.EndUpdate;

    if kOpenSQL( DataSet1, SQL.Text, [Empresa, Indice, pvFim], not pvStartTransaction) then
      Result := DataSet1.Fields[0].AsCurrency;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end; // function Indices

function TkCalculador.IndiceGeral( Indice: Integer): Double;
begin
  try
    Result := Indices( pvEmpresa, Indice, pvFim, True);
    pvReferencia := Result;
  except
    Result := Indices( 0, Indice, pvFim, True);
    pvReferencia := Result;
  end;
end;  // function IndiceLocal

function TkCalculador.IndiceLocal( Indice: Integer): Double;
begin
  Result := Indices( pvEmpresa, Indice, pvFim, True);
  pvReferencia := Result;
end;  // function IndiceLocal

function TkCalculador.IndiceGlobal( Indice: Integer): Double;
begin
  Result := Indices( 0, Indice, pvFim, True);
  pvReferencia := Result;
end;  // function IndiceGlobal

{ Funcoes de Tabelas }

function TkCalculador.TabelaLocal( Tabela: Integer; Valor: Double): Double;
var
  bFound: Boolean;
  cDeduzir, cAcrescentar: Currency;
begin

  Result := 0.0;
  bFound := False;

  with cdTabelaLocal do
  begin
    First;
    while (not Eof) do
    begin
      if (Tabela = FieldByName('IDTABELA').AsInteger) then
      begin
        bFound := True;
        if (Valor < FieldByName('FAIXA').AsCurrency) then
        begin
          pvTaxa       := FieldByName('TAXA').AsCurrency;
          cDeduzir     := FieldByName('REDUZIR').AsCurrency;
          cAcrescentar := FieldByName('ACRESCENTAR').AsCurrency;
          Result       := (Valor*pvTaxa*0.01) + cAcrescentar - cDeduzir;
          pvReferencia := IfThen( pvTaxa = 0.0, cAcrescentar-cDeduzir, pvTaxa);
          Break;
        end;
      end;
      Next;
    end;
  end;

  if not bFound then
    raise Exception.CreateFmt( 'Tabela Local %d não existe.', [Tabela]);

end;  // function TabelaLocal

function TkCalculador.TabelaLocalItem( Tabela, Item: Integer): Double;
var
  bFound: Boolean;
begin

  Result := 0.0;
  bFound := False;

  with cdTabelaLocalItem do
  begin
    First;
    while (not Eof) do
    begin
      if (Tabela = FieldByName('IDTABELA').AsInteger) and
         (Item = FieldByName('ITEM').AsInteger) then
      begin
        Result := FieldByName('VALOR').AsCurrency;
        bFound := True;
        Break;
      end;
      Next;
    end;
  end;  // with cdTabelaLocalItem

  if not bFound then
      raise Exception.CreateFmt( 'Item %d da Tabela Local %d não existe.',
                                 [Item, Tabela]);

end;  // function TabelaLocalItem

// Tabela Global - Pesquisa na tabela o valor da Faixa
function TkCalculador.TabelaGlobal( Tabela: Integer; Valor: Double): Double;
var
  bFound: Boolean;
  cDeduzir, cAcrescentar: Currency;
begin

  Result := 0.0;
  bFound := False;

  with cdTabelaGlobal do
  begin
    First;
    while (not Eof) do
    begin
      if (Tabela = FieldByName('IDTABELA').AsInteger) then
      begin
        bFound := True;
        if (Valor < FieldByName('FAIXA').AsCurrency) then
        begin
          pvTaxa       := FieldByName('TAXA').AsCurrency;
          cDeduzir     := FieldByName('REDUZIR').AsCurrency;
          cAcrescentar := FieldByName('ACRESCENTAR').AsCurrency;
          Result       := (Valor*pvTaxa*0.01) + cAcrescentar - cDeduzir;
          pvReferencia := IfThen( pvTaxa = 0.0, cAcrescentar-cDeduzir, pvTaxa);
          Break;
        end;
      end;
      Next;
    end;
  end;

  if not bFound then
    raise Exception.Create( 'Tabela Global '+IntToStr(Tabela)+' não existe.');

end;  // function TabelaGlobal;

function TkCalculador.TabelaGeralItem( Tabela, Item: Integer): Double;
begin

  try
    Result := TabelaLocalItem( Tabela, Item);
  except
    try
      Result := TabelaGlobalItem( Tabela, Item);
    except
      raise Exception.CreateFmt( 'Item %d da Tabela de Cálculo %d não existe.',
                                 [Item, Tabela]);
    end;
  end;

end;  // function TabelaGeralItem

// Tabela Geral - Pesquisa na tabela o valor da Faixa
function TkCalculador.TabelaGeral( Tabela: Integer; Valor: Double): Double;
begin

  try
    Result := TabelaLocal( Tabela, Valor);
  except
    try
      Result := TabelaGlobal( Tabela, Valor);
    except
      raise Exception.CreateFmt( 'Tabela de Cálculo %d não existe.', [Tabela]);
    end;
  end;

end;  // function TabelaGeral;

function TkCalculador.TabelaGlobalItem( Tabela, Item: Integer): Double;
var
  bFound: Boolean;
begin

  Result := 0.0;
  bFound := False;

  with cdTabelaGlobalItem do
  begin
    First;
    while (not Eof) do
    begin
      if (Tabela = FieldByName('IDTABELA').AsInteger) and
         (Item = FieldByName('ITEM').AsInteger) then
      begin
        Result := FieldByName('VALOR').AsCurrency;
        bFound := True;
        Break;
      end;
      Next;
    end;
  end;   // with cdTabelaGlobalItem

  if not bFound then
    raise Exception.CreateFmt( 'O item %d da Tabela Global %d não existe.',
                               [Item, Tabela]);

end;  // function TabelaGeralItem

// Evento - Retorna o valor de determinado campo de um evento em deteminada folha
function TkCalculador.Evento( Codigo: Integer; Folha: Integer; Campo: String = 'CALCULADO'): Double;
var
  cdLocal: TClientDataSet;
  SQL: TStringList;
begin

  Result := 0.0;

  if (Folha = 0) then // verifica na folha atual (em calculo)
  begin
    if cdCentral.Locate( 'IDEVENTO', Codigo, []) then
    begin
      Result := cdCentral.FieldByName(Campo).AsCurrency;
      if (Campo = 'CALCULADO') and (cdCentral.FieldByName('LIQUIDO').AsInteger = 0) then
       pvTotalizado := pvTotalizado + Result;
    end;
    Exit;
  end;

  cdLocal := TClientDataSet.Create(nil);
  SQL     := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT '+Campo+', LIQUIDO FROM F_CENTRAL');
    SQL.Add('WHERE IDEMPRESA = :IDEMPRESA');
    SQL.Add('  AND IDFOLHA = :IDFOLHA');
    SQL.Add('  AND IDFUNCIONARIO = :IDFUNCIONARIO');
    SQL.Add('  AND IDEVENTO = :IDEVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( cdLocal, SQL.Text,
                     [pvEmpresa, Folha, pvFuncionario, pvEvento], not pvStartTransaction) then
      raise Exception.Create(kGetErrorLastSQL);

    if (cdLocal.RecordCount > 0) then
    begin
      Result := cdLocal.Fields[0].AsCurrency;
      if (Campo = 'CALCULADO') and (cdCentral.Fields[1].AsInteger = 0) then
        pvTotalizado := pvTotalizado + Result;
    end;

  finally
    cdLocal.Free;
    SQL.Free;
  end;

end; // function Evento

// Evento - Retorna o valor de determinado campo de um evento em deteminada folha
function TkCalculador.Evento( Codigo: Integer; Campo: String = 'CALCULADO'): Double;
begin
  Result := Evento( Codigo, 0, Campo);
end;

function TkCalculador.ValorMaximoEvento: Double;
begin
  Result := cdSequencia.FieldByName('VALOR_MAXIMO').AsCurrency;
end;

function TkCalculador.ValorMinimoEvento: Double;
begin
  Result := cdSequencia.FieldByName('VALOR_MINIMO').AsCurrency;
end;

{ ContraPartida - Contra Partida
  Retorna o total de valores calculados de uma Evento
  das folhas anexas a folha atual }
function TkCalculador.ContraPartida( Evento: Integer): Double;
var
  DataSet: TClientDataSet;
  SQL: TStringList;
begin

  Result  := 0.00;
  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT SUM(CALCULADO) FROM  F_CENTRAL');
    SQL.Add('WHERE IDEMPRESA = :IDEMPRESA');
    SQL.Add('  AND IDFOLHA IN (');
    SQL.Add('        SELECT IDFOLHA_CP FROM F_FOLHA_CP');
    SQL.Add('        WHERE IDEMPRESA = F_CENTRAL.IDEMPRESA AND IDFOLHA = :IDFOLHA)');
    SQL.Add('  AND IDFUNCIONARIO = :IDFUNCIONARIO  AND IDEVENTO = :IDEVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text,
                     [ pvEmpresa, pvFolha, pvFuncionario, Evento], not pvStartTransaction) then
      raise Exception.Create(kGetErrorLastSQL);

    Result := DataSet.Fields[0].AsCurrency;

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;

function TkCalculador.ContraPartida( Evento: String): Double;
begin
  Result := ContraPartida(StrToInt(Evento));
end;

{ Dados do Funcionario }

{ TempoServico - Retorna em meses o tempo de servico }
function TkCalculador.TempoServico():Integer;
begin
  Result := DiffMonths( pvAdmissao, pvFim);
  {$IFDEF DEBUG}
  ShowMessage( 'Tempo de servico = '+IntToStr(Result)+' mes(es)');
  {$ENDIF}
end;

function TkCalculador.DependenteGeral( const Tipo: String = '';
  const Sexo: String = ''; const Invalido: String = ''): Integer;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT COUNT(*) FROM F_DEPENDENTE');
    SQL.Add('WHERE');
    SQL.Add('  IDEMPRESA = :EMPRESA AND IDFUNCIONARIO = :FUNCIONARIO');
    if (Tipo <> EmptyStr) then
      SQL.Add('AND TIPO LIKE '+QuotedStr('%'+UpperCase(Tipo)+'%'));
    if (Sexo <> EmptyStr) and (Sexo[1] in ['m','f','M','F']) then
      SQL.Add('AND SEXO = '+QuotedStr(UpperCase(Sexo)));
    if (Invalido <> EmptyStr) and (Invalido[1] in ['I','i']) then
      SQL.Add('AND INVALIDO_X = 1');
    SQL.EndUpdate;

    Result := kCountSQL( SQL.Text, [pvEmpresa, pvFuncionario], not pvStartTransaction);

  finally
    SQL.Free;
  end;

end;  // function DependenteGeral

function TkCalculador.Dependente( const Tipo: String = '';
  const Sexo: String = ''; const Invalido: String = ''): Integer;
var
  iLimite: Integer;
  dNasc: TDateTime;
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  Result  := 0;
  iLimite := 0;

  if (Tipo <> EmptyStr) then
  begin

    if Length(Tipo) > 1 then
      raise Exception.Create('Tipo de dependente inválido - "'+Tipo+'".');

    if not cdDependenteTipo.Locate( 'IDTIPO', UpperCase(Tipo), []) then
      Exit;

    iLimite := cdDependenteTipo.FieldByName('LIMITE_ANO').AsInteger;

  end;

  SQL      := TStringList.Create;
  DataSet1 := TClientDataSet.Create(NIL);

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT * FROM F_DEPENDENTE');
    SQL.Add('WHERE');
    SQL.Add('  IDEMPRESA = :EMPRESA AND IDFUNCIONARIO = :FUNCIONARIO');
    if (Tipo <> EmptyStr) then
      SQL.Add('AND TIPO LIKE '+QuotedStr('%'+UpperCase(Tipo)+'%'));
    if (Sexo <> EmptyStr) and (Sexo[1] in ['m','f','M','F']) then
      SQL.Add('AND SEXO = '+QuotedStr(UpperCase(Sexo)));
    if (Invalido <> EmptyStr) and (Invalido[1] in ['I','i']) then
      SQL.Add('AND INVALIDO_X = 1');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text, [pvEmpresa, pvFuncionario], not pvStartTransaction) then
      Exit;

    if (Tipo = EmptyStr) then
      Result := DataSet1.RecordCount
    else begin
      DataSet1.First;
      while not DataSet1.Eof do
      begin
        dNasc := DataSet1.FieldByName('NASCIMENTO').AsDateTime;
        if (DataSet1.FieldByName('INVALIDO_X').AsInteger = 1) or
          (kIdade( dNasc, pvFim) <= iLimite) then
          Inc(Result);
        DataSet1.Next;
      end;
    end;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;  // function Dependente

// TempoNascimento - Retorna em meses a idade do funcionario
function TkCalculador.TempoNascimento():Integer;
begin

  { Bug: Quanto a data de nascimento está vazia o tempo de nascimento retornado é muito grande }
  { Bug reportado por Edimilson [edivaires@yahoo.com.br]
    em 19-10-2005 na mensagem 759 - br.groups.yahoo.com/groups/folha_livre }
  { Bug eliminado por Allan [allan_kardek@yahoo.com.br] em 21-10-2005 }

  Result := 0;

  if not cdFuncionario.FieldByName('NASCIMENTO').IsNull then
    Result := DiffMonths( cdFuncionario.FieldByName('NASCIMENTO').AsDateTime, pvFim);

end;


function TkCalculador.Proporcional( Valor: Double):Double;
var
  iHorasFalta: Integer;
begin

  if (pvDiasInativo < 1) then
    Result := Valor
  else if (pvEventoEntrada = 'D') or (pvCargaHoraria = 0) then
    Result := (Valor/30)*(30-pvDiasInativo)
  else begin
    iHorasFalta := Trunc((pvDiasInativo*(pvCargaHoraria/30)));
    Result := (Valor/pvCargaHoraria)*(pvCargaHoraria-iHorasFalta);
  end;

end;

function TkCalculador.Proporcional( Valor: Integer):Integer;
begin
  Result := Trunc( Proporcional( StrToFloat( IntToStr( Valor))));
end;  // function Proporcional

procedure TkCalculador.AtualizaIncidencia( const Valor: Double);
var
  sTipoEvento, sCampo: String;
  cTotal: Currency;
begin

  sTipoEvento := cdSequencia.FieldByName('TIPO_EVENTO').AsString;

  if (Valor = 0.0) or (sTipoEvento = 'B') then
    Exit;

  with cdIncidencias do
  begin
    First;
    while not Eof do
    begin
      sCampo := 'INC_'+kStrZero( StrToInt(Fields[0].AsString), 2)+'_X';
      cTotal := FieldByName('TOTAL').AsCurrency;
      if Assigned( cdSequencia.FindField(sCampo)) and
        (cdSequencia.FieldByName(sCampo).AsInteger = 1) then
      begin
        Edit;
        if (sTipoEvento = 'P') then
          FieldByName('TOTAL').AsCurrency := cTotal + Valor
        else if (sTipoEvento = 'D') then
          FieldByName('TOTAL').AsCurrency := cTotal - Valor;
        Post;
      end;
      Next;
    end; // while not Eof do
  end;  // with cdIncidencias

end; // proc AtualizaIncidencia

// Total de incidencia

function TkCalculador.TotalIncidencia( Incidencia: Integer ): Double;
begin
  Result := 0.0;
  if cdIncidencias.Locate( 'IDINCIDENCIA', Incidencia, []) then
  begin
    Result := cdIncidencias.FieldByName('TOTAL').AsCurrency;
    pvTotalizado := pvTotalizado + Result;
  end;
  {$IFDEF DEBUG}
  ShowMessage('O total de incidencia ('+IntToStr(Incidencia)+') = '+CurrToStr(Result));
  {$ENDIF}
end;  // func TI

function TkCalculador.TotalIncidencia( Incidencia: String ): Double;
begin
  Result := TotalIncidencia( StrToInt(Incidencia));
end;

function TkCalculador.TotalIncidenciaNome( Nome: String): Double;
var
  iIncidencia: Integer;
begin
  Result := 0.0;
  if cdIncidencias.Locate( 'NOME', Nome, []) then
  begin
    iIncidencia := cdIncidencias.Fields[0].AsInteger;
    Result      := TotalIncidencia(iIncidencia);
  end;
end;

function TkCalculador.Delete:Boolean;
begin

  pvSQL.BeginUpdate;
  pvSQL.Clear;
  pvSQL.Add('DELETE FROM F_CENTRAL_FUNCIONARIO');
  pvSQL.Add('WHERE IDEMPRESA = :IDEMPRESA');
  pvSQL.Add('  AND IDFOLHA = :IDFOLHA');
  pvSQL.Add('  AND IDFUNCIONARIO = :IDFUNCIONARIO');
  pvSQL.EndUpdate;

  // Bug fix: [1674913] Transaction is not active
  Result := kExecSQL( pvSQL.Text, [pvEmpresa, pvFolha, pvFuncionario], not pvStartTransaction);

  if not Result then
    raise Exception.Create(kGetErrorLastSQL);

end;

procedure TkCalculador.Commit;
var
  i: Integer;
begin

  // Incluir Informacoes sobre o Funcionario no momento do Calculo

  with cdCentralFunc do
  begin

    Close;
    CreateDataSet;
    Append;

    for i := 0 to FieldCount-1 do
      if Assigned(cdFuncionario.FindField(Fields[i].FieldName)) then
        Fields[i].Value := cdFuncionario.FieldByName(Fields[i].FieldName).Value;

    if Assigned(FindField('IDEMPRESA')) then
      FieldByName('IDEMPRESA').AsInteger := pvEmpresa;
    if Assigned(FindField('IDFOLHA')) then
      FieldByName('IDFOLHA').AsInteger := pvFolha;

    Post;

    if not kSQLInsert( cdCentralFunc, 'F_CENTRAL_FUNCIONARIO', Fields, not pvStartTransaction) then
      raise Exception.Create(kGetErrorLastSQL);

  end;

  // Incluir os Eventos Calculados para o Funcionario
  kSQLInsertDataSet( cdCentral, 'F_CENTRAL', not pvStartTransaction);

end;  // procedure Commit

destructor TkCalculador.Destroy;
begin

  FExpression.Free;

  {$IFNDEF DEBUG}
  FProgresso.Free;
  {$ENDIF}

  cdCentral.Free;
  cdCentralFunc.Free;
  cdIncidencias.Free;

  cdDependenteTipo.Free;
  cdFolha.Free;
  cdPadrao.Free;
  cdSequencia.Free;

  cdValorLocal.Free;
  cdValorGlobal.Free;

  cdTabelaLocal.Free;
  cdTabelaLocalItem.Free;
  cdTabelaGlobal.Free;
  cdTabelaGlobalItem.Free;

  cdInformado.Free;
  cdAutomatico.Free;
  cdProgramado.Free;

  cdFuncionario.Free;

  cdRescisao.Free;        { 28/05/2005 - allan_lima }
  cdRescisaoEvento.Free;  { 28/05/2005 - allan_lima }

  cdFeriasEvento.Free;    { 14/03/2008 - allan_lima }
  cdFerias.Free;          { 14/03/2008 - allan_lima }

  pvSQL.Free;

  pvPadraoFGTS.Free;
  pvPadraoTipo.Free;
  pvPadraoSituacao.Free;
  pvPadraoVinculo.Free;
  pvPadraoSalario.Free;

  inherited;

end;

function TkCalculador.doCalculate: Boolean;
var
  i, iContraPartida, iComplementar: Integer;
  sFormula, sFormulaPadrao, sFormulaSequencia, sFormulaEvento, sFormulaLocal,
  sTipoEvento, sTipoCalculo: String;
  cCalculado, cMinimo, cMaximo: Currency;
  bAssumeValor, bTestarMinimoMaximo, bProporcional, bCalcular: Boolean;
begin

   Result := True;

   pvBase     := 0.0;
   pvDesconto := 0.0;
   pvProvento := 0.0;

   cdCentral.Close;
   cdCentral.CreateDataSet;

   // Ao iniciar o calculo para o funcionario zerar os totalizadores
   with cdIncidencias do
   begin
     First;
     while not Eof do
     begin
       Edit;
       FieldByName('TOTAL').AsCurrency := 0.0;
       Post;
       Next;
     end;
   end;

   // Apaga as informações do funcionário de cálculos anteriores
   Delete();

   // Carrega informações do funcionário

   pvSQL.BeginUpdate;
   pvSQL.Clear;
   pvSQL.Add('SELECT');
   pvSQL.Add('  F.*, P.*');
   pvSQL.Add('FROM');
   pvSQL.Add('  FUNCIONARIO F, PESSOA P');
   pvSQL.Add('WHERE');
   pvSQL.Add('  F.IDEMPRESA = :IDEMPRESA');
   pvSQL.Add('  AND F.IDFUNCIONARIO = :IDFUNCIONARIO');
   pvSQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
   pvSQL.Add('  AND P.IDPESSOA = F.IDPESSOA');
   pvSQL.EndUpdate;

   kOpenSQL( cdFuncionario, pvSQL.Text, [pvEmpresa, pvFuncionario], not pvStartTransaction);

   pvCargaHoraria := cdFuncionario.FieldByName('CARGA_HORARIA').AsInteger;
   pvTipoFunc     := cdFuncionario.FieldByName('IDTIPO').AsString;
   pvSituacaoFunc := cdFuncionario.FieldByName('IDSITUACAO').AsString;
   pvVinculoFunc  := cdFuncionario.FieldByName('IDVINCULO').AsString;
   pvTipoSalario  := cdFuncionario.FieldByName('IDSALARIO').AsString;
   pvAdmissao     := cdFuncionario.FieldByName('ADMISSAO').AsDateTime;
   pvDemissao     := cdFuncionario.FieldByName('DEMISSAO').AsDateTime;
   pvSindicato    := cdFuncionario.FieldByName('IDSINDICATO').AsInteger;
   pvFGTSFunc     := cdFuncionario.FieldByName('IDFGTS').AsString;

   // Carrega informações sobre a rescisão do funcionario

   if (pvTipoFolha = 'R') then  { 28/05/2005 - allan_lima }
   begin

     pvSQL.BeginUpdate;
     pvSQL.Clear;
     pvSQL.Add('SELECT * FROM F_RESCISAO_CONTRATO');
     pvSQL.Add('WHERE IDEMPRESA = :EMPRESA');
     pvSQL.Add('  AND IDFUNCIONARIO = :FUNCIONARIO');
     pvSQL.Add('  AND IDFOLHA = :FOLHA');
     pvSQL.EndUpdate;

     kOpenSQL( cdRescisao, pvSQL.Text, [pvEmpresa, pvFuncionario, pvFolha], pvStartTransaction);

     pvCausaRescisao := cdRescisao.FieldByName('IDRESCISAO').AsString;

     pvSQL.BeginUpdate;
     pvSQL.Clear;
     pvSQL.Add('SELECT R.*, F.FORMULA');
     pvSQL.Add('FROM F_RESCISAO_EVENTO R');
     pvSQL.Add('LEFT JOIN F_FORMULA F ON (R.IDFORMULA = F.IDFORMULA)');
     pvSQL.Add('WHERE R.IDGP = :GP AND R.IDRESCISAO = :RESCISAO');
     pvSQL.EndUpdate;

     kOpenSQL( cdRescisaoEvento, pvSQL.Text, [pvGP, pvCausaRescisao], not pvStartTransaction);

   end else
     pvCausaRescisao := EmptyStr;

   // Lancamentos manuais efetuados para a folha do funcionario
   pvSQL.BeginUpdate;
   pvSQL.Clear;
   pvSQL.Add('SELECT IDEVENTO, INFORMADO FROM F_INFORMADO');
   pvSQL.Add('WHERE  IDEMPRESA = :IDEMPRESA AND IDFOLHA = :IDFOLHA');
   pvSQL.Add('       AND IDFUNCIONARIO = :IDFUNCIONARIO');
   pvSQL.EndUpdate;

   // Bug fix: [1674913] Transaction is not active
   kOpenSQL( cdInformado, pvSQL.Text, [pvEmpresa, pvFolha, pvFuncionario], not pvStartTransaction);

   // Lancamentos automáticos efetuados para funcionario
   pvSQL.BeginUpdate;
   pvSQL.Clear;
   pvSQL.Add('SELECT IDEVENTO, INFORMADO');
   pvSQL.Add('FROM   F_AUTOMATICO');
   pvSQL.Add('WHERE  IDEMPRESA = :EMPRESA');
   pvSQL.Add('   AND IDFUNCIONARIO = :IDFUNCIONARIO');
   pvSQL.Add('   AND IDFOLHA_TIPO = :IDTIPO_FOLHA');
   pvSQL.Add('   AND '+C_COMPETENCIAS[pvCompetencia]+' = 1');
   pvSQL.EndUpdate;

   // Bug fix: [1674913] Transaction is not active
   kOpenSQL( cdAutomatico, pvSQL.Text, [pvEmpresa, pvFuncionario, pvTipoFolha], not pvStartTransaction);

   // Lancamentos programados para funcionario
   pvSQL.BeginUpdate;
   pvSQL.Clear;
   pvSQL.Add('SELECT IDEVENTO, INFORMADO FROM F_PROGRAMADO');
   pvSQL.Add('WHERE  IDEMPRESA = :EMPRESA');
   pvSQL.Add('   AND IDFUNCIONARIO = :IDFUNCIONARIO');
   pvSQL.Add('   AND IDFOLHA_TIPO = :IDTIPO_FOLHA');
   pvSQL.Add('   AND SUSPENSO_X = 0');
   pvSQL.Add('   AND INICIO <= :INICIO AND TERMINO >= :FIM');  // Bug fix: 1805573
   pvSQL.EndUpdate;

   kOpenSQL( cdProgramado, pvSQL.Text,
             [pvEmpresa, pvFuncionario, pvTipoFolha, pvInicio, pvFim], not pvStartTransaction);

   NumeroDiasInativos();

   if (pvDiasInativo = 30) then
     Exit;

   // Percorre cdSequencia para que o calculo obedeca a sequencia de calculo

   with cdSequencia do
   begin

     First;

     while not EOF do
     begin

       pvTaxa       := 0.0;
       pvInformado  := 0.0;
       pvReferencia := 0.0;
       pvTotalizado := 0.0;
       cCalculado   := 0.0;

       pvEvento          := FieldByName('IDEVENTO').AsInteger;
       pvEventoNome      := FieldByName('EVENTO').AsString;
       sTipoEvento       := FieldByName('TIPO_EVENTO').AsString ;
       sTipoCalculo      := FieldByName('TIPO_CALCULO').AsString ;
       iContraPartida    := FieldByName('CONTRA_PARTIDA').AsInteger;
       pvEventoEntrada   := FieldByName('VALOR_HORA').AsString;

       sFormulaPadrao    := EmptyStr;
       sFormulaSequencia := EmptyStr;

       if Assigned(FindField('FORMULA_SEQUENCIA')) then
         sFormulaSequencia := FieldByName('FORMULA_SEQUENCIA').AsString;

       sFormulaEvento    := FieldByName('FORMULA_EVENTO').AsString;
       sFormulaLocal     := FieldByName('FORMULA_LOCAL').AsString;

       bAssumeValor      := (FieldByName('ASSUME_X').AsInteger = 1);
       pvMultiplicador   := FieldByName('MULTIPLICADOR').AsCurrency;
       bProporcional     := (FieldByName('PROPORCIONAL_X').AsInteger = 1);

       if Assigned(FindField('COMPLEMENTAR')) then { 10/07/2005 - allan_lima }
         iComplementar := FieldByName('COMPLEMENTAR').AsInteger
       else
         iComplementar := C_EV_COMPLEMENTAR;

       bCalcular := True; // O evento é normalmente calculado { 10/07/2005 - allan_lima }

       if pvFolhaComplementar and (iComplementar = C_EV_NAO_CALCULAR) then
         bCalcular := False; { 10/07/2005 - allan_lima }

       if bCalcular and PesquisaValorInformado(sFormulaPadrao) then
       begin

         // Nesse momento avalia e retorna o valor calculado para a formula

         try

           bTestarMinimoMaximo := False;
           FExpression.Text := EmptyStr;

           if (sFormulaPadrao <> EmptyStr) then
           begin
             // A formula padrao tem prioridade sobre todas as outras informacoes do evento
             sFormula         := sFormulaPadrao;
             FExpression.Text := sFormula;
             cCalculado       := FExpression.AsDouble;

           end else if (sFormulaSequencia <> EmptyStr) then
           begin
             // A formula definida na sequencia tem prioridade sobre todas
             // as outras informacoes do evento
             sFormula         := sFormulaSequencia;
             FExpression.Text := sFormula;
             cCalculado       := FExpression.AsDouble;

           end else if bAssumeValor and (pvInformado > 0.0) then
             // SE ASSUME_X estiver ativado, considera o valor informado
             // desprezando outras configuracoes
             cCalculado := pvInformado

           else if (sTipoCalculo = 'C') then // Contra Partida
             cCalculado := ContraPartida(iContraPartida)

           else if (sTipoCalculo = 'D') then // Dia Trabalhado
           begin

             pvReferencia := (SalarioMensal / 30);  // Valor do Dia trabalhado
             if (pvEventoEntrada = 'H') then
               pvInformado := pvInformado / (pvCargaHoraria/30);
             cCalculado  := pvInformado * pvReferencia;
             bTestarMinimoMaximo := True;

           end else if (sTipoCalculo = 'H') then // Hora Trabalhada
           begin

             pvReferencia := HoraNormal() * pvMultiplicador;
             if (pvEventoEntrada = 'D') then
               pvInformado :=  pvInformado * (pvCargaHoraria/30);
             cCalculado := pvInformado * pvReferencia;
             bTestarMinimoMaximo := True;

           end else if (sTipoCalculo = 'I') then // Valor Informado
             cCalculado := pvInformado

           else if (sTipoCalculo = 'F') then  // Formula
           begin

             if (sFormulaEvento <> EmptyStr) then
               FExpression.Text := sFormulaEvento
             else if (sFormulaLocal <> EmptyStr) then
               FExpression.Text := sFormulaLocal;

             if (FExpression.Text <> EmptyStr) then
             begin
               sFormula   := FExpression.Text;
               cCalculado := FExpression.AsDouble;
             end;

             bTestarMinimoMaximo := True;

           end;

           if bProporcional and (cCalculado > 0.0) then
             cCalculado := Proporcional(cCalculado);

           if bTestarMinimoMaximo and (cCalculado > 0.0) then
           begin

             cMinimo := ValorMinimoEvento();
             cMaximo := ValorMaximoEvento();

             if (cMinimo = 0.0) then cMinimo := 0.01;
             if (cMaximo = 0.0) then cMaximo := MaxCurrency;

             if cCalculado < cMinimo then
               cCalculado := 0.0 {cMinimo} { 07/06/2005 - allan_lima}
             else if cCalculado > cMaximo then
               cCalculado := cMaximo;

           end;

           // Realiza o arrendondamento do valor calculado para duas casas decimais
           cCalculado := Math.RoundTo( cCalculado, -2);

           if pvFolhaComplementar and  { 19/06/2005 - allan_lima }
              (iComplementar = C_EV_COMPLEMENTAR) then { 10/07/2005 - allan_lima }
             cCalculado := cCalculado - ValorBase(pvEvento);

           if (cCalculado > 0.0) then  // Realiza a gravação do evento
           begin

             cdCentral.Append;

             for i := 0 to Fields.Count-1 do
               if Assigned( cdCentral.FindField(Fields[i].FieldName)) then
                 cdCentral.FieldByName( Fields[i].FieldName).Value := Fields[i].Value;

             cdCentral.FieldByName('IDEMPRESA').AsInteger     := pvEmpresa;
             cdCentral.FieldByName('IDFOLHA').AsInteger       := pvFolha;
             cdCentral.FieldByName('IDFUNCIONARIO').AsInteger := pvFuncionario;
             cdCentral.FieldByName('IDEVENTO').AsInteger      := pvEvento;
             cdCentral.FieldByName('MES_ANO').AsString        := pvMesAno;
             cdCentral.FieldByName('INFORMADO').AsCurrency    := pvInformado;
             cdCentral.FieldByName('REFERENCIA').AsCurrency   := pvReferencia;
             cdCentral.FieldByName('CALCULADO').AsCurrency    := cCalculado;
             cdCentral.FieldByName('TOTALIZADO').AsCurrency   := pvTotalizado;
             cdCentral.Post;

             if (sTipoEvento = 'B') then
               pvBase := pvBase + cCalculado
             else if (sTipoEvento = 'D') then
               pvDesconto := pvDesconto + cCalculado
             else if (sTipoEvento = 'P') then
               pvProvento := pvProvento + cCalculado;

             AtualizaIncidencia( cCalculado);

           end;

         except
           on E:Exception do
           begin
             Result := False;
             kErro('Erro na execução da fórmula' + sLineBreak + sLineBreak +
                   'Evento: ' + IntToStr(pvEvento) + sLineBreak+ sLineBreak +
                   'Formula' + sLineBreak + sLineBreak +
                   sFormula + sLineBreak + sLineBreak + E.Message);
             Exit;
           end;  // on E:Exception
         end; // try - except

       end;  // if bCalcular

       Next;

     end;  // while not cdSequencia.EOF do

   end; // with cdSequencia do

   // Grava todos os eventos calculados para o funcionario em F_CENTRAL
   Commit();

end;

// HoraNormal - Retorna o valor da hora normal do funcionario
function TkCalculador.HoraNormal():Double;
begin
  if (cdFuncionario.FieldByName('IDSALARIO').AsString = '05') then
    Result := cdFuncionario.FieldByName('SALARIO').AsCurrency
  else
    Result := SalarioNormal()/pvCargaHoraria;
end; // HoraNormal

function TkCalculador.SalarioNormal():Double;
var
  sTipoSalario: String;
  cSalario: Currency;
  iCargaHoraria: Integer;
begin

  { Bug fix: 1672060; Open Date: 01/03/2007; Close Date: 01/03/2007; Close Developer: allan_lima }

  cSalario := cdFuncionario.FieldByName('SALARIO').AsCurrency;
  sTipoSalario := cdFuncionario.FieldByName('IDSALARIO').AsString;
  iCargaHoraria := cdFuncionario.FieldByName('CARGA_HORARIA').AsInteger;

  if (sTipoSalario = '02') then  // Quizenalista
    cSalario := cSalario * 2.0

  else if (sTipoSalario = '03') then  // Semanalista
    cSalario := (cSalario / 7.0) * 30.0

  else if (sTipoSalario = '04') then // Diarista
    cSalario := cSalario * 30.0

  else if (sTipoSalario = '05') then // Horista
    cSalario := cSalario * iCargaHoraria;

  Result := RoundTo( cSalario, -2);

end;   // SalarioNormal

function TkCalculador.SalarioMensal():Double;
var
  sTipoSalario: String;
  cSalario: Currency;
  iCargaHoraria: Integer;
begin

  { Bug fix: 1672060; Open Date: 01/03/2007;
    Close Date: 01/03/2007; Close Developer: allan_lima }

  cSalario := cdFuncionario.FieldByName('SALARIO').AsCurrency;
  sTipoSalario := cdFuncionario.FieldByName('IDSALARIO').AsString;
  iCargaHoraria := cdFuncionario.FieldByName('CARGA_HORARIA').AsInteger;

  if (sTipoSalario = '01') then  // Mensalista
  begin

    pvReferencia := (cSalario / 30.0);

    if (pvInformado = 0.0) then
      pvInformado := 30.0
    else
      cSalario := pvReferencia * pvInformado;

  end else if (sTipoSalario = '02') then  // Quizenalista
  begin

    if (pvInformado = 0.0) then
      pvInformado := 30.0;

    pvReferencia := (cSalario * 2) / 30.0;
    cSalario := pvReferencia * pvInformado;

  end else if (sTipoSalario = '03') then  // Semanalista
  begin

    if (pvInformado = 0.0) then
      pvInformado := 30.0;

    pvReferencia := (cSalario / 7.0);
    cSalario := pvReferencia * pvInformado;

  end else if (sTipoSalario = '04') then // Diarista
  begin

    if (pvInformado = 0.0) then
      pvInformado := 30.0;

    pvReferencia := cSalario;
    cSalario := pvReferencia * pvInformado;

  end else if (sTipoSalario = '05') then // Horista
  begin

    if (pvInformado = 0.0) then
      pvInformado := iCargaHoraria;

    pvReferencia := cSalario;
    cSalario := pvReferencia * pvInformado;

  end;

  Result := RoundTo( cSalario, -2);

end;  // SalarioMensal

function TkCalculador.PesquisaValorInformado( var Formula: String):Boolean;
var
  s: String;
  iMesDireito, iPadrao: Integer;

  function PesquisaFiltro( const Filtro: String; Padrao: Integer):String;
  var
    sFieldName, sTableName: String;
    DataSet1: TClientDataSet;
  begin

    Result := '_';
    sFieldName := 'ID'+Filtro;
    sTableName := 'F_PADRAO_'+Filtro;

    DataSet1 := TClientDataSet.Create(NIL);

    try

      if not kOpenSQL( DataSet1,
                       'SELECT '+sFieldName+' FROM '+sTableName+sLineBreak+
                       'WHERE IDGP = :G AND IDPADRAO = :P',
                       [pvGP, Padrao], not pvStartTransaction) then
        raise Exception.Create(kGetErrorLastSQL);

      DataSet1.First;

      while not DataSet1.Eof do
      begin
        Result := Result + DataSet1.Fields[0].AsString + '_';
        DataSet1.Next;
      end;

    finally
      DataSet1.Free;

    end;  // try

  end;  // PesquisaFiltro

begin

  Result := False;

  if (pvTipoFolha = 'R') then // Folha de Rescisao
  begin  { 29/05/2005 - allan_lima }

    Result := cdRescisaoEvento.Locate( 'IDSINDICATO;IDEVENTO',
                               VarArrayOf( [pvSindicato, pvEvento]), []);

    if not Result then
      Result := cdRescisaoEvento.Locate( 'IDSINDICATO;IDEVENTO',
                                         VarArrayOf( [0, pvEvento]), []);

    if Result then
    begin

      iMesDireito := cdRescisaoEvento.FieldByName('MES_DIREITO').AsInteger;
      Formula     := cdRescisaoEvento.FieldByName('FORMULA').AsString;

      if (iMesDireito > 0) and (TempoServico() < iMesDireito) then
      begin
        Formula := EmptyStr;
        Result  := False; { Nao tem direito }
      end;

    end; // Result

    if not Result then
      Exit;

  end;

  // O valor informado em F_INFORMADO sempre terá prioridade sobre
  // os outros valores informados

  if cdInformado.Locate( 'IDEVENTO', pvEvento, []) then
  begin
    pvInformado := cdInformado.FieldByName('INFORMADO').AsCurrency;
    Result := True;
    Exit;
  end;

  if cdAutomatico.Locate( 'IDEVENTO', pvEvento, []) then
  begin
    // Pesquisa em cdAutomatico - F_AUTOMATICO
    pvInformado := cdAutomatico.FieldByName('INFORMADO').AsCurrency;
    Result := True;
    Exit;
  end;

  if cdProgramado.Locate( 'IDEVENTO', pvEvento, []) then
  begin
    // Pesquisa em Eventos Programados - F_PROGRAMADO
    pvInformado := cdProgramado.FieldByName('INFORMADO').AsCurrency;
    Result := True;
    Exit;
  end;

  // Pesquisa em Eventos Padrões - cdPadrao - tabela F_PADRAO

  cdPadrao.First;

  while not cdPadrao.Eof do
  begin

    if (cdPadrao.FieldByName('IDEVENTO').AsInteger = pvEvento) then
    begin

      iPadrao := cdPadrao.FieldByName('IDPADRAO').AsInteger;

      { 12/05/2008 by allan_lima }

      if (pvPadraoFGTS.IndexOfName(IntToStr(iPadrao)) = -1) then
        pvPadraoFGTS.Values[IntToStr(iPadrao)] := PesquisaFiltro('FGTS', iPadrao);

      s := pvPadraoFGTS.Values[IntToStr(iPadrao)];

      { A categoria de FGTS consta nas categorias de FGTS do evento-padrao }
      Result := (s = '_') or (Pos(pvFGTSFunc, s) > 0);

      { 21/05/2008 by allan_lima }

      if Result then
      begin

        if (pvPadraoTipo.IndexOfName(IntToStr(iPadrao)) = -1) then
          pvPadraoTipo.Values[IntToStr(iPadrao)] := PesquisaFiltro('TIPO', iPadrao);

        s := pvPadraoTipo.Values[IntToStr(iPadrao)];

        { O tipo de funcionario consta nos tipo de funcionarios do evento-padrao }
        Result := (s = '_') or (Pos( pvTipoFunc, s) > 0);

      end;

      if Result then   { 21/05/2008 by allan_lima }
      begin

        if (pvPadraoSituacao.IndexOfName(IntToStr(iPadrao)) = -1) then
          pvPadraoSituacao.Values[IntToStr(iPadrao)] := PesquisaFiltro('SITUACAO', iPadrao);

        s := pvPadraoSituacao.Values[IntToStr(iPadrao)];

        { A situação do funcionário consta nas situações do evento-padrao }
        Result := (s = '_') or (Pos(pvSituacaoFunc, s) > 0);

      end;

      if Result then  { 21/05/2008 by allan_lima }
      begin

        if (pvPadraoVinculo.IndexOfName(IntToStr(iPadrao)) = -1) then
          pvPadraoVinculo.Values[IntToStr(iPadrao)] := PesquisaFiltro('VINCULO', iPadrao);

        s := pvPadraoVinculo.Values[IntToStr(iPadrao)];

        { O vinculo empregaticio do funcionário consta nos vinculos do evento-padrao }
        Result := (s = '_') or (Pos( pvVinculoFunc, s) > 0);

      end;

      if Result then  { 21/05/2008 by allan_lima }
      begin

        if (pvPadraoSalario.IndexOfName(IntToStr(iPadrao)) = -1) then
          pvPadraoSalario.Values[IntToStr(iPadrao)] := PesquisaFiltro('SALARIO', iPadrao);

        s := pvPadraoSalario.Values[IntToStr(iPadrao)];

        { O tipo de salario do funcionário consta nos tipos de salario do evento-padrao }
        Result := (s = '_') or (Pos( pvTipoSalario, s) > 0);

      end;

      if Result then
      begin
        pvInformado := cdPadrao.FieldByName('INFORMADO').AsCurrency;
        Break;
      end;

    end;  // if Evento

    cdPadrao.Next;

  end; // while

end;  // PesquisaValorInformado

procedure TkCalculador.NumeroDiasInativos();
begin

  pvDiasInativo   := 0;
  pvDiasPagamento := 30;

  if (pvAdmissao > 0) and (Year(pvAdmissao) = Year(pvInicio)) and
     (Month(pvAdmissao) = Month(pvInicio)) then
    pvDiasInativo := Day(pvAdmissao)-1;

  if (pvDemissao > 0) and (Year(pvDemissao) = Year(pvInicio)) and
     (Month(pvDemissao) = Month(pvInicio)) then
    pvDiasInativo := pvDiasInativo + ( pvDiasPagamento - Day(pvDemissao));

end;  // proc NumeroDiasInativos

function tkCalculador.SetInformado( Value: Currency): Currency;
begin
  pvInformado := Value;
  Result := Value;
end;

function tkCalculador.SetReferencia( Value: Currency): Currency;
begin
  pvReferencia := Value;
  Result := Value;
end;

function tkCalculador.SetTotalizado( Value: Currency): Currency;
begin
  pvTotalizado := Value;
  Result := Value;
end;

procedure TkCalculador.LocalVariable(Sender: TObject; Eval: String;
  var Value: Variant; var Done: Boolean);
begin

  // Quando Done for True o FatExpression não processa mais a variavel

  Eval := UpperCase(Eval);

  if (Eval = 'VI') then
  begin
    pvInformado := Value;
    Done := True;
  end else if (Eval = 'VR') then
  begin
    pvReferencia := Value;
    Done := True;
  end else if (Eval = 'VT') then
  begin
    pvTotalizado := Value;
    Done := True;
  end;

end;

procedure TkCalculador.LocalEvaluate(Sender: TObject;
  Eval: String; Args: array of Variant; ArgCount: Integer;
  var Value: Variant; var Done: Boolean);
var

  iEvento, iLen, i: Integer;
  bTotalizado: Boolean;  // Para desativar o "Totalizar"
  sTexto, cTipo, cSexo, cInvalido: String;
  sValor, sCalculo: String;

  procedure fCalculoValor( const Texto: String; var Calculo, Valor: String);
  var
    a: Integer;
  begin

    Calculo := EmptyStr;
    Valor   := EmptyStr;

    for a := 1 to Length(Texto) do
      if (Texto[a] in ['C','I','R','T']) then
      begin
        if (Valor <> EmptyStr) then
          raise Exception.Create(C_ERRO_PARAMETRO)
        else
          Valor := sTexto[a];
      end else if (Texto[a] in ['A','Q','M','X','N','U']) then
      begin
        if (Calculo <> EmptyStr) then
          raise Exception.Create(C_ERRO_PARAMETRO)
        else
          Calculo := Texto[a];
      end;

  end;  // TotalCalculoValor

begin

  iLen := Length(Eval);
  Eval := UpperCase(Eval);

  if (Eval = 'IRRF') then { 27/02/2008 - allan_lima }
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := IRRF(Args[0]);

  end else

  { ========== Dados do funcionario ========== }

  if (Eval = 'CG') then  // Codigo do Cargo
    Value := cdFuncionario.FieldByName('IDCARGO').AsInteger

  else if (Eval = 'CH') then  // Carga Horaria Mensal
    Value := pvCargaHoraria

  else if (Eval = 'GI') then  // Grau de Instrucao
    Value := cdFuncionario.FieldByName('IDINSTRUCAO').AsString

  else if (Eval = 'HT') then  // Valor da Hora Trabalhada
    Value := HoraNormal()

  else if (Eval = 'ID') then // Codigo Identificador
    Value := cdFuncionario.FieldByName('IDFUNCIONARIO').AsInteger

  else if (Eval = 'LT') then  // Codigo da Lotacao
    Value := cdFuncionario.FieldByName('IDLOTACAO').AsInteger

  else if (Eval = 'MMA') then  // Meses de Admissão no Ano
    Value := MAA()

  else if (Eval = 'MM') then  // Meses para Media
    Value := MM()

  else if (Eval = 'SM') then // Valor do Salario Mensal
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := SalarioMensal()

  end else if (Eval = 'SN') then // Valor do Salario Mensal "Normal"
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := SalarioNormal()

  { Bug fix: 1672060; Open Date: 01/03/2007; Close Date: 01/03/2007; Close Developer: allan_lima }
  end else if (Eval = 'SALARIO') then // Valor do Salario Básico
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := cdFuncionario.FieldByName('SALARIO').AsCurrency;

  end else if (Eval = 'TN') then  // Tempo de nascimento em meses
    Value := TempoNascimento()

  else if (Eval = 'TS') then  // Tempo de Servico em meses
    Value := TempoServico()

  { DSR - Descanso Semanal Remunerado }

  else if (Eval = 'DSR') then
  begin
    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);
    Value := DSR();
  end

  { ========== Contagem de Dependentes ========== }

  { * DD ou DD()
    Executa a contagem geral dos dependentes desconsiderando quaisquer informações.

    * DD[t][M,F][I] ou DD([t],[M,F],[I])
    Realiza a contagem dos dependentes desconsiderando as idades e os limites
    do tipo. Se o modificador [t] for informado será considerado apenas os
    dependentes dos tipos [t]. Se o modificador opcional [M,F] for usado será
    considerado apenas os dependentes do sexo correspondente. Se o modificador
    opcional [I] for utilizado será considerado apenas os dependentes "inválidos". }

  else if (Eval = 'DD') then
  begin

    if (ArgCount = 0) then
      Value := DependenteGeral()
    else if (ArgCount = 1) then
      Value := DependenteGeral( String(Args[0]))
    else if (ArgCount = 2) then
      Value := DependenteGeral( String(Args[0]), String(Args[1]))
    else if (ArgCount = 3) then
      Value := DependenteGeral( String(Args[0]), String(Args[1]), String(Args[2]) )
    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end else if (Copy(Eval, 1, 2) = 'DD') then
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto    := Copy( Eval, 3, iLen);
    cTipo     := EmptyStr;
    cSexo     := EmptyStr;
    cInvalido := EmptyStr;

    if Pos( 'F', sTexto) > 0 then
      cSexo := 'F';

    if Pos( 'M', sTexto) > 0 then
      if (cSexo <> EmptyStr) then
        cSexo := EmptyStr
      else
        cSexo := 'M';

    if Pos( 'I', sTexto) > 0 then
      cInvalido := 'I';

    sTexto := kRetiraChar( sTexto, 'FMI');

    if (sTexto <> EmptyStr) then
      cTipo := sTexto[1];

    Value := DependenteGeral( cTipo, cSexo, cInvalido);

  end

  {
  * D[t] ou D([t])
    Executa a contagem dos dependentes do tipo [t], considerando o limite
    de idade para o tipo e o campo "inválido".

  * D[t][M,F][I] ou D([t],[M,F],[I])
    Realiza a contagem dos dependentes considerando o limite de idade quando o
    tipo for especificado. Se o modificador opcional [M,F] for usado será
    considerado apenas os dependentes de sexo correspondente. Se o modificador
    opcional [I] for utilizado será considerado apenas os dependentes "inválidos".
  }

  else if (Eval = 'D') then
  begin

    if (ArgCount = 1) then
      Value := Dependente( String(Args[0]))
    else if (ArgCount = 2) then
      Value := Dependente( String(Args[0]), String(Args[1]))
    else if (ArgCount = 3) then
      Value := Dependente( String(Args[0]), String(Args[1]), String(Args[2]) )
    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end

  else if (iLen > 1) and (Eval[1] = 'D') then // No. de Dependente-Tipo
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto    := Copy( Eval, 2, iLen);
    cTipo     := EmptyStr;
    cSexo     := EmptyStr;
    cInvalido := EmptyStr;

    if Pos( 'F', sTexto) > 0 then
      cSexo := 'F';

    if Pos( 'M', sTexto) > 0 then
      if cSexo <> EmptyStr then
        cSexo := EmptyStr
      else
        cSexo := 'M';

    if Pos( 'I', sTexto) > 0 then
      cInvalido := 'I';

    sTexto := kRetiraChar( sTexto, 'FMI');

    if (sTexto <> EmptyStr) then
      cTipo := sTexto[1];

    Value := Dependente( cTipo, cSexo, cInvalido);

  end

  { ========== Dados do Evento ========== }

  else if (Eval = 'MN') then  // Valor Minimo
    Value := ValorMinimoEvento()

  else if (Eval = 'MT') then // Multiplicador de Hora
    Value := pvMultiplicador

  else if (Eval = 'MX') then  // Valor Maximo
    Value := ValorMaximoEvento()

  { ========== Funcoes para manipulacao de indices ========== }

  else if (Eval = 'IL') then  // Indice Local
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := IndiceLocal( Trunc(Args[0]));

  end else if (Copy( Eval, 1, 2) = 'IL') then  // Indice Local
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));
    Value := IndiceLocal(i);

  end else if (Eval = 'IG') then  // Indice Global
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := IndiceGlobal( Trunc(Args[0]));

  end else if (Copy( Eval, 1, 2) = 'IG') then  // Indice Global
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));
    Value := IndiceGlobal(i);

  end else if (Eval = 'II') then   // Indice Local ou Global
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := IndiceGeral( Trunc(Args[0]));

  end else if (Copy( Eval, 1, 2) = 'II') then  // Indice Local ou Global
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));
    Value := IndiceGeral(i);

  end else if (Copy( Eval, 1, 1) = 'I') then  // Indice Local ou Global
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 2, iLen));
    Value := IndiceGeral(i);

  end

  { ==========  Funcoes para manipulacao de tabelas ========== }

  { * TL[t]([v]) ou TL([t],[v])
    Retorna o valor resultante da aplicação de taxa, redução e/ou acréscimo sobre
    o valor-alvo [v] conforme a faixa apropriada pesquisada da tabela local [t]. }

  else if (Eval = 'TL') then  // Tabela Local
  begin

    if (ArgCount <> 2) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TabelaLocal( Trunc(Args[0]), Args[1]);

  end else if (Copy( Eval, 1, 2) = 'TL') then  // Tabela Local
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));  // número da tabela local
    Value := TabelaLocal( i, Args[0]);

  end

  { * TLI[t]([i]) ou TLI([t],[i])
    Retorna o valor do item [i] da tabela global [t]. }

  else if (Eval = 'TLI') then  // Valor do Item da Tabela Local
  begin

    if (ArgCount <> 2) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TabelaLocalItem( Trunc(Args[0]), Trunc(Args[1]));

  end else if (Copy(Eval, 1, 3) = 'TLI') then  // Valor do Item da Tabela Local
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 4, iLen));  // número da tabela local
    Value := TabelaLocalItem( i, Trunc(Args[0]));

  end

  { * TGI[t]([i]) ou TGI([t],[i])
    Retorna o valor do item [i] da tabela global [t]. }

  else if (Eval = 'TGI') then    // Valor do Item da Tabela Global
  begin

    if (ArgCount <> 2) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TabelaGlobalItem( Trunc(Args[0]) , Trunc(Args[1]));

  end else if (Copy( Eval, 1, 3) = 'TGI') then  // Valor do Item da Tabela Global
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 4, iLen));  // número da tabela global
    Value := TabelaGlobalItem( i , Trunc(Args[0]))

  end

  { * TG[t]([v]) ou TG([t],[v]) - Tabela Global.
    Retorna o valor resultante da aplicação de taxa, redução e/ou acréscimo sobre
    o valor-alvo [v] conforme a faixa apropriada pesquisada na tabela global [t]. }

  else if (Eval = 'TG') then  // Tabela Global
  begin

    if (ArgCount <> 2) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TabelaGlobal( Trunc(Args[0]), Args[1]);

  end else if (Copy( Eval, 1, 2) = 'TG') then  // Tabela Global
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));  // número da tabela global
    Value := TabelaGlobal( i, Args[0]);

  end

  { * TBI[t]([i]) ou TBI([t],[i])
    Retorna o valor do item [i] da tabela local [t].
    Se a tabela local [t] não existir o item [t] será pesquisado
    na tabela global [t]. }

  else if (Eval = 'TBI') then  // Valor do Item da Tabela Geral
  begin

    if (ArgCount <> 2) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TabelaGeralItem( Trunc(Args[0]), Trunc(Args[1]));

  end else if (Copy(Eval, 1, 3) = 'TBI') then  // Valor do Item da Tabela Geral
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 4, iLen));  // número da tabela Geral
    Value := TabelaGeralItem( i, Trunc(Args[0]));

  end

  { * TB[t]([v]) ou TB([t],[v])
    Retorna o valor resultante da aplicação de taxa, redução e/ou acréscimo
    sobre o valor-alvo [v] conforme a faixa apropriada pesquisada na tabela [t].
    A tabela [t] será primeiramente pesquisada na empresa local, se a tabela
    não existir na empresa local será pesquisada na empresa global. }

  else if (Eval = 'TB') and (ArgCount > 0) then  // Tabela Geral
  begin

    if (ArgCount <> 2) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TabelaGeral( Trunc(Args[0]), Args[1]);

  end else if (Copy( Eval, 1, 2) = 'TB') then  // Tabela Geral
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));  // número da tabela Geral
    Value := TabelaGeral( i, Args[0]);

  end

  { ========== Base de Acumulação ========== }

  { * B<n> ou BB(<n>): Executa a base de acumulação <n>. Se a base
      não existir será gerado um erro "Base de Acumulação não existe". }

  else if (Eval[1] = 'B') then
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 2, iLen));  // Número da base de acumulação

    Value := BaseAcumulacao( pvGE, pvEmpresa,
                             pvFolha, i, pvFuncionario, pvEvento,
                             pvAdmissao, pvFim, not pvStartTransaction);

  end else if (Eval = 'BB') then
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := Args[0];  // Número da base de acumulação

    Value := BaseAcumulacao( pvGE, pvEmpresa,
                             pvFolha, i, pvFuncionario, pvEvento,
                             pvAdmissao, pvFim, not pvStartTransaction);

  end

  // Totalizadores/Acumuladores
  // ==========================

  // Totalizadores - TA

  else if (Eval = 'TA') then
  begin

   { * TA, TA() ou TA( [A,M,Q,X,N,U], [C,I,R,T], [<evento>] )
     Executa uma totalização padrão.
     Será considerado apenas o evento em cálculo ou aquele que for informado em
     <evento>, as folhas cujo tipo seja igual ao tipo da folha em cálculo.
     Haverá uma operação de ACUMULAÇÃO sobre o valor CALCULADO.
     A operação poderá ser alterada pelo modificador [A,M,Q,X,N,U] e o
     valor pelo modificador [C,I,R,T] }

    if (ArgCount > 3) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto  := EmptyStr;
    iEvento := pvEvento;

    for i := 0 to ArgCount - 1 do
      if VarIsOrdinal(Args[i]) then
        iEvento := Args[i]
      else
        sTexto := sTexto + UpperCase(Args[i]);

    fCalculoValor( sTexto, sCalculo, sValor);

    Value := TotalizadorPadrao( sValor, sCalculo,
                                pvEmpresa, pvFuncionario, iEvento,
                                pvInicio, pvFim, pvTipoFolha, True, not pvStartTransaction);

  end else if (Copy( Eval, 1, 2) = 'TA') then
  begin

    { * TA[A,M,Q,X,N,U][C,I,R,T]
      Executa uma totalização padrão.
      Será considerado apenas o evento em cálculo e as folhas cujos tipos
      sejão igual ao tipo da folha em cálculo.
      A operação de totalização dependerá dos modificadores [A,M,Q,X,N] e o
      campo de cálculo dependerá  dos modificadores [C,I,R,T].
      Os modificadores não são obrigatórios e as respectivas ordens não são importantes. }

    if (ArgCount > 0) or (Length(Eval) > 4) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto := Copy( Eval, 3, 2);

    fCalculoValor( sTexto, sCalculo, sValor);

    Value := TotalizadorPadrao( sValor, sCalculo,
                                pvEmpresa, pvFuncionario, pvEvento,
                                pvInicio, pvFim, pvTipoFolha, True, not pvStartTransaction);

  { Totalizadores - TT }

  end else if (Eval = 'TT') then
  begin

    sCalculo := EmptyStr;
    sValor   := EmptyStr;

    if (ArgCount = 0) then
    begin

      { * TT ou TT()
        Executa uma totalização padrão.
        Será considerado apenas o evento em cálculo,
        as folhas cujo tipo esteja com o campo "Totalizar" ativado.
        Haverá uma ACUMULAÇÃO do do valor CALCULADO do histórico de pagamentos.}

      Value := TotalizadorPadrao( sValor, sCalculo,
                                  pvEmpresa, pvFuncionario, pvEvento,
                                  pvInicio, pvFim, EmptyStr, True, not pvStartTransaction);

    end else
    if (ArgCount = 1) and VarIsOrdinal(Args[0]) then
    begin

      { * TT([n])
        Executa o totalizador [n].
        Se o totalizador não existir será gerado um erro
        "Totalizador não existe". A operação e o valor de totalização serão o
        que está informado no totalizador. Somente as folhas que pertencerem
        aos tipos especificados no totalizador serão consideradas. Se nenhum
        tipo for estiver definido, somente os tipos cujo campo "Totalizar"
        estiver marcado. Somentes os eventos especificados no totalizador
        serão considerados. Se nenhum eventos estiver definido, será
        considerado apenas o evento em cálculo.}

      Value := Totalizador( pvEmpresa, Args[0], pvFuncionario, pvEvento,
                            pvInicio, pvFim, not pvStartTransaction);

    end else
    begin

      { * TT( [A,M,Q,X,N,U] , [C,I,R,T] , [Z], [<evento>] )

        Executa uma totalização padrão.

        Será considerado apenas o evento em cálculo ou aquele informado em
        <evento> e as folhas cujos tipos estejam com o campo "Totalizar" ativado.

        Se for utilizado o modificador [Z] a verificação do campo "Totalizar"
        será desativada.

        A operação de totalização dependerá dos modificadores [A,M,Q,X,N,U] e o
        campo de cálculo dependerá dos modificadores [C,I,R,T].

        Os modificadores não são obrigatórios e as suas respectivas ordens
        também não são importantes. }

      if (ArgCount > 4) then
        raise Exception.Create(C_ERRO_PARAMETRO);

      sTexto  := EmptyStr;
      iEvento := pvEvento;
      bTotalizado := True;

      for i := 0 to ArgCount - 1 do
        if VarIsOrdinal(Args[i]) then
          iEvento := Args[i]
        else if (UpperCase(Args[i]) = 'Z') then
          bTotalizado := False
        else
          sTexto := sTexto + UpperCase(Args[i]);

      fCalculoValor( sTexto, sCalculo, sValor);

      Value := TotalizadorPadrao( sValor, sCalculo,
                                  pvEmpresa, pvFuncionario, iEvento,
                                  pvInicio, pvFim, EmptyStr, bTotalizado, not pvStartTransaction);

    end;

  end else if (Copy( Eval, 1, 2) = 'TT') then
  begin

    { TT[A,M,Q,X,N,U][C,I,R,T][Z]

      Executa uma totalização padrão.

      Será considerado apenas o evento em cálculo e as folhas cujos
      tipos estejam com o campo "Totalizar" ativado.

      Se for utilizado o modificador [Z] a verificação do campo "Totalizar"
      será desativada.

      A operação de totalização dependerá dos modificadores [A,M,Q,X,N,U] e o
      campo de cálculo dependerá dos modificadores [C,I,R,T].

      Os modificadores não são obrigatórios e as suas
      respectivas ordens também não são importantes. }

    if (ArgCount > 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto := Copy( Eval, 3, iLen);

    if kNumerico(sTexto) then  // TT[1..99] mesmo que TT([n])

      Value := Totalizador( pvEmpresa, StrToInt(sTexto),
                            pvFuncionario, pvEvento,
                            pvInicio, pvFim, not pvStartTransaction)
    else
    begin

      i := Pos('Z', sTexto);
      bTotalizado := True;

      if (i > 0) then
      begin
        bTotalizado := False;
        sTexto := Copy( sTexto, 1, i-1)+Copy(sTexto, i+1, iLen);
      end;

      fCalculoValor( sTexto, sCalculo, sValor);

      Value := TotalizadorPadrao( sValor, sCalculo,
                                  pvEmpresa, pvFuncionario, pvEvento,
                                  pvInicio, pvFim, EmptyStr, bTotalizado, not pvStartTransaction);
    end;

  // Totalizadores - AA

  end else if (Eval = 'AA') then
  begin

   { * AA ou AA()
     Executa uma totalização padrão.
     Será considerado apenas o evento em cálculo, as folhas cujo tipo
     seja igual ao tipo da folha em cálculo. Haverá uma acumulação do
     do valor CALCULADO do histórico de pagamentos do funcionário,
     o período considerado será o primeiro dia do ano até o ínicio do
     período da folha em cálculo. }

   { * AA( [A,M,Q,X,N,U] , [C,I,R,T] )
     Executa a mesma totalização de AA.
     A totalização dependerá dos modificadores [A,M,Q,X,N] e o
     campo de cálculo dependerá dos modificadores [C,I,R,T].
     Os modificadores não são obrigatórios e as suas respectivas ordens
     também não são importantes. }

    if (ArgCount > 3) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto  := EmptyStr;
    iEvento := pvEvento;

    for i := 0 to ArgCount - 1 do
      if VarIsOrdinal(Args[i]) then
        iEvento := Args[i]
      else
        sTexto := sTexto + UpperCase(Args[i]);
    
    fCalculoValor( sTexto, sCalculo, sValor);

    Value := TotalizadorPadrao( sValor, sCalculo,
                                pvEmpresa, pvFuncionario, iEvento,
                                FirstDayOfYear(pvInicio),
                                AddDays( pvInicio, -1), pvTipoFolha, True,
                                not pvStartTransaction);

  end else if (Copy( Eval, 1, 2) = 'AA') then
  begin

    { * AA[A,M,Q,X,N,U][C,I,R,T]
      Executa a mesma totalização de AA.
      A totalização dependerá dos modificadores [A,M,Q,X,N] e o
      campo de cálculo dependerá dos modificadores [C,I,R,T].
      Os modificadores não são obrigatórios e as suas respectivas ordens
      também não são importantes. }

    if (ArgCount > 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto := Copy( Eval, 3, iLen);

    fCalculoValor(sTexto, sCalculo, sValor);

    Value := TotalizadorPadrao( sValor, sCalculo,
                                pvEmpresa, pvFuncionario, pvEvento,
                                FirstDayOfYear(pvInicio),
                                AddDays(pvInicio, -1), pvTipoFolha, True, not pvStartTransaction);

  end

  { Ler os valores CALCULADO, INFORMADO, REFERENCIA E TOTALIZADO }

  else if (Eval = 'VC') then  // Valor calculado do evento
  begin

    if (ArgCount = 1) then
      Value := Evento( Trunc(Args[0]), 0, 'CALCULADO')
    else if (ArgCount = 2) then
      Value := Evento( Trunc(Args[0]), Trunc(Args[1]), 'CALCULADO')
    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end else if (Copy( Eval, 1, 2) = 'VC') then
  begin

    if (ArgCount > 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    sTexto := Copy( Eval, 3, iLen);

    if not IsDigit(sTexto) then
      raise Exception.Create('Argumento inválido para Função a VC(). Informe um número.');

    Value := Evento( StrToInt(sTexto), 0, 'CALCULADO');

  end else if (Eval = 'VI') then   // Valor Informado
  begin

    if (ArgCount = 0) then
     Value := pvInformado
    else if (ArgCount = 1) then
      Value := Evento( Trunc(Args[0]), 0, 'INFORMADO')
    else if (ArgCount = 2) then
      Value := Evento( Trunc(Args[0]), Trunc(Args[1]), 'INFORMADO')
    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end else if (Eval = 'VR') then   // Valor Referencia
  begin

    if (ArgCount = 0) then
      Value := pvReferencia
    else if (ArgCount = 1) then
      Value := Evento( Trunc(Args[0]), 0, 'REFERENCIA')
    else if (ArgCount = 2) then
      Value := Evento( Trunc(Args[0]), Trunc(Args[1]), 'REFERENCIA')
    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end else if (Eval = 'VT') then   // Valor Totalizado
  begin

    if (ArgCount = 1) then
      Value := Evento( Trunc(Args[0]), 0, 'TOTALIZADO')
    else if (ArgCount = 2) then
      Value := Evento( Trunc(Args[0]), Trunc(Args[1]), 'TOTALIZADO')
    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end

  { Funcoes para manipulacao de valores fixos }

  else if (Eval = 'VL') then  // Valor Local
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    if VarIsStr(Args[0]) then
      Value := ValorLocal( VarToStr(Args[0]))
    else
      Value := ValorLocal( Trunc(Args[0]))

  end else if (Copy(Eval, 1, 2) = 'VL') then  // Valor Local
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));  // número do valor local
    Value := ValorLocal(i);

  end else if (Eval = 'VG') then  // Valor Global
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    if VarIsStr(Args[0]) then
      Value := ValorGlobal( VarToStr(Args[0]))
    else
      Value := ValorGlobal( Trunc(Args[0]));

  end else if (Copy( Eval, 1, 2) = 'VG') then  // Valor Global
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));  // número do valor global
    Value := ValorGlobal(i);

  end else if (Eval = 'VV') then  // Valor Local ou Global
  begin

    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    if VarIsStr(Args[0]) then
      Value := ValorGeral( VarToStr(Args[0]))
    else
      Value := ValorGeral( Trunc(Args[0]));

  end else if (Copy( Eval, 1, 2) = 'VV') then  // Valor Local ou Global
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 3, iLen));  // número do valor local ou global
    Value := ValorGeral(i);

  end else if (Copy( Eval, 1, 1) = 'V')  then  // Valor Local ou Global
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i := StrToInt( Copy( Eval, 2, iLen));  // número do valor local ou global
    Value := ValorGeral(i);

  end

  { Define os valores INFORMADO, REFERENCIA E TOTALIZADO }

  else if (Eval = 'SETINF') then // Atualiza valor informado
  begin
    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);
    Value := SetInformado( Args[0]);

  end else if (Eval = 'SETREF') then //  Atualiza valor referencia
  begin
    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);
    Value := SetReferencia( Args[0]);

  end else if (Eval = 'SETTOT') then //  Atualiza valor referencia
  begin
    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);
    Value := SetTotalizado( Args[0]);

  end

  { ========== Outras funcoes de apoio ========== }

  { * CP[e] ou CP([e]) - Contra-Partida.
      Retorna o total de valores calculados para o evento [e] nas
      folhas de contra-partida especificadas na folha atual para funcionario. }

  else if (Eval = 'CP') then  // Contra partida
  begin
    if (ArgCount <> 1) then
      raise Exception.Create(C_ERRO_PARAMETRO);
    if VarIsStr(Args[0]) then
      Value := ContraPartida( VarToStr(Args[0]))
    else
      Value := ContraPartida( Trunc(Args[0]));

  end else if (Copy( Eval, 1, 2) = 'CP') then
  begin
    i := StrToInt(Copy( Eval, 3, iLen));
    Value := ContraPartida(i);

  end

  { Valores recolhidos ou acumulados durante o calculo }

  else if (Eval = 'TX') then // Valor da ultima taxa aplicada na formula
    Value := pvTaxa

  else if (Eval = 'TB') and (ArgCount = 0) then  // Valor Total de Eventos - Base
    Value := pvBase

  else if (Eval = 'TD') then // Valor Total de Eventos - Desconto
    Value := pvDesconto

  else if (Eval = 'TP') then  // Valor Total de Eventos - Provento
    Value := pvProvento

  { Total de Incidencia }

  else if (Eval = 'TI') then
  begin

    if (ArgCount = 0) then
      Value := TotalIncidenciaNome(pvEventoNome) { 06/06/2005 - allan_lima }

    else if (ArgCount = 1) then
      Value := TotalIncidencia( Trunc(Args[0]))

    else
      raise Exception.Create(C_ERRO_PARAMETRO);


  end else if (iLen > 1) and (Eval[1] = 'T') and kNumerico( Copy( Eval, 2, iLen)) then
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TotalIncidencia( StrToInt(Copy( Eval, 2, iLen)));

  end else if (Copy( Eval, 1, 2) = 'TI') then
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := TotalIncidencia( Copy( Eval, 3, iLen));

  end else if (Eval = 'XE') then  { 06/06/2005 - allan_lima }
  begin

    if (ArgCount = 0) then
      Value := XE( pvEvento, Month(pvCredito), Year(pvCredito))

    else if (ArgCount = 1) then
      Value := XE( Args[0], Month(pvCredito), Year(pvCredito))

    else if (ArgCount = 2) then
      Value := XE( Args[0], Args[1], Year(pvCredito))

    else if (ArgCount = 3) then
      Value := XE( Args[0], Args[1], Args[2])

    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end else if (Copy( Eval, 1, 2) = 'XE') then  { 06/06/2005 - allan_lima }
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i     := StrToInt(Copy(Eval, 3, iLen));
    Value := XE( i, Month(pvCredito), Year(pvCredito));

  end else if (Eval = 'XI') then  { 06/06/2005 - allan_lima }
  begin

    if (ArgCount = 0) then
    begin

      if not cdIncidencias.Locate( 'NOME', pvEventoNome, []) then
        raise Exception.Create('Não existe a incidência "'+pvEventoNome+'"');

      i     := cdIncidencias.Fields[0].AsInteger;
      Value := XI( i, Month(pvCredito), Year(pvCredito))

    end else if (ArgCount = 1) then
      Value := XI( Args[0], Month(pvCredito), Year(pvCredito))

    else if (ArgCount = 2) then
      Value := XI( Args[0], Args[1], Year(pvCredito))

    else if (ArgCount = 3) then
      Value := XI( Args[0], Args[1], Args[2])

    else
      raise Exception.Create(C_ERRO_PARAMETRO);

  end else if (Copy( Eval, 1, 2) = 'XI') then  { 06/06/2005 - allan_lima }
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    i     := StrToInt(Copy(Eval, 3, iLen));
    Value := XI( i, Month(pvCredito), Year(pvCredito));

  { Quantidade de dias utéis no periodo da folha }
  end else if (Eval = 'PDU') then
    Value := DiasUteis()

  { Quantidade de domingos e feriados no periodo da folha }
  else if (Eval = 'PDF') then
    Value := DiasNaoUteis()

  { Gratificacao Natalina - 13o salario }
  else if (Eval = 'GN') then
  begin

    if (ArgCount <> 0) then
      raise Exception.Create(C_ERRO_PARAMETRO);

    Value := GN();

  end;

end;  // LocalEvaluate

{ Adicionado em 06/06/2005 por allan_lima }

{ XI - Retorna o total calculado para os eventos cuja incidencia esteja
       ativada das folhas de pagamento de mes de credito igual a
       <Mes> e <Ano> anteriores ao credito da folha atual }

function TkCalculador.XI( Incidencia, Mes, Ano: Integer): Double;
var
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  SQL      := TStringList.Create;
  DataSet1 := TClientDataSet.Create(nil);
  Result   := 0.0;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  SUM(C.CALCULADO*C.LIQUIDO)');
    SQL.Add('FROM');
    SQL.Add('  F_FOLHA F, F_CENTRAL C');
    SQL.Add('WHERE');
    // Folha
    SQL.Add('  F.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND EXTRACT(MONTH FROM F.DATA_CREDITO) = :MES');
    SQL.Add('  AND EXTRACT(YEAR FROM F.DATA_CREDITO)  = :ANO');
    SQL.Add('  AND F.DATA_CREDITO < :CREDITO');
    // Funcionario
    SQL.Add('  AND C.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND C.IDFOLHA   = F.IDFOLHA');
    SQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');
    // Evento
    SQL.Add('  AND C.IDEVENTO IN (SELECT IDEVENTO FROM F_EVENTO');
    SQL.Add('                     WHERE INC_'+kStrZero( Incidencia, 2)+'_X = 1)');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text,
                     [pvEmpresa, Mes, Ano, pvCredito, pvFuncionario],
                     not pvStartTransaction) then
      raise Exception.Create(EmptyStr);

    Result := DataSet1.Fields[0].AsCurrency;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;  // XI

{ Adicionado em 06/06/2005 por allan_lima }

function TkCalculador.XE( Evento, Mes, Ano: Integer): Double;
var
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  SQL      := TStringList.Create;
  DataSet1 := TClientDataSet.Create(nil);
  Result   := 0.0;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  SUM(C.CALCULADO*C.LIQUIDO)');
    SQL.Add('FROM');
    SQL.Add('  F_FOLHA F, F_CENTRAL C');
    SQL.Add('WHERE');
    // Folha
    SQL.Add('  F.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND EXTRACT(MONTH FROM F.DATA_CREDITO) = :MES');
    SQL.Add('  AND EXTRACT(YEAR FROM F.DATA_CREDITO)  = :ANO');
    SQL.Add('  AND F.DATA_CREDITO < :CREDITO');
    // Funcionario
    SQL.Add('  AND C.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND C.IDFOLHA   = F.IDFOLHA');
    SQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');
    // Evento
    SQL.Add('  AND C.IDEVENTO = :EVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text,
                     [pvEmpresa, Mes, Ano, pvCredito, pvFuncionario, Evento],
                     not pvStartTransaction) then
      raise Exception.Create(EmptyStr);

    Result := DataSet1.Fields[0].AsCurrency;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;  // XE

{ Função: ValorBase
  Descrição: Retorna o total do evento processados nas folhas bases
             para desconto/abatimento ao evento da folha complementar }
function TkCalculador.ValorBase( const Evento: Integer): Double; { 19/06/2005 - allan_lima }
var
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  SQL      := TStringList.Create;
  DataSet1 := TClientDataSet.Create(nil);
  Result   := 0.0;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  SUM(C.CALCULADO)');
    SQL.Add('FROM');
    SQL.Add('  F_FOLHA_BASE F, F_CENTRAL C');
    SQL.Add('WHERE');
    SQL.Add('  F.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND F.IDFOLHA = :FOLHA');
    SQL.Add('  AND C.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND C.IDFOLHA = F.IDFOLHA_BASE');
    SQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');
    SQL.Add('  AND C.IDEVENTO = :EVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text,
                     [pvEmpresa, pvFolha, pvFuncionario, Evento],
                     not pvStartTransaction) then
      raise Exception.Create(EmptyStr);

    Result := DataSet1.Fields[0].AsCurrency;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;  // ValorBase

function TkCalculador.DiasUteis(): Double; { 08/03/2007 - allan_lima }
begin

  if (pvDiasUteis = -1) then
  begin
    pvDiasUteis := Trunc(pvFim-pvInicio)+1;  // Total de dias no periodo
    pvDiasUteis := pvDiasUteis - DiasNaoUteis();
  end;

  Result := pvDiasUteis;

end;

function TkCalculador.DiasNaoUteis(): Double; { 08/03/2007 - allan_lima }
var
  iFeriado, iSunday: Integer;
  cdFeriado: TClientDataSet;
begin

  if (pvDiasNaoUteis = -1) then
  begin

    cdFeriado := TClientDataSet.Create(NIL);

    try

      if not kOpenSQL(cdFeriado,
                      'SELECT * FROM FERIADO WHERE DATA BETWEEN :D1 AND :D2',
                      [pvInicio, pvFim], not pvStartTransaction) then
        raise Exception.Create(EmptyStr);

      iFeriado := 0;  // Qtde de feriados não-domingos
      cdFeriado.First;

      while not cdFeriado.Eof do
      begin
        if (DayOfWeek(cdFeriado.FieldByName('DATA').AsDateTime) <> 1) then
          Inc(iFeriado);
        cdFeriado.Next;
      end;

      iSunday := kWeekDayCount(pvInicio, pvFim, 1);  // Total de domingos

      pvDiasNaoUteis := (iFeriado+iSunday);

    finally
      cdFeriado.Free;
    end;

  end;

  Result := pvDiasNaoUteis;

end;

function TkCalculador.DSR():Double; { 23/08/2006 - allan_lima }
begin

  if (pvDSR = -1) then
  begin
    // pvDSR := (iFeriado+iSunday) / iDay;
    pvDSR := DiasNaoUteis() / DiasUteis() { 27/02/2007 - Sergio Toshio Kawahara }
  end;

  Result := pvDSR;

end;

{
- MAA - Meses de Admissao no Ano

  É o número de meses entre janeiro e dezembro do ano da folha que o
  funcionário trabalhará se não for demitido no ano.

  Se o funcionário foi admitido em anos anteriores MAA sempre será 12 (doze).
  Para os funcionários admitidos no ano da folha MAA será a diferênça entre 12
  e o mês de admissão desse funcionário. Se o funcionário trabalhou menos de
  15 (quinze) dias no mês de sua admissão esse mês não será considerado na contagem.
}
function TkCalculador.MAA(): Double; { 03/03/2007 - allan_lima }
begin

  Result := 0.0;

  if YearOf(pvAdmissao) < YearOf(pvInicio) then
    Result := 12.0
  else if YearOf(pvAdmissao) = YearOf(pvInicio) then
  begin
    Result := 12.0 - MonthOf(pvAdmisSao) + 1.0;
    if DayOf(LastDayOfMonth(pvAdmissao)) - DayOf(pvAdmissao) < 15 then
      Result := Result - 1.0;
  end;

end;  // MAA

{
- MM - Meses para Média

  É o número de meses que será considerado para o cálculo de médias.
  Esse número é calculado do seguinte modo: ::

    MESES_NO_PERIODO - (12 - MAA)
}
function TkCalculador.MM(): Double; { 03/03/2007 - allan_lima }
begin
  Result := DiffMonths( pvInicio, pvFim) - (12  - MAA);
end;  // MM

// GN - Gratificação Natalina (13o. salário)
function TkCalculador.GN(): Double;
var
  cdEvento: TClientDataSet;
  sSalario, sCalculo, sFormulaEvento, sFormulaLocal: String;
  iEvento: Integer;
  cValor, cMAA, cMM: Currency;
  eFormula: TAKExpression;

  function TTT( Valor, Calculo: String):Double;
  begin
    Result := TotalizadorPadrao( Valor, Calculo, pvEmpresa,
                                 pvFuncionario, iEvento, pvInicio, pvFim,
                                 EmptyStr, True, not pvStartTransaction);
  end;

begin

  cdEvento := TClientDataSet.Create(NIL);
  eFormula := TAKExpression.Create(NIL);

  try

    with eFormula do
    begin
      OnEvaluate := LocalEvaluate;
      OnVariable := LocalVariable;
      DataSetList.E := cdSequencia;
      DataSetList.F := cdFuncionario;
      DataSetList.L := cdFolha;
      DataSetList.R := cdRescisao;
    end;

    { Seleciona todos os eventos que incidem sobre o 13o. salário. }
    pvSQL.BeginUpdate;
    pvSQL.Clear;
    pvSQL.Add('SELECT');
    pvSQL.Add('  E.*, F.FORMULA AS FORMULA_EVENTO');
    pvSQL.Add('FROM');
    pvSQL.Add('  F_EVENTO E, F_FORMULA F');
    pvSQL.Add('WHERE');
    pvSQL.Add('  E.INC_13_X = 1 AND E.ATIVO_X = 1');
    pvSQL.Add('  AND F.IDFORMULA = E.IDFORMULA');
    pvSQL.EndUpdate;

    kOpenSQL( cdEvento, pvSQL.Text, not pvStartTransaction);

    Result := 0.0;
    cMAA := MAA();  { Meses de Admissao no Ano }
    cMM := MM();    { Meses para Média }

    { Os eventos encontrados são colocados em uma lista que será percorrida item a item }
    with cdEvento do
    begin

      First;

      while not Eof do
      begin

        iEvento  := FieldByName('IDEVENTO').AsInteger;
        sSalario := FieldByName('TIPO_SALARIO').AsString;
        sCalculo := FieldByName('TIPO_CALCULO').AsString;
        sFormulaEvento := FieldByName('FORMULA_EVENTO').AsString;
        sFormulaLocal := FieldByName('FORMULA_LOCAL').AsString;

        eFormula.Text := EmptyStr;
        cValor := 0.0;

        { SALARIO FIXO }

        if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_CONTRA_PARTIDA) then
        begin

          { VALOR_CALCULADO_NO_ULTIMO_MES / 12 * MAA }
          cValor := TTT('C', 'U');

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_VALOR_INFORMADO) then
        begin

          { VALOR_CALCULADO_NO_ULTIMO_MES / 12 * MAA }
          cValor := TTT('C', 'U');

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_HORA_TRABALHADA) then
        begin

          { ( VALOR_INFORMADO_NO_ULTIMO_MES * HT * MT ) / 12 * MAA }
          cValor := TTT('I', 'U');
          cValor := cValor * HoraNormal() * pvMultiplicador;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_DIA_TRABALHADO) then
        begin

          { ( VALOR_INFORMADO_NO_ULTIMO_MES * DT * MT ) / 12 * MAA }
          cValor := TTT('I', 'U');
          cValor := cValor * (SalarioMensal()/30) * pvMultiplicador;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_FORMULA) then
        begin

          { 1. Considera o VALOR_INFORMADO_NO_ULTIMO_MES como VALOR_INFORMADO (VI); }
          pvInformado := TTT('I', 'U');

          if (sFormulaEvento <> EmptyStr) then
            eFormula.Text := sFormulaEvento
          else if (sFormulaLocal <> EmptyStr) then
            eFormula.Text := sFormulaLocal;

          if (eFormula.Text = EmptyStr) then
            raise Exception.Create('É obrigatório que o evento possua fórmula.');

          { 2. Processa a fórmula do evento; }
          cValor := eFormula.AsDouble;

          { 3. RESULTADO_DA_FORMULA / 12 * MAA. }
          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        { SALARIO VARIAVEL }

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_CONTRA_PARTIDA) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_VALOR_INFORMADO) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_HORA_TRABALHADA) then
        begin

          { (( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM) / 12 * MAA ) * HT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * HoraNormal() * pvMultiplicador;

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_DIA_TRABALHADO) then
        begin

          { (( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM) / 12 * MAA ) * DT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * (SalarioMensal()/30.0) * pvMultiplicador;

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_FORMULA) then
        begin

          { 1. Considera como VALOR INFORMADO (VI) a expressão:
               (TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA; }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

          pvInformado := cValor;

          { 2. Processa a fórmula do evento; }
          if (sFormulaEvento <> EmptyStr) then
            eFormula.Text := sFormulaEvento
          else if (sFormulaLocal <> EmptyStr) then
            eFormula.Text := sFormulaLocal;

          if (eFormula.Text = EmptyStr) then
            raise Exception.Create('É obrigatório que o evento possua fórmula.');

          { 3. Assume o retorno da fórmula com resultado do cálculo. }
          cValor := eFormula.AsDouble;

        { PRODUÇÃO / PEÇA / TAREFA }

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_CONTRA_PARTIDA) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_VALOR_INFORMADO) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_HORA_TRABALHADA) then
        begin

          { ( ( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA ) * HT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * HoraNormal() * pvMultiplicador;

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_DIA_TRABALHADO) then
        begin

          { ( ( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA ) * DT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * (SalarioMensal()/30.0) * pvMultiplicador;

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_FORMULA) then
        begin

          { 1. Considera como VALOR INFORMADO (VI) a expressão:
              (TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA; }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

          pvInformado := cValor;

          { 2. Processa a fórmula do evento; }
          if (sFormulaEvento <> EmptyStr) then
            eFormula.Text := sFormulaEvento
          else if (sFormulaLocal <> EmptyStr) then
            eFormula.Text := sFormulaLocal;

          if (eFormula.Text = EmptyStr) then
            raise Exception.Create('É obrigatório que o evento possua fórmula.');

          { 3. Assume o retorno da fórmula com resultado do cálculo. }
          cValor := eFormula.AsDouble;

        end;

        { O valor calculado ser acumulado internamente}
        Result := Result + cValor;

        { e o processamento seguirá para o próximo item (evento) da lista.}
        Next;

      end;  // not Eof

    end;  // with cdEvento

  finally
    eFormula.Free;
    cdEvento.Free;
  end;

end;  // function GN() - Gratificação Natalina (13o. salário)

{ Calculo do Imposto de Renda: 27/02/2008 }
function TkCalculador.IRRF( Incidencia: Integer): Double;
var
  iQtde, iLimite: Integer;
  cValor: Currency;
begin

  // XI - Verbas tributadas para IRRF de folhas anteriores no mesmo mês caixa
  Result := XI( Incidencia, MonthOf(pvCredito), YearOf(pvCredito));

  // TI - Verbas tributadas para IRRF da folha atual
  Result := Result + TotalIncidencia(Incidencia);

  // Dedução de dependentes
  iQtde := Dependente('R');
  iLimite := Trunc(TabelaGlobalItem( pvTabelaIRRF, 4));

  if (iQtde > iLimite) then
    iQtde := iLimite;

  cValor := TabelaGlobalItem( pvTabelaIRRF, 5);

  Result := Result - (iQtde*cValor);

  { Dedução de Aposentaria }
  iQtde := Trunc(TabelaGlobalItem(pvTabelaIRRF, 1)); // Idade de aposentadoria
  if ((TempoNascimento() div 12) >= iQtde) then
  begin
    cValor := TabelaGlobalItem( pvTabelaIRRF, 2); // Valor de dedução
    Result := Result - cValor;
  end;

  { Limite de isenção }
  cValor := TabelaGlobalItem( pvTabelaIRRF, 7);

  if (Result > cValor) then
  begin

    { Checar tabela - faixa - percentual e dedução }
    Result := TabelaGlobal( pvTabelaIRRF, Result);

    { Desconto do IRRF já descontado no mês-caixa }
    Result := Result - XE( pvEvento, MonthOf(pvCredito), YearOf(pvCredito));

    { Valor mínimo de retenção }
    cValor := TabelaGlobalItem( pvTabelaIRRF, 3);

    if (Result < cValor) then
      Result := 0.0;

  end else
    Result := 0.0;  // Isento

end;  // IRRF

// FE - Ferias
function TkCalculador.Ferias(): Double;
var
  SQL: TStringList;
  cdEvento: TClientDataSet;
  sSalario, sCalculo, sFormulaEvento, sFormulaLocal: String;
  iEvento: Integer;
  cValor, cMAA, cMM: Currency;
  eFormula: TAKExpression;

  function TTT( Valor, Calculo: String):Double;
  begin
    Result := TotalizadorPadrao( Valor, Calculo, pvEmpresa,
                                 pvFuncionario, iEvento, pvInicio, pvFim,
                                 EmptyStr, True, not pvStartTransaction);
  end;

begin

  cdEvento := TClientDataSet.Create(NIL);
  eFormula := TAKExpression.Create(NIL);
  SQL      := TStringList.Create;

  try

    with eFormula do
    begin
      OnEvaluate := LocalEvaluate;
      OnVariable := LocalVariable;
      DataSetList.E := cdSequencia;
      DataSetList.F := cdFuncionario;
      DataSetList.L := cdFolha;
      DataSetList.R := cdRescisao;
    end;

    Result := 0.0;
    cMAA := MAA();  { Meses de Admissao no Ano }
    cMM := MM();    { Meses para Média }

    { Os eventos encontrados são colocados em uma lista que será percorrida item a item }
    with cdEvento do
    begin

      First;

      while not Eof do
      begin

        iEvento  := FieldByName('IDEVENTO').AsInteger;
        sSalario := FieldByName('TIPO_SALARIO').AsString;
        sCalculo := FieldByName('TIPO_CALCULO').AsString;
        sFormulaEvento := FieldByName('FORMULA_EVENTO').AsString;
        sFormulaLocal := FieldByName('FORMULA_LOCAL').AsString;

        eFormula.Text := EmptyStr;
        cValor := 0.0;

        { SALARIO FIXO }

        if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_CONTRA_PARTIDA) then
        begin

          { VALOR_CALCULADO_NO_ULTIMO_MES / 12 * MAA }
          cValor := TTT('C', 'U');

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_VALOR_INFORMADO) then
        begin

          { VALOR_CALCULADO_NO_ULTIMO_MES / 12 * MAA }
          cValor := TTT('C', 'U');

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_HORA_TRABALHADA) then
        begin

          { ( VALOR_INFORMADO_NO_ULTIMO_MES * HT * MT ) / 12 * MAA }
          cValor := TTT('I', 'U');
          cValor := cValor * HoraNormal() * pvMultiplicador;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_DIA_TRABALHADO) then
        begin

          { ( VALOR_INFORMADO_NO_ULTIMO_MES * DT * MT ) / 12 * MAA }
          cValor := TTT('I', 'U');
          cValor := cValor * (SalarioMensal()/30) * pvMultiplicador;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

        end else if (sSalario = TS_SALARIO_FIXO) and (sCalculo = TC_FORMULA) then
        begin

          { 1. Considera o VALOR_INFORMADO_NO_ULTIMO_MES como VALOR_INFORMADO (VI); }
          pvInformado := TTT('I', 'U');

          if (sFormulaEvento <> EmptyStr) then
            eFormula.Text := sFormulaEvento
          else if (sFormulaLocal <> EmptyStr) then
            eFormula.Text := sFormulaLocal;

          if (eFormula.Text = EmptyStr) then
            raise Exception.Create('É obrigatório que o evento possua fórmula.');

          { 2. Processa a fórmula do evento; }
          cValor := eFormula.AsDouble;

          { 3. RESULTADO_DA_FORMULA / 12 * MAA. }
          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        { SALARIO VARIAVEL }

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_CONTRA_PARTIDA) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_VALOR_INFORMADO) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_HORA_TRABALHADA) then
        begin

          { (( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM) / 12 * MAA ) * HT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * HoraNormal() * pvMultiplicador;

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_DIA_TRABALHADO) then
        begin

          { (( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM) / 12 * MAA ) * DT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * (SalarioMensal()/30.0) * pvMultiplicador;

        end else if (sSalario = TS_SALARIO_VARIAVEL) and (sCalculo = TC_FORMULA) then
        begin

          { 1. Considera como VALOR INFORMADO (VI) a expressão:
               (TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA; }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

          pvInformado := cValor;

          { 2. Processa a fórmula do evento; }
          if (sFormulaEvento <> EmptyStr) then
            eFormula.Text := sFormulaEvento
          else if (sFormulaLocal <> EmptyStr) then
            eFormula.Text := sFormulaLocal;

          if (eFormula.Text = EmptyStr) then
            raise Exception.Create('É obrigatório que o evento possua fórmula.');

          { 3. Assume o retorno da fórmula com resultado do cálculo. }
          cValor := eFormula.AsDouble;

        { PRODUÇÃO / PEÇA / TAREFA }

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_CONTRA_PARTIDA) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_VALOR_INFORMADO) then
        begin

          { ( TOTAL_VALOR_CALCULADO_NO_PERIODO / MM ) / 12 * MAA }
          cValor := TTT('C', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_HORA_TRABALHADA) then
        begin

          { ( ( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA ) * HT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * HoraNormal() * pvMultiplicador;

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_DIA_TRABALHADO) then
        begin

          { ( ( TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA ) * DT * MT }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0)* cMAA;

          cValor := cValor * (SalarioMensal()/30.0) * pvMultiplicador;

        end else if (sSalario = TS_PRODUCAO) and (sCalculo = TC_FORMULA) then
        begin

          { 1. Considera como VALOR INFORMADO (VI) a expressão:
              (TOTAL_VALOR_INFORMADO_NO_PERIODO / MM ) / 12 * MAA; }
          cValor := TTT('I', 'A') / cMM;

          if (cMAA < 12.0) then
            cValor := (cValor / 12.0) * cMAA;

          pvInformado := cValor;

          { 2. Processa a fórmula do evento; }
          if (sFormulaEvento <> EmptyStr) then
            eFormula.Text := sFormulaEvento
          else if (sFormulaLocal <> EmptyStr) then
            eFormula.Text := sFormulaLocal;

          if (eFormula.Text = EmptyStr) then
            raise Exception.Create('É obrigatório que o evento possua fórmula.');

          { 3. Assume o retorno da fórmula com resultado do cálculo. }
          cValor := eFormula.AsDouble;

        end;

        { O valor calculado ser acumulado internamente}
        Result := Result + cValor;

        { e o processamento seguirá para o próximo item (evento) da lista.}
        Next;

      end;  // not Eof

    end;  // with cdEvento

  finally
    SQL.Free;
    eFormula.Free;
    cdEvento.Free;
  end;

end;  // Ferias()

{ Totalizador: 12/04/2004}

function TotalizadorPadrao( Valor, Calculo: String;
  Empresa, Funcionario, Evento: Integer;
  Inicio, Fim: TDateTime;
  TipoFolha: String;
  Totalizado: Boolean; const IniciarTransacao: Boolean): Double;
var
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  SQL := TStringList.Create;
  DataSet1 := TClientDataSet.Create(NIL);
  Result := 0.0;

  try

    if (Calculo = EmptyStr) then Calculo := 'SUM'
    else if (Calculo = 'A') then Calculo := 'SUM'
    else if (Calculo = 'Q') then Calculo := 'COUNT'
    else if (Calculo = 'M') then Calculo := 'AVG'
    else if (Calculo = 'X') then Calculo := 'MAX'
    else if (Calculo = 'N') then Calculo := 'MIN'
    else if (Calculo = 'U') then Calculo := EmptyStr // Ultima competencia
    else raise Exception.Create('O parametro "calculo" deve ser [Q,M,X,N,U]');

    if (Valor = EmptyStr) then Valor := 'CALCULADO'
    else if (Valor = 'C') then Valor := 'CALCULADO'
    else if (Valor = 'I') then Valor := 'INFORMADO'
    else if (Valor = 'T') then Valor := 'TOTALIZADO'
    else if (Valor = 'R') then Valor := 'REFERENCIA'
    else Exception.Create('O parametro "valor" deve ser [C,I,T,R]');

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    if (Calculo = EmptyStr)
      then SQL.Add('F.COMPETENCIA, SUM(C.'+Valor+')')
      else SQL.Add('  '+Calculo+'(C.'+Valor+')');

    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL C, F_FOLHA F');

    if (TipoFolha = EmptyStr) and Totalizado then
      SQL.Add(', F_FOLHA_TIPO T');

    SQL.Add('WHERE');
    SQL.Add('  C.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');
    SQL.Add('  AND C.IDEVENTO = :EVENTO');
    SQL.Add('  AND F.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND F.IDFOLHA = C.IDFOLHA');
    SQL.Add('  AND F.PERIODO_INICIO >= :INICIO');
    SQL.Add('  AND F.PERIODO_FIM <= :FIM');
    SQL.Add('  AND F.ARQUIVAR_X = 1');

    if (TipoFolha <> EmptyStr) then
      SQL.Add('  AND F.IDFOLHA_TIPO = :TIPO')
    else if Totalizado then
    begin
      SQL.Add('  AND T.IDFOLHA_TIPO = F.IDFOLHA_TIPO');
      SQL.Add('  AND T.TOTALIZAR_X = 1');
    end;

    if (Calculo = EmptyStr) then
      SQL.Add('GROUP BY 1');

    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text,
                     [Empresa, Funcionario, Evento, Inicio, Fim, TipoFolha], IniciarTransacao) then
      raise Exception.Create(kGetErrorLastSQL);

    if (Calculo = EmptyStr) then
    begin
      DataSet1.Last;
      Result := DataSet1.Fields[1].AsCurrency;
    end else
      Result := DataSet1.Fields[0].AsCurrency;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;  // TotalizadorPadrao

function Totalizador( Empresa, Total, Funcionario, Evento: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean): Double;
var
  SQL, SQL1, SQL2: TStringList;
  cdTotal, cdEvento, cdIncidencia, DataSet1: TClientDataSet;
  iTipoFolha, iEvento, iIncidencia: Integer;
  sWhere, sCalculo, sValor: string;
  bIT: Boolean;
  cValor: Currency;
begin

  Result := 0.0;

  bIT := IniciarTransacao;

  SQL  := TStringList.Create;
  SQL1 := TStringList.Create;
  SQL2 := TStringList.Create;

  DataSet1     := TClientDataSet.Create(NIL);
  cdTotal      := TClientDataSet.Create(NIL);
  cdEvento     := TClientDataSet.Create(NIL);
  cdIncidencia := TClientDataSet.Create(NIL);

  try

    sWhere := '(IDTOTAL = '+IntToStr(Total)+')';

    if not kOpenSQL( cdTotal, 'F_TOTALIZADOR', sWhere, [], bIT) then
      raise Exception.Create(kGetErrorLastSQL);

    if (cdTotal.RecordCount = 0) then
      raise Exception.CreateFmt( 'Totalizador "%d" não existe.', [Total]);

    iEvento     := kCountSQL( 'F_TOTALIZADOR_EVENTO', sWhere, bIT);
    iTipoFolha  := kCountSQL( 'F_TOTALIZADOR_FOLHA',
                              sWhere+' AND (ATIVO_X = 1)', bIT);
    iIncidencia := kCountSQL( 'F_TOTALIZADOR_INCIDENCIA',
                              sWhere+' AND (ATIVO_X = 1)', bIT);

    if (iEvento = 0) and (iIncidencia = 0) then
    begin
      if (Evento = 0) then
        raise Exception.Create('Erro no totalizador no. '+IntToStr(Total)+sLineBreak+
                               'Não é possível realizar o cálculo.'+sLineBreak+
                               'Faltar informar eventos ou incidências.');
    end else
      Evento :=  0;  // Não considera o evento informado

    sCalculo := cdTotal.FieldByName('CALCULO').AsString;
    sValor   := cdTotal.FieldByName('VALOR').AsString;

    if      (sCalculo = 'A') then sCalculo := 'SUM'
    else if (sCalculo = 'M') then sCalculo := 'AVG'
    else if (sCalculo = 'N') then sCalculo := 'MIN'
    else if (sCalculo = 'Q') then sCalculo := 'COUNT'
    else if (sCalculo = 'X') then sCalculo := 'MAX'
    else if (sCalculo = 'U') then sCalculo := EmptyStr
    else raise Exception.Create('O campo "calculo" deve ser [A,Q,M,N,X,U]');

    if      (sValor = 'C') then sValor := 'CALCULADO'
    else if (sValor = 'I') then sValor := 'INFORMADO'
    else if (sValor = 'T') then sValor := 'TOTALIZADO'
    else if (sValor = 'R') then sValor := 'REFERENCIA'
    else raise Exception.Create('O campo "valor" deve ser [C,I,T,R]');

    SQL1.BeginUpdate;
    SQL1.Add('SELECT');
    if (sCalculo = EmptyStr) then
      SQL1.Add('F.COMPETENCIA, SUM(C.'+sValor+') AS VALOR')
    else
      SQL1.Add('  '+sCalculo+'(C.'+sValor+') AS VALOR');
    SQL1.Add('FROM');
    SQL1.Add('  F_CENTRAL C, F_FOLHA F');
    SQL1.Add('WHERE');
    SQL1.Add('  C.IDEMPRESA = '+IntToStr(Empresa));
    SQL1.Add('  AND C.IDFUNCIONARIO = '+IntToStr(Funcionario));
    SQL1.EndUpdate;

    SQL2.BeginUpdate;
    SQL2.Add('  AND (F.IDEMPRESA = C.IDEMPRESA)');
    SQL2.Add('  AND (F.IDFOLHA = C.IDFOLHA)');
    SQL2.Add('  AND (F.PERIODO_INICIO >= :INICIO AND F.PERIODO_FIM <= :FIM)');

    SQL2.Add('  AND (F.ARQUIVAR_X = 1)');

    if (iTipoFolha = 0) then
    begin
      SQL2.Add('  AND (F.IDFOLHA_TIPO IN (');
      SQL2.Add('        SELECT IDFOLHA_TIPO FROM F_FOLHA_TIPO');
      SQL2.Add('        WHERE (TOTALIZAR_X = 1)');
      SQL2.Add('      ))');
    end else
    begin
      SQL2.Add('  AND (F.IDFOLHA_TIPO IN (');
      SQL2.Add('        SELECT IDFOLHA_TIPO FROM F_TOTALIZADOR_FOLHA');
      SQL2.Add('        WHERE IDTOTAL = '+IntToStr(Total)+' AND ATIVO_X = 1');
      SQL2.Add('      ))');
    end;

    if (sCalculo = EmptyStr) then
      SQL2.Add('GROUP BY 1');

    SQL2.EndUpdate;

    if (Evento > 0) then  // Considera apenas este evento (que foi informado)
    begin

      SQL.BeginUpdate;
      SQL.Clear;
      SQL.AddStrings(SQL1);
      SQL.Add('  AND (C.IDEVENTO = :EVENTO)');
      SQL.AddStrings(SQL2);
      SQL.EndUpdate;

      if not kOpenSQL( DataSet1, SQL.Text, [Evento, Inicio, Fim], bIT) then
        raise Exception.Create(EmptyStr);

      if (sCalculo = EmptyStr) then
        DataSet1.Last;

      Result := DataSet1.FieldByName('VALOR').AsCurrency;

    end;  // Evento > 0

    if (iEvento > 0) then
    begin

      if not kOpenTable( cdEvento, 'F_TOTALIZADOR_EVENTO', sWhere, bIT) then
        raise Exception.Create(EmptyStr);

      SQL.BeginUpdate;
      SQL.Clear;
      SQL.AddStrings(SQL1);
      SQL.Add('  AND (C.IDEVENTO = :EVENTO)');
      SQL.AddStrings(SQL2);
      SQL.EndUpdate;

      cdEvento.First;

      while not cdEvento.Eof do
      begin

        iEvento := cdEvento.FieldByName('IDEVENTO').AsInteger;

        if not kOpenSQL( DataSet1, SQL.Text,
                         [iEvento, Inicio, Fim], bIT) then
          raise Exception.Create(EmptyStr);

        if (sCalculo = EmptyStr) then
          DataSet1.Last;

        cValor := DataSet1.FieldByName('VALOR').AsCurrency;

        case cdEvento.FieldByName('OPERACAO').AsInteger of
          -1: Result := Result - cValor;
           1: Result := Result + cValor;
        end;

        cdEvento.Next;

      end;  // cdEvento.Eof

    end;  // iEvento > 0

    if (iIncidencia > 0) then
    begin

      sWhere := '(IDTOTAL = '+IntToStr(Total)+') AND (ATIVO_X = 1) AND '+
                '( (PROVENTOS_X = 1) OR (DESCONTOS_X = 1) )';

      if not kOpenTable( cdIncidencia,
                         'F_TOTALIZADOR_INCIDENCIA', sWhere, bIT) then
        raise Exception.Create(EmptyStr);

      cdIncidencia.First;

      while not cdIncidencia.Eof do
      begin

        if (cdIncidencia.FieldByName('DESCONTOS_X').AsInteger = 1) and
           (cdIncidencia.FieldByName('PROVENTOS_X').AsInteger = 1) then
          sWhere := 'TIPO_EVENTO IN ('+QuotedStr('D')+','+QuotedStr('P')+')'
        else if (cdIncidencia.FieldByName('PROVENTOS_X').AsInteger = 1) then
          sWhere := 'TIPO_EVENTO = '+QuotedStr('P')
        else if (cdIncidencia.FieldByName('DESCONTOS_X').AsInteger = 1) then
          sWhere := 'TIPO_EVENTO = '+QuotedStr('D');

        iIncidencia := cdIncidencia.FieldByName('IDINCIDENCIA').AsInteger;
        sWhere := '('+sWhere+') AND (INC_'+kStrZero(iIncidencia,2)+'_X = 1)';

        SQL.BeginUpdate;
        SQL.Clear;
        SQL.AddStrings(SQL1);
        SQL.Add('  AND C.IDEVENTO IN');
        SQL.Add('      (SELECT IDEVENTO FROM F_EVENTO WHERE '+sWhere+')');
        SQL.AddStrings(SQL2);
        SQL.EndUpdate;

        if not kOpenSQL( DataSet1,  SQL.Text, [Inicio, Fim], bIT) then
          raise Exception.Create(EmptyStr);

        if (sCalculo = EmptyStr) then
          DataSet1.Last;

        cValor := DataSet1.FieldByName('VALOR').AsCurrency;

        case cdIncidencia.FieldByName('OPERACAO').AsInteger of
          -1: Result := Result - cValor;
           1: Result := Result + cValor;
        end;

        cdIncidencia.Next;

      end; // cdIncidencia.Eof

    end;  // iIncidencia > 0

  finally
    SQL.Free;
    SQL1.Free;
    SQL2.Free;
    cdEvento.Free;
    cdIncidencia.Free;
    cdTotal.Free;
    DataSet1.Free;
  end;

end;  // Totalizador


{ Base de Acumulacao: 01/06/2004}

function BaseAcumulacao( GE, Empresa, Folha, Base, Funcionario, Evento: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean ): Double;
const
  C_DESCONSIDERAR = 'D';
  C_CONSIDERAR = 'C';
  C_ACUMULADO = 'A';
  C_CONTAGEM = 'Q';
  C_MEDIA = 'M';
  C_MAXIMO = 'X';
  C_MINIMO = 'N';
var
  SQL: TStringList;
  cdBase, cdTotal, cdFolha: TClientDataSet;
  sCalculo, sValor, sRegime, sCompetencia13, sSemValor, sWhere: string;
  bTotalizar, bEvento: Boolean;
  i, iCiclo, iMesInicial, iAno, iMes: Integer;

  procedure CalculoBase( DataSet: TDataSet; var Valor: Double);
  begin

    if (sCalculo = C_CONTAGEM) then
      Valor := Valor + 1
    else if (sCalculo = C_MINIMO) then
    begin
      if (DataSet.FieldByName('VALOR').AsCurrency > 0) then
      begin
        if (Valor = 0.00) then
          Valor := DataSet.FieldByName('VALOR').AsCurrency;
        Valor := Min( Valor, DataSet.FieldByName('VALOR').AsCurrency);
      end;
    end else if (sCalculo = C_MAXIMO) then
      Valor := Max( Valor, DataSet.FieldByName('VALOR').AsCurrency)
    else // Acumulado ou Media
      Valor := Valor + DataSet.FieldByName('VALOR').AsCurrency;

    i := i + 1;

  end;

begin

  SQL     := TStringList.Create;
  cdBase  := TClientDataSet.Create(NIL);
  cdTotal := TClientDataSet.Create(NIL);
  cdFolha := TClientDataSet.Create(NIL);

  Result  := 0.0;

  try

    sWhere := 'IDGE = '+IntToStr(GE)+' AND IDBASE = '+IntToStr(Base);
    Inicio := FirstDayOfMonth(Inicio);

    if not kOpenSQL( cdBase, 'F_BASE', sWhere, []) then
      raise Exception.Create(EmptyStr);

    if not cdBase.Active or (cdBase.RecordCount = 0) then
      raise Exception.Create('Base de Acumulação No. '+IntToStr(Base)+' não existe.');

    bTotalizar := (kCountSQL('F_BASE_FOLHA', sWhere, IniciarTransacao) = 0);
    bEvento    := (kCountSQL('F_BASE_EVENTO', sWhere, IniciarTransacao) = 0);

    sCalculo   := cdBase.FieldByName('CALCULO').AsString;
    sValor     := cdBase.FieldByName('VALOR').AsString;

    { CICLO: Quantidade de meses de acumulação da base.
      Se você informar 0 (zero), o ciclo de meses será indefinido.
      Se você informar 1 (um), o ciclo de um mês.
      Se você informar 2 (dois), o ciclo será de 2 meses. E assim por diante. }

    iCiclo := cdBase.FieldByName('CICLO').AsInteger;

    { REGIME: Quando o ciclo for de 1 (um) mês, pode-se escolher entre os
      regimes de competência ou de caixa, ou seja, pelo mês de competência da
      folha ou pelo mês de crédito da folha de pagamento. Para
      ciclos maiores que 1 (um) mês, o regime sempre será por competência. }

    sRegime := cdBase.FieldByName('REGIME').AsString; // Competência ou Caixa

    if (iCiclo > 1) then
      sRegime := 'C';  // Competencia

    { MÊS INICIAL: Para ciclos igual ou maior que 12 (doze) meses, a base
      necessita do  mês de partida. O mês inicial indica o mês a partir da qual
      a base será mantida atualizada. }

    if (iCiclo < 12) then
      iMesInicial := 0
    else
      iMesInicial := cdBase.FieldByName('MES_INICIAL').AsInteger;

    { COMPETÊNCIA 13: Informa ao sistema como tratar os valores das folhas de
      competência 13. Os valores possiveis para este campo são:

      * Desconsiderar - Não pesquisa os valores da competência 13;
      * Integrar - Pesquisa os valores da competência 13, somando-os à competência 12. }

    sCompetencia13 := cdBase.FieldByName('COMPETENCIA_13').AsString;

    { MESES SEM VALOR: Diz ao sistema como proceder quando não existirem
      valores para determinados meses no histórico pesquisado. Esta
      informação é importante porque influencia o ciclo e o resultado da base,
      principalmete quando o "Cálculo" for uma "Média" ou "Contagem".

      Os valores possíveis são "Considerar" ou "Desconsiderar". }

    sSemValor := cdBase.FieldByName('MES_SEM_VALOR').AsString;

    // Inicia o processamento da base

    if (sValor = EmptyStr)          then sValor := 'CALCULADO'
    else if (sValor[1] = 'I') then sValor := 'INFORMADO'
    else if (sValor[1] = 'T') then sValor := 'TOTALIZADO'
    else if (sValor[1] = 'R') then sValor := 'REFERENCIA'
    else sValor := 'CALCULADO';

    SQL.BeginUpdate;
    SQL.Add('SELECT');

    if (sRegime = 'C') then // Regime - Competencia
    begin
      SQL.Add('  EXTRACT( YEAR FROM F.PERIODO_FIM) AS ANO, F.MES,');
    end else
    begin                   // Regime - Caixa
      SQL.Add('  EXTRACT( YEAR FROM F.DATA_CREDITO) AS ANO,');
      SQL.Add('  EXTRACT( MONTH FROM F.DATA_CREDITO) AS MES,');
    end;

    if bEvento then
      SQL.Add('  SUM(C.'+sValor+') AS VALOR')
    else
      SQL.Add('  SUM(C.'+sValor+'*E.REFERENCIA) AS VALOR');

    SQL.Add('FROM');

    if not bEvento then
      SQL.Add('  F_BASE_EVENTO E,');

    SQL.Add('  F_CENTRAL C, F_FOLHA F');

    SQL.Add('WHERE');

    if bEvento then
      SQL.Add('  C.IDEVENTO = '+IntToStr(Evento))
    else begin
      SQL.Add(' E.IDGE = '+IntToStr(GE));
      SQL.Add(' AND E.IDBASE = '+IntToStr(Base));
      SQL.Add(' AND C.IDEVENTO = E.IDEVENTO');
    end;

    SQL.Add('  AND C.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');

    SQL.Add('  AND F.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND F.IDFOLHA = C.IDFOLHA');
    SQL.Add('  AND (F.PERIODO_INICIO >= :INICIO AND');
    SQL.Add('       F.PERIODO_FIM <= :FIM)');

    if (sCompetencia13 = C_DESCONSIDERAR) then
      SQL.Add('  AND F.COMPETENCIA < 13');

    if not bTotalizar then
    begin
      SQL.Add('  AND F.IDFOLHA_TIPO IN');
      SQL.Add('      (SELECT IDFOLHA_TIPO FROM F_BASE_FOLHA');
      SQL.Add('       WHERE '+sWhere+')');
    end;

    SQL.Add('GROUP BY 1, 2');
    SQL.EndUpdate;

    if not kOpenSQL( cdTotal, SQL.Text,
                     [Empresa, Funcionario, Inicio, Fim], IniciarTransacao) then
      raise Exception.Create(EmptyStr);

    // Lista de Folhas de Pagamentos

    SQL.BeginUpdate;
    SQL.Clear;

    SQL.Add('SELECT');

    if (sRegime = 'C') then // Regime - Competencia
    begin
      SQL.Add('  EXTRACT(YEAR FROM F.PERIODO_FIM) AS ANO, F.MES,');
    end else
    begin                   // Regime - Caixa
      SQL.Add('  EXTRACT(YEAR FROM F.DATA_CREDITO) AS ANO,');
      SQL.Add('  EXTRACT(MONTH FROM F.DATA_CREDITO) AS MES,');
    end;

    SQL.Add(' 0.0 AS VALOR');

    SQL.Add('FROM');
    SQL.Add('  F_FOLHA F');

    SQL.Add('WHERE');
    SQL.Add('  F.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND F.IDFOLHA <> :FOLHA');
    SQL.Add('  AND (F.PERIODO_INICIO >= :INICIO AND');
    SQL.Add('       F.PERIODO_FIM <= :FIM)');

    if not bTotalizar then
    begin
      SQL.Add('  AND F.IDFOLHA_TIPO IN');
      SQL.Add('      (SELECT IDFOLHA_TIPO FROM F_BASE_FOLHA');
      SQL.Add('       WHERE '+sWhere+')');
    end;

    SQL.EndUpdate;

    if not kOpenSQL( cdFolha, SQL.Text,
                     [Empresa, Folha, Inicio, Fim], IniciarTransacao) then
      raise Exception.Create(EmptyStr);

    cdFolha.IndexFieldNames := 'ANO;MES';

    // -----------------------------------------

    with cdTotal do
    begin

      IndexFieldNames := 'ANO;MES';
      First;

      while not Eof do
      begin

        iMes := FieldByName('MES').AsInteger;
        iAno := FieldByName('ANO').AsInteger;

        if cdFolha.Locate( 'ANO;MES', VarArrayOf( [iAno, iMes]), []) then
        begin
          cdFolha.Edit;
          cdFolha.FieldByName('VALOR').AsCurrency := FieldByName('VALOR').AsCurrency;
          cdFolha.Post;
        end;

        Next;

      end;

    end;

    // Calcular o valor da base propriamente dita

    with cdFolha do
    begin

      if (sSemValor = C_DESCONSIDERAR) then { Retirar os meses sem valor }
      begin
        First;
        while not Eof do
        begin
          if (FieldByName('VALOR').AsCurrency = 0.0) then
            Delete
          else
            Next;
        end;
      end;

      Result := 0.0;
      i      := 0;

      if (iCiclo = 0) then
      begin

        { Ciclo indefinido - Considera todos os meses pesquisados }

        First;

        while (not Eof) do
        begin
          CalculoBase( cdFolha, Result);
          Next;
        end;

      end else if (iCiclo < 12) then
      begin

        { Se o "ciclo" é menor que 12 (doze) o "mês inicial" é 0 (zero),
          então considera os últimos "nn" meses }

        Last;

        while (not Bof) and (iCiclo > 0) do
        begin
          CalculoBase( cdFolha, Result);
          iCiclo := iCiclo - 1;
          Prior;
        end;

      end else  { iCiclo >= 12 }
      begin

        { Se o "ciclo" é maior ou igual a 12 (doze), considera o "mes inicial" }

        Last;

        while (not Bof) do
        begin
          CalculoBase( cdFolha, Result);
          { Chegou-se ao mes inicial encerra a pesquisa }
          if (FieldByName('MES').AsInteger = iMesInicial) then
            Break;
          Prior;
        end;

      end;

    end;  // with cdFolha

    if (sCalculo = C_MEDIA) then
      if (i = 0) then Result := 0.0
                 else Result := (Result/i);

  finally
    SQL.Free;
    cdBase.Free;
    cdTotal.Free;
    cdFolha.Free;
  end;

end;  // BaseAcumulacao

end.
