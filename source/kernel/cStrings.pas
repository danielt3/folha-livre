
{$INCLUDE cHeader.inc}

unit cStrings;

interface

uses
  // Delphi Fundamentals (L0)
  cUtils;



{                                                                              }
{ Strings unit v0.14 (L0)                                                      }
{                                                                              }
{   A collection of string functions.                                          }
{                                                                              }
{                                                                              }
{ This unit is copyright © 1999-2000 by David Butler (david@e.co.za)           }
{                                                                              }
{ This unit is part of Delphi Fundamentals, it's original name is cStrings.    }
{                                                                              }
{ I invite you to use this unit, free of charge.                               }
{ I invite you to distibute this unit, but it must be for free.                }
{ I also invite you to contribute to its development, but do not distribute    }
{ a modified copy of this file, send modifications, suggestions and bug        }
{ reports to david@e.co.za                                                     }
{                                                                              }
{                                                                              }
{ Revision history:                                                            }
{   1999/10/19  v0.01  Spawned from Maths unit.                                }
{   1999/10/26  v0.02  Documentation.                                          }
{   1999/10/30  v0.03  Added Count, Reverse.                                   }
{                      Implemented the Boyer-Moore-Horspool pattern searching  }
{                      algorithm in assembly.                                  }
{   1999/10/31  v0.04  Coded Match function in assembly.                       }
{                      Added Replace, Count, PadInside.                        }
{   1999/11/06  v0.05  261 lines interface, 772 lines implementation.          }
{                      Added Remove, TrimEllipse.                              }
{   1999/11/09  v0.06  Added Pack functions.                                   }
{   1999/11/17  v0.07  Added Cut to Pad )                                      }
{                      Added PosN, Before, After and Between.                  }
{                      Added CountWords. Added Split.                          }
{   1999/11/22  v0.08  Added Join. Added Pad (I : Integer).                    }
{   1999/11/23  v0.09  Added Translate.                                        }
{   1999/12/02  v0.10  Added NumToRoman.                                       }
{                      Fixed bugs in Replace and Match reported by             }
{                      daiqingbo@netease.com                                   }
{   1999/12/27  v0.11  Added SelfTest procedure.                               }
{                      Bug fixes. Removed flawed NumToRoman.                   }
{   2000/01/04  v0.12  Added InsensitiveCharSet.                               }
{   2000/01/08  v0.13  Added Append.                                           }
{   2000/05/08  v0.14  Cleaned up unit.                                        }
{                                                                              }



{                                                                              }
{ Character constants                                                          }
{                                                                              }
const
  // ASCII codes
  ASCII_NULL       = #0;
  ASCII_BELL       = #7;
  ASCII_BS         = #8;
  ASCII_HT         = #9;
  ASCII_LF         = #10;
  ASCII_VT         = #11;
  ASCII_FF         = #12;
  ASCII_CR         = #13;
  ASCII_EOF        = #26;
  ASCII_ESC        = #27;
  ASCII_SP         = #32;
  ASCII_DEL        = #127;
  ASCII_CTL        = [#0..#31];
  ASCII_TEXT       = [#32..#127];

  // Common
  c_Tab            = ASCII_HT;
  c_Space          = ASCII_SP;
  c_DecimalPoint   = '.';
  c_CRLF           = ASCII_CR + ASCII_LF;

  cs_Everything    = [#0..#255];
  cs_AlphaLow      = ['a'..'z'];
  cs_AlphaHigh     = ['A'..'Z'];
  cs_Numeric       = ['0'..'9'];
  cs_Alpha         = cs_AlphaLow + cs_AlphaHigh;
  cs_AlphaNumeric  = cs_Numeric + cs_Alpha;
  cs_WhiteSpace    = [#0..#31, ASCII_SP, ASCII_DEL];
  cs_Exponent      = ['E', 'e'];
  cs_HexDigit      = cs_Numeric + ['A'..'F', 'a'..'f'];
  cs_OctalDigit    = ['0'..'7'];
  cs_BinaryDigit   = ['0'..'1'];
  cs_Sign          = ['+', '-'];
  cs_Quotes        = ['"', ''''];
  cs_Parentheses   = ['(', ')'];
  cs_CurlyBrackets = ['{', '}'];
  cs_BlockBrackets = ['[', ']'];
  cs_Punctuation   = ['.', ',', ':', '/', '?', '<', '>', ';', '"', '''',
                      '[', ']', '{', '}', '+', '=', '-', '\', '(', ')', '*',
                      '&', '^', '%', '$', '#', '@', '!', '`', '~'];
  cs_LowerA        = ['a', 'â', 'ä', 'à', 'å', 'á'];
  cs_LowerE        = ['e', 'é', 'ê', 'ë', 'è'];
  cs_LowerI        = ['i', 'ï', 'î', 'ì', 'í'];
  cs_LowerN        = ['n', 'ñ'];
  cs_LowerO        = ['o', 'ô', 'ö', 'ò', 'ó'];
  cs_LowerU        = ['u', 'ü', 'û', 'ù', 'ú'];
  cs_LowerY        = ['y', 'ÿ'];
  cs_Lower         = cs_AlphaLow + cs_LowerA + cs_LowerE + cs_LowerI +
                     cs_LowerN + cs_LowerO + cs_LowerU + cs_LowerY;
  cs_UpperA        = ['A', 'Ä', 'Å'];
  cs_UpperE        = ['E', 'É'];
  cs_UpperN        = ['N', 'Ñ'];
  cs_UpperO        = ['O', 'Ö'];
  cs_UpperU        = ['U', 'Ü'];
  cs_Upper         = cs_AlphaHigh + cs_UpperA + cs_UpperE + cs_UpperN +
                     cs_UpperO + cs_UpperU;
  cs_Word          = cs_Lower + cs_Upper + ['_'];
  cs_Text          = cs_Word + cs_Punctuation + cs_WhiteSpace + cs_Numeric;
  cs_WordDelim     = cs_Text - cs_Word;
  cs_LineDelim     = [ASCII_LF, ASCII_CR];


Function InsensitiveCharSet (const Ch : CharSet) : CharSet;
{ Returns a CharSet includes all the characters in Ch and their equivalents.   }



{                                                                              }
{ Trim                                                                         }
{   TrimQuotes removes quotes around a string.                                 }
{   TrimEllipse trims the string and puts '...' at the end if it's longer      }
{     than Length.                                                             }
{                                                                              }
Function TrimLeft (const S : String; const TrimSet : CharSet = cs_WhiteSpace) : String;
Function TrimRight (const S : String; const TrimSet : CharSet = cs_WhiteSpace) : String;
Function Trim (const S : String; const TrimSet : CharSet = cs_WhiteSpace) : String;          // Faster than calling TrimLeft (TrimRight (S))
Function TrimEllipse (const S : String; const Length : Integer) : String;
Function TrimQuotes (const S : String) : String;



{                                                                              }
{ Dup                                                                          }
{   Illegal values for Count (<0) are tolerated.                               }
{                                                                              }
Function Dup (const S : String; const Count : Integer) : String; overload                    // Pretty fast
Function Dup (const Ch : Char; const Count : Integer) : String; overload;                    // Blazing



{                                                                              }
{ Reverse                                                                      }
{                                                                              }
Function Reverse (const S : String) : String;
Function IsPalindrome (const S : String) : Boolean;                                          // Reverse (S) = S



{                                                                              }
{ Match                                                                        }
{   True if M matches S [Pos] (or S [Pos..Pos+Count-1])                        }
{   Returns False if Pos or Count is invalid                                   }
{                                                                              }
Function Match (const M : CharSet; const S : String; const Pos : Integer = 1;
         const Count : Integer = 1) : Boolean; overload;
Function Match (const M : CharSetArray; const S : String; const Pos : Integer = 1)
         : Boolean; overload;
Function Match (const M, S : String; const Pos : Integer = 1) : Boolean; overload;           // Blazing



{                                                                              }
{ PosNext                                                                      }
{   Returns first Match of Find in S after LastPos.                            }
{   To find the first match, set LastPos to 0.                                 }
{   Returns 0 if not found or illegal value for LastPos (<0,>length(s))        }
{                                                                              }
Function PosNext (const Find : CharSet; const S : String;
         const LastPos : Integer = 0) : Integer; overload;
Function PosNext (const Find : CharSetArray; const S : String;
         const LastPos : Integer = 0) : Integer; overload;
Function PosNext (const Find : String; const S : String;
         const LastPos : Integer = 0) : Integer; overload;
Function PosPrev (const Find : String; const S : String;
         const LastPos : Integer = 0) : Integer; overload;
Function PosPrev (const Find : CharSet; const S : String;
         const LastPos : Integer = 0) : Integer; overload;

type
  { Implements the Boyer-Moore-Horspool pattern searching algorithm.           }
  {                                                                            }
  { For longer values of Find (say length > 4) the function is faster than     }
  {   a brute force find (Delphi's Pos function), the time to Create the       }
  {   object excluded.                                                         }
  { When to use: If you are going to do a Pos (S, ..) more than once and       }
  {   Length (S) > 4.                                                          }
  { See the implementation for speed comparisons                               }
  TBMHSearcher = class
    private
    FTable : Array [#0..#255] of Integer;
    FFind  : String;

    public
    Constructor Create (const Find : String);
    Function PosNext (const S : String; const LastPos : Integer = 0) : Integer;
  end;



{                                                                              }
{ Replace                                                                      }
{   QuoteText puts Quotes around S and replaces inside S with double Quotes.   }
{   Remove removes all characters in Ch from S.                                }
{   RemoveDup removes consequetive occurances of a character from Ch.          }
{                                                                              }
Function Replace (const Find, Replace, S : String) : String; overload;
Function Replace (const Find, Replace : Char; const S : String) : String; overload;
Function Replace (const Find : CharSet; const Replace : Char; const S : String) : String; overload;
Function Remove (const Ch : CharSet; const S : String) : String; overload;
Function Remove (const LeftDelimiter, RightDelimiter, S : String) : String; overload;
Function RemoveDup (const Find : CharSet; const S : String) : String; overload;
Function RemoveDup (const Find, S : String) : String; overload;



{                                                                              }
{ Quoting and Escaping                                                         }
{                                                                              }
{   EscapeText/UnescapeText converts text where escaping is done with a        }
{   single character (EscapePrefix) followed by a single character identifier  }
{   (EscapeChar).                                                              }
{   When AlwaysDropPrefix = True, the prefix will be dropped from the          }
{   resulting string if it is not followed by one of EscapeChar.               }
{   Examples:                                                                  }
{     S := EscapeText (S, [#0, #10, #13, '\'], '\', ['0', 'n', 'r', '\']);     }
{     S := UnescapeText (S, '\', ['0', 'n', 'r', '\'], [#0, #10, #13, '\']);   }
{     S := EscapeText (S, [''''], '''', ['''']);                               }
{                                                                              }
{   QuoteText, UnquoteText converts text where the string is enclosed in a     }
{   pair of the same quote characters, and two consequetive occurance of the   }
{   quote character inside the quotes indicate a quote character in the text.  }
{   Examples:                                                                  }
{     QuoteText ('abc', '"') = '"abc"'                                         }
{     QuoteText ('a"b"c', '"') = '"a""b""c"'                                   }
{     UnquoteText ('"a""b""c"') = 'a"b"c'                                      }
{                                                                              }
Function  EscapeText (const S : String; const CharsToEscape : Array of Char;
          const EscapePrefix : Char; const EscapeChar : Array of Char) : String;
Function  UnescapeText (const S : String; const EscapePrefix : Char;
          const EscapeChar : Array of Char; const Replacement : Array of String;
          const AlwaysDropPrefix : Boolean = False) : String;
Function  QuoteText (const S : String; const Quotes : Char = '''') : String;
Function  UnquoteText (const S : String) : String;




{                                                                              }
{ Paste                                                                        }
{   Paste from Dest [DestPos] to Source [SourcePos]                            }
{                                                                              }
Procedure Paste (var Dest : String; const DestPos : Integer;
          const Source : String; const SourcePos, Count : Integer);



{                                                                              }
{ Count                                                                        }
{   Returns the number of seperate occurances of Find in S (not the number     }
{   of positions where Find occurs in S).                                      }
{                                                                              }
Function Count (const Find, S : String) : Integer; overload;
Function Count (const Find : CharSet; const S : String) : Integer; overload;
Function Count (const Find : CharSetArray; const S : String) : Integer; overload;
Function CountWords (const S : String) : Integer;



{                                                                              }
{ PosN                                                                         }
{   All encompassing Pos function.                                             }
{   Finds the Nth occurance of Find in S from the left or the right.           }
{   If SeperateOccurances is True the number of seperate occurances of and not }
{   the number of positions where Find occurs in S is returned.                }
{   If StartPos = 0 then starts searching from left or right of S, otherwise   }
{   from (and including) StartPos.                                             }
{                                                                              }
Function PosN (const Find, S : String; const N : Integer = 1;
         const FromRight : Boolean = False;
         const SeperateOccurances : Boolean = False;
         const StartPos : Integer = 0) : Integer;



{                                                                              }
{ Copy                                                                         }
{   Variantions on Delphi's Copy. Just like Delphi's Copy, illegal values for  }
{   Start (<1,>len), Stop (<start,>len) and Count (<0,>end) are tolerated.     }
{                                                                              }
Function CopyRange (const S : String; const Start, Stop : Integer) : String;
Function CopyFrom (const S : String; const Start : Integer) : String; overload;
Function CopyLeft (const S : String; const Count : Integer) : String;
Function CopyRight (const S : String; const Count : Integer = 1) : String;



{                                                                              }
{ Delimiter-based Copy                                                         }
{   Similar to Copy functions, but use Delimiters instead of indexes.          }
{   CopyFrom and CopyAfter returns S if Delimiter = ''.                        }
{   CopyBefore and CopyTo will return S instead of '' if DelimiterOptional and }
{     the Delimiter is not found in S.                                         }
{   CopyBetween := CopyBefore (CopyAfter (S, LeftDelimiter), RightDelimiter)   }
{     It returns the portion of S that's between the first occurance of        }
{     LeftDelimiter and the first occurance of RightDelimiter after            }
{     LeftDelimiter.                                                           }
{     If LeftDelimiter is not specified ('') then the result is from the       }
{     beginning of S.                                                          }
{                                                                              }
Function CopyFrom (const S, Delimiter : String;
                   const DelimiterOptional : Boolean = False;
                   const StartPos : Integer = 1) : String; overload;
Function CopyFrom (const S : String; const Delimiter : CharSet) : String; overload;
Function CopyAfter (const S, Delimiter : String;
                    const DelimiterOptional : Boolean = False;
                    const StartPos : Integer = 1) : String; overload;
Function CopyAfter (const S : String; const Delimiter : CharSet;
                    const DelimiterOptional : Boolean = False;
                    const StartPos : Integer = 1) : String; overload;
Function CopyTo (const S, Delimiter : String;
                 const DelimiterOptional : Boolean = True;
                 const StartPos : Integer = 1) : String; overload;
Function CopyTo (const S : String; const Delimiter : CharSet;
                 const DelimiterOptional : Boolean = True;
                 const StartPos : Integer = 1) : String; overload;
Function CopyBefore (const S, Delimiter : String;
                     const DelimiterOptional : Boolean = True; const StartPos : Integer = 1;
                     const DelimiterCount : Integer = 1) : String; overload;
Function CopyBefore (const S : String; const Delimiter : CharSet;
                     const DelimiterOptional : Boolean = True; const StartPos : Integer = 1) : String; overload;
Function CopyBetween (const S, LeftDelimiter, RightDelimiter : String;
                      const LeftDelimiterOptional : Boolean = False;
                      const RightDelimiterOptional : Boolean = True) : String; overload;
Function CopyBetween (const S, LeftDelimiter : String;
                      const RightDelimiter : CharSet;
                      const LeftDelimiterOptional : Boolean = False;
                      const RightDelimiterOptional : Boolean = True) : String; overload;



{                                                                              }
{ Split/Join                                                                   }
{   Splits S into pieces seperated by Delimiter. If Delimiter='' or S='' then  }
{   returns an empty list. If Token not found in S returns list with one       }
{   item, S.                                                                   }
{                                                                              }
Function Split (const S : String; const Delimiter : String) : StringArray; overload;
Function Split (const S : String; const Delimiter : CharSet = [' ']) : StringArray; overload;
Function Join (const S : StringArray; const Delimiter : String = c_Space) : String;



{                                                                              }
{ Pad                                                                          }
{   The default for Cut is False which won't shorten the string to Length      }
{   if Length < Length (S).                                                    }
{   PadLeft is equivalent to a right justify, PadRight a left justify,         }
{   Pad centering and PadInside a full justification.                          }
{   Pad (I : Integer) left-pad the number with zeros.                          }
{                                                                              }
Function PadLeft (const S : String; const PadCh : Char; const Length : Integer;
         const Cut : Boolean = False) : String;
Function PadRight (const S : String; const PadCh : Char; const Length : Integer;
         const Cut : Boolean = False) : String;
Function Pad (const S : String; const PadCh : Char; const Length : Integer;
         const Cut : Boolean = False) : String; overload;
Function Pad (const I : Integer; const Length : Integer;
         const Cut : Boolean = False) : String; overload;
Function PadInside (const S : String; const PadCh : Char; const Length : Integer) : String;



{                                                                              }
{ Type checking                                                                }
{                                                                              }
Function IsNumber (const S : String) : Boolean;
Function IsHexNumber (const S : String) : Boolean;
Function IsInteger (const S : String) : Boolean;
Function IsReal (const S : String) : Boolean;
Function IsScientificReal (const S : String) : Boolean;
Function IsQuotedString (const S : String; const ValidQuotes : CharSet = cs_Quotes) : Boolean;



{                                                                              }
{ Natural language                                                             }
{                                                                              }
Function Number (const Num : Int64; const USStyle : Boolean = False) : String; overload;
Function Number (const Num : Extended; const USStyle : Boolean = False) : String; overload;



{                                                                              }
{ Pack/Unpack                                                                  }
{   Packs paramater (in its binary format) into a string                       }
{                                                                              }
Function Pack (const D : Int64) : String; overload;
Function Pack (const D : Integer) : String; overload;
Function Pack (const D : Byte) : String; overload;
Function Pack (const D : ShortInt) : String; overload;
Function Pack (const D : SmallInt) : String; overload;
Function Pack (const D : Word) : String; overload;
Function Pack (const D : String) : String; overload;
Function PackShortString (const D : ShortString) : String;
Function Pack (const D : Extended) : String; overload;
Function PackSingle (const D : Single) : String;
Function PackDouble (const D : Double) : String;
Function PackCurrency (const D : Currency) : String;
Function PackDateTime (const D : TDateTime) : String;
Function Pack (const D : Boolean) : String; overload;

Function UnpackInteger (const D : String) : Integer;
Function UnpackSingle (const D : String) : Single;
Function UnpackDouble (const D : String) : Double;
Function UnpackExtended (const D : String) : Extended;
Function UnpackBoolean (const D : String) : Boolean;
Function UnpackDateTime (const D : String) : TDateTime;
Function UnpackString (const D : String) : String;
Function UnpackShortString (const D : String) : ShortString;



implementation

uses
  SysUtils,
  Math;



{                                                                              }
{ Miscellaneous                                                                }
{                                                                              }
Function InsensitiveCharSet (const Ch : CharSet) : CharSet;
var C : Char;
  Begin
    Result := Ch;
    For C := 'A' to 'Z' do
      if (C in Ch) or (Char (Ord (C) + 32) in Ch) then
        begin
          Result := Result + [C, Char (Ord (C) + 32)];
          Case C of
            'A' : Result := Result + cs_LowerA + cs_UpperA;
            'E' : Result := Result + cs_LowerE + cs_UpperE;
            'I' : Result := Result + cs_LowerI;
            'N' : Result := Result + cs_LowerN + cs_UpperN;
            'O' : Result := Result + cs_LowerO + cs_UpperO;
            'U' : Result := Result + cs_LowerU + cs_UpperU;
            'Y' : Result := Result + cs_LowerY;
          end;
      end;
  End;


{                                                                              }
{ Copy                                                                         }
{                                                                              }
Function CopyRange (const S : String; const Start, Stop : Integer) : String;
  Begin
    Result := Copy (S, Start, Stop - Start + 1);
  End;

Function CopyFrom (const S : String; const Start : Integer) : String;
  Begin
    if Start <= 1 then
      Result := S else
      Result := Copy (S, Start, Length (S) - Start + 1);
  End;

Function CopyLeft (const S : String; const Count : Integer) : String;
  Begin
    Result := Copy (S, 1, Count);
  End;

Function CopyRight (const S : String; const Count : Integer) : String;
var L : Integer;
  Begin
    L := Length (S);
    if Count >= L then
      Result := S else
      Result := Copy (S, Length (S) - Count + 1, Count);
  End;



{                                                                              }
{ Delimiter-based Copy                                                         }
{                                                                              }
Function CopyFrom (const S, Delimiter : String; const DelimiterOptional : Boolean; const StartPos : Integer) : String;
var I : Integer;
  Begin
    if Delimiter = '' then
      Result := S else
      begin
        I := PosNext (Delimiter, S, StartPos - 1);
        if I > 0 then
          Result := CopyFrom (S, I) else
          if DelimiterOptional then
            Result := CopyFrom (S, StartPos) else
            Result := '';
      end;
  End;


Function CopyFrom (const S : String; const Delimiter : CharSet) : String;
var I : Integer;
  Begin
    if Delimiter = [] then
      Result := S else
      begin
        I := PosNext (Delimiter, S);
        if I = 0 then
          Result := '' else
          Result := CopyFrom (S, I);
      end;
  End;

Function CopyAfter (const S, Delimiter : String; const DelimiterOptional : Boolean; const StartPos : Integer) : String;
var I : Integer;
  Begin
    if Delimiter = '' then
      Result := S else
      begin
        I := PosNext (Delimiter, S, StartPos - 1);
        if I > 0 then
          Result := CopyFrom (S, I + Length (Delimiter)) else
          if DelimiterOptional then
            Result := S else
            Result := '';
      end;
  End;

Function CopyAfter (const S : String; const Delimiter : CharSet; const DelimiterOptional : Boolean; const StartPos : Integer) : String;
var I : Integer;
  Begin
    if Delimiter = [] then
      Result := S else
      begin
        I := PosNext (Delimiter, S, StartPos - 1);
        if I > 0 then
          Result := CopyFrom (S, I + 1) else
          if DelimiterOptional then
            Result := S else
            Result := '';
      end;
  End;

Function CopyTo (const S, Delimiter : String; const DelimiterOptional : Boolean; const StartPos : Integer) : String;
var I : Integer;
  Begin
    I := PosNext (Delimiter, S, StartPos - 1);
    if I > 0 then
      Result := CopyRange (S, StartPos, I + Length (Delimiter) - 1) else
      if DelimiterOptional then
        Result := S else
        Result := '';
  End;

Function CopyTo (const S : String; const Delimiter : CharSet; const DelimiterOptional : Boolean; const StartPos : Integer) : String;
var I : Integer;
  Begin
    I := PosNext (Delimiter, S, StartPos - 1);
    if I > 0 then
      Result := CopyRange (S, StartPos, I) else
      if DelimiterOptional then
        Result := S else
        Result := '';
  End;

Function CopyBefore (const S, Delimiter : String; const DelimiterOptional : Boolean; const StartPos : Integer; const DelimiterCount : Integer) : String;
var I : Integer;
  Begin
    I := PosN (Delimiter, S, DelimiterCount, False, True, StartPos);
    if I > 0 then
      Result := CopyRange (S, StartPos, I - 1) else
      if DelimiterOptional then
        Result := CopyFrom (S, StartPos) else
        Result := '';
  End;

Function CopyBefore (const S : String; const Delimiter : CharSet; const DelimiterOptional : Boolean; const StartPos : Integer) : String;
var I : Integer;
  Begin
    I := PosNext (Delimiter, S, StartPos - 1);
    if I > 0 then
      Result := CopyRange (S, StartPos, I - 1) else
      if DelimiterOptional then
        Result := CopyFrom (S, StartPos) else
        Result := '';
  End;

Function CopyBetween (const S : String; const LeftDelimiter, RightDelimiter : String; const LeftDelimiterOptional : Boolean; const RightDelimiterOptional : Boolean) : String; overload;
  Begin
    Result := CopyBefore (CopyAfter (S, LeftDelimiter, LeftDelimiterOptional), RightDelimiter, RightDelimiterOptional);
  End;

Function CopyBetween (const S, LeftDelimiter : String; const RightDelimiter : CharSet; const LeftDelimiterOptional : Boolean; const RightDelimiterOptional : Boolean) : String; overload;
  Begin
    Result := CopyBefore (CopyAfter (S, LeftDelimiter, LeftDelimiterOptional), RightDelimiter, RightDelimiterOptional);
  End;



{                                                                              }
{ Paste                                                                        }
{                                                                              }
Procedure Paste (var Dest : String; const DestPos : Integer;
          const Source : String; const SourcePos, Count : Integer);
var C : Integer;
  Begin
    C := Min (Count, Length (Dest) - DestPos + 1);
    if C > 0 then
      Move (Source [SourcePos], Dest [DestPos], Min (Length (Source) - SourcePos + 1, C));
  End;



{                                                                              }
{ Trim                                                                         }
{                                                                              }
Function TrimLeft (const S : String; const TrimSet : CharSet) : String;
var F : Integer;
  Begin
    F := 1;
    While (F <= Length (S)) and (S [F] in TrimSet) do
      Inc (F);
    Result := CopyFrom (S, F);
  End;

Function TrimRight (const S : String; const TrimSet : CharSet) : String;
var F : Integer;
  Begin
    F := Length (S);
    While (F >= 1) and (S [F] in TrimSet) do
      Dec (F);
    Result := CopyLeft (S, F);
  End;

Function Trim (const S : String; const TrimSet : CharSet) : String;
var F, G : Integer;
  Begin
    F := 1;
    While (F <= Length (S)) and (S [F] in TrimSet) do
      Inc (F);
    G := Length (S);
    While (G >= F) and (S [G] in TrimSet) do
      Dec (G);
    Result := CopyRange (S, F, G);
  End;

Function TrimEllipse (const S : String; const Length : Integer) : String;
  Begin
    if System.Length (S) <= Length then
      Result := S else
      if Length < 3 then
        Result := '' else
        Result := CopyLeft (S, Length - 3) + '...';
  End;

Function TrimQuotes (const S : String) : String;
var L : Integer;
  Begin
    L := Length (S);
    if (L >= 2) and (S [1] = S [L]) then
      Result := Copy (S, 2, L - 2) else
      Result := S;
  End;


{                                                                              }
{ Dup                                                                          }
{                                                                              }
Function Dup (const S : String; const Count : Integer) : String;
var I, L : Integer;
  Begin
    L := Length (S);
    SetLength (Result, Count * L);
    For I := 0 to Count - 1 do
      Move (S [1], Result [I * L + 1], L);
  End;

Function Dup (const Ch : Char; const Count : Integer) : String;
  Begin
    SetLength (Result, Count);
    if Count > 0 then
      FillChar (Result [1], Count, Ord (Ch));
  End;



{                                                                              }
{ Reverse                                                                      }
{                                                                              }
Function Reverse (const S : String) : String;
var I, L : Integer;
  Begin
    L := Length (S);
    SetLength (Result, L);
    For I := 1 to L do
      Result [L - I + 1] := S [I];
  End;

Function IsPalindrome (const S : String) : Boolean;
var I, L : Integer;
  Begin
    L := Length (S);
    For I := 1 to L div 2 do
      if S [I] <> S [L - I + 1] then
        begin
          Result := False;
          exit;
        end;
    Result := True;
  End;



{                                                                              }
{ Match                                                                        }
{                                                                              }
Function Match (const M : CharSet; const S : String; const Pos : Integer; const Count : Integer) : Boolean;
var I, PosEnd : Integer;
  Begin
    PosEnd := Pos + Count - 1;
    if (M = []) or (Pos < 1) or (Count = 0) or (PosEnd > Length (S)) then
      begin
        Result := False;
        exit;
      end;

    For I := Pos to PosEnd do
      if not (S [I] in M) then
        begin
          Result := False;
          exit;
        end;

    Result := True;
  End;

Function Match (const M : CharSetArray; const S : String; const Pos : Integer) : Boolean;
var J, C : Integer;
  Begin
    C := Length (M);
    if (C = 0) or (Pos < 1) or (Pos + C - 1 > Length (S)) then
      begin
        Result := False;
        exit;
      end;

    For J := 0 to C - 1 do
      if not (S [J + Pos] in M [J]) then
        begin
          Result := False;
          exit;
        end;

    Result := True;
  End;

{ Highly optimized version of Match. Equivalent to, but much faster and more   }
{ memory efficient than: M = Copy (S, Pos, Length (M))                         }
{ Does compare in 32-bit chunks (CPU's native type)                            }
Function Match (const M, S : String; const Pos : Integer) : Boolean;
  Asm
      push esi
      push edi
      push edx                    // save state

      push Pos
      push M
      push S                      // push parameters
      pop edi                     // edi = S [1]
      pop esi                     // esi = M [1]
      pop ecx                     // ecx = Pos
      cmp ecx, 1
      jb @NoMatch                 // if Pos < 1 then @NoMatch

      mov edx, [esi - 4]
      or edx, edx
      jz @NoMatch                 // if Length (M) = 0 then @NoMatch
      add edx, ecx
      dec edx                     // edx = Pos + Length (M) - 1

      cmp edx, [edi - 4]
      ja @NoMatch                 // if Pos + Length (M) - 1 > Length (S) then @NoMatch

      add edi, ecx
      dec edi                     // edi = S [Pos]
      mov ecx, [esi - 4]          // ecx = Length (M)

      // All the following code is an optimization of just two lines:         //
      //     rep cmsb                                                         //
      //     je @Match                                                        //
      mov dl, cl                                                              //
      and dl, $03                                                             //
      shr ecx, 2                                                              //
      jz @CheckMod                 { Length (M) < 4 }                         //
                                                                              //
      { The following is faster than:  {}                                     //
      {     rep cmpsd                  {}                                     //
      {     jne @NoMatch               {}                                     //
      @c1:                             {}                                     //
        mov eax, [esi]                 {}                                     //
        cmp eax, [edi]                 {}                                     //
        jne @NoMatch                   {}                                     //
        add esi, 4                     {}                                     //
        add edi, 4                     {}                                     //
        dec ecx                        {}                                     //
        jnz @c1                        {}                                     //
                                                                              //
      or dl, dl                                                               //
      jz @Match                                                               //
                                                                              //
      { Check remaining dl (0-3) bytes   {}                                   //
    @CheckMod:                           {}                                   //
      mov eax, [esi]                     {}                                   //
      mov ecx, [edi]                     {}                                   //
      cmp al, cl                         {}                                   //
      jne @NoMatch                       {}                                   //
      dec dl                             {}                                   //
      jz @Match                          {}                                   //
      cmp ah, ch                         {}                                   //
      jne @NoMatch                       {}                                   //
      dec dl                             {}                                   //
      jz @Match                          {}                                   //
      and eax, $00ff0000                 {}                                   //
      and ecx, $00ff0000                 {}                                   //
      cmp eax, ecx                       {}                                   //
      je @Match                          {}                                   //

    @NoMatch:
      xor al, al                  // Result := False
      jmp @Fin

    @Match:
      mov al, 1                   // Result := True

    @Fin:
      pop edx                     // restore state
      pop edi
      pop esi
  End;



{                                                                              }
{ PosNext                                                                      }
{                                                                              }
Function PosNext (const Find : CharSet; const S : String; const LastPos : Integer) : Integer;
var I : Integer;
  Begin
    if Find = [] then
      begin
        Result := 0;
        exit;
      end;

    For I := Max (LastPos + 1, 1) to Length (S) do
      if S [I] in Find then
        begin
          Result := I;
          exit;
        end;

    Result := 0;
  End;

Function PosNext (const Find : CharSetArray; const S : String; const LastPos : Integer) : Integer;
var I, C : Integer;
  Begin
    C := Length (Find);
    if C = 0 then
      begin
        Result := 0;
        exit;
      end;

    For I := Max (LastPos + 1, 1) to Length (S) - C + 1 do
      if Match (Find, S, I) then
        begin
          Result := I;
          exit;
        end;

    Result := 0;
  End;

Function PosNext (const Find : String; const S : String; const LastPos : Integer = 0) : Integer;
var I : Integer;
  Begin
    if Find = '' then
      begin
        Result := 0;
        exit;
      end;

    For I := LastPos + 1 to Length (S) - Length (Find) + 1 do
      if Match (Find, S, I) then
        begin
          Result := I;
          exit;
        end;

    Result := 0;
  End;

Function PosPrev (const Find : String; const S : String; const LastPos : Integer = 0) : Integer;
var I, J : Integer;
  Begin
    if Find = '' then
      begin
        Result := 0;
        exit;
      end;

    if LastPos = 0 then
      J := Length (S) - Length (Find) + 1 else
      J := LastPos - 1;
    For I := J downto 1 do
      if Match (Find, S, I) then
        begin
          Result := I;
          exit;
        end;

    Result := 0;
  End;

Function PosPrev (const Find : CharSet; const S : String; const LastPos : Integer = 0) : Integer;
var I, J : Integer;
  Begin
    if Find = [] then
      begin
        Result := 0;
        exit;
      end;

    if LastPos = 0 then
      J := Length (S) else
      J := LastPos - 1;
    For I := J downto 1 do
      if Match (Find, S, I) then
        begin
          Result := I;
          exit;
        end;

    Result := 0;
  End;

{ Boyer-Moore-Horspool pattern searching                                       }
{ Converted to a class and rewritten in assembly by David Butler               }
{  (david@e.co.za) from a highly optimized Pascal unit BMH 1.11a written by    }
{  Jody R Cairns (jodyc@cs.mun.ca) as she took it from the 'Handbook of        }
{  Algorithms and Data Structures in Pascal and C', Second Edition,            }
{  by G.H Gonnet and  R. Baeza-Yates.                                          }
Constructor TBMHSearcher.Create (const Find : String);
  Begin
    inherited Create;
    FFind := Find;

    { Creates a Boyer-Moore-Horspool index table for the search string }
    asm
      push eax
      push ebx
      push edx
      push esi
      push edi
     // save state
      mov eax, self
//      mov edx, FTable
      add edx, eax                    // edx = FTable [0]
      mov ebx, [eax + FFind]          // ebx = FFind [1]

      // FTable [0..255] := Length (FFind)                                    //
      mov eax, [ebx - 4]              { eax = Length (FFind) }                //
      mov edi, edx                    { edi = FTable [0] }                    //
      mov ecx, 256                                                            //
      rep stosd                                                               //

      // FTable [FFind [i = 1..Length (FFind)]] = Length (FFind) - i          //
      mov ecx, eax                    { ecx = Length (FFind) }                //
      dec ecx                                                                 //
      mov edi, edx                    { edi = FTable [0] }                    //
      xor esi, esi                    { esi = i - 1 = 0 }                     //
      xor edx, edx                                                            //
    @c1:                                                                      //
      mov dl, [ebx + esi]             { edx = FFind [i] }                     //
      mov [edi + edx * 4], ecx        { FTable [edx] := Length (FFind) - i }  //
      inc esi                                                                 //
      loop @c1                                                                //

      pop edi                         // restore state
      pop esi
      pop edx
      pop ebx
      pop eax
    end;
  End;

{ Results of a speed trial (you'll never be able to reproduce them :-) to      }
{ give you an idea of the speed relationship:                                  }
{                Len(Find)  Len(S)  System.Pos  TBMHSearcher.Pos  %Diff        }
{ Worst case        1        250    0.16 mil/s     0.04 mil/s      -300%       }
{                   1        60     0.6 mil/s      0.16 mil/s      -275%       }
{                   1        7      2.5 mil/s      1.2 mil/s       -108%       }
{                   5        250    0.16 mil/s     0.18 mil/s      +13%        }
{                   5        60     0.5 mil/s      0.6 mil/s       +20%        }
{                   5        7      3.5 mil/s      4.3 mil/s       +22%        }
{                   5        50000  713 /s         888 /s          +25%        }
{                   15       250    0.16 mil/s     0.36 mil/s      +157%       }
{                   15       60     0.7 mil/s      1.9 mil/s       +171%       }
{                   50       250    0.16 mil/s     1.35 mil/s      +744%       }
{ Best cast         250      50000  700 /s         30000 /s        +4286%      }
Function TBMHSearcher.PosNext (const S : String; const LastPos : Integer) : Integer;
  Asm
      push ebp
      push ebx
      push edx
      push esi
      push edi                                      // save state

      push LastPos
      push S
      push self                                     // push parameters
      pop ebp                                       // ebp = self
      pop eax                                       // eax = S
      pop ebx                                       // ebx = LastPos

      mov edx, [ebp + FFind]                        // edx = FFind
      or edx, edx
      jz @NoMatch                                   // if FFind = '' then NoMatch
      add ebx, [edx - 4]                            // ebx = counter, starting at LastPos + Length (FFind)

    // while ebx < Length (s)                                                                     //
    @WhileNotEnd:                                                                                 //
      cmp ebx, [eax - 4]                                                                          //
      ja @NoMatch                                                                                 //
                                                                                                  //
      mov ecx, [edx - 4]                            { loop count = Length (FFind) }               //
                                                                                                  //
      mov esi, eax                                                                                //
      add esi, ebx                                                                                //
      sub esi, ecx                                  { esi = S [1 + ebx - Length (FFind)] }        //      { "Maybe it's meant to be" - SG }
                                                                                                  //
      mov edi, edx                                  { edi = FFind [1] }                           //
                                                                                                  //      { "Vergete die verlede,           }
    { This is actually faster than REP CMPSB on a Pentium                     {}                  //      {  Rooskleurig die hede..." - SG  }
    @c1:                                                                      {}                  //
      cmpsb                                                                   {}                  //
      jne @NotEq                                                              {}                  //
      loop @c1                                                                {}                  //
                                                                                                  //
      jmp @Match                                    { Match found }                               //
                                                                                                  //
    @NotEq:                                                                                       //
      xor ecx, ecx                                                                                //
      mov cl, [eax + ebx - 1]                       { ecx = S [ebx] }                             //
                                                                                                  //
      add ebx, dword ptr [ebp + FTable + ecx * 4]   { Inc (ebx, FTable [ecx]) }                   //
                                                                                                  //
      jmp @WhileNotEnd                                                                            //

    @NoMatch:
      xor eax, eax                                  // Result = 0
      jmp @Fin

    @Match:
      mov eax, ebx
      inc eax
      sub eax, [edx - 4]                            // Result = ebx - Length (FFind) + 1

    @Fin:
      pop edi                                       // Restore state
      pop esi
      pop edx
      pop ebx
      pop ebp
  End;



{                                                                              }
{ PosN                                                                         }
{                                                                              }
Function PosN (const Find, S : String; const N : Integer; const FromRight : Boolean;
               const SeperateOccurances : Boolean; const StartPos : Integer) : Integer;
var F, I : Integer;
  Begin
    if StartPos = 0 then
      F := 0 else
      if FromRight then
        F := StartPos + 1 else
        F := StartPos - 1;
    For I := 1 to N do
      begin
        if FromRight then
          F := PosPrev (Find, S, F) else
          F := PosNext (Find, S, F);
        if F = 0 then
          break;
        if (I < N) and SeperateOccurances then
          if FromRight then
            Dec (F, Length (Find) - 1) else
            Inc (F, Length (Find) - 1);
      end;
    Result := F;
  End;



{                                                                              }
{ Split                                                                        }
{                                                                              }
Function Split (const S : String; const Delimiter : String) : StringArray;
var I, J, L : Integer;
  Begin
    SetLength (Result, 0);
    if (Delimiter = '') or (S = '') then
      exit;

    I := 0;
    L := 0;
    Repeat
      SetLength (Result, L + 1);
      J := PosNext (Delimiter, S, I);
      if J = 0 then
        Result [L] := CopyFrom (S, I + Length (Delimiter)) else
        begin
          Result [L] := CopyRange (S, I + Length (Delimiter), J - 1);
          I := J;
          Inc (L);
        end;
    Until J = 0;
  End;

Function Split (const S : String; const Delimiter : CharSet = [' ']) : StringArray;
var I, J, L : Integer;
  Begin
    SetLength (Result, 0);
    if (Delimiter = []) or (S = '') then
      exit;

    I := 0;
    L := 0;
    Repeat
      SetLength (Result, L + 1);
      J := PosNext (Delimiter, S, I);
      if J = 0 then
        Result [L] := CopyFrom (S, I + 1) else
        begin
          Result [L] := CopyRange (S, I + 1, J - 1);
          I := J;
          Inc (L);
        end;
    Until J = 0;
  End;

Function Join (const S : StringArray; const Delimiter : String = c_Space) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to High (S) do
      begin
        if I > 0 then
          Result := Result + Delimiter;
        Result := Result + S [I];
      end;
  End;



{                                                                              }
{ Replace                                                                      }
{                                                                              }
Function Replace (const Find, Replace, S : String) : String;
// This implemenmtation uses 2 traversals and 1 memory allocation rather than
// 1 traversal and possible multiple memory allocations.
var F, G, X, I : Integer;
    LR, LF     : Integer;
  Begin
    X := Count (Find, S);
    if X = 0 then
      begin
        Result := S;
        exit;
      end;

    LR := Length (Replace);
    LF := Length (Find);
    SetLength (Result, Length (S) + X * (LR - LF));
    if Result = '' then
      exit;

    F := PosNext (Find, S);
    Move (S [1], Result [1], F - 1);
    if LR > 0 then
      Move (Replace [1], Result [F], LR);
    I := F + LR;
    G := F + LF;
    Repeat
      F := PosNext (Find, S, G - 1);
      if F > 0 then
        begin
          Move (S [G], Result [I], F - G);
          Inc (I, F - G);
          if LR > 0 then
            Move (Replace [1], Result [I], LR);
          Inc (I, LR);
          G := F + LF;
        end;
    Until F = 0;
    F := Length (S) - G + 1;
    if F > 0 then
      Move (S [G], Result [I], F);
  End;

Function Replace (const Find, Replace : Char; const S : String) : String;
var I : Integer;
  Begin
    Result := S;
    For I := 1 to Length (S) do
      if S [I] = Find then
        Result [I] := Replace;
  End;

Function Replace (const Find : CharSet; const Replace : Char; const S : String) : String;
var I : Integer;
  Begin
    Result := S;
    For I := 1 to Length (S) do
      if S [I] in Find then
        Result [I] := Replace;
  End;

Function Remove (const Ch : CharSet; const S : String) : String;
var I : Integer;
  Begin
    Result := S;
    I := 1;
    While I <= Length (Result) do
      if Result [I] in Ch then
        Delete (Result, I, 1) else
        Inc (I);
  End;

Function Remove (const LeftDelimiter, RightDelimiter, S : String) : String;
var I, J : Integer;
  Begin
    I := PosNext (LeftDelimiter, S);
    if I = 0 then
      Result := S else
      begin
        J := PosNext (RightDelimiter, S, I + Length (LeftDelimiter) - 1);
        if J = 0 then
          Result := S else
          Result := CopyLeft (S, I - 1) + CopyFrom (S, J + Length (RightDelimiter));
      end;
  End;

Function RemoveDup (const Find : CharSet; const S : String) : String;
var I : Integer;
  Begin
    Result := S;
    I := 2;
    While I <= Length (Result) do
      if (Result [I] in Find) and (Result [I] = Result [I - 1]) then
        Delete (Result, I, 1) else
        Inc (I);
  End;

Function RemoveDup (const Find, S : String) : String;
var I, P, L : Integer;
  Begin
    Result := S;
    P := 0;
    L := Length (Find);
    Repeat
      I := PosNext (Find, Result, P);
      if (P > 0) and (I = P + L) then
        System.Delete (Result, I, L) else
        P := I;
    Until I = 0;
  End;


{                                                                              }
{ Quoting and Escaping                                                         }
{                                                                              }
Function EscapeText (const S : String; const CharsToEscape : Array of Char;
          const EscapePrefix : Char; const EscapeChar : Array of Char) : String;
var Ch   : CharSet;
    I, J : Integer;
    F    : Integer;
    C    : Char;
  Begin
    Ch := AsCharSet (CharsToEscape);
    Result := '';
    J := 0;
    Repeat
      I := PosNext (Ch, S, J);
      if I > 0 then
        begin
          Result := Result + CopyRange (S, J + 1, I - 1);
          C := S [I];
          For F := 0 to High (CharsToEscape) do
            if CharsToEscape [F] = C then
              begin
                Result := Result + EscapePrefix + EscapeChar [F];
                break;
              end;
          J := I + 1;
        end;
    Until I = 0;
    if (I = 0) and (J = 0) then
      Result := S else
      Result := Result + CopyFrom (S, J + 1);
  End;

Function UnescapeText (const S : String; const EscapePrefix : Char;
         const EscapeChar : Array of Char; const Replacement : Array of String;
         const AlwaysDropPrefix : Boolean) : String;
var I, J : Integer;
    F    : Integer;
    R    : Boolean;
    Ch   : Char;
    T    : String;
  Begin
    Assert (High (EscapeChar) = High (Replacement), 'Arrays must be of equal length');

    Result := '';
    J := 0;
    Repeat
      I := PosNext (EscapePrefix, S, J);
      if I > 0 then
        begin
          R := False;
          if I < Length (S) then
            begin
              Ch := S [I + 1];
              For F := 0 to High (EscapeChar) do
                if EscapeChar [F] = Ch then
                  begin
                    R := True;
                    break;
                  end;
            end;
          Result := Result + CopyRange (S, J + 1, I - 1);
          if R then
            begin
              T := Replacement [F];
              Result := Result + T;
              J := I + Length (T);
            end else
            begin
              if not AlwaysDropPrefix then
                Result := Result + EscapePrefix;
              J := I;
            end;
        end;
    Until I = 0;
    if (I = 0) and (J = 0) then
      Result := S else
      Result := Result + CopyFrom (S, J + 1);
  End;

Function QuoteText (const S : String; const Quotes : Char) : String;
  Begin
    Result := Quotes + Replace (Quotes, Quotes + Quotes, S) + Quotes;
  End;

Function UnquoteText (const S : String) : String;
var Quote : Char;
    L     : Integer;
  Begin
    L := Length (S);
    if (L < 2) or (S [1] <> S [L]) then
      begin
        Result := S;
        exit;
      end;
    Quote := S [1];
    Result := Replace (Quote + Quote, Quote, Copy (S, 2, L - 2));
  End;



{                                                                              }
{ Count                                                                        }
{                                                                              }
Function Count (const Find, S : String) : Integer;
var I : Integer;
  Begin
    Result := 0;
    I := PosNext (Find, S);
    While I > 0 do
      begin
        Inc (Result);
        I := PosNext (Find, S, I + Length (Find) - 1);
      end;
  End;

Function Count (const Find : CharSetArray; const S : String) : Integer;
var I : Integer;
  Begin
    Result := 0;
    I := PosNext (Find, S);
    While I > 0 do
      begin
        Inc (Result);
        I := PosNext (Find, S, I + Length (Find) - 1);
      end;
  End;

Function Count (const Find : CharSet; const S : String) : Integer;
var I : Integer;
  Begin
    Result := 0;
    For I := 1 to Length (S) do
      if S [I] in Find then
        Inc (Result);
  End;

Function CountWords (const S : String) : Integer;
  Begin
    Result := Count (AsCharSetArray ([cs_Alpha, cs_WordDelim]), S);
    if Result = 0 then
      if PosNext (cs_Alpha, S) > 0 then
        Result := 1;
  End;



{                                                                              }
{ Pad                                                                          }
{                                                                              }
Function PadLeft (const S : String; const PadCh : Char; const Length : Integer;
         const Cut : Boolean = False) : String;
  Begin
    Result := Dup (PadCh, Length - System.Length (S)) + S;
    if Cut then
      SetLength (Result, Length);
  End;

Function PadRight (const S : String; const PadCh : Char; const Length : Integer;
         const Cut : Boolean = False) : String;
  Begin
    Result := S + Dup (PadCh, Length - System.Length (S));
    if Cut then
      SetLength (Result, Length);
  End;

Function Pad (const S : String; const PadCh : Char; const Length : Integer;
         const Cut : Boolean) : String;
var I : Integer;
  Begin
    I := Length - System.Length (S);
    Result := Dup (PadCh, I div 2) + S + Dup (PadCh, (I + 1) div 2);
    if Cut then
      SetLength (Result, Length);
  End;

Function Pad (const I : Integer; const Length : Integer; const Cut : Boolean) : String;
  Begin
    Result := PadLeft (IntToStr (I), '0', Length, Cut);
  End;

Function PadInside (const S : String; const PadCh : Char; const Length : Integer) : String;
var I, J, K, C, M : Integer;
    PNP : CharSetArray;
  Begin
    if System.Length (S) >= Length then
      begin
        Result := S;
        exit;
      end;

    PNP := AsCharSetArray ([[PadCh], cs_Everything - [PadCh]]);
    I := Count (PNP, S);
    if I = 0 then // nowhere to pad inside
      begin
        Result := S;
        exit;
      end;

    C := (Length - System.Length (S)) div I; // min characters to insert in each "space"
    M := (Length - System.Length (S)) mod I; // extra characters to insert anywhere
    I := PosNext (PNP, S);
    K := 0;
    Result := CopyLeft (S, I);
    Repeat
      Result := Result + Dup (PadCh, C);
      if K < M then
        Result := Result + PadCh;
      Inc (K);
      J := I;
      I := PosNext (PNP, S, J);
      if I > 0 then
        Result := Result + CopyRange (S, J + 1, I);
    Until I = 0;
    Result := Result + CopyFrom (S, J + 1);
  End;



{                                                                              }
{ Type testing                                                                 }
{                                                                              }
{ ('0'..'9')+ }
Function IsNumber (const S : String) : Boolean;
var L : Integer;
  Begin
    L := Length (S);
    Result := (L > 0) and Match (cs_Numeric, S, 1, L);
  End;

{ ('0'..'9','A'..'F')+ }
Function IsHexNumber (const S : String) : Boolean;
var L : Integer;
  Begin
    L := Length (S);
    Result := (L > 0) and Match (cs_HexDigit, S, 1, L);
  End;

{ ['+','-']<number> }
Function IsInteger (const S : String) : Boolean;
  Begin
    if S = '' then
      Result := False else
      if S [1] in cs_Sign then
        Result := (Length (S) > 1) and IsNumber (CopyFrom (S, 2)) else
        Result := IsNumber (S);
  End;

{ <integer>['.'<number>]   or }
{          ['.'<number>]      }
Function IsReal (const S : String) : Boolean;
var F : Integer;
  Begin
    F := Pos (c_DecimalPoint, S);
    if F = 0 then
      Result := IsInteger (S) else
      Result := ((F = 1) or IsInteger (CopyLeft (S, F - 1))) and
                IsNumber (CopyFrom (S, F + 1));
  End;

{ <real>['e'<int>] }
Function IsScientificReal (const S : String) : Boolean;
var F : Integer;
  Begin
    F := PosNext (cs_Exponent, S);
    if F = 0 then
      Result := IsReal (S) else
      Result := IsReal (CopyLeft (S, F - 1)) and IsInteger (CopyFrom (S, F + 1));
  End;

{ <quote><text incl double quoted quotes><quote> }
Function IsQuotedString (const S : String; const ValidQuotes : CharSet) : Boolean;
var Quote : Char;
    I     : Integer;
  Begin
    if (Length (S) < 2) or (S [1] <> S [Length (S)]) or not (S [1] in ValidQuotes) then
      begin
        Result := False;
        exit;
      end;
    Quote := S [1];
    I := 1;
    Repeat
      I := PosNext (Quote, S, I);
      if I < Length (S) then
        if S [I + 1] <> Quote then // not double quoted
          begin
            Result := False;
            exit;
          end else
          Inc (I);
    Until I = Length (S);
    Result := True;
  End;



{                                                                              }
{ Natural language                                                             }
{   US style billion = 1,000 million                                           }
{   UK style billion = 1,000,000 million                                       }
{   US style trillion = 1,000 US billion                                       }
{   UK style trillion = 1,000,000 UK billion?                                  }
{                                                                              }
Function Number (const Num : Int64; const USStyle : Boolean = False) : String;
var I : Int64;
const
  Eng_minus    = 'minus ';
  Eng_Numbers  : Array [0..12] of String =
        ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine',
         'ten', 'eleven', 'twelve');
  Eng_Prefixes : Array [2..9] of String =
        ('twen', 'thir', 'four', 'fif', 'six', 'seven', 'eigh', 'nin');
  Eng_teen     = 'teen';
  Eng_ty       = 'ty';
  Eng_hundred  = ' hundred';
  Eng_and      = ' and ';
  Eng_thousand  = ' thousand';
  Eng_million   = ' million';
  Eng_billion   = ' billion';
  Eng_trillion  = ' trillion';
  USBillion  : Int64 = 1000000000;
  USTrillion : Int64 = 1000000000000;
  UKBillion  : Int64 = 1000000000000;
  UKTrillion : Int64 = 1000000000000000000;

  Begin
    if Num < 0 then
      Result := Eng_minus + Number (-Num) else
    if Num <= 12 then
      Result := Eng_Numbers [Num] else
    if Num <= 19 then
      Result := Eng_Prefixes [Num mod 10] + Eng_teen else
    if Num <= 99 then
      begin
        Result := Eng_Prefixes [Num div 10] + Eng_ty;
        if Num mod 10 > 0 then
          Result := Result + ' ' + Eng_Numbers [Num mod 10];
      end else
    if Num <= 999 then
      begin
        Result := Number (Num div 100) + Eng_hundred;
        if Num mod 100 > 0 then
          Result := Result + Eng_and + Number (Num mod 100);
      end else
    if Num <= 999999 then
      begin
        Result := Number (Num div 1000) + Eng_thousand;
        if Num mod 1000 > 0 then
          Result := Result + ' ' + Number (Num mod 1000);
      end else
    if ((Num < USBillion) and USStyle) or
       ((Num < UKBillion) and not USStyle) then
      begin
        Result := Number (Num div 1000000) + Eng_million;
        if Num mod 1000000 > 0 then
          Result := Result + ' ' + Number (Num mod 1000000);
      end else
    if ((Num < USTrillion) and USStyle) or
       ((Num < UKTrillion) and not USStyle) then
      begin
        if USStyle then
          I := USBillion else
          I := UKBillion;
        Result := Number (Num div I) + Eng_billion;
        if Num mod I > 0 then
          Result := Result + ' ' + Number (Num mod I, USStyle);
      end else
      begin
        if USStyle then
          I := USTrillion else
          I := UKTrillion;
        Result := Number (Num div I) + Eng_trillion;
        if Num mod I > 0 then
          Result := Result + ' ' + Number (Num mod I, USStyle);
      end;
  End;

Function Number (const Num : Extended; const USStyle : Boolean = False) : String;
const Eng_point = ' point';
var N, I : Int64;
  Begin
    Result := Number (Trunc (Num), USStyle);
    N := Abs (Round (Frac (Num) * 1000000));
    if N > 0 then
      begin
        Result := Result + Eng_point;
        I := 100000;
        While (I > 1) and (N > 0) do
          begin
            Result := Result + ' ' + Number (N div I);
            N := N mod I;
            I := I div 10;
          end;
      end;
  End;



{                                                                              }
{ Pack                                                                         }
{                                                                              }
Function Pack (const D : Int64) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function Pack (const D : Integer) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function Pack (const D : SmallInt) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function Pack (const D : ShortInt) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function Pack (const D : Byte) : String;
  Begin
    Result := Char (D);
  End;

Function Pack (const D : Word) : String;
  Begin
    Result := Char (Lo (D)) + Char (Hi (D));
  End;

Function Pack (const D : String) : String;
  Begin
    Result := Pack (Length (D)) + D;
  End;

Function PackShortString (const D : ShortString) : String;
  Begin
    Result := D [0] + D;
  End;

Function PackSingle (const D : Single) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function PackDouble (const D : Double) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function Pack (const D : Extended) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function PackCurrency (const D : Currency) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function PackDateTime (const D : TDateTime) : String;
  Begin
    SetLength (Result, Sizeof (D));
    Move (D, Result [1], Sizeof (D));
  End;

Function Pack (const D : Boolean) : String;
  Begin
    Result := Char (Ord (D));
  End;

Function UnpackShortString (const D : String) : ShortString;
var L : Byte;
  Begin
    L := Byte (D [1]);
    SetLength (Result, L);
    if L > 0 then
      Move (D [2], Result [1], L);
  End;

Function UnpackString (const D : String) : String;
var L : Integer;
  Begin
    L := UnpackInteger (CopyLeft (D, Sizeof (Integer)));
    SetLength (Result, L);
    if L > 0 then
      Move (D [5], Result [1], L);
  End;

Function UnpackInteger (const D : String) : Integer;
  Begin
    Move (D [1], Result, Sizeof (Result));
  End;

Function UnpackSingle (const D : String) : Single;
  Begin
    Move (D [1], Result, Sizeof (Result));
  End;

Function UnpackDouble (const D : String) : Double;
  Begin
    Move (D [1], Result, Sizeof (Result));
  End;

Function UnpackExtended (const D : String) : Extended;
  Begin
    Move (D [1], Result, Sizeof (Result));
  End;

Function UnpackBoolean (const D : String) : Boolean;
  Begin
    Move (D [1], Result, Sizeof (Result));
  End;

Function UnpackDateTime (const D : String) : TDateTime;
  Begin
    Move (D [1], Result, Sizeof (Result));
  End;

end.

