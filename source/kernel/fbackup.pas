
unit fbackup;

{$I flivre.inc}

interface

uses
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Mask, IBServices, ComCtrls, ToolEdit, RXCtrls;

{$IFDEF IBX}
type
  TFrmBackup = class(TForm)
    Panel1: TPanel;
    Label2: TLabel;
    Edit2: TFilenameEdit;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    IBBackupService1: TIBBackupService;
    Animate1: TAnimate;
    RxSpeedButton1: TRxSpeedButton;
    Memo1: TMemo;
    procedure RxSpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
{$ENDIF}

{$IFDEF IBX}
procedure CriaBackup;
{$ENDIF}

implementation

{$R *.DFM}

uses fdb, fsystem, ftext, fsuporte, foption;

{$IFDEF IBX}
procedure CriaBackup;
begin

  with TFrmBackup.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;

end;

procedure TFrmBackup.RxSpeedButton1Click(Sender: TObject);
var
  sServer: String;
begin

  with IBBackupService1 do
  begin

    sServer := kGetOption('server');

    if (sServer = '') then
    begin
      Protocol   := Local;
      ServerName := 'localhost';
    end else begin
      Protocol   := TCP;
      ServerName := sServer;
    end;

    LoginPrompt  := kGetConnection.LoginPrompt;
    DatabaseName := kGetConnection.DatabaseName;

    Params.Assign( kGetConnection.Params);

    Active := True;

    try try

      Verbose := True;
      BackupFile.Add(Edit2.Text);

      Animate1.CommonAVI := aviCopyFiles;
      Animate1.Active    := True;

      ServiceStart;

      while not Eof do
        Memo1.Lines.Add(GetNextLine);

      Animate1.Active := False;

      kAviso('Backup concluído com sucesso !!!');

    except
      on E:Exception do
        kErro(E.Message, 'fbackup', 'CriaBackup()');
    end;
    finally
      Animate1.Active := False;
      Active := False;
    end;

  end;

  Close;

end;

procedure TFrmBackup.FormCreate(Sender: TObject);
var
  sBaseName, sFileName, sDirName: String;
begin

  sBaseName := kGetConnection.DatabaseName;

  if (kGetSystem( 'BACKUP_INFORMAR', '1') <> '1') then
  begin
    Edit2.Enabled     := False;
    Edit2.ParentColor := True;
  end;

  // Pasta onde o arquivo de backup será gravado, referente ao servidor
  sDirName  := kGetSystem( 'BACKUP_LOCAL', sBaseName);
  sDirName  := ExtractFilePath(sDirName);

  sFileName := ExtractFileName(sBaseName);
  sFileName := ChangeFileExt( sFileName, '-'+FormatDateTime( 'dd-mm-yyyy', Date())+'.gbk');

  if (sDirName[Length(sDirName)] <> PathDelim) then
    sDirName := sDirName + PathDelim;

  Edit2.FileName := sDirName + sFileName;
  RxSpeedButton1.Font.Style := RxSpeedButton1.Font.Style + [fsBold];

end;

{$ENDIF}

end.
