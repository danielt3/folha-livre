{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002, Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

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
  kPrintGrid( dbgRegistro, UpperCase(kRetira( RxTitulo.Caption, ' · ')), False, NIL);
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
