unit finterface;

interface

uses
  SysUtils, Windows, Dialogs, Controls, Registry, Forms, stdctrls;

procedure kTaskBarShow( Visible: Boolean);stdcall;
function kTaskBarVisible:Boolean;stdcall;

function kGetPrinter( Porta: Word):Boolean;stdcall;

function kImpOK(Porta:Word = 1): Boolean; stdcall;
function kIsPrinter: Boolean; stdcall;

function kGetComputador: String; stdcall;

implementation

procedure kTaskBarShow( Visible: Boolean);
var
  Handle: THandle;
begin
  Handle := FindWindow( PChar('Shell_TrayWnd'), nil);
  if Visible then ShowWindow( Handle, SW_RESTORE)
             else ShowWindow( Handle, SW_HIDE);
end;

function kTaskBarVisible:Boolean;
var
  Handle: THandle;
begin
  Handle:= FindWindow( PChar('Shell_TrayWnd'), nil);
  Result := IsWindowVisible(Handle);
end;

function kGetPrinter( Porta: Word):Boolean;
type
  TStatus = ( Lista, OffLine, SemPapel, Apagada, Desconhecido);
var
  Estado: TStatus;
  Rdo: byte;
  Confirmado: Boolean;
  TextoError: String;
begin

   Estado     := Desconhecido;
   Confirmado := False;

   while (Estado <> Lista) and (not Confirmado) do begin

     asm
       MOV  DX,Porta
       MOV  AX,$0200  {AH := $02 : Leer el estado de la impresora}
       INT  $17
       MOV  Rdo,AH     {Guarda el estado en AL}
     end;

     if Rdo = 144 then
       Estado := Lista

     else if Rdo = 24 then begin
       Estado := OffLine;
       TextoError := 'A impressora se encontra fora de linha.';

     end else if Rdo = 56 then begin
       Estado := SemPapel;
       TextoError := 'A impressora se encontra sem papel.';

     end else if Rdo = 32 then begin
       Estado := Apagada;
       TextoError := 'A impresora esta desligada.';

     end else begin
       Estado := Desconhecido;
       TextoError := 'A impressora tem um problema desconhecido.';
     end;

     if Estado <> Lista then begin
       if MessageDlg( TextoError, mtError, [mbRetry,mbCancel],0) = mrCancel then
         Confirmado := True;
     end;

   end;  // while

   Result := ( Estado = Lista);

end;

function kIsPrinter:Boolean;
const
  PrnStInt: Byte = $17;
  StRq: Byte = $02;
  PrnNum: Word = 0; {0 para LPT1, 1 para LPT2, etc. }
var
  nResult: Byte;
begin

  asm
    mov ah,StRq;
    mov dx,PrnNum;
    Int $17;
    mov nResult,ah;
  end;

  Result := (nResult and $80) = $80;

  // Enviado por: Glauber Yatsuda - sandman@wnet.com.br  ICQ # 6192244

end;

{ Fim das funções XBase - Clipper }

// Verifica se a impressora esta' em linha
function kImpOK(Porta:Word = 1):Boolean;
begin
  Result := True;
  while Result and (not kIsPrinter) do begin
    SysUtils.Beep();
    Result := Application.MessageBox(
               PChar('A Impressora nao está preparada.'+#13+
                     'Verifique.'), PChar('Confirme'),
               MB_ICONQUESTION + MB_RETRYCANCEL ) = idRetry;
  end;
end;

function kGetComputador: String;
var
  Reg: tRegistry;
begin

  Result := '';
  Reg := TRegistry.Create;

   try
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     Reg.OpenKey('System\CurrentControlSet\Services\VXD\VNETSUP', False);
     Result:= Reg.ReadString('ComputerName');
   finally
     Reg.Free;
   end;

end;  // func GetComputador

end.
