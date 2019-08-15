{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2002 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fdepstr;

{$I flivre.inc}

interface

uses
  Classes, SysUtils;

type

  PDepStr = ^RDepStr;

  RDepStr = record
    Nome: String;
    Valor: String;
  end;

  TDepStr = class
  private
    { Private declarations }
    FList: TList;
    function GetCount: Integer;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure SetValue( Name: String; const Value: String);
    function GetValue( Name:String; const Default:String = ''):String;
    function IsName(Name: String): Boolean;
    procedure Clear;
  end;

implementation

//*** Implementation TDepStr ***************

constructor TDepStr.Create;
begin
  FList := TList.Create;
end;

destructor TDepStr.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

function TDepStr.GetCount(): Integer;
begin
  Result := FList.Count;
end;

procedure TDepstr.SetValue( Name: String; const Value: String);
var
  pItem: PDepStr;
  i: Integer;
  bFound: Boolean;
begin

  bFound := False;

  for i := 0 to FList.Count - 1 do
  begin
    pItem := FList.Items[i];
    bFound := ( UpperCase(pItem^.Nome) = UpperCase(Name) );
    if bFound then
    begin
      if (Value = '') then
      begin
        Dispose(pItem);
        FList.Delete(i);
      end else
        pItem^.Valor := Value;
      Break;
    end;  // if bFound;
  end;  // for

  if (not bFound) and (Value <> '') then
  begin
    New(pItem);
    pItem^.Nome  := Name;
    pItem^.Valor := Value;
    FList.Add(pItem);
  end; // if

end;  // function SetDep

function TDepStr.GetValue( Name: String; const Default: String = ''):String;
var
 pItem: PDepStr;
 i: Integer;
begin

  Result := Default;

  for i := 0 to FList.Count - 1 do begin
    pItem := FList.Items[i];
    if ( UpperCase(pItem^.Nome) = UpperCase(Name) ) then begin
      Result := pItem^.Valor;
      Break;
    end;  // if bFound;
  end;  // for

end;  // function GetDep

function TDepStr.IsName(Name: String): Boolean;
begin
  Result := (GetValue(Name) <> '');
end;

procedure TDepStr.Clear;
var
 pItem: PDepStr;
 i: Integer;
begin

  for i := 0 to (FList.Count - 1) do
  begin
    pItem := FList.Items[i];
    Dispose(pItem);
  end;  // for

  FList.Clear;

end;

end.
