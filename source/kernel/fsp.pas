unit fsp;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QMenus,
  QGrids, QDBGrids, QComCtrls, QStdCtrls, QExtCtrls, QButtons, QMask, QDBCtrls, QAKLabel,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Menus,
  Grids, DBGrids, ComCtrls, StdCtrls, ExtCtrls, Buttons, Mask, DBCtrls, AKLabel,
  {$ENDIF}
  {$IFDEF IBX}
  IBCustomDataSet, IBStoredProc,
  {$ENDIF}
  SysUtils, Variants, Classes, DB, DBClient, MidasLib, fcadastro;

type
  TFrmSP = class(TFrmCadastro)
    spRegistro: TIBStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure FrmBtnControlePadrao( Operacao: String); override;
    procedure FrmDetalharClient; override;
  end;

implementation

uses ftext, fsuporte;

{$R *.dfm}

{ TFrmSP }

procedure TFrmSP.FrmBtnControlePadrao(Operacao: String);
begin
  kBtnControle( Self, Operacao, mtListagem, mtRegistro, spRegistro);
end;

procedure TFrmSP.FrmDetalharClient;
begin
  kDetalhar( Self, mtListagem, mtRegistro,
             spRegistro, PesquisaValor.Text, pvSELECT,
             mtPesquisa.Fields[1].AsString );
end;

end.
