unit Encrcom;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, TabNotBk, Buttons, ClipBrd,
  ComCtrls;

type
  TForm1 = class(TForm)
    Label8: TLabel;
    TabbedNotebook1: TTabbedNotebook;
    OutputEnc_Dec: TEdit;
    Button2: TButton;
    EdSequence2: TEdit;
    Memo2: TMemo;
    Button1: TButton;
    Label3: TLabel;
    EdSequence1: TEdit;
    Input: TEdit;
    Panel1: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    GpBoxFirst: TGroupBox;
    RdButXOR1: TRadioButton;
    RdButMove1: TRadioButton;
    RdButTurning1: TRadioButton;
    GpBoxSecond: TGroupBox;
    RdButXOR2: TRadioButton;
    RdButMove2: TRadioButton;
    RdButTurning2: TRadioButton;
    GpBoxThird: TGroupBox;
    RdButMove3: TRadioButton;
    RdButXOR3: TRadioButton;
    RdButTurning3: TRadioButton;
    Label4: TLabel;
    Label1: TLabel;
    EdKey: TEdit;
    Label2: TLabel;
    EdMove: TEdit;
    ChBoxTurning: TCheckBox;
    MemoExport: TMemo;
    ChBoxDecimalOut: TCheckBox;
    Label9: TLabel;
    EdMoveDecr: TEdit;
    BitBtn1: TBitBtn;
    ButExportAll: TButton;
    ButExportMin: TButton;
    Label10: TLabel;
    EdVar: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure RdButXOR1Click(Sender: TObject);
    procedure RdButMove1Click(Sender: TObject);
    procedure RdButTurning1Click(Sender: TObject);
    procedure RdButXOR2Click(Sender: TObject);
    procedure RdButMove2Click(Sender: TObject);
    procedure RdButTurning2Click(Sender: TObject);
    procedure EdMoveChange(Sender: TObject);
    procedure InputChange(Sender: TObject);
    procedure ButExportAllClick(Sender: TObject);
    procedure ButExportMinClick(Sender: TObject);
  private
    { Private declarations }
    function ReadSequence: String;
    Procedure FindLast;
    Procedure FillInString(Str: String);
    Procedure CheckMoveNumberInput;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses fencrypt;

{$R *.DFM}

Procedure TForm1.FillInString(Str: String);

  function Turn(TextIn: String; LengthText: Integer): String;
  var
    textturned: String;
    karakter: String;
    I: Integer;
  Begin
    Delete(Textturned,1,255);
    For I := 1 to LengthText do
    Begin
      karakter := Copy(textIn, (LengthText-I+1), 1);
      textturned := Concat(textturned, karakter);
    End;
    Result := textturned;
  End;

begin
  EdSequence1.text := Str;
  EdSequence2.text := Turn(Str, 3);
end;

Procedure TForm1.FindLast;
var
  Str: String;
  Checked: Array[1..3] of Boolean;
  i: Integer;
begin
  Str := ReadSequence;
  if Length(Str) < 3 then
  begin
    for i := 1 to 3 do
      Checked[i] := False;
    for i := 1 to 2 do
    begin
      case Str[i] of
        '1': Checked[1] := True;
        '2': Checked[2] := True;
        '3': Checked[3] := True;
      end;
    end;
    for i := 1 to 3 do
    begin
      case Checked[i] of
        False : Str := Str + IntToStr(i);
      end;
    end;
    if not Checked[1] then RdButXOR3.checked := True;
    if not Checked[2] then RdButMove3.checked := True;
    if not Checked[3] then RdButTurning3.checked := True;
  end;
  FillInString(Str);
end;

Function TForm1.ReadSequence: String;
var
  Str: String;
begin
  Str := '';
  if RdButXOR1.checked then Str := '1';
  if RdButMove1.checked then Str := '2';
  if RdButTurning1.checked then Str := '3';

  if RdButXOR2.checked then
    Str := Str + '1';
  if RdButMove2.checked then
    Str := Str + '2';
  if RdButTurning2.checked then
    Str := Str + '3';

  if RdButXOR3.checked then
    Str := Str + '1';
  if RdButMove3.checked then
    Str := Str + '2';
  if RdButTurning3.checked then
    Str := Str + '3';
  ReadSequence := Str;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo2.lines.clear;
  Memo2.lines.add(
      kEnDencrypt( Input.Text, edKey.Text, ReadSequence, ChBoxTurning.Checked,
                   ChBoxDecimalOut.Checked, StrToInt(EdMove.Text) )
                  );
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  OutputEnc_Dec.Text :=
    kEnDencrypt( Memo2.lines[0]+Memo2.lines[1]+Memo2.lines[2],
                 edKey.Text, edSequence2.Text, ChBoxTurning.Checked,
                 ChBoxDecimalOut.Checked, StrToInt(EdMoveDecr.Text) );
end;

Procedure TForm1.CheckMoveNumberInput;
var
  Int: Integer;
begin
  try
    Int := StrToInt(EdMove.Text);
    if Int >  100 then EdMove.text :=  '100';
    if Int < -100 then EdMove.text := '-100';
  except
    EdMove.text := '0'
  end;

end;

procedure TForm1.RdButXOR1Click(Sender: TObject);
begin
  RdButXOR2.checked := False;
  RdButXOR3.checked := False;
  RdButXOR2.enabled := False;
  RdButmove2.enabled := True;
  RdButTurning2.enabled := True;
end;

procedure TForm1.RdButMove1Click(Sender: TObject);
begin
  RdButmove2.checked := False;
  RdButmove3.checked := False;
  RdButXOR2.enabled := True;
  RdButmove2.enabled := False;
  RdButTurning2.enabled := True;
end;

procedure TForm1.RdButTurning1Click(Sender: TObject);
begin
  RdButTurning2.checked := False;
  RdButTurning3.checked := False;
  RdButXOR2.enabled := True;
  RdButMove2.enabled := True;
  RdButTurning2.enabled := False;
end;

procedure TForm1.RdButXOR2Click(Sender: TObject);
begin
  RdButXOR3.checked := False;
  RdButXOR3.enabled := False;
  FindLast;
end;

procedure TForm1.RdButMove2Click(Sender: TObject);
begin
  RdButmove3.checked := False;
  RdButmove3.enabled := False;
  FindLast;
end;

procedure TForm1.RdButTurning2Click(Sender: TObject);
begin
  RdButTurning3.checked := False;
  RdButTurning3.enabled := False;
  FindLast;
end;

procedure TForm1.EdMoveChange(Sender: TObject);
begin
  CheckMoveNumberInput;
  EdMoveDecr.text := IntToStr(0 - StrToInt(EdMove.text));
end;

procedure TForm1.InputChange(Sender: TObject);
var
  Str: String;
begin
  Str := Input.text;
  if (length(Input.text) > 64) and ChBoxDecimalOut.checked then
  begin
    Delete(Str, 64, 255);
    Input.text := Str;
  end;
end;

procedure TForm1.ButExportAllClick(Sender: TObject);
var
  MDecimalOut: String;
  MTurning: String;
  i: Integer;
  MyStr: String;
begin
  if Memo2.lines[0] <> '' then
  begin
    If ChBoxDecimalOut.Checked then
      MDecimalOut := 'True'
    else
      MDecimalOut := 'False';
    if ChBoxTurning.Checked then
      MTurning := 'True'
    else
      MTurning := 'False';
    with memoExport.lines do
    begin
      clear;
      add('with Encode1 do');
      add('begin');
      add('  DecimalOut := ' + MDecimalOut + ';');
      add('  Key := ' + #39 + EdKey.Text + #39 + ';');
      add('  MoveNumber := ' + EdMoveDecr.Text + ';');
      add('  Sequence := ' + #39 + EdSequence2.Text + #39 + ';');
      add('  Turning := ' + MTurning + ';');
      i := 0;
      MyStr := '';
      while memo2.lines[i] <> '' do
      begin
        if MyStr <> '' then
          add(MyStr);
        if i = 0 then
          MyStr := '  TextInOut := '+ #39 + memo2.lines[i] + #39 + '+'
        else
          MyStr := '               '+ #39 + memo2.lines[i] + #39 + '+';
        inc(i);
      end;
    end;
    Delete(MyStr, Length(MyStr), 1);
    MyStr := MyStr + ';';
    memoExport.lines.add(MyStr);
    if EdVar.Text = '' then
      memoExport.lines.add('   := TextInOut;')
    else
      memoExport.lines.add('  ' + EdVar.Text + ' := TextInOut;');
    memoExport.lines.add('end;');
  end
  else
  begin
    memoExport.lines.clear;
    memoExport.lines.add('Encode result in the memo on the "Test and Input" Tab is empty!');
  end;
end;

procedure TForm1.ButExportMinClick(Sender: TObject);
var
  i: Integer;
  MyStr: String;
begin
  if Memo2.lines[0] <> '' then
  begin
    with memoExport.lines do
    begin
      clear;
      add('with Encode1 do');
      add('begin');
      add('  MoveNumber := ' + EdMoveDecr.Text + ';');
      add('  Sequence := ' + #39 + EdSequence2.Text + #39 + ';');
      i := 0;
      MyStr := '';
      while memo2.lines[i] <> '' do
      begin
        if MyStr <> '' then
          add(MyStr);
        if i = 0 then
          MyStr := '  TextInOut := '+ #39 + memo2.lines[i] + #39 + '+'
        else
          MyStr := '               '+ #39 + memo2.lines[i] + #39 + '+';
        inc(i);
      end;
    end;
    Delete(MyStr, Length(MyStr), 1);
    MyStr := MyStr + ';';
    memoExport.lines.add(MyStr);
    if EdVar.Text = '' then
      memoExport.lines.add('   := TextInOut;')
    else
      memoExport.lines.add('  ' + EdVar.Text + ' := TextInOut;');
    memoExport.lines.add('end;');
  end
  else
  begin
    memoExport.lines.clear;
    memoExport.lines.add('Encode result in the memo on the "Test and Input" Tab is empty!');
  end;
end;

end.
