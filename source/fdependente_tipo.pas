{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Tipos de Dependente

Copyright (c) 2004, Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@file-date: 10/02/2004
@autor-name: Allan Kardek Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fdependente_tipo;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls,
  QDBCtrls, QMask, QGrids, QDBGrids, QComCtrls, QButtons,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fdialogo, DBClient, DB, Types;

type
  TFrmDependenteTipo = class(TFrmDialogo)
  protected
    { Protected declarations }
    lbCodigo: TLabel;
    dbCodigo: TDBEdit;
    procedure GetData; override;
    procedure Pesquisar; override;
  private
    { Private declarations }
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
  end;

procedure CriaDependenteTipo;

implementation

uses ftext, fdb, fsuporte, futil, fbase;

const
  C_AUTO_EDIT = True;
  C_UNIT = 'fdependente_tipo.pas';

procedure CriaDependenteTipo;
begin

  with TFrmDependenteTipo.Create(Application) do
  try
    pvTabela := 'F_DEPENDENTE_TIPO';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;

{ TFrmDependenteTipo }

constructor TFrmDependenteTipo.Create(AOwner: TComponent);
var
  Label1: TLabel;
  Control1: TWinControl;
begin

  inherited;

  Caption          := 'Tipos de Dependente';
  RxTitulo.Caption := ' + Cadastro de Tipos de Dependente';

  mtRegistro.AfterCancel  := mtRegistroAfterCancel;
  mtRegistro.AfterOpen    := mtRegistroAfterOpen;
  mtRegistro.BeforeDelete := mtRegistroBeforeDelete;
  mtRegistro.BeforeEdit   := mtRegistroBeforeEdit;
  mtRegistro.BeforePost   := mtRegistroBeforePost;

  // Criação de componentes locais

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'IDTIPO';
    Title.Caption := 'Código';
    Width := 50;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'DESCRICAO';
    Title.Caption := 'Descrição do Tipo';
    Width := 380;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'LIMITE_ANO';
    Title.Caption := 'Limite de Idade';
    Width := 80;
  end;

  lbCodigo := TLabel.Create(Self);

  with lbCodigo do
  begin
    Caption := 'Código';
    Left    := 8;
    Parent  := Panel;
    Top     := 8;
  end;

  dbCodigo := TDBEdit.Create(Self);

  with dbCodigo do
  begin
    CharCase   := ecUpperCase;
    DataSource := dtsRegistro;
    DataField  := 'IDTIPO';
    Left       := lbCodigo.Left;
    Parent     := Panel;
    Top        := lbCodigo.Top+lbCodigo.Height+3;
    Width      := 50;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Caption := 'Descrição do Tipo';
    Left    := dbCodigo.Left + dbCodigo.Width + 5;
    Parent  := Panel;
    Top     := lbCodigo.Top;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    CharCase    := ecUpperCase;
    DataSource  := dtsRegistro;
    DataField   := 'DESCRICAO';
    Left        := Label1.Left;
    Parent      := Panel;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 300;
    Label1.FocusControl := Control1;
  end;

  // Limite de idade

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Limite-Idade';
    Left    := Control1.Left+Control1.Width+5;
    Top     := lbCodigo.Top;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    CharCase    := ecUpperCase;
    DataSource  := dtsRegistro;
    DataField   := 'LIMITE_ANO';
    Left        := Label1.Left;
    Parent      := Panel;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 100;
    Label1.FocusControl := Control1;
  end;

  // Ajustar a altura do Panel de edicao
  Panel.Height := Control1.Top + Control1.Height + 10;

end;

procedure TFrmDependenteTipo.GetData;
begin

  try
    if not kSQLSelectFrom( pvDataSet, pvTabela) then
      raise Exception.Create(kGetErrorLastSQL);
    pvDataSet.Last;
    pvDataSet.First;
  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'GetData()');
  end;

end;

procedure TFrmDependenteTipo.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome:= DataSet.FieldByName('DESCRICAO').AsString;
  if not kConfirme('Excluir o Dependente "'+sNome+' ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmDependenteTipo.Pesquisar;
begin
  GetData();
end;

procedure TFrmDependenteTipo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
  inherited;
end;

procedure TFrmDependenteTipo.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
  inherited;
end;

procedure TFrmDependenteTipo.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDTIPO').ProviderFlags := [pfInkey];
  inherited;
end;

procedure TFrmDependenteTipo.mtRegistroBeforePost(DataSet: TDataSet);
begin
  if (DataSet.FieldByName('IDTIPO').AsString[1] in ['D','M','F','I']) then
  begin
    kErro('Código de tipo inválido. Não é permitido os caracters D, M, F, I.');
    SysUtils.Abort;
  end;
  inherited;
end;

end.
