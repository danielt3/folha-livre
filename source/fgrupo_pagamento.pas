{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Grupos de Pagamento

Copyright (c) 2002 Allan Lima, Belém-Pará-Brasil.

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

unit fgrupo_pagamento;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, QGrids, QMask, QButtons, QExtCtrls,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, Grids, Mask, Buttons, ExtCtrls,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  {$ENDIF}
  DB, DBClient, Types;

function FindGrupoPagamento( Pesquisa: String; GrupoEmpresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean; overload;

function FindGrupoPagamento( const Pesquisa: String;
  GrupoEmpresa: Integer; DataSet: TDataSet;
  var Key: Word; AutoEdit: Boolean = True):Boolean; overload;

procedure CriaGrupoPagamento;

implementation

uses fdb, ftext, fsuporte, fdialogo, fgrupo_empresa, fbase, ffind;

type
  TFrmGrupoPagamento = class(TFrmDialogo)
  protected
    lbID: TLabel;
    dbID: TDBEdit;
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    ge_id: Integer;
    ge_nome: String;
    procedure SetTitulo2;
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure CreateDataSet;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Iniciar; override;
    procedure Pesquisar; override;
  end;

function FindGrupoPagamento( const Pesquisa: String;
  GrupoEmpresa: Integer; DataSet: TDataSet;
  var Key: Word; AutoEdit: Boolean = True):Boolean;
var
  iCodigo: Integer;
  sNome: String;
  bSave: Boolean;
begin

  Result := FindGrupoPagamento( Pesquisa, GrupoEmpresa, iCodigo, sNome);

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
        if Assigned(DataSet.FindField('IDGP')) then
          DataSet.FieldByName('IDGP').AsInteger := iCodigo;
        if Assigned(DataSet.FindField('GP')) then
          DataSet.FieldByName('GP').AsString := sNome
        else if Assigned(DataSet.FindField('NOME')) then
         DataSet.FieldByName('NOME').AsString := sNome;
      end;

      if bSave and (DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Post;

    end;

  end else
  begin
    kErro('Grupo de Pagamento não encontrado. Tente novamente !!!');
    Key := 0;
  end;

end;

function FindGrupoPagamento( Pesquisa: String; GrupoEmpresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean;
var
  vCodigo: Variant;
  DataSet: TClientDataSet;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa Grupo de Pagamentos',
                       'Informe um texto para pesquisar', Pesquisa) then
      Exit;
  end;

  if (Length(Pesquisa) = 0) then
    Exit;

  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try

    Pesquisa := kSubstitui(Pesquisa, '*', '%');

    SQL.BeginUpdate;
    SQL.Add('SELECT IDGP, NOME');
    SQL.Add('FROM F_GRUPO_PAGAMENTO');
    SQL.Add('WHERE');
    SQL.Add(' IDGE = :GE');
    if kNumerico(Pesquisa) then
      SQL.Add('AND IDGP = '+Pesquisa)
    else
      SQL.Add('AND NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.Add('ORDER BY 1');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text, [GrupoEmpresa]) then
      Exit;

    if (DataSet.RecordCount = 1) or
       kFindDataSet( DataSet, 'Grupo de Pagamento',
                     DataSet.Fields[0].FieldName, {Find Field}
                     vCodigo,
                     [foNoPanel, foNoTitle] {Options} ) then
    begin
      Codigo := DataSet.Fields[0].AsInteger;
      Nome   := DataSet.Fields[1].AsString;
      Result := True;
    end;

  finally
    Dataset.Free;
    SQL.Free;
  end;

end;

procedure CriaGrupoPagamento;
begin

  with TFrmGrupoPagamento.Create(Application) do
    try
      pvTabela := 'F_GRUPO_PAGAMENTO';
      if kCountSQL('F_GRUPO_EMPRESA', '') = 0 then
        kErro('Não há grupos de empresas cadastrados.')
      else begin
        Iniciar();
        ShowModal;
      end;
    finally
      Free;
    end;

end;  // procedure

procedure TFrmGrupoPagamento.Iniciar;
begin
  ge_id := pvGE;
  FindGrupoEmpresa( IntToStr(ge_id), ge_id, ge_nome);
  with RxTitulo do
  begin
    Font.Size := Font.Size - 3;
    SetTitulo2();
  end;
  inherited Iniciar;
end;

procedure TFrmGrupoPagamento.Pesquisar;
begin
  kSQLSelectFrom( pvDataSet, pvTabela, 'IDGE = '+IntToStr(ge_id));
end;

procedure TFrmGrupoPagamento.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (State = dsInsert) and (FieldByName('IDGP').AsInteger = 0) then
      FieldByName('IDGP').AsInteger := kMaxCodigo( pvTabela, 'IDGP');
  inherited;
end;

procedure TFrmGrupoPagamento.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir o Grupo "'+DataSet.FieldByName('NOME').AsString+'" ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmGrupoPagamento.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  lbID.Enabled := False;
  dbID.Enabled := False;
  inherited;
end;

procedure TFrmGrupoPagamento.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

procedure TFrmGrupoPagamento.mtRegistroNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDGE').AsInteger := ge_id;
  DataSet.FieldByName('IDGP').AsInteger := kMaxCodigo( pvTabela, 'IDGP');
end;

procedure TFrmGrupoPagamento.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_F12) then
  begin
    if pvDataSet.State in [dsInsert,dsEdit] then
      pvDataSet.Cancel;
    if not FindGrupoEmpresa( '*', ge_id, ge_nome) then
      Key := 0
    else
    begin
      SetTitulo2();
      Pesquisar();
      dbgRegistro.SetFocus;
    end;
  end;

  inherited;

end;

procedure TFrmGrupoPagamento.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDGP').ProviderFlags := [pfInUpdate, pfInWhere, pfInKey];
end;

procedure TFrmGrupoPagamento.CreateDataSet;
begin

  with mtRegistro do
  begin

    mtRegistro.FieldDefs.Add( 'IDGP', ftInteger, 0);
    mtRegistro.FieldDefs.Add( 'IDGE', ftInteger, 0);
    mtRegistro.FieldDefs.Add( 'NOME', ftString, 30);

    IndexFieldNames := 'IDGP';

    AfterCancel := mtRegistroAfterCancel;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit := mtRegistroBeforeEdit;
    BeforeInsert := mtRegistroBeforeInsert;
    BeforePost := mtRegistroBeforePost;
    OnNewRecord := mtRegistroNewRecord;
    AfterPost := mtRegistroAfterCancel;

    AfterOpen := mtRegistroAfterOpen;

  end;

end;  // CreateDataSet

constructor TFrmGrupoPagamento.Create(AOwner: TComponent);
var
  Column: TColumn;
  i, iMaxWidth: Integer;
  Label2: TLabel;
begin

  inherited;

  Caption := 'Grupo de Pagamentos';
  RxTitulo.Caption := ' + '+Caption;

  OnKeyDown := FormKeyDown;

  CreateDataSet;

  lbID := TLabel.Create(Self);

  with lbID do
  begin
    Parent := Panel;
    Left := 8;
    Top := 8;
    Width := 53;
    Caption := 'ID (Código)';
  end;

  dbID :=  TDBEdit.Create(Self);

  with dbID do
  begin
    Parent := Panel;
    Left := lbID.Left;
    Top  := lbId.Top + lbID.Height + 3;
    Width := 80;
    DataField := 'IDGP';
    DataSource := dtsRegistro;
  end;

  Label2 := TLabel.Create(Self);

  with Label2 do
  begin
    Parent := Panel;
    Left := dbID.Left + dbID.Width + 5;
    Top  := lbID.Top;
    Caption := 'Nome';
  end;

  with TDBEdit.Create(Self) do
  begin
    Parent := Panel;
    Left := Label2.Left;
    Top := dbID.Top;
    Width := 400;
    CharCase := ecUpperCase;
    DataField := 'NOME';
    DataSource := dtsRegistro;
  end;

  // Cria e configura as colunas do DBGrid

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'IDGP';
    Title.Caption := 'ID';
    Width := 70;
  end;

  Column := dbgRegistro.Columns.Add;
  with Column do
  begin
    FieldName := 'NOME';
    Title.Caption := 'Nome do Grupo de Pagamento';
    Width := 445;
  end;

  // Calcular a largura do formulario para conter o Grid
  iMaxWidth  := Round( Rate * (30 + dbgRegistro.Columns.Count));
  for i := 0 to dbgRegistro.Columns.Count-1 do
    iMaxWidth := iMaxWidth + dbgRegistro.Columns[i].Width;

  ClientWidth := iMaxWidth;

end; // CreateControls

procedure TFrmGrupoPagamento.SetTitulo2;
begin
  RxTitulo.Caption := ' [F12] Grupo de Empresa: ('+IntToStr(ge_id)+') '+ge_nome;
end;

end.
