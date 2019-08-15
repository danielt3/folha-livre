{
Projeto FolhaLivre - Folha de Pagamento Livre
Formulário para Pesquisa em um DataSet

Copyright (c) 2002-2009 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

{
Histórico
---------

* 19/07/2005 - Adicionado suporte para o campo de seleção 'X'
* 14/07/2006 - Adicionada a função kFindTable()
* 08/11/2008 - Adicionada a função kFindSQL()
* 07/02/2009 - Adicionado o recurso de incluir registro
}

unit ffind;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QStdCtrls, QMask, QExtCtrls,
  QDBGrids, QGrids,{$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, Mask,
  ExtCtrls, DBGrids, Grids,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, DB, DBClient, Variants, Types;

type

  TFrmFindOption = (foNoPanel, foNoTitle);
  TFrmFindOptions = set of TFrmFindOption;

  TFrmFind = class(TForm)
  protected
    procedure GridDrawColumnCell( Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState); virtual;
  private
    FPanel: TGroupBox;
    FMaskEdit: TMaskEdit;
    FGrid: TDBGrid;
    FDataSource: TDataSource;
    FOK: TButton;
    FCancelar: TButton;
    FNovo: TButton;
    Rate: Double;
    FFindField: String;
    FInsertSQL: String;
    FOptions: TFrmFindOptions;
    FTitleInsert: TCaption;
    procedure CreateControls;
    procedure MaskEditChange(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure GridTitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow( Sender: TObject);
    procedure SetOptions(Value: TFrmFindOptions);
    procedure NovoClick(Sender: TObject);
    function GetTitleInsert:TCaption;
  published
    property FindField: String read FFindField write FFindField;
    property InsertSQL: String read FInsertSQL write FInsertSQL;
    property Grid: TDBGrid read FGrid write FGrid;
    property DataSource: TDataSource read FDataSource write FDataSource;
    property Options: TFrmFindOptions read FOptions write SetOptions;
    property TitleInsert: TCaption read GetTitleInsert write FTitleInsert;
  public
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  end;

const
  FORM_INDENT = 14;

function kFindTable(
  Table: String; {Tabela a ser pesquisada}
  Title: String; {Titulo da janela de pesquisa}
  ValueFind: Variant; {Valor a pesquisar}
  FieldFind: String; {Campo a pesquisar}
  const ResultFields: Array of String; {Nome dos campos a serem retornados}
  var ResultValues: Variant; {Valores dos campos retornados}
  DisplayFields: array of String;{Campos a serem exibidos na janela de pesquisa}
  IniciarTransacao: Boolean = True):Boolean;

function kFindDataSet( DataSet1: TDataSet; FindValue: Variant;
  const FindField: String; var ResultValue: Variant;
  const ResultField: String = ''; Warning: Boolean = True):Boolean; overload;

function kFindDataSet(
  DataSet1: TDataSet;
  Title: String; {Titulo da janela de pesquisa}
  FindField: String; {Campo a pesquisar}
  var ResultValue: Variant;
  Options1: TFrmFindOptions = [];
  ResultField: String = ''):Boolean; overload;

function kFindSQL(
  SQL: String; {Tabela a ser pesquisada}
  Title: String; {Titulo da janela de pesquisa}
  const ResultFields: Array of String; {Nome dos campos a serem retornados}
  var ResultValues: Variant; {Valores dos campos retornados}
  DisplayFields: Array of String; {Campos a serem exibidos na janela de pesquisa}
  PesquisaValor: Variant;
  const PesquisaCampo: String = '';
  IniciarTransacao: Boolean = True ):Boolean;

function kFindNew(
  DataSet: TDataSet; {Tabela a ser pesquisada}
  const Title: String; {Titulo da janela de pesquisa}
  ResultFields: TStringList):Boolean; overload;

function kFindNew(
  SQL: String; const Title: String; {Titulo da janela de pesquisa}
  ResultFields: TStringList; const IniciarTransacao: Boolean = True):Boolean; overload;

implementation

uses fsuporte, ftext, fdb, fcolor, CadRegistroRapido;

function kFindTable(
  Table: String; {Tabela a ser pesquisada}
  Title: String; {Titulo da janela de pesquisa}
  ValueFind: Variant; {Valor a pesquisar}
  FieldFind: String; {Campo a pesquisar}
  const ResultFields: Array of String; {Nome dos campos a serem retornados}
  var ResultValues: Variant; {Valores dos campos retornados}
  DisplayFields: array of String;{Campos a serem exibidos na janela de pesquisa}
  IniciarTransacao: Boolean = True):Boolean;
var
  i: Integer;
  Value: Variant;
  DataSet1: TClientDataSet;
begin

  DataSet1 := TClientDataSet.Create(NIL);
  Result := False;

  try

    if not kOpenTable( DataSet1, Table, '', IniciarTransacao) then
      Exit;

    if (DataSet1.RecordCount = 0) then
    begin
      kErro('Não há registros para pesquisar. Verifique');
      Exit;
    end;

    if VarIsNull(ValueFind) or (VarIsStr(ValueFind) and (VarToStr(ValueFind)='')) then
    begin

      if Length(DisplayFields) > 0 then
      begin
        for i := 0 to DataSet1.FieldCount-1 do
          DataSet1.Fields[i].Visible := False;
        for i := 0 to Length(DisplayFields)-1 do
          DataSet1.FieldByName(DisplayFields[i]).Visible := True;
      end;

      if not kFindDataSet( DataSet1, Title, FieldFind, Value, [foNoPanel,foNoTitle]) then
        Exit;

    end else
    begin

      if not DataSet1.Locate( FieldFind, ValueFind, []) then
      begin
        kErro('Valor informado não encontrado. Verifique e tente novamente.');
        Exit;
      end;

   end;

   if (Length(ResultFields) = 1) then
     ResultValues := DataSet1.FieldByName(ResultFields[0]).Value
   else
     for i :=  0 to Length(ResultFields)-1 do
       ResultValues[i] := DataSet1.FieldByName(ResultFields[i]).Value;

   Result := True;

  finally
    DataSet1.Free;
  end;

end;

function kFindDataSet( DataSet1: TDataSet;
  Title: String;
  FindField: String; { Nome do campo a ser pesquisado }
  var ResultValue: Variant; { Valor do campo a ser retornado }
  Options1: TFrmFindOptions = []; { Opçoes }
  ResultField: String = '' { Nome do campo a ser retornado }  ):Boolean;
begin

  Result := False;

  if DataSet1.IsEmpty then
    Exit;

  if (ResultField = '') then
    ResultField := FindField;

  if (DataSet1.RecordCount = 1) then
  begin
    if (ResultField <> EmptyStr) then
      ResultValue := DataSet1.FieldByName(ResultField).Value;
    Result := True;
    Exit;
  end;

  with TFrmFind.CreateNew(Application) do
    try

      if (Title = '') then
        Title := 'Pesquisando...';

      Caption := Title;

      DataSource.DataSet := DataSet1;

      FFindField := FindField;
      FOptions   := Options1;

      ShowModal;

      {$IFDEF CLX}
      if (ModalResult = mrYes) then
      {$ELSE}
      if (ModalResult = idOK) then
      {$ENDIF}
      begin
        if (ResultField <> EmptyStr) then
          ResultValue := DataSet1.FieldByName(ResultField).Value;
        Result := True;
      end;

    finally
      Free;
    end;

end;

function kFindDataSet( DataSet1: TDataSet; FindValue: Variant;
  const FindField: String; var ResultValue: Variant;
  const ResultField: String = ''; Warning: Boolean = True):Boolean;
begin

  Result := DataSet1.Locate(FindField, VarArrayOf(FindValue), []);

  if (not Result) then
  begin
     if Warning then
       kErro( 'O valor '+VarToStr(FindValue)+' não foi encontrado. Tente novamente.')
      else
        Result := kFindDataSet(DataSet1, 'Pesquisa' {Titulo},
                               FindField {Nome do campo a ser pesquisado},
                               FindValue {Valor a ser pesquisado},
                               [foNoPanel, foNoTitle],
                               ResultField {Campo cujo conteúdo será retornado} );
  end;

  if Result then
  begin
    if (ResultField = '') then
      ResultValue := DataSet1.FieldByName(FindField).Value
    else
      ResultValue := DataSet1.FieldByName(ResultField).Value;
  end;

end;

{ TFrmFind }

constructor TFrmFind.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew( AOwner, Dummy);

  KeyPreview  := TRUE;

  OnKeyDown   := FormKeyDown;
  OnShow      := FormShow;

  FDataSource := TDataSource.Create(Owner);

  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}
  {$IFDEF VCL}
  Ctl3D := False;
  BorderStyle := bsDialog;
  {$ENDIF}

  Color := kGetColor();
  Rate := Canvas.TextWidth('W') / 11;
  Position := poScreenCenter;

  if Assigned(Application.MainForm) then
  begin
    ClientHeight := Round(Application.MainForm.Height * 0.70);
    ClientWidth := Round(Application.MainForm.Width * 0.85);
  end;

end;

procedure TFrmFind.CreateControls;
begin

  FPanel := TGroupBox.Create(Self);
  with FPanel do
  begin
    Parent      := Self;
    Caption     := 'Digite um texto para pesquisar';
    Height      := Round(Rate * 42);
    Align       := alTop;
    ParentColor := True;
    {$IFDEF FL_D2007}
    AlignWithMargins := True;
    {$ENDIF}
  end;  // with FPanel

  FMaskEdit := TMaskEdit.Create(Self);
  with FMaskEdit do
  begin
    Parent   := FPanel;
    CharCase := ecUpperCase;
    //Left     := Round(Rate * 10);
    //Top      := Round(Rate * 25);
    //Width    := Round(Rate * 200);
    Align := alClient;
    {$IFDEF FL_D2007}
    AlignWithMargins := True;
    {$ENDIF}
    OnChange := MaskEditChange;
  end;

  if (InsertSQL <> EmptyStr) then
  begin

    FNovo := TButton.Create(Self);
    with FNovo do
    begin
      Parent  := FPanel;
      ModalResult := mrNone;
      Caption := '&Incluir';
      Width := Round(Rate * 60);
      Align := alRight;
      {$IFDEF FL_D2007}
      Margins.Top := 1;
      Margins.Bottom := 1;
      AlignWithMargins := True;
      {$ENDIF}
      Name := 'btnIncluir';
      OnClick := NovoClick;
    end;

  end;

  FOK := TButton.Create(Self);
  with FOK do
  begin
    Parent  := FPanel;
    Default := True;
    ModalResult := mrOK;
    Caption := 'OK';
    //Left := FMaskEdit.Left + FMaskEdit.Width + Round(Rate * FORM_INDENT);
    //Top := FMaskEdit.Top;
    //Height := FMaskEdit.Height;
    Visible := False;
  end;

  FCancelar := TButton.Create(Self);
  with FCancelar do
  begin
    Parent := FPanel;
    ModalResult := mrCancel;
    Caption := 'Cancelar';
    //Left := FOK.Left + FOK.Width + Round(Rate * FORM_INDENT);
    //Top := FOK.Top;
    //Height := FOK.Height;
    Visible := False;
  end;

  FGrid := TDBGrid.Create(Self);

  with FGrid do
  begin
    Parent := Self;
    Align := alClient;
    DataSource := FDataSource;
    Options := Options - [dgEditing];
    Options := Options + [dgRowSelect];
    Options := Options + [dgAlwaysShowSelection];
    if (foNoTitle in FOptions) then
      FGrid.Options := FGrid.Options - [dgTitles];
    OnDblClick := GridDblClick;
    OnDrawColumnCell := GridDrawColumnCell;
    OnTitleClick := GridTitleClick;
    ParentColor := True;
    {$IFDEF FL_D2007}
    AlignWithMargins := True;
    {$ENDIF}
  end;

  FPanel.Visible := not (foNoPanel in FOptions);

  if foNoTitle in FOptions then
    FGrid.Options := FGrid.Options - [dgTitles]
  else
    FGrid.Options := FGrid.Options + [dgTitles];

end;

procedure TFrmFind.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Key = VK_DOWN) and (ActiveControl = FMaskEdit) then
  begin
    Key := 0;
    FDataSource.DataSet.Next;

  end else if (Key = VK_UP) and (ActiveControl = FMaskEdit) then
  begin
    Key := 0;
    FDataSource.DataSet.Prior;

  end else if (Key = VK_RETURN) then
  begin
    if DataSource.DataSet.IsEmpty then
      FCancelar.Click
    else
      FOK.Click;

  end else if (Key = VK_ESCAPE) then
    FCancelar.Click

  { Adicionado em 19/07/2005 por Allan Lima }

  else if (Key = VK_SPACE) and (ActiveControl = FGrid) and
          Assigned(FDataSource.DataSet.FindField('X')) then
  begin

    Key := 0;
    FDataSource.DataSet.Edit;

    if (FDataSource.DataSet.FieldByName('X').DataType in [ftSmallInt, ftInteger, ftWord]) then
    begin
      if FDataSource.DataSet.FieldByName('X').AsInteger = 0 then
        FDataSource.DataSet.FieldByName('X').AsInteger := 1
      else FDataSource.DataSet.FieldByName('X').AsInteger := 0;

    end else if (FDataSource.DataSet.FieldByName('X').DataType = ftString) then
    begin
      if FDataSource.DataSet.FieldByName('X').AsString = '' then
        FDataSource.DataSet.FieldByName('X').AsString := 'X'
      else
        FDataSource.DataSet.FieldByName('X').AsString := '';

    end else if (FDataSource.DataSet.FieldByName('X').DataType = ftBoolean) then
      FDataSource.DataSet.FieldByName('X').AsBoolean := not FDataSource.DataSet.FieldByName('X').AsBoolean;

    FDataSource.DataSet.Post;

  end else
    kKeyDown( Self, Key, Shift);

end;

procedure TFrmFind.MaskEditChange(Sender: TObject);
var s: String;
begin
  s := TMaskEdit(Sender).Text;
  if (s = EmptyStr) then
    FDataSource.DataSet.First
  else
    FDataSource.DataSet.Locate(FFindField, s, [loCaseInsensitive,loPartialKey]);
end;

procedure TFrmFind.NovoClick(Sender: TObject);
var
  lResult: TStringList;
  i: Integer;
begin

  // InsertSQL contém a instrução SQL utilizada para inserir o novo registro no banco
  lResult := CriaRegistroRapido(FDataSource.DataSet, TitleInsert, InsertSQL);

  if (lResult.Count > 0) then  // O registro foi incluído, deve-se inserir
  begin                        // um registro no DataSet e seleciona-lo
    with FDataSource.DataSet do
    begin
      Append;
      for i := 0 to lResult.Count - 1 do
        FieldByName(lResult.Names[i]).Value := lResult.ValueFromIndex[i];
      Post;
    end;
    FOK.Click;
  end;

end;

function TFrmFind.GetTitleInsert: TCaption;
begin
  if (FTitleInsert = EmptyStr) then
    Result := 'Novo Registro'
  else
    Result := FTitleInsert;
end;

procedure TFrmFind.GridDblClick(Sender: TObject);
begin
  FOK.Click;
end;

procedure TFrmFind.GridDrawColumnCell( Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TDBGrid(Sender).Focused);

  if (Column.Field.FieldName = FFindField) then
  begin
    TDBGrid(Sender).Canvas.Font.Style := TDBGrid(Sender).Canvas.Font.Style + [fsBold];
    TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
  end;

  if Assigned(Column.Field.DataSet.FindField('X')) and
     ( (Column.Field.DataSet.FieldByName('X').AsString = '1') or
       (Column.Field.DataSet.FieldByName('X').AsString = 'X') or
       (Column.Field.DataSet.FieldByName('X').AsString = 'True') ) then
  begin
    TDBGrid(Sender).Canvas.Font.Color := clBlue;
    TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
  end;

end;

procedure TFrmFind.GridTitleClick(Column: TColumn);
begin
  kTitleClick(Column.Grid, Column, NIL);
  FFindField := Column.FieldName;
  FMaskEdit.OnChange(FMaskEdit);
end;

procedure TFrmFind.FormShow(Sender: TObject);
begin
//  Width := kMaxWidthColumn( FGrid.Columns, Rate);
//  kWidthColumn(FGrid);

  CreateControls;
  
  Width := kMaxWidthColumn( FGrid.Columns, Rate);
  if (FFindField = EmptyStr) then
    GridTitleClick(FGrid.Columns[0]);

end;

procedure TFrmFind.SetOptions(Value: TFrmFindOptions);
begin

  if (FOptions <> Value) then
  begin

    FOptions := [];

    if foNoPanel in Value then
      Include( FOptions, foNoPanel);

    if foNoTitle in Value then
      Include( FOptions, foNoTitle);

    if Assigned(FPanel) then
      FPanel.Visible := not (foNoPanel in FOptions);

    if Assigned(FGrid) then
      if foNoTitle in FOptions then
        FGrid.Options := FGrid.Options - [dgTitles]
      else
        FGrid.Options := FGrid.Options + [dgTitles];

  end;

end;

function kFindSQL(
  SQL: String; {Tabela a ser pesquisada}
  Title: String; {Titulo da janela de pesquisa}
  const ResultFields: Array of String; {Nome dos campos a serem retornados}
  var ResultValues: Variant; {Valores dos campos retornados}
  DisplayFields: Array of String; {Campos a serem exibidos na janela de pesquisa}
  PesquisaValor: Variant;
  const PesquisaCampo: String = '';
  IniciarTransacao: Boolean = True  ):Boolean;
var
  i: Integer;
  Value: Variant;
  DataSet1: TClientDataSet;
begin

  DataSet1 := TClientDataSet.Create(NIL);
  Result := False;

  try

    if not kOpenSQL(DataSet1, SQL, IniciarTransacao) then
      Exit;

    if DataSet1.IsEmpty then
      Exit;

    if (PesquisaCampo = EmptyStr) or VarIsNull(PesquisaValor) or
       (VarIsStr(PesquisaValor) and (VarToStr(PesquisaValor)='')) then
    begin

      if Length(DisplayFields) > 0 then
      begin
        // Mostra no grid apenas os campos informados em DisplayFields
        for i := 0 to DataSet1.FieldCount-1 do
          DataSet1.Fields[i].Visible := False;
        for i := 0 to Length(DisplayFields)-1 do
          DataSet1.FieldByName(DisplayFields[i]).Visible := True;
      end;

      if not kFindDataSet(DataSet1, Title, '', Value, [foNoPanel,foNoTitle]) then
        Exit;

      if (Length(ResultFields) = 1) then
        ResultValues := DataSet1.FieldByName(ResultFields[0]).Value
      else
        for i := 0 to Length(ResultFields)-1 do
          if ResultFields[i] = EmptyStr then
            ResultValues[i] := DataSet1.Fields[i].Value
          else
            ResultValues[i] := DataSet1.FieldByName(ResultFields[i]).Value;

    end else
    begin

      if not DataSet1.Locate( PesquisaCampo, PesquisaValor, []) then
      begin
        kErro('Valor informado não encontrado. Verifique e tente novamente.');
        Exit;
      end;

    end;

    Result := True;

  finally
    DataSet1.Free;
  end;

end;  // kFindSQL

function kFindNew(
  DataSet: TDataSet; {Tabela a ser pesquisada}
  const Title: String; {Titulo da janela de pesquisa}
  ResultFields: TStringList):Boolean;
var
  i: Integer;
  Value: Variant;
begin

  Result := False;

  if DataSet.IsEmpty then
    Exit;

  Result := (DataSet.RecordCount = 1) or kFindDataSet(DataSet, Title, '', Value, [foNoPanel,foNoTitle]);

  if not Result then
    Exit;

  for i := 0 to DataSet.FieldCount-1 do
    if DataSet.Fields[i].IsNull then
      ResultFields.Add(DataSet.Fields[i].FieldName+'=')
    else
      ResultFields.Values[DataSet.Fields[i].FieldName] := DataSet.Fields[i].AsString;

end;  // kFindNew

function kFindNew(
  SQL: String; const Title: String; {Titulo da janela de pesquisa}
  ResultFields: TStringList; const IniciarTransacao: Boolean = True):Boolean;
var
  cs: TClientDataSet;
begin

  cs := TClientDataSet.Create(NIL);

  try
    kOpenSQL( cs, SQL, IniciarTransacao);
    Result := kFindNew( cs, Title, ResultFields)
  finally
    cs.Free;
  end;

end;

end.
