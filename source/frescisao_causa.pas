{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Causas de Rescisao de Contrato de Trabalho

Copyright (C) 2005 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@file-date: 03/05/2005
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

{$IFNDEF QFLIVRE}
unit frescisao_causa;
{$ENDIF}

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QGrids, QDBGrids,
  QComCtrls, QButtons, QMask, QStdCtrls, QExtCtrls, QDBCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, Grids, DBGrids,
  ComCtrls, Buttons, Mask, StdCtrls, ExtCtrls, DBCtrls,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fdialogo, DB, DBClient, Types;

type
  TFrmRescisaoCausa = class(TFrmDialogo)
  protected
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
  private
    { Private declarations }
    procedure CreateDataSet;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

function FindRescisaoCausa( Pesquisa: String; var ID, Nome: String):Boolean; overload;
function FindRescisaoCausa( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean; overload;

procedure CriaRescisaoCausa;

implementation

uses fdb, ftext, fsuporte, ffind;

function FindRescisaoCausa( Pesquisa: String; var ID, Nome: String):Boolean;
var
  DataSet1: TClientDataSet;
  sWhere, sSelect: String;
  vValue: Variant;
begin

  Result   := False;
  DataSet1 := TClientDataSet.Create(nil);

  try

    Pesquisa := kSubstitui(Pesquisa, '*', '%');

    if (Pesquisa = '') then
      sWhere := ''
    else if kNumerico(Pesquisa) then
      sWhere := 'IDRESCISAO = '+QuotedStr(Pesquisa)
    else
      sWhere := 'NOME LIKE '+QuotedStr(Pesquisa+'%');

    sSelect := 'SELECT IDRESCISAO, NOME FROM F_RESCISAO';

    if (sWhere <> '') then
      sSelect := sSelect + ' WHERE '+sWhere;

    if not kOpenSQL( DataSet1, sSelect) then
      raise Exception.Create(kGetErrorLastSQL);

    Result :=  ( (DataSet1.RecordCount = 1) or
                 kFindDataSet( DataSet1, 'Pesquisando Tipo Rescisão',
                               'IDRESCISAO', vValue, [foNoPanel, foNoTitle] ) );

    if Result then
    begin
      ID   := DataSet1.FieldByName('IDRESCISAO').AsString;
      Nome := DataSet1.FieldByName('NOME').AsString;
    end;

  finally
    DataSet1.Free;
  end;

end;  // FindRescisaoCausa

function FindRescisaoCausa( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean;
var
  Codigo, Nome: String;
begin

  Result := FindRescisaoCausa( Pesquisa, Codigo, Nome);

  if Result then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDRESCISAO')) then
          DataSet.FieldByName('IDRESCISAO').AsString := Codigo;
        if Assigned(DataSet.FindField('RESCISAO')) then
          DataSet.FieldByName('RESCISAO').AsString := Nome
        else if Assigned(DataSet.FindField('NOME')) then
          DataSet.FieldByName('NOME').AsString := Nome
      end;

    end;

  end else
  begin
    kErro('Causa de Rescisão não encontrada !!!');
    Key := 0;
  end;

end;  // FindRescisaoCausa

procedure CriaRescisaoCausa;
begin

  with TFrmRescisaoCausa.Create(Application) do
  try
    pvTabela := 'F_RESCISAO';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // procedure CriaSituacao

constructor TFrmRescisaoCausa.Create(AOwner: TComponent);
var
  Label1: TLabel;
  Control1: TControl;
  iLeft, iTop: Integer;
begin

  inherited;

  CreateDataSet();

//  dbgRegistro.OnDrawColumnCell := dbgRegistroDrawColumnCell;

  Caption := 'Cadastro de Causas de Rescisão de Contrato';
  RxTitulo.Caption := ' · Listagem de Causa';

  iLeft := 8;
  iTop  := 8;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Name    := 'lbCodigo';
    Parent  := Panel;
    Left    := iLeft;
    Top     := iTop;
    Caption := 'Código';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Name      := 'dbCodigo';
    Parent    := Panel;
    Left      := iLeft;
    Top       := Label1.Top + Label1.Height + 3;
    Width     := Canvas.TextWidth(Label1.Caption)*2;
    DataField := 'IDRESCISAO';
    DataSource := dtsRegistro;
    iLeft  := Left + Width + 5;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent := Panel;
    Left   := iLeft;
    Top    := iTop;
    Caption := 'Descrição da Causa';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Name       := 'dbNome';
    Parent     := Panel;;
    Left       := iLeft;
    Top        := Label1.Top + Label1.Height + 3;
    Width      := 350;
    CharCase   := ecUpperCase;
    DataField  := 'NOME';
    DataSource := dtsRegistro;
  end;

  // Cria e configura as colunas do DBGrid

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'IDRESCISAO';
    Title.Caption := 'Código';
    Width         := 70;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'NOME';
    Title.Caption := 'Descrição da Causa';
    Width         := 400;
  end;

  ClientWidth := kMaxWidthColumn( dbgRegistro.Columns, Rate);

end;

procedure TFrmRescisaoCausa.CreateDataSet;
begin

  with mtRegistro do
  begin

    FieldDefs.Add('IDRESCISAO', ftString, 2);
    FieldDefs.Add('NOME', ftString, 50);

    IndexFieldNames := 'IDRESCISAO';

    AfterCancel  := mtRegistroAfterCancel;
    AfterOpen    := mtRegistroAfterOpen;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit   := mtRegistroBeforeEdit;

  end;

end;

procedure TFrmRescisaoCausa.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'EXCLUIR a causa "'+DataSet.Fields[1].AsString + '" ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmRescisaoCausa.mtRegistroBeforeEdit(DataSet: TDataSet);
var
  Comp1: TComponent;
begin

  Comp1 := FindComponent('lbCodigo');
  if Assigned(Comp1) and (Comp1 is TControl) then
    TControl(Comp1).Enabled := False;

  Comp1 := FindComponent('dbCodigo');
  if Assigned(Comp1) and (Comp1 is TControl) then
    TControl(Comp1).Enabled := False;

  inherited;

end;

procedure TFrmRescisaoCausa.mtRegistroAfterCancel(DataSet: TDataSet);
var
  Comp1: TComponent;
begin

  inherited;

  Comp1 := FindComponent('lbCodigo');
  if Assigned(Comp1) and (Comp1 is TControl) then
    TControl(Comp1).Enabled := True;

  Comp1 := FindComponent('dbCodigo');
  if Assigned(Comp1) and (Comp1 is TControl) then
    TControl(Comp1).Enabled := True;

end;

procedure TFrmRescisaoCausa.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDRESCISAO').ProviderFlags := [pfInKey];
end;

end.
