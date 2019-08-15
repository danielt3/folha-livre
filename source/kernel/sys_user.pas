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

autor(s): Allan Lima
email: allan_kardek@yahoo.com.br / folha_livre@yahoo.com.br
}

unit sys_user;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls, QDBCtrls,
  QMask, QGrids, QDBGrids, QComCtrls, QButtons, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, DBCtrls,
  Mask, Grids, DBGrids, ComCtrls, Buttons, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fbase, DBClient, DB;

type
  Tfrmsysuser = class(TFrmBase)
    PageControl1: TPageControl;
    dbgRegistro: TDBGrid;
    Panel: TPanel;
    lbLogin: TLabel;
    lbChave: TLabel;
    dbLogin: TDBEdit;
    dbChave: TDBEdit;
    lbValor: TLabel;
    dbValor: TDBEdit;
    dbAtivo: TDBCheckBox;
    mtRegistroLOGIN: TStringField;
    mtRegistroCHAVE: TStringField;
    mtRegistroVALOR: TStringField;
    mtRegistroATIVO: TSmallintField;
    procedure PanelExit(Sender: TObject);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

procedure CriaSysUser();

implementation

uses ftext, fsuporte, fdb;

{$R *.dfm}

procedure CriaSysUser();
var
  Frm: Tfrmsysuser;
begin

  Frm := Tfrmsysuser.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'SYS_USER';
      Iniciar();
      ShowModal;
    end;
  finally
    Frm.Free;
  end;

end;  // procedure

procedure Tfrmsysuser.Iniciar;
begin
  dbLogin.Font.Style := dbLogin.Font.Style + [fsBold];
  dbChave.Font.Assign(dbLogin.Font);
  inherited;
end;

procedure Tfrmsysuser.PanelExit(Sender: TObject);
begin
  if btnGravar.Enabled then btnGravar.Click;
end;

procedure Tfrmsysuser.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := DataSet.FieldByName('CHAVE').AsString;
  if not kConfirme( 'Excluir a Chave '+QuotedStr(sNome)+' ?') then
    SysUtils.Abort;
  inherited;
end;

procedure Tfrmsysuser.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('ATIVO').AsInteger := 1;
end;

procedure Tfrmsysuser.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbLogin.SetFocus;
end;

procedure Tfrmsysuser.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbLogin.Enabled := True;
  dbLogin.Enabled := True;
  lbChave.Enabled := True;
  dbChave.Enabled := True;
end;

procedure Tfrmsysuser.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbValor.SetFocus;
  lbLogin.Enabled := False;
  dbLogin.Enabled := False;
  lbChave.Enabled := False;
  dbChave.Enabled := False;
end;

procedure Tfrmsysuser.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if (Column.Field.DataSet.FieldByName('ATIVO').AsInteger = 0) then
    TDBGrid(Sender).Canvas.Font.Color := clRed;
  kDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

end.
