{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (C) 2002 Allan Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fdeposito;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}QForms, QControls,{$ENDIF}
  {$IFDEF VCL}Forms, Controls,{$ENDIF}
  {$IFDEF FL_D6}Variants,{$ENDIF}
  Classes, SysUtils, fdepstr;

procedure kSetDeposito( Name: String; const Value: String = '');{$IFDEF FL_D6}overload;{$ENDIF}
{$IFDEF FL_D6}
procedure kSetDeposito( Name: String; const Value: Variant); overload;
{$ENDIF}
function kGetDeposito( Name: String; const Default: String = ''):String;
function kIsDeposito( Name: String): Boolean;
procedure kFrmDeposito( Frm: TForm);
procedure kFreeDeposito;

implementation

var
  lDeposito: TDepStr;

procedure kSetDeposito( Name: String; const Value: String = '');
begin
  if not Assigned(lDeposito) then
    lDeposito := TDepStr.Create;
  lDeposito.SetValue( Name, Value);
end;

{$IFDEF FL_D6}
procedure kSetDeposito( Name: String; const Value: Variant);
begin
  if not Assigned(lDeposito) then
    lDeposito := TDepStr.Create;
  lDeposito.SetValue( Name, VarToStr(Value));
end;
{$ENDIF}

function kGetDeposito( Name: String; const Default: String = ''):String;
begin
  Result := Default;
  if Assigned(lDeposito) then
    Result := lDeposito.GetValue(Name, Default);
end;

function kIsDeposito( Name: String): Boolean;
begin
  Result := lDeposito.IsName(Name);
end;

procedure kFreeDeposito;
begin
  lDeposito.Free;
end;  // proc kFreeDeposito

procedure kFrmDeposito( Frm: TForm);
var
  i: Integer;
  sName: String;
  sAutorizacao: String[1];
begin
  for i := 0 to (Frm.ComponentCount - 1) do
    if (Frm.Components[i] is TControl) then
      with TControl(Frm.Components[i]) do
      begin
        sName := Frm.Name+'_'+Name;
        if lDeposito.IsName(sName) then
        begin
          sAutorizacao := lDeposito.GetValue( sName, '3');
          Enabled := (sAutorizacao = '0');
          Visible := (sAutorizacao <> '2');
        end;
      end; // with TControl
end;  // proc FrmDeposito

end.

