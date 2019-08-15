{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002 Allan Lima

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

unit sys_global;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids, QComCtrls,
  QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient, Variants, Types, fdialogo;

type
  Tfrmsysglobal = class(TFrmDialogo)
    lbLocal: TLabel;
    lbChave: TLabel;
    dbLocal: TDBEdit;
    dbChave: TDBEdit;
    lbValor: TLabel;
    dbValor: TDBEdit;
    dbDescricao: TDBEdit;
    lbDescricao: TLabel;
    dbAtivo: TDBCheckBox;
    mtRegistroID: TIntegerField;
    mtRegistroLOCAL: TStringField;
    mtRegistroCHAVE: TStringField;
    mtRegistroVALOR: TStringField;
    mtRegistroDESCRICAO: TStringField;
    mtRegistroATIVO: TSmallintField;
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

procedure CriaSysGlobal();

implementation

uses ftext, fsuporte, fdb, fsystem;

const
  C_UNIT = 'sys_global.pas';

{$R *.DFM}

procedure CriaSysGlobal();
begin

  with Tfrmsysglobal.Create(Application) do
  try
    pvTabela := 'SYSTEM';
    Iniciar();
    ShowModal;
  except
    on E: Exception do kErro( E.Message, C_UNIT, 'CriaSysGlobal()');
  end;

end;  // procedure

procedure Tfrmsysglobal.Iniciar;
begin

  dbLocal.Font.Style := dbLocal.Font.Style + [fsBold];
  dbChave.Font.Assign(dbLocal.Font);

  inherited;

  {
  btnTexto.Font.Style := btnTexto.Font.Style + [fsBold];
  btnTexto.Top    := dbValor.Top;
  btnTexto.Left   := dbValor.Left + dbValor.Width + 5;
  btnTexto.Height := dbValor.Height;
  }

end;  // Iniciar

procedure Tfrmsysglobal.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := DataSet.FieldByName('CHAVE').AsString;
  if not kConfirme( 'Excluir a Chave '+QuotedStr(sNome)+' ?') then
    SysUtils.Abort;
  inherited;
end;

procedure Tfrmsysglobal.mtRegistroBeforePost(DataSet: TDataSet);
begin
  if (DataSet.State = dsInsert) then
    DataSet.FieldByName('ID').AsInteger := kMaxCodigo( pvTabela, 'ID');
  inherited;
end;

procedure Tfrmsysglobal.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbLocal.SetFocus;
end;

procedure Tfrmsysglobal.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('ID').AsInteger    := 0;
  DataSet.FieldByName('ATIVO').AsInteger := 1;
end;

procedure Tfrmsysglobal.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if not kWinControlParent( ActiveControl, Panel) then
    dbLocal.SetFocus;
end;

procedure Tfrmsysglobal.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  if (Column.Field.DataSet.FieldByName('ATIVO').AsInteger = 0) then
    TDBGrid(Sender).Canvas.Font.Color := clRed;
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

end.
