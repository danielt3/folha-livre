{
Projeto FolhaLivre - Folha de Pagamento Livre
Relatorio de Comprovante de Rendimentos

Copyright (c) 2007 Allan Lima.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS, COMERCIAIS OU DE
ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

* Histórico

- 15/10/2007 - Primeira versão
- 20/12/2007 - Adicionado o suporte a incidências nos totalizadores
- 29/12/2007 - Gravação do comprovante individual em arquivos PDF

}

unit r_c_rendimento;

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
  TPrinterOption = (poPrinter, poPreview, poPDF);

procedure CriaRendimento( Empresa:Integer; Ano: Word);

procedure ImprimeRendimento( Ano: Word;
  Empresa, Funcionario, Lotacao, Cargo: Integer;
  Recurso, Tipo: String; Imprimir: TPrinterOption);

function Eventalizar( Empresa, Evento, Funcionario: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean): Double;

function Totalizar( Empresa, Total, Funcionario: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean): Double;

implementation

uses
  flotacao, fcargo, ftext, fdb, fsuporte, ftipo, frecurso, futil,
  DateUtils, foption, RLReport, RLFilters, RLPDFFilter, Math
  {$IFDEF FL_D7}, r_teste{$ENDIF};

type
  TfrmRendimento = class(TForm)
  protected
    cdConfig: TClientDataSet;
    dtsConfig: TDataSource;
    btnGravarPDF: TButton;
    btnImprimir: TButton;
    btnVisualizar: TButton;
    btnFechar: TButton;
    edtAno: TEdit;
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
    {$IFDEF VCL}
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    {$ENDIF}
    procedure dbLotacaoXClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    { Private declarations }
  private
    pvEmpresa: Integer;
    procedure CreateDB;
    procedure CreateControls;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

  TFPrint = class(TComponent)
  protected
    { Private declarations }
  private
    { Private declarations }
    Report: TRLReport;
    Filter: TRLPDFFilter;
    {$IFDEF FL_D7}
    FormReport: TFrmTeste;
    {$ENDIF}
    dsDados: TDataSource;
    cdFuncionario, cdComprovante, cdDados: TClientDataSet;

    pvAno: Word;
    pvEmpresa, pvFuncionario, pvCargo, pvLotacao: Integer;
    pvRecurso, pvTipo, pvFiltro: String;

    function Prepara:Boolean;
    procedure Generate;
    function Processa(PrinterOption: TPrinterOption): Boolean;

    procedure cdDadosAfterOpen( DataSet: TDataSet);
    procedure CPFGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure NaturezaGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);

  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

const
  C_AUTO_EDIT = TRUE;
  C_FMT_VALOR = '###,##0.00';

procedure CriaRendimento( Empresa:Integer; Ano: Word);
begin

  with TfrmRendimento.CreateNew(Application) do
  try
    pvEmpresa := Empresa;
    edtAno.Text := IntToStr(Ano);
    ShowModal;
  finally
    Free;
  end;

end;

procedure TfrmRendimento.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (ActiveControl = dbFuncionario) and (Key = VK_RETURN) then
    PesquisaFuncionario( TDBEdit(ActiveControl).Text, pvEmpresa,
                     TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_RETURN) then
    PesquisaLotacao( TDBEdit(ActiveControl).Text, pvEmpresa,
                     TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbLotacao) and (Key = VK_F12) then
    PesquisaLotacao( EmptyStr, pvEmpresa, TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_RETURN) then
    PesquisaCargo( TDBEdit(ActiveControl).Text, pvEmpresa,
                   TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbCargo) and (Key = VK_F12) then
    PesquisaCargo( EmptyStr, pvEmpresa, TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_RETURN) then
    PesquisaTipo( TDBEdit(ActiveControl).Text,
                  TDBEdit(ActiveControl).DataSource.DataSet,
                  Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbTipo) and (Key = VK_F12) then
    PesquisaTipo( EmptyStr,  TDBEdit(ActiveControl).DataSource.DataSet,
                   Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_RETURN) then
    PesquisaRecurso( TDBEdit(ActiveControl).Text,
                     TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, EmptyStr, C_AUTO_EDIT)

  else if (ActiveControl = dbRecurso) and (Key = VK_F12) then
    PesquisaRecurso( EmptyStr,  TDBEdit(ActiveControl).DataSource.DataSet,
                     Key, EmptyStr, C_AUTO_EDIT);

  kKeyDown( Self, Key, Shift);

end;

procedure TfrmRendimento.dbLotacaoXClick(Sender: TObject);
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

procedure TfrmRendimento.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRendimento.btnImprimirClick(Sender: TObject);
var
  iAno, iFuncionario, iCargo, iLotacao: Integer;
  sRecurso, sTipo: String;
  TipoImpressao: TPrinterOption;
begin

  with cdConfig do
  begin

    if State in [dsInsert,dsEdit] then
      Post;

    iFuncionario := -1;
    iLotacao := -1;
    sTipo := EmptyStr;
    sRecurso := EmptyStr;
    iCargo := -1;

    iAno := StrToInt(edtAno.Text);

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

  if (Sender = btnGravarPDF) then
    TipoImpressao := poPDF
  else if (Sender = btnImprimir) then
    TipoImpressao := poPrinter
  else
    TipoImpressao := poPreview;

  ImprimeRendimento( iAno, pvEmpresa, iFuncionario, iLotacao,
                     iCargo, sRecurso, sTipo, TipoImpressao);

end;

constructor TfrmRendimento.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew(AOwner, Dummy);

  Font.Name := 'Arial';

  {$IFDEF VCL}
  BorderStyle := bsDialog;
  Ctl3D  := False;
  {$ENDIF}

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}

  Caption := 'Impressão de Comprovante de Rendimentos';
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

procedure TfrmRendimento.CreateControls;
var
  i: Integer;
  Label1: TLabel;
  Edit1: TDBEdit;
begin

  Self.ClientWidth := 450;

  // Ano Calendário

  Label1 := TLabel.Create(Self);
  with Label1 do
  begin
    Parent := Self;
    Left := 8;
    Top := 8;
    Font.Style := [fsBold];
    Font.Size := Font.Size + 3;
    Caption := 'Ano Calendário:';
  end;

  edtAno := TEdit.Create(Self);
  with edtAno do
  begin
    Parent := Self;
    Font.Color := clBlue;
    Font.Style := [fsBold];
    Font.Size := Font.Size + 3;
    Left := Label1.Left + Label1.Width + 5;
    Width := 50;
    Top := Label1.Top;
  end;

  Label1.Top := Label1.Top + ( (edtAno.Height - Label1.Height) div 2 );

  // Funcionario

  gpFuncionario := TGroupBox.Create(Self);
  with gpFuncionario do
  begin
    Parent := Self;
    Left := 8;
    Top := edtAno.Top + edtAno.Height + 5;
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

  btnFechar := TButton.Create(Self);
  with btnFechar do
  begin
    Parent := Self;
    Width := 100;
    Left := gpRecurso.Left + gpRecurso.Width - Width;
    Top := gpRecurso.Top + gpRecurso.Height + 10;
    Cancel := True;
    Caption := '&Fechar';
    Font.Style := [fsBold];
    OnClick := btnCancelarClick;
    i := TabOrder;
  end;

  btnVisualizar := TButton.Create(Self);
  with btnVisualizar do
  begin
    Parent  := btnFechar.Parent;
    Width   := btnFechar.Width;
    Left    := btnFechar.Left - Width - 10;
    Top     := btnFechar.Top;
    TabOrder := i;
    Font.Assign(btnFechar.Font);
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

  btnGravarPDF := TButton.Create(Self);
  with btnGravarPDF do
  begin
    Parent  := btnImprimir.Parent;
    Width   := btnImprimir.Width;
    Left    := btnImprimir.Left - Width - 10;
    Top     := btnImprimir.Top;
    TabOrder := i;
    Font.Assign(btnImprimir.Font);
    Caption := '&Gravar PDF';
    OnClick := btnImprimirClick;
  end;

  Self.ClientHeight := btnImprimir.Top + btnImprimir.Height + 10;

end;

procedure TfrmRendimento.CreateDB;
begin

  cdConfig := TClientDataSet.Create(Self);

  with cdConfig do
  begin
    FieldDefs.Add('IDFUNCIONARIO', ftInteger);
    FieldDefs.Add('NOME', ftString, 50);
    FieldDefs.Add('IDLOTACAO', ftInteger);
    FieldDefs.Add('LOTACAO', ftString, 50);
    FieldDefs.Add('IDTIPO', ftString, 2);
    FieldDefs.Add('TIPO', ftString, 30);
    FieldDefs.Add('IDCARGO', ftInteger);
    FieldDefs.Add('CARGO', ftString, 50);
    FieldDefs.Add('IDRECURSO', ftString, 2);
    FieldDefs.Add('RECURSO', ftString, 30);
    CreateDataSet;
    Append;
  end;

  dtsConfig := TDataSource.Create(Self);
  dtsConfig.AutoEdit := True;
  dtsConfig.DataSet  := cdConfig;

end;  // CreateDB


//**************** RELATORIO ***********************************

procedure ImprimeRendimento( Ano: Word;
  Empresa, Funcionario, Lotacao, Cargo: Integer;
  Recurso, Tipo: String; Imprimir: TPrinterOption);
var
  Frm: TFPrint;
begin

  kStartTransaction();

  Frm := TFPrint.Create(NIL);

  try try

    with Frm do
    begin

      pvAno := Ano;
      pvFuncionario := Funcionario;
      pvEmpresa := Empresa;

      { Para um funcionario, não precisa de filtro }
      if (pvFuncionario <> -1) then
      begin
        pvRecurso := EmptyStr;
        pvLotacao := -1;
        pvTipo    := EmptyStr;
        pvCargo   := -1;
      end else
      begin
        pvRecurso := Recurso;
        pvLotacao := Lotacao;
        pvTipo    := Tipo;
        pvCargo   := Cargo;
      end;

      if not Prepara() then   // Disponibiliza os dados
        Exit;

      if kInTransaction() then
        kCommitTransaction();

      Generate;   // Gera/monta o relatorio

      Processa(Imprimir);

    end;

  except
    on E:Exception do
    begin
      if kInTransaction() then
       kRollbackTransaction();
      kErro('Erro na impressão do comprovante de rendimentos'+#13+E.Message);
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

  {$IFDEF FL_D7}
  FormReport := TFrmTeste.Create(Self);
  Report := FormReport.RLReport1;
  Filter := FormReport.RLPDFFilter1;
  {$ELSE}
  Report := TRLReport.Create(Self);
  Filter := TRLPDFFilter.Create(Self);
  {$ENDIF}

  cdFuncionario := TClientDataSet.Create(Self);
  cdComprovante := TClientDataSet.Create(Self);
  cdDados       := TClientDataSet.Create(Self);

  dsDados := TDataSource.Create(Self);
  dsDados.DataSet := cdDados;

end;

destructor TFPrint.Destroy;
begin

  {$IFDEF FL_D7}
  FormReport.Free;
  {$ELSE}
  Report.Free;
  Filter.Free;
  {$ENDIF}

  dsDados.Free;

  cdFuncionario.Free;
  cdComprovante.Free;
  cdDados.Free;

  inherited;

end;

function TFPrint.Prepara:Boolean;
var
  i: Integer;
  tmpCursor: TCursor;
  SQL: TStringList;
  sSGDB: String;
  aParamList: Array of Variant;
begin

  SQL := TStringList.Create;
  Result  := False;

  tmpCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try

    SetLength( aParamList, 1);
    aParamList[0] := pvEmpresa;
    sSGDB := LowerCase(kGetOption('sgdb_name'));

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  E.IDGE, E.CPF_CGC AS CNPJ, E.NOME AS EMPRESA,');
    SQL.Add('  F.IDFUNCIONARIO AS CODIGO, P.NOME, P.CPF_CGC AS CPF,');
    SQL.Add('  F.IDNATUREZA, N.NATUREZA');
    SQL.Add('FROM');
    SQL.Add('  EMPRESA E, FUNCIONARIO F, PESSOA P,');
    SQL.Add('  F_NATUREZA_RENDIMENTO N');
    SQL.Add('WHERE');
    SQL.Add('  E.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND F.IDEMPRESA = E.IDEMPRESA');

    if (sSGDB = 'firebird') or (sSGDB = 'interbase') then
      SQL.Add('  AND EXTRACT(YEAR FROM F.ADMISSAO) <= '+IntToStr(pvAno))
    else begin
      SQL.Add('  AND F.ADMISSAO <= :ANO');
      SetLength(aParamList, 2);
      aParamList[1] := DateUtils.StartOfAYear(pvAno);
    end;

    pvFiltro := EmptyStr;

    if (pvFuncionario <> -1) then
      pvFiltro := pvFiltro + ' AND F.IDFUNCIONARIO = '+IntToStr(pvFuncionario);

    if (pvLotacao <> -1) then
      pvFiltro := pvFiltro + ' AND F.IDLOTACAO = '+IntToStr(pvLotacao);

    if (pvCargo <> -1) then
      pvFiltro := pvFiltro + ' AND F.IDCARGO = '+IntToStr(pvCargo);

    if (pvTipo <> EmptyStr) then
      pvFiltro := pvFiltro + ' AND F.IDTIPO = '+QuotedStr(pvTipo);

    if (pvRecurso <> EmptyStr) then
      pvFiltro := pvFiltro + ' AND F.IDRECURSO = '+QuotedStr(pvRecurso);

    if (pvFiltro <> EmptyStr) then
      SQL.Add(pvFiltro);

    SQL.Add('  AND P.IDEMPRESA = F.IDEMPRESA');
    SQL.Add('  AND P.IDPESSOA = F.IDPESSOA');

    SQL.Add('  AND N.IDNATUREZA = F.IDNATUREZA');

    SQL.Add('ORDER BY P.NOME');

    SQL.EndUpdate;

    if not kOpenSQL( cdFuncionario, SQL.Text, aParamList) then
      raise Exception.Create(kGetErrorLastSQL);

    if (cdFuncionario.RecordCount = 0) then
      raise Exception.Create('Não há dados a imprimir.');


    if not kOpenSQL( cdComprovante, 'F_COMPROVANTE_RENDIMENTO', 'IDGE = :GE',
                                    [cdFuncionario.Fields[0].AsInteger]) then
      raise Exception.Create(kGetErrorLastSQL);

    cdComprovante.IndexFieldNames := 'GRUPO;SUBGRUPO';

    cdDados.FieldDefs.BeginUpdate;

    for i := 0 to cdFuncionario.FieldCount - 1 do
      cdDados.FieldDefs.Add( cdFuncionario.Fields[i].FieldName,
                             cdFuncionario.Fields[i].DataType,
                             cdFuncionario.Fields[i].Size,
                             cdFuncionario.Fields[i].Required);

    with cdComprovante do
    begin

      First;

      while not Eof do
      begin
        if (FieldByName('SUBGRUPO').AsInteger > 0) then
          cdDados.FieldDefs.Add('V_'+FieldByName('GRUPO').AsString+
                                '_'+FieldByName('SUBGRUPO').AsString,
                                ftString, 78);
        Next;
      end;

    end;

    cdDados.FieldDefs.EndUpdate;

    cdDados.AfterOpen := cdDadosAfterOpen;
    
    cdDados.CreateDataSet;

    Result := True;

  finally
    SQL.Free;
    Screen.Cursor := tmpCursor;
  end;

end; // function Prepara

function TFPrint.Processa(PrinterOption: TPrinterOption):Boolean;
var
  i, iGrupo, iSubGrupo, iEvento, iTotalizador, iCountFiles: Integer;
  f, sValor, sDescricao, sPath, sFileName, sName: String;
  cValor, cTotal: Currency;
  ProgressBar: TFrmProgress;
  slData: TStringList;
begin

  ProgressBar := CriaProgress(EmptyStr);
  slData := TStringList.Create;
  sPath := EmptyStr;  // Diretorio onde serao gravados os comprovantes
  iCountFiles := 0;

  try

    Result := False;

    ProgressBar.Rotulo.Visible := False;
    ProgressBar.Bar.Align := alClient;
    ProgressBar.Bar.Font.Size := ProgressBar.Bar.Font.Size * 2;

    ProgressBar.MaxValue := cdFuncionario.RecordCount;

    cdFuncionario.First;

    while not cdFuncionario.EOF do
    begin

      ProgressBar.AddProgress(1);

      pvFuncionario := cdFuncionario.FieldByName('CODIGO').AsInteger;
      cTotal := 0.0;
      slData.Clear;

      cdComprovante.First;

      while not cdComprovante.Eof do
      begin

        iGrupo     := cdComprovante.FieldByName('GRUPO').AsInteger;
        iSubGrupo  := cdComprovante.FieldByName('SUBGRUPO').AsInteger;
        sDescricao := cdComprovante.FieldByName('DESCRICAO').AsString;

        if (iSubGrupo > 0) then
        begin

          iEvento := cdComprovante.FieldByName('IDEVENTO').AsInteger;
          iTotalizador := cdComprovante.FieldByName('IDTOTALIZADOR').AsInteger;
          cValor := 0.0;

          if (iEvento > 0) then
            cValor := Eventalizar( pvEmpresa, iEvento, pvFuncionario,
                                   DateUtils.StartOfAYear(pvAno),
                                   DateUtils.EndOfAYear(pvAno), True);

          cTotal := cTotal + cValor;

          if (iTotalizador > 0) then
            cValor := Totalizar( pvEmpresa, iTotalizador, pvFuncionario,
                                 DateUtils.StartOfAYear(pvAno),
                                 DateUtils.EndOfAYear(pvAno), True);

          cTotal := cTotal + cValor;

          // Grava o valor
          f := 'V_'+IntToStr(iGrupo)+'_'+IntToStr(iSubGrupo);

          sValor := PadLeftChar( FormatFloat( C_FMT_VALOR, cValor),
                                 Length(C_FMT_VALOR), '.');

          sDescricao := '   '+IntToStr(iSubGrupo)+'. '+sDescricao;
          sDescricao := sDescricao+
                        Replicate( '.', 78-Length(sDescricao+sValor)) + sValor;

          slData.Values[f] := sDescricao;

        end;

        cdComprovante.Next;

      end;  // not cdComprovante.Eof

      if (cTotal > 0.0) then
      begin

        if (PrinterOption = poPDF) then
        begin
          cdDados.Close;
          cdDados.CreateDataSet;
          if (sPath = EmptyStr) then
          begin
            sPath := ExtractFilePath(ParamStr(0))+'cr'+IntToStr(pvAno)+PathDelim;
            if DirectoryExists(sPath) then
              kDeleteFiles(sPath+'*.pdf')
            else
              CreateDir(sPath);
          end;
        end;

        cdDados.Append;

        // Grava dados do funcionario
        for i := 0 to cdFuncionario.FieldCount - 1 do
        begin
          f := cdFuncionario.Fields[i].FieldName;
          cdDados.FieldByName(f).Value := cdFuncionario.Fields[i].Value;
        end;

        for i := 0 to slData.Count - 1 do
        begin
          f := slData.Names[i];
          cdDados.FieldByName(f).AsString := slData.Values[f];
        end;

        cdDados.Post;

        if (PrinterOption = poPDF) then
        begin

          sName := cdDados.FieldByName('NOME').AsString;

          sFileName := sPath+IntToStr(pvAno)+'-'+
                       cdDados.FieldByName('CPF').AsString+'-'+
                       Copy( sName, 1, Pos(' ',sName)-1) + '.pdf';

          Report.Prepare;
          Report.SaveToFile(sFileName);
          Inc(iCountFiles);

        end;

      end;  // cTotal > 0

      cdFuncionario.Next;

    end; // while

    FreeAndNil(ProgressBar);

    case PrinterOption of
      poPreview:
           Report.PreviewModal;
      poPrinter:
           begin
             Report.PrintDialog := True;
             Report.Print;
           end;
      poPDF:
           if (iCountFiles = 0) then
             kAviso('Processamento concluído.'+sLineBreak+
                    'Nenhum arquivo foi armazenado !!!', mtError)
           else
             kAviso('Processamento concluído.'+sLineBreak+
                    IntToStr(iCountFiles)+' arquivo(s) armazenado(s) !!!', mtInformation);

    end;

    Result := True;

  finally
    if Assigned(ProgressBar) then
      ProgressBar.Free;
    slData.Free;
  end;

end;  // processa

procedure TFPrint.Generate;
var
  iTop: Integer;
  Band: TRLBand;
  LineText: TRLLabel;
  LineDB: TRLDBText;

  procedure TitleLine(Caption: String);
  begin

    LineText := TRLLabel.Create(Report);

    LineText.Parent := Band;
    LineText.Align := faWidth;
    LineText.Alignment := taCenter;
    LineText.Caption := Caption;
    LineText.Font.Style := [fsBold];
    LineText.Top := iTop + 2;

    iTop := LineText.Top + LineText.Height;

  end;

  procedure SubTitleLine(Caption: String);
  begin

    LineText := TRLLabel.Create(Report);

    LineText.Parent  := Band;
    LineText.Caption := Caption;
    LineText.Align := faWidth;
    LineText.Font.Style := [fsBold];
    LineText.Top := iTop + 2;

    iTop := LineText.Top + LineText.Height;

  end;

  procedure NextLine( Caption, FieldName: String);
  begin

    LineText := TRLLabel.Create(Report);

    LineText.Parent  := Band;
    LineText.Caption := '   '+Caption+':';
    LineText.Align   := faLeftOnly;
    LineText.Top := iTop + 2;

    LineDB := TRLDBText.Create(Report);

    LineDB.Parent := Band;
    LineDB.DataSource := dsDados;
    LineDB.DataField := FieldName;
    LineDB.Top := LineText.Top;
    LineDB.Left := LineText.Left + LineText.Width + 2;

    iTop := LineDB.Top + LineDB.Height;

  end;

  procedure DataLine(FieldName: String);
  begin

    LineDB := TRLDBText.Create(Report);

    LineDB.Parent := Band;
    LineDB.Align := faWidth;
    LineDB.DataSource := dsDados;
    LineDB.DataField := FieldName;
    LineDB.Top := iTop + 2;

    iTop := LineDB.Top + LineDB.Height;

  end;

  procedure EmptyLine;
  begin

    LineText := TRLLabel.Create(Report);

    LineText.Parent  := Band;
    LineText.Caption := ' ';
    LineText.Align   := faWidth;
    LineText.Top := iTop + 2;

    iTop := LineText.Top + LineText.Height;

  end;

begin

  with Report do
  begin

    //Borders.Sides := sdAll;
    DataSource := dsDados;
    Font.Name := 'Courier New';
    Font.Size := 11;

    Band := TRLBand.Create(Report);

    Band.Parent := Report;
    Band.BandType := btDetail;
    iTop := 0;

    TitleLine(' ');
    TitleLine('COMPROVANTE DE RENDIMENTOS PAGOS E DE RETENCAO DE IMPOSTO DE RENDA NA FONTE');
    TitleLine('ANO CALENDARIO '+IntToStr(pvAno));
    TitleLine(' ');
    TitleLine(' ');

    SubTitleLine('1. FONTE PAGADORA PESSOA JURIDICA');
    EmptyLine();
    NextLine( 'CNPJ', 'CNPJ');
    NextLine( 'RAZAO SOCIAL', 'EMPRESA');
    EmptyLine();

    SubTitleLine('2. PESSOA FISICA BENEFICIARIA DOS RENDIMENTOS');

    EmptyLine();

    NextLine('CPF', 'CPF');
    NextLine('NOME', 'NOME');
    NextLine('NATUREZA DO RENDIMENTO', 'NATUREZA');

    cdComprovante.First;

    while not cdComprovante.Eof do
    begin

      if (cdComprovante.FieldByName('SUBGRUPO').AsInteger = ZeroValue) then
      begin

        EmptyLine();
        SubTitleLine(cdComprovante.FieldByName('GRUPO').AsString+'. '+
                     cdComprovante.FieldByName('DESCRICAO').AsString);
        EmptyLine();

      end else
      begin

        DataLine('V_'+cdComprovante.FieldByName('GRUPO').AsString+'_'+
                      cdComprovante.FieldByName('SUBGRUPO').AsString);

      end;

      cdComprovante.Next;

    end;  // while

    Band.Height := iTop + 5;

  end;  // Report

end;  // Generate

procedure TFPrint.cdDadosAfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('CNPJ').OnGetText := CPFGetText;
  DataSet.FieldByName('CPF').OnGetText := CPFGetText;
  DataSet.FieldByName('NATUREZA').OnGetText := NaturezaGetText;
end;

procedure TFPrint.CPFGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := kFormatCPF(Sender.AsString);
end;

procedure TFPrint.NaturezaGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.DataSet.FieldByName('NATUREZA').AsString + ' - CODIGO ' +
          Sender.DataSet.FieldByName('IDNATUREZA').AsString;

end;

function Eventalizar( Empresa, Evento, Funcionario: Integer;
  Inicio, Fim: TDateTime; const IniciarTransacao: Boolean): Double;
var
  SQL: TStringList;
  DataSet1: TClientDataSet;
begin

  SQL      := TStringList.Create;
  DataSet1 := TClientDataSet.Create(NIL);
  Result   := 0.0;

  try

    if (kCountSQL('F_EVENTO', 'IDEVENTO = :E', [Evento],
                  IniciarTransacao) = 0) then
      raise Exception.CreateFmt('O evento "%d" não existe.', [Evento]);

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  SUM(C.CALCULADO)');
    SQL.Add('FROM');
    SQL.Add('  F_CENTRAL C, F_FOLHA F');
    SQL.Add('WHERE');
    SQL.Add('  C.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND C.IDFUNCIONARIO = :FUNCIONARIO');
    SQL.Add('  AND C.IDEVENTO = :EVENTO');
    SQL.Add('  AND F.IDEMPRESA = C.IDEMPRESA');
    SQL.Add('  AND F.IDFOLHA = C.IDFOLHA');
    SQL.Add('  AND (F.DATA_CREDITO BETWEEN :INICIO AND :FIM)');
    SQL.Add('  AND (F.ARQUIVAR_X = 1)');
    SQL.Add('  AND F.IDFOLHA_TIPO IN');
    SQL.Add('      ( SELECT IDFOLHA_TIPO FROM F_FOLHA_TIPO');
    SQL.Add('        WHERE TOTALIZAR_X = 1 )');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text,
                     [Empresa, Funcionario, Evento, Inicio, Fim],
                     IniciarTransacao) then
      raise Exception.Create(kGetErrorLastSQL);

    Result := DataSet1.Fields[0].AsCurrency;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;  // Eventalizar

function Totalizar( Empresa, Total, Funcionario: Integer;
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
      raise Exception.Create('Erro no totalizador no. '+IntToStr(Total)+sLineBreak+
                             'Não é possível realizar o cálculo.'+sLineBreak+
                             'Faltar informar eventos ou incidências.');

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
    SQL2.Add('  AND (F.DATA_CREDITO BETWEEN :INICIO AND :FIM)');
    SQL2.Add('  AND (F.ARQUIVAR_X = 1)');

    if (iTipoFolha > 0) then
    begin
      SQL2.Add('  AND (F.IDFOLHA_TIPO IN (');
      SQL2.Add('        SELECT IDFOLHA_TIPO FROM F_TOTALIZADOR_FOLHA');
      SQL2.Add('        WHERE IDTOTAL = '+IntToStr(Total)+' AND ATIVO_X = 1');
      SQL2.Add('      ))');
    end;

    if (sCalculo = EmptyStr) then
      SQL2.Add('GROUP BY 1');

    SQL2.EndUpdate;

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

end;  // Totalizar

end.
