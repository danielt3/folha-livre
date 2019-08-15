{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2002 Allan Lima, Bel�m-Par�-Brasil.

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

Autor(s): Allan Kardek Neponuceno Lima
E-mail(s): allan_kardek@yahoo.com.br / folha_livre@yahoo.com.br
}

unit fvfixo;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs,
  QExtCtrls, QStdCtrls, QDBCtrls, QMask, QGrids, QDBGrids,
  QComCtrls, QButtons, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows,
  Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, DBCtrls, Mask, Grids, DBGrids,
  ComCtrls, Buttons, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fdialogo, DB, DBClient;

type
  TFrmVFixo = class(TFrmDialogo)
    lbID: TLabel;
    Label2: TLabel;
    dbID: TDBEdit;
    dbNome: TDBEdit;
    mtRegistroNOME: TStringField;
    dbValor: TDBEdit;
    lbValor: TLabel;
    mtRegistroIDVFIXO: TIntegerField;
    mtRegistroVALOR: TCurrencyField;
    mtRegistroIDEMPRESA: TIntegerField;
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure CriaValorFixo;

implementation

uses fdb, ftext, fsuporte, fdeposito, fbase;

{$R *.dfm}

procedure CriaValorFixo;
var
  Frm: TFrmVFixo;
begin

  if (kGetAcesso('MNIVALORFIXO') <> 0) then
    Exit;

  Frm := TFrmVFixo.Create(Application);

  try
    with Frm do
    begin
      if (pvEmpresa = 0) then
        Caption := 'Valores Globais';
      RxTitulo.Caption := ' � Listagem de '+Caption;
      pvTabela := 'F_VALOR_FIXO';
      Iniciar();
      ShowModal;
    end;
  finally
    Frm.Free;
  end;

end;  // procedure

procedure TFrmVFixo.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir o Valor Fixo "'+DataSet.FieldByName('NOME').AsString + '" ?') then
    SysUtils.Abort
  else inherited;
end;

procedure TFrmVFixo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmVFixo.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus
end;

procedure TFrmVFixo.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDVFIXO').AsInteger = 0) then
      FieldByName('IDVFIXO').AsInteger := kMaxCodigo( pvTabela, 'IDVFIXO', pvEmpresa);
  inherited;
end;

procedure TFrmVFixo.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

end.
