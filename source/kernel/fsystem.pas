{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (C) 2002-2009 Allan Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.
}

{$IFNDEF NO_FSYSTEM}
unit fsystem;
{$ENDIF}

{$IFNDEF NO_FLIVRE}
  {$I flivre.inc}
{$ENDIF}

interface

uses Classes, {$IFDEF FL_MIDASLIB}Midas,{$ENDIF} DBClient, SysUtils;

procedure kLoadSystem;
function kGetSystem(const Name: String; const Default:String=''):String; overload;
procedure kSetSystem(const Name, Value:String);

implementation

uses fdb, ftext;

var
  lSystem: TStringList;

procedure kLoadSystem;
var
  ds: TClientDataSet;
  sLocal, sChave, sValor: String;
begin

  lSystem.Clear;

  ds := TClientDataSet.Create(NIL);

  try

    if kSQLSelectFrom( ds, 'SYSTEM', 'ATIVO = 1') then
    begin
      ds.First;
      while not ds.EOF do
      begin
        sLocal := ds.FieldByName('LOCAL').AsString;
        sChave := ds.FieldByName('CHAVE').AsString;
        sValor := ds.FieldByName('VALOR').AsString;
        if (sChave <> EmptyStr) then
          sLocal := sLocal+'_'+sChave;
        lSystem.Values[sLocal] := sValor;
        ds.Next;
      end;
    end;

  finally
    ds.Free;
  end;

end;

procedure kSetSystem(const Name, Value: String);
var
  sLocal, sChave, sWhere: String;
  iPos: Integer;
  bSucess: Boolean;
begin

  iPos := Pos('_', Name);

  sLocal := Name;
  sChave := '';

  if (iPos > 0) then
  begin
    sLocal := Copy( Name, 1, iPos-1);
    sChave := Copy( Name, iPos+1, Length(Name));
  end;

  sWhere := 'LOCAL = :L AND CHAVE = :C';

  if (kCountSQL('SYSTEM', sWhere, [sLocal, sChave]) = 0) then
    bSucess := kExecSQL('INSERT INTO SYSTEM (LOCAL, CHAVE, VALOR, ATIVO)'#13+
                        'VALUES (:L, :C, :V, 1)', [sLocal, sChave, Value])
  else
    bSucess := kExecSQL('UPDATE SYSTEM SET VALOR = :V WHERE '+sWhere,
                        [Value, sLocal, sChave]);

  if bSucess then
    lSystem.Values[Name] := Value;

end;  // kSetSystem

function kGetSystem(const Name: String; const Default:String=''):String;
var
  i: Integer;
begin

  if (lSystem.Count = 0) then
    kLoadSystem;

  i := lSystem.IndexOfName(Name);

  Result := Default;

  if (i = -1) then
    Result := Default
  else
    Result := lSystem.ValueFromIndex[i];

end;  // kGetSystem

initialization
  lSystem := TStringList.Create;

finalization
  lSystem.Free;

end.
