{$INCLUDE cHeader.inc}
unit cUtils;

{                                                                              }
{                  Miscellaneous utility functions v0.12 (L0)                  }
{                                                                              }
{        This unit is copyright © 2000 by David Butler (david@e.co.za)         }
{                                                                              }
{                  This unit is part of Delphi Fundamentals.                   }
{                    It's original file name is cUtils.pas                     }
{                      It was generated 5 Jul 2000 02:10.                      }
{                                                                              }
{                I invite you to use this unit, free of charge.                }
{        I invite you to distibute this unit, but it must be for free.         }
{             I also invite you to contribute to its development,              }
{             but do not distribute a modified copy of this file.              }
{       Send modifications, suggestions and bug reports to david@e.co.za       }
{                                                                              }
{                                                                              }
{ Revision history:                                                            }
{   2000/02/02  v0.01  Initial version                                         }
{   2000/03/08  v0.02  Moved RealArray / IntegerArray functions from cMaths.   }
{   2000/04/10  v0.03  Added Append, Renamed Delete to Remove and added        }
{                      StringArrays.                                           }
{   2000/05/03  v0.04  Added Path functions.                                   }
{                      Added locked integer manipulation functions.            }
{   2000/05/08  v0.05  Cleaned up unit.                                        }
{                      188 lines interface. 1171 lines implementation.         }
{   2000/06/01  v0.06  Added Range and Dup constructors for dynamic arrays.    }
{   2000/06/03  v0.07  Added ArrayInsert functions.                            }
{   2000/06/06  v0.08  Moved bit functions from cMaths.                        }
{   2000/06/08  v0.09  Removed TInteger, TReal, TRealArray, TIntegerArray.     }
{                      299 lines interface. 2019 lines implementations.        }
{   2000/06/10  v0.10  Added linked lists for Integer, Int64, Extended and     }
{                      String.                                                 }
{                      518 lines interface. 3396 lines implementation.         }
{   2000/06/14  v0.11  Unit now generated from a template using a source       }
{                      pre-processor that uses L0 :-)                          }
{                      560 lines interface. 1328 lines implementation!         }
{                      Produced source: 644 lines interface, 4716 lines        }
{                      implementation.                                         }
{   2000/07/04  v0.12  Revision for Fundamentals release.                      }
{                                                                              }

interface

uses
  SysUtils,
  Classes,
  Math;



{                                                                              }
{ Integer types                                                                }
{   Byte      unsigned 8 bits                                                  }
{   Word      unsigned 16 bits                                                 }
{   LongWord  unsigned 32 bits                                                 }
{   ShortInt  signed 8 bits                                                    }
{   SmallInt  signed 16 bits                                                   }
{   LongInt   signed 32 bits                                                   }
{   Int64     signed 64 bits                                                   }
{   Integer   signed 32 bits (Delphi 5)                                        }
{   Cardinal  unsigned 32 bits (Delphi 5)                                      }
{                                                                              }
const
  MinByte     = Low (Byte);
  MaxByte     = High (Byte);
  MinWord     = Low (Word);
  MaxWord     = High (Word);
  MinLongWord = Low (LongWord);
  MaxLongWord = High (LongWord);
  MinShortInt = Low (ShortInt);
  MaxShortInt = High (ShortInt);
  MinSmallInt = Low (SmallInt);
  MaxSmallInt = High (SmallInt);
  MinLongInt  = Low (LongInt);
  MaxLongInt  = High (LongInt);
  MaxInt64    = High (Int64);
  MinInt64    = Low (Int64);
  MinInteger  = Low (Integer);
  MaxInteger  = High (Integer);
  MinCardinal = Low (Cardinal);
  MaxCardinal = High (Cardinal);



{                                                                              }
{ Floating point types                                                         }
{   Single    32 bits                                                          }
{   Double    64 bits                                                          }
{   Extended  80 bits                                                          }
{                                                                              }
const
  MinSingle   = 1.5E-45;
  MaxSingle   = 3.4E+38;
  MinDouble   = 5.0E-324;
  MaxDouble   = 1.7E+308;
  MinExtended = 3.4E-4932;
  MaxExtended = 1.1E+4932;

type
  TFPUPrecision = (pSingle, pDouble, pExtended);

Procedure SetFPUPrecision (const Precision : TFPUPrecision);

{ Fuzzy floating point operations                                              }
{                                                                              }
{ FloatZero and FloatEqual returns True if the numbers are within              }
{   FloatCompareTolerance.                                                     }
{ FloatDefuzz returns zero if the number is nearly zero.                       }
Function  FloatEqual (const X, Y : Extended) : Boolean;
Function  FloatZero (const X : Extended) : Boolean;
Procedure FloatDefuzz (var X : Single); overload;
Procedure FloatDefuzz (var X : Double); overload;
Procedure FloatDefuzz (var X : Extended); overload;

var
  FloatCompareTolerance : Single = 1e-8;



{                                                                              }
{ Sets                                                                         }
{                                                                              }
type
  CharSet = Set of Char;
  ByteSet = Set of Byte;
  PCharSet = ^CharSet;
  PByteSet = ^ByteSet;

Function AsCharSet (const C : Array of Char) : CharSet;
Function AsByteSet (const C : Array of Byte) : ByteSet;



{                                                                              }
{ Type conversion                                                              }
{                                                                              }
Function  StrToFloatDef (const S : String; const Default : Extended) : Extended;
Function  BooleanToStr (const B : Boolean) : String;
Function  StrToBoolean (const S : String) : Boolean;



{                                                                              }
{ Swap                                                                         }
{                                                                              }
Procedure Swap (var X, Y : Boolean); overload;
Procedure Swap (var X, Y : Byte); overload;
Procedure Swap (var X, Y : Word); overload;
Procedure Swap (var X, Y : LongWord); overload;
Procedure Swap (var X, Y : ShortInt); overload;
Procedure Swap (var X, Y : SmallInt); overload;
Procedure Swap (var X, Y : LongInt); overload;
Procedure Swap (var X, Y : Int64); overload;
Procedure Swap (var X, Y : Single); overload;
Procedure Swap (var X, Y : Double); overload;
Procedure Swap (var X, Y : Extended); overload;
Procedure Swap (var X, Y : String); overload;
Procedure Swap (var X, Y : Pointer); overload;
Procedure Swap (var X, Y : TObject); overload;



{                                                                              }
{ Cond                                                                         }
{   Cond returns TrueValue if Expr is True, otherwise it returns FalseValue.   }
{                                                                              }
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : LongInt) : LongInt; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : Int64) : Int64; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : Single) : Single; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : Double) : Double; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : Extended) : Extended; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : String) : String; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : Pointer) : Pointer; overload;
Function  Cond (const Expr : Boolean; const TrueValue, FalseValue : TObject) : TObject; overload;



{                                                                              }
{ Dynamic Arrays                                                               }
{                                                                              }
type
  ByteArray = Array of Byte;
  WordArray = Array of Word;
  LongWordArray = Array of LongWord;
  ShortIntArray = Array of ShortInt;
  SmallIntArray = Array of SmallInt;
  LongIntArray = Array of LongInt;
  Int64Array = Array of Int64;
  SingleArray = Array of Single;
  DoubleArray = Array of Double;
  ExtendedArray = Array of Extended;
  StringArray = Array of String;
  PointerArray = Array of Pointer;
  ObjectArray = Array of TObject;
  CharSetArray = Array of CharSet;
  ByteSetArray = Array of ByteSet;
  IntegerArray = LongIntArray;
  CardinalArray = LongWordArray;

Function  Append (var V : ByteArray; const R : Byte) : Integer; overload;
Function  Append (var V : WordArray; const R : Word) : Integer; overload;
Function  Append (var V : LongWordArray; const R : LongWord) : Integer; overload;
Function  Append (var V : ShortIntArray; const R : ShortInt) : Integer; overload;
Function  Append (var V : SmallIntArray; const R : SmallInt) : Integer; overload;
Function  Append (var V : LongIntArray; const R : LongInt) : Integer; overload;
Function  Append (var V : Int64Array; const R : Int64) : Integer; overload;
Function  Append (var V : SingleArray; const R : Single) : Integer; overload;
Function  Append (var V : DoubleArray; const R : Double) : Integer; overload;
Function  Append (var V : ExtendedArray; const R : Extended) : Integer; overload;
Function  Append (var V : StringArray; const R : String) : Integer; overload;
Function  Append (var V : PointerArray; const R : Pointer) : Integer; overload;
Function  Append (var V : ObjectArray; const R : TObject) : Integer; overload;
Function  Append (var V : CharSetArray; const R : CharSet) : Integer; overload;
Function  Append (var V : ByteSetArray; const R : ByteSet) : Integer; overload;

Function  Append (var V : ByteArray; const R : ByteArray) : Integer; overload;
Function  Append (var V : WordArray; const R : WordArray) : Integer; overload;
Function  Append (var V : LongWordArray; const R : LongWordArray) : Integer; overload;
Function  Append (var V : ShortIntArray; const R : ShortIntArray) : Integer; overload;
Function  Append (var V : SmallIntArray; const R : SmallIntArray) : Integer; overload;
Function  Append (var V : LongIntArray; const R : LongIntArray) : Integer; overload;
Function  Append (var V : Int64Array; const R : Int64Array) : Integer; overload;
Function  Append (var V : SingleArray; const R : SingleArray) : Integer; overload;
Function  Append (var V : DoubleArray; const R : DoubleArray) : Integer; overload;
Function  Append (var V : ExtendedArray; const R : ExtendedArray) : Integer; overload;
Function  Append (var V : StringArray; const R : StringArray) : Integer; overload;
Function  Append (var V : PointerArray; const R : PointerArray) : Integer; overload;
Function  Append (var V : ObjectArray; const R : ObjectArray) : Integer; overload;
Function  Append (var V : CharSetArray; const R : CharSetArray) : Integer; overload;
Function  Append (var V : ByteSetArray; const R : ByteSetArray) : Integer; overload;

Procedure Remove (var V : ByteArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : WordArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : LongWordArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : ShortIntArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : SmallIntArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : LongIntArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : Int64Array; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : SingleArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : DoubleArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : ExtendedArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : StringArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : PointerArray; const Idx : Integer; const Count : Integer = 1); overload;
Procedure Remove (var V : ObjectArray; const Idx : Integer; const Count : Integer = 1;
          const FreeObjects : Boolean = False); overload;

Procedure ArrayInsert (var V : ByteArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : WordArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : LongWordArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : ShortIntArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : SmallIntArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : LongIntArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : Int64Array; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : SingleArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : DoubleArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : ExtendedArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : StringArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : PointerArray; const Idx : Integer; const Count : Integer); overload;
Procedure ArrayInsert (var V : ObjectArray; const Idx : Integer; const Count : Integer); overload;

Procedure FreeObjectArray (var V); overload;
Procedure FreeObjectArray (var V; const LoIdx, HiIdx : Integer); overload;

Function  PosNext (const Find : Byte; const V : ByteArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : Word; const V : WordArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : LongWord; const V : LongWordArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : ShortInt; const V : ShortIntArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : SmallInt; const V : SmallIntArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : LongInt; const V : LongIntArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : Int64; const V : Int64Array; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : Single; const V : SingleArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : Double; const V : DoubleArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : Extended; const V : ExtendedArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function  PosNext (const Find : String; const V : StringArray; const PrevPos : Integer = -1;
          const IsSortedAscending : Boolean = False) : Integer; overload;
Function PosNext (const Find : Pointer; const V : PointerArray; const PrevPos : Integer = -1) : Integer; overload;
Function PosNext (const Find : TObject; const V : ObjectArray; const PrevPos : Integer = -1) : Integer; overload;

Function  Intersection (const V1, V2 : ByteArray; const IsSortedAscending : Boolean = False) : ByteArray; overload;
Function  Intersection (const V1, V2 : WordArray; const IsSortedAscending : Boolean = False) : WordArray; overload;
Function  Intersection (const V1, V2 : LongWordArray; const IsSortedAscending : Boolean = False) : LongWordArray; overload;
Function  Intersection (const V1, V2 : ShortIntArray; const IsSortedAscending : Boolean = False) : ShortIntArray; overload;
Function  Intersection (const V1, V2 : SmallIntArray; const IsSortedAscending : Boolean = False) : SmallIntArray; overload;
Function  Intersection (const V1, V2 : LongIntArray; const IsSortedAscending : Boolean = False) : LongIntArray; overload;
Function  Intersection (const V1, V2 : Int64Array; const IsSortedAscending : Boolean = False) : Int64Array; overload;
Function  Intersection (const V1, V2 : SingleArray; const IsSortedAscending : Boolean = False) : SingleArray; overload;
Function  Intersection (const V1, V2 : DoubleArray; const IsSortedAscending : Boolean = False) : DoubleArray; overload;
Function  Intersection (const V1, V2 : ExtendedArray; const IsSortedAscending : Boolean = False) : ExtendedArray; overload;
Function  Intersection (const V1, V2 : StringArray; const IsSortedAscending : Boolean = False) : StringArray; overload;

Procedure Reverse (var V : ByteArray); overload;
Procedure Reverse (var V : WordArray); overload;
Procedure Reverse (var V : LongWordArray); overload;
Procedure Reverse (var V : ShortIntArray); overload;
Procedure Reverse (var V : SmallIntArray); overload;
Procedure Reverse (var V : LongIntArray); overload;
Procedure Reverse (var V : Int64Array); overload;
Procedure Reverse (var V : SingleArray); overload;
Procedure Reverse (var V : DoubleArray); overload;
Procedure Reverse (var V : ExtendedArray); overload;
Procedure Reverse (var V : StringArray); overload;
Procedure Reverse (var V : PointerArray); overload;
Procedure Reverse (var V : ObjectArray); overload;

Function  AsByteArray (const V : Array of Byte) : ByteArray;
Function  AsWordArray (const V : Array of Word) : WordArray;
Function  AsLongWordArray (const V : Array of LongWord) : LongWordArray;
Function  AsCardinalArray (const V : Array of Cardinal) : CardinalArray;
Function  AsShortIntArray (const V : Array of ShortInt) : ShortIntArray;
Function  AsSmallIntArray (const V : Array of SmallInt) : SmallIntArray;
Function  AsLongIntArray (const V : Array of LongInt) : LongIntArray;
Function  AsIntegerArray (const V : Array of Integer) : IntegerArray;
Function  AsInt64Array (const V : Array of Int64) : Int64Array;
Function  AsSingleArray (const V : Array of Single) : SingleArray;
Function  AsDoubleArray (const V : Array of Double) : DoubleArray;
Function  AsExtendedArray (const V : Array of Extended) : ExtendedArray;
Function  AsStringArray (const V : Array of String) : StringArray;
Function  AsPointerArray (const V : Array of Pointer) : PointerArray;
Function  AsCharSetArray (const V : Array of CharSet) : CharSetArray;
Function  AsObjectArray (const V : Array of TObject) : ObjectArray;

Function  RangeByte (const First : Byte; const Count : Integer; const Increment : Byte = 1) : ByteArray;
Function  RangeWord (const First : Word; const Count : Integer; const Increment : Word = 1) : WordArray;
Function  RangeLongWord (const First : LongWord; const Count : Integer; const Increment : LongWord = 1) : LongWordArray;
Function  RangeCardinal (const First : Cardinal; const Count : Integer; const Increment : Cardinal = 1) : CardinalArray;
Function  RangeShortInt (const First : ShortInt; const Count : Integer; const Increment : ShortInt = 1) : ShortIntArray;
Function  RangeSmallInt (const First : SmallInt; const Count : Integer; const Increment : SmallInt = 1) : SmallIntArray;
Function  RangeLongInt (const First : LongInt; const Count : Integer; const Increment : LongInt = 1) : LongIntArray;
Function  RangeInteger (const First : Integer; const Count : Integer; const Increment : Integer = 1) : IntegerArray;
Function  RangeInt64 (const First : Int64; const Count : Integer; const Increment : Int64 = 1) : Int64Array;
Function  RangeSingle (const First : Single; const Count : Integer; const Increment : Single = 1) : SingleArray;
Function  RangeDouble (const First : Double; const Count : Integer; const Increment : Double = 1) : DoubleArray;
Function  RangeExtended (const First : Extended; const Count : Integer; const Increment : Extended = 1) : ExtendedArray;

Function  DupByte (const V : Byte; const Count : Integer) : ByteArray;
Function  DupWord (const V : Word; const Count : Integer) : WordArray;
Function  DupLongWord (const V : LongWord; const Count : Integer) : LongWordArray;
Function  DupCardinal (const V : Cardinal; const Count : Integer) : CardinalArray;
Function  DupShortInt (const V : ShortInt; const Count : Integer) : ShortIntArray;
Function  DupSmallInt (const V : SmallInt; const Count : Integer) : SmallIntArray;
Function  DupLongInt (const V : LongInt; const Count : Integer) : LongIntArray;
Function  DupInteger (const V : Integer; const Count : Integer) : IntegerArray;
Function  DupInt64 (const V : Int64; const Count : Integer) : Int64Array;
Function  DupSingle (const V : Single; const Count : Integer) : SingleArray;
Function  DupDouble (const V : Double; const Count : Integer) : DoubleArray;
Function  DupExtended (const V : Extended; const Count : Integer) : ExtendedArray;
Function  DupString (const V : String; const Count : Integer) : StringArray;
Function  DupCharSet (const V : CharSet; const Count : Integer) : CharSetArray;

Function  IsEqual (const V1, V2 : ByteArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : WordArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : LongWordArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : ShortIntArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : SmallIntArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : LongIntArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : Int64Array) : Boolean; overload;
Function  IsEqual (const V1, V2 : SingleArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : DoubleArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : ExtendedArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : StringArray) : Boolean; overload;
Function  IsEqual (const V1, V2 : CharSetArray) : Boolean; overload;

Function  ByteArrayToLongIntArray (const V : ByteArray) : LongIntArray;
Function  WordArrayToLongIntArray (const V : WordArray) : LongIntArray;
Function  ShortIntArrayToLongIntArray (const V : ShortIntArray) : LongIntArray;
Function  SmallIntArrayToLongIntArray (const V : SmallIntArray) : LongIntArray;
Function  LongIntArrayToInt64Array (const V : LongIntArray) : Int64Array;
Function  LongIntArrayToSingleArray (const V : LongIntArray) : SingleArray;
Function  LongIntArrayToDoubleArray (const V : LongIntArray) : DoubleArray;
Function  LongIntArrayToExtendedArray (const V : LongIntArray) : ExtendedArray;
Function  LongIntArrayToStringArray (const V : LongIntArray) : StringArray;
Function  SingleArrayToExtendedArray (const V : SingleArray) : ExtendedArray;
Function  SingleArrayToDoubleArray (const V : SingleArray) : DoubleArray;
Function  SingleArrayToLongIntArray (const V : SingleArray) : LongIntArray;
Function  SingleArrayToInt64Array (const V : SingleArray) : Int64Array;
Function  SingleArrayToStringArray (const V : SingleArray) : StringArray;
Function  DoubleArrayToSingleArray (const V : DoubleArray) : SingleArray;
Function  DoubleArrayToExtendedArray (const V : DoubleArray) : ExtendedArray;
Function  DoubleArrayToLongIntArray (const V : DoubleArray) : LongIntArray;
Function  DoubleArrayToInt64Array (const V : DoubleArray) : Int64Array;
Function  DoubleArrayToStringArray (const V : DoubleArray) : StringArray;
Function  ExtendedArrayToSingleArray (const V : ExtendedArray) : SingleArray;
Function  ExtendedArrayToDoubleArray (const V : ExtendedArray) : DoubleArray;
Function  ExtendedArrayToLongIntArray (const V : ExtendedArray) : LongIntArray;
Function  ExtendedArrayToInt64Array (const V : ExtendedArray) : Int64Array;
Function  ExtendedArrayToStringArray (const V : ExtendedArray) : StringArray;
Function  StringArrayToLongIntArray (const V : StringArray) : LongIntArray;
Function  StringArrayToInt64Array (const V : StringArray) : Int64Array;
Function  StringArrayToSingleArray (const V : StringArray) : SingleArray;
Function  StringArrayToDoubleArray (const V : StringArray) : DoubleArray;
Function  StringArrayToExtendedArray (const V : StringArray) : ExtendedArray;

Procedure StringArrayToTStrings (const S : StringArray; const D : TStrings);
Function  TStringsToStringArray (const V : TStrings) : StringArray;
Procedure PointerArrayToTList (const S : PointerArray; const D : TList);
Function  TListToPointerArray (const V : TList) : PointerArray;

Function  ByteArrayToStr (const V : ByteArray) : String;
Function  WordArrayToStr (const V : WordArray) : String;
Function  LongWordArrayToStr (const V : LongWordArray) : String;
Function  CardinalArrayToStr (const V : CardinalArray) : String;
Function  ShortIntArrayToStr (const V : ShortIntArray) : String;
Function  SmallIntArrayToStr (const V : SmallIntArray) : String;
Function  LongIntArrayToStr (const V : LongIntArray) : String;
Function  IntegerArrayToStr (const V : IntegerArray) : String;
Function  Int64ArrayToStr (const V : Int64Array) : String;
Function  SingleArrayToStr (const V : SingleArray) : String;
Function  DoubleArrayToStr (const V : DoubleArray) : String;
Function  ExtendedArrayToStr (const V : ExtendedArray) : String;
Function  StringArrayToStr (const V : StringArray) : String;

Function  StrToByteArray (const S : String; const Delimiter : Char = ',') : ByteArray;
Function  StrToWordArray (const S : String; const Delimiter : Char = ',') : WordArray;
Function  StrToLongWordArray (const S : String; const Delimiter : Char = ',') : LongWordArray;
Function  StrToCardinalArray (const S : String; const Delimiter : Char = ',') : CardinalArray;
Function  StrToShortIntArray (const S : String; const Delimiter : Char = ',') : ShortIntArray;
Function  StrToSmallIntArray (const S : String; const Delimiter : Char = ',') : SmallIntArray;
Function  StrToLongIntArray (const S : String; const Delimiter : Char = ',') : LongIntArray;
Function  StrToIntegerArray (const S : String; const Delimiter : Char = ',') : IntegerArray;
Function  StrToInt64Array (const S : String; const Delimiter : Char = ',') : Int64Array;
Function  StrToSingleArray (const S : String; const Delimiter : Char = ',') : SingleArray;
Function  StrToDoubleArray (const S : String; const Delimiter : Char = ',') : DoubleArray;
Function  StrToExtendedArray (const S : String; const Delimiter : Char = ',') : ExtendedArray;
Function  StrToStringArray (const S : String; const Delimiter : Char = ',') : StringArray;

Procedure Sort (var V : ByteArray); overload;
Procedure Sort (var V : WordArray); overload;
Procedure Sort (var V : LongWordArray); overload;
Procedure Sort (var V : ShortIntArray); overload;
Procedure Sort (var V : SmallIntArray); overload;
Procedure Sort (var V : LongIntArray); overload;
Procedure Sort (var V : Int64Array); overload;
Procedure Sort (var V : SingleArray); overload;
Procedure Sort (var V : DoubleArray); overload;
Procedure Sort (var V : ExtendedArray); overload;
Procedure Sort (var V : StringArray); overload;



{                                                                              }
{ Linked lists                                                                 }
{                                                                              }
type
  PLinkedItem = ^LinkedItem;
  LinkedItem = object
    Next : PLinkedItem;

    Function  HasNext : Boolean;
    Function  Last : PLinkedItem;
    Function  Count : Integer;
    Procedure RemoveNext;
    Procedure InsertAfter (const Item : PLinkedItem);
  end;

  PDoublyLinkedItem = ^DoublyLinkedItem;
  DoublyLinkedItem = object (LinkedItem)
    Prev : PDoublyLinkedItem;

    Function  HasPrev : Boolean;
    Function  First : PDoublyLinkedItem;
    Procedure Remove;
    Procedure RemoveNext;
    Procedure RemovePrev;
    Procedure InsertAfter (const Item : PDoublyLinkedItem);
    Procedure InsertBefore (const Item : PDoublyLinkedItem);
  end;

  PLinkedInteger = ^LinkedInteger;
  LinkedInteger = object (LinkedItem)
    Value : Integer;

    Procedure InsertAfter (const V : Integer); reintroduce; overload;
    Procedure Append (const V : Integer);
    Function  FindNext (const Find : Integer) : PLinkedInteger;
  end;
  PDoublyLinkedInteger = ^DoublyLinkedInteger;
  DoublyLinkedInteger = object (DoublyLinkedItem)
    Value : Integer;

    Procedure InsertAfter (const V : Integer); reintroduce; overload;
    Procedure InsertBefore (const V : Integer); reintroduce; overload;
    Procedure InsertFirst (const V : Integer);
    Procedure Append (const V : Integer);
    Function  FindNext (const Find : Integer) : PDoublyLinkedInteger;
    Function  FindPrev (const Find : Integer) : PDoublyLinkedInteger;
  end;

  PLinkedInt64 = ^LinkedInt64;
  LinkedInt64 = object (LinkedItem)
    Value : Int64;

    Procedure InsertAfter (const V : Int64); reintroduce; overload;
    Procedure Append (const V : Int64);
    Function  FindNext (const Find : Int64) : PLinkedInt64;
  end;
  PDoublyLinkedInt64 = ^DoublyLinkedInt64;
  DoublyLinkedInt64 = object (DoublyLinkedItem)
    Value : Int64;

    Procedure InsertAfter (const V : Int64); reintroduce; overload;
    Procedure InsertBefore (const V : Int64); reintroduce; overload;
    Procedure InsertFirst (const V : Int64);
    Procedure Append (const V : Int64);
    Function  FindNext (const Find : Int64) : PDoublyLinkedInt64;
    Function  FindPrev (const Find : Int64) : PDoublyLinkedInt64;
  end;

  PLinkedSingle = ^LinkedSingle;
  LinkedSingle = object (LinkedItem)
    Value : Single;

    Procedure InsertAfter (const V : Single); reintroduce; overload;
    Procedure Append (const V : Single);
    Function  FindNext (const Find : Single) : PLinkedSingle;
  end;
  PDoublyLinkedSingle = ^DoublyLinkedSingle;
  DoublyLinkedSingle = object (DoublyLinkedItem)
    Value : Single;

    Procedure InsertAfter (const V : Single); reintroduce; overload;
    Procedure InsertBefore (const V : Single); reintroduce; overload;
    Procedure InsertFirst (const V : Single);
    Procedure Append (const V : Single);
    Function  FindNext (const Find : Single) : PDoublyLinkedSingle;
    Function  FindPrev (const Find : Single) : PDoublyLinkedSingle;
  end;

  PLinkedDouble = ^LinkedDouble;
  LinkedDouble = object (LinkedItem)
    Value : Double;

    Procedure InsertAfter (const V : Double); reintroduce; overload;
    Procedure Append (const V : Double);
    Function  FindNext (const Find : Double) : PLinkedDouble;
  end;
  PDoublyLinkedDouble = ^DoublyLinkedDouble;
  DoublyLinkedDouble = object (DoublyLinkedItem)
    Value : Double;

    Procedure InsertAfter (const V : Double); reintroduce; overload;
    Procedure InsertBefore (const V : Double); reintroduce; overload;
    Procedure InsertFirst (const V : Double);
    Procedure Append (const V : Double);
    Function  FindNext (const Find : Double) : PDoublyLinkedDouble;
    Function  FindPrev (const Find : Double) : PDoublyLinkedDouble;
  end;

  PLinkedExtended = ^LinkedExtended;
  LinkedExtended = object (LinkedItem)
    Value : Extended;

    Procedure InsertAfter (const V : Extended); reintroduce; overload;
    Procedure Append (const V : Extended);
    Function  FindNext (const Find : Extended) : PLinkedExtended;
  end;
  PDoublyLinkedExtended = ^DoublyLinkedExtended;
  DoublyLinkedExtended = object (DoublyLinkedItem)
    Value : Extended;

    Procedure InsertAfter (const V : Extended); reintroduce; overload;
    Procedure InsertBefore (const V : Extended); reintroduce; overload;
    Procedure InsertFirst (const V : Extended);
    Procedure Append (const V : Extended);
    Function  FindNext (const Find : Extended) : PDoublyLinkedExtended;
    Function  FindPrev (const Find : Extended) : PDoublyLinkedExtended;
  end;

  PLinkedString = ^LinkedString;
  LinkedString = object (LinkedItem)
    Value : String;

    Procedure InsertAfter (const V : String); reintroduce; overload;
    Procedure Append (const V : String);
    Function  FindNext (const Find : String) : PLinkedString;
  end;
  PDoublyLinkedString = ^DoublyLinkedString;
  DoublyLinkedString = object (DoublyLinkedItem)
    Value : String;

    Procedure InsertAfter (const V : String); reintroduce; overload;
    Procedure InsertBefore (const V : String); reintroduce; overload;
    Procedure InsertFirst (const V : String);
    Procedure Append (const V : String);
    Function  FindNext (const Find : String) : PDoublyLinkedString;
    Function  FindPrev (const Find : String) : PDoublyLinkedString;
  end;


Function  CreateLinkedInteger (const V : Integer = 0) : PLinkedInteger;
Function  CreateLinkedInt64 (const V : Int64 = 0) : PLinkedInt64;
Function  CreateLinkedSingle (const V : Single = 0.0) : PLinkedSingle;
Function  CreateLinkedDouble (const V : Double = 0.0) : PLinkedDouble;
Function  CreateLinkedExtended (const V : Extended = 0.0) : PLinkedExtended;
Function  CreateLinkedString (const V : String = '') : PLinkedString;
Function  CreateDoublyLinkedInteger (const V : Integer = 0) : PDoublyLinkedInteger;
Function  CreateDoublyLinkedInt64 (const V : Int64 = 0) : PDoublyLinkedInt64;
Function  CreateDoublyLinkedSingle (const V : Single = 0.0) : PDoublyLinkedSingle;
Function  CreateDoublyLinkedDouble (const V : Double = 0.0) : PDoublyLinkedDouble;
Function  CreateDoublyLinkedExtended (const V : Extended = 0.0) : PDoublyLinkedExtended;
Function  CreateDoublyLinkedString (const V : String = '') : PDoublyLinkedString;
{
Procedure FreeLinkedList (const V : PLinkedInteger); overload;
Procedure FreeLinkedList (const V : PLinkedInt64); overload;
Procedure FreeLinkedList (const V : PLinkedSingle); overload;
Procedure FreeLinkedList (const V : PLinkedDouble); overload;
Procedure FreeLinkedList (const V : PLinkedExtended); overload;
Procedure FreeLinkedList (const V : PLinkedString); overload;
Procedure FreeLinkedList (const V : PDoublyLinkedInteger); overload;
Procedure FreeLinkedList (const V : PDoublyLinkedInt64); overload;
Procedure FreeLinkedList (const V : PDoublyLinkedSingle); overload;
Procedure FreeLinkedList (const V : PDoublyLinkedDouble); overload;
Procedure FreeLinkedList (const V : PDoublyLinkedExtended); overload;
Procedure FreeLinkedList (const V : PDoublyLinkedString); overload;
}
Function  LinkedIntegerListToStr (const V : PLinkedInteger) : String;
Function  LinkedInt64ListToStr (const V : PLinkedInt64) : String;
Function  LinkedSingleListToStr (const V : PLinkedSingle) : String;
Function  LinkedDoubleListToStr (const V : PLinkedDouble) : String;
Function  LinkedExtendedListToStr (const V : PLinkedExtended) : String;
Function  LinkedStringListToStr (const V : PLinkedString) : String;
Function  DoublyLinkedIntegerListToStr (const V : PDoublyLinkedInteger) : String;
Function  DoublyLinkedInt64ListToStr (const V : PDoublyLinkedInt64) : String;
Function  DoublyLinkedSingleListToStr (const V : PDoublyLinkedSingle) : String;
Function  DoublyLinkedDoubleListToStr (const V : PDoublyLinkedDouble) : String;
Function  DoublyLinkedExtendedListToStr (const V : PDoublyLinkedExtended) : String;
Function  DoublyLinkedStringListToStr (const V : PDoublyLinkedString) : String;

Function  StrToLinkedIntegerList (const S : String) : PLinkedInteger;
Function  StrToLinkedInt64List (const S : String) : PLinkedInt64;
Function  StrToLinkedSingleList (const S : String) : PLinkedSingle;
Function  StrToLinkedDoubleList (const S : String) : PLinkedDouble;
Function  StrToLinkedExtendedList (const S : String) : PLinkedExtended;
Function  StrToLinkedStringList (const S : String) : PLinkedString;
Function  StrToDoublyLinkedIntegerList (const S : String) : PDoublyLinkedInteger;
Function  StrToDoublyLinkedInt64List (const S : String) : PDoublyLinkedInt64;
Function  StrToDoublyLinkedSingleList (const S : String) : PDoublyLinkedSingle;
Function  StrToDoublyLinkedDoubleList (const S : String) : PDoublyLinkedDouble;
Function  StrToDoublyLinkedExtendedList (const S : String) : PDoublyLinkedExtended;
Function  StrToDoublyLinkedStringList (const S : String) : PDoublyLinkedString;

Function  IntegerArrayToLinkedIntegerList (const V : IntegerArray) : PLinkedInteger;
Function  Int64ArrayToLinkedInt64List (const V : Int64Array) : PLinkedInt64;
Function  SingleArrayToLinkedSingleList (const V : SingleArray) : PLinkedSingle;
Function  DoubleArrayToLinkedDoubleList (const V : DoubleArray) : PLinkedDouble;
Function  ExtendedArrayToLinkedExtendedList (const V : ExtendedArray) : PLinkedExtended;
Function  StringArrayToLinkedStringList (const V : StringArray) : PLinkedString;
Function  IntegerArrayToDoublyLinkedIntegerList (const V : IntegerArray) : PDoublyLinkedInteger;
Function  Int64ArrayToDoublyLinkedInt64List (const V : Int64Array) : PDoublyLinkedInt64;
Function  SingleArrayToDoublyLinkedSingleList (const V : SingleArray) : PDoublyLinkedSingle;
Function  DoubleArrayToDoublyLinkedDoubleList (const V : DoubleArray) : PDoublyLinkedDouble;
Function  ExtendedArrayToDoublyLinkedExtendedList (const V : ExtendedArray) : PDoublyLinkedExtended;
Function  StringArrayToDoublyLinkedStringList (const V : StringArray) : PDoublyLinkedString;

Function  LinkedIntegerListToIntegerArray (const V : PLinkedInteger) : IntegerArray;
Function  LinkedInt64ListToInt64Array (const V : PLinkedInt64) : Int64Array;
Function  LinkedSingleListToSingleArray (const V : PLinkedSingle) : SingleArray;
Function  LinkedDoubleListToDoubleArray (const V : PLinkedDouble) : DoubleArray;
Function  LinkedExtendedListToExtendedArray (const V : PLinkedExtended) : ExtendedArray;
Function  LinkedStringListToStringArray (const V : PLinkedString) : StringArray;
Function  DoublyLinkedIntegerListToIntegerArray (const V : PDoublyLinkedInteger) : IntegerArray;
Function  DoublyLinkedInt64ListToInt64Array (const V : PDoublyLinkedInt64) : Int64Array;
Function  DoublyLinkedSingleListToSingleArray (const V : PDoublyLinkedSingle) : SingleArray;
Function  DoublyLinkedDoubleListToDoubleArray (const V : PDoublyLinkedDouble) : DoubleArray;
Function  DoublyLinkedExtendedListToExtendedArray (const V : PDoublyLinkedExtended) : ExtendedArray;
Function  DoublyLinkedStringListToStringArray (const V : PDoublyLinkedString) : StringArray;

Function  AsLinkedIntegerList (const V : Array of Integer) : PLinkedInteger;
Function  AsLinkedInt64List (const V : Array of Int64) : PLinkedInt64;
Function  AsLinkedSingleList (const V : Array of Single) : PLinkedSingle;
Function  AsLinkedDoubleList (const V : Array of Double) : PLinkedDouble;
Function  AsLinkedExtendedList (const V : Array of Extended) : PLinkedExtended;
Function  AsLinkedStringList (const V : Array of String) : PLinkedString;
Function  AsDoublyLinkedIntegerList (const V : Array of Integer) : PDoublyLinkedInteger;
Function  AsDoublyLinkedInt64List (const V : Array of Int64) : PDoublyLinkedInt64;
Function  AsDoublyLinkedSingleList (const V : Array of Single) : PDoublyLinkedSingle;
Function  AsDoublyLinkedDoubleList (const V : Array of Double) : PDoublyLinkedDouble;
Function  AsDoublyLinkedExtendedList (const V : Array of Extended) : PDoublyLinkedExtended;
Function  AsDoublyLinkedStringList (const V : Array of String) : PDoublyLinkedString;

Function  IsEqual (const V1 : PLinkedInteger; const V2 : PLinkedInteger) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedInt64; const V2 : PLinkedInt64) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedSingle; const V2 : PLinkedSingle) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedDouble; const V2 : PLinkedDouble) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedExtended; const V2 : PLinkedExtended) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedString; const V2 : PLinkedString) : Boolean; overload;
Function  IsEqual (const V1 : PDoublyLinkedInteger; const V2 : PDoublyLinkedInteger) : Boolean; overload;
Function  IsEqual (const V1 : PDoublyLinkedInt64; const V2 : PDoublyLinkedInt64) : Boolean; overload;
Function  IsEqual (const V1 : PDoublyLinkedSingle; const V2 : PDoublyLinkedSingle) : Boolean; overload;
Function  IsEqual (const V1 : PDoublyLinkedDouble; const V2 : PDoublyLinkedDouble) : Boolean; overload;
Function  IsEqual (const V1 : PDoublyLinkedExtended; const V2 : PDoublyLinkedExtended) : Boolean; overload;
Function  IsEqual (const V1 : PDoublyLinkedString; const V2 : PDoublyLinkedString) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedInteger; const V2 : PDoublyLinkedInteger) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedInt64; const V2 : PDoublyLinkedInt64) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedSingle; const V2 : PDoublyLinkedSingle) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedDouble; const V2 : PDoublyLinkedDouble) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedExtended; const V2 : PDoublyLinkedExtended) : Boolean; overload;
Function  IsEqual (const V1 : PLinkedString; const V2 : PDoublyLinkedString) : Boolean; overload;



{                                                                              }
{ Path functions                                                               }
{                                                                              }
const
  PathSeparator = {$IFDEF UNIX}'/'{$ELSE}'\'{$ENDIF};

Function UnixPathToWindowsPath (const Path : String) : String;
Function WindowsPathToUnixPath (const Path : String) : String;
Function PathWithSlashAtEnd (const Path : String; const SlashCh : Char = PathSeparator) : String;
Function PathWithoutSlashAtEnd (const Path : String; const SlashCh : Char = PathSeparator) : String;
Function PathLeftElement (const Path : String; const SlashCh : Char = PathSeparator) : String;
Function PathRightElement (const Path : String; const SlashCh : Char = PathSeparator) : String;
Function PathWithoutLeftElement (const Path : String; const SlashCh : Char = PathSeparator) : String;
Function PathWithoutRightElement (const Path : String; const SlashCh : Char = PathSeparator) : String;



{                                                                              }
{ Locked integer manipulation (simple synchronization)                         }
{                                                                              }
{
Function LockedAdd (var Target : Integer; const Value : Integer) : Integer; assembler; register;
Function LockedCompareExchange (var Target : Integer; const Exch, Comp : Integer) : Integer; assembler; register;
Function LockedDec (var Target : Integer) : Integer; assembler; register;
Function LockedExchange (var Target : Integer; Value : Integer) : Integer; assembler; register;
Function LockedExchangeAdd (var Target : Integer; Value : Integer) : Integer; assembler; register;
Function LockedExchangeDec (var Target : Integer) : Integer; assembler; register;
Function LockedExchangeInc (var Target : Integer) : Integer; assembler; register;
Function LockedExchangeSub (var Target : Integer; Value : Integer) : Integer; assembler; register;
Function LockedInc (var Target : Integer) : Integer; assembler; register;
Function LockedSub (var Target : Integer; const Value : Integer) : Integer; assembler; register;
}


{                                                                              }
{ Bit functions                                                                }
{                                                                              }
{   All bit functions work on 32-bit values (LongWord).                        }
{   SwapBits reverses the bit order.                                           }
{   LSBit and MSBit returns bit number (0-31) of respectively the least and    }
{     most significant bit set.                                                }
{   SwapEndian swaps between little and big endian formats.                    }
{   BitCount returns the number of bits set.                                   }
{   LSBitsMask returns a value with all the N least significant bits set.      }
{   BitsRangeMask returns a value with the bits L to H set.                    }
{                                                                              }
const
  BitsPerCardinal = Sizeof (Cardinal) * 8;

Function  SwapBits (const Value : LongWord) : LongWord;
Function  LSBit (const Value : LongWord) : LongWord;
Function  MSBit (const Value : LongWord) : LongWord;
Function  SwapEndian (const Value : LongWord) : LongWord;
Function  BitCount (const Value : LongWord) : LongWord;
Procedure ToggleBit (var Value : LongWord; const Bit : Byte);
Procedure SetBit (var Value : LongWord; const Bit : Byte);
Procedure ClearBit (var Value : LongWord; const Bit : Byte);
Function  IsBitSet (const Value : LongWord; const Bit : Byte) : Boolean;
Function  LSBitsMask (const N : Byte) : Cardinal;
Function  MSBitsMask (const N : Byte) : Cardinal;
Function  BitRangeMask (const L, H : Byte) : LongWord;



{                                                                              }
{ Miscellaneous                                                                }
{                                                                              }
type
  TCompareResult = (crEqual, crLess, crGreater);

Function Compare (const I1, I2 : Integer) : TCompareResult; overload;
Function Compare (const I1, I2 : Int64) : TCompareResult; overload;
Function Compare (const I1, I2 : Single) : TCompareResult; overload;
Function Compare (const I1, I2 : Double) : TCompareResult; overload;
Function Compare (const I1, I2 : Extended) : TCompareResult; overload;
Function Compare (const I1, I2 : String) : TCompareResult; overload;
Function Compare (const I1, I2 : TObject) : TCompareResult; overload;

{$IFDEF MSWINDOWS}
Function GetUserName : String;
{$ENDIF}
Function ExceptionToStr (const E : Exception) : String;



implementation

uses
  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  
  // Delphi Fundamentals (L0)
  cStrings;      // Copy functions



{                                                                              }
{ Swap                                                                         }
{                                                                              }
Procedure Swap (var X, Y : Boolean);
var F : Boolean;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Byte);
var F : Byte;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Word);
var F : Word;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : LongWord);
var F : LongWord;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : ShortInt);
var F : ShortInt;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : SmallInt);
var F : SmallInt;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : LongInt);
var F : LongInt;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Int64);
var F : Int64;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Single);
var F : Single;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Double);
var F : Double;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Extended);
var F : Extended;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : String);
var F : String;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : Pointer);
var F : Pointer;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;

Procedure Swap (var X, Y : TObject);
var F : TObject;
  Begin
    F := X;
    X := Y;
    Y := F;
  End;



{                                                                              }
{ Cond                                                                         }
{                                                                              }
Function Cond (const Expr : Boolean; const TrueValue, FalseValue : Integer) : Integer;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : Int64) : Int64;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : Single) : Single;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : Double) : Double;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : Extended) : Extended;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : String) : String;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : Pointer) : Pointer;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;

Function Cond (const Expr : Boolean; const TrueValue, FalseValue : TObject) : TObject;
  Begin
    if Expr then
      Result := TrueValue else
      Result := FalseValue;
  End;



{                                                                              }
{ Floating point                                                               }
{                                                                              }

{ You can modify the level of accuracy by changing the FPU's control word.     }
{ The default accuracy, as initialized by the Delphi runtime library,          }
{ is the slowest, but most precise one (i.e. extended). Note that changing     }
{ this only changes the execution time of division and, in the case of         }
{ Pentium II and Pentium III processors, square roots.                         }
{ See http://econos.com/optimize/float.htm#ctrlwrd                             }
Procedure SetFPUPrecision (const Precision : TFPUPrecision);
  Begin
    Case Precision of
      pSingle   : Set8087CW (Default8087CW and $FCFF);
      pDouble   : Set8087CW ((Default8087CW and $FCFF) or $0200);
      pExtended : Set8087CW (Default8087CW or $0300);
    end;
  End;

Function FloatEqual (const X, Y : Extended) : Boolean;
  Begin
    Result := Abs (X - Y) <= FloatCompareTolerance;
  End;

Function FloatZero (const X : Extended) : Boolean;
  Begin
    Result := Abs (X) <= FloatCompareTolerance;
  End;

{ FloatDefuzz returns zero if the number is nearly zero. Avoids propogation    }
{   of nearly-zero values. The term 'fuzz' is courtesy of Earl F. Glynn        }
{   (EarlGlynn@att.net) which adapted it from the APL language.                }
Procedure FloatDefuzz (var X : Single);
  Begin
    if Abs (X) <= FloatCompareTolerance then
      X := 0.0;
  End;

Procedure FloatDefuzz (var X : Double);
  Begin
    if Abs (X) <= FloatCompareTolerance then
      X := 0.0;
  End;

Procedure FloatDefuzz (var X : Extended);
  Begin
    if Abs (X) <= FloatCompareTolerance then
      X := 0.0;
  End;




{                                                                              }
{ Sets                                                                         }
{                                                                              }
Function AsCharSet (const C : Array of Char) : CharSet;
var I : Integer;
  Begin
    Result := [];
    For I := 0 to High (C) do
      Result := Result + [C [I]];
  End;

Function AsByteSet (const C : Array of Byte) : ByteSet;
var I : Integer;
  Begin
    Result := [];
    For I := 0 to High (C) do
      Result := Result + [C [I]];
  End;


{                                                                              }
{ Append                                                                       }
{                                                                              }
Function Append (var V : ByteArray; const R : Byte) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : WordArray; const R : Word) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : LongWordArray; const R : LongWord) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : ShortIntArray; const R : ShortInt) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : SmallIntArray; const R : SmallInt) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : LongIntArray; const R : LongInt) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : Int64Array; const R : Int64) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : SingleArray; const R : Single) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : DoubleArray; const R : Double) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : ExtendedArray; const R : Extended) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : StringArray; const R : String) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : PointerArray; const R : Pointer) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : ObjectArray; const R : TObject) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : CharSetArray; const R : CharSet) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;

Function Append (var V : ByteSetArray; const R : ByteSet) : Integer;
  Begin
    Result := Length (V);
    SetLength (V, Result + 1);
    V [Result] := R;
  End;


Function Append (var V : ByteArray; const R : ByteArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : WordArray; const R : WordArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : LongWordArray; const R : LongWordArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : ShortIntArray; const R : ShortIntArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : SmallIntArray; const R : SmallIntArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : LongIntArray; const R : LongIntArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : Int64Array; const R : Int64Array) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : SingleArray; const R : SingleArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : DoubleArray; const R : DoubleArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : ExtendedArray; const R : ExtendedArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : PointerArray; const R : PointerArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : ObjectArray; const R : ObjectArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : CharSetArray; const R : CharSetArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;

Function Append (var V : ByteSetArray; const R : ByteSetArray) : Integer;
var LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        Move (R [0], V [Result], Sizeof (R [0]) * LR);
      end;
  End;


Function Append (var V : StringArray; const R : StringArray) : Integer;
var I, LR : Integer;
  Begin
    Result := Length (V);
    LR := Length (R);
    if LR > 0 then
      begin
        SetLength (V, Result + LR);
        For I := 0 to LR - 1 do
          V [Result + I] := R [I];
      end;
  End;



{                                                                              }
{ Remove                                                                       }
{                                                                              }
Procedure Remove (var V : ByteArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Byte));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : WordArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Word));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : LongWordArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (LongWord));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : ShortIntArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (ShortInt));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : SmallIntArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (SmallInt));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : LongIntArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (LongInt));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : Int64Array; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Int64));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : SingleArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Single));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : DoubleArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Double));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : ExtendedArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Extended));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : PointerArray; const Idx : Integer; const Count : Integer);
var I, J, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (Pointer));
    SetLength (V, L - J);
  End;


Procedure Remove (var V : ObjectArray; const Idx : Integer; const Count : Integer; const FreeObjects : Boolean);
var I, J, K, L, M : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    if FreeObjects then
      For K := I to L - J - 1 do
        FreeAndNil (V [K]);
    M := L - J - I;
    if M > 0 then
      Move (V [I + J], V [I], M * SizeOf (TObject));
    SetLength (V, L - J);
  End;

Procedure Remove (var V : StringArray; const Idx : Integer; const Count : Integer);
var I, J, K, L : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (L = 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    J := Min (Count, L - I);
    For K := I to L - J - 1 do
      V [K] := V [K + J];
    SetLength (V, L - J);
  End;

Procedure FreeObjectArray (var V);
var I : Integer;
    A : ObjectArray absolute V;
  Begin
    For I := Length (A) - 1 downto 0 do
      FreeAndNil (A [I]);
  End;

Procedure FreeObjectArray (var V; const LoIdx, HiIdx : Integer);
var I : Integer;
    A : ObjectArray absolute V;
  Begin
    For I := HiIdx downto LoIdx do
      FreeAndNil (A [I]);
  End;



{                                                                              }
{ ArrayInsert                                                                  }
{                                                                              }
Procedure ArrayInsert (var V : ByteArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Byte);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : WordArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Word);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : LongWordArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (LongWord);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : ShortIntArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (ShortInt);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : SmallIntArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (SmallInt);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : LongIntArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (LongInt);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : Int64Array; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Int64);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : SingleArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Single);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : DoubleArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Double);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : ExtendedArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Extended);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : StringArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (String);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : PointerArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (Pointer);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;

Procedure ArrayInsert (var V : ObjectArray; const Idx : Integer; const Count : Integer);
var I, L, C : Integer;
  Begin
    L := Length (V);
    if (Idx >= L) or (Idx + Count <= 0) or (Count = 0) then
      exit;
    I := Max (Idx, 0);
    SetLength (V, L + Count);
    C := Count * Sizeof (TObject);
    Move (V [I], V [I + Count], C);
    FillChar (V [I], C, #0);
  End;



{                                                                              }
{ PosNext                                                                      }
{   PosNext finds the next occurance of Find in V, -1 if it was not found.     }
{     Searches from item [PrevPos + 1], ie PrevPos = -1 to find first          }
{     occurance.                                                               }
{                                                                              }
Function PosNext (const Find : Byte; const V : ByteArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : Byte;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : Word; const V : WordArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : Word;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : LongWord; const V : LongWordArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : LongWord;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : ShortInt; const V : ShortIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : ShortInt;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : SmallInt; const V : SmallIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : SmallInt;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : LongInt; const V : LongIntArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : LongInt;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : Int64; const V : Int64Array; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : Int64;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : Single; const V : SingleArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : Single;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if FloatEqual (D, Find) then
                begin
                  While (I > 0) and FloatEqual (V [I - 1], Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if FloatEqual (V [PrevPos + 1], Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if FloatEqual (V [I], Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : Double; const V : DoubleArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : Double;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if FloatEqual (D, Find) then
                begin
                  While (I > 0) and FloatEqual (V [I - 1], Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if FloatEqual (V [PrevPos + 1], Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if FloatEqual (V [I], Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : Extended; const V : ExtendedArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : Extended;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if FloatEqual (D, Find) then
                begin
                  While (I > 0) and FloatEqual (V [I - 1], Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if FloatEqual (V [PrevPos + 1], Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if FloatEqual (V [I], Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;

Function PosNext (const Find : String; const V : StringArray; const PrevPos : Integer; const IsSortedAscending : Boolean) : Integer;
var I, L, H : Integer;
    D       : String;
  Begin
    if IsSortedAscending then // binary search
      begin
        if Max (PrevPos + 1, 0) = 0 then // find first
          begin
            L := 0;
            H := Length (V) - 1;
            Repeat
              I := (L + H) div 2;
              D := V [I];
              if (D = Find) then
                begin
                  While (I > 0) and (V [I - 1] = Find) do
                    Dec (I);
                  Result := I;
                  exit;
                end else
              if D > Find then
                H := I - 1 else
                L := I + 1;
            Until L > H;
            Result := -1;
          end else // find next
          if PrevPos >= Length (V) - 1 then
            Result := -1 else
            if (V [PrevPos + 1] = Find) then
              Result := PrevPos + 1 else
              Result := -1;
      end else
      begin // linear search
        For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
          if (V [I] = Find) then
            begin
              Result := I;
              exit;
            end;
        Result := -1;
      end;
  End;


Function PosNext (const Find : TObject; const V : ObjectArray; const PrevPos : Integer) : Integer;
var I : Integer;
  Begin
    For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
      if V [I] = Find then
        begin
          Result := I;
          exit;
         end;
    Result := -1;
  End;

Function PosNext (const Find : Pointer; const V : PointerArray; const PrevPos : Integer) : Integer;
var I : Integer;
  Begin
    For I := Max (PrevPos + 1, 0) to Length (V) - 1 do
      if V [I] = Find then
        begin
          Result := I;
          exit;
         end;
    Result := -1;
  End;


{                                                                              }
{ Intersection                                                                 }
{   If both arrays are sorted ascending then time is o(n) instead of o(n^2).   }
{                                                                              }
Function Intersection (const V1, V2 : SingleArray; const IsSortedAscending : Boolean) : SingleArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if FloatEqual (V1 [I], V2 [J]) then
                  Append (Result, V1 [I]);
                While (J < LV) and (FloatEqual (V2 [J], V1 [I]) or (V2 [J] < V1 [I])) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : DoubleArray; const IsSortedAscending : Boolean) : DoubleArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if FloatEqual (V1 [I], V2 [J]) then
                  Append (Result, V1 [I]);
                While (J < LV) and (FloatEqual (V2 [J], V1 [I]) or (V2 [J] < V1 [I])) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : ExtendedArray; const IsSortedAscending : Boolean) : ExtendedArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if FloatEqual (V1 [I], V2 [J]) then
                  Append (Result, V1 [I]);
                While (J < LV) and (FloatEqual (V2 [J], V1 [I]) or (V2 [J] < V1 [I])) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : ByteArray; const IsSortedAscending : Boolean) : ByteArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : WordArray; const IsSortedAscending : Boolean) : WordArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : LongWordArray; const IsSortedAscending : Boolean) : LongWordArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : ShortIntArray; const IsSortedAscending : Boolean) : ShortIntArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : SmallIntArray; const IsSortedAscending : Boolean) : SmallIntArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : LongIntArray; const IsSortedAscending : Boolean) : LongIntArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : Int64Array; const IsSortedAscending : Boolean) : Int64Array;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;

Function Intersection (const V1, V2 : StringArray; const IsSortedAscending : Boolean) : StringArray;
var I, J, L, LV : Integer;
  Begin
    SetLength (Result, 0);
    if IsSortedAscending then
      begin
        I := 0;
        J := 0;
        L := Length (V1);
        LV := Length (V2);
        While (I < L) and (J < LV) do
          begin
            While (I < L) and (V1 [I] < V2 [J]) do
              Inc (I);
            if I < L then
              begin
                if V1 [I] = V2 [J] then
                  Append (Result, V1 [I]);
                While (J < LV) and (V2 [J] <= V1 [I]) do
                  Inc (J);
              end;
          end;
      end else
      For I := 0 to Length (V1) - 1 do
        if (PosNext (V1 [I], V2) >= 0) and (PosNext (V1 [I], Result) = -1) then
          Append (Result, V1 [I]);
  End;



{                                                                              }
{ Reverse                                                                      }
{                                                                              }
Procedure Reverse (var V : ByteArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : WordArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : LongWordArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : ShortIntArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : SmallIntArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : LongIntArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : Int64Array);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : StringArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : PointerArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : ObjectArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : SingleArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : DoubleArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;

Procedure Reverse (var V : ExtendedArray);
var I, L : Integer;
  Begin
    L := Length (V);
    For I := 1 to L div 2 do
      Swap (V [I - 1], V [L - I]);
  End;



{                                                                              }
{ Returns an open array (V) as a dynamic array.                                }
{                                                                              }
Function AsByteArray (const V : Array of Byte) : ByteArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsWordArray (const V : Array of Word) : WordArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsLongWordArray (const V : Array of LongWord) : LongWordArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsCardinalArray (const V : Array of Cardinal) : CardinalArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsShortIntArray (const V : Array of ShortInt) : ShortIntArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsSmallIntArray (const V : Array of SmallInt) : SmallIntArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsLongIntArray (const V : Array of LongInt) : LongIntArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsIntegerArray (const V : Array of Integer) : IntegerArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsInt64Array (const V : Array of Int64) : Int64Array;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsSingleArray (const V : Array of Single) : SingleArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsDoubleArray (const V : Array of Double) : DoubleArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsExtendedArray (const V : Array of Extended) : ExtendedArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsStringArray (const V : Array of String) : StringArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsPointerArray (const V : Array of Pointer) : PointerArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsCharSetArray (const V : Array of CharSet) : CharSetArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;

Function AsObjectArray (const V : Array of TObject) : ObjectArray;
var I : Integer;
  Begin
    SetLength (Result, High (V) + 1);
    For I := 0 to High (V) do
     Result [I] := V [I];
  End;



Function RangeByte (const First : Byte; const Count : Integer; const Increment : Byte) : ByteArray;
var I : Integer;
    J : Byte;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeWord (const First : Word; const Count : Integer; const Increment : Word) : WordArray;
var I : Integer;
    J : Word;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeLongWord (const First : LongWord; const Count : Integer; const Increment : LongWord) : LongWordArray;
var I : Integer;
    J : LongWord;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeCardinal (const First : Cardinal; const Count : Integer; const Increment : Cardinal) : CardinalArray;
var I : Integer;
    J : Cardinal;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeShortInt (const First : ShortInt; const Count : Integer; const Increment : ShortInt) : ShortIntArray;
var I : Integer;
    J : ShortInt;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeSmallInt (const First : SmallInt; const Count : Integer; const Increment : SmallInt) : SmallIntArray;
var I : Integer;
    J : SmallInt;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeLongInt (const First : LongInt; const Count : Integer; const Increment : LongInt) : LongIntArray;
var I : Integer;
    J : LongInt;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeInteger (const First : Integer; const Count : Integer; const Increment : Integer) : IntegerArray;
var I : Integer;
    J : Integer;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeInt64 (const First : Int64; const Count : Integer; const Increment : Int64) : Int64Array;
var I : Integer;
    J : Int64;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeSingle (const First : Single; const Count : Integer; const Increment : Single) : SingleArray;
var I : Integer;
    J : Single;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeDouble (const First : Double; const Count : Integer; const Increment : Double) : DoubleArray;
var I : Integer;
    J : Double;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;

Function RangeExtended (const First : Extended; const Count : Integer; const Increment : Extended) : ExtendedArray;
var I : Integer;
    J : Extended;
  Begin
    SetLength (Result, Count);
    J := First;
    For I := 0 to Count - 1 do
      begin
        Result [I] := J;
        J := J + Increment;
      end;
  End;



{                                                                              }
{ Dup                                                                          }
{                                                                              }
Function DupByte (const V : Byte; const Count : Integer) : ByteArray;
  Begin
    SetLength (Result, Count);
    FillChar (Result [0], Count, V);
  End;

Function DupWord (const V : Word; const Count : Integer) : WordArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupLongWord (const V : LongWord; const Count : Integer) : LongWordArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupCardinal (const V : Cardinal; const Count : Integer) : CardinalArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupShortInt (const V : ShortInt; const Count : Integer) : ShortIntArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupSmallInt (const V : SmallInt; const Count : Integer) : SmallIntArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupLongInt (const V : LongInt; const Count : Integer) : LongIntArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupInteger (const V : Integer; const Count : Integer) : IntegerArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupInt64 (const V : Int64; const Count : Integer) : Int64Array;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupSingle (const V : Single; const Count : Integer) : SingleArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupDouble (const V : Double; const Count : Integer) : DoubleArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupExtended (const V : Extended; const Count : Integer) : ExtendedArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupString (const V : String; const Count : Integer) : StringArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;

Function DupCharSet (const V : CharSet; const Count : Integer) : CharSetArray;
var I : Integer;
  Begin
    SetLength (Result, Count);
    For I := 0 to Count - 1 do
      Result [I] := V;
  End;



{                                                                              }
{ IsEqual                                                                      }
{                                                                              }
Function IsEqual (const V1, V2 : ByteArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (Byte) * L);
  End;

Function IsEqual (const V1, V2 : WordArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (Word) * L);
  End;

Function IsEqual (const V1, V2 : LongWordArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (LongWord) * L);
  End;

Function IsEqual (const V1, V2 : ShortIntArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (ShortInt) * L);
  End;

Function IsEqual (const V1, V2 : SmallIntArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (SmallInt) * L);
  End;

Function IsEqual (const V1, V2 : LongIntArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (LongInt) * L);
  End;

Function IsEqual (const V1, V2 : Int64Array) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (Int64) * L);
  End;

Function IsEqual (const V1, V2 : SingleArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (Single) * L);
  End;

Function IsEqual (const V1, V2 : DoubleArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (Double) * L);
  End;

Function IsEqual (const V1, V2 : ExtendedArray) : Boolean;
var L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    Result := CompareMem (V1, V2, Sizeof (Extended) * L);
  End;

Function IsEqual (const V1, V2 : StringArray) : Boolean;
var I, L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    For I := 0 to L - 1 do
      if V1 [I] <> V2 [I] then
        begin
          Result := False;
          exit;
        end;
    Result := True;
  End;

Function IsEqual (const V1, V2 : CharSetArray) : Boolean;
var I, L : Integer;
  Begin
    L := Length (V1);
    if L <> Length (V2) then
      begin
        Result := False;
        exit;
      end;
    For I := 0 to L - 1 do
      if V1 [I] <> V2 [I] then
        begin
          Result := False;
          exit;
        end;
    Result := True;
  End;



{                                                                              }
{ Dynamic array to Dynamic array                                               }
{                                                                              }
Function ByteArrayToLongIntArray (const V : ByteArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function WordArrayToLongIntArray (const V : WordArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function ShortIntArrayToLongIntArray (const V : ShortIntArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function SmallIntArrayToLongIntArray (const V : SmallIntArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function LongIntArrayToInt64Array (const V : LongIntArray) : Int64Array;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function LongIntArrayToSingleArray (const V : LongIntArray) : SingleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function LongIntArrayToDoubleArray (const V : LongIntArray) : DoubleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function LongIntArrayToExtendedArray (const V : LongIntArray) : ExtendedArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function LongIntArrayToStringArray (const V : LongIntArray) : StringArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := IntToStr (V [I]);
  End;

Function SingleArrayToExtendedArray (const V : SingleArray) : ExtendedArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function SingleArrayToDoubleArray (const V : SingleArray) : DoubleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function SingleArrayToLongIntArray (const V : SingleArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := Trunc (V [I]);
  End;

Function SingleArrayToInt64Array (const V : SingleArray) : Int64Array;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := Trunc (V [I]);
  End;

Function SingleArrayToStringArray (const V : SingleArray) : StringArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := FloatToStr (V [I]);
  End;

Function DoubleArrayToSingleArray (const V : DoubleArray) : SingleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function DoubleArrayToExtendedArray (const V : DoubleArray) : ExtendedArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function DoubleArrayToLongIntArray (const V : DoubleArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := Trunc (V [I]);
  End;

Function DoubleArrayToInt64Array (const V : DoubleArray) : Int64Array;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := Trunc (V [I]);
  End;

Function DoubleArrayToStringArray (const V : DoubleArray) : StringArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := FloatToStr (V [I]);
  End;

Function ExtendedArrayToSingleArray (const V : ExtendedArray) : SingleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function ExtendedArrayToDoubleArray (const V : ExtendedArray) : DoubleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Function ExtendedArrayToLongIntArray (const V : ExtendedArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := Trunc (V [I]);
  End;

Function ExtendedArrayToInt64Array (const V : ExtendedArray) : Int64Array;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := Trunc (V [I]);
  End;

Function ExtendedArrayToStringArray (const V : ExtendedArray) : StringArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := FloatToStr (V [I]);
  End;

Function StringArrayToLongIntArray (const V : StringArray) : LongIntArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := StrToInt (V [I]);
  End;

Function StringArrayToInt64Array (const V : StringArray) : Int64Array;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := StrToInt64 (V [I]);
  End;

Function StringArrayToSingleArray (const V : StringArray) : SingleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := StrToFloat (V [I]);
  End;

Function StringArrayToDoubleArray (const V : StringArray) : DoubleArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := StrToFloat (V [I]);
  End;

Function StringArrayToExtendedArray (const V : StringArray) : ExtendedArray;
var I, L : Integer;
  Begin
    L := Length (V);
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := StrToFloat (V [I]);
  End;


Procedure StringArrayToTStrings (const S : StringArray; const D : TStrings);
var I : Integer;
  Begin
    D.Clear;
    For I := 0 to Length (S) - 1 do
      D.Add (S [I]);
  End;

Function TStringsToStringArray (const V : TStrings) : StringArray;
var I, L : Integer;
  Begin
    L := V.Count;
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

Procedure PointerArrayToTList (const S : PointerArray; const D : TList);
var I : Integer;
  Begin
    D.Clear;
    For I := 0 to Length (S) - 1 do
      D.Add (S [I]);
  End;

Function TListToPointerArray (const V : TList) : PointerArray;
var I, L : Integer;
  Begin
    L := V.Count;
    SetLength (Result, L);
    For I := 0 to L - 1 do
      Result [I] := V [I];
  End;

{                                                                              }
{ Dynamic array to String                                                      }
{                                                                              }
Function ByteArrayToStr (const V : ByteArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function WordArrayToStr (const V : WordArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function LongWordArrayToStr (const V : LongWordArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function CardinalArrayToStr (const V : CardinalArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function ShortIntArrayToStr (const V : ShortIntArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function SmallIntArrayToStr (const V : SmallIntArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function LongIntArrayToStr (const V : LongIntArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function IntegerArrayToStr (const V : IntegerArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function Int64ArrayToStr (const V : Int64Array) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + IntToStr (V [I]);
  End;

Function SingleArrayToStr (const V : SingleArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + FloatToStr (V [I]);
  End;

Function DoubleArrayToStr (const V : DoubleArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + FloatToStr (V [I]);
  End;

Function ExtendedArrayToStr (const V : ExtendedArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + FloatToStr (V [I]);
  End;

Function StringArrayToStr (const V : StringArray) : String;
var I : Integer;
  Begin
    Result := '';
    For I := 0 to Length (V) - 1 do
      Result := Result + Cond (I > 0, ',', '') + QuoteText (V [I]);
  End;


{                                                                              }
{ String to Dynamic array                                                      }
{                                                                              }
Function StrToByteArray (const S : String; const Delimiter : Char) : ByteArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToWordArray (const S : String; const Delimiter : Char) : WordArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToLongWordArray (const S : String; const Delimiter : Char) : LongWordArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToCardinalArray (const S : String; const Delimiter : Char) : CardinalArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToShortIntArray (const S : String; const Delimiter : Char) : ShortIntArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToSmallIntArray (const S : String; const Delimiter : Char) : SmallIntArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToLongIntArray (const S : String; const Delimiter : Char) : LongIntArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToIntegerArray (const S : String; const Delimiter : Char) : IntegerArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToInt64Array (const S : String; const Delimiter : Char) : Int64Array;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0 else
          Result [L - 1] := StrToInt64 (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToSingleArray (const S : String; const Delimiter : Char) : SingleArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0.0 else
          Result [L - 1] := StrToFloat (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToDoubleArray (const S : String; const Delimiter : Char) : DoubleArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0.0 else
          Result [L - 1] := StrToFloat (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToExtendedArray (const S : String; const Delimiter : Char) : ExtendedArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := 0.0 else
          Result [L - 1] := StrToFloat (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;

Function StrToStringArray (const S : String; const Delimiter : Char) : StringArray;
var F, G, L, C : Integer;
  Begin
    L := 0;
    F := 1;
    C := Length (S);
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> Delimiter) do
          Inc (G);
        Inc (L);
        SetLength (Result, L);
        if G = 0 then
          Result [L - 1] := '' else
          Result [L - 1] := UnquoteText (Copy (S, F, G));
        Inc (F, G + 1);
      end;
  End;



{                                                                              }
{ Dynamic array Sort                                                           }
{                                                                              }
Procedure Sort (var V : ByteArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : WordArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : LongWordArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : ShortIntArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : SmallIntArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : LongIntArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : Int64Array);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : SingleArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : DoubleArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : ExtendedArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;

Procedure Sort (var V : StringArray);

  Procedure QuickSort (L, R : Integer);
  var I, J, M : Integer;
    Begin
      Repeat
        I := L;
        J := R;
        M := (L + R) shr 1;
        Repeat
          While V [I] < V [M] do
            Inc (I);
          While V [J] > V [M] do
            Dec (J);
          if I <= J then
            begin
              Swap (V [I], V [J]);
              Inc (I);
              Dec (J);
            end;
        Until I > J;
        if L < J then
          QuickSort (L, J);
        L := I;
      Until I >= R;
    End;

var I : Integer;
  Begin
    I := Length (V);
    if I > 0 then
      QuickSort (0, I - 1);
  End;



{                                                                              }
{ Linked lists                                                                 }
{                                                                              }
Function LinkedItem.HasNext : Boolean;
  Begin
    Result := Assigned (Next);
  End;

Function LinkedItem.Last : PLinkedItem;
  Begin
    Result := @self;
    While Assigned (Result.Next) do
      Result := Result.Next;
  End;

Function LinkedItem.Count : Integer;
var P : PLinkedItem;
  Begin
    P := @self;
    Result := 1;
    While Assigned (P.Next) do
      begin
        Inc (Result);
        P := P.Next;
      end;
  End;

Procedure LinkedItem.RemoveNext;
  Begin
    if Assigned (Next) then
      Next := Next.Next;
  End;

Procedure LinkedItem.InsertAfter (const Item : PLinkedItem);
  Begin
    Item.Next := Next;
    Next := Item;
  End;

Function DoublyLinkedItem.HasPrev : Boolean;
  Begin
    Result := Assigned (Prev);
  End;

Function DoublyLinkedItem.First : PDoublyLinkedItem;
  Begin
    Result := @self;
    While Assigned (Result.Prev) do
      Result := Result.Prev;
  End;

Procedure DoublyLinkedItem.Remove;
  Begin
    if Assigned (Next) then
      PDoublyLinkedItem (Next).Prev := Prev;
    if Assigned (Prev) then
      Prev.Next := Next;
  End;

Procedure DoublyLinkedItem.RemoveNext;
  Begin
    if Assigned (Next) then
      PDoublyLinkedItem (Next).Remove;
  End;

Procedure DoublyLinkedItem.RemovePrev;
  Begin
    if Assigned (Prev) then
      Prev.Remove;
  End;

Procedure DoublyLinkedItem.InsertAfter (const Item : PDoublyLinkedItem);
  Begin
    Item.Next := Next;
    Item.Prev := @self;
    Next := Item;
  End;

Procedure DoublyLinkedItem.InsertBefore (const Item : PDoublyLinkedItem);
  Begin
    Item.Next := @self;
    Item.Prev := Prev;
    Prev := Item;
  End;



{                                                                              }
{ LinkedInteger / DoublyLinkedInteger                                          }
{                                                                              }
Procedure LinkedInteger.InsertAfter (const V : Integer);
var R : PLinkedInteger;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure LinkedInteger.Append (const V : Integer);
  Begin
    PLinkedInteger (Last).InsertAfter (V);
  End;

Function LinkedInteger.FindNext (const Find : Integer) : PLinkedInteger;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PLinkedInteger (Result.Next);
    Until not Assigned (Result);
  End;

Procedure DoublyLinkedInteger.InsertAfter (const V : Integer);
var R : PDoublyLinkedInteger;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure DoublyLinkedInteger.InsertBefore (const V : Integer);
var R : PDoublyLinkedInteger;
  Begin
    New (R);
    R.Value := V;
    inherited InsertBefore (R);
  End;

Procedure DoublyLinkedInteger.InsertFirst (const V : Integer);
  Begin
    PDoublyLinkedInteger (First).InsertBefore (V);
  End;

Procedure DoublyLinkedInteger.Append (const V : Integer);
  Begin
    PDoublyLinkedInteger (Last).InsertAfter (V);
  End;

Function DoublyLinkedInteger.FindNext (const Find : Integer) : PDoublyLinkedInteger;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedInteger (Result.Next);
    Until not Assigned (Result);
  End;

Function DoublyLinkedInteger.FindPrev (const Find : Integer) : PDoublyLinkedInteger;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedInteger (Result.Prev);
    Until not Assigned (Result);
  End;

{                                                                              }
{ LinkedInt64 / DoublyLinkedInt64                                              }
{                                                                              }
Procedure LinkedInt64.InsertAfter (const V : Int64);
var R : PLinkedInt64;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure LinkedInt64.Append (const V : Int64);
  Begin
    PLinkedInt64 (Last).InsertAfter (V);
  End;

Function LinkedInt64.FindNext (const Find : Int64) : PLinkedInt64;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PLinkedInt64 (Result.Next);
    Until not Assigned (Result);
  End;

Procedure DoublyLinkedInt64.InsertAfter (const V : Int64);
var R : PDoublyLinkedInt64;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure DoublyLinkedInt64.InsertBefore (const V : Int64);
var R : PDoublyLinkedInt64;
  Begin
    New (R);
    R.Value := V;
    inherited InsertBefore (R);
  End;

Procedure DoublyLinkedInt64.InsertFirst (const V : Int64);
  Begin
    PDoublyLinkedInt64 (First).InsertBefore (V);
  End;

Procedure DoublyLinkedInt64.Append (const V : Int64);
  Begin
    PDoublyLinkedInt64 (Last).InsertAfter (V);
  End;

Function DoublyLinkedInt64.FindNext (const Find : Int64) : PDoublyLinkedInt64;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedInt64 (Result.Next);
    Until not Assigned (Result);
  End;

Function DoublyLinkedInt64.FindPrev (const Find : Int64) : PDoublyLinkedInt64;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedInt64 (Result.Prev);
    Until not Assigned (Result);
  End;

{                                                                              }
{ LinkedSingle / DoublyLinkedSingle                                            }
{                                                                              }
Procedure LinkedSingle.InsertAfter (const V : Single);
var R : PLinkedSingle;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure LinkedSingle.Append (const V : Single);
  Begin
    PLinkedSingle (Last).InsertAfter (V);
  End;

Function LinkedSingle.FindNext (const Find : Single) : PLinkedSingle;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PLinkedSingle (Result.Next);
    Until not Assigned (Result);
  End;

Procedure DoublyLinkedSingle.InsertAfter (const V : Single);
var R : PDoublyLinkedSingle;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure DoublyLinkedSingle.InsertBefore (const V : Single);
var R : PDoublyLinkedSingle;
  Begin
    New (R);
    R.Value := V;
    inherited InsertBefore (R);
  End;

Procedure DoublyLinkedSingle.InsertFirst (const V : Single);
  Begin
    PDoublyLinkedSingle (First).InsertBefore (V);
  End;

Procedure DoublyLinkedSingle.Append (const V : Single);
  Begin
    PDoublyLinkedSingle (Last).InsertAfter (V);
  End;

Function DoublyLinkedSingle.FindNext (const Find : Single) : PDoublyLinkedSingle;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedSingle (Result.Next);
    Until not Assigned (Result);
  End;

Function DoublyLinkedSingle.FindPrev (const Find : Single) : PDoublyLinkedSingle;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedSingle (Result.Prev);
    Until not Assigned (Result);
  End;

{                                                                              }
{ LinkedDouble / DoublyLinkedDouble                                            }
{                                                                              }
Procedure LinkedDouble.InsertAfter (const V : Double);
var R : PLinkedDouble;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure LinkedDouble.Append (const V : Double);
  Begin
    PLinkedDouble (Last).InsertAfter (V);
  End;

Function LinkedDouble.FindNext (const Find : Double) : PLinkedDouble;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PLinkedDouble (Result.Next);
    Until not Assigned (Result);
  End;

Procedure DoublyLinkedDouble.InsertAfter (const V : Double);
var R : PDoublyLinkedDouble;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure DoublyLinkedDouble.InsertBefore (const V : Double);
var R : PDoublyLinkedDouble;
  Begin
    New (R);
    R.Value := V;
    inherited InsertBefore (R);
  End;

Procedure DoublyLinkedDouble.InsertFirst (const V : Double);
  Begin
    PDoublyLinkedDouble (First).InsertBefore (V);
  End;

Procedure DoublyLinkedDouble.Append (const V : Double);
  Begin
    PDoublyLinkedDouble (Last).InsertAfter (V);
  End;

Function DoublyLinkedDouble.FindNext (const Find : Double) : PDoublyLinkedDouble;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedDouble (Result.Next);
    Until not Assigned (Result);
  End;

Function DoublyLinkedDouble.FindPrev (const Find : Double) : PDoublyLinkedDouble;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedDouble (Result.Prev);
    Until not Assigned (Result);
  End;

{                                                                              }
{ LinkedExtended / DoublyLinkedExtended                                        }
{                                                                              }
Procedure LinkedExtended.InsertAfter (const V : Extended);
var R : PLinkedExtended;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure LinkedExtended.Append (const V : Extended);
  Begin
    PLinkedExtended (Last).InsertAfter (V);
  End;

Function LinkedExtended.FindNext (const Find : Extended) : PLinkedExtended;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PLinkedExtended (Result.Next);
    Until not Assigned (Result);
  End;

Procedure DoublyLinkedExtended.InsertAfter (const V : Extended);
var R : PDoublyLinkedExtended;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure DoublyLinkedExtended.InsertBefore (const V : Extended);
var R : PDoublyLinkedExtended;
  Begin
    New (R);
    R.Value := V;
    inherited InsertBefore (R);
  End;

Procedure DoublyLinkedExtended.InsertFirst (const V : Extended);
  Begin
    PDoublyLinkedExtended (First).InsertBefore (V);
  End;

Procedure DoublyLinkedExtended.Append (const V : Extended);
  Begin
    PDoublyLinkedExtended (Last).InsertAfter (V);
  End;

Function DoublyLinkedExtended.FindNext (const Find : Extended) : PDoublyLinkedExtended;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedExtended (Result.Next);
    Until not Assigned (Result);
  End;

Function DoublyLinkedExtended.FindPrev (const Find : Extended) : PDoublyLinkedExtended;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedExtended (Result.Prev);
    Until not Assigned (Result);
  End;

{                                                                              }
{ LinkedString / DoublyLinkedString                                            }
{                                                                              }
Procedure LinkedString.InsertAfter (const V : String);
var R : PLinkedString;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure LinkedString.Append (const V : String);
  Begin
    PLinkedString (Last).InsertAfter (V);
  End;

Function LinkedString.FindNext (const Find : String) : PLinkedString;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PLinkedString (Result.Next);
    Until not Assigned (Result);
  End;

Procedure DoublyLinkedString.InsertAfter (const V : String);
var R : PDoublyLinkedString;
  Begin
    New (R);
    R.Value := V;
    inherited InsertAfter (R);
  End;

Procedure DoublyLinkedString.InsertBefore (const V : String);
var R : PDoublyLinkedString;
  Begin
    New (R);
    R.Value := V;
    inherited InsertBefore (R);
  End;

Procedure DoublyLinkedString.InsertFirst (const V : String);
  Begin
    PDoublyLinkedString (First).InsertBefore (V);
  End;

Procedure DoublyLinkedString.Append (const V : String);
  Begin
    PDoublyLinkedString (Last).InsertAfter (V);
  End;

Function DoublyLinkedString.FindNext (const Find : String) : PDoublyLinkedString;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedString (Result.Next);
    Until not Assigned (Result);
  End;

Function DoublyLinkedString.FindPrev (const Find : String) : PDoublyLinkedString;
  Begin
    Result := @self;
    Repeat
      if Result.Value = Find then
        exit;
      Result := PDoublyLinkedString (Result.Prev);
    Until not Assigned (Result);
  End;



{                                                                              }
{ Create linked list item                                                      }
{                                                                              }
Function CreateLinkedInteger (const V : Integer) : PLinkedInteger;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateLinkedInt64 (const V : Int64) : PLinkedInt64;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateLinkedSingle (const V : Single) : PLinkedSingle;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateLinkedDouble (const V : Double) : PLinkedDouble;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateLinkedExtended (const V : Extended) : PLinkedExtended;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateLinkedString (const V : String) : PLinkedString;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateDoublyLinkedInteger (const V : Integer) : PDoublyLinkedInteger;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateDoublyLinkedInt64 (const V : Int64) : PDoublyLinkedInt64;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateDoublyLinkedSingle (const V : Single) : PDoublyLinkedSingle;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateDoublyLinkedDouble (const V : Double) : PDoublyLinkedDouble;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateDoublyLinkedExtended (const V : Extended) : PDoublyLinkedExtended;
  Begin
    New (Result);
    Result.Value := V;
  End;

Function CreateDoublyLinkedString (const V : String) : PDoublyLinkedString;
  Begin
    New (Result);
    Result.Value := V;
  End;



{                                                                              }
{ Free a linked list                                                           }
{                                                                              }
{
Procedure FreeLinkedList (const V : PLinkedInteger);
var I, N : PLinkedInteger;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PLinkedInteger (I.Next);
        Release(I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PLinkedInt64);
var I, N : PLinkedInt64;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PLinkedInt64 (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PLinkedSingle);
var I, N : PLinkedSingle;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PLinkedSingle (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PLinkedDouble);
var I, N : PLinkedDouble;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PLinkedDouble (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PLinkedExtended);
var I, N : PLinkedExtended;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PLinkedExtended (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PLinkedString);
var I, N : PLinkedString;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PLinkedString (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PDoublyLinkedInteger);
var I, N : PDoublyLinkedInteger;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PDoublyLinkedInteger (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PDoublyLinkedInt64);
var I, N : PDoublyLinkedInt64;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PDoublyLinkedInt64 (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PDoublyLinkedSingle);
var I, N : PDoublyLinkedSingle;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PDoublyLinkedSingle (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PDoublyLinkedDouble);
var I, N : PDoublyLinkedDouble;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PDoublyLinkedDouble (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PDoublyLinkedExtended);
var I, N : PDoublyLinkedExtended;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PDoublyLinkedExtended (I.Next);
        Release (I);
        I := N;
      end;
  End;

Procedure FreeLinkedList (const V : PDoublyLinkedString);
var I, N : PDoublyLinkedString;
  Begin
    I := V;
    While Assigned (I) do
      begin
        N := PDoublyLinkedString (I.Next);
        Release (I);
        I := N;
      end;
  End;
}


{                                                                              }
{ Linked list to String                                                        }
{                                                                              }
Function LinkedIntegerListToStr (const V : PLinkedInteger) : String;
var I : PLinkedInteger;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + IntToStr (I.Value);
        I := PLinkedInteger (I.Next);
      end;
  End;

Function LinkedInt64ListToStr (const V : PLinkedInt64) : String;
var I : PLinkedInt64;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + IntToStr (I.Value);
        I := PLinkedInt64 (I.Next);
      end;
  End;

Function LinkedSingleListToStr (const V : PLinkedSingle) : String;
var I : PLinkedSingle;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + FloatToStr (I.Value);
        I := PLinkedSingle (I.Next);
      end;
  End;

Function LinkedDoubleListToStr (const V : PLinkedDouble) : String;
var I : PLinkedDouble;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + FloatToStr (I.Value);
        I := PLinkedDouble (I.Next);
      end;
  End;

Function LinkedExtendedListToStr (const V : PLinkedExtended) : String;
var I : PLinkedExtended;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + FloatToStr (I.Value);
        I := PLinkedExtended (I.Next);
      end;
  End;

Function LinkedStringListToStr (const V : PLinkedString) : String;
var I : PLinkedString;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + QuoteText (I.Value);
        I := PLinkedString (I.Next);
      end;
  End;

Function DoublyLinkedIntegerListToStr (const V : PDoublyLinkedInteger) : String;
var I : PDoublyLinkedInteger;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + IntToStr (I.Value);
        I := PDoublyLinkedInteger (I.Next);
      end;
  End;

Function DoublyLinkedInt64ListToStr (const V : PDoublyLinkedInt64) : String;
var I : PDoublyLinkedInt64;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + IntToStr (I.Value);
        I := PDoublyLinkedInt64 (I.Next);
      end;
  End;

Function DoublyLinkedSingleListToStr (const V : PDoublyLinkedSingle) : String;
var I : PDoublyLinkedSingle;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + FloatToStr (I.Value);
        I := PDoublyLinkedSingle (I.Next);
      end;
  End;

Function DoublyLinkedDoubleListToStr (const V : PDoublyLinkedDouble) : String;
var I : PDoublyLinkedDouble;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + FloatToStr (I.Value);
        I := PDoublyLinkedDouble (I.Next);
      end;
  End;

Function DoublyLinkedExtendedListToStr (const V : PDoublyLinkedExtended) : String;
var I : PDoublyLinkedExtended;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + FloatToStr (I.Value);
        I := PDoublyLinkedExtended (I.Next);
      end;
  End;

Function DoublyLinkedStringListToStr (const V : PDoublyLinkedString) : String;
var I : PDoublyLinkedString;
  Begin
    Result := '';
    I := V;
    While Assigned (I) do
      begin
        Result := Result + Cond (Result <> '', ',', '') + QuoteText (I.Value);
        I := PDoublyLinkedString (I.Next);
      end;
  End;



{                                                                              }
{ String to Linked list                                                        }
{                                                                              }
Function StrToLinkedIntegerList (const S : String) : PLinkedInteger;
var F, G, C : Integer;
    I, L    : PLinkedInteger;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateLinkedInteger (StrToInt (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToLinkedInt64List (const S : String) : PLinkedInt64;
var F, G, C : Integer;
    I, L    : PLinkedInt64;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateLinkedInt64 (StrToInt64 (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToLinkedSingleList (const S : String) : PLinkedSingle;
var F, G, C : Integer;
    I, L    : PLinkedSingle;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateLinkedSingle (StrToFloat (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToLinkedDoubleList (const S : String) : PLinkedDouble;
var F, G, C : Integer;
    I, L    : PLinkedDouble;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateLinkedDouble (StrToFloat (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToLinkedExtendedList (const S : String) : PLinkedExtended;
var F, G, C : Integer;
    I, L    : PLinkedExtended;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateLinkedExtended (StrToFloat (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToLinkedStringList (const S : String) : PLinkedString;
var F, G, C : Integer;
    I, L    : PLinkedString;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateLinkedString (UnquoteText (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToDoublyLinkedIntegerList (const S : String) : PDoublyLinkedInteger;
var F, G, C : Integer;
    I, L    : PDoublyLinkedInteger;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateDoublyLinkedInteger (StrToInt (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToDoublyLinkedInt64List (const S : String) : PDoublyLinkedInt64;
var F, G, C : Integer;
    I, L    : PDoublyLinkedInt64;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateDoublyLinkedInt64 (StrToInt64 (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToDoublyLinkedSingleList (const S : String) : PDoublyLinkedSingle;
var F, G, C : Integer;
    I, L    : PDoublyLinkedSingle;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateDoublyLinkedSingle (StrToFloat (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToDoublyLinkedDoubleList (const S : String) : PDoublyLinkedDouble;
var F, G, C : Integer;
    I, L    : PDoublyLinkedDouble;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateDoublyLinkedDouble (StrToFloat (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToDoublyLinkedExtendedList (const S : String) : PDoublyLinkedExtended;
var F, G, C : Integer;
    I, L    : PDoublyLinkedExtended;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateDoublyLinkedExtended (StrToFloat (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;

Function StrToDoublyLinkedStringList (const S : String) : PDoublyLinkedString;
var F, G, C : Integer;
    I, L    : PDoublyLinkedString;
  Begin
    F := 1;
    C := Length (S);
    Result := nil;
    While F <= C do
      begin
        G := 0;
        While (F + G <= C) and (S [F + G] <> ',') do
          Inc (G);
        I := CreateDoublyLinkedString (UnquoteText (Copy (S, F, G)));
        if not Assigned (Result) then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
        Inc (F, G + 1);
      end;
  End;



{                                                                              }
{ Dynamic array to Linked list                                                 }
{                                                                              }
Function IntegerArrayToLinkedIntegerList (const V : IntegerArray) : PLinkedInteger;
var I, L : PLinkedInteger;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateLinkedInteger (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function Int64ArrayToLinkedInt64List (const V : Int64Array) : PLinkedInt64;
var I, L : PLinkedInt64;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateLinkedInt64 (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function SingleArrayToLinkedSingleList (const V : SingleArray) : PLinkedSingle;
var I, L : PLinkedSingle;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateLinkedSingle (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function DoubleArrayToLinkedDoubleList (const V : DoubleArray) : PLinkedDouble;
var I, L : PLinkedDouble;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateLinkedDouble (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function ExtendedArrayToLinkedExtendedList (const V : ExtendedArray) : PLinkedExtended;
var I, L : PLinkedExtended;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateLinkedExtended (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function StringArrayToLinkedStringList (const V : StringArray) : PLinkedString;
var I, L : PLinkedString;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateLinkedString (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function IntegerArrayToDoublyLinkedIntegerList (const V : IntegerArray) : PDoublyLinkedInteger;
var I, L : PDoublyLinkedInteger;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateDoublyLinkedInteger (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function Int64ArrayToDoublyLinkedInt64List (const V : Int64Array) : PDoublyLinkedInt64;
var I, L : PDoublyLinkedInt64;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateDoublyLinkedInt64 (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function SingleArrayToDoublyLinkedSingleList (const V : SingleArray) : PDoublyLinkedSingle;
var I, L : PDoublyLinkedSingle;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateDoublyLinkedSingle (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function DoubleArrayToDoublyLinkedDoubleList (const V : DoubleArray) : PDoublyLinkedDouble;
var I, L : PDoublyLinkedDouble;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateDoublyLinkedDouble (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function ExtendedArrayToDoublyLinkedExtendedList (const V : ExtendedArray) : PDoublyLinkedExtended;
var I, L : PDoublyLinkedExtended;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateDoublyLinkedExtended (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function StringArrayToDoublyLinkedStringList (const V : StringArray) : PDoublyLinkedString;
var I, L : PDoublyLinkedString;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to Length (V) - 1 do
      begin
        I := CreateDoublyLinkedString (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;



{                                                                              }
{ Linked list to Dynamic array                                                 }
{                                                                              }
Function LinkedIntegerListToIntegerArray (const V : PLinkedInteger) : IntegerArray;
var I : PLinkedInteger;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PLinkedInteger (I.Next);
      end;
  End;

Function LinkedInt64ListToInt64Array (const V : PLinkedInt64) : Int64Array;
var I : PLinkedInt64;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PLinkedInt64 (I.Next);
      end;
  End;

Function LinkedSingleListToSingleArray (const V : PLinkedSingle) : SingleArray;
var I : PLinkedSingle;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PLinkedSingle (I.Next);
      end;
  End;

Function LinkedDoubleListToDoubleArray (const V : PLinkedDouble) : DoubleArray;
var I : PLinkedDouble;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PLinkedDouble (I.Next);
      end;
  End;

Function LinkedExtendedListToExtendedArray (const V : PLinkedExtended) : ExtendedArray;
var I : PLinkedExtended;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PLinkedExtended (I.Next);
      end;
  End;

Function LinkedStringListToStringArray (const V : PLinkedString) : StringArray;
var I : PLinkedString;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PLinkedString (I.Next);
      end;
  End;

Function DoublyLinkedIntegerListToIntegerArray (const V : PDoublyLinkedInteger) : IntegerArray;
var I : PDoublyLinkedInteger;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PDoublyLinkedInteger (I.Next);
      end;
  End;

Function DoublyLinkedInt64ListToInt64Array (const V : PDoublyLinkedInt64) : Int64Array;
var I : PDoublyLinkedInt64;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PDoublyLinkedInt64 (I.Next);
      end;
  End;

Function DoublyLinkedSingleListToSingleArray (const V : PDoublyLinkedSingle) : SingleArray;
var I : PDoublyLinkedSingle;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PDoublyLinkedSingle (I.Next);
      end;
  End;

Function DoublyLinkedDoubleListToDoubleArray (const V : PDoublyLinkedDouble) : DoubleArray;
var I : PDoublyLinkedDouble;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PDoublyLinkedDouble (I.Next);
      end;
  End;

Function DoublyLinkedExtendedListToExtendedArray (const V : PDoublyLinkedExtended) : ExtendedArray;
var I : PDoublyLinkedExtended;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PDoublyLinkedExtended (I.Next);
      end;
  End;

Function DoublyLinkedStringListToStringArray (const V : PDoublyLinkedString) : StringArray;
var I : PDoublyLinkedString;
  Begin
    I := V;
    SetLength (Result, 0);
    While Assigned (I) do
      begin
        Append (Result, I.Value);
        I := PDoublyLinkedString (I.Next);
      end;
  End;



{                                                                              }
{ Open array to Linked list                                                    }
{                                                                              }
Function AsLinkedIntegerList (const V : Array of Integer) : PLinkedInteger;
var I, L : PLinkedInteger;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateLinkedInteger (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsLinkedInt64List (const V : Array of Int64) : PLinkedInt64;
var I, L : PLinkedInt64;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateLinkedInt64 (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsLinkedSingleList (const V : Array of Single) : PLinkedSingle;
var I, L : PLinkedSingle;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateLinkedSingle (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsLinkedDoubleList (const V : Array of Double) : PLinkedDouble;
var I, L : PLinkedDouble;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateLinkedDouble (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsLinkedExtendedList (const V : Array of Extended) : PLinkedExtended;
var I, L : PLinkedExtended;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateLinkedExtended (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsLinkedStringList (const V : Array of String) : PLinkedString;
var I, L : PLinkedString;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateLinkedString (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsDoublyLinkedIntegerList (const V : Array of Integer) : PDoublyLinkedInteger;
var I, L : PDoublyLinkedInteger;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateDoublyLinkedInteger (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsDoublyLinkedInt64List (const V : Array of Int64) : PDoublyLinkedInt64;
var I, L : PDoublyLinkedInt64;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateDoublyLinkedInt64 (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsDoublyLinkedSingleList (const V : Array of Single) : PDoublyLinkedSingle;
var I, L : PDoublyLinkedSingle;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateDoublyLinkedSingle (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsDoublyLinkedDoubleList (const V : Array of Double) : PDoublyLinkedDouble;
var I, L : PDoublyLinkedDouble;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateDoublyLinkedDouble (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsDoublyLinkedExtendedList (const V : Array of Extended) : PDoublyLinkedExtended;
var I, L : PDoublyLinkedExtended;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateDoublyLinkedExtended (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;

Function AsDoublyLinkedStringList (const V : Array of String) : PDoublyLinkedString;
var I, L : PDoublyLinkedString;
    F    : Integer;
  Begin
    Result := nil;
    For F := 0 to High (V) do
      begin
        I := CreateDoublyLinkedString (V [F]);
        if F = 0 then
          begin
            L := I;
            Result := I;
          end else
          begin
            L.InsertAfter (I);
            L := I;
          end;
      end;
  End;



{                                                                              }
{ Linked list comparison                                                       }
{                                                                              }
Function IsEqual (const V1 : PLinkedInteger; const V2 : PLinkedInteger) : Boolean;
var I1 : PLinkedInteger;
    I2 : PLinkedInteger;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedInteger (I1.Next);
          I2 := PLinkedInteger (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedInt64; const V2 : PLinkedInt64) : Boolean;
var I1 : PLinkedInt64;
    I2 : PLinkedInt64;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedInt64 (I1.Next);
          I2 := PLinkedInt64 (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedSingle; const V2 : PLinkedSingle) : Boolean;
var I1 : PLinkedSingle;
    I2 : PLinkedSingle;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedSingle (I1.Next);
          I2 := PLinkedSingle (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedDouble; const V2 : PLinkedDouble) : Boolean;
var I1 : PLinkedDouble;
    I2 : PLinkedDouble;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedDouble (I1.Next);
          I2 := PLinkedDouble (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedExtended; const V2 : PLinkedExtended) : Boolean;
var I1 : PLinkedExtended;
    I2 : PLinkedExtended;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedExtended (I1.Next);
          I2 := PLinkedExtended (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedString; const V2 : PLinkedString) : Boolean;
var I1 : PLinkedString;
    I2 : PLinkedString;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedString (I1.Next);
          I2 := PLinkedString (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PDoublyLinkedInteger; const V2 : PDoublyLinkedInteger) : Boolean;
var I1 : PDoublyLinkedInteger;
    I2 : PDoublyLinkedInteger;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PDoublyLinkedInteger (I1.Next);
          I2 := PDoublyLinkedInteger (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PDoublyLinkedInt64; const V2 : PDoublyLinkedInt64) : Boolean;
var I1 : PDoublyLinkedInt64;
    I2 : PDoublyLinkedInt64;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PDoublyLinkedInt64 (I1.Next);
          I2 := PDoublyLinkedInt64 (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PDoublyLinkedSingle; const V2 : PDoublyLinkedSingle) : Boolean;
var I1 : PDoublyLinkedSingle;
    I2 : PDoublyLinkedSingle;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PDoublyLinkedSingle (I1.Next);
          I2 := PDoublyLinkedSingle (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PDoublyLinkedDouble; const V2 : PDoublyLinkedDouble) : Boolean;
var I1 : PDoublyLinkedDouble;
    I2 : PDoublyLinkedDouble;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PDoublyLinkedDouble (I1.Next);
          I2 := PDoublyLinkedDouble (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PDoublyLinkedExtended; const V2 : PDoublyLinkedExtended) : Boolean;
var I1 : PDoublyLinkedExtended;
    I2 : PDoublyLinkedExtended;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PDoublyLinkedExtended (I1.Next);
          I2 := PDoublyLinkedExtended (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PDoublyLinkedString; const V2 : PDoublyLinkedString) : Boolean;
var I1 : PDoublyLinkedString;
    I2 : PDoublyLinkedString;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PDoublyLinkedString (I1.Next);
          I2 := PDoublyLinkedString (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedInteger; const V2 : PDoublyLinkedInteger) : Boolean;
var I1 : PLinkedInteger;
    I2 : PDoublyLinkedInteger;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedInteger (I1.Next);
          I2 := PDoublyLinkedInteger (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedInt64; const V2 : PDoublyLinkedInt64) : Boolean;
var I1 : PLinkedInt64;
    I2 : PDoublyLinkedInt64;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedInt64 (I1.Next);
          I2 := PDoublyLinkedInt64 (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedSingle; const V2 : PDoublyLinkedSingle) : Boolean;
var I1 : PLinkedSingle;
    I2 : PDoublyLinkedSingle;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedSingle (I1.Next);
          I2 := PDoublyLinkedSingle (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedDouble; const V2 : PDoublyLinkedDouble) : Boolean;
var I1 : PLinkedDouble;
    I2 : PDoublyLinkedDouble;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedDouble (I1.Next);
          I2 := PDoublyLinkedDouble (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedExtended; const V2 : PDoublyLinkedExtended) : Boolean;
var I1 : PLinkedExtended;
    I2 : PDoublyLinkedExtended;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedExtended (I1.Next);
          I2 := PDoublyLinkedExtended (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;

Function IsEqual (const V1 : PLinkedString; const V2 : PDoublyLinkedString) : Boolean;
var I1 : PLinkedString;
    I2 : PDoublyLinkedString;
  Begin
    I1 := V1;
    I2 := V2;
    While Assigned (I1) and Assigned (I2) do
      if I1.Value <> I2.Value then
        begin
          Result := False;
          exit;
        end else
        begin
          I1 := PLinkedString (I1.Next);
          I2 := PDoublyLinkedString (I2.Next);
        end;
    Result := not Assigned (I1) and not Assigned (I2);
  End;



{                                                                              }
{ Type conversion                                                              }
{                                                                              }
Function StrToFloatDef (const S : String; const Default : Extended) : Extended;
  Begin
    try
      Result := StrToFloat (S);
    except
      Result := Default;
    end;
  End;

Function BooleanToStr (const B : Boolean) : String;
  Begin
    Result := Cond (B, 'True', 'False');
  End;

Function StrToBoolean (const S : String) : Boolean;
  Begin
    Result := LowerCase (S) = 'true';
  End;

{                                                                              }
{ Path functions                                                               }
{                                                                              }
Function PathWithSlashAtEnd (const Path : String; const SlashCh : Char = '\') : String;
  Begin
    if (Path <> '') and (Path [Length (Path)] <> SlashCh) then
      Result := Path + SlashCh else
      Result := Path;
  End;

Function PathWithoutSlashAtEnd (const Path : String; const SlashCh : Char = '\') : String;
  Begin
    if (Path <> '') and (Path [Length (Path)] = SlashCh) then
      Result := Copy (Path, 1, Length (Path) - 1) else
      Result := Path;
  End;

Function UnixPathToWindowsPath (const Path : String) : String;
  Begin
    Result := Replace ('/', '\', Replace (['\', ':', '"', '<', '>', '|'], '_', Path));
  End;

{ Network path:  \\      --->   /                                              }
{ Device path:   \\.\    --->   /                                              }
{ Drive letter:  X:      --->   X/                                             }
Function WindowsPathToUnixPath (const Path : String) : String;
  Begin
    Result := Path;
    if Length (Result) >= 2 then
      if Result [2] = ':' then // drive letter
        Result [2] := '/' else
      if (Result [1] = '\') and (Result [2] = '\') then
        if (Length (Result) >= 3) and (Result [3] = '.') then
          Delete (Result, 1, 3) else    // device path
          Delete (Result, 1, 1);        // network path
    Result := Replace ('\', '/', Replace (['/', ':', '"', '<', '>', '|'], '_', Path));
  End;

Function PathLeftElement (const Path : String; const SlashCh : Char = '\') : String;
  Begin
    Result := CopyBefore (Path, SlashCh, True);
  End;

Function PathRightElement (const Path : String; const SlashCh : Char = '\') : String;
  Begin
    Result := CopyFrom (Path, PosPrev (SlashCh, Path) + 1);
  End;

Function PathWithoutLeftElement (const Path : String; const SlashCh : Char = PathSeparator) : String;
  Begin
    Result := CopyAfter (Path, SlashCh, False);
  End;

Function PathWithoutRightElement (const Path : String; const SlashCh : Char = PathSeparator) : String;
  Begin
    Result := CopyBefore (Path, SlashCh, False);
  End;



{                                                                              }
{ Locked integer manipulation                                                  }
{ Code by Azret Botash.                                                        }
{   LockedAdd, LockedDec, LockedSub, LockedInc does operation with Value on    }
{     Target and returns the result.                                           }
{   LockedCompareExchange compares Target with Comp and if equal sets Target   }
{     to Exch.                                                                 }
{   LockedExchange set current value of Target to Value and returns old value  }
{     of Target.                                                               }
{                                                                              }
{
Function LockedAdd (var Target : Integer; const Value : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, EDX
      LOCK
      XADD    [ECX], EAX
      ADD     EAX, EDX
  End;

Function LockedSub (var Target : Integer; const Value : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      NEG     EDX
      MOV     EAX, EDX
      LOCK
      XADD    [ECX], EAX
      ADD     EAX, EDX
  End;

Function LockedInc (var Target : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, 1
      LOCK
      XADD    [ECX], EAX
      INC     EAX
  End;

Function LockedDec (var Target : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, -1
      LOCK
      XADD    [ECX], EAX
      DEC     EAX
  End;

Function LockedCompareExchange (var Target : Integer; const Exch, Comp : Integer) : Integer; assembler; register;
  Asm
      XCHG    EAX, ECX
      LOCK
      CMPXCHG [ECX], EDX
  End;

Function LockedExchange (var Target : Integer; Value : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, EDX
      LOCK
      XCHG    [ECX], EAX
  End;

Function LockedExchangeAdd (var Target : Integer; Value : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, EDX
      LOCK
      XADD    [ECX], EAX
  End;

Function LockedExchangeDec (var Target : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, -1
      LOCK
      XADD    [ECX], EAX
  End;

Function LockedExchangeInc (var Target : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      MOV     EAX, 1
      LOCK
      XADD    [ECX], EAX
  End;

Function LockedExchangeSub (var Target : Integer; Value : Integer) : Integer; assembler; register;
  Asm
      MOV     ECX, EAX
      NEG     EDX
      MOV     EAX, EDX
      LOCK
      XADD    [ECX], EAX
  End;
}

{ Bit functions                                                                }
{   SwapBits, LSBit, MSBit and SwapEndian taken from the Delphi Encryption     }
{   Compendium 3.0 by Hagen Reddmann (HaReddmann@AOL.COM)                      }
Function SwapBits (const Value : LongWord) : LongWord; register;
  Asm
           BSWAP  EAX
           MOV    EDX,EAX
           AND    EAX,0AAAAAAAAh
           SHR    EAX,1
           AND    EDX,055555555h
           SHL    EDX,1
           OR     EAX,EDX
           MOV    EDX,EAX
           AND    EAX,0CCCCCCCCh
           SHR    EAX,2
           AND    EDX,033333333h
           SHL    EDX,2
           OR     EAX,EDX
           MOV    EDX,EAX
           AND    EAX,0F0F0F0F0h
           SHR    EAX,4
           AND    EDX,00F0F0F0Fh
           SHL    EDX,4
           OR     EAX,EDX
  End;

Function LSBit (const Value : LongWord) : LongWord; assembler; register;
  Asm
       BSF   EAX,EAX
  End;

Function MSBit (const Value : LongWord) : LongWord; assembler; register;
  Asm
       BSR   EAX,EAX
  End;

Function SwapEndian (const Value : LongWord) : LongWord; assembler; register;
  Asm
       XCHG  AH,AL
       ROL   EAX,16
       XCHG  AH,AL
  End;

Procedure SetBit (var Value : LongWord; const Bit : Byte); assembler; register;
  Asm
       MOV CL, DL
       XOR EDX, EDX
       INC EDX
       SHL EDX, CL
       OR [EAX], EDX
  End;

Procedure ClearBit (var Value : LongWord; const Bit : Byte); assembler; register;
  Asm
       MOV CL, DL
       XOR EDX, EDX
       INC EDX
       SHL EDX, CL
       NOT EDX
       AND [EAX], EDX
  End;

Procedure ToggleBit (var Value : LongWord; const Bit : Byte); assembler; register;
  Asm
       MOV CL, DL
       XOR EDX, EDX
       INC EDX
       SHL EDX, CL
       XOR [EAX], EDX
  End;

Function IsBitSet (const Value : LongWord; const Bit : Byte) : Boolean; assembler; register;
  Asm
       MOV CL, DL
       XOR EDX, EDX
       INC EDX
       SHL EDX, CL
       TEST EAX, EDX
       JZ @NotSet
       MOV AL, 1
       RET
     @NotSet:
       OR AL, AL
  End;

{ Called a "dense" bitcount function                                           }
Function BitCount (const Value : LongWord) : LongWord;
var Y : LongWord;
  Begin
    Y := Value - ((Value shr 1) and $55555555);
    Y := (Y and $33333333) + ((Y shr 2) and $33333333);
    Y := Y + Y shr 4;
    Y := Y and $0F0F0F0F;
    Y := Y + Y shr 8;
    Result := (Y + Y shr 16) and $000000FF;
  End;

{ Returns Cardinal with N least significant bits set.                          }
Function LSBitsMask (const N : Byte) : Cardinal;
  Begin
    Result := (1 shl N) - 1;
  End;

{ Returns Cardinal with N most significant bits set.                           }
Function MSBitsMask (const N : Byte) : Cardinal;
  Begin
    Result := not (1 shl (BitsPerCardinal - N)) + 1;
  End;

{ Returns Cardinal with bits L to H set.                                       }
Function BitRangeMask (const L, H : Byte) : LongWord; Assembler;
  Begin
    Result := not Cardinal (0);
    if L > 0 then
      Result := Result and not LSBitsMask (L);
    if H < BitsPerCardinal - 1 then
      Result := Result and not MSBitsMask (BitsPerCardinal - 1 - H);
  End;

Function Compare (const I1, I2 : Integer) : TCompareResult;
  Begin
    if I1 < I2 then
      Result := crLess else
    if I1 > I2 then
      Result := crGreater else
      Result := crEqual;
  End;

Function Compare (const I1, I2 : Int64) : TCompareResult;
  Begin
    if I1 < I2 then
      Result := crLess else
    if I1 > I2 then
      Result := crGreater else
      Result := crEqual;
  End;

Function Compare (const I1, I2 : Single) : TCompareResult;
  Begin
    if I1 < I2 then
      Result := crLess else
    if I1 > I2 then
      Result := crGreater else
      Result := crEqual;
  End;

Function Compare (const I1, I2 : Double) : TCompareResult;
  Begin
    if I1 < I2 then
      Result := crLess else
    if I1 > I2 then
      Result := crGreater else
      Result := crEqual;
  End;

Function Compare (const I1, I2 : Extended) : TCompareResult;
  Begin
    if I1 < I2 then
      Result := crLess else
    if I1 > I2 then
      Result := crGreater else
      Result := crEqual;
  End;

Function Compare (const I1, I2 : String) : TCompareResult;
  Begin
    if I1 < I2 then
      Result := crLess else
    if I1 > I2 then
      Result := crGreater else
      Result := crEqual;
  End;


Function Compare (const I1, I2 : TObject) : TCompareResult;
  Begin
    Result := Compare (Integer (I1), Integer (I2));
  End;

{$IFDEF MSWINDOWS}
Function GetUserName : String;
var L : LongWord;
  Begin
    L := 128;
    SetLength (Result, L);
    if Windows.GetUserName (PChar (Result), L) and (L > 0) then
      SetLength (Result, L - 1) else
      Result := '';
  End;
{$ENDIF}

Function ExceptionToStr (const E : Exception) : String;
  Begin
    Result := E.ClassName + ' (' + E.Message + ')';
  End;

end.

