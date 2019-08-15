{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (C) 2002 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

autor(s): Allan Kardek Neponuceno Lima
email: allan_kardek@yahoo.com.br / folha_livre@yahoo.com.br
}
unit sys_empresa;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs,
  QGrids, QDBGrids, QComCtrls, QButtons, QMask, QStdCtrls,
  QExtCtrls, QDBCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ComCtrls, Buttons, Mask, StdCtrls,
  ExtCtrls, DBCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Variants, fcadastro, DB, DBClient, fbase, Types;

type
  Tfrmsysempresa = class(TFrmBase)
    PageControl1: TPageControl;
    dbgRegistro: TDBGrid;
    Panel: TPanel;
    lbChave: TLabel;
    dbChave: TDBEdit;
    lbValor: TLabel;
    dbValor: TDBEdit;
    dbAtivo: TDBCheckBox;
    mtRegistroCHAVE: TStringField;
    mtRegistroVALOR: TStringField;
    mtRegistroATIVO: TSmallintField;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PanelExit(Sender: TObject);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure dbgRegistroTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgRegistroTitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

procedure CriaSysEmpresa();

implementation

uses ftext, fsuporte, fdb, fempresa;

{$R *.DFM}

procedure CriaSysEmpresa();
var
  Frm: Tfrmsysempresa;
begin

  Frm := Tfrmsysempresa.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'SYS_EMPRESA';
      Iniciar();
      ShowModal;
    end;
  except
    on E: Exception do
      kErro( E.Message, 'sys_empresa.pas', 'CriaSysEmpresa()');
  end;

end;  // procedure

procedure Tfrmsysempresa.Iniciar;
begin
  dbChave.Font.Style := dbChave.Font.Style + [fsBold];
  inherited;
end;

procedure Tfrmsysempresa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  kOpenEmpresa();
end;

procedure Tfrmsysempresa.PanelExit(Sender: TObject);
begin
  if btnGravar.Enabled then btnGravar.Click;
end;

procedure Tfrmsysempresa.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := DataSet.FieldByName('CHAVE').AsString;
  if not kConfirme( 'Excluir a Chave '+QuotedStr(sNome)+' ?') then
    SysUtils.Abort;
  inherited;
end;

procedure Tfrmsysempresa.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('ATIVO').AsInteger := 1;
end;

procedure Tfrmsysempresa.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbChave.SetFocus;
end;

procedure Tfrmsysempresa.dbgRegistroTitleBtnClick(Sender: TObject; ACol: Integer;
  Field: TField);
begin
  kTitleBtnClick(Field);
end;

procedure Tfrmsysempresa.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbChave.Enabled := False;
  dbValor.SetFocus;
end;

procedure Tfrmsysempresa.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  dbChave.Enabled := True;
end;

procedure Tfrmsysempresa.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  if (Column.Field.DataSet.FieldByName('ATIVO').AsInteger = 0) then
    TDBGrid(Sender).Canvas.Font.Color := clRed;
  kDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure Tfrmsysempresa.dbgRegistroTitleClick(Column: TColumn);
begin
  kTitleClick( TDBGrid(Column.Grid), Column, nil);
end;

end.
