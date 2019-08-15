{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

unit fdepvar;

{$I flivre.inc}

interface

uses
  {$IFDEF VLC}Forms, Controls,{$ENDIF}
  {$IFDEF CLX}QForms, QControls,{$ENDIF}
  Classes, SysUtils, Variants, RTLConsts;

type

  PDeposito = ^RDeposito;
  RDeposito = record
    Nome: String;
    Valor: Variant;
  end;

  TDeposito = class
  private
    { Private declarations }
    FList: TList;
    function GetCount: Integer;
    function Get(Index: Integer): PDeposito;
    procedure Put(Index: Integer; const Value: PDeposito);
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Assign( Source: TDeposito);
    function SetDeposito( Name: String; const Value: Variant):Variant;
    function GetDeposito( Name: String):Variant;
    function GetString( Name: String):String;
    function VarDeposito( Name:String; const Default:Variant):Variant;
    function IsDeposito( Name: String): Boolean;
    procedure Clear;
    property Items[Index: Integer]: PDeposito read Get write Put;
  published
    { Published declarations }
  end;

  TListNameVar = class
  private
    { Private declarations }
    FDeposito: TDeposito;
    function GetCount: Integer;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    procedure Append( Name: String; const Value: Variant);
    function IndexOf( Name: String): Variant;
    function Remove( Name: String): Variant;
    procedure Clear;
  published
    { Published declarations }
  end;

implementation

//*** Implementation TDepositoClass ***************

constructor TDeposito.Create;
begin
  inherited Create;
  FList := TList.Create;
end;

destructor TDeposito.Destroy;
begin
  Clear;
  FList.Free;
  inherited Destroy;
end;

procedure TDeposito.Clear;
var
 pItem: PDeposito;
 i: Integer;
begin

  for i := 0 to (FList.Count - 1) do
  begin
    pItem := FList.Items[i];
    Dispose(pItem);
  end;  // for

  FList.Clear;

end;

function TDeposito.GetCount(): Integer;
begin
  Result := FList.Count;
end;

function TDeposito.SetDeposito(  Name: String; const Value: Variant):Variant;
var
  pItem: PDeposito;
  i: Integer;
  bFound: Boolean;
begin

  Result := NULL;
  bFound := False;

  for i := 0 to FList.Count - 1 do
  begin
    pItem := FList.Items[i];
    bFound := ( UpperCase(pItem^.Nome) = UpperCase(Name) );
    if bFound then
    begin
      Result := pItem^.Valor;
      if VarIsNull(Value) then
      begin
        Dispose(pItem);
        FList.Delete(i);
      end else
        pItem^.Valor := Value;
      Break;
    end;  // if bFound;
  end;  // for

  if not bFound then
  begin
    New(pItem);
    pItem^.Nome  := Name;
    pItem^.Valor := Value;
    FList.Add(pItem);
  end; // if

end;  // function SetDeposito

function TDeposito.GetDeposito( Name: String):Variant;
var
 pItem: PDeposito;
 i: Integer;
begin

  Result := NULL;

  for i := 0 to FList.Count - 1 do
  begin
    pItem := FList.Items[i];
    if ( UpperCase(pItem^.Nome) = UpperCase(Name) ) then
    begin
      Result := pItem^.Valor;
      Break;
    end;  // if bFound;
  end;  // for

end;  // function GetDeposito

function TDeposito.VarDeposito( Name:String; const Default:Variant):Variant;
begin
  Result := GetDeposito(Name);
  if VarIsNull(Result) then
    Result := Default;
end;  // procedure VarDeposito

function TDeposito.IsDeposito(Name: String): Boolean;
begin
  Result := not VarIsNull( GetDeposito(Name));
end;

function TDeposito.GetString(Name: String): String;
begin
  Result := VarToStr( GetDeposito(Name) );
end;

function TDeposito.Get(Index: Integer): PDeposito;
begin
  Result := FList.Items[Index];
end;

procedure TDeposito.Put(Index: Integer; const Value: PDeposito);
begin
  FList.Insert( Index, Value);
end;

procedure TDeposito.Assign(Source: TDeposito);
var
  i: Integer;
begin

  if (Source = NIL) then Exit;
  Clear;
  for i := 0 to Source.FList.Count - 1 do
    SetDeposito( Source.Items[i].Nome, Source.Items[i].Valor)

end;

{ TListName }

constructor TListNameVar.Create;
begin
  inherited Create;
  FDeposito := TDeposito.Create;
end;

destructor TListNameVar.Destroy;
begin
  FDeposito.Free;
  inherited;
end;

procedure TListNameVar.Append(Name: String; const Value: Variant);
begin
  FDeposito.SetDeposito( Name, Value);
end;

function TListNameVar.GetCount: Integer;
begin
  Result := FDeposito.Count;
end;

function TListNameVar.IndexOf(Name: String): Variant;
begin
  Result := FDeposito.GetDeposito(Name);
end;

function TListNameVar.Remove(Name: String): Variant;
var
 pItem: PDeposito;
 i: Integer;
begin

  Result := NULL;

  for i := 0 to FDeposito.FList.Count - 1 do
  begin
    pItem := FDeposito.FList.Items[i];
    if ( UpperCase(pItem^.Nome) = UpperCase(Name) ) then
    begin
      Result := pItem^.Valor;
      FDeposito.FList.Delete(i);
      Break;
    end;  // if bFound;
  end;  // for

end;  // function Remove

procedure TListNameVar.Clear;
begin
  FDeposito.Clear;
end;

end.
