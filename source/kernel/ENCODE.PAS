{************************************************************
  This Unit contains:
  - The class/component TEncodeBaseClass and TEncode.
  - The property editor TAbout.
  - The property editor TSequence.

  Main purpose off the component TEncodeBaseClass:
  - Encode and decode a string by XOR, Shift and turning around.
  - There is no Text property published in this class. Some of the
    childeren are not allowed to have such a property.

  Main purpose off the component TEncode:
  - The same as TEncodeBaseClass but with the Text property
    published.


  Programmer               : Frank Millenaar Ir.
  Place                    : Arnhem.
  Date Start               : 30-12-1994.
  Latest change            :  3- 5-1995
  Reinplemented for Delphi : 30-11-1996
  Latest change for Delphi :  4-12-1996
************************************************************}
unit Encode;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs;

type
{  TAboutProperty = class(TPropertyEditor)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
  end;
}
{  TSequenceProperty = class(TStringProperty)
  public
    procedure Edit; override;
    function GetAttributes: TPropertyAttributes; override;
  end;
}
  TEncodeBaseClass = class(TComponent)
  private
    { Private declarations }
    FText: String;
    FKey: String;
    FTurning: Boolean;
    FMoveNumber: Integer;
    FDecimalOut: Boolean;
    FSequence: String;
//    FAbout: TAboutProperty;
    LengthText: Integer;
    LengthKey: Integer;
    procedure SetSequence(Seq: String);
    procedure SetMoveNumber(MoveN: Integer);
    procedure SetDecimalOut(Dec_Out: Boolean);
    function En_Decode: String;
    Procedure XorConversion;
    Procedure TurnConversion;
    Procedure MoveConversion;
    Procedure Make_Charakters;
    Procedure Make_numbers;
  protected
    { Protected declarations }
    function GettextBC: String;
    procedure SetTextBC(TextIn: String);
    procedure En_DecodeList(Data: TStringList);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property Key: String read FKey write Fkey;
    property Turning: Boolean read FTurning write FTurning;
    property MoveNumber: Integer read FMoveNumber write SetMoveNumber;
    property DecimalOut: Boolean read FDecimalOut write SetDecimalOut;
    property Sequence: String read FSequence write SetSequence;
//    property About: TAboutProperty read FAbout write FAbout;
  end;

  Tencode = class(TEncodeBaseClass)
  private
    { Private declarations }
    FTextInOut: String;
    function GetText: String;
    procedure SetText(TextIn: String);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property TextInOut: String read GetText write SetText;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Informatize', [TEncode]);
//  RegisterPropertyEditor(TypeInfo(String), TEncodeBaseClass, 'Sequence', TSequenceProperty);
//  RegisterPropertyEditor(TypeInfo(TAboutProperty), TEncodeBaseClass, 'About', TAboutProperty)
end;


{************************************************************
 Implementation of Property editor TSequenceProperty
*************************************************************}
{procedure TSequenceProperty.Edit;
var
  FSeq: TFormSequence;
begin
  FSeq := TFormSequence.create(Application);
  FSeq.ShowModal;
  SetStrValue(FSeq.SequenceOut);
  SetValue(FSeq.SequenceOut);
  FSeq.Free;
end;

function TSequenceProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;
}
{************************************************************
  Implementation of TEncode
*************************************************************}
constructor TEncode.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTextInOut := '';
end;

destructor TEncode.Destroy;
begin
  inherited Destroy;
end;

function TEncode.GetText: String;
begin
  FTextInOut := GetTextBC;
  Result := FTextInOut;
end;

procedure TEncode.SetText(TextIn: String);
begin
  FTextInOut := TextIn;
  SetTextBC(TextIn);
end;


{************************************************************
  Implementation of TBaseClassEncode
*************************************************************}
constructor TEncodeBaseClass.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FKey := 'ABCDE';
  FText := '';
  FTurning := True;
  FMoveNumber := 10;
  FDecimalOut := True;
  FSequence := '123';
  LengthText := 0;
  LengthKey := 0;
end;

destructor TEncodeBaseClass.Destroy;
begin
  inherited Destroy;
end;

function TEncodeBaseClass.GetTextBC: String;
begin
  FText := En_Decode;
  Result := FText;
end;

procedure TEncodeBaseClass.SetTextBC(TextIn: String);
begin
  {### One charactar can existed of 2 or 3 nummbers and
       an extra charactar '#' is placed before every number.
       There for 256/4= 64 characters #}
  if (Length(TextIn) > 64) and FDecimalOut and
      not (TextIn[1] ='#')then
    Delete(TextIn, 64, 256);
  FText := TextIn;
end;

procedure TEncodeBaseClass.SetSequence(Seq: String);
var
  FSet: Set of Char;
begin
  FSet := ['1','2','3'];
  If Not (Length(Seq) > 3) and (Seq[1] in FSet) and
         (Seq[1] in FSet) and (Seq[1] in FSet) then
    FSequence := Seq
  else
    FSequence := '123';
end;

procedure TEncodeBaseClass.SetMoveNumber(MoveN: Integer);
begin
  If MoveN > 100 then
    FMoveNumber := 100
  else
    FMoveNumber := MoveN;
  If MoveN < -100 then
    FMoveNumber := -100;
end;

procedure TEncodeBaseClass.SetDecimalOut(Dec_Out: Boolean);
begin
  FDecimalOut := Dec_Out;
  If FDecimalOut and (Length(FText) > 64) then
    Delete(FText, 64, 256);
end;

procedure TEncodeBaseClass.En_DecodeList(Data: TStringList);
var
  i: Integer;
begin
  for i := 0 to Data.count -1 do
  begin
    SetTextBC(Data.strings[i]);
    Data.strings[i] := GetTextBC;
  end;
end;

Procedure TEncodeBaseClass.Make_Charakters;
var
  I: Integer;
  StrNum: String;
  TextOut: String;
  FSet: Set of Char;
begin
  FSet := ['0','1','2','3','4','5','6','7','8','9'];
  TextOut := '';
  StrNum := '';
  for i := 1 to Length(FText) do
  begin
    if (FText[i] <> '#') and (FText[i] in FSet) then
      StrNum := StrNum + FText[i]
    else
    begin
      If StrNum <> '' then
        TextOut := Textout + chr(StrToInt(StrNum));
      StrNum := '' ;
    end;
  end;
  if StrNum <> '' then
    TextOut := Textout + chr(StrToInt(StrNum));
  FText := TextOut;
end;

Procedure TEncodeBaseClass.Make_numbers;
var
  I: Integer;
  TextOut: String;
begin
  TextOut := '';
  for i := 1 to LengthText do
  begin
    TextOut := Textout + '#' + IntToStr(ord(FText[i]));
  end;
  FText := TextOut;
end;

{************************************************************}
{* Een string wordt gecodeerd met XOR, draaien en schuiven. *}
{* In welke volgorde dit gebeurt moet worden meegegeven.    *}
{* Als codeer true is word er gecodeerd, anderd gedecodeerd.*}
{* De bewerking met XOR   = 1.                              *}
{* De bewerking omdraaien = 2.                              *}
{* De bewerking schuiven  = 3.                              *}
{* De volgorde waarin dit gebeurt staat in de string        *}
{* "Schuiven". De volgorde van de bewerkingen is bij        *}
{* decodeeren het omgekeerde van coderen!!                  *}
{************************************************************}
function TEncodeBaseClass.En_Decode: String;
var
  Choice: String;
  ChoiceInt: Integer;
  mistake: Integer;    { Val operation. }
  I: Integer;
  FromNumber: Boolean;
Begin
  if FText <> '' then
  begin
    if FDecimalOut and (FText[1] = '#') then
    begin
      Make_Charakters;
      FromNumber := True;
    end
    else
      FromNumber := False;
    LengthText := Length(FText);
    LengthKey := Length(FKey);
    For I := 1 to 3 do
    Begin
      Choice := Copy(Fsequence, I, 1);
      Val(Choice,ChoiceInt,mistake);
      Case ChoiceInt of
        1 : Begin
              if FKey <> '' then XorConversion; 
            End;
        2 : Begin
               If FTurning then TurnConversion;
             End;
        3 : Begin
              if FMoveNumber <> 0 then
              begin
              (*  If not Encode then FMoveNumber := 0 - FMoveNumber; *)
                MoveConversion;
              end;
            End;
      End; { end Case KeuzeInt of }
    End;  { end for i := 1 to 3 do }
    if DecimalOut and not FromNumber then
      Make_numbers;
  end; { end if <> '' }
  Result := FText;
End;

{************************************************************}
{* In deze procedure worden de karakters van de tekstin     *}
{* bit voor bit omgezet met XOR en de meegegeven sleutel.   *}
{* Deze procedure wordt zowel voor het coderen als het      *}
{* decoderen gebruikt.                                      *}
{************************************************************}
Procedure TEncodeBaseClass.XorConversion;
var
  StartPiece: Integer;
  WorkingPart: String;
  CodeerNum: Integer;
  KeyNum: Integer;
  CodeerKar: Char;
  I: Integer;
  FirstTime: Boolean;
  TextOut: String;
Begin
  Delete(WorkingPart,1,255);
  Delete(TextOut,1,255);
  StartPiece := 1; { Start position is character 1. }
  FirstTime := True;
  Repeat
    WorkingPart := Copy(FText, StartPiece, LengthKey); { Fill the workingpart. }
    If StartPiece+LengthKey-1 > LengthText then
    Begin
      LengthKey := LengthText+1-StartPiece;
      If FirstTime then LengthKey := LengthText;
    end;
    FirstTime := False;
    {### Do XOR on 'workingpart' with the key and place the
         result in back in the 'workingpart' #}
    For I := 1 to LengthKey do
    Begin
      CodeerNum := ORD(WorkingPart[I]);
      KeyNum := ORD(Key[I]);
      CodeerNum := CodeerNum XOR KeyNum;
      Delete(WorkingPart,I,1);
      CodeerKar := CHR(CodeerNum);
      Insert(CodeerKar, WorkingPart, I);
    End;
    TextOut := Concat(TextOut,WorkingPart); { Add workingpart to TextOut. }
    StartPiece := StartPiece + LengthKey; { Calulate next StartPiece position. }
  until StartPiece > LengthText;
  FText := TextOut;
End;

{************************************************************}
{* In deze procedure wrodt de tekst omgedraaid, het laatste *}
{* karakter wordt de eerste, etc.                           *}
{************************************************************}
Procedure TEncodeBaseClass.TurnConversion;
var
  Charakter: String;
  I: Integer;
  TextOut: String;
Begin
  Delete(TextOut,1,255);
  For I := 1 to LengthText do
  Begin
    Charakter := Copy(FText, (LengthText-I+1), 1);
    textOut := Concat(textOut, Charakter);
  End;
  FText := TextOut;
End;

{************************************************************}
{* Alle karkaters worden net zoveel opgeschoven als de      *}
{* waarde in schuiven. Als een karakter een waarde boven de *}
{* 255 zo krijgen word weer bij 0 begonnen.                 *}
{************************************************************}
Procedure TEncodeBaseClass.MoveConversion;
var
  charakterInt: Integer;
  I: Integer;
  TextOut: String;
Begin
  Delete(TextOut,1,255);
  For I := 1 to LengthText do
  Begin
    charakterInt := ORD(FText[I]);
    charakterInt := charakterInt + FMoveNumber;
    If charakterInt > 255 then
      charakterInt := charakterInt - 255;
    If charakterInt < 0 then
      charakterInt := charakterInt + 255;
    TextOut := Concat(TextOut, CHR(charakterInt));
  End;
  FText := TextOut;
End;


{************************************************************
 Implementation of Property editor TAboutProperty
*************************************************************}
{procedure TAboutProperty.Edit;
begin
  Application.MessageBox('This component is freeware. '+ #13#10+
                         '© 1996 Mill Software Development    '+ #13#10 +
                         'http://ourworld.compuserve.com/homepages/FMillenaar',
            'Mill Software Development', MB_OK + MB_ICONINFORMATION);
end;

function TAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paMultiSelect, paDialog, paReadOnly];
end;

function TAboutProperty.GetValue: string;
begin
  Result := '(about)';
end;
}

end.
