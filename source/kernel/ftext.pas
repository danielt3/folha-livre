{
ftext.pas - Biblioteca de funções genéricas para manipulação de texto
Copyright (c) 2001-2002, Allan Lima, Brazil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Autor: Allan Kardek Lima
E-mail: allan_kardek@yahoo.com.br ; folha_livre@yahoo.com.br
}

unit ftext;

{$I flivre.inc}

interface

uses
 {$IFDEF VCL}Windows, Forms, Controls, Dialogs,{$ENDIF}
 {$IFDEF CLX}QForms, QControls, QDialogs,{$ENDIF}
 SysUtils, Classes, MaskUtils;

function kNumerico( Source: String): Boolean;
function kIsNumerico( Source: String): Boolean;
function Alfabetico( Source: String): Boolean;stdcall;
function AlfaNumerico( Source: String): Boolean;stdcall;

function IsAlpha(S:String):Boolean;stdcall;
function kIsAlpha(S:String):Boolean;  // verifica se há algum caracter alfabetico
function kIsDigit(S:String):Boolean;
function IsDigit( S:String):Boolean;stdcall;
function IsLower( S:String):Boolean;stdcall;
function IsUpper( S:String):Boolean;stdcall;
function UpperLowerCase( S:String):String;stdcall;

function kIfThenStr( AValue: Boolean; const ATrue, AFalse: String):String;stdcall;

function Replicate( const S:String; ALen:Integer):String;stdcall;
function kEspaco( ALen:Integer ):String;stdcall;
function kStrZero(const AValue:Integer; const ALen:Integer):String;stdcall;

function PadLeftChar( AValue: String; const ALen: Integer; AChar: Char = #32): String;stdcall;
function PadRightChar( AValue: String; const ALen: Integer; AChar: Char = #32): String;stdcall;
function PadCenter( AValue: String; const ALen: Integer; AChar: Char = #32): String;stdcall;

function Rat( Substr, S: String):Integer;stdcall;

procedure kBreakApart( BaseString, BreakString:String;
  var StringList:TStringList);stdcall;

function kRetira( const Texto, Parte:String):String;stdcall;
function kRetiraChar( Texto, Parte: String):String;stdcall;
function kSubstitui( Texto, Procura, Troca:String):String;stdcall;

function Sigla( const S:String):String;stdcall;

// Rotinas de janelas de mensagens

function kConfirme(Mensagem:String; Default: Integer = 2):Boolean;stdcall;
procedure kErro( Msg:String; Modulo: String = ''; Processo: String = ''); overload;
procedure kErro( E: Exception; Msg: String = '';
  Modulo: String = ''; Processo: String = ''); overload;
procedure kAviso(Aviso:String; DlgType: TMsgDlgType = mtWarning);

function kChecaPIS( const PIS: String):Boolean;stdcall;
function kChecaPISMsg( const PIS: String; Obrigatorio: Boolean = False):Boolean;stdcall;

function kChecaCPF( const CPF: String):Boolean;stdcall;
function kChecaCNPJ(const Cgc: String):Boolean;stdcall;
function kChecaCPFCGC( const CPFCGC: String; Obrigatorio:Boolean):Boolean;stdcall;
function kChecaBCO( const Conta: String):Boolean;stdcall;
function kChecaConta( const Conta: String):Boolean;stdcall;
function kCartaoCredito( const Numero, Nome:String):Boolean;stdcall;

function kSpaceString( const Text: TStringList;
  const SpaceTotal: Integer; const SpaceString: Char = ' '):String; overload;

function kSpaceString( const Text: array of String;
  const SpaceTotal: Integer; const SpaceString: Char = ' '): String; overload;

function kLengthChar( const Text: TStringList): Integer; overload;
function kLengthChar( const Text: array of String): Integer; overload;

function kInputInt( const ACaption, APrompt: string;
  var Value: Integer): Boolean;

function kInputCurrency( const ACaption, APrompt: string;
  var Value: Currency): Boolean;

function kInputDate( ACaption, APrompt: string; var Value: TDateTime): Boolean;
function kInputText( const ACaption, APrompt: string;
  var Value: String): Boolean;

function kFormatCEP( const Numero:String):String;
function kFormatCNPJ( const Numero:String):String;
function kFormatCPF( const Numero:String):String;
function kFormatPIS( const Numero:String):String;
function kFormatAgencia( const Numero:String):String;

function kFirstName( const Name:String):String;

implementation

function kIsNumerico(Source: String): Boolean;
begin
  Result := kNumerico(Source);
end;

function kNumerico(Source: String): Boolean;
var
  i: Integer;
begin

  Result := False;

  for i := 1 to Length(Source) do
  begin
    Result := (Source[i] in ['0'..'9']);
    if not Result then
      Break;
  end;

end;

function Alfabetico( Source: String): Boolean;
var i: Integer;
begin

  if Length(Source) = 0 then
    Result := False

  else begin

    Result := True;

    for i := 1 to Length(Source) do
      if not (Source[i] in ['A'..'Z','a'..'z']) then
      begin
        Result := False;
        Break;
      end;

  end;

end;

function AlfaNumerico( Source: String): Boolean;
var
  i: Integer;
  bNumero, bLetra: Boolean;
begin

  Result  := False;
  bNumero := False;
  bLetra  := False;

  if (Length( Source) = 0) then
    Exit;

  for i := 1 to Length( Source) do
    if ( Source[i] in ['A'..'Z','a'..'z'] ) then
      bLetra := True
   else if ( Source[i] in ['0'..'9'] ) then
      bNumero := True;

  if bLetra and bNumero then
    Result := True;

end;

// verifica se o primeiro caracter é alfabetico
function IsAlpha( S:String):Boolean;
begin
  Result := (UpCase(S[1]) in ['A'..'Z']);
end;

// verifica se há algum caracter alfabetico
function kIsAlpha( S:String):Boolean;
var
  i: Integer;
begin

  Result := False;

  if (S = EmptyStr) then
    Exit;

  for i := 1 to Length(S) do
  begin
    Result := S[i] in ['A'..'Z','a'..'z'];
    if Result then
      Break;
  end;

end;

// verifica se todos os caracteres são numéricos
function kIsDigit( S:String):Boolean;
var
  i: Integer;
begin

  Result := False;

  if (S = EmptyStr) then
    Exit;

  for i := 1 to Length(S) do
  begin
    Result := S[i] in ['0'..'9','.'];
    if not Result then
      Break;
  end;

end;

// verifica se o primeiro caracter é um dígito
function IsDigit( S:String):Boolean;
begin
  Result := (S[1] in ['0'..'9']);
end;

// verifica se o primeiro caracter é alfabetico minusculo
function IsLower( S:String):Boolean;
begin
  Result := ( S[1] in ['a'..'z']);
end;

// verifica se o primeiro caracter é alfabetico maiusculo
function IsUpper( S:String):Boolean;
begin
  Result := ( S[1] in ['A'..'Z']);
end;

function UpperLowerCase( S:String):String;
begin
  Result := UpperCase(S[1])+LowerCase(Copy(S, 2, Length(S)));
end;

function Replicate( const S:String; ALen:Integer ):String;
var
 i: Integer;
begin
  Result := '';
  for i := 1 to ALen do
    Result := Result + S;
end;

function kIfThenStr( AValue: Boolean; const ATrue, AFalse: String):String;stdcall;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function kEspaco( ALen:Integer ):String;
begin
  Result := StringOfChar(#32, ALen);
end;

function kStrZero( const AValue:Integer; const ALen:Integer):String;
begin
  Result := Format('%.'+IntToStr(ALen)+'d',[AValue]);
end;

function Pad( S:String; const ALen:Integer;
              const ASide: TAlignment; const AChar:String):String;
begin

  case ASide of
    taLeftJustify:
      while Length(S) < ALen do
        S := S + AChar;
    taRightJustify:
      while Length(S) < ALen do
        S := AChar + S;
    taCenter:
      while Length(S) < ALen do
        if (Length(S) mod 2) = 0 then S := S + AChar
                                 else S := AChar + S;
  end;

  if Length(S) > ALen then
    S := Copy( S, 1, ALen);

  Result := S;

end;

function PadLeftChar( AValue: String; const ALen: Integer; AChar: Char = #32): String;
begin
  Result := Pad( AValue, ALen, taRightJustify, AChar);
end;

function PadRightChar( AValue: String; const ALen: Integer; AChar: Char = #32): String;
begin
  Result := Pad( AValue, ALen, taLeftJustify, AChar);
end;

function PadCenter( AValue: String; const ALen: Integer; AChar: Char = #32): String;
begin
  Result := Pad( AValue, ALen, taCenter, AChar);
end;

// Encontra a ultima ocorrencia de Substr em S
function Rat( Substr, S:String):Integer;
var
  iLen, iLenS, i: Integer;
begin

  Result := 0;
  iLen   := Length(Substr);
  iLenS  := Length(S);

  if iLen > iLenS then Exit;

  for i := ( iLenS-iLen+1) downto 1 do
    if Substr = Copy( S, i, iLen) then begin
      Result := i;
      Break;
    end;

end;

procedure kBreakApart( BaseString, BreakString:String; var StringList:TStringList);
var
  EndOfCurrentString: Byte;
begin

  // StringList := BreakApart('Allan Kardek Neponuceno Lima', ' ')
  // StringList[0]: 'Allan'
  // StringList[1]: 'Kardek'
  // StringList[2]: 'Neponuceno'
  // StringList[3]: 'Lima'

  StringList.Clear;

  repeat
    EndOfCurrentString := Pos( BreakString, BaseString);
    if EndOfCurrentString = 0 then
      StringList.Add(BaseString)
    else            
      StringList.Add( Copy(BaseString, 1, EndOfCurrentString-1) );
    BaseString := Copy( BaseString,
                        EndOfCurrentString + Length(BreakString),
                        Length(BaseString)-EndOfCurrentString );
  until
    EndOfCurrentString = 0;

end;

function kRetira( const Texto, Parte:String):String;
begin
  Result := kSubstitui( Texto, Parte, '');
end;

function kRetiraChar( Texto, Parte:String):String;
var
  i: Integer;
begin
  Result := Texto;
  for i := 1 to Length(Parte) do
    Result := StringReplace(Result, Parte[i], '', [rfReplaceAll]);
end;

function kSubstitui( Texto, Procura, Troca:String):String;
begin
  Result := StringReplace(Texto, Procura, Troca, [rfReplaceAll]);
end;

// Retorna a Sigla do Texto enviado.
// 1. Ex.: 'ALLAN KARDEK LIMA' -> 'AKL'
// 2. Ex.: 'INFOR-SYSTEM'      -> 'IS'
// 3. Ex.: 'ALLAN;CLAUDIA;ORMINDA' -> 'ACO'
function Sigla( const S:String):String;
const
  Letras: String = ',;-';
var
  i, Posicao: Integer;
  Texto: String;
begin

  Texto := S;

  for i := 1 to Length(Letras) do
    Texto := kSubstitui( Texto, Letras[i], #32);

  Texto := ' '+kSubstitui( Texto, #32#32, #32);
  Posicao := 1;

  repeat
    Result := Result + Copy( Texto, Posicao+1, 1);
    Delete( Texto, Posicao, 1);
    Posicao := Pos( #32, Texto);
  until ( Posicao  = 0 )

end;

function SetGetCursor( Cursor: TCursor):TCursor;
begin
  Result := Screen.Cursor;
  Screen.Cursor := Cursor;
end;

{ mensagens }

function kConfirme(Mensagem:String; Default: Integer = 2):Boolean;
var
  Cursor: TCursor;
  Button: Integer;
begin
  Cursor := SetGetCursor(crDefault);
  //  MessageBeep( MB_ICONQUESTION);
  Result := True;
  if (Mensagem = '') then
    Exit;
  {$IFDEF VCL}
  Button := MB_DEFBUTTON2;
  if Default = 1 then       Button := MB_DEFBUTTON1
  else if Default = 3 then  Button := MB_DEFBUTTON3
  else if Default = 4 then  Button := MB_DEFBUTTON4;
  Result := (Application.MessageBox( PChar(Mensagem), PChar('Confirme'),
                         mb_iconquestion + mb_YesNo + Button ) = idYes);
  {$ENDIF}
  {$IFDEF CLX}
  Result := (Application.MessageBox( Mensagem, 'Confirme', [smbYes, smbNo],
                                     smsInformation, smbNo, smbNo) = smbYes);
  {$ENDIF}
  SetGetCursor(Cursor);
end;

procedure kErro( Msg: String; Modulo: String = ''; Processo: String = '');
var
  Cursor: TCursor;
begin

  if (Msg = '') then
    Exit;

  Cursor := SetGetCursor(crDefault);
  SysUtils.Beep;

  if (Modulo = '.') then
    Modulo := ExtractFileName(Application.ExeName);

  if (Length(Modulo) > 0) and (Length(Processo) > 0) then
    Msg := 'Módulo: '+Modulo+#10#13+'Função: '+Processo+#10#13#10#13+Msg;

  MessageDlg( Msg, mtError, [mbOK], 0);

  SetGetCursor(Cursor);

end;

procedure kErro( E: Exception; Msg: String = '';
  Modulo: String = ''; Processo: String = ''); overload;
var
  Cursor: TCursor;
  sMessage, sTemp: String;
begin

  Cursor := SetGetCursor(crDefault);
  SysUtils.Beep;

  sMessage := Modulo;

  if (sMessage = '.') then
    sMessage := ExtractFileName(Application.ExeName);

  if (sMessage <> '') then
    sMessage := 'Módulo: '+sMessage;

  if (Processo <> '') then
  begin
    if (sMessage <> '') then
      sMessage := sMessage + #10#13;
    sMessage := sMessage+'Processo: '+Processo;
  end;

  {$IFDEF IBX}
  //sTemp := kTrataErro(E);
  {$ENDIF}

  if (sTemp <> '') then
    sMessage := sMessage + #10#13#10#13 + sTemp;

  sMessage := sMessage + #10#13#10#13 + E.Message;

  if (Msg <> '') and (E.Message <> Msg) then
    sMessage := sMessage + #10#13#10#13 + Msg;

  MessageDlg( sMessage, mtError, [mbOK], 0);

  SetGetCursor(Cursor);

end;

procedure kAviso(Aviso:String; DlgType: TMsgDlgType = mtWarning);
var
  Cursor: TCursor;
begin
  Cursor := SetGetCursor(crDefault);
  SysUtils.Beep;
  MessageDlg( Aviso, DlgType, [mbOK], 0);
  SetGetCursor(Cursor);
end;

{ validacao de numeros de documentos }

function kChecaPIS( const PIS: String):Boolean;
const
  MODELO = '3298765432';
var
  iDigito, i, iSoma: Integer;
begin

  Result := False;

  if (Length(PIS) <> 11) then
    Exit;

  try
    iSoma := 0;
    for i := 1 to Length(MODELO) do
      iSoma := iSoma + ( StrToInt(PIS[i]) * StrToInt(MODELO[i]) );
    iDigito := 11 - (iSoma mod 11);
    Result := (StrToInt(PIS[Length(MODELO)+1]) = iDigito);
  except
    Result := False;
  end;

end;  // function ChecaPIS

function kChecaPISMsg( const PIS: String; Obrigatorio: Boolean = False):Boolean;
var
  iLen: Integer;
  Num: String;
begin

  Result := False;
  Num    := Trim(PIS);
  iLen   := Length(PIS);

  if (iLen = 0) and Obrigatorio then
    kErro('O Número do PIS/IPASEP é obrigatório')

  else if (iLen = 0) and (not Obrigatorio) then
    Result := True

  else if (iLen = 11) then
    Result := kChecaPIS(Num);

  if (iLen > 0) and (not Result) then
    kErro( 'O número do PIS/IPASEP está inválido. Verifique');

end;  // function ChecaPISMsg

function kChecaCPF( const CPF: String):Boolean;
var
  localCPF: String;
  localResult: Boolean;
  digit1, digit2, ii, soma: Integer;
begin

  localCPF    := '';
  localResult := False;
  Result      := False;

  {analisa CPF no formato 999.999.999-00}
  if (Length(Cpf) = 14) and ( Cpf[4]+Cpf[8]+Cpf[12] = '..-' ) then begin
    localCPF := Copy( Cpf, 1, 3) + Copy( Cpf, 5, 3) +
                Copy( Cpf, 9, 3) + Copy( Cpf, 13, 2);
    localResult := True;
  end;

  {analisa CPF no formato 99999999900}
  if Length(Cpf) = 11 then begin
    localCPF := Cpf;
    localResult := True;
  end;

  if not localResult then
    Exit;

  {comeca a verificacao do digito}

  try

    {1° digito}
    soma := 0;
    for ii := 1 to 9 do
      Inc( soma, StrToInt( localCPF[10-ii] )*(ii+1));
    digit1 := 11 - (soma mod 11);
    if digit1 > 9 then digit1 := 0;

    {2° digito}
    soma := 0;
    for ii := 1 to 10 do Inc(soma, StrToInt( localCPF[11-ii])*(ii+1));
    digit2 := 11 - (soma mod 11);
    if digit2 > 9 then digit2 := 0;

    {Checa os dois dígitos}
    localResult := ( (Digit1 = StrToInt(localCPF[10])) and
                     (Digit2 = StrToInt( localCPF[11])) );

  except
    localResult := False;
  end;

  Result := localResult;

end;  // function ChecaCFP

function kChecaCNPJ(const Cgc: String):Boolean;
var
  localCGC: String;
  localResult: Boolean;
  digit1, digit2, ii, soma: Integer;
begin

  localCGC := '';
  localResult := False;
  Result := False;

  {analisa CGC no formato 99.999.999/9999-99}
  if ( Length(Cgc) = 18 ) and (Cgc[3]+Cgc[7]+Cgc[11]+Cgc[16] = '../-') then begin
    localCGC := Copy(Cgc,1,2) + Copy(Cgc,4,3) + Copy(Cgc,8,3) +
                Copy(Cgc,12,4) + Copy(Cgc,17,2);
    localResult := True;
  end;

  {analisa CGC no formato 99999999999900}
  if Length(Cgc) = 14 then begin
    localCGC := Cgc;
    localResult := True;
  end;

  if not localResult then
    Exit;

  {comeca a verificacao do digito}
  try

    {1° digito}
    soma := 0;
    for ii := 1 to 12 do
      if ii < 5 then Inc(soma, StrToInt( localCGC[ii])*(6-ii))
                else Inc(soma, StrToInt( localCGC[ii])*(14-ii));

    digit1 := 11 - (soma mod 11);
    if digit1 > 9 then digit1 := 0;

    {2° digito}
    soma := 0;
    for ii := 1 to 13 do
      if ii < 6 then Inc(soma, StrToInt( localCGC[ii])*(7-ii))
                else Inc(soma, StrToInt( localCGC[ii])*(15-ii));

    digit2 := 11 - (soma mod 11);

    if digit2 > 9 then digit2 := 0;

    {Checa os dois dígitos}
    localResult := ( (Digit1 = StrToInt( localCGC[13] )) and
                     (Digit2 = StrToInt( localCGC[14] ))  );

  except
    localResult := False;
  end;

  Result := localResult;

end;

function kChecaCPFCGC( const CPFCGC: String; Obrigatorio:Boolean):Boolean;
var
  iLen: Integer;
  Num: String;
begin

  Result := False;
  Num    := Trim(CpfCgc);
  iLen   := Length(Num);

  if (iLen = 0) and Obrigatorio then
    kErro('O Número do CPF/CNPJ é obrigatório')

  else if (iLen = 0) and (not Obrigatorio) then
    Result := True

  else if (iLen = 11) then
    Result := kChecaCPF(Num)

  else if (iLen = 14) then
    Result := kChecaCNPJ(Num);

  if (iLen > 0) and (not Result) then
    kErro( 'O CPF/CNPJ informado está inválido. Verifique');

end;

function kChecaBCO( const Conta: String):Boolean;
var
  localConta, DigitoConta: String;
  localResult: Boolean;
  i, localDigito, Contador, Soma: integer;
begin

  localConta  := '';
  localResult := False;

  { Prefixo de Agencia Bancaria no Formato 9999-0}
  if ( Length(Conta) = 6 ) then
    if ( Copy( Conta, 5, 1) = '-' ) then
      localConta := Copy( Conta, 1, 4)+Copy( Conta, 6, 1);

  { Prefixo de Agencia Bancaria no Formato 99990}
  if ( Length(Conta) = 5 ) then
  begin
    localConta  := Conta;
    localResult := True;
  end;

  { Conta Bancaria no Formato 99.999.999-0}
  if ( Length(Conta) = 12 ) then
    if (Copy(Conta,3,1)+Copy(Conta,7,1)+Copy(Conta,11,1) = '..-') then
      localConta := Copy( Conta, 1, 2) + Copy( Conta, 4, 3) +
                     Copy( Conta, 8, 3) + Copy( Conta, 12, 1);

  { Conta Bancaria no Formato 999999990}
  if ( Length(Conta) = 9 ) then
  begin
    localConta  := Conta;
    localResult := True;
  end;

  if localResult then
    try
      // Retira o Digito Verificador da conta
      DigitoConta := Copy( localConta, Length(localConta), 1);
      localConta  := Copy( localConta, 1, Length(localConta)-1);
      Contador    := Length( localConta);
      Soma        := 0;

      if (DigitoConta = 'X') or (DigitoConta = 'x') then
        DigitoConta := '10';

      for i := 9 downto 10 - Length(localConta) do
      begin
        localDigito := StrToInt( Copy( localConta, Contador, 1) );
        Soma := Soma + ( localDigito * i);
        Contador := Contador - 1;
      end;

      if StrToInt( DigitoConta) = ( Soma mod 11 ) then
        localResult := True
      else
        localResult := False;

    except
      localResult := False;
    end;

  Result := localResult;

end;

function kChecaConta( const Conta: String):Boolean;
var
  localConta, DigitoConta: String;
  i, localDigito, Contador, Soma: integer;
begin

  { Conta Bancaria no Formato 99.999.999-0}
  localConta := kRetiraChar(Conta, '..-');
  localConta := PadLeftChar( localConta, 9, '0');

  try
    // Retira o Digito Verificador da conta
    DigitoConta := Copy( localConta, Length(localConta), 1);
    localConta  := Copy( localConta, 1, Length(localConta)-1);
    Contador    := Length( localConta);
    Soma        := 0;

    if (DigitoConta = 'X') or (DigitoConta = 'x') then
      DigitoConta := '10';

    for i := 9 downto 10 - Length(localConta) do
    begin
      localDigito := StrToInt( Copy( localConta, Contador, 1) );
      Soma := Soma + ( localDigito * i);
      Contador := Contador - 1;
    end;

    if StrToInt( DigitoConta) = ( Soma mod 11 ) then
      Result := True
    else
      Result := False;

  except
    Result := False;
  end;

end;

function kCartaoCredito( const Numero, Nome:String):Boolean;
type
  TCreditCardType = (ccAmex, ccVisa, ccMasterCard, ccDiscover, ccOther);
var
  CardType: TCreditCardType;
  SubSum, CheckSum, StartPos, i: integer;
  Number, Mask: String;
  TempChar : Char;
  sNome: String;
begin

   sNome := UpperCase(Nome);

   if (sNome = 'AMEX') or (sNome = 'AMERICAN EXPRESS') or (sNome = 'OPTIMA') then
     CardType := ccAmex
   else if (sNome = 'VISA') then
     CardType := ccVisa
   else if (sNome = 'MASTERCARD') or (sNome = 'MC') or (sNome = 'EUROCARD') or
           (sNome = 'CREDCARD') then
     CardType := ccMasterCard
   else if (sNome = 'DISCOVER') or (sNome = 'NOVOUS') then
     CardType := ccDiscover
   else
     CardType := ccOther;

   Result := FALSE; // by default it is not valid
   CheckSum := 0;
   Mask := '2121212121212121';

   Number := '';
   for i := 1 to Length(Numero) do
      if (Numero[i] in ['0' .. '9']) then
         Number := Number + Numero[i];

   if (Length(Number) < 13) then
      Exit;

   while (Length(Number) < 16) do
      Number := '0' + Number;

   Number := LowerCase(Trim(Number));

   TempChar := '0';
   StartPos := 1;

   for i := 1 to Length(Number) do
     if (Number[i] <> '0') then begin
       TempChar := Number[i];
       StartPos := i;
       BREAK;
     end;

   case CardType of
      ccVisa : if (TempChar <> '4') then
                  EXIT;
      ccDiscover : if (TempChar <> '6') then
                  EXIT;
      ccMasterCard : if (TempChar <> '5') then
                  EXIT;
      ccAmex : if (TempChar = '3') then begin
                  if (StartPos < Length(Number)) then begin
                     if (Number[StartPos + 1] <> '7') then
                        EXIT;
                  end else
                     EXIT;
               end else
                  EXIT;
      ccOther : ;
   end; { case }

   for i := 1 to 16 do
   begin
      TempChar := Number[i];
      SubSum := (Ord(TempChar) - 48) * (Ord(Mask[i]) - 48);
      if (SubSum > 9) then
         Dec(SubSum, 9);
      Inc(checkSum, SubSum);
   end;

   if ((CheckSum mod 10) <> 0) then
     EXIT;

   Result := TRUE;

end; { CartaoCredito }

function kLengthChar( const Text: TStringList): Integer;
var i: Integer;
begin
  Result := 0;
  for i := 0 to Text.Count-1 do  // Conta o numero de caracteres em Text
    Inc( Result, Length(Text[i]));
end;

function kLengthChar( const Text: array of String): Integer;
var i: Integer;
begin
  Result := 0;
  for i := Low(Text) to High(Text) do  // Conta o numero de caracteres em Text
    Inc( Result, Length(Text[i]));
end;

function kSpaceString( const Text: TStringList;
  const SpaceTotal: Integer; const SpaceString: Char = ' '):String;
var
  i, iLen, iCount, iDif, iInt: Integer;
begin

  iDif := 0;
  iInt := Text.Count-1;
  iLen := kLengthChar(Text);

  if (iLen = 0) then
    iCount := 0
  else if (SpaceTotal = 0) or (iLen > SpaceTotal) then
    iCount := 1
  else begin
    iCount := Trunc((SpaceTotal-iLen)/iInt);
    iDif   := (iCount*iInt);
  end;

  Result := '';

  for i := 0 to Text.Count-1 do
  begin
    Result := Result + Text[i] + StringOfChar( SpaceString, iCount);
    if (iDif > 0) then
    begin
      Dec(iDif);
      Result := Result + SpaceString;
    end;
  end;

  if (SpaceTotal > 0) then
    Result := Copy( Result, 1, SpaceTotal);

end;

function kSpaceString( const Text: array of String;
  const SpaceTotal: Integer; const SpaceString: Char = ' '): String;
var
  ListText: TStringList;
  i: Integer;
begin

  ListText := TStringList.Create;

  try
    ListText.BeginUpdate;
    for i := Low(Text) to High(Text) do
      ListText.Add(Text[i]);
    ListText.EndUpdate;
    Result := kSpaceString( ListText, SpaceTotal, SpaceString);
  finally
    ListText.Free;
  end;

end;

function kInputInt( const ACaption, APrompt: string;
  var Value: Integer): Boolean;
var
  sValue: String;
begin

  sValue := '';
  Result := False;

  while not Result do
  begin

    if not InputQuery( ACaption, APrompt, sValue) then
      Exit;

    try

      if (sValue = EmptyStr) then
        Value := 0
      else
        Value := StrToInt(sValue);

      Result := True;
      Break;

    except
      kErro('Número inválido. Informe novamente.');
    end;

  end;

end;  // kInputInt

function kInputCurrency( const ACaption, APrompt: string;
  var Value: Currency): Boolean;
var
  sValue: String;
begin

  sValue := CurrToStr(Value);
  Result := False;

  while not Result do
  begin

    if not InputQuery( ACaption, APrompt, sValue) then
      Exit;

    try

      if (sValue = EmptyStr) then
        Value := 0.0
      else begin
        if (DecimalSeparator = '.') then
          sValue := kSubstitui(sValue, ',', DecimalSeparator)
        else
          sValue := kSubstitui(sValue, '.', DecimalSeparator);
        Value := StrToCurr(sValue);
      end;

      Result := True;
      Break;

    except
      kErro('Valor inválido. Informe novamente.');
    end;

  end;

end;  // kInputCurrency

function kInputDate( ACaption, APrompt: string; var Value: TDateTime): Boolean;
var
  sData: String;
begin

  sData := DateToStr(Value);
  Result := False;

  while not Result do
  begin

    if (ACaption = EmptyStr) then
      ACaption := 'Entrada de dados';

    if not InputQuery( ACaption, APrompt, sData) or (sData = '') then
      Exit;

    try
      Value := StrToDate(sData);
      Result := True;
      Break;
    except
      kErro('Data inválida. Informe a data novamente.');
    end;

  end;

end;  // kInputDate

function kInputText( const ACaption, APrompt: string;
  var Value: String): Boolean;
var
  sValue: String;
begin

  sValue := '';
  Result := False;

  while not Result do
  begin

    if not InputQuery( ACaption, APrompt, sValue) then
      Exit;

    if (sValue = EmptyStr) then
      kErro('Texto não informado.')
    else
    begin
      Value := sValue;
      Result := True;
      Break;
    end;

  end;

end;  // kInputText

function kFormatCNPJ( const Numero:String):String;
begin
  Result := Numero;
  if (Length(Result) = 14) then
    Result := FormatMaskText( '99\.999\.999\-9999\/99;0', Result);
end;

function kFormatCEP( const Numero:String):String;
begin
  Result := Numero;
  if (Length(Result) = 8) then
    Result := FormatMaskText( '99\.999\-999;0', Result);
end;

function kFormatCPF( const Numero:String):String;
begin
  Result := Numero;
  if ( Length(Result) = 11 ) then
    Result := FormatMaskText( '999\.999\.999\-99;0', Result)
  else if ( Length(Result) = 14 ) then
    Result := FormatMaskText( '99\.999\.999\-9999\/99;0', Result);
end;

function kFormatPIS( const Numero:String):String;
begin
  Result := Numero;
  if ( Length(Result) = 11 ) then
    Result := FormatMaskText( '999\.99999\.99\-9;0', Result);
end;

function kFormatAgencia( const Numero:String):String;
begin
  Result := Numero;
  if ( Length(Result) = 5 ) then
    Result := FormatMaskText( '9999\-9;0', Result);
end;


function kFirstName(const Name:String):String;
var
  iPos: Integer;
begin
  Result := Name;
  iPos := Pos( ' ', Name);
  if (iPos > 0) then
    Result := Copy( Name, 1, iPos-1);
end;

end.
