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

Autor(es): Allan Kardek Neponuceno Lima
E-mail: allan_kardek@yahoo.com.br / folha_livre@yahoo.com.br
}

unit fevento_grupo;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, QGrids, QMask, QButtons, QExtCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, Grids, Mask, Buttons, ExtCtrls,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
   Db, fdialogo, DBClient, Types, AKLabel;

type
  TFrmEvento_Grupo = class(TFrmDialogo)
    Label2: TLabel;
    lbID: TLabel;
    dbNome: TDBEdit;
    dbID: TDBEdit;
    mtRegistroIDGRUPO: TIntegerField;
    mtRegistroNOME: TStringField;
    Label1: TLabel;
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CriaEventoGrupo;

implementation

uses fdb, ftext, fsuporte;

{$R *.DFM}

procedure CriaEventoGrupo;
var
  Frm: TFrmEvento_Grupo;
begin
  Frm := TFrmEvento_Grupo.Create(Application);
  try
    with Frm do
    begin
      pvTabela := 'F_EVENTO_GRUPO';
      Iniciar();
      ShowModal;
    end;
  finally
    Frm.Free;
  end;
end;  // procedure

procedure TFrmEvento_Grupo.mtRegistroBeforePost(DataSet: TDataSet);
begin
  if (DataSet.State = dsInsert) then
    DataSet.FieldByName('IDGRUPO').AsInteger := kMaxCodigo( pvTabela, 'IDGRUPO');
  inherited;
end;

procedure TFrmEvento_Grupo.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

procedure TFrmEvento_Grupo.mtRegistroBeforeDelete(DataSet: TDataSet);
var sNome: String;
begin
  sNome   := DataSet.FieldByName('NOME').AsString;
  if not kConfirme( 'Excluir o Grupo "'+sNome+'" ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmEvento_Grupo.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus
end;

procedure TFrmEvento_Grupo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

end.
