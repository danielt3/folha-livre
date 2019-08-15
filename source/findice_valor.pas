{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2008 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Histórico
---------

* 06/03/2008 - Primeira versão

}

unit findice_valor;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids,
  QComCtrls, QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls, QMenus,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls, Menus,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Variants, DB, DBClient, SysUtils, Classes, Types, TypInfo;

type
  TFrmIndice = class(TForm)
  private
    { Private declarations }
    FCompany: Integer;
    FIndex: Integer;
    FIndexName: String;
    procedure GetIndex;
    procedure GetHistory;
    procedure NewIndex;
    procedure UpdateValue;
    procedure ComboBoxChange(Sender: TObject);
    procedure FecharClick(Sender: TObject);
    procedure DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure IndexNewClick(Sender: TObject);
    procedure BeforeDelete(DataSet: TDataSet);
    procedure AfterInsert(DataSet: TDataSet);
    procedure BeforePost(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AfterOpen(DataSet: TDataSet);
    procedure NewValue;
  protected
    FHistory: TDBGrid;
    dbIndex: TComboBox;
    dsHistory: TDataSource;
    cdHistory: TClientDataSet;
    FGroupIndex: TgroupBox;
    FGroupHistory: TGroupBox;
    FFechar: TButton;
    procedure FormShow(Sender: TObject); virtual;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShowIndex; virtual;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  published
    property Company: Integer read FCompany write FCompany;
    property Indice: Integer read FIndex write FIndex;
    property IndexName: String read FIndexName write FIndexName;
  end;

procedure CreateIndex(Empresa: Integer);

implementation

uses fdb, ftext, fsuporte, fcolor, fsystem, Math;

const
  cTableName = 'F_INDICE_VALOR';

procedure CreateIndex(Empresa: Integer);
begin

  if kCountSQL( 'F_INDICE', 'IDEMPRESA = :E', [Empresa]) = ZeroValue then
    kErro('Não há índces cadastrados para esta empresa.'+sLineBreak+
          'Pressione [Novo Indíce] para incluir.');

  with TFrmIndice.CreateNew(Application) do
    try
      Company := Empresa;
      ShowModal;
    finally
      Free;
    end;

end;  // CreateIndex

procedure TFrmIndice.FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmIndice.DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);
end;

procedure TFrmIndice.GetHistory;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT IDEMPRESA, IDINDICE, COMPETENCIA, VALOR, COMPLEMENTO');
    SQL.Add('FROM '+cTableName);
    SQL.Add('WHERE IDEMPRESA = :E AND IDINDICE = :T');
    SQL.Add('ORDER BY COMPETENCIA DESC');
    SQL.EndUpdate;

    if not kOpenSQL( cdHistory, SQL.Text, [Company, Indice]) then
      Exit;

  finally
    SQL.Free;

  end;

end;  // GetHistory

procedure TFrmIndice.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) and (ActiveControl = FHistory) then
    UpdateValue()
  else if (Key = VK_INSERT) then
    NewValue()
  else if (Key = VK_DELETE) then
    cdHistory.Delete
  else
    kKeyDown( Self, Key, Shift);

end;

procedure TFrmIndice.NewIndex;
var
  sIndice: String;
  iIndice: Integer;
begin

  sIndice := '';

  if not InputQuery( 'Novo Índice',
                     'Informe um nome para o novo índice', sIndice) then
    Exit;

  if (sIndice = EmptyStr) then
    raise Exception.Create('O nome do índice não pode ser vazio.');

  if not kConfirme('Incluir o índice "'+sIndice+'" ?') then
    Exit;

  sIndice := AnsiUpperCase(sIndice);
  iIndice := kMaxCodigo('F_INDICE', 'IDINDICE', Company);

  if not kExecSQL( 'INSERT INTO F_INDICE (IDEMPRESA, IDINDICE, NOME)'+sLineBreak+
                   'VALUES (:E, :I, :N)', [Company, iIndice, sIndice]) then
    Exit;

  GetIndex();

  Indice    := iIndice;
  IndexName := sIndice;

  ShowIndex();

end;  // NewIndex

procedure TFrmIndice.ShowIndex;
begin
  dbIndex.ItemIndex := dbIndex.Items.IndexOf(IntToStr(Indice)+' - '+IndexName);
  GetHistory();
end;

procedure TFrmIndice.IndexNewClick(Sender: TObject);
begin
  NewIndex();
end;

procedure TFrmIndice.BeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Excluir o valor selecionado ?') then
    SysUtils.Abort
  else if not kSQLDelete( DataSet, cTableName, DataSet.Fields) then
    SysUtils.Abort;
end;

procedure TFrmIndice.AfterInsert(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDEMPRESA').AsInteger := Company;
  DataSet.FieldByName('IDINDICE').AsInteger := Indice;
  DataSet.FieldByName('COMPETENCIA').AsDateTime := Date();
  DataSet.FieldByName('VALOR').AsCurrency := 0.0;
  DataSet.FieldByName('COMPLEMENTO').AsCurrency := 0.0;
end;

procedure TFrmIndice.BeforePost(DataSet: TDataSet);
begin
  if not kSQLCache( DataSet, cTableName, DataSet.Fields) then
    SysUtils.Abort;
end;

procedure TFrmIndice.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (cdHistory.State in [dsInsert,dsEdit]) then
    CanClose := kSQLCache( cdHistory, cTableName, cdHistory.Fields);
end;

constructor TFrmIndice.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
var
  iTop, iWidth: Integer;
  Column: TColumn;
  Button: TButton;
  Lab: TLabel;
begin

  inherited CreateNew( AOwner, Dummy);

  Self.Caption := 'Histórico de Índices';

  Self.Color := kGetColor();
  Self.Font.Name := 'Arial';

  Self.KeyPreview := True;
  Self.BorderStyle := bsDialog;
  Self.Ctl3D := False;
  Self.Position := poScreenCenter;

  Self.OnCloseQuery := FormCloseQuery;
  Self.OnKeyDown := FormKeyDown;
  Self.OnShow := FormShow;

  cdHistory := TClientDataSet.Create(Self);

  cdHistory.AfterOpen := AfterOpen;
  cdHistory.AfterInsert := AfterInsert;
  cdHistory.BeforeDelete := BeforeDelete;
  cdHistory.BeforePost := BeforePost;

  dsHistory := TDataSource.Create(Self);
  dsHistory.DataSet := cdHistory;

  dbIndex := TComboBox.Create(Self);

  // Competência

  FGroupIndex := TGroupBox.Create(Self);

  FGroupIndex.Parent := Self;
  FGroupIndex.Left := 8;
  FGroupIndex.Caption := ' &Índices ';
  FGroupIndex.Top := 8;

  dbIndex.Parent := FGroupIndex;
  dbIndex.Font.Size := dbIndex.Font.Size + 4;
  dbIndex.Font.Style := [fsBold];
  dbIndex.BevelInner := bvNone;
  dbIndex.BevelKind := bkFlat;
  dbIndex.Left := 8;
  dbIndex.Style := csDropDownList;
  dbIndex.Top := 20;
  dbIndex.Width := 300;
  dbIndex.OnChange := ComboBoxChange;

  Button := TButton.Create(Self);

  Button.Parent := FGroupIndex;
  Button.Caption := 'N&ovo Índice';
  Button.Height := dbIndex.Height;
  Button.Left := dbIndex.Left + dbIndex.Width + 8;
  Button.Top := dbIndex.Top;
  Button.Width := 100;
  Button.OnClick := IndexNewClick;

  if kGetAcesso('mniindice') <> 0 then
    Button.Enabled := False;

  iTop := Button.Top + Button.Height + 8;

  Lab := TLabel.Create(Self);

  Lab.Parent := FGroupIndex;
  Lab.Caption := 'Para incluir, modificar ou excluir índices use a opção >Cadastro>Índices';
  Lab.Font.Style := [fsBold];
  Lab.Font.Color := clRed;
  Lab.Left := 8;
  Lab.Top := iTop;

  FGroupIndex.ClientWidth := Button.Left + Button.Width + dbIndex.Left;
  FGroupIndex.ClientHeight := Lab.Top + Lab.Height + 10;

  Self.ClientWidth := FGroupIndex.Left + FGroupIndex.Width + FGroupIndex.Left;

  iWidth := FGroupIndex.Width;
  iTop := FGroupIndex.Top + FGroupIndex.Height + 8;

  // Historico

  FGroupHistory := TGroupBox.Create(Self);

  FGroupHistory.Parent := Self;
  FGroupHistory.Left := 8;
  FGroupHistory.Caption := ' &Histórico do índice ';
  FGroupHistory.Width := iWidth;
  FGroupHistory.Top := iTop;

  FHistory := TDBGrid.Create(Self);

  FHistory.Parent := FGroupHistory;
  FHistory.DataSource := dsHistory;
  FHistory.Font.Size := FHistory.Font.Size + 4;
  FHistory.Height := 300;
  FHistory.Left := 8;
  FHistory.Options := FHistory.Options + [dgRowSelect,dgAlwaysShowSelection];
  FHistory.ParentColor := True;
  FHistory.TitleFont.Size := FHistory.Font.Size;
  FHistory.TitleFont.Style := [fsBold];
  FHistory.Top := 20;
  FHistory.Width := iWidth - FHistory.Left*2;

  FHistory.OnDrawColumnCell := DrawColumnCell;

  Column := FHistory.Columns.Add;
  Column.FieldName := 'COMPETENCIA';
  Column.Title.Caption := 'Competência';
  Column.Width := (FHistory.Width div 3) - 17;

  Column := FHistory.Columns.Add;
  Column.FieldName := 'VALOR';
  Column.Title.Caption := 'Valor';
  Column.Width := (FHistory.Width div 3) - 17;

  Column := FHistory.Columns.Add;
  Column.FieldName := 'COMPLEMENTO';
  Column.Title.Caption := 'Complemento';
  Column.Width := (FHistory.Width div 3) - 17;

  iTop := FHistory.Top + FHistory.Height + 8;

  Lab := TLabel.Create(Self);

  Lab.Parent := FGroupHistory;
  Lab.Caption := 'Para manipular os valores use as teclas <Insert>, <Enter> ou <Delete>';
  Lab.Font.Style := [fsBold];
  Lab.Font.Color := clRed;
  Lab.Left := FHistory.Left;
  Lab.Top := iTop;

  FGroupHistory.ClientHeight := Lab.Top + Lab.Height + 10;

  iTop := FGroupHistory.Top + FGroupHistory.Height + 10;

  // Fechar

  FFechar := TButton.Create(Self);

  FFechar.Caption := '&Fechar';
  FFechar.Parent := Self;
  FFechar.Font.Style := [fsBold];
  FFechar.Top := iTop;
  FFechar.Left := (FGroupHistory.Left + FGroupHistory.Width) - FFechar.Width;
  FFechar.OnClick := FecharClick;

  Self.ClientHeight := FFechar.Top + FFechar.Height + 10;

end;  // CreateNew

procedure TFrmIndice.AfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDEMPRESA').ProviderFlags := [pfInKey];
    FieldByName('IDINDICE').ProviderFlags := [pfInKey];
    FieldByName('COMPETENCIA').ProviderFlags := [pfInKey];
    TCurrencyField(FieldByName('VALOR')).DisplayFormat := ',0.00#';
    TCurrencyField(FieldByName('COMPLEMENTO')).DisplayFormat := ',0.00#';
  end;
end;

procedure TFrmIndice.ComboBoxChange(Sender: TObject);
var
  iPos: Integer;
  sText: String;
begin

  sText := TComboBox(Sender).Text;
  iPos := Pos( ' - ', sText);

  Indice := StrToInt(Copy(sText, 1, iPos-1));
  IndexName := Copy( sText, iPos+3, MaxInt);

  ShowIndex();

end;

procedure TFrmIndice.FormShow(Sender: TObject);
begin
  GetIndex();
  ShowIndex();
end;  // FormShow

procedure TFrmIndice.GetIndex;
var
  DataSet1: TClientDataSet;
begin

  DataSet1 := TClientDataSet.Create(NIL);

  try

    if not kOpenSQL( DataSet1, 'SELECT * FROM F_INDICE WHERE IDEMPRESA = :E', [Company]) then
      Exit;

    dbIndex.Items.Clear;

    DataSet1.IndexFieldNames := 'NOME';
    DataSet1.First;

    while not DataSet1.Eof do
    begin
      Indice := DataSet1.FieldByName('IDINDICE').AsInteger;
      IndexName := DataSet1.FieldByName('NOME').AsString;
      dbIndex.Items.Add( IntToStr(Indice)+' - '+IndexName);
      DataSet1.Next;
    end;

  finally
    DataSet1.Free;
  end;

end;

procedure TFrmIndice.UpdateValue;
var
  sValue: String;
  cValor, cComplemento: Currency;
begin

  sValue := cdHistory.FieldByName('VALOR').AsString;

  if not InputQuery( 'Entrada de dados',
                     'Informe um novo valor para a competência', sValue) then
    Exit;

  try

    if (DecimalSeparator = '.') then
      sValue := StringReplace( sValue, ',', DecimalSeparator, [])
    else if (DecimalSeparator = ',') then
      sValue := StringReplace( sValue, '.', DecimalSeparator, []);

    cValor := StrToCurr(sValue);

  except
    kErro('O valor informado não é válido. Verifique !!!');
    Exit;
  end;

  sValue := cdHistory.FieldByName('COMPLEMENTO').AsString;

  if not InputQuery( 'Entrada de dados',
                     'Informe um novo complemento para a competência', sValue) then
    Exit;

  try

    if (DecimalSeparator = '.') then
      sValue := StringReplace( sValue, ',', DecimalSeparator, [])
    else if (DecimalSeparator = ',') then
      sValue := StringReplace( sValue, '.', DecimalSeparator, []);

    cComplemento := StrToCurr(sValue);

  except
    kErro('O valor informado não é válido. Verifique !!!');
    Exit;
  end;

  cdHistory.Edit;
  cdHistory.FieldByName('VALOR').AsCurrency := cValor;
  cdHistory.FieldByName('COMPLEMENTO').AsCurrency := cComplemento;
  cdHistory.Post;

end;  // UpdateValue;

procedure TFrmIndice.NewValue;
var
  sDate, sValue: String;
  cValor, cComplemento: Currency;
  dDate: TDateTime;
begin

  sDate := DateToStr(Date());

  if not InputQuery( 'Entrada de dados',
                     'Informe uma data para a nova competência', sDate) then
    Exit;

  try
    dDate := StrToDate(sDate);
  except
    kErro('A data informada não é válida. Verifique !!!');
    Exit;
  end;

  sValue := EmptyStr;

  if not InputQuery( 'Entrada de dados',
                     'Informe um novo valor para a competência', sValue) and
     (sValue = EmptyStr) then
    Exit;

  try

    if (DecimalSeparator = '.') then
      sValue := StringReplace( sValue, ',', DecimalSeparator, [])
    else if (DecimalSeparator = ',') then
      sValue := StringReplace( sValue, '.', DecimalSeparator, []);

    if (sValue[1] = DecimalSeparator) then
      sValue := '0'+sValue;

    cValor := StrToCurr(sValue);

  except
    kErro('O valor informado não é válido. Verifique !!!');
    Exit;
  end;

  sValue := EmptyStr;

  if not InputQuery( 'Entrada de dados',
                     'Informe um novo complemento para a competência', sValue) and
     (sValue = EmptyStr) then
    Exit;

  try

    if (DecimalSeparator = '.') then
      sValue := StringReplace( sValue, ',', DecimalSeparator, [])
    else if (DecimalSeparator = ',') then
      sValue := StringReplace( sValue, '.', DecimalSeparator, []);

    if (sValue[1] = DecimalSeparator) then
      sValue := '0'+sValue;

    cComplemento := StrToCurr(sValue);

  except
    kErro('O valor informado não é válido. Verifique !!!');
    Exit;
  end;

  cdHistory.Append;
  cdHistory.FieldByName('COMPETENCIA').AsDateTime := dDate;
  cdHistory.FieldByName('VALOR').AsCurrency := cValor;
  cdHistory.FieldByName('COMPLEMENTO').AsCurrency := cComplemento;  
  cdHistory.Post;

end;  // NewValue;

end.
