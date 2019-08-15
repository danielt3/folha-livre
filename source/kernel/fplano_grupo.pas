{
FolhaLivre - Folha de Pagamento Copyright (C) 2002 Allan Kardek N Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

autor(es): Allan Kardek Neponuceno Lima
emails: allan_kardek@yahoo.com.br / folha_livre@yahoo.com.br
}

unit fplano_grupo;

{$I flivre.inc}

interface

uses
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, QGrids, QMask, QAKLabel, QButtons, QExtCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, Grids, Mask, AKLabel, Buttons, ExtCtrls,
  {$ENDIF}
  SysUtils, Classes, Db, fdialogo, DBClient, Types;

type
  TFrmPlanoGrupo = class(TFrmDialogo)
    mtRegistroIDPLANO_GRUPO: TIntegerField;
    mtRegistroNOME: TStringField;
    lbID: TLabel;
    dbID: TDBEdit;
    dbNome: TDBEdit;
    Label2: TLabel;
    mtRegistroIDEMPRESA: TIntegerField;
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CriaPlanoGrupo;

implementation

uses fdb, ftext, fsuporte;

{$R *.DFM}

procedure CriaPlanoGrupo;
var
  Frm: TFrmPlanoGrupo;
begin

  Frm := TFrmPlanoGrupo.Create(Application);

  try
    with Frm do
    begin
      pvTabela := 'PLANO_GRUPO';
      Iniciar();
      ShowModal;
    end;
  finally
    Frm.Free;
  end;

end;  // procedure

procedure TFrmPlanoGrupo.mtRegistroBeforePost(DataSet: TDataSet);
var iCodigo: Integer;
begin
  if (DataSet.State = dsInsert) and
     (DataSet.FieldByName('IDPLANO_GRUPO').AsInteger = 0) then
  begin
    iCodigo := kMaxCodigo( pvTabela, 'IDPLANO_GRUPO', pvEmpresa);
    DataSet.FieldByName('IDPLANO_GRUPO').AsInteger := iCodigo;
  end;
  inherited;
end;

procedure TFrmPlanoGrupo.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir o Grupo "'+DataSet.FieldByName('NOME').AsString + '" ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmPlanoGrupo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmPlanoGrupo.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

procedure TFrmPlanoGrupo.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus;
end;

end.
