unit ucalculador_clx;

interface

uses
  Qt, SysUtils, Classes, DB, DBClient, QForms, QDialogs, QStdCtrls, QExtCtrls, QGrids,
  QDBGrids, QControls, QComCtrls, ClipperExpression;

type
  TCalculador = class(TForm)
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1CODIGO: TIntegerField;
    ClientDataSet1SALARIO: TCurrencyField;
    ClientDataSet1NOME: TStringField;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSuporte: TTabSheet;
    FuncList: TMemo;
    dbDataSet: TDBGrid;
    Memo1: TMemo;
    LogList: TListBox;
    OpenCode: TOpenDialog;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FatExpression1Evaluate(Sender: TObject; Eval: String;
      Args: array of Variant; ArgCount: Integer; var Value: Variant);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Log(const Msg: String);
  end;

var
  Calculador: TCalculador;

implementation

{$R *.xfm}

procedure TCalculador.Button1Click(Sender: TObject);
var
  sText: String;
  bk: TBookmark;
  FatExpression1: TFatExpression;
begin

  sText := Memo1.SelText;

  if (sText = '') then
    sText := Memo1.Lines.Text;

  if (ClientDataSet1.State in [dsInsert,dsEdit]) then
    ClientDataSet1.Post;

  FatExpression1 := TFatExpression.Create(NIL);

  try

    FatExpression1.OnEvaluate := FatExpression1Evaluate;
    FatExpression1.DataSetList.F := ClientDataSet1;
    FatExpression1.Functions.Assign(FuncList.Lines);

    Log( '*');

    if (Sender = Button1) then
    begin
      FatExpression1.Text := sText;
      Log('result=' + FatExpression1.AsString);
    end else
    begin
      ClientDataSet1.First;
      while not ClientDataSet1.Eof do
      begin
        FatExpression1.Text := sText;
        bk := ClientDataSet1.GetBookmark;
        Log('result=' + FatExpression1.AsString);
        ClientDataSet1.GotoBookmark(bk);
        ClientDataSet1.Next;
        ClientDataSet1.FreeBookmark(bk);
      end;
    end;

  finally
    FatExpression1.Free;
  end;

end;

procedure TCalculador.Log(const Msg: String);
begin
  LogList.Items.Add(Msg);
  LogList.TopIndex := LogList.Items.Count - 1;
  LogList.ItemIndex := LogList.Items.Count - 1;
end;

procedure TCalculador.FatExpression1Evaluate(Sender: TObject; Eval: String;
  Args: array of Variant; ArgCount: Integer; var Value: Variant);
var
  S: String;
  I: Integer;
begin

  // this code is used only to display some information
  S := '';
  if (ArgCount > 0) then
  begin
    for I := 0 to ArgCount - 1 do
      S := S + ' ' + FloatToStr(Args[I]);
    Delete(S, 1, 1);
    Log(Format('eval %s (%d) [ %s ]', [Eval, ArgCount, S]));
  end else
    Log( Format('eval %s', [Eval]));

  // here we handle the "Pi" function
  if (Eval = 'pi') then
  begin
    if (ArgCount > 0) then
      raise Exception.Create('A função PI não necessita de parametros.');
    Value := Pi
  end else if (Eval = 'add') then
  begin
    Value := 0;
    for I := 0 to ArgCount - 1 do
      Value := Value + Args[I];
  end else
    // Value := 0;  {evita que o erro ERROR_UNDECLARED ocorra}

end;

procedure TCalculador.FormCreate(Sender: TObject);
var
  Path: String;
begin
  Path := ExtractFilePath(ParamStr(0)) + 'samples'+PathDelim;
  ClientDataSet1.LoadFromFile( Path + 'dataset.xml');
  FuncList.Lines.LoadFromFile( Path + 'functions.txt');
  if FileExists( Path+'script.txt') then
    Memo1.Lines.LoadFromFile( Path + 'script.txt');
  PageControl1.ActivePageIndex := 0;
end;

procedure TCalculador.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = key_f9 then
    Button1.Click;
end;

procedure TCalculador.Button3Click(Sender: TObject);
var
  Path: String;
begin
  Path := ExtractFilePath(ParamStr(0)) + 'samples'+PathDelim;
  OpenCode.Filter := 'Text Script File (*.txt)|*.txt|';
  OpenCode.DefaultExt := '*.txt';
  OpenCode.InitialDir := Path;
  if OpenCode.Execute then
    Memo1.Lines.LoadFromFile( OpenCode.FileName);
end;

procedure TCalculador.FormClose(Sender: TObject; var Action: TCloseAction);
var
  Path: String;
begin
  Path := ExtractFilePath(ParamStr(0)) + 'samples'+PathDelim;
  ClientDataSet1.SaveToFile( Path + 'dataset.xml');
  FuncList.Lines.SaveToFile( Path + 'functions.txt');
end;

end.
