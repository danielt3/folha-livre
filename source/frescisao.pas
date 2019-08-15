{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro da Sequência de Cálculo

Copyright (c) 2005 Allan Lima, Belém-Pará-Brasil.

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
unit frescisao;
{$ENDIF}

{$I flivre.inc}

{.$UNDEF AK_LABEL}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs,
  QGrids, QDBGrids, QComCtrls, QButtons, QMask, QStdCtrls,
  QExtCtrls, QDBCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ComCtrls, Buttons, Mask, StdCtrls,
  ExtCtrls, DBCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fdialogo, DB, DBClient, Types;

type
  TFrmRescisao = class(TFrmDialogo)
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure dbEventoButtonClick(Sender: TObject);
    procedure dbFormulaButtonClick(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  protected
    cdFiltro: TClientDataSet;
    dsFiltro: TDataSource;
    lbEvento: TLabel;
    {$IFDEF AK_LABEL}
    dbGE: TAKDBEdit;
    dbGP: TAKDBEdit;
    dbSindicato: TAKDBEdit;
    dbRescisao: TAKDBEdit;
    dbEvento: TAKDBEdit;
    dbFormula: TAKDBEdit;
    {$ELSE}
    dbGE: TDBEdit;
    dbGP: TDBEdit;
    dbSindicato: TDBEdit;
    dbRescisao: TDBEdit;
    dbEvento: TDBEdit;
    dbFormula: TDBEdit;
    {$ENDIF}
  private
    { Private declarations }
    {$IFDEF AK_LABEL}
    procedure PesquisaGrupoClick(Sender: TObject);
    {$ENDIF}
  public
    { Public declarations }
    procedure Pesquisar; override;
    procedure Iniciar; override;
    constructor Create(AOwner: TComponent); override;
  end;

procedure CriaRescisao;

implementation

uses fdb, ftext, ffind, fsuporte, fevento, fformula, fgrupo_empresa,
  fgrupo_pagamento, fsindicato, fbase, frescisao_causa;

const
  C_UNIT = 'frescisao.pas';

procedure CriaRescisao;
begin

  with TFrmRescisao.Create(Application) do
    try try
      pvTabela := 'F_RESCISAO_EVENTO';
      Iniciar();
      ShowModal;
    except
      on E:Exception do
        kErro( E.Message, C_UNIT, 'CriaRescisao()');
    end;
    finally
      Free;
    end;

end;  // CriaRescisao

{TFrmRescisao}

constructor TFrmRescisao.Create(AOwner: TComponent);
var
  Panel1: TPanel;
  Label1: TLabel;
  Control1: TWinControl;
  iTop, iLeft, iHeight, iWidth: Integer;
begin

  inherited;

  Caption          := 'Eventos para a Rescisão';
  RxTitulo.Caption := ' + '+Caption;

  OnKeyDown := FormKeyDown;

  mtRegistro.AfterCancel  := mtRegistroAfterCancel;
  mtRegistro.AfterOpen    := mtRegistroAfterOpen;
  mtRegistro.BeforeDelete := mtRegistroBeforeDelete;
  mtRegistro.BeforeEdit   := mtRegistroBeforeEdit;
  mtRegistro.BeforeInsert := mtRegistroBeforeInsert;
  mtRegistro.OnNewRecord  := mtRegistroNewRecord;

  // Criação de componentes locais

  cdFiltro := TClientDataSet.Create(Self);

  cdFiltro.FieldDefs.BeginUpdate;
  cdFiltro.FieldDefs.Add('IDGE', ftInteger);
  cdFiltro.FieldDefs.Add('GE', ftString, 30);
  cdFiltro.FieldDefs.Add('IDGP', ftInteger);
  cdFiltro.FieldDefs.Add('GP', ftString, 30);
  cdFiltro.FieldDefs.Add('IDSINDICATO', ftInteger);
  cdFiltro.FieldDefs.Add('SINDICATO', ftString, 50);
  cdFiltro.FieldDefs.Add('IDRESCISAO', ftString, 2);
  cdFiltro.FieldDefs.Add('RESCISAO', ftString, 50);
  cdFiltro.FieldDefs.EndUpdate;

  dsFiltro := TDataSource.Create(Self);
  dsFiltro.DataSet := cdFiltro;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent   := PnlClaro;
    Align    := alTop;
    Height   := 55;
    Color    := PnlControle.Color;
    TabOrder := 0
  end;

  Label1 := TLabel.Create(Self);

  iTop  := 8;
  iLeft := 8;

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Grupo de Empresa';
    Left    := iLeft;
    Top     := iTop;
  end;

  {$IFDEF AK_LABEL}
  dbGE := TAKDBEdit.Create(Self);
  {$ELSE}
  dbGE := TDBEdit.Create(Self);
  {$ENDIF}

  with dbGE do
  begin
    Parent     := Panel1;
    CharCase   := ecUpperCase;
    DataSource := dsFiltro;
    DataField  := 'IDGE';
    Left       := Label1.Left;
    Top        := Label1.Top+Label1.Height+3;
    Width      := 30;
    iLeft      := Left + Width + 5;
    {$IFDEF AK_LABEL}
    if ClassNameIs('TAKDBEdit') then
    begin
      iLeft         := iLeft + ButtonSpacing + EditButton.Width;
      OnButtonClick := PesquisaGrupoClick;
    end;
    {$ENDIF}
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel1;
    DataSource  := dsFiltro;
    DataField   := 'GE';
    Left        := iLeft;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 250;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
    iLeft       := Left + Width + 5;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Grupo de Pagamento';
    Left    := iLeft;
    Top     := iTop;
  end;

  {$IFDEF AK_LABEL}
  dbGP := TAKDBEdit.Create(Self);
  {$ELSE}
  dbGP := TDBEdit.Create(Self);
  {$ENDIF}

  with dbGP do
  begin
    Parent        := Panel1;
    CharCase      := ecUpperCase;
    DataSource    := dsFiltro;
    DataField     := 'IDGP';
    Left          := Label1.Left;
    Top           := Label1.Top+Label1.Height+3;
    Width         := 30;
    iLeft         := Left + Width + 5;
    {$IFDEF AK_LABEL}
    if ClassNameIs('TAKDBEdit') then
    begin
      iLeft         := iLeft + ButtonSpacing + EditButton.Width;
      OnButtonClick := PesquisaGrupoClick;
    end;
    {$ENDIF}
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel1;
    DataSource  := dsFiltro;
    DataField   := 'GP';
    Left        := iLeft;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 250;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
  end;

  iTop  := Control1.Top + Control1.Height + 5;
  iLeft := 8;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Sindicato';
    Top     := iTop;
    Left    := iLeft;
  end;

  {$IFDEF AK_LABEL}
  dbSindicato := TAKDBEdit.Create(Self);
  {$ELSE}
  dbSindicato := TDBEdit.Create(Self);
  {$ENDIF}

  with dbSindicato do
  begin
    Parent     := Panel1;
    CharCase   := ecUpperCase;
    DataSource := dsFiltro;
    DataField  := 'IDSINDICATO';
    Left       := iLeft;
    Top        := Label1.Top+Label1.Height+3;
    Width      := 30;
    iTop       := Top;
    iLeft      := Left + Width + 5;
    {$IFDEF AK_LABEL}
    if ClassNameIs('TAKDBEdit') then
    begin
      iLeft         := iLeft + ButtonSpacing + EditButton.Width;
      OnButtonClick := PesquisaGrupoClick;
    end;
    {$ENDIF}
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel1;
    DataSource  := dsFiltro;
    DataField   := 'SINDICATO';
    Left        := iLeft;
    Top         := iTop;
    Width       := 250;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
    iLeft       := Left + Width + 5;
  end;

  iTop := Label1.Top;

  // Tipo de Rescisao

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Tipo de Rescisão';
    Top     := iTop;
    Left    := iLeft;
  end;

  {$IFDEF AK_LABEL}
  dbRescisao := TAKDBEdit.Create(Self);
  {$ELSE}
  dbRescisao := TDBEdit.Create(Self);
  {$ENDIF}

  with dbRescisao do
  begin
    Parent     := Panel1;
    CharCase   := ecUpperCase;
    DataSource := dsFiltro;
    DataField  := 'IDRESCISAO';
    Left       := Label1.Left;
    Top        := Label1.Top+Label1.Height+3;
    Width      := 30;
    iTop       := Top;
    iLeft      := Left + Width + 5;
    {$IFDEF AK_LABEL}
    if ClassNameIs('TAKDBEdit') then
    begin
      iLeft         := iLeft + ButtonSpacing + EditButton.Width;
      OnButtonClick := PesquisaGrupoClick;
    end;
    {$ENDIF}
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel1;
    DataSource  := dsFiltro;
    DataField   := 'RESCISAO';
    Left        := iLeft;
    Top         := iTop;
    Width       := 250;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
  end;

  Panel1.Height := Control1.Top + Control1.Height + 10;
  ClientWidth   := Control1.Left + Control1.Width + 10;

  // Colunas

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'IDEVENTO';
    Title.Caption := 'ID Evento';
    Width := 60;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'EVENTO';
    Title.Caption := 'Descrição do Evento';
    Width := 280;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'FORMULA';
    Title.Caption := 'Fórmula';
    Width := 150;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'MES_DIREITO';
    Title.Caption := 'Meses Direito';
    Width := Canvas.TextWidth(Title.Caption)+5;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'INFORMACAO_X';
    Title.Caption := 'Req. Inf.';
    Width := Canvas.TextWidth(Title.Caption)+5;
  end;

  // Cadastro

  lbEvento := TLabel.Create(Self);

  with lbEvento do
  begin
    Parent  := Panel;
    Caption := 'ID Evento';
    Left    := 8;
    Top     := 8;
    iTop    := Top;
  end;

  {$IFDEF AK_LABEL}
  dbEvento := TAKDBEdit.Create(Self);
  {$ELSE}
  dbEvento := TDBEdit.Create(Self);
  {$ENDIF}

  with {$IFDEF AK_LABEL}TAKDBEdit(Control1){$ELSE}
                        TDBEdit(Control1){$ENDIF} do

  with dbEvento do
  begin
    Parent        := Panel;
    CharCase      := ecUpperCase;
    DataSource    := dtsRegistro;
    DataField     := 'IDEVENTO';
    Left          := lbEvento.Left;
    Top           := lbEvento.Top+lbEvento.Height+3;
    Width         := 60;
    iLeft         := Left + Width + 5;
    {$IFDEF AK_LABEL}
    if ClassNameIs('TAKDBEdit') then
    begin
      iLeft := iLeft + ButtonSpacing + EditButton.Width;
      OnButtonClick := dbEventoButtonClick;
    end;
    {$ENDIF}
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Descrição do Evento';
    Left    := iLeft;
    Top     := iTop;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel;
    DataSource  := dtsRegistro;
    DataField   := 'EVENTO';
    Left        := Label1.Left;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 250;
    ReadOnly    := True;
    TabStop     := False;
    ParentColor := True;
  end;

  // Formula

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Fórmula';
    Left    := Control1.Left + Control1.Width + 5;
    Top     := iTop;
  end;

  {$IFDEF AK_LABEL}
  dbFormula := TAKDBEdit.Create(Self);
  {$ELSE}
  dbFormula := TDBEdit.Create(Self);
  {$ENDIF}

  with dbFormula do
  begin
    Parent        := Panel;
    CharCase      := ecUpperCase;
    DataSource    := dtsRegistro;
    DataField     := 'IDFORMULA';
    Left          := Label1.Left;
    Top           := Label1.Top+Label1.Height+3;
    Width         := 60;
    iLeft         := Left + Width + 5;
    {$IFDEF AK_LABEL}
    iLeft         := iLeft + ButtonSpacing + EditButton.Width;
    OnButtonClick := dbFormulaButtonClick;
    {$ENDIF}
    iHeight := Height;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent   := Panel;
    Caption  := 'Meses-Direito';
    Left     := iLeft;
    Top      := iTop;
    Hint     := 'Informe o número minímo de meses de admissão para ter direito a esse evento';
    ShowHint := True;

  end;

  with TDBEdit.Create(Self) do
  begin
    Parent      := Panel;
    DataSource  := dtsRegistro;
    DataField   := 'MES_DIREITO';
    Left        := Label1.Left;
    Top         := Label1.Top+Label1.Height+3;
    Width       := Canvas.TextWidth(Label1.Caption);
    iLeft       := Left + Width + 5;
    Hint        := Label1.Hint;
    ShowHint    := Label1.ShowHint;
  end;

  with TDBCheckBox.Create(Self) do
  begin
    Parent         := Panel;
    DataSource     := dtsRegistro;
    DataField      := 'INFORMACAO_X';
    Left           := iLeft;
    Top            := Label1.Top+Label1.Height+3;
    Caption        := 'Requer Informação?';
    AllowGrayed    := False;
    ValueChecked   := '1';
    ValueUnchecked := '0';
    Width          := (Canvas.TextWidth('W')*2) + Canvas.TextWidth(Caption);
    iWidth         := Left + Width;
  end;

  // Ajustar a altura do Panel de edicao
  Panel.Height := Control1.Top + Control1.Height + 10;

  // Ajustar a altura do formulario
  ClientHeight := PnlTitulo.Height + (Panel.Height * 5) +
                  Panel1.Height + PnlControle.Height;
  
end;

procedure TFrmRescisao.Iniciar;
begin
  cdFiltro.CreateDataSet;
  cdFiltro.Append;
  inherited;
end;

procedure TFrmRescisao.Pesquisar;
var
  iGP, iSindicato: Integer;
  sRescisao: String;
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  R.*, F.NOME AS FORMULA, E.NOME AS EVENTO, E.TIPO_EVENTO, E.ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_RESCISAO_EVENTO R');
    SQL.Add('  LEFT JOIN F_FORMULA F ON (F.IDFORMULA = R.IDFORMULA),');
    SQL.Add('  F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  R.IDGP = :GP AND R.IDSINDICATO = :SINDICATO');
    SQL.Add('  AND R.IDRESCISAO = :RESCISAO');
    SQL.Add('  AND E.IDEVENTO = R.IDEVENTO');
    SQL.Add('ORDER BY');
    SQL.Add('  R.IDEVENTO');
    SQL.EndUpdate;

    iGP        := cdFiltro.FieldByName('IDGP').AsInteger;
    iSindicato := cdFiltro.FieldByName('IDSINDICATO').AsInteger;
    sRescisao  := cdFiltro.FieldByName('IDRESCISAO').AsString;

    if not kOpenSQL( mtRegistro, SQL.Text, [iGP, iSindicato, sRescisao]) then
      Exception.Create(kGetErrorLastSQL);

    mtRegistro.IndexFieldNames := 'IDEVENTO';

  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'Pesquisar()');
  end;
  finally
    SQL.Free;
  end;

end;  // Pesquisar

procedure TFrmRescisao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando: Boolean;
begin

  bEditando := (pvDataSet.State in [dsInsert,dsEdit]);

  if (Key = VK_ESCAPE) then
    Close

  else if (Key = VK_RETURN) and (ActiveControl = dbGE) then
  begin
    if FindGrupoEmpresa( dbGE.Text, dbGE.DataSource.DataSet, Key, True) then
      Pesquisar();

  end else if (Key = VK_RETURN) and (ActiveControl = dbGP) then
  begin
    if FindGrupoPagamento( dbGP.Text, StrToInt(dbGE.Text),
                           dbGP.DataSource.DataSet, Key, True) then
      Pesquisar();

  end else if (Key = VK_RETURN) and (ActiveControl = dbSindicato) then
  begin
    if FindSindicato( dbSindicato.Text, dbSindicato.DataSource.DataSet, Key, True) then
      Pesquisar();

  end else if (Key = VK_RETURN) and (ActiveControl = dbRescisao) then
  begin
    if FindRescisaoCausa( dbRescisao.Text, dbRescisao.DataSource.DataSet, Key, True) then
      Pesquisar();

  end else if (Key = VK_RETURN) and bEditando and (ActiveControl = dbEvento) then
    FindEvento( dbEvento.Text, pvDataSet, Key)

  else if bEditando and (Key = VK_RETURN) and (ActiveControl = dbFormula) then
    FindFormula( dbFormula.Text, pvDataSet, Key)

  else if (Key = VK_RETURN) and bEditando and (ActiveControl = kGetLastTabOrder(Panel)) then
     Key := VK_F3;

  inherited;

end;

procedure TFrmRescisao.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('IDGP').AsInteger        := cdFiltro.FieldByName('IDGP').AsInteger;
    FieldByName('IDSINDICATO').AsInteger := cdFiltro.FieldByName('IDSINDICATO').AsInteger;
    FieldByName('IDRESCISAO').AsString   := cdFiltro.FieldByName('IDRESCISAO').AsString;
  end;
end;

procedure TFrmRescisao.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Retirar o Evento "'+
              DataSet.FieldByName('EVENTO').AsString+'" da sequência ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmRescisao.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbFormula.SetFocus;
  lbEvento.Enabled := False;
  dbEvento.Enabled := False;
end;

procedure TFrmRescisao.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbEvento.Enabled := True;
  dbEvento.Enabled := True;
end;

procedure TFrmRescisao.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('IDGP').ProviderFlags         := [pfInKey];
    FieldByName('IDSINDICATO').ProviderFlags  := [pfInKey];
    FieldByName('IDRESCISAO').ProviderFlags   := [pfInKey];
    FieldByName('IDEVENTO').ProviderFlags     := [pfInKey];
    FieldByName('EVENTO').ProviderFlags       := [pfHidden];
    FieldByName('FORMULA').ProviderFlags      := [pfHidden];
    FieldByName('TIPO_EVENTO').ProviderFlags  := [pfHidden];
    FieldByName('ATIVO_X').ProviderFlags      := [pfHidden];
  end;
end;

procedure TFrmRescisao.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbEvento.SetFocus;
end;

procedure TFrmRescisao.dbEventoButtonClick(Sender: TObject);
begin
  FindEvento( '', TDBEdit(Sender).DataSource.DataSet);
end;

procedure TFrmRescisao.dbFormulaButtonClick(Sender: TObject);
begin
  FindFormula( '', mtRegistro);
end;

procedure TFrmRescisao.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kEventoDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

{$IFDEF AK_LABEL}
procedure TFrmRescisao.PesquisaGrupoClick(Sender: TObject);
var
  Key: Word;
  bResult: Boolean;
  DataSet1: TDataSet;
begin

  bResult  := False;
  DataSet1 := TDBEdit(Sender).DataSource.DataSet;

  if (Sender = dbGE) then
    bResult := FindGrupoEmpresa( '*', DataSet1, Key, True)
  else if (Sender = dbGP) then
    bResult := FindGrupoPagamento( '*', DataSet1.FieldByName('IDGE').AsInteger, DataSet1, Key, True)
  else if (Sender = dbSindicato) then
    bResult := FindSindicato( '*', DataSet1, Key, True)
  else if (Sender = dbRescisao) then
    bResult := FindRescisaoCausa( '*', DataSet1, Key, True);

  if bResult then
    Pesquisar();

end;
{$ENDIF}

end.
