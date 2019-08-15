{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (C) 2005,2006,2007 Allan Lima

O FolhaLivre é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

unit splash;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls, QButtons,
  QTypes, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons,
  Types, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  SysUtils, Classes;

type

  TSplashForm = class(TForm)
  private
    { Private declarations }
    FBitmap: TBitmap;
    FFileName: TFileName;

    FVersion: TLabel;
    FCopyright: TLabel;
    FLicense: TLabel;

    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);

    procedure SetFileName( Value: TFileName);

    function GetVersion: String;
    procedure SetVersion( Value: String);
    function GetVersionLink: String;
    procedure SetVersionLink( Value: String);

    function GetCopyright: String;
    procedure SetCopyright( Value: String);
    function GetCopyrightLink: String;
    procedure SetCopyrightLink( Value: String);

    function GetLicense: String;
    procedure SetLicense( Value: String);
    function GetLicenseLink: String;
    procedure SetLicenseLink( Value: String);

  public
    { Public declarations }
    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;

  published

    property FileName: TFileName read FFileName write SetFileName;

    property Version: String read GetVersion write SetVersion;
    property VersionLink: String read GetVersionLink write SetVersionLink;

    property Copyright: String read GetCopyright write SetCopyright;
    property CopyrightLink: String read GetCopyrightLink write SetCopyrightLink;

    property License: String read GetLicense write SetLicense;
    property LicenseLink: String read GetLicenseLink write SetLicenseLink;

  end;

var
  SplashForm: TSplashForm;

implementation

constructor TSplashForm.CreateNew(AOwner: TComponent; Dummy: Integer = 0);
begin

  inherited CreateNew( AOwner, Dummy);

  FBitmap := TBitmap.Create;

  BorderStyle  := bsNone;
  FormStyle    := fsStayOnTop;

  // Programa - versão

  {$IFDEF AK_LABEL}
  FVersion := TAKLabel.Create(Self);
  {$ELSE}
  FVersion := TLabel.Create(Self);
  {$ENDIF}

  FVersion.Parent      := Self;
  FVersion.Transparent := True;
  FVersion.Top         := 10;
  FVersion.Left        := 10;

  FVersion.Cursor      := crHandPoint;
  FVersion.Font.Color  := clGreen;
  FVersion.Font.Style  := [fsBold];

  // Copyright

  {$IFDEF AK_LABEL}
  FCopyright := TAKLabel.Create(Self);
  {$ELSE}
  FCopyright := TLabel.Create(Self);
  {$ENDIF}

  FCopyright.Parent      := Self;
  FCopyright.Transparent := True;
  FCopyright.Left        := FVersion.Left;
  FCopyright.Cursor      := FVersion.Cursor;

  // License

  {$IFDEF AK_LABEL}
  FLicense := TAKLabel.Create(Self);
  {$ELSE}
  FLicense := TLabel.Create(Self);
  {$ENDIF}

  FLicense.Parent      := Self;
  FLicense.Transparent := True;
  FLicense.Cursor      := FVersion.Cursor;

  {$IFDEF FLIVRE}
  SetVersion(Application.Title);
  SetVersionLink('http://folha-livre.sf.net');
  SetCopyright('Copyright (C) 2002-2007 Allan Lima.');
  SetCopyrightLink('allan_kardek@yahoo.com.br');
  SetLicense('Este programa é distribuído sobre os termos da GNU GPL.');
  SetLicenseLink('http://www.gnu.org/gnu-gpl');
  {$ENDIF}

  // Events

  OnClose   := FormClose;
  OnPaint   := FormPaint;
  OnDestroy := FormDestroy;
  OnMouseUp := FormMouseUp;
  OnKeyDown := FormKeyDown;
  OnShow    := FormShow;

end;

procedure TSplashForm.FormPaint(Sender: TObject);
begin

  if Assigned(FBitmap) then
  begin

    Canvas.Draw( 0, 0, FBitmap);

    {$IFDEF LINUX}
    Canvas.Font.Name   := 'Nimbus Sans L';
    Canvas.Font.Size   := 10;
    {$ELSE}
    Canvas.Font.Name   := 'Arial';
    {$ENDIF}

  end;

end;

procedure TSplashForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ModalResult := mrAbort;
end;

procedure TSplashForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ModalResult := mrAbort;
end;

procedure TSplashForm.FormShow(Sender: TObject);
var
  sFileName: TFileName;

  {$IFDEF AK_LABEL}
  procedure SetAKLabel( TextLabel: TLabel);
  begin
    with TAKLabel(TextLabel) do
    begin
      MouseEffectEnter.Enabled     := True;
      MouseEffectEnter.Frame       := False;
      MouseEffectEnter.ParentColor := False;
      MouseEffectEnter.ParentFont  := False;
      MouseEffectEnter.Font.Color  := clBlue;
      MouseEffectEnter.Font.Style  := [fsUnderline];

      MouseEffectLeave.Enabled     := True;
      MouseEffectLeave.Frame       := False;
    end;
  end;
  {$ENDIF}

begin

  if (FFileName <> '') then
    sFileName := FFileName
  else
    sFileName := 'splashscreen';

  // Não foi especificado a pasta, considera a pasta do programa

  if (sFileName = ExtractFileName(sFileName)) then
    sFileName := ExtractFilePath(Application.ExeName)+sFileName;

  FBitmap.LoadFromFile(sFileName);

  ClientWidth  := FBitmap.Width;
  ClientHeight := FBitmap.Height;
  Top          := (Screen.Height-ClientHeight) div 2;
  Left         := (Screen.Width-ClientWidth) div 2;

  {$IFDEF AK_LABEL}
  SetAKLabel(FVersion);

  with TAKLabel(FVersion) do
  begin
    MouseEffectEnter.Font.Assign(FVersion.Font);
    MouseEffectEnter.Font.Style := MouseEffectEnter.Font.Style + [fsUnderline];
    MouseEffectLeave.ParentFont := False;
    MouseEffectLeave.Font.Assign(FVersion.Font);
  end;
  {$ENDIF}

  FCopyright.Top  := ClientHeight - 10 - Canvas.TextHeight('P');

  {$IFDEF AK_LABEL}
  SetAKLabel(FCopyright);
  {$ENDIF}

  FLicense.Top  := FCopyright.Top;
  FLicense.Left := ClientWidth - 10 - Canvas.TextWidth(FLicense.Caption);

  {$IFDEF AK_LABEL}
  SetAKLabel(FLicense);
  {$ENDIF}

end;

procedure TSplashForm.FormDestroy(Sender: TObject);
begin
  FBitmap.Free;
end;

procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

{ Version }

function TSplashForm.GetVersion: String;
begin
  Result := FVersion.Caption;
end;

procedure TSplashForm.SetVersion(Value: String);
begin
  if (FVersion.Caption <> Value) then
    FVersion.Caption := Value;
end;

function TSplashForm.GetVersionLink: String;
begin
  Result := FVersion.Hint;
end;

procedure TSplashForm.SetVersionLink(Value: String);
begin
  if (FVersion.Hint <> Value) then
  begin
    FVersion.Hint := Value;
    FVersion.ShowHint := (Value <> '');
    {$IFDEF AK_LABEL}
    TAKLabel(FVersion).URL := Value;
    {$ENDIF}
  end;
end;

{ Copyright }

function TSplashForm.GetCopyright: String;
begin
  Result := FCopyright.Caption;
end;

procedure TSplashForm.SetCopyright(Value: String);
begin
  if (FCopyright.Caption <> Value) then
    FCopyright.Caption := Value;
end;

function TSplashForm.GetCopyrightLink: String;
begin
  Result := FCopyright.Hint;
end;

procedure TSplashForm.SetCopyrightLink(Value: String);
begin
  if (FCopyright.Hint <> Value) then
  begin
    FCopyright.Hint := Value;
    FCopyright.ShowHint := (Value <> '');
    {$IFDEF AK_LABEL}
    TAKLabel(FCopyright).URL := Value;
    {$ENDIF}
  end;
end;

{ License }

function TSplashForm.GetLicense: String;
begin
  Result := FLicense.Caption;
end;

procedure TSplashForm.SetLicense(Value: String);
begin
  if (FLicense.Caption <> Value) then
    FLicense.Caption := Value;
end;

function TSplashForm.GetLicenseLink: String;
begin
  Result := FLicense.Hint;
end;

procedure TSplashForm.SetLicenseLink(Value: String);
begin
  if (FLicense.Hint <> Value) then
  begin
    FLicense.Hint := Value;
    FLicense.ShowHint := (Value <> '');
    {$IFDEF AK_LABEL}
    TAKLabel(FLicense).URL := Value;
    {$ENDIF}
  end;
end;

procedure TSplashForm.SetFileName(Value: TFileName);
begin
   if (FFileName <> Value) then
     FFileName := Value;
end;

end.
