{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Opcoes do CAGED

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
@file-date: 28/05/2005
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

{$IFNDEF QFLIVRE}
unit fcaged;
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
  TFrmCAGED = class(TFrmDialogo)
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

function FindCAGED( Tipo, Pesquisa: String; var ID, Nome: String):Boolean; overload;
function FindCAGED( Tipo, Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean; overload;

procedure CriaCAGED;

implementation

uses fdb, ftext, fsuporte, ffind;

function FindCAGED( Tipo, Pesquisa: String; var ID, Nome: String):Boolean;
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
      sWhere := 'IDCAGED = '+QuotedStr(Pesquisa)
    else
      sWhere := 'NOME LIKE '+QuotedStr(Pesquisa+'%');

    if (Tipo <> '') then
    begin
      if (sWhere <> '') then
        sWhere := sWhere + ' AND ';
      sWhere := sWhere + 'TIPO = '+QuotedStr(Tipo);
    end;

    sSelect := 'SELECT IDCAGED, NOME, TIPO FROM F_CAGED';

    if (sWhere <> '') then
      sSelect := sSelect + ' WHERE '+sWhere;

    if not kOpenSQL( DataSet1, sSelect) then
      raise Exception.Create(kGetErrorLastSQL);

    Result :=  ( (DataSet1.RecordCount = 1) or
                 kFindDataSet( DataSet1, 'Pesquisando CAGED',
                               'IDCAGED', vValue, [foNoPanel, foNoTitle] ) );

    if Result then
    begin
      ID   := DataSet1.FieldByName('IDCAGED').AsString;
      Nome := DataSet1.FieldByName('NOME').AsString;
    end;

  finally
    DataSet1.Free;
  end;

end;  // FindCAGED

function FindCAGED( Tipo, Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean;
var
  Codigo, Nome: String;
begin

  Result := FindCAGED( Tipo, Pesquisa, Codigo, Nome);

  if Result then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDCAGED')) then
          DataSet.FieldByName('IDCAGED').AsString := Codigo;
        if Assigned(DataSet.FindField('CAGED')) then
          DataSet.FieldByName('CAGED').AsString := Nome
        else if Assigned(DataSet.FindField('NOME')) then
          DataSet.FieldByName('NOME').AsString := Nome
      end;

    end;

  end else
  begin
    kErro('CAGED não encontrado !!!');
    Key := 0;
  end;

end;  // FindCAGED

procedure CriaCAGED;
begin

  with TFrmCAGED.Create(Application) do
  try
    pvTabela := 'F_CAGED';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // procedure CriaCAGED

constructor TFrmCAGED.Create(AOwner: TComponent);
var
  Label1: TLabel;
  Control1: TControl;
  iLeft, iTop: Integer;
begin

  inherited;

  CreateDataSet();

  Caption := 'Cadastro de CAGED';
  RxTitulo.Caption := ' · Listagem de CAGED';

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
    DataField := 'IDCAGED';
    DataSource := dtsRegistro;
    iLeft  := Left + Width + 5;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent := Panel;
    Left   := iLeft;
    Top    := iTop;
    Caption := 'Descrição do CAGED';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Name       := 'dbNome';
    Parent     := Panel;;
    Left       := iLeft;
    Top        := Label1.Top + Label1.Height + 3;
    Width      := 350;
    //CharCase   := ecUpperCase;
    DataField  := 'NOME';
    DataSource := dtsRegistro;
    iLeft      := Left + Width + 5;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Left    := iLeft;
    Top     := iTop;
    Caption := 'Tipo [A,D]';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent     := Panel;;
    Left       := iLeft;
    Top        := Label1.Top + Label1.Height + 3;
    Width      := Canvas.TextWidth(Label1.Caption);
    CharCase   := ecUpperCase;
    DataField  := 'TIPO';
    DataSource := dtsRegistro;
  end;

  // Cria e configura as colunas do DBGrid

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'IDCAGED';
    Title.Caption := 'Código';
    Width         := 70;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'NOME';
    Title.Caption := 'Descrição da Causa';
    Width         := 400;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName     := 'TIPO';
    Title.Caption := 'A/D';
    Width         := 30;
  end;

  ClientWidth := kMaxWidthColumn( dbgRegistro.Columns, Rate);

end;

procedure TFrmCAGED.CreateDataSet;
begin

  with mtRegistro do
  begin

    FieldDefs.Add('IDCAGED', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('TIPO', ftString, 1);

    IndexFieldNames := 'IDCAGED';

    AfterCancel  := mtRegistroAfterCancel;
    AfterOpen    := mtRegistroAfterOpen;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit   := mtRegistroBeforeEdit;

  end;

end;

procedure TFrmCAGED.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'EXCLUIR o CAGED "'+DataSet.Fields[1].AsString + '" ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmCAGED.mtRegistroBeforeEdit(DataSet: TDataSet);
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

procedure TFrmCAGED.mtRegistroAfterCancel(DataSet: TDataSet);
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

procedure TFrmCAGED.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDCAGED').ProviderFlags := [pfInKey];
end;

end.
