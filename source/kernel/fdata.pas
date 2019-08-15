unit fdata;

interface

function kIdade( Nascimento: TDateTime): Integer; overload;
function kIdade( Nascimento, Hoje: TDateTime): Integer; overload;

function kMonthYearToStr( Month: Word; Year: Word = 0):String; overload;
function kMonthYearToStr( Data: TDateTime):String; overload;

function kMonthToStr(Month:Integer=0): String;

// Conta a quantidade de dias da semana (1-7) entre duas datas
function kWeekDayCount( const D1, D2: TDateTime; const Week: Integer): Integer;

implementation

uses SysUtils, cDateTime, DateUtils;

function kMonthYearToStr( Month: Word; Year: Word = 0):String;
const
  aMes: array [1..12] of String =
           ('Janeiro', 'Fevereiro', 'Marco', 'Abril', 'Maio', 'Junho',
            'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro');

begin
  Result := aMes[Month];
  if (Year > 0) then
    Result := Result + '/' + IntToStr(Year);
end;

function kMonthYearToStr( Data: TDateTime):String;
begin
  Result := kMonthYearToStr( MonthOf(Data), YearOf(Data));
end;

function kIdade( Nascimento: TDateTime):Integer;
begin
  Result := kIdade(Nascimento, Date());
end;

function kIdade( Nascimento, Hoje: TDateTime):Integer;
begin

  Result := 0;

  if (Nascimento = 0) or (Hoje = 0) or (Nascimento > Hoje) then
    Exit;

  Result := Year(Hoje) - Year(Nascimento);

  if Month(Hoje) < Month(Nascimento) then
    Result := Result - 1
  else if (Month(Hoje) = Month(Nascimento)) and
          (Day(Hoje) < Day(Nascimento)) then
    Result := Result - 1;

end;

function kMonthToStr(Month:Integer=0): String;
begin
  if Month = 0 then Month := MonthOf(Date());
  Result := Copy( 'JANFEVMARABRMAIJUNJULAGOSETOUTNOVDEZ', ((Month-1)*3)+1, 3);
end;

// Conta a quantidade de dias da semana (1-7) entre duas datas
function kWeekDayCount( const D1, D2: TDateTime; const Week: Integer): Integer;
var
  Ye, Mo, Da: Word;
  Dt1, Dt2: TDateTime;
begin

  Result := 0;

  DecodeDate(D1, Ye, Mo, Da);
  Dt1 := EncodeDate(Ye, Mo, Da);

  DecodeDate(D2, Ye, Mo, Da);
  Dt2 := EncodeDate(Ye, Mo, Da);

  while Dt1 <= Dt2 do
  begin
    if (DayOfWeek(Dt1) = Week) then
      Inc(Result);
    Dt1 := Dt1 + 1;
  end;

end;

end.
