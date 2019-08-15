unit AKExpression;

{$I AKLIB.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF AK_D6}DateUtils,{$ENDIF}
  FatExpression;

type
  TAKExpression = class(TFatExpression)
  protected
    procedure EvaluateCustom( Sender: TObject; Eval: String;
      Args: array of Variant; ArgCount: Integer;
      var Value: {$IFDEF AK_D6}Variant{$ELSE}Double{$ENDIF};
      var Done: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

procedure Register;

implementation

const
  ERROR_FUNCTION_PARAMETER = 'Function "%s" invalid number parameter.';

procedure Register;
begin
  RegisterComponents( 'AK Lib', [TAKExpression]);
end;

constructor TAKExpression.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TAKExpression.EvaluateCustom( Sender: TObject; Eval: String;
  Args: array of Variant; ArgCount: Integer;
  var Value: {$IFDEF AK_D6}Variant{$ELSE}Double{$ENDIF};
  var Done: Boolean);

  procedure ErrorParameter( ParamCount: Integer);
  begin
    if (Length(Args) <> ParamCount) then
      raise Exception.CreateFmt( ERROR_FUNCTION_PARAMETER, [Eval]);
  end;

var
  i: Integer;
begin

  Eval  := UpperCase(Eval);
  Done  := True;

  // funcoes matematica basicas adicionadas {Allan}
  if (Eval = 'ABS') then
  begin
    ErrorParameter(1);
    Value := Abs( Args[0]);

  end else if (Eval = 'FRAC') then
  begin
    ErrorParameter(1);
    Value := Frac(Args[0])

  end else if (Eval = 'INT') then
  begin
    ErrorParameter(1);
    Value := Int(Args[0])

  end else if (Eval = 'MAX') then
  begin

    Value := Args[0];

    for i := 0 to High(Args) do
      if Args[i] > Value then
        Value := Args[i];

  end else if (Eval = 'MIN') then
  begin

    Value := Args[0];

    for i := 0 to High(Args) do
      if (Args[i] < Value) then
        Value := Args[i];

  end else if (Eval = 'MOD') then
  begin
    ErrorParameter(2);
    Value := Trunc(Args[0]) mod Trunc(Args[1])

  end else if (Eval = 'ROUND') then
  begin

    if (Length(Args) = 0) or (Length(Args) > 2) then
      raise Exception.CreateFmt( ERROR_FUNCTION_PARAMETER, [Eval]);

    if (Length(Args) < 2) then
      i := 2
    else
      i := Round(Args[1]);

    Value := StrToFloat( Format( '%0.'+IntToStr(i)+'f', [Double(Args[0])] ) );

  end else if (Eval = 'SIGN') then
  begin

    ErrorParameter(1);

    if Args[0] = Abs(Args[0]) then
      Value := 1
    else if Args[0] = 0 then
      Value := 0
    else
      Value := -1;

  end else if (Eval = 'SQRT') then {Returns the square root of X.}
  begin
    ErrorParameter(1);
    Value := Sqrt(Args[0]);

  end else if (Eval = 'SIN') then {Returns the sine of the angle in radians.}
  begin
    ErrorParameter(1);
    Value := Sin(Args[0]);

  end else if (Eval = 'COS') then  {Calculates the cosine of an angle.}
  begin
    ErrorParameter(1);
    Value := Cos(Args[0]);

  end else if (Eval = 'TAN') then
  begin
    ErrorParameter(1);
    Value := Sin(Args[0])/Cos(Args[0]);

  end else if (Eval = 'ATAN') then {Calculates the arctangent of a given number.}
  begin
    ErrorParameter(1);
    Value := ArcTan(Args[0]);

  end else if (Eval = 'LN') then {Returns the natural log of a real expression.}
  begin
    ErrorParameter(1);
    Value := Ln(Args[0]);

  end else if (Eval = 'EXP') then    {Returns the exponential of X.}
  begin
    ErrorParameter(1);
    Value := Exp(Args[0]);

  end else if (Eval = 'SUM') then
  begin

    Value := 0;

    for i := 0 to High(Args) do
      Value := Value + Args[i];

  end else if (Eval = 'TRUNC') then
  begin
    ErrorParameter(1);
    Value := Trunc(Args[0])

  // ********* BOOLEAN FUNCTIONS *******
  end else if (Eval = 'AND') then
  begin
    Value := 1;
    for i := 0 to High(Args) do
      if (Args[i] = 0) then
      begin
        Value := 0;
        Break;
      end;

  end else if (Eval = 'OR') then
  begin
    Value := 0;
    for i := 0 to High(Args) do
      if (Args[i] = 1) then
      begin
        Value := 1;
        Break;
      end;

  end else if (Eval = 'IF') then
  begin

    ErrorParameter(3);

    if Args[0] = 1 then
      Value := Args[1]
    else
      Value := Args[2];

  // ********* OUTER FUNCTIONS
  end else if (Eval = 'RANDOM') then
  begin

    ErrorParameter(1);
    Value := Random(Integer(Args[0]));

  end else if (Eval = 'RANDOMIZE') then
  begin

    ErrorParameter(0);
    Value := 0;
    Randomize;

  // ********* STRING FUNCTIONS ***********

  end else if (Eval = 'ASC') then
  begin
    ErrorParameter(1);
    Value := Ord( String(Args[0])[1]);

  end else if (Eval = 'CHR') then
  begin
    ErrorParameter(1);
    Value := Chr(Integer(Args[0]));

  end else if (Eval = 'COPY') or (Eval = 'SUBSTR') or (Eval = 'MID') then
  begin
    ErrorParameter(3);
    Value := Copy( String(Args[0]), Integer(Args[1]), Integer(Args[2]));

  end else if (Eval='LOWER') or (Eval='LOWERCASE') or (Eval='LCASE') then
  begin
    ErrorParameter(1);
    Value := LowerCase(String(Args[0]));

  end else if (Eval='UPPER') or (Eval='UPPERCASE') or (Eval='UCASE') then
  begin
    ErrorParameter(1);
    Value := UpperCase(String(Args[0]));

  end else if (Eval = 'POS') then
  begin
    ErrorParameter(2);
    Value := Pos( String(Args[0]), String(Args[1]));

  end else if (Eval = 'TRIM') then
  begin
    ErrorParameter(1);
    Value := Trim(String(Args[0]));

  // ********* DATE / TIME FUNCTIONS ***********

  end else if (Eval = 'DATE') then
  begin
    ErrorParameter(0);
    Value := DateToStr(Date);

  end else if (Eval = 'DAY') then
  begin
    if (ArgCount = 0) then
      Value := DayOf(Date)
    else if (ArgCount = 1) then
      Value := DayOf(Args[0])
    else
      ErrorParameter(ArgCount+1);

  end else if (Eval = 'DAYOF') then
  begin
    ErrorParameter(1);
    Value := DayOf( Args[0]);

  end else if (Eval = 'MONTH') then
  begin

    if (ArgCount = 0) then
      Value := MonthOf(Date)
    else if (ArgCount = 1) then
      Value := MonthOf( Args[0])
    else
      ErrorParameter(ArgCount+1);

  end else if (Eval = 'MONTHOF') then
  begin

    ErrorParameter(1);
    Value := MonthOf(Args[0]);

  end else if (Eval = 'YEAR') then
  begin

    if (ArgCount = 0) then
      Value := YearOf(Date)
    else if (ArgCount = 1) then
      Value := YearOf(Args[0])
    else
      ErrorParameter(ArgCount+1);

  end else if (Eval = 'YEAROF') then
  begin
    ErrorParameter(1);
    Value := YearOf(Args[0]);

  end else if (Eval = 'TIME') then
  begin
    ErrorParameter(0);
    Value := TimeToStr(Time);
  end else
    Done := False;

end;

end.

