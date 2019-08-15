{
Projeto FolhaLivre - Folha de Pagamento Livre
Relatorio de Folha Analitica

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

- 13/03/2007 - Bug fix: 1680181 - Resumo da Folha

}

unit r_analitica;

{$I flivre.inc}

interface

uses
  {$IFDEF VCL}Windows, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DBCtrls, Mask, Messages, AKPrint,
  {$ENDIF}
  {$IFDEF CLX}Qt, QGraphics, QControls, QForms, QDialogs,
  QStdCtrls, QExtCtrls, QDBCtrls, QMask, QAKPrint,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, DB, DBClient, Variants, fprogress;

type
  TResumoType = (rtSeparado, rtJunto, rtSem, rtSomente);

procedure CriaFolhaAnalitica( Empresa, Folha:Integer);

procedure ImprimeFolhaAnalitica( Empresa, Folha, Funcionario, Lotacao, Cargo: Integer;
  Recurso, Tipo, Ordem: String; Resumo: TResumoType; Imprimir: Boolean);

implementation

uses flotacao, fcargo, ftext, fdb, fsuporte, ftipo, frecurso, futil;

type
  TfrmFolhaAnalitica = class(TForm)
  protected
    cdConfig: TClientDataSet;
    dtsConfig: TDataSource;
    btnImprimir: TButton;
    btnCancelar: TButton;
    btnVisualizar: TButton;
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
    gpResumo: TRadioGroup;
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
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

  TFPrint = class(TComponent)
  protected
    { Private declarations }
    FProgresso: TFrmProgress;
    procedure CustomReportGenerate( Sender: TObject);
  private
    { Private declarations }
    FReport: TTbCustomReport;
    FPrinter: TTbPrinter;
    cdDetalhe, cdEmpresa, cdFolha, cdFuncionario, cdTemp: TClientDataSet;

    pvEmpresa, pvFolha, pvFuncionario, pvCargo, pvLotacao: Integer;
    pvRecurso, pvTipo, pvOrdem, pvFiltro: String;
    pvResumo: TResumoType;
    pvSQL: TStringList;

    function Processa():Boolean;

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

const
  C_AUTO_EDIT = TRUE;
  C_FMT_REF   = '###.##';
  C_FMT_VALOR = '###,##0.00';
  C_RESUMO = 'R E S U M O  D A  F O L H A';
  C_NOME = 20;
  C_ESPACO = 3;

procedure CriaFolhaAnalitica( Empresa, Folha:Integer);
begin

  if (Folha <= 0) then
    Exit;

  with TfrmFolhaAnalitica.CreateNew(Application) do
  try
    pvEmpresa := Empresa;
    pvFolha   := Folha;
    ShowModal;
  finally
    Free;
  end;

end;

{$IFDEF VCL}
procedure TfrmFolhaAnalitica.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (ActiveControl = dbFuncionario) and (Key = VK_RETURN) then
    PesquisaFuncionario( TDBEdit(ActiveControl).Text, pvEmpresa,
                     TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_RETURN) then
    PesquisaLotacao( TDBEdit(ActiveControl).Text, pvEmpresa,
                     TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_F12) then
    PesquisaLotacao( '', pvEmpresa, TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_RETURN) then
    PesquisaCargo( TDBEdit(ActiveControl).Text, pvEmpresa,
                   TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_F12) then
    PesquisaCargo( '', pvEmpresa, TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_RETURN) then
    PesquisaTipo( TDBEdit(ActiveControl).Text,
                   TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_F12) then
    PesquisaTipo( '',  TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_RETURN) then
    PesquisaRecurso( TDBEdit(ActiveControl).Text,
                     TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, '', C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_F12) then
    PesquisaRecurso( '',  TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, '', C_AUTO_EDIT);

  kKeyDown( Self, Key, Shift);

end;
{$ENDIF}

procedure TfrmFolhaAnalitica.dbLotacaoXClick(Sender: TObject);
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

procedure TfrmFolhaAnalitica.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmFolhaAnalitica.btnImprimirClick(Sender: TObject);
var
  iFuncionario, iCargo, iLotacao: Integer;
  sRecurso, sTipo, sOrdem: String;
  tResumo: TResumoType;
begin

  with cdConfig do
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

  end;  // with cdConfig do

  sOrdem := gpOrdem.Items[gpOrdem.ItemIndex][1];
  tResumo := TResumoType(gpResumo.ItemIndex);

  {$IFDEF VCL}
  ImprimeFolhaAnalitica( pvEmpresa, pvFolha, iFuncionario,
                         iLotacao, iCargo, sRecurso, sTipo,
                         sOrdem, tResumo, (Sender = btnImprimir) );

  {$ENDIF}

end;

constructor TfrmFolhaAnalitica.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  {$IFDEF VCL}
  BorderStyle := bsDialog;
  Ctl3D  := False;
  {$ENDIF}

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}

  Caption := 'Folha de Pagamento Analítica';
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

procedure TfrmFolhaAnalitica.CreateControls;
var
  i: Integer;
begin

  Self.ClientWidth := 450;

  // Funcionario

  gpFuncionario := TGroupBox.Create(Self);
  with gpFuncionario do
  begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Width := Self.ClientWidth - Left*2;
    Caption := 'Funcionário';
  end;

  dbFuncionarioX := TCheckBox.Create(Self);
  with dbFuncionarioX do
  begin
    Parent := gpFuncionario;
    Left := 8;
    Top := 20;
    Width := 120;
    Caption := 'Todos os &Funcionários';
    Checked := True;
    State := cbChecked;
    OnClick := dbLotacaoXClick;
  end;

  dbFuncionario := TDBEdit.Create(Self);
  with dbFuncionario do
  begin
    Parent := gpFuncionario;
    Left := dbFuncionarioX.Left;
    Top := dbFuncionarioX.Top + dbFuncionarioX.Height + 3;
    Width := 80;
    CharCase := ecUpperCase;
    DataField := 'IDFUNCIONARIO';
    DataSource := dtsConfig;
    ParentColor := True;
    TabStop  := False;
  end;

  dbFuncionario2 := TDBEdit.Create(Self);
  with dbFuncionario2 do
  begin
    Parent := gpFuncionario;
    Left := dbFuncionario.Left + dbFuncionario.Width + 5;
    Top := dbFuncionario.Top;
    Width := gpFuncionario.Width - (Left+dbFuncionario.Left);
    TabStop := False;
    DataField := 'NOME';
    DataSource := dtsConfig;
    ParentColor := True;
    ReadOnly := True;
  end;

  gpFuncionario.Height := dbFuncionario2.Top + dbFuncionario2.Height + 10;

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
    kControlAssigned(dbFuncionarioX, dbLotacaoX);
    Caption := 'Todas as &Lotações';
    OnClick := dbLotacaoXClick;
  end;

  dbLotacao := TDBEdit.Create(Self);
  with dbLotacao do
  begin
    Parent := gpLotacao;
    DataField := 'IDLOTACAO';
    kControlAssigned(dbFuncionario, dbLotacao);
  end;

  dbLotacao2 := TDBEdit.Create(Self);
  with dbLotacao2 do
  begin
    Parent := gpLotacao;
    DataField := 'LOTACAO';
    kControlAssigned(dbFuncionario2, dbLotacao2);
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
    Parent := gpRecurso.Parent;
    Left := gpRecurso.Left;
    Top := gpRecurso.Top + gpRecurso.Height + 5;
    Width := 130;
    Height := 45;
    Caption := 'Ordem dos funcionários';
    Items.Add('Nome');
    Items.Add('Código');
    Columns := Items.Count;
    ItemIndex := 0;
  end;

  gpResumo := TRadioGroup.Create(Self);
  with gpResumo do
  begin
    Parent :=  gpOrdem.Parent;
    Left := gpOrdem.Left + gpOrdem.Width + 5;
    Top := gpOrdem.Top;
    Width := (gpRecurso.Left + gpRecurso.Width) - gpResumo.Left;
    Height := gpOrdem.Height;
    Caption := 'Impressão do Resumo da Folha';
    Items.Add('Separado');
    Items.Add('Junto');
    Items.Add('Sem');
    Items.Add('Somente');
    Columns := Items.Count;
    ItemIndex := 0;
  end;

  btnCancelar := TButton.Create(Self);
  with btnCancelar do
  begin
    Parent := Self;
    Width := 100;
    Left := gpResumo.Left + gpResumo.Width - Width;
    Top := gpResumo.Top + gpResumo.Height + 10;
    Cancel  := True;
    Caption := 'Cancelar';
    Font.Style := [fsBold];
    OnClick := btnCancelarClick;
    i := TabOrder;
  end;

  btnVisualizar := TButton.Create(Self);
  with btnVisualizar do
  begin
    Parent  := btnCancelar.Parent;
    Width   := btnCancelar.Width;
    Left    := btnCancelar.Left - Width - 10;
    Top     := btnCancelar.Top;
    TabOrder := i;
    Font.Assign(btnCancelar.Font);
    Caption := '&Visualizar';
    OnClick := btnImprimirClick;
  end;

  btnImprimir := TButton.Create(Self);
  with btnImprimir do
  begin
    Parent  := btnVisualizar.Parent;
    Width   := btnVisualizar.Width;
    Left    := btnVisualizar.Left - Width - 10;
    Top     := btnVisualizar.Top;
    TabOrder := i;
    Font.Assign(btnVisualizar.Font);    
    Caption := '&Imprimir';
    OnClick := btnImprimirClick;
  end;

  Self.ClientHeight := btnImprimir.Top + btnImprimir.Height + 10;

end;

procedure TfrmFolhaAnalitica.CreateDB;
begin

  cdConfig := TClientDataSet.Create(Self);

  with cdConfig do
  begin
    FieldDefs.Add( 'IDFUNCIONARIO', ftInteger);
    FieldDefs.Add( 'NOME', ftString, 50);
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

  dtsConfig := TDataSource.Create(Self);
  dtsConfig.AutoEdit := True;
  dtsConfig.DataSet  := cdConfig;

end;  // CreateDB


//**************** RELATORIO ***********************************

procedure ImprimeFolhaAnalitica( Empresa, Folha, Funcionario, Lotacao, Cargo: Integer;
  Recurso, Tipo, Ordem: String; Resumo: TResumoType; Imprimir: Boolean);
var
  Frm: TFPrint;
begin

  kStartTransaction();

  Frm := TFPrint.Create(NIL);

  try try

    with Frm do
    begin

      pvFuncionario := Funcionario;
      pvEmpresa := Empresa;
      pvFolha   := Folha;

      pvOrdem   := Ordem;

      if (pvFuncionario <> -1) then  { Para um funcionario, não precisa de resumo nem de filtro }
      begin
        pvRecurso := '';
        pvLotacao := -1;
        pvTipo    := '';
        pvCargo   := -1;
        pvResumo  := rtSem;
      end else
      begin
        pvRecurso := Recurso;
        pvLotacao := Lotacao;
        pvTipo    := Tipo;
        pvCargo   := Cargo;
        pvResumo  := Resumo;
      end;

      Processa();

      FPrinter.Preview := not Imprimir;
      FReport.OnGenerate := CustomReportGenerate;
      FReport.Execute;

    end;
  except
    on E:Exception do
    begin
      if kInTransaction() then
       kRollbackTransaction();
      kErro('Erro na impressão da folha analitica'+#13+E.Message);
    end;
  end;
  finally
    Frm.Free;
    if kInTransaction() then
      kCommitTransaction();
  end;

end;

constructor TFPrint.Create(AOwner: TComponent);
begin
  inherited;

  FPrinter := TTbPrinter.Create(Self);
  FPrinter.FastFont := FPrinter.FastFont + [Comprimido];
  FPrinter.Zoom := zReal;

  FReport  := TTbCustomReport.Create(Self);
  FReport.Printer := FPrinter;

  cdEmpresa := TClientDataSet.Create(Self);
  cdFolha   := TClientDataSet.Create(Self);
  cdDetalhe := TClientDataSet.Create(Self);
  cdFuncionario := TClientDataSet.Create(Self);
  cdTemp := TClientDataSet.Create(Self);

  pvSQL := TStringList.Create;
  
  with cdDetalhe do
  begin
    // Coluna de Proventos
    FieldDefs.Add( 'P_CODIGO', ftInteger);
    FieldDefs.Add( 'P_NOME', ftString, 30);
    FieldDefs.Add( 'P_VALOR_HORA', ftString, 1);
    FieldDefs.Add( 'P_INFORMADO', ftCurrency);
    FieldDefs.Add( 'P_REFERENCIA', ftCurrency);
    FieldDefs.Add( 'P_VALOR', ftCurrency);
    // Coluna de Descontos
    FieldDefs.Add( 'D_CODIGO', ftInteger);
    FieldDefs.Add( 'D_NOME', ftString, 30);
    FieldDefs.Add( 'D_VALOR_HORA', ftString, 1);
    FieldDefs.Add( 'D_INFORMADO', ftCurrency);
    FieldDefs.Add( 'D_REFERENCIA', ftCurrency);
    FieldDefs.Add( 'D_VALOR', ftCurrency);
    // Coluna de Bases
    FieldDefs.Add( 'B_CODIGO', ftInteger);
    FieldDefs.Add( 'B_NOME', ftString, 30);
    FieldDefs.Add( 'B_VALOR_HORA', ftString, 1);
    FieldDefs.Add( 'B_INFORMADO', ftCurrency);
    FieldDefs.Add( 'B_REFERENCIA', ftCurrency);
    FieldDefs.Add( 'B_VALOR', ftCurrency);
    CreateDataSet;
  end;

  FProgresso := CriaProgress('');

  FProgresso.Rotulo.Visible := False;
  FProgresso.Bar.Align := alClient;
  FProgresso.Bar.Font.Size := FProgresso.Bar.Font.Size * 2;

end;

destructor TFPrint.Destroy;
begin
  FProgresso.Free;
  cdFolha.Free;
  cdEmpresa.Free;
  cdDetalhe.Free;
  cdFuncionario.Free;
  cdTemp.Free;
  pvSQL.Free;
  FReport.Free;
  FPrinter.Free;
  inherited;
end;

function TFPrint.Processa():Boolean;
var
  tmpCursor: TCursor;
  SQL: TStringList;
begin

  kSQLSelectFrom( cdEmpresa, 'EMPRESA', pvEmpresa, '', False);
  kSQLSelectFrom( cdFolha, 'F_FOLHA', pvEmpresa, 'IDFOLHA = '+IntToStr(pvFolha), False);

  SQL := TStringList.Create;
  Result  := False;

  tmpCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  CF.*, F.ADMISSAO,');
    SQL.Add('  P.NOME, P.CPF_CGC,');
    SQL.Add('  L.NOME LOTACAO, G.NOME CARGO,');
    SQL.Add('  S.NOME TIPO_SALARIO, T.NOME TIPO,');
    SQL.Add('  R.NOME RECURSO');
    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL_FUNCIONARIO CF, FUNCIONARIO F,');
    SQL.Add('  PESSOA P, F_CARGO G, F_LOTACAO L,');
    SQL.Add('  F_RECURSO R, F_TIPO T, F_SALARIO S');
    SQL.Add('WHERE');
    SQL.Add('  CF.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND CF.IDFOLHA = :FOLHA');

    pvFiltro := '';

    if (pvFuncionario <> -1) then
      pvFiltro := pvFiltro + ' AND CF.IDFUNCIONARIO = '+IntToStr(pvFuncionario);

    if (pvLotacao <> -1) then
      pvFiltro := pvFiltro + ' AND CF.IDLOTACAO = '+IntToStr(pvLotacao);

    if (pvCargo <> -1) then
      pvFiltro := pvFiltro + ' AND CF.IDCARGO = '+IntToStr(pvCargo);

    if (pvTipo <> '') then
      pvFiltro := pvFiltro + ' AND CF.IDTIPO = '+QuotedStr(pvTipo);

    if (pvRecurso <> '') then
      pvFiltro := pvFiltro + ' AND CF.IDRECURSO = '+QuotedStr(pvRecurso);

    if (pvFiltro <> EmptyStr) then
      SQL.Add(pvFiltro);

    SQL.Add('  AND F.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND F.IDFUNCIONARIO = CF.IDFUNCIONARIO');

    SQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND P.IDPESSOA = F.IDPESSOA');

    SQL.Add('  AND G.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND G.IDCARGO = CF.IDCARGO');

    SQL.Add('  AND L.IDEMPRESA = CF.IDEMPRESA');
    SQL.Add('  AND L.IDLOTACAO = CF.IDLOTACAO');

    SQL.Add('  AND R.IDRECURSO = CF.IDRECURSO');
    SQL.Add('  AND T.IDTIPO = CF.IDTIPO');
    SQL.Add('  AND S.IDSALARIO = CF.IDSALARIO');

    SQL.Add('ORDER BY');

    if (pvOrdem = 'N') then SQL.Add('P.NOME')
                       else SQL.Add('CF.IDFUNCIONARIO');

    SQL.EndUpdate;

    kOpenSQL( cdFuncionario, SQL.Text, [pvEmpresa,pvFolha], False);

    if (cdFuncionario.RecordCount = 0) then
      raise Exception.Create('Não há dados a imprimir.');

    if (pvResumo = rtSomente) then
      cdFuncionario.EmptyDataSet;

    if (pvResumo <> rtSem) then
    begin
      cdFuncionario.Append;
      cdFuncionario.FieldByName('IDFUNCIONARIO').AsInteger := 9999;
      cdFuncionario.FieldByName('NOME').AsString := 'R E S U M O  D A  F O L H A';
      cdFuncionario.Post;
    end;

    Result := True;

  finally
    SQL.Free;
    Screen.Cursor := tmpCursor;
  end;

end; // function Processa

procedure TFPrint.CustomReportGenerate(Sender: TObject);
var
  iMargem, iPaginaAtual, iLinhaAtual, iLinhaPorPagina, iMargemDireita: Integer;
  iFuncionario, iDependente, iCargaHoraria: Integer;
  sEmpresa, sTitulo, sSubTitulo, sCabecalhoColuna, Texto: String;
  cVantagem, cDesconto, cBase, cTotalVantagem, cTotalDesconto: Currency;
  sNome, sTipo, sRecurso, sTipoSalario, sSalario, sCPF, sLotacao, sFuncao: String;
  dAdmissao: TDateTime;
  cSalario, cSalarioMensal: Currency;

  function Formata( const Formato, Prefixo: string; Valor: Extended): string;
  begin
    if (Valor = 0) then
      Result := ''
    else
      Result := FormatFloat( Formato, Valor);
    Result := PadLeftChar( Result, Length(Formato), Prefixo[1]);
  end;

  procedure Escreve( Linha, Coluna:Byte; Texto: String);
  begin
    with FReport.Printer do
      Escribir( Coluna, Linha, Texto, FastFont );
  end;

  procedure CabecalhoFuncionario();
  begin

    with cdFuncionario do
    begin

      iFuncionario  := FieldByName('IDFUNCIONARIO').AsInteger;
      sNome         := FieldByName('NOME').AsString;
      sTipo         := FieldByName('TIPO').AsString;
      sRecurso      := FieldByName('RECURSO').AsString;
      sTipoSalario  := FieldByName('TIPO_SALARIO').AsString;
      sSalario      := FieldByName('IDSALARIO').AsString;
      sCPF          := FieldByName('CPF_CGC').AsString;
      iDependente   := FieldByName('DEPENDENTE_IR').AsInteger;
      sLotacao      := FieldByName('LOTACAO').AsString;
      sFuncao       := FieldByName('CARGO').AsString;
      dAdmissao     := FieldByName('ADMISSAO').AsDateTime;
      iCargaHoraria := FieldByName('CARGA_HORARIA').AsInteger;
      cSalario      := FieldByName('SALARIO').AsCurrency;
      cSalarioMensal := kSalarioNormal( cSalario, sSalario, iCargaHoraria);

      if (iFuncionario = 9999) then
      begin
        Escreve( iLinhaAtual, (iMargemDireita-iMargem-Length(sNome)) div 2, sNome);
        iLinhaAtual := iLinhaAtual + 2;
      end else
      begin

        Escreve( iLinhaAtual, iMargem,
                 Formata( '####', #32, iFuncionario)+' - '+
                 PadRightChar( sNome, 45, #32) + ' ' +
                 'CPF: '+PadRightChar( kFormatCPF(sCPF), 14, #32)+ ' ' +
                 'Admissao: '+ kIfThenStr( dAdmissao = 0, '  /  /    ',
                           FormatDateTime( 'dd/mm/yyyy', dAdmissao)) + ' ' +
                 'Lotacao: '+PadRightChar( sLotacao, 30, #32) ); //109

        Escreve( iLinhaAtual+1, iMargem,
                 kEspaco(1) +
                 PadRightChar( '('+sTipoSalario+')', 12, #32)+ ' ' +
                 'Tipo: '+PadRightChar( sTipo, 8, #32)+ ' '+
                 'Recs: '+PadRightChar( sRecurso, 8, #32)+ ' '+
                 'Salario:' + Formata( C_FMT_VALOR, '*', cSalario) + ' ' +
                 'Carga H.: ' + Formata( '###', #32, iCargaHoraria) + ' ' +
                 'Sal Mensal:' + Formata( C_FMT_VALOR, '*', cSalarioMensal) + ' ' +
                 'Dep.IR: '+Formata( '#0', #32, iDependente) + ' ' +
                 'Cargo: '+PadRightChar( sFuncao, 15, #32) );

        iLinhaAtual := iLinhaAtual + 3;

      end;

    end;  // with cdFuncionario

  end;  // CabecalhoFuncionario

  procedure Cabecalho;
  begin

    FReport.Printer.NuevaPagina;
    iPaginaAtual := iPaginaAtual + 1;

    Escreve( 2, iMargem, Copy( Application.Title, 1, Pos('-',Application.Title)-1));
    Escreve( 2, (iMargemDireita-iMargem-Length(sEmpresa)) div 2, sEmpresa );
    Escreve( 2, iMargemDireita-18, FormatDateTime('dd/mm/yyyy - hh:nn',Now) );

    Escreve( 3, (iMargemDireita-iMargem-Length(sTitulo)) div 2, sTitulo );
    Escreve( 3, iMargemDireita-8, 'Pag. '+kStrZero( iPaginaAtual, 3) );

    Escreve( 4, (iMargemDireita-iMargem-Length(sSubTitulo)) div 2, sSubTitulo);

    Escreve( 5, iMargem, Replicate('-', iMargemDireita)) ;
    Escreve( 6, iMargem, sCabecalhoColuna);
    Escreve( 7, iMargem, Replicate('-', iMargemDireita)) ;

    iLinhaAtual := 8;

  end;  // Cabecalho

  procedure LerEvento(Funcionario: Integer);
  var
    sNome, sTipo, sValorHora: String;
    iEvento: Integer;
    cInformado, cReferencia, cCalculado: Currency;
  begin

    if (Funcionario = 9999) then
      pvSQL.Clear;

    if (pvSQL.Count = 0) then
    begin

      pvSQL.BeginUpdate;
      pvSQL.Clear;
      pvSQL.Add('SELECT');
      pvSQL.Add('  E.IDEVENTO, E.NOME, E.TIPO_EVENTO, E.VALOR_HORA,');

      if (Funcionario = 9999)
        then pvSQL.Add('  0.0 AS INFORMADO, 0.0 AS REFERENCIA, SUM(C.CALCULADO) AS CALCULADO')
        else pvSQL.Add('  C.INFORMADO, C.REFERENCIA, C.CALCULADO');

      pvSQL.Add('FROM');
      if (Funcionario = 9999) then
        pvSQL.Add('  F_CENTRAL_FUNCIONARIO CF,');

      pvSQL.Add('  F_CENTRAL C, F_EVENTO E');

      pvSQL.Add('WHERE');

      if (Funcionario = 9999) then
      begin
        pvSQL.Add('  CF.IDEMPRESA = :EMPRESA AND CF.IDFOLHA = :FOLHA');
        if (pvFiltro <> EmptyStr) then
          pvSQL.Add(pvFiltro);
        pvSQL.Add('  AND C.IDEMPRESA = CF.IDEMPRESA AND C.IDFOLHA = CF.IDFOLHA');
        pvSQL.Add('  AND C.IDFUNCIONARIO = CF.IDFUNCIONARIO');
      end else
      begin
        pvSQL.Add('  C.IDEMPRESA = :EMPRESA AND C.IDFOLHA = :FOLHA');
        pvSQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');
      end;

      pvSQL.Add('  AND E.IDEVENTO = C.IDEVENTO');

      if (Funcionario = 9999)
        then pvSQL.Add('GROUP BY 1,2,3,4,5,6')
        else pvSQL.Add('ORDER BY E.IDEVENTO');

      pvSQL.EndUpdate;

    end;

    if (Funcionario = 9999)
      then kOpenSQL( cdTemp, pvSQL.Text, [pvEmpresa,pvFolha], False)
      else kOpenSQL( cdTemp, pvSQL.Text, [pvEmpresa,pvFolha,Funcionario], False);

    cdDetalhe.Close;
    cdDetalhe.CreateDataSet;

    cdTemp.First;

    while not cdTemp.EOF do
    begin

      iEvento     := cdTemp.FieldByName('IDEVENTO').AsInteger;
      sNome       := cdTemp.FieldByName('NOME').AsString;
      sTipo       := cdTemp.FieldByName('TIPO_EVENTO').AsString;
      sValorHora  := cdTemp.FieldByName('VALOR_HORA').AsString;
      cCalculado  := cdTemp.FieldByName('CALCULADO').AsCurrency;
      cInformado  := cdTemp.FieldByName('INFORMADO').AsCurrency;
      cReferencia := cdTemp.FieldByName('REFERENCIA').AsCurrency;

      if cdDetalhe.Locate( sTipo+'_CODIGO', NULL, []) then
        cdDetalhe.Edit
      else
        cdDetalhe.Append;

      cdDetalhe.FieldByName(sTipo+'_CODIGO').AsInteger      := iEvento;
      cdDetalhe.FieldByName(sTipo+'_NOME').AsString         := sNome;
      cdDetalhe.FieldByName(sTipo+'_VALOR_HORA').AsString   := sValorHora;
      cdDetalhe.FieldByName(sTipo+'_INFORMADO').AsCurrency  := cInformado;
      cdDetalhe.FieldByName(sTipo+'_REFERENCIA').AsCurrency := cReferencia;
      cdDetalhe.FieldByName(sTipo+'_VALOR').AsCurrency      := cCalculado;

      cdDetalhe.Post;

      cdTemp.Next;

    end; // while not EOF

  end;  // procedure LerEvento

  procedure RodapeFuncionario();
  var
    sLinha: String;
  begin

    sLinha :=
        kEspaco(3) + #32 +
        PadRightChar( 'TOTAL DE PROVENTOS', C_NOME, '.') + '.' +
        StringOfChar( '.', Length(C_FMT_REF)) + '.' +
        Formata( C_FMT_VALOR, '.', cTotalVantagem) +

        kEspaco(C_ESPACO) +

        kEspaco(3) + #32+
        PadRightChar( 'TOTAL DE DESCONTOS', C_NOME, '.') + '.' +
        StringOfChar( '.', Length(C_FMT_REF)) + '.' +
        Formata( C_FMT_VALOR, '.', cTotalDesconto) +

        kEspaco(C_ESPACO) +

        kEspaco(3) + #32+
        PadRightChar( 'LIQUIDO', C_NOME, '.') + '.' +
        StringOfChar( '.', Length(C_FMT_REF)) + '.' +
        Formata( C_FMT_VALOR, '.', cTotalVantagem-cTotalDesconto) ;

     Escreve( iLinhaAtual, iMargem, sLinha);
     Escreve( iLinhaAtual+1, iMargem, Replicate( '-', iMargemDireita)) ;

     iLinhaAtual := iLinhaAtual + 2;

     cTotalVantagem := 0.0;
     cTotalDesconto := 0.0;

  end;

begin

  iLinhaPorPagina := 60;
  iPaginaAtual    := 0;
  iMargemDireita  := 132;
  iMargem         := 1;

  sEmpresa   := cdEmpresa.FieldByName('NOME').AsString;
  sTitulo    := 'Endereco: '+cdEmpresa.FieldByName('ENDERECO').AsString+kEspaco(10)+
                  'CNPJ/CEI: '+kFormatCPF(cdEmpresa.FieldByName('CPF_CGC').AsString);
  sSubTitulo := 'Competencia: '+FormatDateTime( 'dd/mm/yyyy', cdFolha.FieldByName('PERIODO_INICIO').AsDateTime)+' a '+
                         FormatDateTime( 'dd/mm/yyyy', cdFolha.FieldByName('PERIODO_FIM').AsDateTime) +
                '  -  Folha No.: '+cdFolha.FieldByName('IDFOLHA').AsString + ' - '+
                cdFolha.FieldByName('DESCRICAO').AsString ;

  sCabecalhoColuna := 'COD'+ #32 +
                      PadRightChar('PROVENTO', C_NOME) + #32 +
                      PadLeftChar( 'REF.', Length(C_FMT_REF)) + #32 +
                      PadLeftChar( 'VALOR', Length(C_FMT_VALOR)) +
                      kEspaco(C_ESPACO) +
                      'COD'+ #32 +
                      PadRightChar('DESCONTO', C_NOME) + #32 +
                      PadLeftChar( 'REF.', Length(C_FMT_REF)) + #32 +
                      PadLeftChar( 'VALOR', Length(C_FMT_VALOR)) +
                      kEspaco(C_ESPACO) +
                      'COD'+ #32 +
                      PadRightChar('BASE', C_NOME) + #32 +
                      PadLeftChar( 'REF.', Length(C_FMT_REF)) + #32 +
                      PadLeftChar( 'VALOR', Length(C_FMT_VALOR));

    cTotalDesconto := 0.0;
    cTotalVantagem := 0.0;

    FProgresso.MaxValue := cdFuncionario.RecordCount;

    cdFuncionario.First;

    while not cdFuncionario.EOF do
    begin

      iFuncionario := cdFuncionario.FieldByName('IDFUNCIONARIO').AsInteger;

      FProgresso.AddProgress(1);

      LerEvento(iFuncionario);

      if (cdDetalhe.RecordCount = 0) then
      begin
        cdFuncionario.Next;
        Continue;
      end;

      if (iPaginaAtual = 0) then
        Cabecalho()

      else if (iLinhaAtual+8 > iLinhaPorPagina) or ((iFuncionario = 9999) and (pvResumo = rtSeparado) ) then
        Cabecalho();

      CabecalhoFuncionario();

      cdDetalhe.First;

      while not cdDetalhe.Eof do
      begin

        if (iLinhaAtual > iLinhaPorPagina) then
        begin
          Cabecalho();
          CabecalhoFuncionario();
        end;

        cVantagem := cdDetalhe.FieldByName('P_VALOR').AsCurrency;
        cDesconto := cdDetalhe.FieldByName('D_VALOR').AsCurrency;
        cBase     := cdDetalhe.FieldByName('B_VALOR').AsCurrency;

        cTotalVantagem := cTotalVantagem + cVantagem;
        cTotalDesconto := cTotalDesconto + cDesconto;

        Texto :=
           PadRightChar( cdDetalhe.FieldByName('P_CODIGO').AsString, 3) + #32 +
           PadRightChar( cdDetalhe.FieldByName('P_NOME').AsString, C_NOME ) + #32 +
           Formata( C_FMT_REF, #32, cdDetalhe.FieldByName('P_REFERENCIA').AsCurrency)+ #32 +
           Formata( C_FMT_VALOR, #32, cVantagem) +
           kEspaco(C_ESPACO) +
           PadRightChar( cdDetalhe.FieldByName('D_CODIGO').AsString, 3)+ #32 +
           PadRightChar( cdDetalhe.FieldByName('D_NOME').AsString, C_NOME ) + #32 +
           Formata( C_FMT_REF,   #32, cdDetalhe.FieldByName('D_REFERENCIA').AsCurrency)+ #32 +
           Formata( C_FMT_VALOR, #32, cDesconto) +
           kEspaco(C_ESPACO) +
           PadRightChar( cdDetalhe.FieldByName('B_CODIGO').AsString, 3)+ #32 +
           PadRightChar( cdDetalhe.FieldByName('B_NOME').AsString, C_NOME ) + #32+
           Formata( C_FMT_REF,   #32, cdDetalhe.FieldByName('B_REFERENCIA').AsCurrency)+ #32 +
           Formata( C_FMT_VALOR, #32, cBase) ;

        Escreve( iLinhaAtual, iMargem, Texto);

        Inc(iLinhaAtual);

        cdDetalhe.Next;

      end;  // while not cdDetalhe EOF

      cdFuncionario.Next;

      RodapeFuncionario();

    end; // while

    FProgresso.Hide;

end;

end.
