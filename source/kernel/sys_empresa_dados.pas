{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2004-2007 Allan Lima

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
@file-date: 30/04/2004
}

unit sys_empresa_dados;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QGrids,
  QDBGrids, QComCtrls, QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids,
  DBGrids, ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls,
  {$ENDIF}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  Variants, fcadastro, DB, DBClient, SysUtils, Classes, fbase, Types;

type
  TFrmSysEmpresaDados = class(TFrmBase)
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
    mtRegistroATIVO_X: TSmallintField;
    mtRegistroIDEMPRESA: TIntegerField;
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

function kGetEmpresaDados( const Nome: String; const Default: String = ''):String;
procedure CriaSysEmpresaDados();

implementation

uses ftext, fsuporte, fdb, futil;

{$R *.DFM}

function kGetEmpresaDados( const Nome: String; const Default: String = ''):String;
var
  iEmpresa: Integer;
  sSQL: String;
begin
  iEmpresa := kEmpresaAtiva();
  sSQL := 'SELECT VALOR FROM EMPRESA_DADOS'#13+
          'WHERE IDEMPRESA = '+IntToStr(iEmpresa)+' AND CHAVE = '+QuotedStr(Nome);

  if not kGetFieldSQL( sSQL, Result) then
    raise Exception.Create('');

  if (Result = EmptyStr) then
    Result := Default;
    
end;

procedure CriaSysEmpresaDados();
var
  Frm: TFrmSysEmpresaDados;
begin

  Frm := TFrmSysEmpresaDados.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'EMPRESA_DADOS';
      Iniciar();
      ShowModal;
    end;
  except
    on E: Exception do
      kErro( E.Message, 'sys_empresa_dados.pas', 'CriaSysEmpresaDados()');
  end;

end;  // procedure

procedure TFrmSysEmpresaDados.Iniciar;
var
  cdEmpresa: TClientDataSet;
begin

  cdEmpresa := TClientDataSet.Create(Self);

  try
    if kSQLSelectFrom( cdEmpresa, 'EMPRESA', pvEmpresa) then
      Caption := Caption + ' - ' + cdEmpresa.FieldByName('NOME').AsString;
  finally
    cdEmpresa.Free;
  end;

  dbChave.Font.Style := dbChave.Font.Style + [fsBold];
  inherited;

end;

procedure TFrmSysEmpresaDados.PanelExit(Sender: TObject);
begin
  if btnGravar.Enabled then btnGravar.Click;
end;

procedure TFrmSysEmpresaDados.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := DataSet.FieldByName('CHAVE').AsString;
  if not kConfirme( 'Excluir a Chave '+QuotedStr(sNome)+' ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmSysEmpresaDados.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDEMPRESA').AsInteger := pvEmpresa;
  DataSet.FieldByName('ATIVO_X').AsInteger     := 1;
end;

procedure TFrmSysEmpresaDados.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbChave.SetFocus;
end;

procedure TFrmSysEmpresaDados.dbgRegistroTitleBtnClick(Sender: TObject; ACol: Integer;
  Field: TField);
begin
  kTitleBtnClick(Field);
end;

procedure TFrmSysEmpresaDados.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbChave.Enabled := False;
  dbValor.SetFocus;
end;

procedure TFrmSysEmpresaDados.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  dbChave.Enabled := True;
end;

procedure TFrmSysEmpresaDados.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);
  if (Column.Field.DataSet.FieldByName('ATIVO_X').AsInteger = 0) then
    TDBGrid(Sender).Canvas.Font.Color := clRed;
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);    
end;

procedure TFrmSysEmpresaDados.dbgRegistroTitleClick(Column: TColumn);
begin
  kTitleClick( TDBGrid(Column.Grid), Column, nil);
end;

end.
