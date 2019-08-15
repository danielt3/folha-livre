{
fprogress.pas - Formul�rio com barra de progresso
Copyright (C) 2003, Allan Kardek N Lima, Brasil.

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

Autor(es): Allan Kardek Neponuceno Lima
E-mail: allan_kardek@yahoo.com.br / allan-kardek@bol.com.br
}

unit fprogress;

{$I flivre.inc}

interface

uses
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls,
  ExtCtrls, Gauges,
  {$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls,
  QComCtrls,
  {$ENDIF}
  SysUtils, Classes;

type

  TFrmProgress = class(TForm)
  private
    FGauge:{$IFDEF VCL}TGauge{$ENDIF}
           {$IFDEF CLX}TProgressBar{$ENDIF};
    FLabel: TLabel;
    FProcessMessages: Boolean;
    FRate: Double;
    function GetMaxValue: Longint;
    procedure SetMaxValue( Value: Longint);
    function GetMessage:String;
    procedure SetMessage( Value: String);
    function GetProgress: Longint;
    procedure SetProgress( Value: Longint);
    procedure CreateDialog;
  public
    property Mensagem: String read GetMessage write SetMessage;
    property Bar:{$IFDEF VCL}TGauge{$ENDIF}
                 {$IFDEF CLX}TProgressBar{$ENDIF} read FGauge;
    property Rotulo: TLabel read FLabel;
    property Progress: Longint read GetProgress write SetProgress;
    procedure AddProgress( Value: Integer);
    property MaxValue: Longint read GetMaxValue write SetMaxValue;
    property ProcessMessages: Boolean read FProcessMessages write FProcessMessages;
  end;

function CriaProgress( const Title: String = ''; Messages: Boolean = False): TFrmProgress;

implementation

function CriaProgress( const Title: String = ''; Messages: Boolean = False): TFrmProgress;
begin

  Result := TFrmProgress.CreateNew(Application);

  with Result do
  begin
    if (Title = '') then
      Caption := 'Aguarde. Processando...'
    else
      Caption := Title;
    FormStyle := fsStayOnTop;
    CreateDialog;
    FProcessMessages := Messages;
    Show;
  end;

end;

{ TFrmProgress }

procedure TFrmProgress.CreateDialog;
begin

  {$IFDEF VCL}
  Ctl3D := False;
  BorderStyle := bsToolWindow;// bsDialog;
  {$ENDIF}
  {$IFDEF CLX}
  BorderStyle := fbsToolWindow;// bsDialog;
  {$ENDIF}
  Color := clBtnFace;

  BorderIcons := BorderIcons - [biSystemMenu];
  FRate := Canvas.TextWidth('W')/11;
  Position := poScreenCenter;

  ClientHeight := Round(FRate * 50);
  ClientWidth  := Round(FRate * 400);

  FGauge := {$IFDEF VCL}TGauge.Create(Self){$ENDIF}
            {$IFDEF CLX}TProgressBar.Create(Self){$ENDIF};

  FGauge.Parent := Self;
  FGauge.Align  := alBottom;
  FGauge.Height := Trunc(ClientHeight/2);

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Align  := alClient;
  FLabel.Alignment := taCenter;
  FLabel.Layout := tlCenter;

  FProcessMessages := False;

end;

function TFrmProgress.GetMessage:String;
begin
  Result := FLabel.Caption;
end;

procedure TFrmProgress.SetMessage( Value: String);
begin
  FLabel.Caption := Value;
  if FProcessMessages then
    Application.ProcessMessages;
end;

function TFrmProgress.GetProgress: Longint;
begin
  Result := {$IFDEF VCL}FGauge.Progress{$ENDIF}
            {$IFDEF CLX}FGauge.Position{$ENDIF};
end;

procedure TFrmProgress.SetProgress(Value: Integer);
begin
  {$IFDEF VCL}FGauge.Progress := Value;{$ENDIF}
  {$IFDEF CLX}FGauge.Position := Value;{$ENDIF}
  Self.Show;
  if FProcessMessages then
    Application.ProcessMessages;
end;

procedure TFrmProgress.AddProgress(Value: Integer);
begin
  {$IFDEF VCL}FGauge.Progress := FGauge.Progress + Value;{$ENDIF}
  {$IFDEF CLX}FGauge.Position := FGauge.Position + Value;{$ENDIF}
  Self.Show;
  if FProcessMessages then
    Application.ProcessMessages;
end;

function TFrmProgress.GetMaxValue: Longint;
begin
  Result := {$IFDEF VCL}FGauge.MaxValue{$ENDIF}
            {$IFDEF CLX}FGauge.Max{$ENDIF};
end;

procedure TFrmProgress.SetMaxValue(Value: Integer);
begin
  {$IFDEF VCL}FGauge.MaxValue := Value;{$ENDIF}
  {$IFDEF CLX}FGauge.Max := Value;{$ENDIF}
end;

end.
