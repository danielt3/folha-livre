unit cDateTime;

interface

uses
  SysUtils;   // Exception, DateTime functions



{                                                                              }
{ DateTime unit v0.05 (L0)                                                     }
{                                                                              }
{   A collection of date/time functions.                                       }
{                                                                              }
{                                                                              }
{ This unit is copyrighted © 1999-2000 by David Butler (david@e.co.za)         }
{                                                                              }
{ This unit is part of Delphi Fundamentals, it's original name is cDateTime.   }
{                                                                              }
{ I invite you to use this unit, free of charge.                               }
{ I invite you to distibute this unit, but it must be for free.                }
{ I also invite you to contribute to its development, but do not distribute    }
{ a modified copy of this file, send modifications, suggestions and bug        }
{ reports to david@e.co.za                                                     }
{                                                                              }
{                                                                              }
{ A good source of information on calendars is the FAQ ABOUT CALENDARS,        }
{ available at http://www.tondering.dk/claus/calendar.html                     }
{                                                                              }
{ Note the following (and more) is available in SysUtils:                      }
{   Function IsLeapYear (Year : Word) : Boolean                                }
{     (1 = Sunday .. 7 = Saturday)                                             }
{   Function EncodeDate (Year, Month, Day : Word) : TDateTime;                 }
{   Procedure DecodeDate (D : DateTime; var Year, Month, Day : Word);          }
{   var ShortDayNames, LongDayNames, ShortMonthNames, LongMonthNames : Array   }
{                                                                              }
{                                                                              }
{ Revision history:                                                            }
{   1999/11/10  v0.01  Initial version from scratch. Add functions. DayOfYear. }
{   1999/11/21  v0.02  EasterSunday function. Diff functions. ISOInteger.      }
{   2000/03/04  v0.03  Moved RFC functions to cInternetStandards.              }
{   2000/03/05  v0.04  Added Time Zone functions from cInternetStandards.      }
{   2000/05/03  v0.05  Added ISO Week functions, courtesy of Martin Boonstra   }
{                      (m.boonstra@imn.nl)                                     }
{                                                                              }
{                                                                              }



type
  EDateTime = class (Exception);

{                                                                              }
{ Decoding                                                                     }
{                                                                              }
Function Century (const D : TDateTime) : Word; stdcall;
Function Year (const D : TDateTime) : Word; stdcall;
Function Month (const D : TDateTime) : Word; stdcall;
Function Day (const D : TDateTime) : Word; stdcall;
Function Hour (const D : TDateTime) : Word; stdcall;
Function Minute (const D : TDateTime) : Word; stdcall;
Function Second (const D : TDateTime) : Word; stdcall;
Function Millisecond (const D : TDateTime) : Word; stdcall;

const
  OneDay         = 1.0;
  OneHour        = OneDay / 24.0;
  OneMinute      = OneHour / 60.0;
  OneSecond      = OneMinute / 60.0;
  OneMillisecond = OneSecond / 1000.0;


{                                                                              }
{ Comparison                                                                   }
{                                                                              }
Function IsEqual (const D1, D2 : TDateTime) : Boolean; overload;
Function IsEqual (const D1 : TDateTime; const Ye, Mo, Da : Word) : Boolean; overload;
Function IsEqual (const D1 : TDateTime; const Ho, Mi, Se, ms : Word) : Boolean; overload;
Function IsAM (const D : TDateTime) : Boolean;
Function IsPM (const D : TDateTime) : Boolean;
Function IsMidnight (const D : TDateTime) : Boolean;
Function IsNoon (const D : TDateTime) : Boolean;
Function IsSunday (const D : TDateTime) : Boolean;
Function IsMonday (const D : TDateTime) : Boolean;
Function IsTuesday (const D : TDateTime) : Boolean;
Function IsWedneday (const D : TDateTime) : Boolean;
Function IsThursday (const D : TDateTime) : Boolean;
Function IsFriday (const D : TDateTime) : Boolean;
Function IsSaturday (const D : TDateTime) : Boolean;
Function IsWeekend (const D : TDateTime) : Boolean;



{                                                                              }
{ Relative date/times                                                          }
{                                                                              }
Function Noon (const D : TDateTime) : TDateTime;
Function Midnight (const D : TDateTime) : TDateTime;
Function FirstDayOfMonth (const D : TDateTime) : TDateTime;
Function LastDayOfMonth (const D : TDateTime) : TDateTime;
Function NextWorkday (const D : TDateTime) : TDateTime;
Function PreviousWorkday (const D : TDateTime) : TDateTime;
Function FirstDayOfYear (const D : TDateTime) : TDateTime;
Function LastDayOfYear (const D : TDateTime) : TDateTime;
Function EasterSunday (const Year : Word) : TDateTime;
Function GoodFriday (const Year : Word) : TDateTime;

Function AddMilliseconds (const D : TDateTime; const N : Integer) : TDateTime;
Function AddSeconds (const D : TDateTime; const N : Integer) : TDateTime;
Function AddMinutes (const D : TDateTime; const N : Integer) : TDateTime;
Function AddHours (const D : TDateTime; const N : Integer) : TDateTime;
Function AddDays (const D : TDateTime; const N : Integer) : TDateTime;
Function AddWeeks (const D : TDateTime; const N : Integer) : TDateTime;
Function AddMonths (const D : TDateTime; const N : Integer) : TDateTime;
Function AddYears (const D : TDateTime; const N : Integer) : TDateTime;



{                                                                              }
{ Counting                                                                     }
{   DayOfYear and WeekNumber start at 1.                                       }
{   WeekNumber is not the ISO week number but the week number where week one   }
{     starts at Jan 1.                                                         }
{   For reference: ISO standard 8601:1988 - (European Standard EN 28601).      }
{     "It states that a week is identified by its number in a given year.      }
{      A week begins with a Monday (day 1) and ends with a Sunday (day 7).     }
{      The first week of a year is the one which includes the first Thursday   }
{      (day 4), or equivalently the one which includes January 4.              }
{      In other words, the first week of a new year is the week that has the   }
{      majority of its days in the new year."                                  }
{   ISOFirstWeekOfYear returns the start date (Monday) of the first ISO week   }
{     of a year (may be in the previous year).                                 }
{   ISOWeekNumber returns the ISO Week number and the year to which the week   }
{     number applies.                                                          }
{                                                                              }
Function  DayOfYear (const Ye, Mo, Da : Word) : Integer; overload;
Function  DayOfYear (const D : TDateTime) : Integer; overload;
Function  DaysInMonth (const Ye, Mo : Word) : Integer; overload;
Function  DaysInMonth (const D : TDateTime) : Integer; overload;
Function  DaysInYear (const Ye : Word) : Integer; overload;
Function  DaysInYear (const D : TDateTime) : Integer; overload;
Function  WeekNumber (const D : TDateTime) : Integer;
Function  ISOFirstWeekOfYear (const Ye : Integer) : TDateTime;
Procedure ISOWeekNumber (const D : TDateTime; var WeekNumber, WeekYear : Word);



{                                                                              }
{ Difference                                                                   }
{                                                                              }
Function DiffMilliseconds (const D1, D2 : TDateTime) : Int64; stdcall;
Function DiffSeconds (const D1, D2 : TDateTime) : Integer; stdcall;
Function DiffMinutes (const D1, D2 : TDateTime) : Integer; stdcall;
Function DiffHours (const D1, D2 : TDateTime) : Integer; stdcall;
Function DiffDays (const D1, D2 : TDateTime) : Integer; stdcall;
Function DiffWeeks (const D1, D2 : TDateTime) : Integer; stdcall;
Function DiffMonths (const D1, D2 : TDateTime) : Integer; stdcall;
Function DiffYears (const D1, D2 : TDateTime) : Integer; stdcall;



{                                                                              }
{ Time Zone                                                                    }
{   Uses systems regional settings to convert between local and GMT time.      }
{                                                                              }
{$IFDEF MSWINDOWS}
Function GMTTimeToLocalTime (const D : TDateTime) : TDateTime;
Function LocalTimeToGMTTime (const D : TDateTime) : TDateTime;
{$ENDIF}



{                                                                              }
{ Conversions                                                                  }
{   ANSI Integer is an integer in the format YYYYDDD (where DDD = day number)  }
{   ISO-8601 Integer date is an integer in the format YYYYMMDD.                }
{   TropicalYear is the time for one orbit of the earth around the sun.        }
{   TwoDigitYearToYear returns the full year number given a two digit year.    }
{   SynodicMonth is the time between two full moons.                           }
{                                                                              }
Function DateTimeToANSI (const D : TDateTime) : Integer;
Function ANSIToDateTime (const Julian : Integer) : TDateTime;
Function DateTimeToISOInteger (const D : TDateTime) : Integer;
Function DateTimeToISO (const D : TDateTime) : String;
Function ISOIntegerToDateTime (const ISOInteger : Integer) : TDateTime;
Function TwoDigitYearToYear (const Y : Integer) : Integer;
Function DateTimeAsElapsedTime (const D : TDateTime) : String;


{                                                                              }
{ High-precision timing                                                        }
{   StartTimer returns an encoded time (running timer).                        }
{   StopTimer returns an encoded elapsed time (stopped timer).                 }
{   ResumeTimer returns an encoded time (running timer), given an encoded      }
{     elapsed time (stopped timer).                                            }
{   ZeroElapsed returns an encoded elapsed time of zero, ie a stopped timer    }
{     with no time elapsed.                                                    }
{   MillisecondsElapsed returns the time elapsed, given a running or a stopped }
{     Timer.                                                                   }
{   Times are encoded in CPU clock cycles.                                     }
{   CPU clock frequency returns the number of CPU clock cycles per second.     }
{                                                                              }

{$IFDEF MSWINDOWS}

type
  THPTimer = Int64;

Function  StartTimer : THPTimer;
Procedure StopTimer (var Timer : THPTimer);
Procedure ResumeTimer (var StoppedTimer : THPTimer);
Function  ZeroElapsed : THPTimer;
Function  MillisecondsElapsed (const Timer : THPTimer; const TimerRunning : Boolean = True) : Integer;
Function  CPUClockFrequency : Int64;

{$ENDIF}

const
  TropicalYear = 365.24219 * OneDay;
  SynodicMonth = 29.53059 * OneDay;



implementation



uses
  {$IFDEF MSWINDOWS}
  Windows,     // TTimeZoneInformation
  {$ENDIF}
  Math,
  // Delphi Fundamentals (L0)
  cStrings;


{                                                                              }
{ Decoding                                                                     }
{                                                                              }
Function Century (const D : TDateTime) : Word;
  Begin
    Result := Year (D) div 100;
  End;

Function Year (const D : TDateTime) : Word;
var Mo, Da : Word;
  Begin
    DecodeDate (D, Result, Mo, Da);
  End;

Function Month (const D : TDateTime) : Word;
var Ye, Da : Word;
  Begin
    DecodeDate (D, Ye, Result, Da);
  End;

Function Day (const D : TDateTime) : Word;
var Ye, Mo : Word;
  Begin
    DecodeDate (D, Ye, Mo, Result);
  End;

Function Hour (const D : TDateTime) : Word;
var Mi, Se, MS : Word;
  Begin
    DecodeTime (D, Result, Mi, Se, MS);
  End;

Function Minute (const D : TDateTime) : Word;
var Ho, Se, MS : Word;
  Begin
    DecodeTime (D, Ho, Result, Se, MS);
  End;

Function Second (const D : TDateTime) : Word;
var Ho, Mi, MS : Word;
  Begin
    DecodeTime (D, Ho, Mi, Result, MS);
  End;

Function Millisecond (const D : TDateTime) : Word;
var Ho, Mi, Se : Word;
  Begin
    DecodeTime (D, Ho, Mi, Se, Result);
  End;



{                                                                              }
{ Comparison                                                                   }
{                                                                              }
Function IsEqual (const D1, D2 : TDateTime) : Boolean;
  Begin
    Result := Abs (D1 - D2) < OneMillisecond;
  End;

Function IsEqual (const D1 : TDateTime; const Ye, Mo, Da : Word) : Boolean;
var Ye1, Mo1, Da1 : Word;
  Begin
    DecodeDate (D1, Ye1, Mo1, Da1);
    Result := (Da = Da1) and (Mo = Mo1) and (Ye = Ye1);
  End;

Function IsEqual (const D1 : TDateTime; const Ho, Mi, Se, ms : Word) : Boolean;
var Ho1, Mi1, Se1, ms1 : Word;
  Begin
    DecodeTime (D1, Ho1, Mi1, Se1, ms1);
    Result := (ms = ms1) and (Se = Se1) and (Mi = Mi1) and (Ho = Ho1);
  End;

Function IsAM (const D : TDateTime) : Boolean;
  Begin
    Result := Frac (D) < 0.5;
  End;

Function IsPM (const D : TDateTime) : Boolean;
  Begin
    Result := Frac (D) >= 0.5;
  End;

Function IsNoon (const D : TDateTime) : Boolean;
  Begin
    Result := Abs (Frac (D) - 0.5) < OneMillisecond;
  End;

Function IsMidnight (const D : TDateTime) : Boolean;
var T : TDateTime;
  Begin
    T := Frac (D);
    Result := (T < OneMillisecond) or (T > 1.0 - OneMillisecond);
  End;

Function IsSunday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 1;
  End;

Function IsMonday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 2;
  End;

Function IsTuesday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 3;
  End;

Function IsWedneday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 4;
  End;

Function IsThursday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 5;
  End;

Function IsFriday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 6;
  End;

Function IsSaturday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) = 7;
  End;

Function IsWeekend (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) in [1, 7];
  End;

Function IsWeekday (const D : TDateTime) : Boolean;
  Begin
    Result := DayOfWeek (D) in [2..6];
  End;



{                                                                              }
{ Relative calculations                                                        }
{                                                                              }
Function Noon (const D : TDateTime) : TDateTime;
  Begin
    Result := Int (D) + 0.5 * OneDay;
  End;

Function Midnight (const D : TDateTime) : TDateTime;
  Begin
    Result := Int (D);
  End;

Function NextWorkday (const D : TDateTime) : TDateTime;
  Begin
    Case DayOfWeek (D) of
      1..5 : Result := Trunc (D) + OneDay;                                      // 1..5 Sun..Thu
      6    : Result := Trunc (D) + 3 * OneDay;                                  // 6    Fri
      else Result := Trunc (D) + 2 * OneDay;                                    // 7    Sat
    end;
  End;

Function PreviousWorkday (const D : TDateTime) : TDateTime;
  Begin
    Case DayOfWeek (D) of
      1 : Result := Trunc (D) - 2 * OneDay;                                     // 1    Sun
      2 : Result := Trunc (D) - 3 * OneDay;                                     // 2    Mon
      else Result := Trunc (D) - OneDay;                                        // 3..7 Tue-Sat
    end;
  End;

Function LastDayOfMonth (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, Mo, DaysInMonth (Ye, Mo));
  End;

Function FirstDayOfMonth (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, Mo, 1);
  End;

Function LastDayOfYear (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, 12, 31);
  End;

Function FirstDayOfYear (const D : TDateTime) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := EncodeDate (Ye, 1, 1);
  End;

{ This algorithm comes from http://www.tondering.dk/claus/calendar.html:       }
{ " This algorithm is based in part on the algorithm of Oudin (1940) as        }
{   quoted in "Explanatory Supplement to the Astronomical Almanac",            }
{   P. Kenneth Seidelmann, editor.                                             }
{   People who want to dig into the workings of this algorithm, may be         }
{   interested to know that                                                    }
{     G is the Golden Number-1                                                 }
{     H is 23-Epact (modulo 30)                                                }
{     I is the number of days from 21 March to the Paschal full moon           }
{     J is the weekday for the Paschal full moon (0=Sunday, 1=Monday,etc.)     }
{     L is the number of days from 21 March to the Sunday on or before         }
{       the Paschal full moon (a number between -6 and 28) "                   }
Function EasterSunday (const Year : Word) : TDateTime;
var C, I, J, H, G, L : Integer;
    D, M : Word;
  Begin
    G := Year mod 19;
    C := Year div 100;
    H := (C - C div 4 - (8 * C + 13) div 25 + 19 * G + 15) mod 30;
    I := H - (H div 28) * (1 - (H div 28) * (29 div (H + 1)) * ((21 - G) div 11));
    J := (Year + Year div 4 + I + 2 - C + C div 4) mod 7;
    L := I - J;
    M := 3 + (L + 40) div 44;
    D := L + 28 - 31 * (M div 4);
    Result := EncodeDate (Year, M, D);
  End;

Function GoodFriday (const Year : Word) : TDateTime;
  Begin
    Result := EasterSunday (Year) - 2 * OneDay;
  End;

Function AddMilliseconds (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + OneMillisecond * N;
  End;

Function AddSeconds (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + OneSecond * N;
  End;

Function AddMinutes (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + OneMinute * N;
  End;

Function AddHours (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + OneHour * N;
  End;

Function AddDays (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + N;
  End;

Function AddWeeks (const D : TDateTime; const N : Integer) : TDateTime;
  Begin
    Result := D + N * 7 * OneDay;
  End;

Function AddMonths (const D : TDateTime; const N : Integer) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Inc (Ye, N div 12);
    Inc (Mo, N mod 12);
    if Mo > 12 then
      begin
        Dec (Mo, 12);
        Inc (Ye);
      end else
      if Mo < 1 then
        begin
          Inc (Mo, 12);
          Dec (Ye);
        end;
    Da := Min (Da, DaysInMonth (Ye, Mo));
    Result := EncodeDate (Ye, Mo, Da) + Frac (D);
  End;

Function AddYears (const D : TDateTime; const N : Integer) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Inc (Ye, N);
    Da := Min (Da, DaysInMonth (Ye, Mo));
    Result := EncodeDate (Ye, Mo, Da);
  End;




{                                                                              }
{ Counting                                                                     }
{                                                                              }
const
  DaysInNonLeapMonth : Array [1..12] of Integer = (
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
  CumDaysInNonLeapMonth : Array [1..12] of Integer = (
    0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);

Function DayOfYear (const Ye, Mo, Da : Word) : Integer; overload;
  Begin
    Result := CumDaysInNonLeapMonth [Mo] + Da;
    if (Mo > 2) and IsLeapYear (Ye) then
      Inc (Result);
  End;

Function DayOfYear (const D : TDateTime) : Integer; overload;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := DayOfYear (Ye, Mo, Da);
  End;

Function DaysInMonth (const Ye, Mo : Word) : Integer;
  Begin
    Result := DaysInNonLeapMonth [Mo];
    if (Mo = 2) and IsLeapYear (Ye) then
      Inc (Result);
  End;

Function DaysInMonth (const D : TDateTime) : Integer;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := DaysInMonth (Ye, Mo);
  End;

Function DaysInYear (const Ye : Word) : Integer;
  Begin
    if IsLeapYear (Ye) then
      Result := 366 else
      Result := 365;
  End;

Function DaysInYear (const D : TDateTime) : Integer;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := DaysInYear (Ye);
  End;

Function WeekNumber (const D : TDateTime) : Integer;
  Begin
    Result := (DiffDays (FirstDayOfYear (D), D) div 7) + 1;
  End;

{ ISO Week functions courtesy of Martin Boonstra (m.boonstra@imn.nl)           }
Function ISOFirstWeekOfYear (const Ye : Integer) : TDateTime;
const WeekStartOffset : Array [1..7] of Integer = (1, 0, -1, -2, -3, 3, 2);
            // Weekday  Start of ISO week 1 is
            //  1 Su          02-01-Year
            //  2 Mo          01-01-Year
            //  3 Tu          31-12-(Year-1)
            //  4 We          30-12-(Year-1)
            //  5 Th          29-12-(Year-1)
            //  6 Fr          04-01-Year
            //  7 Sa          03-01-Year
  Begin
    // Adjust with an offset from 01-01-Ye
    Result := EncodeDate (Ye, 1, 1);
    Result := AddDays (Result, WeekStartOffset [DayOfWeek (Result)]);
  End;

Procedure ISOWeekNumber (const D : TDateTime; var WeekNumber, WeekYear : Word);
var Ye : Word;
    ISOFirstWeekOfPrevYear,
    ISOFirstWeekOfCurrYear,
    ISOFirstWeekOfNextYear : TDateTime;
  Begin
    { 3 cases:                                                       }
    {   1: D < ISOFirstWeekOfCurrYear                                }
    {       D lies in week 52/53 of previous year                    }
    {   2: ISOFirstWeekOfCurrYear <= D < ISOFirstWeekOfNextYear      }
    {       D lies in week N (1..52/53) of this year                 }
    {   3: D >= ISOFirstWeekOfNextYear                               }
    {       D lies in week 1 of next year                            }
    Ye := Year (D);
    ISOFirstWeekOfCurrYear := ISOFirstWeekOfYear (Ye);
    if D >= ISOFirstWeekOfCurrYear then
      begin
        ISOFirstWeekOfNextYear := ISOFirstWeekOfYear (Ye + 1);
        if (D < ISOFirstWeekOfNextYear) then
          begin // case 2
            WeekNumber := DiffDays (ISOFirstWeekOfCurrYear, D) div 7 + 1;
            WeekYear := Ye;
          end else
          begin // case 3
            WeekNumber := 1;
            WeekYear := Ye + 1;
          end;
      end else
      begin // case 1
        ISOFirstWeekOfPrevYear := ISOFirstWeekOfYear (Ye - 1);
        WeekNumber := DiffDays (ISOFirstWeekOfPrevYear, D) div 7 + 1;
        WeekYear := Ye - 1;
      end;
  End;


{                                                                              }
{ Difference                                                                   }
{                                                                              }
Function DiffMilliseconds (const D1, D2 : TDateTime) : Int64;
  Begin
    Result := Trunc ((D2 - D1) / OneMillisecond);
  End;

Function DiffSeconds (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc ((D2 - D1) / OneSecond);
  End;

Function DiffMinutes (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc ((D2 - D1) / OneMinute);
  End;

Function DiffHours (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc ((D2 - D1) / OneHour);
  End;

Function DiffDays (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc (D2 - D1);
  End;

Function DiffWeeks (const D1, D2 : TDateTime) : Integer;
  Begin
    Result := Trunc (D2 - D1) div 7;
  End;

Function DiffMonths (const D1, D2 : TDateTime) : Integer;
var Ye1, Mo1, Da1 : Word;
    Ye2, Mo2, Da2 : Word;
    ModMonth1,
    ModMonth2     : TDateTime;
  Begin
    DecodeDate (D1, Ye1, Mo1, Da1);
    DecodeDate (D2, Ye2, Mo2, Da2);
    Result := (Ye2 - Ye1) * 12 + (Mo2 - Mo1);
    ModMonth1 := Da1 + Frac (D1);
    ModMonth2 := Da2 + Frac (D2);
    if (D2 > D1) and (ModMonth2 < ModMonth1) then
      Dec (Result);
    if (D2 < D1) and (ModMonth2 > ModMonth1) then
      Inc (Result);
  End;

Function DiffYears (const D1, D2 : TDateTime) : Integer;
var Ye1, Mo1, Da1 : Word;
    Ye2, Mo2, Da2 : Word;
    ModYear1,
    ModYear2      : TDateTime;
  Begin
    DecodeDate (D1, Ye1, Mo1, Da1);
    DecodeDate (D2, Ye2, Mo2, Da2);
    Result := Ye2 - Ye1;
    ModYear1 := Mo1 * 31 + Da1 + Frac (Da1);
    ModYear2 := Mo2 * 31 + Da2 + Frac (Da2);
    if (D2 > D1) and (ModYear2 < ModYear1) then
      Dec (Result);
    if (D2 < D1) and (ModYear2 > ModYear1) then
      Inc (Result);
  End;



{                                                                              }
{ Conversions                                                                  }
{                                                                              }
Function DateTimeToANSI (const D : TDateTime) : Integer;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := Ye * 1000 + DayOfYear (Ye, Mo, Da);
  End;

Function ANSIToDateTime (const Julian : Integer) : TDateTime;
var DDD, M, Y : Integer;
    I, C, J   : Integer;
  Begin
    DDD := Julian mod 1000;
    if DDD = 0 then
      raise EDateTime.Create ('Invalid ANSI date format');

    Y := Julian div 1000;
    M := 0;
    C := 0;
    For I := 1 to 12 do
      begin
        J := DaysInNonLeapMonth [I];
        if (I = 2) and IsLeapYear (Y) then
          Inc (J);
        Inc (C, J);
        if C >= DDD then
          begin
            M := I;
            break;
          end;
      end;
    if M = 0 then // DDD > end of year
      raise EDateTime.Create ('Invalid ANSI date format');

    Result := EncodeDate (Y, M, DDD - C + J);
  End;

Function DateTimeToISOInteger (const D : TDateTime) : Integer;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := Ye * 10000 + Mo * 100 + Da;
  End;

Function DateTimeToISO (const D : TDateTime) : String;
var Ye, Mo, Da : Word;
  Begin
    DecodeDate (D, Ye, Mo, Da);
    Result := IntToStr (Ye) + '-' +
              PadLeft (IntToStr (Mo), '0', 2) + '-' +
              PadLeft (IntToStr (Da), '0', 2);
  End;

Function ISOIntegerToDateTime (const ISOInteger : Integer) : TDateTime;
var Ye, Mo, Da : Word;
  Begin
    Ye := ISOInteger div 10000;
    Mo := (ISOInteger mod 10000) div 100;
    if (Mo < 1) or (Mo > 12) then
      raise EDateTime.Create ('Invalid ISO Integer date format');
    Da := ISOInteger mod 100;
    if (Da < 1) or (Da > DaysInMonth (Ye, Mo)) then
      raise EDateTime.Create ('Invalid ISO Integer date format');
    Result := EncodeDate (Ye, Mo, Da);
  End;

Function DateTimeAsElapsedTime (const D : TDateTime) : String;
  Begin
    Result := IntToStr (Trunc (D) * 24 + Hour (D)) + ':' +
              PadLeft (IntToStr (Minute (D)), '0', 2) + ':' +
              PadLeft (IntToStr (Second (D)), '0', 2);
  End;


{$IFDEF MSWINDOWS}

{                                                                              }
{ Time Zone                                                                    }
{                                                                              }

{ Returns the GMT bias (in minutes) from the operating system's regional       }
{ settings.                                                                    }
Function GMTBias : Integer;
var TZI : TTimeZoneInformation;
  Begin
    GetTimeZoneInformation (TZI);
    Result := TZI.Bias;
  End;

{ Converts GMT Time to Local Time                                              }
Function GMTTimeToLocalTime (const D : TDateTime) : TDateTime;
  Begin
    Result := D - GMTBias / (24 * 60);
  End;

{ Converts Local Time to GMT Time                                              }
Function LocalTimeToGMTTime (const D : TDateTime) : TDateTime;
  Begin
    Result := D + GMTBias / (24 * 60);
  End;

{$ENDIF}
  
{ Quickie: Hard coded with a radix of year 2000.                               }
Function TwoDigitYearToYear (const Y : Integer) : Integer;
  Begin
    if Y < 50 then
      Result := 2000 + Y else
      Result := 1900 + Y;
  End;

{                                                                              }
{ High-precision timing                                                        }
{                                                                              }
var
  HighPrecisionTimerInit : Boolean = False;
  HighPrecisionFactor    : Int64;

{$IFDEF MSWINDOWS}
Function CPUClockFrequency : Int64;
  Begin
    QueryPerformanceFrequency (Result);
  End;

Function StartTimer : Int64;
  Begin
    if not HighPrecisionTimerInit then
      begin
        HighPrecisionFactor := CPUClockFrequency;
        HighPrecisionFactor := HighPrecisionFactor div 1000;
        HighPrecisionTimerInit := True;
      end;
    QueryPerformanceCounter (Result);
  End;

Function MillisecondsElapsed (const Timer : Int64; const TimerRunning : Boolean = True) : Integer;
var I : Int64;
  Begin
    if not TimerRunning then
      Result := Timer div HighPrecisionFactor else
      begin
        QueryPerformanceCounter (I);
        Result := (I - Timer) div HighPrecisionFactor;
      end;
  End;

Procedure StopTimer (var Timer : Int64);
var I : Int64;
  Begin
    QueryPerformanceCounter (I);
    Timer := I - Timer;
  End;

Procedure ResumeTimer (var StoppedTimer : Int64);
  Begin
    StoppedTimer := StartTimer - StoppedTimer;
  End;

Function ZeroElapsed : Int64;
  Begin
    Result := 0;
  End;

{$ENDIF MSWINDOWS}

end.

