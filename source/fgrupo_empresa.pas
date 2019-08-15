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

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fgrupo_empresa;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, QGrids, QMask, QButtons, QExtCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, Grids, Mask, Buttons, ExtCtrls,
  {$ENDIF}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  SysUtils, Classes, DB, DBClient, Types, fdialogo;

type
  TFrmGrupoEmpresa = class(TFrmDialogo)
    mtRegistroIDGE: TIntegerField;
    mtRegistroNOME: TStringField;
    lbID: TLabel;
    dbID: TDBEdit;
    dbNome: TDBEdit;
    Label2: TLabel;
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FindGrupoEmpresa( Pesquisa: String;
  var Codigo: Integer; var Nome: String):Boolean; overload;

function FindGrupoEmpresa( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean; overload;

procedure CriaGrupoEmpresa;

implementation

uses fdb, ftext, fsuporte, ffind;

{$R *.dfm}

function FindGrupoEmpresa( Pesquisa: String;
  var Codigo: Integer; var Nome: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) or (Pesquisa = '0') then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa de Grupo de Empresa',
                       'Informe um texto para pesquisar', Pesquisa) then
      Exit;
  end;

  if (Length(Pesquisa) = 0) then
    Exit;

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT IDGE AS ID, NOME');
    SQL.Add('FROM F_GRUPO_EMPRESA');
    if kNumerico(Pesquisa) then
      SQL.Add('WHERE IDGE = '+Pesquisa)
    else
      SQL.Add('WHERE NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text) then
      Exit;

    with DataSet do
      if (RecordCount = 1) or
         kFindDataSet( DataSet, 'Grupo de Empresas',
                       Fields[1].FieldName, {Find Field}
                       vCodigo,
                       [foNoPanel, foNoTitle], {Options}
                       Fields[0].FieldName {Result Field} ) then
      begin
        Codigo := Fields[0].AsInteger;
        Nome   := Fields[1].AsString;
        Result := True;
      end;

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // function FindGrupoEmpresa

function FindGrupoEmpresa( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean;
var
  iCodigo: Integer;
  sNome: String;
  bSave: Boolean;
begin

  Result := FindGrupoEmpresa( Pesquisa, iCodigo, sNome);

  if Result then
  begin

    if Assigned(DataSet) then
    begin

      bSave := False;

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
      begin
        DataSet.Edit;
        bSave := True;
      end;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDGE')) then
          DataSet.FieldByName('IDGE').AsInteger := iCodigo;
        if Assigned(DataSet.FindField('GE')) then
          DataSet.FieldByName('GE').AsString := sNome;
        if Assigned(DataSet.FindField('IDGP')) then
          DataSet.FieldByName('IDGP').AsString := '';
        if Assigned(DataSet.FindField('GP')) then
          DataSet.FieldByName('GP').AsString := '';
      end;

      if bSave and (DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Post;

    end;

  end else
  begin
    kErro('Grupo de Empresa não encontrado !!!');
    Key := 0;
  end;

end;  // FindGrupoEmpresa

procedure CriaGrupoEmpresa;
begin

  with TFrmGrupoEmpresa.Create(Application) do
    try
      pvTabela := 'F_GRUPO_EMPRESA';
      Iniciar();
      ShowModal;
    finally
      Free;
    end;

end;  // procedure

procedure TFrmGrupoEmpresa.mtRegistroBeforePost(DataSet: TDataSet);
begin
  if (DataSet.State = dsInsert) and (DataSet.Fields[0].AsInteger = 0) then
    DataSet.Fields[0].AsInteger := kMaxCodigo( pvTabela, 'IDGE');
  inherited;
end;

procedure TFrmGrupoEmpresa.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if (DataSet.Fields[0].AsInteger = 1) then
  begin
    kErro('O Grupo de Empresa no. 1 não pode ser excluído !!!');
    SysUtils.Abort;
  end else if not kConfirme( 'Excluir o Grupo "'+DataSet.Fields[1].AsString+'" ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmGrupoEmpresa.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmGrupoEmpresa.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

procedure TFrmGrupoEmpresa.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus;
end;

procedure TFrmGrupoEmpresa.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDGE').AsInteger := 0;
end;

end.
