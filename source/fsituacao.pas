{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Situaçao de Funcionarios

Copyright (C) 2002 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@file-date: 07/12/2004
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

{$IFNDEF QFLIVRE}
unit fsituacao;
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
  TFrmSituacao = class(TFrmDialogo)
  protected
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    procedure CreateDataSet;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  end;

function PesquisaSituacao( Pesquisa: String; var Codigo, Nome: String):Boolean; overload;
function PesquisaSituacao( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean; overload;

procedure CriaSituacao;

implementation

uses fdb, ftext, fsuporte, ffind;

function PesquisaSituacao( Pesquisa: String; var Codigo, Nome: String):Boolean;
var
  DataSet1: TClientDataSet;
  vValue: Variant;
begin

  DataSet1 := TClientDataSet.Create(nil);

  try

    kSQLSelectFrom( DataSet1, 'F_SITUACAO');

    Result := DataSet1.Locate( 'IDSITUACAO', Pesquisa, [loCaseInsensitive]);

    if not Result then
      Result := kFindDataSet( DataSet1,
                              'Pesquisando Situação',
                              'IDSITUACAO', vValue, [foNoPanel, foNoTitle] );

    if Result then
    begin
      Codigo := DataSet1.FieldByName('IDSITUACAO').AsString;
      Nome   := DataSet1.FieldByName('NOME').AsString;
    end;

  finally
    DataSet1.Free;
  end;

end;  // FindSituacao

function PesquisaSituacao( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean;
var
  Codigo, Nome: String;
begin

  Result := PesquisaSituacao( Pesquisa, Codigo, Nome);

  if Result then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDSITUACAO')) then
          DataSet.FieldByName('IDSITUACAO').AsString := Codigo;
        if Assigned(DataSet.FindField('SITUACAO')) then
          DataSet.FieldByName('SITUACAO').AsString := Nome
        else if Assigned(DataSet.FindField('NOME')) then
          DataSet.FieldByName('NOME').AsString := Nome;
      end;

    end;

  end else
  begin
    kErro('Situação não encontrada !!!');
    Key := 0;
  end;

end;  // PesquisaSituacao

procedure CriaSituacao;
begin

  with TFrmSituacao.Create(Application) do
  try
    pvTabela := 'F_SITUACAO';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // procedure CriaSituacao

constructor TFrmSituacao.Create(AOwner: TComponent);
var
  Label1: TLabel;
  Control1: TControl;
  iLeft, iTop: Integer;
begin

  inherited;

  CreateDataSet();

  dbgRegistro.OnDrawColumnCell := dbgRegistroDrawColumnCell;
  
  Caption := 'Cadastro de Situações de Funcionários';
  RxTitulo.Caption := ' · Listagem de Situação';

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
    Name   := 'dbCodigo';
    Parent := Panel;
    Left   := iLeft;
    Top    := Label1.Top + Label1.Height + 2;
    Width  := 80;
    DataField := 'IDSITUACAO';
    DataSource := dtsRegistro;
    iLeft  := Left + Width + 5;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent := Panel;
    Left   := iLeft;
    Top    := iTop;
    Caption := 'Descrição da Situação';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Name       := 'dbNome';
    Parent     := Panel;;
    Left       := iLeft;
    Top        := Label1.Top + Label1.Height + 2;
    Width      := 350;
    CharCase   := ecUpperCase;
    DataField  := 'NOME';
    DataSource := dtsRegistro;
    iLeft      := Left + Width + 5;
    iTop       := Top;
  end;

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := Panel;
    Caption        := 'Calcular';
    Left           := iLeft;
    Top            := iTop;
    Width          := 80;
    AllowGrayed    := False;
    ValueChecked   := '1';
    ValueUnchecked := '0';
    DataField      := 'CALCULAR_X';
    DataSource     := dtsRegistro;
  end;

  // Cria e configura as colunas do DBGrid

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'IDSITUACAO';
    Title.Caption := 'Código';
    Width         := 70;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'NOME';
    Title.Caption := 'Descrição da Situação';
    Width         := 400;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'CALCULAR_X';
    Title.Caption := 'Calc.';
    Width         := 30;
  end;

  ClientWidth := kMaxWidthColumn( dbgRegistro.Columns, Rate);

end;

procedure TFrmSituacao.CreateDataSet;
begin

  with mtRegistro do
  begin

    FieldDefs.Add('IDSITUACAO', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('CALCULAR_X', ftSmallInt);

    IndexFieldNames := 'IDSITUACAO';

    AfterCancel  := mtRegistroAfterCancel;
    AfterOpen    := mtRegistroAfterOpen;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit   := mtRegistroBeforeEdit;

  end;

end;

procedure TFrmSituacao.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir a situação "'+DataSet.Fields[1].AsString + '" ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmSituacao.mtRegistroBeforeEdit(DataSet: TDataSet);
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

procedure TFrmSituacao.mtRegistroAfterCancel(DataSet: TDataSet);
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

procedure TFrmSituacao.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDSITUACAO').ProviderFlags := [pfInKey];
end;

procedure TFrmSituacao.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  if TDBGrid(Sender).DataSource.DataSet.FieldByName('CALCULAR_X').AsInteger = 0 then
    TDBGrid(Sender).Canvas.Font.Color := clRed;
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

end.
