{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro da Sequência de Cálculo

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
unit fsequencia;
{$ENDIF}

{$I flivre.inc}

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
  TFrmSequencia = class(TFrmDialogo)
    mtRegistroIDGP: TIntegerField;
    mtRegistroIDEVENTO: TIntegerField;
    mtRegistroSEQUENCIA: TSmallintField;
    mtRegistroEVENTO: TStringField;
    mtRegistroFORMULA: TStringField;
    mtRegistroIDFORMULA: TIntegerField;
    mtRegistroTIPO_EVENTO: TStringField;
    mtRegistroTIPO_CALCULO: TStringField;
    mtRegistroTIPO_SALARIO: TStringField;
    mtRegistroATIVO_X: TSmallintField;
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
    dbGE, dbGP: TAKDBEdit;
    dbEvento: TAKDBEdit;
    dbFormula: TAKDBEdit;
  private
    procedure PesquisaGrupoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure mtRegistroTIPO_EVENTOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure mtRegistroTIPO_CALCULOGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure mtRegistroTIPO_SALARIOGetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    { Private declarations }
  public
    { Public declarations }
    procedure Pesquisar; override;
    procedure Iniciar; override;
    constructor Create(AOwner: TComponent); override;
  end;

procedure CriaSequencia;

implementation

uses fdb, ftext, fsuporte, fevento, fformula, fgrupo_empresa, fgrupo_pagamento,
  fbase, futil;

const
  C_UNIT = 'fsequencia.pas';

procedure CriaSequencia;
var
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmSequencia) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  with TFrmSequencia.Create(Application) do
    try
      pvTabela := 'F_SEQUENCIA';
      Iniciar();
      Show();
    except
      on E:Exception do
      begin
        kErro( E.Message, C_UNIT, 'CriaSequencia()');
        Free;
      end;
    end;

end;  // CriaSequencia

{TFrmSequencia}

constructor TFrmSequencia.Create(AOwner: TComponent);
var
  Panel1: TPanel;
  Label1: TLabel;
  Control1: TWinControl;
  iLeft, iTop: Integer;
begin

  inherited;

  kMDIChild(Self);

  OnActivate := FormResize;
  OnClose := FormClose;
  OnResize := FormResize;

  Caption          := 'Sequência de Cálculo';
  RxTitulo.Caption := ' + '+Caption;

  OnKeyDown := FormKeyDown;

  dbgRegistro.OnTitleClick := NIL;

  mtRegistro.AfterCancel  := mtRegistroAfterCancel;
  mtRegistro.AfterOpen    := mtRegistroAfterOpen;
  mtRegistro.BeforeDelete := mtRegistroBeforeDelete;
  mtRegistro.BeforeEdit   := mtRegistroBeforeEdit;
  mtRegistro.BeforeInsert := mtRegistroBeforeInsert;
  mtRegistro.OnNewRecord  := mtRegistroNewRecord;

  // Criação de componentes locais

  cdFiltro := TClientDataSet.Create(Self);
  dsFiltro := TDataSource.Create(Self);
  dsFiltro.DataSet := cdFiltro;

  PnlTitulo.Align := alNone;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent   := PnlClaro;
    Align    := alTop;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Color    := PnlControle.Color;
    Height   := 55;
    TabOrder := PnlTitulo.TabOrder + 1;
  end;

  PnlTitulo.Align := alTop;

  iLeft := 8;
  iTop  := 8;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel1;
    Caption := 'Grupo de Empresa';
    Left    := iLeft;
    Top     := iTop;
  end;

  dbGE := TAKDBEdit.Create(Self);

  with dbGE do
  begin
    Parent     := Panel1;
    CharCase   := ecUpperCase;
    DataSource := dsFiltro;
    DataField  := 'IDGE';
    Left       := Label1.Left;
    Top        := Label1.Top+Label1.Height+3;
    Width      := 30;
    OnButtonClick := PesquisaGrupoClick;
    iLeft      := Left + Width + ButtonSpacing + EditButton.Width + 5;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel1;
    DataSource  := dsFiltro;
    DataField   := 'GE';
    Left        := iLeft;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 220;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
    Label1.FocusControl := Control1;
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

  dbGP := TAKDBEdit.Create(Self);

  with dbGP do
  begin
    Parent     := Panel1;
    CharCase   := ecUpperCase;
    DataSource := dsFiltro;
    DataField  := 'IDGP';
    Left       := Label1.Left;
    Top        := Label1.Top+Label1.Height+3;
    Width      := 30;
    OnButtonClick := PesquisaGrupoClick;
    iLeft      := Left + Width + ButtonSpacing + EditButton.Width + 5;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := Panel1;
    DataSource  := dsFiltro;
    DataField   := 'GP';
    Left        := iLeft;
    Top         := Label1.Top+Label1.Height+3;
    Width       := 220;
    ParentColor := True;
    ReadOnly    := True;
    TabStop     := False;
  end;

  // Colunas

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'SEQUENCIA';
    Title.Caption := 'Ordem';
    Width := 40;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'IDEVENTO';
    Title.Caption := 'Código';
    Width := 40;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'EVENTO';
    Title.Caption := 'Descrição do Evento';
    Width := 200;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'TIPO_EVENTO';
    Title.Caption := 'Tipo';
    Width := 60;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'TIPO_CALCULO';
    Title.Caption := 'Cálculo';
    Width := 100;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'TIPO_SALARIO';
    Title.Caption := 'Salário';
    Width := 100;
  end;

  with dbgRegistro.Columns.Add do
  begin
    FieldName := 'FORMULA';
    Title.Caption := 'Fórmula na Sequência';
    Width := 140;
  end;

  // Cadastro

  iLeft := 8;
  iTop  := 8;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'ID Evento';
    Left    := iLeft;
    Top     := iTop;
  end;

  dbEvento := TAKDBEdit.Create(Self);

  with dbEvento do
  begin
    Parent        := Panel;
    CharCase      := ecUpperCase;
    DataSource    := dtsRegistro;
    DataField     := 'IDEVENTO';
    Left          := Label1.Left;
    Top           := Label1.Top+Label1.Height+3;
    Width         := 60;
    OnButtonClick := dbEventoButtonClick;
    Label1.FocusControl := dbEvento;
  end;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Descrição do Evento';
    if (dbEvento is TAKDBEdit) then
      Left := dbEvento.EditButton.Left +
              dbEvento.EditButton.Width + 5
    else
      Left := dbEvento.Left + dbEvento.Width + 5;
    Top := iTop;
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

  dbFormula := TAKDBEdit.Create(Self);

  with dbFormula do
  begin
    Parent        := Panel;
    CharCase      := ecUpperCase;
    DataSource    := dtsRegistro;
    DataField     := 'IDFORMULA';
    Left          := Label1.Left;
    Top           := Label1.Top+Label1.Height+3;
    Width         := 60;
    OnButtonClick := dbFormulaButtonClick;
  end;

  // Sequencia

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := Panel;
    Caption := 'Sequência';
    if (dbEvento is TAKDBEdit) then
      Left := dbFormula.EditButton.Left + dbFormula.EditButton.Width + 5
    else
      Left := dbFormula.Left + dbFormula.Width + 5;
    Top     := iTop;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent        := Panel;
    DataSource    := dtsRegistro;
    DataField     := 'SEQUENCIA';
    Left          := Label1.Left;
    Top           := Label1.Top+Label1.Height+3;
    Width         := 80;
  end;

  iTop := Control1.Top + Control1.Height + 5;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Caption := 'Se for especificada uma fórmula para o cálculo do evento nesta sequência'#13+
                 'apenas o resultado desta fórmula formará o valor calculado do evento,'#13+
                 'sendo todas as outras informações desconsideradas.';
    Parent := Panel;
    Top := iTop;
    Left := 8;
    Font.Color := clRed;
    Font.Style := [fsBold];
    AutoSize := True;
  end;

  // Ajustar a altura do Panel de edicao
  Panel.Height := Label1.Top + Label1.Height + 10;

  Panel.Visible := False;
  Panel.Visible := True;

end;

procedure TFrmSequencia.Iniciar;
var
  i: Integer;
  SQL: TStringList;
  cdGE: TClientDataSet;
begin

  SQL := TStringList.Create;
  cdGE := TClientDataSet.Create(NIL);

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  P.IDGP, P.IDGE, P.NOME AS GP, E.NOME GE');
    SQL.Add('FROM');
    SQL.Add('  F_GRUPO_PAGAMENTO P, F_GRUPO_EMPRESA E');
    SQL.Add('WHERE');
    SQL.Add('  E.IDGE = P.IDGE');
    SQL.EndUpdate;

    kOpenSQL( cdFiltro, SQL.Text);

    kOpenTable(cdGE, 'F_GRUPO_EMPRESA');

    // Posiciona no Grupo de Pagamento da Folha Atual
    cdFiltro.Locate('IDGP', kGrupoPagamentoFolhaAtiva(), []);

  finally
    SQL.Free;
    cdGE.Free;
  end;

  lblPrograma.Caption := 'Sequência';
  pnlPesquisa.Visible := False;
  PnlEscuro.Visible := False;

  // ajusta o tamanho horizontal da coluna DESCRICAO
  i := kMaxWidthColumn(dbgRegistro.Columns, Rate);

  if (dbgRegistro.Width > i) then
    dbgRegistro.Columns[2].Width :=
      dbgRegistro.Columns[2].Width + (PnlClaro.Width - i)
  else
    dbgRegistro.Columns.Delete(5);

  inherited;

end;

procedure TFrmSequencia.Pesquisar;
var
  iGP: Integer;
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  S.*, F.NOME FORMULA, E.NOME EVENTO,');
    SQL.Add('  E.TIPO_EVENTO, E.TIPO_CALCULO, E.TIPO_SALARIO, E.ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_SEQUENCIA S');
    SQL.Add('  LEFT JOIN F_FORMULA F ON (F.IDFORMULA = S.IDFORMULA),');
    SQL.Add('  F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  S.IDGP = :GP AND E.IDEVENTO = S.IDEVENTO');
    SQL.Add('ORDER BY');
    SQL.Add('  S.SEQUENCIA, S.IDEVENTO');
    SQL.EndUpdate;

    iGP := cdFiltro.FieldByName('IDGP').AsInteger;

    if not kOpenSQL( mtRegistro, SQL.Text, [iGP]) then
      Exception.Create(kGetErrorLastSQL);

    mtRegistro.IndexFieldNames := 'SEQUENCIA;IDEVENTO';

  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'Pesquisar()');
  end;
  finally
    SQL.Free;
  end;

end;  // Pesquisar

procedure TFrmSequencia.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando: Boolean;
begin

  bEditando := (pvDataSet.State in [dsInsert,dsEdit]);

  if (Key = VK_RETURN) and (ActiveControl = dbGE) then
  begin
    if FindGrupoEmpresa( dbGE.Text, cdFiltro, Key, True) then
      Pesquisar();

  end else if (Key = VK_RETURN) and (ActiveControl = dbGP) then
  begin
    if FindGrupoPagamento( dbGP.Text, cdFiltro.FieldByName('IDGE').AsInteger, cdFiltro, Key, True) then
      Pesquisar();

  end else if (Key = VK_RETURN) and bEditando and (ActiveControl = dbEvento) then
    FindEvento( dbEvento.Text, pvDataSet, Key)

  else if (Key = VK_RETURN) and bEditando and (ActiveControl = dbFormula) then
    FindFormula( dbFormula.Text, pvDataSet, Key);

  inherited;

end;

procedure TFrmSequencia.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('IDGP').AsInteger      := cdFiltro.FieldByName('IDGP').AsInteger;
  DataSet.FieldByName('SEQUENCIA').AsInteger := 0;
end;

procedure TFrmSequencia.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Retirar o Evento "'+
              DataSet.FieldByName('EVENTO').AsString+'" da sequência ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmSequencia.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbFormula.SetFocus;
  dbEvento.Enabled := False;
end;

procedure TFrmSequencia.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  dbEvento.Enabled := True;
end;

procedure TFrmSequencia.mtRegistroAfterOpen(DataSet: TDataSet);
begin
  DataSet.FieldByName('IDGP').ProviderFlags         := [pfInKey];
  DataSet.FieldByName('IDEVENTO').ProviderFlags     := [pfInKey];
  DataSet.FieldByName('EVENTO').ProviderFlags       := [pfHidden];
  DataSet.FieldByName('FORMULA').ProviderFlags      := [pfHidden];
  with DataSet.FieldByName('TIPO_EVENTO') do
  begin
    ProviderFlags  := [pfHidden];
    OnGetText := mtRegistroTIPO_EVENTOGetText;
  end;
  with DataSet.FieldByName('TIPO_CALCULO') do
  begin
    ProviderFlags  := [pfHidden];
    OnGetText := mtRegistroTIPO_CALCULOGetText;
  end;
  with DataSet.FieldByName('TIPO_SALARIO') do
  begin
    ProviderFlags  := [pfHidden];
    OnGetText := mtRegistroTIPO_SALARIOGetText;
  end;
  DataSet.FieldByName('ATIVO_X').ProviderFlags      := [pfHidden];
end;

procedure TFrmSequencia.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbEvento.SetFocus;
end;

procedure TFrmSequencia.dbEventoButtonClick(Sender: TObject);
begin
  FindEvento( '', TAKDBEdit(Sender).DataSource.DataSet);
end;

procedure TFrmSequencia.dbFormulaButtonClick(Sender: TObject);
begin
  FindFormula( '', mtRegistro);
end;

procedure TFrmSequencia.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kEventoDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmSequencia.PesquisaGrupoClick(Sender: TObject);
var
  Key: Word;
  bResult: Boolean;
begin

  bResult := False;

  if Sender = dbGE then
    bResult := FindGrupoEmpresa( '*', dbGE.DataSource.DataSet, Key, True)
  else if Sender = dbGP then
    bResult := FindGrupoPagamento( '*', dbGE.Field.AsInteger,
                                   dbGP.DataSource.DataSet, Key, True);

  if bResult then
    Pesquisar();

end;

procedure TFrmSequencia.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmSequencia.FormResize(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TFrmSequencia.mtRegistroTIPO_EVENTOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if (Sender.AsString = 'B') then
     Text := 'Base'
  else if (Sender.AsString = 'D') then
     Text := 'Desconto'
  else if (Sender.AsString = 'P') then
     Text := 'Provento';
end;

procedure TFrmSequencia.mtRegistroTIPO_CALCULOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if (Sender.AsString = 'C') then
     Text := 'Contra-Partida'
  else if (Sender.AsString = 'D') then
     Text := 'Dia Trabalhado'
  else if (Sender.AsString = 'F') then
     Text := 'Fórmula'
  else if (Sender.AsString = 'H') then
     Text := 'Hora Trabalhada'
  else if (Sender.AsString = 'I') then
     Text := 'Valor Informado';
end;

procedure TFrmSequencia.mtRegistroTIPO_SALARIOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := '';
  if (Sender.AsString = 'F') then
     Text := 'Fixo'
  else if (Sender.AsString = 'V') then
     Text := 'Variável'
  else if (Sender.AsString = 'P') then
     Text := 'Produção/Peça';
end;

end.
