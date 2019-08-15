{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro e Pesquisa de Eventos

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
Histórico das modificações
==========================

* 10/07/2005 - Adicionado suporte a folha complementar - evento complementar
* 03/03/2007 - Adicionado TIPO_SALARIO (suporte para 13o salário)
* 15/03/2007 - Ajustes na apresentação da fórmula
* 07/01/2008 - Adicionado a guia "GRUPOS" (Grupos de Eventos)
}

unit fevento;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids, QComCtrls, QMask,
  QButtons, QStdCtrls, QExtCtrls, QDBCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids, Mask,
  ComCtrls, Buttons, StdCtrls, ExtCtrls, DBCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF SYN_EDIT}
    {$IFDEF CLX}
    QSynHighlighterCAC, QSynEdit, QSynDBEdit, QSynEditExport, QSynExportRTF,
    QSynExportHTML,
    {$ENDIF}
    {$IFDEF VCL}
    SynHighlighterCAC, SynEdit, SynDBEdit, SynEditExport, SynExportRTF,
    SynExportHTML,
    {$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Variants, DB, DBClient, fcadastro, ffind;

type
  TFrmEvento = class(TFrmCadastro)
    mtRegistroIDEVENTO: TIntegerField;
    mtRegistroCONTRA_PARTIDA: TIntegerField;
    mtRegistroPROPORCIONAL_X: TSmallintField;
    mtRegistroATIVO_X: TSmallintField;
    mtRegistroMULTIPLICADOR: TCurrencyField;
    mtRegistroTIPO_EVENTO: TStringField;
    mtRegistroTIPO_CALCULO: TStringField;
    mtRegistroNOME: TStringField;
    pnlDados: TPanel;
    lbCodigo: TLabel;
    lbNome: TLabel;
    dbCodigo: TDBEdit;
    dbNome: TDBEdit;
    mtRegistroVALOR_HORA: TStringField;
    PageControl2: TPageControl;
    TabIncidencia: TTabSheet;
    TabGeral: TTabSheet;
    pnlGeral: TPanel;
    dbHoraValor: TDBRadioGroup;
    dbTipo: TDBRadioGroup;
    dbCalculo: TDBRadioGroup;
    gpOutros: TGroupBox;
    lbMultiplicador: TLabel;
    gpIntervalo: TGroupBox;
    lbMinimo: TLabel;
    Label1: TLabel;
    dbMultiplicador: TDBEdit;
    dbMinimo: TDBEdit;
    dbMaximo: TDBEdit;
    dbContraPartida: TDBEdit;
    Label2: TLabel;
    Panel2: TPanel;
    gpIncidencia: TGroupBox;
    dbInc01: TDBCheckBox;
    mtRegistroINC_01_X: TSmallIntField;
    mtRegistroINC_02_X: TSmallIntField;
    mtRegistroINC_03_X: TSmallIntField;
    mtRegistroINC_04_X: TSmallIntField;
    mtRegistroINC_05_X: TSmallIntField;
    mtRegistroINC_06_X: TSmallIntField;
    mtRegistroINC_07_X: TSmallIntField;
    mtRegistroINC_08_X: TSmallIntField;
    mtRegistroINC_09_X: TSmallIntField;
    mtRegistroINC_10_X: TSmallIntField;
    mtRegistroINC_11_X: TSmallIntField;
    mtRegistroINC_12_X: TSmallIntField;
    mtRegistroINC_13_X: TSmallIntField;
    mtRegistroINC_14_X: TSmallIntField;
    mtRegistroINC_15_X: TSmallIntField;
    mtRegistroINC_16_X: TSmallIntField;
    mtRegistroINC_17_X: TSmallIntField;
    mtRegistroINC_18_X: TSmallIntField;
    mtRegistroINC_19_X: TSmallIntField;
    mtRegistroINC_20_X: TSmallIntField;
    dbInc02: TDBCheckBox;
    dbInc03: TDBCheckBox;
    dbInc04: TDBCheckBox;
    dbInc05: TDBCheckBox;
    dbInc06: TDBCheckBox;
    dbInc07: TDBCheckBox;
    dbInc08: TDBCheckBox;
    dbInc09: TDBCheckBox;
    dbInc10: TDBCheckBox;
    dbInc11: TDBCheckBox;
    dbInc12: TDBCheckBox;
    dbInc13: TDBCheckBox;
    dbInc14: TDBCheckBox;
    dbInc15: TDBCheckBox;
    dbInc16: TDBCheckBox;
    dbInc17: TDBCheckBox;
    dbInc18: TDBCheckBox;
    dbInc19: TDBCheckBox;
    dbInc20: TDBCheckBox;
    mtRegistroVALOR_MINIMO: TCurrencyField;
    mtRegistroVALOR_MAXIMO: TCurrencyField;
    mtRegistroIDFORMULA: TIntegerField;
    mtRegistroASSUME_X: TSmallintField;
    mtRegistroFORMULA: TStringField;
    mtListagemFORMULA: TStringField;
    mtRegistroFORMULA_LOCAL: TStringField;
    mtRegistroTOTAL_LOTACAO_X: TSmallintField;
    mtRegistroCONTRA_CHEQUE_X: TSmallintField;
    mtRegistroCOMPLEMENTAR: TSmallintField;
    mtRegistroTIPO_SALARIO: TStringField;
    dbSalario: TDBRadioGroup;
    TabFormula: TTabSheet;
    gpFormula: TGroupBox;
    lbFormula: TLabel;
    Label3: TLabel;
    dbFormula: TAKDBEdit;
    dbFormula2: TDBEdit;
    dbFormulaLocal: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    StaticText1: TStaticText;
    gpFormulaTexto: TGroupBox;
    Panel1: TPanel;
    mtRegistroFORMULA_SOURCE: TStringField;
    mtListagemFORMULA_SOURCE: TStringField;
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure FormCreate(Sender: TObject);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure PageControl1Change(Sender: TObject);
    procedure dbFormulaButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure PageControl2Change(Sender: TObject);
    procedure dtsRegistroStateChange(Sender: TObject);
  protected

    TabGrupo: TTabSheet;

    pnlGrupo1: TPanel;
    dbgGrupo1: TDBGrid;
    cdGrupo1: TClientDataSet;
    dsGrupo1: TDataSource;

    pnlGrupo2: TPanel;
    dbgGrupo2: TDBGrid;
    cdGrupo2: TClientDataSet;
    dsGrupo2: TDataSource;

  private
    { Private declarations }
    {$IFDEF SYN_EDIT}
    dbFormulaTexto: TDBSynEdit;
    {$ELSE}
    dbFormulaTexto: TDBMemo;
    {$ENDIF}
    procedure LerGrupo1;
    function AtivarGrupo1: Boolean;
    procedure dbgAtivoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cdGrupo1AfterScroll(DataSet: TDataSet);
    procedure LerGrupo2;
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    procedure Iniciar; override;
  end;

  { TFrmEventoFind }

  TFrmEventoFind = class(TFrmFind)
  protected
    procedure OnAfterOpen( DataSet: TDataSet); virtual;
    procedure GridDrawColumnCell( Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState); override;
  private
    { Private declarations }
    FDataSet: TClientDataSet;
    procedure Pesquisar( Pesquisa: String);
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

function kEventoFind( const Pesquisa: String; var Codigo: Integer;
  var Nome, Tipo: String; var Ativo:Integer):Boolean;

procedure FindEvento( const Pesquisa: String; DataSet: TDataSet; var Key: Word); overload;
procedure FindEvento( const Pesquisa: String; DataSet: TDataSet); overload;

procedure kEventoColor( Field: TField; AFont: TFont);

procedure kEventoDrawColumnCell( Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);

function kEventoTipo( Tipo: String):String;

procedure CriaEvento();

implementation

uses fdb, ftext, fbase, fsuporte, fformula, Math;

{$R *.dfm}

procedure kEventoColor( Field: TField; AFont: TFont);
begin

  if Assigned(Field.DataSet.FindField('TIPO_EVENTO')) and
     (Field.DataSet.FieldByName('TIPO_EVENTO').AsString <> '') then
    case Field.DataSet.FieldByName('TIPO_EVENTO').AsString[1] of
      'B': AFont.Color := clBlue;      // Base de calculo
      'D': AFont.Color := clRed;       // Desconto
      'P': AFont.Color := clBlack;     // Provento
    end;

  if Assigned(Field.DataSet.FindField('ATIVO_X')) and
     (Field.DataSet.FieldByName('ATIVO_X').AsInteger = 0) then   // Inativo
    AFont.Style := AFont.Style + [fsStrikeOut];

end;

procedure kEventoDrawColumnCell( Sender: TObject; const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);
  kEventoColor( Column.Field, TDBGrid(Sender).Canvas.Font);
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

function kEventoTipo( Tipo: String):String;
begin
  if (Tipo = 'B') then Result := 'Base'
  else if (Tipo = 'D') then Result := 'Desconto'
  else if (Tipo = 'P') then Result := 'Provento'
  else Result := '';
end;

procedure CriaEvento();
var
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmEvento) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  with TFrmEvento.Create(Application) do
  begin
    pvTabela := 'F_EVENTO';
    Iniciar();
    Show;
  end;

end;

{ TFrmEvento }

constructor TFrmEvento.Create(Owner: TComponent);
var
  Panel1: TPanel;
  Control1: TControl;
  gpOpcao: TGroupBox;
  i: Integer;
begin

  inherited;

  gpOpcao := TGroupBox.Create(Self);

  with gpOpcao do
  begin
    Parent := pnlGeral;
    Caption := 'Opções';
    Top := dbHoraValor.Top + dbHoraValor.Height + 5;
    Left := dbHoraValor.Left;
    Width := (dbCalculo.Left+dbCalculo.Width) - Left;
  end;

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := gpOpcao;
    AllowGrayed    := False;
    Caption        := 'Exibir em Contra-Cheque';
    DataSource     := dtsRegistro;
    DataField      := 'CONTRA_CHEQUE_X';
    Left           := 8;
    Top            := 16;
    ValueChecked   := '1';
    ValueUnchecked := '0';
    Width := gpOpcao.Width - 10;
  end;

  Control1 := kGetLastTabOrder(gpOpcao);

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := Control1.Parent;
    AllowGrayed    := False;
    Caption        := 'Exibir em Total de Lotação';
    DataSource     := dtsRegistro;
    DataField      := 'TOTAL_LOTACAO_X';
    Left           := Control1.Left;
    Top            := Control1.Top + Control1.Height + 3;
    ValueChecked   := '1';
    ValueUnchecked := '0';
    Width := Control1.Width;
  end;

  Control1 := kGetLastTabOrder(gpOpcao);

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := Control1.Parent;
    AllowGrayed    := False;
    Caption        := 'Assumir Valor Informado';
    DataSource     := dtsRegistro;
    DataField      := 'ASSUME_X';
    Left           := Control1.Left;
    Top            := Control1.Top + Control1.Height + 3;
    ValueChecked   := '1';
    ValueUnchecked := '0';
    Width := Control1.Width;
  end;

  Control1 := kGetLastTabOrder(gpOpcao);

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := Control1.Parent;
    AllowGrayed    := False;
    Caption        := 'Proporcional';
    DataSource     := dtsRegistro;
    DataField      := 'PROPORCIONAL_X';
    Left           := Control1.Left;
    Top            := Control1.Top + Control1.Height + 3;
    ValueChecked   := '1';
    ValueUnchecked := '0';
    Parent.Height  := Top + Height + 5;
    Width := Control1.Width;
  end;

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent := gpOpcao.Parent;
    Caption := 'Folha Complementar';
    DataSource := dtsRegistro;
    DataField := 'COMPLEMENTAR';
    Top := gpOpcao.Top;
    Left := gpOpcao.Left + gpOpcao.Width + 5;
    Height := gpOpcao.Height;
    Width := gpOpcao.Width;
    Items.Add('Não calcula'); Values.Add('0');
    Items.Add('Complemento'); Values.Add('1');
    Items.Add('Total'); Values.Add('2');
  end;

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := pnlGeral;
    Name           := 'dbAtivo';
    AllowGrayed    := False;
    Caption        := 'Ativo';
    DataSource     := dtsRegistro;
    DataField      := 'ATIVO_X';
    Left           := gpOpcao.Left;
    Top            := gpOpcao.Top + gpOpcao.Height + 5;
    ValueChecked   := '1';
    ValueUnchecked := '0';
  end;

  {$IFDEF SYN_EDIT}
  if not Assigned(dbFormulaTexto) then
    dbFormulaTexto := TDBSynEdit.Create(Self);

  with dbFormulaTexto do
  begin
    Gutter.Visible := True;
    Gutter.ShowLineNumbers := True;
    Highlighter := TSynCACSyn.Create(Self);
    Highlighter.CommentAttribute.Foreground := clRed;
    Highlighter.StringAttribute.Foreground  := clBlue;
  end;
  {$ELSE}
  if not Assigned(dbFormulaTexto) then
    dbFormulaTexto := TDBMemo.Create(Self);
  {$ENDIF}

  dbFormulaTexto.Parent := gpFormulaTexto;

  dbFormulaTexto.DataSource := dtsRegistro;
  dbFormulaTexto.DataField := 'FORMULA_SOURCE';

  dbFormulaTexto.BorderStyle := bsNone;
  dbFormulaTexto.ScrollBars := ssVertical;
  dbFormulaTexto.ParentColor := True;
  dbFormulaTexto.ReadOnly := True;
  dbFormulaTexto.Align := alClient;

  { Adicionado em 07/01/2008 - Allan Lima }

  cdGrupo1 := TClientDataSet.Create(Self);

  with cdGrupo1 do
  begin
    FieldDefs.Add('IDGRUPO', ftInteger);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    AfterScroll := cdGrupo1AfterScroll;
    CreateDataSet;
  end;

  dsGrupo1 := TDataSource.Create(Self);
  dsGrupo1.DataSet := cdGrupo1;

  TabGrupo := TTabSheet.Create(Self);

  with TabGrupo do
  begin
    PageControl := PageControl2;
    Caption := 'Grupos';
  end;

  pnlGrupo1 := TPanel.Create(Self);

  with pnlGrupo1 do
  begin
    Parent := TabGrupo;
    Align := alLeft;
    ParentColor := True;
  end;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := pnlGrupo1;
    Align       := alTop;
    Alignment   := taLeftJustify;
    Caption     := ' · Grupos do evento atual';
    Color       := RxTitulo.Color;
    Font.Assign(RxTitulo.Font);
    Height      := RxTitulo.Height;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  dbgGrupo1 := TDBGrid.Create(Self);

  with dbgGrupo1 do
  begin
    Parent := pnlGrupo1;
    Align  := alClient;
    ParentColor := True;
    DataSource := dsGrupo1;
    Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
    Options := Options - [dgColumnResize];
    ReadOnly := True;
    OnDrawColumnCell := dbgAtivoDrawColumnCell;
    Font.Size := Trunc(Self.Font.Size * 1.5);
  end;

  with dbgGrupo1.Columns.Add do
  begin
    FieldName := 'IDGRUPO';
    Title.Caption := 'Grupo';
    Width := 70;
  end;

  with dbgGrupo1.Columns.Add do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Nome do Grupo';
    Width := 350;
  end;

  with TLabel.Create(Self) do
  begin
    Parent := pnlGrupo1;
    Align := alBottom;
    Alignment := taCenter;
    Caption := 'Pressione a tecla <Espaço> para incluir/remover o evento do grupo';
    Font.Color := clRed;
    Font.Style := [fsBold];
    Height := Trunc(Height * 1.5);
    Layout := tlCenter;
  end;

  pnlGrupo1.Width := kMaxWidthColumn( dbgGrupo1.Columns, Rate);

  // Outros eventos do grupo selecionado

  cdGrupo2 := TClientDataSet.Create(Self);

  with cdGrupo2 do
  begin
    FieldDefs.Add('IDEVENTO', ftInteger);
    FieldDefs.Add('NOME', ftString, 50);
    FieldDefs.Add('TIPO_EVENTO', ftString, 1);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    CreateDataSet;
  end;

  dsGrupo2 := TDataSource.Create(Self);
  dsGrupo2.DataSet := cdGrupo2;

  pnlGrupo2 := TPanel.Create(Self);

  with pnlGrupo2 do
  begin
    Parent := TabGrupo;
    Align := alClient;
    ParentColor := True;
  end;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := pnlGrupo2;
    Align       := alTop;
    Alignment   := taLeftJustify;
    Caption     := ' · Eventos do grupo selecionado';
    Color       := RxTitulo.Color;
    Font.Assign(RxTitulo.Font);
    Height      := RxTitulo.Height;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  dbgGrupo2 := TDBGrid.Create(Self);

  with dbgGrupo2 do
  begin
    Parent := pnlGrupo2;
    Align  := alClient;
    ParentColor := True;
    DataSource := dsGrupo2;
    Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
    Options := Options - [dgColumnResize];
    ReadOnly := True;
    OnDrawColumnCell := dbgRegistroDrawColumnCell;
    Font.Size := Trunc(Self.Font.Size * 1.5);
  end;

  with dbgGrupo2.Columns.Add do
  begin
    FieldName := 'IDEVENTO';
    Title.Caption := 'Evento';
    Width := 70;
  end;

  with dbgGrupo2.Columns.Add do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Nome do Evento';
    Width := 350;
  end;

end;

procedure TFrmEvento.Iniciar;
var
  cdIncidencia: TClientDataSet;
  i: Integer;
  sCaption: String;
  Comp1: TComponent;
begin

  pvSELECT := 'SELECT E.*, F.NOME AS FORMULA, F.FORMULA AS FORMULA_SOURCE'#13+
              'FROM F_EVENTO E'#13+
              'LEFT JOIN F_FORMULA F ON (F.IDFORMULA = E.IDFORMULA)';

  pvSELECT_NULL := 'ORDER BY E.TIPO_EVENTO DESC, E.IDEVENTO';

  kNovaPesquisa( mtPesquisa, 'ID', 'WHERE E.IDEVENTO = #');
  kNovaPesquisa( mtPesquisa, 'NOME', 'WHERE E.NOME LIKE '+QuotedStr('#%'));

  inherited Iniciar;

  cdIncidencia := TClientDataSet.Create(Self);

  for i := 0 to gpIncidencia.ControlCount-1 do
    if (gpIncidencia.Controls[i] is TDBCheckBox) then
      TDBCheckBox(gpIncidencia.Controls[i]).Visible := False;

  try

    kSQLSelectFrom( cdIncidencia, 'F_INCIDENCIA');

    cdIncidencia.First;
    while not cdIncidencia.Eof do
    begin
      i := cdIncidencia.FieldByName('IDINCIDENCIA').AsInteger;
      sCaption := IntToStr(i)+'. '+cdIncidencia.FieldByName('NOME').AsString+' - T'+IntToStr(i);
      Comp1 := FindComponent('dbInc'+kStrZero(i,2));
      if Assigned(Comp1) then
      begin
        TDBCheckBox(Comp1).Visible := True;
        TDBCheckBox(Comp1).Caption := sCaption;
      end;
      cdIncidencia.Next;
    end;

    dbInc13.Visible := True;
    dbInc13.Caption := '13. DÉCIMO TERCEIRO - T13 (Reservado)';
    dbInc13.Font.Color := clBlue;
    dbInc13.Font.Style := [fsBold];

  finally
    cdIncidencia.Free;
  end;

  dbgRegistro.SetFocus;

end;  // iniciar

procedure TFrmEvento.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
end;

procedure TFrmEvento.FormCreate(Sender: TObject);
begin
  inherited;
  dbNome.Font.Style := dbNome.Font.Style + [fsBold];
end;

procedure TFrmEvento.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('TIPO_EVENTO').AsString   := 'B';  // Base
    FieldByName('TIPO_CALCULO').AsString  := 'F';  // Formula
    FieldByName('TIPO_SALARIO').AsString  := 'I';  // Indeterminado
    FieldByName('VALOR_HORA').AsString    := 'H';  // Hora
    FieldByName('ATIVO_X').AsInteger      := 1;    // Ativo
    FieldByName('COMPLEMENTAR').AsInteger := 0;    // Nao Complementar
  end;
end;

procedure TFrmEvento.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDEVENTO').AsInteger = 0) then
      FieldByName('IDEVENTO').AsInteger := kMaxCodigo( 'F_EVENTO', 'IDEVENTO');
  inherited;
end;

procedure TFrmEvento.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Excluir o evento "'+DataSet.FieldByName('NOME').AsString+'" ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmEvento.PageControl1Change(Sender: TObject);
begin
  inherited;
  if (TPageControl(Sender).ActivePageIndex = 1) then
    PageControl2.ActivePageIndex := 0;
end;

procedure TFrmEvento.dbFormulaButtonClick(Sender: TObject);
var Key: Word;
begin
  FindFormula('*', mtRegistro, Key);
end;

procedure TFrmEvento.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando: Boolean;
begin

  bEditando := mtRegistro.State in [dsInsert,dsEdit];

  if (Key = VK_RETURN) and bEditando and (ActiveControl = dbFormula) then
    FindFormula( dbFormula.Text, pvDataSet, Key)

  else if (Key = VK_RETURN) and bEditando and (ActiveControl.Name = 'dbAtivo') then
  begin
    Key := 0;
    PageControl2.SelectNextPage(True);

  end else if (Key = VK_RETURN) and bEditando and (ActiveControl = dbFormulaLocal) then
  begin
    Key := 0;
    PageControl2.SelectNextPage(True);

  end else if (ActiveControl = dbgGrupo1) and (Key = VK_SPACE) then
  begin
    if AtivarGrupo1() then
      LerGrupo1();
    Key := 0;
  end;

  inherited;

end;

procedure TFrmEvento.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  kEventoDrawColumnCell(Sender, Rect, DataCol, Column, State);
end;

procedure TFrmEvento.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
end;

{ Pesquisa de Eventos }

procedure FindEvento( const Pesquisa: String; DataSet: TDataSet; var Key: Word);
var
  Codigo, Ativo: Integer;
  Nome, Tipo: String;
begin

  if kEventoFind( Pesquisa, Codigo, Nome, Tipo, Ativo) then
  begin
    with DataSet do
    if (State in [dsInsert,dsEdit]) then
    begin
      if Assigned(FindField('IDEVENTO')) then
        FieldByName('IDEVENTO').AsInteger := Codigo;
      if Assigned(FindField('EVENTO')) then
        FieldByName('EVENTO').AsString := Nome;
      if Assigned(FindField('TIPO_EVENTO')) then
        FieldByName('TIPO_EVENTO').AsString := Tipo;
      if Assigned(FindField('ATIVO_X')) then
        FieldByName('ATIVO_X').AsInteger := Ativo;
    end;
  end else
  begin
    kErro('Evento não encontrado. Tente novamente !!!');
    Key := 0;
  end;

end;

procedure TFrmEvento.LerGrupo1;
var
  iEvento, i: Integer;
begin

  iEvento := pvDataSet.FieldByName('IDEVENTO').AsInteger;

  with TStringList.Create do
  try

    BeginUpdate;
    Clear;
    Add('SELECT G.IDGRUPO, G.NOME, 1 AS ATIVO_X');
    Add('FROM F_EVENTO_LISTA L');
    Add('LEFT JOIN F_EVENTO_GRUPO G ON (G.IDGRUPO = L.IDGRUPO)');
    Add('WHERE L.IDEVENTO = '+IntToStr(iEvento));
    Add('UNION ALL');
    Add('SELECT G.IDGRUPO, G.NOME, 0 AS ATIVO_X');
    Add('FROM F_EVENTO_GRUPO G');
    Add('WHERE IDGRUPO NOT IN (SELECT IDGRUPO FROM F_EVENTO_LISTA');
    Add('                      WHERE IDEVENTO = '+IntToStr(iEvento)+')');
    Add('ORDER BY 1');
    EndUpdate;

    i := cdGrupo1.FieldByName('IDGRUPO').AsInteger;

    kOpenSQL( cdGrupo1, Text);

    cdGrupo1.Locate('IDGRUPO', i, []);

  finally
    Free;
  end;

end;  // LerGrupo1

procedure TFrmEvento.LerGrupo2;
begin

  with TStringList.Create do
  try

    BeginUpdate;
    Clear;
    Add('SELECT L.IDEVENTO, E.NOME, E.TIPO_EVENTO, E.ATIVO_X');
    Add('FROM F_EVENTO_LISTA L, F_EVENTO E');
    Add('WHERE L.IDGRUPO = :G AND E.IDEVENTO = L.IDEVENTO');
    Add('ORDER BY 1');
    EndUpdate;

    kOpenSQL( cdGrupo2, Text, [cdGrupo1.FieldByName('IDGRUPO').AsInteger]);

  finally
    Free;
  end;

end;  // LerGrupo2

function TFrmEvento.AtivarGrupo1: Boolean;
var
  sSQL: String;
  iEvento, iGrupo: Integer;
begin

  iEvento := pvDataSet.FieldByName('IDEVENTO').AsInteger;

  with cdGrupo1 do
  begin
    iGrupo := FieldByName('IDGRUPO').AsInteger;
    if (FieldByName('ATIVO_X').AsInteger = 1) then
      sSQL := 'DELETE FROM F_EVENTO_LISTA WHERE IDGRUPO = :G AND IDEVENTO = :E'
    else
      sSQL := 'INSERT INTO F_EVENTO_LISTA (IDGRUPO, IDEVENTO) VALUES (:G,:E)';
  end;

  Result := kExecSQL( sSQL, [iGrupo, iEvento]);

end;  // AtivarGrupo1

procedure TFrmEvento.PageControl2Change(Sender: TObject);
begin

  if TPageControl(Sender).ActivePage = TabGrupo then
  begin
    LerGrupo1();
    if (dbgGrupo2.Tag = 0) then
    begin
     dbgGrupo2.Columns[1].Width := dbgGrupo2.Columns[1].Width -
                  (kMaxWidthColumn(dbgGrupo2.Columns, Rate) - pnlGrupo2.Width);
     dbgGrupo2.Tag := 1;
    end;

  end;

end;

procedure TFrmEvento.dbgAtivoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);
  if (Column.Field.DataSet.FieldByName('ATIVO_X').AsInteger = 0)
    then TDBGrid(Sender).Canvas.Font.Color := clGray
    else TDBGrid(Sender).Canvas.Font.Style := [fsBold];
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

procedure TFrmEvento.cdGrupo1AfterScroll(DataSet: TDataSet);
begin
  LerGrupo2();
end;

{ TFrmEventoFind }

procedure FindEvento( const Pesquisa: String; DataSet: TDataSet);
var
  Key: Word;
begin
  FindEvento( Pesquisa, DataSet, Key);
end;

function kEventoFind( const Pesquisa: String; var Codigo: Integer;
  var Nome, Tipo: String; var Ativo:Integer):Boolean;
var
  iQtde: Integer;
  bConfirmado: Boolean;
  sPesquisa: String;
  Frm: TFrmEventoFind;
begin

  Codigo    := 0;
  Nome      := '';
  Result    := False;
  sPesquisa := Pesquisa;

  if (Length(sPesquisa) = 0) then
  begin
    sPesquisa := '*';
    if not InputQuery( 'Pesquisa Eventos',
                       'Informe um texto para pesquisar', sPesquisa) then Exit;
  end;

  if (Length(sPesquisa) = 0) then
    Exit;

  Frm := TFrmEventoFind.CreateNew(Application);

  try

    with Frm do
    begin

      Options := [foNoPanel];
      sPesquisa   := UpperCase(sPesquisa);
      bConfirmado := False;

      Pesquisar(sPesquisa);

      iQtde := DataSource.DataSet.RecordCount;

      if (iQtde = 1) then
        bConfirmado := True
      else if (iQtde > 1) then
        bConfirmado := ( ShowModal = mrOk );

      if bConfirmado then
      begin
        Codigo := DataSource.DataSet.FieldByName('IDEVENTO').AsInteger;
        Nome   := DataSource.DataSet.FieldByName('NOME').AsString;
        Tipo   := DataSource.DataSet.FieldByName('TIPO_EVENTO').AsString;
        Ativo  := DataSource.DataSet.FieldByName('ATIVO_X').AsInteger;
      end;

      Result := bConfirmado;

    end;

  finally
    Frm.Free;
  end;

end;

constructor TFrmEventoFind.CreateNew(AOwner: TComponent; Dummy: Integer);
begin

  inherited;

  Caption := 'Pesquisando Eventos...';

  FDataSet := TClientDataSet.Create(Self);
  DataSource.DataSet := FDataSet;

   with DataSource.DataSet do
   begin
     FieldDefs.Add('IDEVENTO', ftInteger);
     FieldDefs.Add('NOME', ftString, 30);
     FieldDefs.Add('TIPO_EVENTO', ftString, 1);
     FieldDefs.Add('IDFORMULA', ftInteger);
     FieldDefs.Add('ATIVO_X', ftSmallInt);
     AfterOpen := OnAfterOpen;
   end;

end;

procedure TFrmEventoFind.Pesquisar( Pesquisa: String);
var
  sWhere: String;
  SQL: TStringList;
begin

  Pesquisa := kSubstitui( Pesquisa, '*', '%');

  if kNumerico(Pesquisa) then
    sWhere := 'IDEVENTO = '+Pesquisa
  else
    sWhere := 'NOME LIKE '+QuotedStr(Pesquisa+'%');

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  IDEVENTO, NOME, TIPO_EVENTO, IDFORMULA, ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_EVENTO');
    SQL.Add('WHERE '+sWhere);
    SQL.Add('ORDER BY NOME');
    SQL.EndUpdate;

    if not kOpenSQL( DataSource.DataSet, SQL.Text) then
      raise Exception.Create(kGetErrorLastSQL);

  except
    on E:Exception do
      kErro( E.Message, 'fevento', 'Pesquisar()');
  end;

end;

procedure TFrmEventoFind.GridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  kEventoDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmEventoFind.OnAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin

    if Assigned(FindField('IDEVENTO')) then
      FieldByName('IDEVENTO').DisplayLabel := 'ID Evento';

    if Assigned(FindField('NOME')) then
      FieldByName('NOME').DisplayLabel := 'Nome';

    if Assigned(FindField('TIPO_EVENTO')) then
    begin
      FieldByName('TIPO_EVENTO').DisplayLabel := 'Tipo';
      FieldByName('TIPO_EVENTO').DisplayWidth := 8;
    end;

    if Assigned(FindField('IDFORMULA')) then
      FieldByName('IDFORMULA').DisplayLabel := 'Fórmula';

    if Assigned(FindField('ATIVO_X')) then
      FieldByName('ATIVO_X').Visible := False;

  end;
end;

procedure TFrmEvento.dtsRegistroStateChange(Sender: TObject);
var
  i: Integer;
  bEditando: Boolean;
begin
  inherited;
  bEditando := TDataSource(Sender).DataSet.State in [dsInsert,dsEdit];
  for i := 3 to PageControl2.PageCount - 1 do
    PageControl2.Pages[i].TabVisible := not bEditando;
end;

end.
