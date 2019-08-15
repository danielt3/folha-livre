unit fencrypt;

interface

uses
   Classes;

function kEncryptStd( Texto, Key:String):String;stdcall;
function kDencryptStd( Texto, Key:String):String;stdcall;

function kEnDencrypt( Texto, Key, Sequencia: String;
  Turning, DecimalOut: Boolean; MoveNumber: Integer):String;stdcall;

implementation

uses Encode;

function kEnDencrypt( Texto, Key, Sequencia: String;
  Turning, DecimalOut: Boolean; MoveNumber: Integer): String;
var
  Encpt: Tencode;
begin

  Encpt := Tencode.Create(NIL);

  try

    Encpt.DecimalOut := DecimalOut;
    Encpt.Key        := Key;
    Encpt.MoveNumber := MoveNumber;
    Encpt.Sequence   := Sequencia;
    Encpt.Turning    := Turning;
    Encpt.TextInOut  := Texto;

    Result := Encpt.TextInOut;

  finally
    Encpt.Free;
  end;

end;

function kEncryptStd( Texto, Key:String):String;
begin
  Result := kEnDencrypt( Texto, Key, '123', True, False, 10);
end;

function kDencryptStd( Texto, Key:String):String;
begin
  Result := kEnDencrypt( Texto, Key, '321', True, False, -10);
end;  // function kDencryptStd

end.
