{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2002-2007 Allan Lima, Belém-Pará-Brasil.

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

{$IFNDEF QFLIVRE}
unit finformado;
{$ENDIF}

{$I flivre.inc}

interface

uses
  SysUtils, Classes, Types,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls, QDBCtrls,
  QMask, QGrids, QDBGrids, QComCtrls, QButtons, QMenus,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, DBCtrls,
  Mask, Grids, DBGrids, ComCtrls, Buttons, Menus,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fdialogo, DBClient, StrUtils, DB;

type
  TFrmInformado = class(TFrmDialogo)
  protected
    {Protected declarations }
    cdFuncionario: TClientDataSet;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure dbEventoButtonClick(Sender: TObject);
    procedure dbFuncButtonClick(Sender: TObject);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure cdFuncionarioCPF_CGCGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure GetData; override;
  private
    { Private declarations }
    function GetFuncionario: String; overload;
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure cdFuncionarioAfterOpen(DataSet: TDataSet);
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
    procedure Pesquisar; override;
  end;

procedure CriaInformado;

implementation

uses fdeposito, fdb, ftext, fsuporte, fevento, fformula, fgrupo_pagamento,
  ffind, futil, MaskUtils;

procedure CriaInformado;
begin

  if not kIsDeposito('FOLHA_ID') then
    Exit;

  with TFrmInformado.Create(Application) do
  try try
    pvTabela := 'F_INFORMADO';
    Iniciar();
    ShowModal;
  except
    on E:Exception do kErro( E.Message, 'finformado', 'CriaInformado()');
  end;
  finally
    Free;
  end;

end;  // procedure CriaInformado

constructor TFrmInformado.Create(AOwner: TComponent);
var
  Panel1: TPanel;
  Label1: TLabel;
  Control1: TControl;
  DataSource1: TDataSource;
begin

  inherited;

  Caption          := 'Eventos Informados';
  RxTitulo.Caption := ' · Eventos Informados para o Funcionário';

  OnKeyDown := FormKeyDown;

  mtRegistro.AfterCancel  := mtRegistroAfterCancel;
  mtRegistro.AfterOpen    := mtRegistroAfterOpen;
  mtRegistro.AfterPost    := mtRegistroAfterPost;
  mtRegistro.BeforeDelete := mtRegistroBeforeDelete;
  mtRegistro.BeforeEdit   := mtRegistroBeforeEdit;
  mtRegistro.BeforePost   := mtRegistroBeforePost;
  mtRegistro.OnNewRecord  := mtRegistroNewRecord;

  // Criação de DataSet e DataSource

  with mtRegistro do
  begin
    FieldDefs.Add('IDEMPRESA', ftInteger);
    FieldDefs.Add('IDFOLHA', ftInteger);
    FieldDefs.Add('IDFUNCIONARIO', ftInteger);
    FieldDefs.Add('ID', ftInteger);
    FieldDefs.Add('IDEVENTO', ftInteger);
    FieldDefs.Add('EVENTO', ftString, 50);
    FieldDefs.Add('TIPO_EVENTO', ftString, 1);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    FieldDefs.Add('INFORMADO', ftCurrency);
    CreateDataSet;
  end;

  cdFuncionario := TClientDataSet.Create(Self);

  with cdFuncionario do
  begin
    AfterOpen := cdFuncionarioAfterOpen;
    FieldDefs.Add('IDFUNCIONARIO', ftInteger);
    FieldDefs.Add('FUNCIONARIO', ftString, 50);
    FieldDefs.Add('IDGP', ftInteger);
    FieldDefs.Add('CPF_CGC', ftString, 14);
    CreateDataSet;
  end;

  DataSource1         := TDataSource.Create(Self);
  DataSource1.DataSet := cdFuncionario;

  // Criação do Panel de Pesquisa de Funcionarios

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent   := Panel.Parent;
    Align    := alTop;
    Caption  := '';
    Color    := PnlControle.Color;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'ID Func.';
    Left    := 8;
    Top     := 8;
  end;

  Control1 := {$IFDEF AK_LABEL}TAKDBEdit.Create(Self);
              {$ELSE}TDBEdit.Create(Self);{$ENDIF}

  with {$IFDEF AK_LABEL}TAKDBEdit(Control1)
       {$ELSE}TDBEdit(Control1){$ENDIF} do
  begin
    Parent     := Label1.Parent;
    Name       := 'dbFuncionario';
    Top        := Label1.Top + Label1.Height + 5;
    Left       := Label1.Left;
    DataSource := DataSource1;
    DataField  := 'IDFUNCIONARIO';
    Width      := 50;
    {$IFDEF AK_LABEL}
    EditButton.OnClick := dbFuncButtonClick;
    {$ENDIF}
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Control1.Parent;
    Caption := 'Nome do Funcionário';
    Top     := 8;
    Left    := Control1.Left + Control1.Width +
               {$IFDEF AK_LABEL}TAKDBEdit(Control1).EditButton.Width +
                                TAKDBEdit(Control1).ButtonSpacing +
               {$ENDIF}5;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Label1.Parent;
    Top         := Label1.Top + Label1.Height + 5;
    Left        := Label1.Left;
    DataSource  := DataSource1;
    DataField   := 'FUNCIONARIO';
    Width       := 350;
    TabStop     := False;
    ParentColor := True;
    ReadOnly    := True;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Control1.Parent;
    Caption := 'CPF';
    Top     := 8;
    Left    := Control1.Left + Control1.Width + 5;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Label1.Parent;
    Top         := Label1.Top + Label1.Height + 5;
    Left        := Label1.Left;
    DataSource  := DataSource1;
    DataField   := 'CPF_CGC';
    Width       := 100;
    TabStop     := False;
    ParentColor := True;
    ReadOnly    := True;
  end;

  Panel1.Height := Control1.Top + Control1.Height + 10;

  // Configura a grade de exibicao dos dados

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'IDEVENTO';
    Title.Caption := 'ID Evento';
    Width := Round( Rate * 60);
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'EVENTO';
    Title.Caption := 'Descrição do Evento';
    Width := Round( Rate * 320);
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'TIPO_EVENTO';
    Title.Caption := 'Evento';
    Width := Round( Rate * 50);
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'INFORMADO';
    Title.Caption := 'Informado';
    Width := Round( Rate * 85);
  end;

  dbgRegistro.OnDrawColumnCell := dbgRegistroDrawColumnCell;

  // Criação dos controles de edição de registro

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'ID E&vento';
    Top     := 8;
    Left    := 8;
  end;

  Control1 := {$IFDEF AK_LABEL}TAKDBEdit.Create(Self);
              {$ELSE}TDBEdit.Create(Self);{$ENDIF}

  with {$IFDEF AK_LABEL}TAKDBEdit(Control1)
       {$ELSE}TDBEdit(Control1){$ENDIF} do
  begin
    Parent     := Panel;
    Top        := Label1.Top + Label1.Height + 5;
    Left       := Label1.Left;
    DataSource := dtsRegistro;
    DataField  := 'IDEVENTO';
    Width      := 60;
    Name       := 'dbEvento';
    {$IFDEF AK_LABEL}
    EditButton.OnClick := dbEventoButtonClick;
    {$ENDIF}
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Descrição do Evento';
    Top     := 8;
    Left    := Control1.Left + Control1.Width +
               {$IFDEF AK_LABEL}TAKDBEdit(Control1).EditButton.Width +
                                TAKDBEdit(Control1).ButtonSpacing +
               {$ENDIF}5;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel;
    Top         := Label1.Top + Label1.Height + 5;
    Left        := Label1.Left;
    DataSource  := dtsRegistro;
    DataField   := 'EVENTO';
    Width       := 310;
    TabStop     := False;
    ParentColor := True;
    ReadOnly    := True;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Qtde/Valor';
    Top     := 8;
    Left    := Control1.Left + Control1.Width + 5;
    Name    := 'dbInformado';
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel;
    Top         := Label1.Top + Label1.Height + 5;
    Left        := Label1.Left;
    DataSource  := dtsRegistro;
    DataField   := 'INFORMADO';
    Width       := 100;
  end;

  Panel.Height := Control1.Top + Control1.Height + 10;

end;

procedure TFrmInformado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) and (ActiveControl.Name = 'dbFuncionario') then
  begin

    if not (cdFuncionario.State in [dsInsert,dsEdit]) then
      cdFuncionario.Edit;

    PesquisaFuncionario( TDBEdit(ActiveControl).Text,
                         pvEmpresa, cdFuncionario, Key);

    if (cdFuncionario.State in [dsInsert,dsEdit]) then
      cdFuncionario.Post;

    if (Key <> 0) then
      GetData();

  end else if (Key = VK_SPACE) and (ActiveControl is TDBGrid) then
  begin
    if Assigned(TDBGrid(ActiveControl).OnDblClick) then
      TDBGrid(ActiveControl).OnDblClick(ActiveControl);

  end else if (Key = VK_RETURN) and (ActiveControl.Name = 'dbEvento') and
              (pvDataSet.State in [dsInsert,dsEdit]) then
    FindEvento( TDBEdit(ActiveControl).Text, pvDataSet, Key);

  inherited;

end;

procedure TFrmInformado.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('IDEMPRESA').AsInteger    := pvEmpresa;
    FieldByName('IDFOLHA').AsInteger      := pvFolha;
    FieldByName('IDFUNCIONARIO').AsString := GetFuncionario();
    FieldByName('ID').AsInteger           := 0;
    FieldByName('IDEVENTO').AsString      := '';
    FieldByName('INFORMADO').AsCurrency   := 0.00
  end;
end;

procedure TFrmInformado.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Retirar o Evento "'+
              DataSet.FieldByName('EVENTO').AsString+'" para o funcionário ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmInformado.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  TDBEdit(FindComponent('dbEvento')).SetFocus;
end;

procedure TFrmInformado.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  TDBEdit(FindComponent('dbEvento')).SetFocus;
end;

procedure TFrmInformado.dbEventoButtonClick(Sender: TObject);
var
  Key: Word;
begin
  FindEvento( '', pvDataSet, Key);
end;

procedure TFrmInformado.GetData;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  I.*, E.NOME EVENTO, E.TIPO_EVENTO, E.ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_INFORMADO I, F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  I.IDEMPRESA = :EMPRESA AND I.IDFOLHA = :FOLHA');
    SQL.Add('  AND I.IDFUNCIONARIO = :FUNCIONARIO');
    SQL.Add('  AND E.IDEVENTO = I.IDEVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( pvDataSet, SQL.Text,
                     [pvEmpresa, pvFolha, GetFuncionario]) then
      raise Exception.Create(kGetErrorLastSQL);

  except
    on E:Exception do
      kErro( E.Message, 'finformado', 'GetData()');
  end;
  finally
    SQL.Free;
  end;

end;  // procedure GetData

procedure TFrmInformado.Pesquisar;
begin
  GetData();
end;

procedure TFrmInformado.dbFuncButtonClick(Sender: TObject);
var Key: Word;
begin

  if not (cdFuncionario.State in [dsInsert,dsEdit]) then
    cdFuncionario.Edit;

  PesquisaFuncionario( '', pvEmpresa, cdFuncionario, Key);

  if (cdFuncionario.State in [dsInsert,dsEdit]) then
    cdFuncionario.Post;

  GetData();

end;

procedure TFrmInformado.mtRegistroAfterPost(DataSet: TDataSet);
begin
  inherited;
  if (DataSet.Tag = 1) then
  begin
    GetData();
    DataSet.Append;
  end;
end;

procedure TFrmInformado.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('ID').AsInteger = 0) then
      FieldByName('ID').AsInteger := kMaxCodigo( pvTabela, 'ID', pvEmpresa,
         'IDFOLHA = '+IntToStr(pvFolha)+' AND IDFUNCIONARIO = '+GetFuncionario);
  inherited;
end;

function TFrmInformado.GetFuncionario: String;
begin
  Result := cdFuncionario.FieldByName('IDFUNCIONARIO').AsString;
end;

procedure TFrmInformado.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kEventoDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmInformado.cdFuncionarioCPF_CGCGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    if ( Length(Text) = 11 ) then
      Text := FormatMaskText( '999\.999\.999\-99;0', Text)
    else if ( Length(Text) = 14 ) then
      Text := FormatMaskText( '99\.999\.999\-9999\/99;0', Text);
end;

procedure TFrmInformado.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDEMPRESA').ProviderFlags     := [pfInKey];
    FieldByName('IDFOLHA').ProviderFlags       := [pfInKey];
    FieldByName('IDFUNCIONARIO').ProviderFlags := [pfInKey];
    FieldByName('ID').ProviderFlags            := [pfInKey];
    FieldByName('EVENTO').ProviderFlags        := [pfHidden];
    FieldByName('TIPO_EVENTO').ProviderFlags   := [pfHidden];
    FieldByName('ATIVO_X').ProviderFlags       := [pfHidden];
    TCurrencyField(FieldByName('INFORMADO')).DisplayFormat := '0.##';
  end;
end;

procedure TFrmInformado.cdFuncionarioAfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('CPF_CGC').OnGetText := cdFuncionarioCPF_CGCGetText;
end;


end.
