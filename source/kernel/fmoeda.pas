{
FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002 Allan Kardek Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

unit fmoeda;

interface

uses SysUtils, Classes;

function kParcela( const Valor: Currency; Numero: Integer;
  var Parcela1, Parcela2: Currency):Boolean;stdcall;
function kArredonda( AValue:Extended; ALen:Integer):Extended;
function kExtenso( Valor: Currency): String;

implementation

function kParcela( const Valor: Currency; Numero: Integer;
  var Parcela1, Parcela2: Currency):Boolean;
var
  cParcela, cTotal: Currency;
begin

  Result   := False;
  Parcela1 := 0.00;
  Parcela2 := 0.00;

  if (Valor <= 0.00) or (Numero <= 0) then
    Exit;

  cParcela := kArredonda( (Valor/Numero), 2);  //  Calcula as parcelas
  cTotal   := (cParcela * Numero);            //  Faz a operação inversa

  Parcela1 := cParcela;
  Parcela2 := cParcela;

  if (Valor > cTotal) then    // As parcelas nao sao iguais
    Parcela1 := cParcela+(Valor-cTotal);

  Result := True;

end;

// Esta função arredonda conforme casas decimais (ALen)
function kArredonda( AValue:Extended; ALen:Integer):Extended;
begin
  Result := StrToFloat( Format( '%0.'+IntToStr(ALen)+'f', [AValue]));
end;

{ escreve por extenso um numero entre 0 e 999 }
function TrataGrupo(const S: String): String;
const
  Num1a19: array [1..19] of String = (
    'UM', 'DOIS', 'TRÊS', 'QUATRO', 'CINCO',
    'SEIS', 'SETE', 'OITO', 'NOVE', 'DEZ',
    'ONZE', 'DOZE', 'TREZE', 'CATORZE', 'QUINZE',
    'DEZESSEIS', 'DEZESSETE', 'DEZOITO', 'DEZENOVE');

  Num10a90: array [1..9] of String = (
    'DEZ', 'VINTE', 'TRINTA', 'QUARENTA', 'CINQUENTA',
    'SESSENTA', 'SETENTA', 'OITENTA', 'NOVENTA');

  Num100a900: array [1..9] of String = (
    'CENTO', 'DUZENTOS', 'TREZENTOS', 'QUATROCENTOS', 'QUINHENTOS',
    'SEISCENTOS', 'SETECENTOS', 'OITOCENTOS', 'NOVECENTOS');
var
  N: Integer;

  function Trata0a99(const S: String; N: Integer): String;
  begin
    case N of
      0:      Result := '';
      1..19:  Result := Num1a19[N];
      20..99: begin
        Result := Num10a90[Ord(S[1]) - Ord('0')];
        if S[2] <> '0' then
          Result := Result + ' E ' + Num1a19[Ord(S[2]) - Ord('0')];
      end;
    end;
  end;

  function Trata101a999(const S: String; N: Integer): String;
  var
    Aux: String[3];
  begin
    Result := Num100a900[Ord(S[1]) - Ord('0')];
    if (S[2] <> '0') or (S[3] <> '0') then begin
      Aux := Copy(S, 2, 2);
      Result := Result + ' E ' + Trata0a99(Aux, StrToInt(Aux));
    end;
  end;

begin
  N := StrToInt(S);
  case N of
    0..99: Result := Trata0a99(IntToStr(N), N);
    100: Result := 'CEM';
    101..999: Result := Trata101a999(S, N);
  end;
end;

function kExtenso( Valor: Currency): String;
var
  Lst: TStringList;
  I: Integer;
  Aux, Grupo: String;
  Truncado: Longint;
begin
  Lst := nil;
  Result := '';
  try
    if Valor = 0.0 then begin
      Result := 'ZERO REAIS';
      Exit;
    end;
    Lst := TStringList.Create;
    Grupo := '';
    Aux := FormatFloat( '#,##0.00', Valor);

    // separa em grupos
    for I := 1 to Length(Aux) do
      if (Aux[I] = '.') or (Aux[I] = ',') then begin
        Lst.Add(Grupo);
        Grupo := '';
      end else
        Grupo := Grupo + Aux[I];

    Lst.Add(Grupo); // inclui o ultimo grupo

    // trata os bilhoes
    I := 0;
    if Lst.Count > 4 then begin
      Result := TrataGrupo(Lst[I]);
      if StrToInt(Lst[I]) = 1 then
        Result := Result + ' BILHÃO'
      else
        Result := Result + ' BILHÕES';
      Inc(I);
    end;

    // trata os milhoes
    if (Lst.Count > 3) then begin
      if StrToInt(Lst[I]) <> 0 then begin
        if Length(Result) > 0 then
          Result := Result + ', ';
        Result := Result + TrataGrupo(Lst[I]);
        if StrToInt(Lst[I]) = 1 then
          Result := Result + ' MILHÃO'
        else
          Result := Result + ' MILHÕES';
      end;
      Inc(I);
    end;

    // trata os milhares
    if Lst.Count > 2 then
    begin
      if StrToInt(Lst[I]) <> 0 then begin
        if Length(Result) > 0 then
          Result := Result + ', ';
        Result := Result + TrataGrupo(Lst[I]);
        Result := Result + ' MIL';
      end;
      Inc(I);
    end;

    // trata as unidades
    if StrToInt(Lst[I]) > 0 then begin
      if Length(Result) > 0 then
        Result := Result + ' E ';
      Result := Result + TrataGrupo(Lst[I]);
    end;
    Truncado := Trunc(Valor);
    if Truncado = 1 then
      Result := Result + ' REAL'
    else if (Truncado = 1000000) or
            (Truncado = 10000000) or
            (Truncado = 100000000) or
            (Truncado = 1000000000) then
      Result := Result + ' DE REAIS'
    else if Truncado <> 0 then
      Result := Result + ' REAIS';
    Inc(I);

    // trata os centavos
    if StrToInt(Lst[I]) = 0 then Exit;

    if Truncado > 0 then Result := Result + ', ';

    Result := Result + TrataGrupo(Lst[I]);

    if StrToInt(Lst[I]) = 1
     then Result := Result + ' ' + 'CENTAVO'
     else Result := Result + ' ' + 'CENTAVOS';

    if Truncado = 0 then
      Result := Result + ' DE REAL';

  finally
    // trata tipo texto
    Result := AnsiLowerCase(Result);
    if Lst <> nil then Lst.Free;
  end;
end;

end.
