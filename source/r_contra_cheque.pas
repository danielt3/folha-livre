{
Projeto FolhaLivre - Folha de Pagamento Livre
Impressão e visualização de Contra-Cheques

Copyright (c) 2002-2007 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

// Alterações
{
18/03/2007 - Adicionado o filtro por funcionário
30/12/2003 - Formulário de filtragem/configuração - *Allan Lima*
12/12/2003 - Moldura do Contra-Cheque - edimilson-edimilson@softvaires.com.br
}

unit r_contra_cheque;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QTypes, QForms, QGraphics, QControls, QMask, QExtCtrls, QStdCtrls,
  QDBCtrls, QAKPrint,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Forms, Graphics, Controls, Mask, ExtCtrls, StdCtrls,
  DBCtrls, AKPrint,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient, Variants;

procedure CriaContraCheque( Empresa, Folha: Integer);

procedure ImprimeContraCheque( Empresa, Folha, Funcionario, Lotacao,
  Cargo: Integer; Recurso, Tipo, Ordem: String; Moldura, Imprimir: Boolean);

implementation

uses flotacao, fcargo, fdb, ftext, fsuporte, ftipo, frecurso, futil;

const
  C_AUTO_EDIT = True;

type
  TFrmContraCheque = class(TForm)
  protected
    DataSet1: TClientDataSet;
    DataSource1: TDataSource;
    pnlControle: TPanel;
    btnImprimir: TButton;
    btnCancelar: TButton;
    btnVisualizar: TButton;
    pnlConfig: TPanel;

    gpFuncionario: TGroupBox;
    dbFuncionarioX: TCheckBox;
    dbFuncionario: TDBEdit;
    dbFuncionario2: TDBEdit;

    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacao: TDBEdit;
    dbLotacao2: TDBEdit;

    gpCargo: TGroupBox;
    dbCargoX: TCheckBox;
    dbCargo: TDBEdit;
    dbCargo2: TDBEdit;

    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipo: TDBEdit;
    dbTipo2: TDBEdit;

    gpRecurso: TGroupBox;
    dbRecursoX: TCheckBox;
    dbRecurso: TDBEdit;
    dbRecurso2: TDBEdit;

    gpOrdem: TRadioGroup;
    dbMoldura: TCheckBox;
    {$IFDEF VCL}
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    {$ENDIF}
    procedure dbLotacaoXClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    { Private declarations }
  private
    pvEmpresa: Integer;
    pvFolha: Integer;
    procedure CreateDB;
    procedure CreateControls;
    procedure CreateButtons;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

  TFPrint = class(TComponent)
  protected
    procedure CustomReportGenerate(Sender: TObject);
  private
    { Private declarations }
    FReport: TAKCustomReport;
    FPrinter: TAKPrinter;
    FFrame: Boolean;
    mtDetalhe, mtEmpresa, mtFolha: TClientDataSet;
    pvEmpresa, pvFolha,
    pvFuncionario, pvLotacao, pvCargo: Integer;
    pvOrdem, pvTipo, pvRecurso: String;

    procedure Processa;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Frame: Boolean read FFrame write FFrame default False;
  end;

procedure CriaContraCheque( Empresa, Folha:Integer);
begin

  if (Folha <= 0) then
    Exit;

  with TFrmContraCheque.CreateNew(Application) do
  try
    pvEmpresa := Empresa;
    pvFolha   := Folha;
    ShowModal;
  finally
    Free;
  end;

end;

{ Formulario de Filtragem para Contra Cheque}

{$IFDEF VCL}
procedure TFrmContraCheque.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (ActiveControl = dbFuncionario) and (Key = VK_RETURN) then
    PesquisaFuncionario( dbFuncionario.Text, pvEmpresa, DataSet1, Key, C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_RETURN) then
    PesquisaLotacao( dbLotacao.Text, pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_F12) then
    PesquisaLotacao( '', pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_RETURN) then
    PesquisaCargo( dbCargo.Text, pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_F12) then
    PesquisaCargo( '', pvEmpresa, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_RETURN) then
    PesquisaTipo( dbTipo.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_F12) then
    PesquisaTipo( '', DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_RETURN) then
    PesquisaRecurso( dbRecurso.Text, DataSet1, Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_F12) then
    PesquisaRecurso( '', DataSet1, Key, '', C_AUTO_EDIT);

  kKeyDown( Self, Key, Shift);

end;
{$ENDIF}

procedure TFrmContraCheque.dbLotacaoXClick(Sender: TObject);
var
  wControl: TControl;
  wCheck: TCheckBox;
begin

  wCheck   := TCheckBox(Sender);
  wControl := kGetTabOrder( wCheck.Parent, wCheck.TabOrder+1);

  if Assigned(wControl) and (wControl is TDBEdit) then
    with TDBEdit(wControl) do
    begin
      TabStop := not wCheck.Checked;
      if wCheck.Checked then
        ParentColor := True
      else
        Color := clWindow;
    end;  // with TDBEdit

end;

procedure TFrmContraCheque.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmContraCheque.btnImprimirClick(Sender: TObject);
var
  iFuncionario, iCargo, iLotacao: Integer;
  sRecurso, sTipo, sOrdem: String;
begin

  with DataSet1 do
  begin

    if State in [dsInsert,dsEdit] then
      Post;

    iFuncionario := -1;
    iLotacao := -1;
    sTipo := '';
    sRecurso := '';
    iCargo := -1;

    if not dbFuncionarioX.Checked then
      iFuncionario := FieldByName('IDFUNCIONARIO').AsInteger;

    if not dbLotacaoX.Checked then
      iLotacao := FieldByName('IDLOTACAO').AsInteger;

    if not dbTipoX.Checked then
      sTipo := FieldByName('IDTIPO').AsString;

    if not dbRecursoX.Checked then
      sRecurso := FieldByName('IDRECURSO').AsString;

    if not dbCargoX.Checked then
      iCargo := FieldByName('IDCARGO').AsInteger;

    sOrdem := gpOrdem.Items[gpOrdem.ItemIndex][1];

  end;  // with DataSet1

  ImprimeContraCheque( pvEmpresa, pvFolha, iFuncionario, iLotacao, iCargo,
                       sRecurso, sTipo, sOrdem, dbMoldura.Checked,
                       (Sender = btnImprimir) );

end;

constructor TFrmContraCheque.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  {$IFDEF VCL}
  BorderStyle := bsDialog;
  Ctl3D  := False;
  {$ENDIF}

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}

  Caption := 'Impressão de Contra-Cheques';
  ClientHeight := 400;
  ClientWidth := 450;

  Color  := $00E0E9EF;

  KeyPreview := True;
  Position := poScreenCenter;

  {$IFDEF VCL}
  OnKeyDown := FormKeyDown;
  {$ENDIF}

  CreateDB;   // Criacao dos componentes de acesso a dados
  CreateControls; // Criacao dos componentes de interface

end;

procedure TFrmContraCheque.CreateControls;
begin

  pnlConfig := TPanel.Create(Self);
  with pnlConfig do
  begin
    Parent := Self;
    Align := alTop;
    BevelOuter := bvNone;
    ParentColor := True;
  end;

  // Funcionario

  gpFuncionario := TGroupBox.Create(Self);

  with gpFuncionario do
  begin
    Parent := pnlConfig;
    Left := 8;
    Top := 8;
    Width := 420;
    Height := 70;
    Caption := 'Funcionário';
  end;

  dbFuncionarioX := TCheckBox.Create(Self);

  with dbFuncionarioX do
  begin
    Parent := gpFuncionario;
    Left := 8;
    Top := 19;
    Width := 120;
    Height := 17;
    Caption := 'Todos os &Funcionários';
    Checked := True;
    State := cbChecked;
    OnClick := dbLotacaoXClick;
  end;

  dbFuncionario := TDBEdit.Create(Self);

  with dbFuncionario do
  begin
    Parent := gpFuncionario;
    Left := 8;
    Top := 39;
    Width := 80;
    Height := 21;
    CharCase := ecUpperCase;
    DataField := 'IDFUNCIONARIO';
    DataSource := DataSource1;
    ParentColor := True;
    TabStop  := False;
  end;

  dbFuncionario2 := TDBEdit.Create(Self);

  with dbFuncionario2 do
  begin
    Parent := gpFuncionario;
    Left := dbFuncionario.Left + dbFuncionario.Width + 5;
    Top := dbFuncionario.Top;
    Width := 300;
    Height := dbFuncionario.Height;
    TabStop := False;
    DataField := 'FUNCIONARIO';
    DataSource := DataSource1;
    ParentColor := True;
    ReadOnly := True;
  end;

  // Lotacao

  gpLotacao := TGroupBox.Create(Self);

  with gpLotacao do
  begin
    kControlAssigned( gpFuncionario, gpLotacao);
    Caption := 'Lotação';
  end;

  dbLotacaoX := TCheckBox.Create(Self);

  with dbLotacaoX do
  begin
    Parent := gpLotacao;
    Left := 8;
    Top := 19;
    Width := 120;
    Height := 17;
    Caption := 'Todas as &Lotações';
    Checked := True;
    State := cbChecked;
    OnClick := dbLotacaoXClick;
  end;

  dbLotacao := TDBEdit.Create(Self);

  with dbLotacao do
  begin
    Parent := gpLotacao;
    Left := 8;
    Top := 39;
    Width := 80;
    Height := 21;
    CharCase := ecUpperCase;
    DataField := 'IDLOTACAO';
    DataSource := DataSource1;
    ParentColor := True;
    TabStop  := False;
  end;

  dbLotacao2 := TDBEdit.Create(Self);

  with dbLotacao2 do
  begin
    Parent := gpLotacao;
    Left := dbLotacao.Left + dbLotacao.Width + 5;
    Top := dbLotacao.Top;
    Width := 300;
    Height := dbLotacao.Height;
    TabStop := False;
    DataField := 'LOTACAO';
    DataSource := DataSource1;
    ParentColor := True;
    ReadOnly := True;
  end;

  // Cargo de Funcionario ***************************

  gpCargo := TGroupBox.Create(Self);

  with gpCargo do
  begin
    kControlAssigned( gpLotacao, gpCargo);
    Caption := 'Cargo';
  end;

  dbCargoX := TCheckBox.Create(Self);

  with dbCargoX do
  begin
    Parent := gpCargo;
    kControlAssigned( dbLotacaoX, dbCargoX);
    Caption := 'Todos os &Cargos';
    OnClick := dbLotacaoXClick;
  end;

  dbCargo := TDBEdit.Create(Self);

  with dbCargo do
  begin
    Parent := gpCargo;
    DataField := 'IDCARGO';
    kControlAssigned( dbLotacao, dbCargo);
  end;

  dbCargo2 := TDBEdit.Create(Self);

  with dbCargo2 do
  begin
    Parent := gpCargo;
    DataField := 'CARGO';
    kControlAssigned( dbLotacao2, dbCargo2);
  end;

  // Tipo de Funcionarios ***************************

  gpTipo := TGroupBox.Create(Self);

  with gpTipo do
  begin
    kControlAssigned( gpCargo, gpTipo);
    Caption := 'Tipo de &Funcionário';
  end;

  dbTipoX := TCheckBox.Create(Self);

  with dbTipoX do
  begin
    Parent := gpTipo;
    kControlAssigned( dbCargoX, dbTipoX);
    Caption := 'Todos os &Tipos';
    OnClick := dbLotacaoXClick;
  end;

  dbTipo := TDBEdit.Create(Self);

  with dbTipo do
  begin
    Parent := gpTipo;
    DataField := 'IDTIPO';
    kControlAssigned( dbCargo, dbTipo);
  end;

  dbTipo2 := TDBEdit.Create(Self);

  with dbTipo2 do
  begin
    Parent := gpTipo;
    DataField := 'TIPO';
    kControlAssigned( dbCargo2, dbTipo2);
  end;

  // Recurso para Pagamento do Funcionario

  gpRecurso := TGroupBox.Create(Self);

  with gpRecurso do
  begin
    kControlAssigned( gpTipo, gpRecurso);
    Caption := 'Recursos';
  end;

  dbRecursoX := TCheckBox.Create(Self);

  with dbRecursoX do
  begin
    Parent := gpRecurso;
    kControlAssigned( dbTipoX, dbRecursoX);
    Caption := 'Todos os &Recursos';
    OnClick := dbLotacaoXClick;
  end;

  dbRecurso := TDBEdit.Create(Self);

  with dbRecurso do
  begin
    Parent := gpRecurso;
    DataField := 'IDRECURSO';
    kControlAssigned( dbTipo, dbRecurso);
  end;

  dbRecurso2 := TDBEdit.Create(Self);

  with dbRecurso2 do
  begin
    Parent := gpRecurso;
    DataField := 'RECURSO';
    kControlAssigned( dbTipo2, dbRecurso2);
  end;

  // Opcoes Diversas ***************************

  gpOrdem := TRadioGroup.Create(Self);

  with gpOrdem do
  begin
    Parent := pnlConfig;
    Left := gpRecurso.Left;
    Top := gpRecurso.Top + gpRecurso.Height + 5;
    Width := 169;
    Height := 45;
    Caption := 'Cla&ssificação dos funcionários';
    Columns := 2;
    Items.Add('Nome');
    Items.Add('Código');
    ItemIndex := 0;
  end;

  dbMoldura := TCheckBox.Create(Self);

  with dbMoldura do
  begin
    Parent := pnlConfig;
    Left := gpOrdem.Left + gpOrdem.Width + 5;
    Top := gpOrdem.Top + Trunc(gpOrdem.Height/2);
    Width := 120;
    Height := 17;
    Caption := 'Mostrar Moldura';
    Checked := True;
    State := cbChecked;
  end;

  pnlConfig.Height := gpOrdem.Top + gpOrdem.Height + 5;

  CreateButtons;

  Self.ClientHeight := pnlConfig.Height + pnlControle.Height + 5;

end;

procedure TFrmContraCheque.CreateDB;
begin

  DataSet1 := TClientDataSet.Create(Self);

  with DataSet1 do
  begin
    FieldDefs.Add( 'IDFUNCIONARIO', ftString, 30);
    FieldDefs.Add( 'FUNCIONARIO', ftString, 50);
    FieldDefs.Add( 'IDLOTACAO', ftInteger);
    FieldDefs.Add( 'LOTACAO', ftString, 50);
    FieldDefs.Add( 'IDTIPO', ftString, 2);
    FieldDefs.Add( 'TIPO', ftString, 30);
    FieldDefs.Add( 'IDCARGO', ftInteger);
    FieldDefs.Add( 'CARGO', ftString, 50);
    FieldDefs.Add( 'IDRECURSO', ftString, 2);
    FieldDefs.Add( 'RECURSO', ftString, 30);
    CreateDataSet;
    Append;
  end;

  DataSource1 := TDataSource.Create(Self);
  DataSource1.AutoEdit := True;
  DataSource1.DataSet  := DataSet1;

end;  // CreateDB

procedure TFrmContraCheque.CreateButtons;
begin

  pnlControle := TPanel.Create(Self);
  with pnlControle do
  begin
    Parent := Self;
    Align := alBottom;
    BevelOuter := bvLowered;
    ParentColor := True;
  end;

  btnImprimir := TButton.Create(Self);
  with btnImprimir do
  begin
    Parent := pnlControle;
    Left := 172;
    Top := 8;
    Width := 75;
    Height := 25;
    Caption := '&Imprimir';
    OnClick := btnImprimirClick;
  end;

  btnVisualizar := TButton.Create(Self);
  with btnVisualizar do
  begin
    Parent  := btnImprimir.Parent;
    Left    := btnImprimir.Left + btnImprimir.Width + 10;
    Top     := btnImprimir.Top;
    Width   := btnImprimir.Width;
    Height  := btnImprimir.Height;
    Caption := '&Visualizar';
    OnClick := btnImprimirClick;
  end;

  btnCancelar := TButton.Create(Self);
  with btnCancelar do
  begin
    Parent  := btnVisualizar.Parent;
    Left    := btnVisualizar.Left + btnVisualizar.Width + 10;
    Top     := btnVisualizar.Top;
    Width   := btnVisualizar.Width;
    Height  := btnVisualizar.Height;
    Cancel  := True;
    Caption := 'Cancelar';
    OnClick := btnCancelarClick;
  end;

  pnlControle.Height := btnImprimir.Top + btnImprimir.Height + 10;

end;  // CreateButtons

{ Impressao }

constructor TFPrint.Create(AOwner: TComponent);
begin

  inherited;

  FPrinter := TAKPrinter.Create(Self);
  FPrinter.Zoom := zReal;

  FReport  := TAKCustomReport.Create(Self);
  FReport.Printer := FPrinter;

  mtEmpresa := TClientDataSet.Create(Self);
  mtFolha   := TClientDataSet.Create(Self);
  mtDetalhe := TClientDataSet.Create(Self);

  Frame := False;

end;

destructor TFPrint.Destroy;
begin
  mtFolha.Free;
  mtEmpresa.Free;
  mtDetalhe.Free;
  FReport.Free;
  FPrinter.Free;
  inherited;
end;

procedure TFPrint.Processa;
var
  SQL: TStringList;
begin

  SQL    := TStringList.Create;

  try

    if not kSQLSelectFrom( mtEmpresa, 'EMPRESA', pvEmpresa) then
      raise Exception.Create('');

    if not kSQLSelectFrom( mtFolha, 'F_FOLHA', pvEmpresa,
                          'IDFOLHA = '+IntToStr(pvFolha)) then
      raise Exception.Create('');

    SQL.BeginUpdate;
    SQL.Clear ;
    SQL.Add('SELECT');
    SQL.Add('  CF.IDFUNCIONARIO, P.NOME, P.CPF_CGC,');
    SQL.Add('  F.ADMISSAO, CF.SALARIO, CF.CARGA_HORARIA,');
    SQL.Add('  L.NOME LOTACAO, CG.NOME CARGO,');
    SQL.Add('  E.IDEVENTO, E.NOME EVENTO, ');
    SQL.Add('  E.TIPO_EVENTO, E.VALOR_HORA, ');
    SQL.Add('  C.INFORMADO, C.REFERENCIA, C.CALCULADO');
    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL_FUNCIONARIO CF, F_CENTRAL C,');
    SQL.Add('  FUNCIONARIO F, PESSOA P,');
    SQL.Add('  F_CARGO CG, F_LOTACAO L, F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  CF.IDEMPRESA = '+IntToStr(pvEmpresa));
    SQL.Add('  AND CF.IDFOLHA = '+IntToStr(pvFolha));

    if (pvFuncionario <> -1) then
      SQL.Add(' AND CF.IDFUNCIONARIO = '+IntToStr(pvFuncionario));

    if (pvLotacao <> -1) then
      SQL.Add(' AND CF.IDLOTACAO = '+IntToStr(pvLotacao));

    if (pvTipo <> '') then
      SQL.Add(' AND CF.IDTIPO = '+QuotedStr(pvTipo));

    if (pvRecurso <> '') then
      SQL.Add(' AND CF.IDRECURSO = '+QuotedStr(pvRecurso));

    if (pvCargo <>  -1) then
      SQL.Add(' AND CF.IDCARGO = '+IntToStr(pvCargo));

    SQL.Add('  AND C.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND C.IDFOLHA = CF.IDFOLHA');
    SQL.Add('  AND C.IDFUNCIONARIO = CF.IDFUNCIONARIO');

    SQL.Add('  AND F.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND F.IDFUNCIONARIO = CF.IDFUNCIONARIO');

    SQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND P.IDPESSOA = F.IDPESSOA');

    SQL.Add('  AND CG.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND CG.IDCARGO = CF.IDCARGO');

    SQL.Add('  AND L.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND L.IDLOTACAO = CF.IDLOTACAO');

    SQL.Add('  AND E.IDEVENTO = C.IDEVENTO');
    SQL.Add('  AND E.CONTRA_CHEQUE_X = 1');

    SQL.Add('ORDER BY');
    if (pvOrdem = 'N') then
      SQL.Add('P.NOME,');
    SQL.Add('CF.IDFUNCIONARIO, C.LIQUIDO DESC, C.SEQUENCIA');
    SQL.EndUpdate;

    if not kOpenSQL( mtDetalhe, SQL.Text) then
      raise Exception.Create('');

    if (mtDetalhe.RecordCount = 0) then
      raise Exception.Create('Não há dados a imprimir.');

  finally
    SQL.Free;
  end;

end; // Processa

//===========================================================

procedure ImprimeContraCheque( Empresa, Folha, Funcionario, Lotacao,
  Cargo: Integer; Recurso, Tipo, Ordem: String; Moldura, Imprimir: Boolean);
var
  Frm: TFPrint;
begin

  Frm := TFPrint.Create(NIL);

  try try

    with Frm do
    begin

      pvEmpresa := Empresa;
      pvFolha := Folha;
      pvFuncionario := Funcionario;
      pvLotacao := Lotacao;
      pvRecurso := Recurso;
      pvCargo := Cargo;
      pvTipo := Tipo;
      pvOrdem := Ordem;
      Frame := Moldura;

      Processa();

      FPrinter.Preview := not Imprimir;
      FReport.OnGenerate := CustomReportGenerate;
      FReport.Execute;

    end;

  except
    on E:Exception do
      if (E.Message <> '') then
        kErro('Erro na Impressão do Contra-Chque.'#13+E.Message);
  end;
  finally
    Frm.Free;
  end;

end;

procedure TFPrint.CustomReportGenerate(Sender: TObject);
const
  FMT_REF   = '###.##';
  FMT_VALOR = '##,###,##0.00';
  FMT_BASE  = ',0.00';

var
  lBaseNames, lBaseValues: TStringList;
  iCodigo: integer;
  sRubricaCodigo, sRubricaNome, sRubricaTipo,sRubricaVlHr: String;
  cSalario, cInformado, cReferencia, cValor, cVantagem, cDesconto: Currency;
  sEmpresa, sCGC, sPeriodo: String;
  dPeriodo1, dPeriodo2: TDateTime;
  bPrimeiro: Boolean;
  iLinha: Byte;

  function Formata(const Format: string; Value: Extended): string;
  begin
    Result := FormatFloat( Format, Value);
    Result := StringOfChar( #32, Length(Format)-Length(Result))+Result;
  end;

  function Formata2(const Format: string; Value: Extended): string;
  begin
    Result := FormatFloat( Format, Value);
    Result := StringOfChar( '*', Length(Format)-Length(Result))+Result;
  end;

  procedure Escreve( Linha, Coluna:Byte; Texto: String);
  begin
    FPrinter.EscribirStd( Coluna, Linha, Texto);
  end;

  function LinhaReal( Linha: Byte):Byte;
  begin
    if bPrimeiro then
      Result := Linha
    else
      Result := Linha + 32; // alterado para acertar impressora LX300 - Claudio - 05/08/2004
  end;

  procedure ImprimeCabecalho;
  var
    sLotacao, sCargo, sNome: String;
  begin

    if (not bPrimeiro) and (iCodigo <> 0) then
      FPrinter.NuevaPagina;

    bPrimeiro := not bPrimeiro;

    iCodigo  := mtDetalhe.FieldByName('IDFUNCIONARIO').AsInteger;
    sNome    := mtDetalhe.FieldByName('NOME').AsString;
    cSalario := mtDetalhe.FieldByName('SALARIO').AsCurrency;
    sLotacao := mtDetalhe.FieldByName('LOTACAO').AsString;
    sCargo   := mtDetalhe.FieldByName('CARGO').AsString;

    iLinha := 1;

    if Frame then
    begin
      // Montagem do cabeçalho - edimilson-edimilson@softvaires.com.br 11/12/2003
      Escreve( LinhaReal(iLinha),  2, '+' + StringOfChar( '-', 74) + '+');
      Escreve( LinhaReal(iLinha+1),  2, '|');
    end;

    Inc(iLinha);
    Escreve( LinhaReal(iLinha),  4, sEmpresa);

    if Frame then
    begin
      Escreve( LinhaReal(iLinha), 71, '|');
      Escreve( LinhaReal(iLinha+1),  2, '|');
    end;

    Inc(iLinha);

    // edimilson-edimilson@softvaires.com.br 10/12/2003
    Escreve( LinhaReal(iLinha),  4, sCGC);

    if Frame then
      Escreve( LinhaReal(iLinha), 77, '|');

    Escreve( LinhaReal(iLinha), 45, sPeriodo);
    Inc(iLinha);

    if Frame then
      Escreve( LinhaReal(iLinha),   2, '+'+StringOfChar('-',74)+'+');

    Inc(iLinha);

    if Frame then
      Escreve( LinhaReal(iLinha), 2, '|');

    Escreve( LinhaReal(iLinha), 4, IntToStr(iCodigo)+'-'+sNome);

    Escreve( LinhaReal(iLinha), 50, 'Cargo: '+sCargo);

    if Frame then
      Escreve( LinhaReal(iLinha), 77, '|');

    Inc(iLinha);

    if Frame then
    begin
      Escreve( LinhaReal(iLinha),    2, '+---+----------------------------+-------+----------------+----------------+');
      Escreve( LinhaReal(iLinha+1),  2, '|Cód| Descricao                  | Refer |    Proventos   |    Descontos   |');
      Escreve( LinhaReal(iLinha+2),  2, '+---+----------------------------+-------+----------------+----------------+');
    end;

    Inc( iLinha, 3);

  end;  // ImprimeCabecalho

  procedure ImprimeRodape;
  var
    x: Integer;
    s: String;
  begin


    if (iCodigo > 0) then
    begin

      if Frame then
      begin

        for x := iLinha to 21 do
        begin
          iLinha := X;
          Escreve( LinhaReal(iLinha),  2, '|');
          Escreve( LinhaReal(iLinha),  6, '|');
          Escreve( LinhaReal(iLinha), 35, '|');
          Escreve( LinhaReal(iLinha), 43, '|');
          Escreve( LinhaReal(iLinha), 60, '|');
          Escreve( LinhaReal(iLinha), 77, '|');
        end;

      end else
        iLinha := 23;

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha), 2, '+---+----------------------------+-------+----------------+----------------+');

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha),  2, '|');

      if Frame then
        Escreve( LinhaReal(iLinha), 43, '|');

      Escreve( LinhaReal(iLinha), 47, Formata( FMT_VALOR, cVantagem) );

      if Frame then
        Escreve( LinhaReal(iLinha), 60, '|');

      Escreve( LinhaReal(iLinha), 64, Formata( FMT_VALOR, cDesconto) );

      if Frame then
        Escreve( LinhaReal(iLinha), 77, '|');

      Inc(iLinha);

      if Frame then
      begin
        Escreve( LinhaReal(iLinha),  2, '|');
        Escreve( LinhaReal(iLinha), 43, '+----------------+----------------+');
      end;

      Inc(iLinha);

      if Frame then
      begin
        Escreve( LinhaReal(iLinha),  2, '|');
        Escreve( LinhaReal(iLinha), 43, '|   Liquido -> |');
      end;

      Escreve( LinhaReal(iLinha), 64, Formata( FMT_VALOR, cVantagem-cDesconto ) );

      if Frame then
        Escreve( LinhaReal(iLinha), 77, '|');

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha),  2, '+'+StringOfChar('-',40)+'+----------------+----------------+');

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha),  2, '|');

      s := '';

      for x := 0 to lBaseNames.Count - 1 do
        s := s + ' ' + PadRightChar( lBaseNames[x], 15);

      Escreve( LinhaReal(iLinha),  3, s);

      Inc(iLinha);

      s := '';
      
      for x := 0 to lBaseValues.Count - 1 do
        s := s + ' ' + PadCenter( lBaseValues[x], 15);

      Escreve( LinhaReal(iLinha),  3, s);

      if Frame then
        Escreve( LinhaReal(iLinha), 77, '|');

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha), 2, '+'+StringOfChar('-',74)+'+');

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha), 7, '     Declaro ter recebido a importancia discriminada neste recibo     ');

      Inc(iLinha);

      if Frame then
        Escreve( LinhaReal(iLinha), 7, '     Data:__/__/____   Assinatura:_______________________________     ');

     end;

     lBaseValues.Clear;
     lBaseValues.Clear;

     cVantagem := 0.0;   // edimilson-edimilson@softvaires.com.br 08/12/2003
     cDesconto := 0.0;   // edimilson-edimilson@softvaires.com.br 08/12/2003

  end;  // ImprimeRodape

begin  // Rotina de impressao principal

  lBaseNames := TStringList.Create;
  lBaseValues := TStringList.Create;

  sEmpresa  := mtEmpresa.FieldByName('NOME').AsString;
  sCGC      := mtEmpresa.FieldByName('CPF_CGC').AsString;

  dPeriodo1 := mtFolha.FieldByName('PERIODO_INICIO').AsDateTime;
  dPeriodo2 := mtFolha.FieldByName('PERIODO_FIM').AsDateTime;

  sPeriodo := 'Periodo: '+FormatDateTime( 'dd/mm/yyyy', dPeriodo1)+' a '+
                          FormatDateTime( 'dd/mm/yyyy', dPeriodo2);

  bPrimeiro   := False;
  FPrinter.Comenzar;

  iLinha  := 0;
  iCodigo := 0;

  mtDetalhe.First;

  while True do
  begin

     if mtDetalhe.EOF then
      begin
       ImprimeRodape;  // Imprime linha de base de calculos
       Break;
     end;

     if (iCodigo <> mtDetalhe.FieldByName('IDFUNCIONARIO').AsInteger) then
     begin
       ImprimeRodape;
       ImprimeCabecalho;
     end;

     if (iLinha = LinhaReal(24)) then
       ImprimeCabecalho;

     sRubricaCodigo := mtDetalhe.FieldByName('IDEVENTO').AsString;
     sRubricaCodigo := PadRightChar( sRubricaCodigo, 3);
     sRubricaNome   := mtDetalhe.FieldByName('EVENTO').AsString;
     sRubricaTipo   := mtDetalhe.FieldByName('TIPO_EVENTO').AsString;
     sRubricaVlHr   := mtDetalhe.FieldByName('VALOR_HORA').AsString;
     cInformado     := mtDetalhe.FieldByName('INFORMADO').AsCurrency;
     cReferencia    := mtDetalhe.FieldByName('REFERENCIA').AsCurrency;
     cValor         := mtDetalhe.FieldByName('CALCULADO').AsCurrency;

     if (sRubricaTipo[1] in ['P','D']) then
     begin

       if Frame then
         Escreve( LinhaReal(iLinha), 2, '|');

       Escreve( LinhaReal(iLinha), 3, sRubricaCodigo);

       if Frame then
         Escreve( LinhaReal(iLinha), 6, '|');

       Escreve( LinhaReal(iLinha), 8, sRubricaNome);

       if Frame then
         Escreve( LinhaReal(iLinha), 35, '|');

       if (sRubricaVlHr[1] in ['H']) then
         Escreve( LinhaReal(iLinha), 36, Formata( FMT_REF, cInformado))
       else
         Escreve( LinhaReal(iLinha), 36, Formata( FMT_REF, cReferencia));

       if Frame then
       begin
         Escreve( LinhaReal(iLinha), 43, '|');
         Escreve( LinhaReal(iLinha), 57, '|');
       end;

       if (sRubricaTipo = 'P') then
       begin
         Escreve( LinhaReal(iLinha), 44, Formata( FMT_VALOR, cValor ) );
         cVantagem := cVantagem + cValor;
       end else
       begin
         Escreve( LinhaReal(iLinha), 58, Formata( FMT_VALOR, cValor ) );
         cDesconto := cDesconto + cValor;
       end;

       if Frame then
         Escreve( LinhaReal(iLinha), 71, '|');

       Inc(iLinha);

     end else
     begin
       lBaseNames.Add(  sRubricaNome);
       lBaseValues.Add( Formata( FMT_BASE, cValor) );
     end;

     mtDetalhe.Next;

   end;

end; // procedure CustomReportGenerate


end.
