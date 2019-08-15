{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002, Allan Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

{$IFNDEF QDIALOGO}
unit fdialogo;
{$ENDIF}

{$I flivre.inc}

interface

uses
  Classes, SysUtils,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs,
  QExtCtrls, QStdCtrls, QDBCtrls, QMask, QGrids, QDBGrids,
  QComCtrls, QButtons, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Mask, Grids, DBGrids,
  ComCtrls, Buttons, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Types, fbase, DB, DBClient;

type
  TFrmDialogo = class(TFrmBase)
    dbgRegistro: TDBGrid;
    Panel: TPanel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnImprimirClick(Sender: TObject);
    procedure PanelExit(Sender: TObject);
    procedure dbgRegistroTitleClick(Column: TColumn);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses {$IFDEF VCL}fprint,{$ENDIF} fdb, ftext, fsuporte;

{$R *.dfm}

procedure TFrmDialogo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) and (kGetLastTabOrder(Panel) = ActiveControl) and
     (pvDataSet.State in [dsInsert,dsEdit]) then
    Key := VK_F3;
  inherited;
end;

procedure TFrmDialogo.btnImprimirClick(Sender: TObject);
begin
  {$IFDEF VCL}
  kPrintGrid( dbgRegistro, UpperCase(kRetira( RxTitulo.Caption, ' � ')), False, NIL);
  {$ENDIF}
end;

procedure TFrmDialogo.PanelExit(Sender: TObject);
begin
  if btnGravar.Enabled then btnGravar.Click;
end;

procedure TFrmDialogo.dbgRegistroTitleClick(Column: TColumn);
begin
  kTitleClick( TDBGrid(Column.Grid), Column, nil);
end;

procedure TFrmDialogo.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State,
                   TWinControl(Sender).Focused);
end;

procedure TFrmDialogo.mtRegistroBeforeInsert(DataSet: TDataSet);
var
  pControl: TControl;
begin
  if Panel.Enabled and Panel.Visible then
  begin
    pControl := kGetFirstTabOrder(Panel);
    if Assigned(pControl) and (pControl is TWinControl) then
      TWinControl(pControl).SetFocus;
  end;
  inherited;
end;

procedure TFrmDialogo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  if Assigned(DataSet.BeforeInsert) then
    DataSet.BeforeInsert(DataSet)
  else
    inherited;
end;

end.
