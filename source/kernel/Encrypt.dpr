program Encrypt;

uses
  Forms,
  Encrcom in 'ENCRCOM.PAS' {Form1},
  fencrypt in 'fencrypt.pas';

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
