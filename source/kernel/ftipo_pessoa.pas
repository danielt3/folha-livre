{
FolhaLivre - Folha de Pagamento
Copyright (C) 2002 Allan Lima

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

{$I flivre.inc}

unit ftipo_pessoa;

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls, QDialogs,{$ENDIF}
  {$IFDEF VCL}Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls, Dialogs,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
   Db, fdialogo, DBClient;

type
  TFrmTipoPessoa = class(TFrmDialogo)
  protected
    mtRegistroIDTIPO: TStringField;
    mtRegistroNOME: TStringField;
    dbCodigo: TDBEdit;
    lbCodigo: TLabel;
    dbNome: TDBEdit;
    lbNome: TLabel;
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

procedure CriaTipoPessoa;

implementation

uses ftext, fsuporte, fdb, fbase;

procedure CriaTipoPessoa;
var
  Frm: TFrmTipoPessoa;
begin

  Frm := TFrmTipoPessoa.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'PESSOA_TIPO';
      Iniciar();
      ShowModal();
    end;
  finally
    Frm.Free;
  end;

end;

procedure TFrmTipoPessoa.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbCodigo.SetFocus;
end;

procedure TFrmTipoPessoa.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  lbCodigo.Enabled := False;
  dbCodigo.Enabled := False;
  dbNome.SetFocus;
end;

procedure TFrmTipoPessoa.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  lbCodigo.Enabled := True;
  dbCodigo.Enabled := True;
end;

procedure TFrmTipoPessoa.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Excluir o tipo "'+DataSet.FieldByName('NOME').AsString+'" ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmTipoPessoa.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
    FieldByName('IDTIPO').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
end;

constructor TFrmTipoPessoa.Create(AOwner: TComponent);
var
  Column: TColumn;
  iMaxWidth, i: Integer;
begin

  inherited Create(AOwner);

  Self.Caption := 'Cadastro de Tipos de Pessoa';
  RxTitulo.Caption := ' · Listagem de Tipos de Pessoa';

  lbCodigo := TLabel.Create(Self);
  with lbCodigo do
  begin
    Parent := Panel;
    Left := 8;
    Top := 8;
    Caption := 'Código';
    FocusControl := dbCodigo;
  end;

  dbCodigo := TDBEdit.Create(Self);
  with dbCodigo do
  begin
    Parent := Panel;
    CharCase := ecUpperCase;
    Left := lbCodigo.Left;
    Top := lbCodigo.Top + lbCodigo.Height + 5;
    Width := 80;
    Height := 19;
    DataField := 'IDTIPO';
    DataSource := dtsRegistro;
  end;

  lbNome := TLabel.Create(Self);
  with lbNome do
  begin
    Parent := Panel;
    Left := dbCodigo.Left + dbCodigo.Width + 5;
    Top := lbCodigo.Top;
    Caption := 'Descrição do Tipo';
    FocusControl := dbNome;
  end;

  dbNome := TDBEdit.Create(Self);
  with dbNome do
  begin
    Parent := Panel;
    CharCase := ecUpperCase;
    Left := lbNome.Left;
    Top := dbCodigo.Top;
    Width := 300;
    Height := dbCodigo.Height;
    DataField := 'NOME';
    DataSource := dtsRegistro;
  end;

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'IDTIPO';
    Title.Caption := 'Código';
    Width := 80;
  end;

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Descrição do tipo';
    Width := 440;
  end;

  // Calcular a largura do formulario para conter o Grid
  iMaxWidth  := Round( Rate * (30 + dbgRegistro.Columns.Count));
  for i := 0 to dbgRegistro.Columns.Count-1 do
    iMaxWidth := iMaxWidth + dbgRegistro.Columns[i].Width;

  ClientWidth := iMaxWidth;

  with mtRegistro do
  begin

    FieldDefs.BeginUpdate;
    FieldDefs.Add( 'IDTIPO', ftString, 2);
    FieldDefs.Add( 'NOME', ftString, 30);
    FieldDefs.EndUpdate;

    IndexFieldNames := 'IDTIPO';

    AfterCancel := mtRegistroAfterCancel;
    AfterOpen   := mtRegistroAfterOpen;
    AfterPost := mtRegistroAfterCancel;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit := mtRegistroBeforeEdit;
    BeforeInsert := mtRegistroBeforeInsert;
    BeforePost := mtRegistroBeforePost;

  end;  // with mtRegistro

end;

end.
