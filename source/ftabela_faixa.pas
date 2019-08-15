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

* 27/02/2008 - Primeira versão

}

unit ftabela_faixa;

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
  {$IFDEF RX_LIB}CurrEdit,{$ENDIF}
  Variants, DB, DBClient, SysUtils, Classes, Types, TypInfo;

type
  TFrmFaixa = class(TForm)
  private
    { Private declarations }
    FCompany: Integer;
    FTable: Integer;
    FTableName: String;
    FStartDate: TDateTime;
    procedure GetFaixa;
    procedure GetItem;
    procedure NewDate;
    procedure ComboBoxChange(Sender: TObject);
    procedure FecharClick(Sender: TObject);
    procedure dbgItemDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure CompetenciaNovaClick(Sender: TObject);
    procedure ValueKeyPress(Sender: TObject; var Key: Char);
    procedure cdFaixaBeforeDelete(DataSet: TDataSet);
    procedure cdFaixaAfterDelete(DataSet: TDataSet);
    procedure cdFaixaAfterInsert(DataSet: TDataSet);
    procedure cdFaixaBeforePost(DataSet: TDataSet);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cdFaixaAfterOpen(DataSet: TDataSet);
    function UpdateItem(Item: Integer; Valor: String): Boolean;
  protected
    FFaixa: TDBGrid;
    dbCompetencia: TComboBox;
    dsFaixa: TDataSource;
    cdFaixa: TClientDataSet;
    cdItem: TClientDataSet;
    FGroupDate: TgroupBox;
    FGroupItem: TGroupBox;
    FFechar: TButton;
    procedure MaxDate;
    procedure FormShow(Sender: TObject); virtual;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ShowDate; virtual;
  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
  published
    property Company: Integer read FCompany write FCompany;
    property Table: Integer read FTable write FTable;
    property TableName: String read FTableName write FTableName;
    property StartDate: TDateTime read FStartDate write FStartDate;
  end;

procedure CriaFaixa(Empresa: Integer);

implementation

uses fdb, ftext, fsuporte, DateUtils, fcolor, fevento, fsystem, ffind, ftabela,
  Math;

const
  cTableName = 'F_TABELA_FAIXA';

procedure CriaFaixa(Empresa: Integer);
var
  iTable: Integer;
  sName: String;
begin

  if kCountSQL( 'F_TABELA', 'IDEMPRESA = :E', [Empresa]) = ZeroValue then
    kErro('Não há tabelas cadastradas para esta empresa.'+sLineBreak+
          'Utilize a opção <Tabelas> do menu <Cadastro>.');

  if not FindTabela( '*', Empresa, iTable, sName) then
    Exit;

  with TFrmFaixa.CreateNew(Application) do
    try
      Company := Empresa;
      Table := iTable;
      TableName := sName;
      ShowModal;
    finally
      Free;
    end;

end;  // CriaFaixa

procedure TFrmFaixa.FecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmFaixa.dbgItemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmFaixa.MaxDate;
var
  DataSet: TClientDataSet;
  SQL: TStringList;
begin

  DataSet := TClientDataSet.Create(NIL);
  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT DISTINCT COMPETENCIA FROM '+cTableName);
    SQL.Add('WHERE IDEMPRESA = '+IntToStr(Company)+' AND IDTABELA = '+IntToStr(Table));
    SQL.Add('UNION');
    SQL.Add('SELECT DISTINCT COMPETENCIA FROM F_TABELA_ITEM');
    SQL.Add('WHERE IDEMPRESA = '+IntToStr(Company)+' AND IDTABELA = '+IntToStr(Table));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text) then
      Exit;

    DataSet.IndexFieldNames := DataSet.Fields[0].FieldName;

    dbCompetencia.Items.Clear;

    if DataSet.IsEmpty then  // Não há faixas nem itens
    begin

      StartDate := StartOfTheMonth(Date());
      dbCompetencia.Items.Add(DateToStr(StartDate));

    end else
    begin

      DataSet.First;
      while not DataSet.Eof do
      begin
        StartDate := DataSet.Fields[0].AsDateTime;
        dbCompetencia.Items.Add(DateToStr(StartDate));
        DataSet.Next;
      end;

    end;

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // MaxDate

procedure TFrmFaixa.GetItem;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT M.ITEM, M.NOME, I.VALOR');
    SQL.Add('FROM F_TABELA_MODELO M');
    SQL.Add('     LEFT JOIN F_TABELA_ITEM I ON');
    SQL.Add('          (I.IDEMPRESA = M.IDEMPRESA AND I.IDTABELA = M.IDTABELA');
    SQL.Add('           AND I.ITEM = M.ITEM AND I.COMPETENCIA = :C)');
    SQL.Add('WHERE M.IDEMPRESA = :E AND M.IDTABELA = :T ORDER BY 1');
    SQL.EndUpdate;

    if not kOpenSQL( cdItem, SQL.Text, [StartDate, Company, Table]) then
      Exit;

  finally
    SQL.Free;

  end;

end;  // GetItem

procedure TFrmFaixa.GetFaixa;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT * FROM '+cTableName);
    SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :C');
    SQL.EndUpdate;

    if not kOpenSQL( cdFaixa, SQL.Text, [Company, Table, StartDate]) then
       Exit;

    cdFaixa.IndexFieldNames := 'FAIXA;TAXA';

  finally
    SQL.Free;
  end;

end;  // GetFaixa

procedure TFrmFaixa.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  sName, sValor: String;
  iItem: Integer;
begin

  sName := ActiveControl.Name;

  if (Key = VK_RETURN) and (sName <> EmptyStr) and (sName[1] in ['i', 'I']) then
  begin

    iItem := StrToInt(Copy( sName, 2, MaxInt));
    sValor := GetStrProp(ActiveControl, 'Text');

    if (sValor = EmptyStr) then
    begin
      sValor := '0';
      SetStrProp( ActiveControl, 'Text', sValor);
    end;

    if not UpdateItem( iItem, sValor) then
      Key := 0;

  end;

  if (Key = VK_RETURN) and (ActiveControl = FFaixa) then
  else if (Key = VK_DELETE) and (ActiveControl = FFaixa) and
          (cdFaixa.State = dsBrowse) then
    cdFaixa.Delete
  else
    kKeyDown( Self, Key, Shift);

end;

procedure TFrmFaixa.NewDate;
var
  sData: String;
  SQL: TStringList;
  dData: TDateTime;
  i: Integer;
  DataSet: TClientDataSet;
  wMonth, wYear: Word;
begin

  sData := FormatDateTime('mm/yyyy', Date());

  if not InputQuery( 'Entrada da Competência',
                     'Informe uma data no formato mês/ano (mm/aaaa)', sData) then
    Exit;

  try
    i := Pos('/', sData);
    if (i = 0) then
      raise Exception.Create('');
    wMonth := StrToInt(Copy(sData, 1, i-1));
    wYear := StrToInt(Copy(sData, i+1, Length(sData)));
    dData := EncodeDate(  wYear, wMonth, 1);
  except
    kErro('A entrada não é uma data válida.');
    Exit;
  end;

  i := kCountSQL( 'SELECT COUNT(*) FROM '+cTableName+sLineBreak+
                  'WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :C',
                  [Company, Table, dData]);

  if (i > 0) then
  begin
    kErro('A competência informada já está cadastrada');
    if (StartDate <> dData) then
    begin
      StartDate := dData;
      ShowDate();
    end;
    Exit;
  end;

  if not kConfirme('Incluir a competência '+
                   FormatDateTime('mmmm/yyyy', dData)+'?') then
    Exit;

  SQL     := TStringList.Create;
  DataSet := TClientDataSet.Create(NIL);

  try

    // Itens

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT MAX(COMPETENCIA) FROM F_TABELA_ITEM');
    SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA < :D');
    SQL.EndUpdate;

    // Encontra a competencia imediatamente menor que a nova competencia
    if not kOpenSQL( DataSet, SQL.Text, [Company, Table, dData]) then
      Exit;

    // Encontrou competencia anterior, cria uma nova baseada nela
    if not DataSet.IsEmpty then
    begin

      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('INSERT INTO F_TABELA_ITEM');
      SQL.Add('(IDEMPRESA, IDTABELA, COMPETENCIA, ITEM, VALOR)');
      SQL.Add('SELECT IDEMPRESA, IDTABELA, :C, ITEM, VALOR');
      SQL.Add('FROM F_TABELA_ITEM');
      SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :DATA');
      SQL.EndUpdate;

      if not kExecSQL( SQL.Text, [dData, Company, Table,
                                  DataSet.Fields[0].AsDateTime] ) then
        Exit;

    end;

    // Faixas

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT MAX(COMPETENCIA) FROM '+cTableName);
    SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA < :D');
    SQL.EndUpdate;

    // Encontra a competencia imediatamente menor que a nova competencia
    if not kOpenSQL( DataSet, SQL.Text, [Company, Table, dData]) then
      Exit;

    // Encontrou competencia anterior, cria uma nova baseada nela
    if not DataSet.IsEmpty then
    begin

      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('INSERT INTO '+cTableName);
      SQL.Add('(IDEMPRESA, IDTABELA, COMPETENCIA, IDFAIXA,');
      SQL.Add(' FAIXA, TAXA, REDUZIR, ACRESCENTAR)');
      SQL.Add('SELECT IDEMPRESA, IDTABELA, :C, IDFAIXA,');
      SQL.Add('       FAIXA, TAXA, REDUZIR, ACRESCENTAR FROM '+cTableName);
      SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :DATA');
      SQL.EndUpdate;

      if not kExecSQL( SQL.Text, [dData, Company, Table,
                                  DataSet.Fields[0].AsDateTime] ) then
        Exit;

    end;

    MaxDate();         // Refaz o Items de dbCompetencia

    StartDate := dData;

    // Pode ser que para a nova competencia ainda não tenha faixas e itens
    if dbCompetencia.Items.IndexOf(DateToStr(StartDate)) = -1 then
      dbCompetencia.Items.Add(DateToStr(StartDate));

    ShowDate();

  finally
    SQL.Free;
    DataSet.Free;
  end;

end;  // NewDate

procedure TFrmFaixa.ShowDate;
var
  dbControl: TComponent;
begin

  dbCompetencia.ItemIndex := dbCompetencia.Items.IndexOf(DateToStr(StartDate));

  GetItem();

  cdItem.First;
  while not cdItem.Eof do
  begin
    dbControl := Self.FindComponent('i'+cdItem.FieldByName('ITEM').AsString);
    if Assigned(dbControl) then
      SetStrProp( dbControl, 'Text', cdItem.FieldByName('VALOR').AsString);
    cdItem.Next;
  end;

  GetFaixa();

end;  // ShowDate

procedure TFrmFaixa.CompetenciaNovaClick(Sender: TObject);
begin
  NewDate();
end;

procedure TFrmFaixa.ValueKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key in ['.',',']) then
    Key := DecimalSeparator
  else if Ord(Key) in [33..47] then
    Key := #0
  else if Ord(Key) in [58..255] then
    Key := #0;
end;

procedure TFrmFaixa.cdFaixaBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Excluir a faixa selecionada ?') then
    SysUtils.Abort
  else if not kSQLDelete( DataSet, 'F_TABELA_FAIXA', DataSet.Fields) then
    SysUtils.Abort;
end;

procedure TFrmFaixa.cdFaixaAfterInsert(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDEMPRESA').AsInteger := Company;
    FieldByName('IDTABELA').AsInteger := Table;
    FieldByName('COMPETENCIA').AsDateTime := StartDate;
    FieldByName('IDFAIXA').AsInteger :=
         kMaxCodigo('F_TABELA_FAIXA', 'IDFAIXA',
                    'IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :C',
                    [Company, Table, StartDate]);
    FieldByName('FAIXA').AsCurrency := 0.0;
    FieldByName('TAXA').AsCurrency := 0.0;
    FieldByName('REDUZIR').AsCurrency := 0.0;
    FieldByName('ACRESCENTAR').AsCurrency := 0.0;
  end;
end;

procedure TFrmFaixa.cdFaixaBeforePost(DataSet: TDataSet);
begin
  if not kSQLCache( DataSet, 'F_TABELA_FAIXA', DataSet.Fields) then
    SysUtils.Abort;
end;

procedure TFrmFaixa.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (cdFaixa.State in [dsInsert,dsEdit]) then
    CanClose := kSQLCache( cdFaixa, 'F_TABELA_FAIXA', cdFaixa.Fields);
end;

constructor TFrmFaixa.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew( AOwner, Dummy);

  Self.Color := kGetColor();
  Self.Font.Name := 'Arial';

  Self.KeyPreview := True;
  Self.BorderStyle := bsDialog;
  Self.Ctl3D := False;
  Self.Position := poScreenCenter;

  Self.OnCloseQuery := FormCloseQuery;
  Self.OnKeyDown := FormKeyDown;
  Self.OnShow := FormShow;

  cdFaixa := TClientDataSet.Create(Self);

  cdFaixa.AfterOpen := cdFaixaAfterOpen;
  cdFaixa.AfterInsert := cdFaixaAfterInsert;
  cdFaixa.AfterDelete := cdFaixaAfterDelete;
  cdFaixa.BeforeDelete := cdFaixaBeforeDelete;
  cdFaixa.BeforePost := cdFaixaBeforePost;

  dsFaixa := TDataSource.Create(Self);
  dsFaixa.DataSet := cdFaixa;

  cdItem := TClientDataSet.Create(Self);

  dbCompetencia := TComboBox.Create(Self);

end;  // CreateNew

procedure TFrmFaixa.cdFaixaAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDEMPRESA').ProviderFlags := [pfInKey];
    FieldByName('IDTABELA').ProviderFlags := [pfInKey];
    FieldByName('COMPETENCIA').ProviderFlags := [pfInKey];
    FieldByName('IDFAIXA').ProviderFlags := [pfInKey];
    TCurrencyField(FieldByName('FAIXA')).DisplayFormat := ',0.00';
    TCurrencyField(FieldByName('TAXA')).DisplayFormat := ',0.## %';
    TCurrencyField(FieldByName('REDUZIR')).DisplayFormat := ',0.00';
    TCurrencyField(FieldByName('ACRESCENTAR')).DisplayFormat := ',0.00';
  end;
end;

procedure TFrmFaixa.ComboBoxChange(Sender: TObject);
begin
  StartDate := StrToDate(dbCompetencia.Text);
  ShowDate();
end;

procedure TFrmFaixa.FormShow(Sender: TObject);
var
  iTop, iLeft, iWidth: Integer;
  Edit: TEdit;
  {$IFDEF RX_LIB}
  EditValor: TCurrencyEdit;
  {$ELSE}
  EditValor: TMaskEdit;
  {$ENDIF}
  Lab: TLabel;
  Column: TColumn;
  Button: TButton;
begin

  Self.Caption := 'Tabela de '+TableName;

  // Competência

  FGroupDate := TGroupBox.Create(Self);

  FGroupDate.Parent := Self;
  FGroupDate.Left := 8;
  FGroupDate.Caption := ' &Competência ';
  FGroupDate.Top := 8;

  dbCompetencia.Parent := FGroupDate;
  dbCompetencia.Font.Size := dbCompetencia.Font.Size + 4;
  dbCompetencia.Font.Style := [fsBold];
  dbCompetencia.BevelInner := bvNone;
  dbCompetencia.BevelKind := bkFlat;
  dbCompetencia.Left := 8;
  dbCompetencia.Style := csDropDownList;
  dbCompetencia.Top := 20;
  dbCompetencia.Width := 220;
  dbCompetencia.OnChange := ComboBoxChange;

  Button := TButton.Create(Self);

  Button.Parent := FGroupDate;
  Button.Caption := 'N&ova Competência';
  Button.Height := dbCompetencia.Height;
  Button.Left := dbCompetencia.Left + dbCompetencia.Width + 8;
  Button.Top := dbCompetencia.Top;
  Button.Width := 150;
  Button.OnClick := CompetenciaNovaClick;

  FGroupDate.ClientWidth := Button.Left + Button.Width + dbCompetencia.Left;
  FGroupDate.ClientHeight := dbCompetencia.Top + dbCompetencia.Height + 10;

  Self.ClientWidth := FGroupDate.Left + FGroupDate.Width + FGroupDate.Left;

  iWidth := FGroupDate.Width;
  iTop := FGroupDate.Top + FGroupDate.Height + 10;

  MaxDate();

  GetItem();

  if (cdItem.RecordCount > ZeroValue) then
  begin

    // Itens

    FGroupItem := TGroupBox.Create(Self);

    FGroupItem.Parent := Self;
    FGroupItem.Left := 8;
    FGroupItem.Width := iWidth;
    FGroupItem.Caption := ' &Itens ';
    FGroupItem.Top := iTop;

    iTop := 20;
    cdItem.First;

    while not cdItem.Eof do
    begin

      iLeft := 8;

      Edit := TEdit.Create(Self);
      Edit.Parent := FGroupItem;
      Edit.Text := cdItem.FieldByName('ITEM').AsString;
      Edit.Left := iLeft;
      Edit.Top := iTop;
      Edit.ReadOnly := True;
      Edit.TabStop := False;
      Edit.ParentColor := True;
      Edit.Width := 50;

      iLeft := Edit.Left + Edit.Width + 5;

      Edit := TEdit.Create(Self);
      Edit.Parent := FGroupItem;
      Edit.Text := cdItem.FieldByName('NOME').AsString;
      Edit.Left := iLeft;
      Edit.Top := iTop;
      Edit.ReadOnly := True;
      Edit.TabStop := False;
      Edit.ParentColor := True;
      Edit.Width := 200;

      iLeft := Edit.Left + Edit.Width + 5;

      {$IFDEF RX_LIB}
      EditValor := TCurrencyEdit.Create(Self);
      EditValor.DisplayFormat := ',0.##';
      {$ELSE}
      EditValor := TMaskEdit.Create(Self);
      {$ENDIF}
      EditValor.Parent := FGroupItem;
      EditValor.Name := 'i'+cdItem.FieldByName('ITEM').AsString;
      EditValor.Left := iLeft;
      EditValor.Top := iTop;
      EditValor.Width := 100;
      EditValor.OnKeyPress := ValueKeyPress;

      iTop := EditValor.Top + EditValor.Height + 8;

      cdItem.Next;

    end;

    Lab := TLabel.Create(Self);

    Lab.Parent := FGroupItem;
    Lab.Caption := 'Nota: Ao alterar algum valor utilize a tecla ENTER para gravá-lo.';
    Lab.Font.Style := [fsBold];
    Lab.Font.Color := clRed;
    Lab.Left := 8;
    Lab.Top := iTop;

    FGroupItem.ClientHeight := Lab.Top + Lab.Height + 10;

    iTop := FGroupItem.Top + FGroupItem.Height + 10;

  end;  // cdItem.RecordCount

  // Faixas

  FFaixa := TDBGrid.Create(Self);

  FFaixa.Parent := Self;
  FFaixa.DataSource := dsFaixa;
  FFaixa.Height := 200;
  FFaixa.Left := FGroupDate.Left;
  FFaixa.Width := iWidth;
  FFaixa.Options := FFaixa.Options - [dgTabs];
  FFaixa.ParentColor := True;
  FFaixa.ParentFont := True;
  FFaixa.TitleFont.Style := [fsBold];
  FFaixa.Top := iTop;

  FFaixa.OnDrawColumnCell := dbgItemDrawColumnCell;

  Column := FFaixa.Columns.Add;
  Column.FieldName := 'FAIXA';
  Column.Title.Caption := 'Faixa - Até';
  Column.Width := 100;

  Column := FFaixa.Columns.Add;
  Column.FieldName := 'TAXA';
  Column.Title.Caption := 'Taxa';
  Column.Width := 70;

  Column := FFaixa.Columns.Add;
  Column.FieldName := 'REDUZIR';
  Column.Title.Caption := 'Dedução';
  Column.Width := 94;

  Column := FFaixa.Columns.Add;
  Column.FieldName := 'ACRESCENTAR';
  Column.Title.Caption := 'Acréscimo';
  Column.Width := 94;

  iTop := FFaixa.Top + FFaixa.Height + 10;

  // Fechar

  FFechar := TButton.Create(Self);

  FFechar.Caption := '&Fechar';
  FFechar.Parent := Self;
  FFechar.Font.Style := [fsBold];
  FFechar.Top := iTop;
  FFechar.Left := (FFaixa.Left + FFaixa.Width) - FFechar.Width;
  FFechar.OnClick := FecharClick;

  Self.ClientHeight := FFechar.Top + FFechar.Height + 10;

  ShowDate();

end;  // FormShow

function TFrmFaixa.UpdateItem( Item: Integer; Valor: String): Boolean;
var
  SQL: TStringList;
  cValor: Currency;
begin

  Result := False;
  SQL := TStringList.Create;

  try try

    if (DecimalSeparator = '.') then
      Valor := StringReplace( Valor, ',', DecimalSeparator, [])
    else if (DecimalSeparator = ',') then
      Valor := StringReplace( Valor, '.', DecimalSeparator, []);

    cValor := StrToCurr(Valor);

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) FROM F_TABELA_ITEM');
    SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :C');
    SQL.EndUpdate;

    if (kCountSQL( SQL.Text, [Company, Table, StartDate]) = ZeroValue) then
    begin

      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('INSERT INTO F_TABELA_ITEM');
      SQL.Add('  (IDEMPRESA, IDTABELA, COMPETENCIA, ITEM, VALOR)');
      SQL.Add('SELECT IDEMPRESA, IDTABELA, :C, ITEM, :V');
      SQL.Add('FROM F_TABELA_MODELO');
      SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T');
      SQL.EndUpdate;

      if not kExecSQL( SQL.Text, [StartDate, 0.0, Company, Table]) then
        Exit;

    end;

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('UPDATE F_TABELA_ITEM SET VALOR = :V');
    SQL.Add('WHERE IDEMPRESA = :E AND IDTABELA = :T');
    SQL.Add('      AND COMPETENCIA = :C AND ITEM = :I');
    SQL.EndUpdate;

    Result := kExecSQL( SQL.Text, [cValor, Company, Table, StartDate, Item]);

  except
    Result := False;   end;

  finally
    SQL.Free;          end;

end;  // UpdateItem

procedure TFrmFaixa.cdFaixaAfterDelete(DataSet: TDataSet);
begin

  if (DataSet.RecordCount = ZeroValue) and (cdItem.RecordCount > ZeroValue) and
     kConfirme('Você excluiu a última faixa desta competência.'+sLineBreak+
               'Deseja excluir também os valores dos itens ?') and
     kExecSQL('DELETE FROM F_TABELA_ITEM'+sLineBreak+
              'WHERE IDEMPRESA = :E AND IDTABELA = :T AND COMPETENCIA = :C',
              [Company, Table, StartDate]) then
    ShowDate();

end;

end.
