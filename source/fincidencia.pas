{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Incidencias para Eventos

Copyright (c) 2002-2007, Allan Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fincidencia;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls, QDialogs,
  QGrids, QMask, QButtons, QExtCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls, Dialogs,
  Grids, Mask, Buttons, ExtCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, DB, fdialogo, DBClient, Types;

type
  TFrmIncidencia = class(TFrmDialogo)
  protected
    lbCodigo: TLabel;
    lbNome: TLabel;
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
//    constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0); override;
    procedure Iniciar; override;
  end;

procedure CriaIncidencia;

implementation

uses fdb, ftext, fsuporte;

procedure CriaIncidencia;
begin

  with TFrmIncidencia.Create(Application) do
  try
    pvTabela := 'F_INCIDENCIA';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // CriaIncidencia

procedure TFrmIncidencia.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (State = dsInsert) and (Fields[0].AsInteger = 0) then
      Fields[0].AsInteger := kMaxCodigo( pvTabela, 'IDINCIDENCIA');
  inherited;
end;

procedure TFrmIncidencia.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir a Incid�ncia No. '+
                    Dataset.Fields[0].AsString+#13+
                    DataSet.Fields[1].AsString + ' ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmIncidencia.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  lbNome.FocusControl.SetFocus;
  lbCodigo.Enabled := False;
  lbCodigo.FocusControl.Enabled := False;
end;

procedure TFrmIncidencia.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.Enabled := True;
  lbCodigo.FocusControl.Enabled := True;
end;

procedure TFrmIncidencia.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  lbCodigo.FocusControl.SetFocus;
end;

constructor TFrmIncidencia.Create(AOwner: TComponent);
var
  Control1: TDBEdit;
begin

  inherited Create(AOwner);

  FormStyle        := fsNormal;
  Visible          := False;
  WindowState      := wsNormal;
  
  Caption          := 'Incid�ncias';
  RxTitulo.Caption := ' + Cadastro de Incid�ncias';

  OnKeyDown := FormKeyDown;

  mtRegistro.AfterCancel  := mtRegistroAfterCancel;
  mtRegistro.AfterOpen    := mtRegistroAfterOpen;
  mtRegistro.OnNewRecord  := mtRegistroNewRecord;
  mtRegistro.BeforeDelete := mtRegistroBeforeDelete;
  mtRegistro.BeforeEdit   := mtRegistroBeforeEdit;

  // Configura a grade de exibicao dos dados

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'IDINCIDENCIA';
    Title.Caption := 'C�digo';
    Width := Round( Rate * 80);
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Descri��o';
    Width := Round( Rate * 450);
  end;

  // Calcular a largura do formulario para conter o Grid
  Width := kMaxWidthColumn( dbgRegistro.Columns, Rate);

  // Constru��o dos componentes de entrada

  lbCodigo := TLabel.Create(Self);

  with lbCodigo do
  begin
    Parent  := Panel;
    Caption := 'C�digo';
    Left    := 8;
    Top     := 8;
  end;

  Control1 := TDBEdit.Create(Self);

  with Control1 do
  begin
    Parent      := Panel;
    CharCase    := ecUpperCase;
    DataSource  := dtsRegistro;
    DataField   := 'IDINCIDENCIA';
    Left        := lbCodigo.Left;
    Top         := lbCodigo.Top+lbCodigo.Height+3;
    Width       := 80;
    lbCodigo.FocusControl := Control1;
  end;

  lbNome := TLabel.Create(Self);

  with lbNome do
  begin
    Parent  := Panel;
    Caption := 'Descri��o da Incid�ncia';
    Left    := Control1.Left + Control1.Width + 5;
    Top     := lbCodigo.Top;
  end;

  Control1 := TDBEdit.Create(Self);

  with Control1 do
  begin
    Parent      := Panel;
    CharCase    := ecUpperCase;
    DataSource  := dtsRegistro;
    DataField   := 'NOME';
    Left        := lbNome.Left;
    Top         := lbNome.Top+lbNome.Height+3;
    Width       := 400;
    lbNome.FocusControl := Control1;
  end;

  // Ajustar a altura do Panel de edicao
  Panel.Height := Control1.Top + Control1.Height + 10;

end;

procedure TFrmIncidencia.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDINCIDENCIA').ProviderFlags := [pfInKey];
end;

procedure TFrmIncidencia.Iniciar;
begin
  inherited;
  mtRegistro.IndexFieldNames := 'IDINCIDENCIA';
end;

end.
