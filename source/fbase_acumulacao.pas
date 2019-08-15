{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Base de Acumulação

Copyright (c) 2004-2005 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@file-name: fbase_acumulacao.pas
@file-date: 14/12/2004
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
}

//  Histórico das alterações
//
//  1.0 - versão inicial - 12/02/2005 - Allan
//

{$IFNDEF QFLIVRE}
unit fbase_acumulacao;
{$ENDIF}

{$I flivre.inc}

interface

uses
  Classes, SysUtils,
  {$IFDEF MSWINDOWS}
  Windows, Messages, ShellAPI,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Buttons, DBCtrls, StdCtrls, ExtCtrls,
  Dialogs, Grids, DBGrids, ComCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QButtons, QDBCtrls, QStdCtrls, QExtCtrls,
  QDialogs, QGrids, QDBGrids, QComCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  {$IFDEF FL_D6}DateUtils,{$ELSE}cDateTime,{$ENDIF}
  Variants, fcadastro, DB, DBClient;

type
  TFrmBases = class(TFrmCadastro)
  protected
    PageControl2: TPageControl;
    TabDados, TabTipos, TabEventos: TTabSheet;
    dsTipos, dsEventos: TDataSource;
    cdTipos, cdEventos: TClientDataSet;
    procedure mtRegistroAfterOpen(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroAfterInsert(DataSet: TDataSet);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtsRegistroStateChange(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  private
    { Private declarations }
    procedure LerTipos;
    procedure LerEventos;
    procedure AdicionarTipo(Sender: TObject);
    procedure RemoverTipo(Sender: TObject);
    procedure AdicionarEvento(Sender: TObject);
    procedure RemoverEvento(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Iniciar; override;
  end;

procedure CriaBase;

implementation

uses
  fbase, ftext, fdb, fsuporte, fdepvar, fprint,
  ffolha_tipo, fevento, fgrupo_empresa;

const
  C_UNIT = 'fbase_acumulacao.pas';

procedure CriaBase;
var
  i: Integer;
begin

  with Application do
    for i := 0 to MainForm.MDIChildCount -1 do
      if MainForm.MDIChildren[i] is TFrmBases then
      begin
        MainForm.MDIChildren[i].Show;
        Exit;
      end;

  with TFrmBases.Create(Application) do
  try
    pvTabela := 'F_BASE';
    Iniciar();
    Show;
  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'CriaBase()');
  end; // try

end;

{ TFrmBases }

constructor TFrmBases.Create(AOwner: TComponent);
var
  Panel1, Panel2: TPanel;
  Button1: TSpeedButton;
  Label1: TLabel;
  Control1: TControl;
  Comp1: TComponent;
  Grid1: TDBGrid;
  iTop, iLeft, iHeight, iWidth: Integer;
begin

  inherited;

  Caption := 'Bases de Acumulação';

  lblPrograma.Caption := 'Bases';
  TabListagem.Caption := 'Lista de Bases';
  TabDetalhe.Caption  := 'Detalhe da Base';

  OnKeyDown := FormKeyDown;

  dbgRegistro.OnDrawColumnCell := dbgRegistroDrawColumnCell;
  dtsRegistro.OnStateChange    := dtsRegistroStateChange;

  btnImprimir.OnClick := btnImprimirClick;

  with mtRegistro do
  begin

    AfterCancel  := mtRegistroAfterCancel;
    AfterOpen    := mtRegistroAfterOpen;
    AfterInsert  := mtRegistroAfterInsert;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit   := mtRegistroBeforeEdit;
    BeforePost   := mtRegistroBeforePost;
    OnNewRecord  := mtRegistroNewRecord;

    FieldDefs.Add('IDGE', ftInteger);
    FieldDefs.Add('IDBASE', ftInteger);
    FieldDefs.Add('NOME', ftString, 50);
    FieldDefs.Add('CALCULO', ftString, 1);
    FieldDefs.Add('VALOR', ftString, 1);
    FieldDefs.Add('CICLO', ftSmallInt);
    FieldDefs.Add('REGIME', ftString, 1);
    FieldDefs.Add('MES_INICIAL', ftSmallInt);
    FieldDefs.Add('COMPETENCIA_13', ftString, 1);
    FieldDefs.Add('MES_SEM_VALOR', ftString, 1);
    FieldDefs.Add('GE', ftString, 30);

  end;

  cdTipos   := TClientDataSet.Create(Self);
  cdEventos := TClientDataSet.Create(Self);

  with cdTipos do
  begin
    FieldDefs.Add('IDGE', ftInteger);
    FieldDefs.Add('IDBASE', ftInteger);
    FieldDefs.Add('IDFOLHA_TIPO', ftString, 1);
    FieldDefs.Add('FOLHA_TIPO', ftString, 30);
    CreateDataSet;
  end;

  with cdEventos do
  begin
    FieldDefs.Add('IDGE', ftInteger);
    FieldDefs.Add('IDBASE', ftInteger);
    FieldDefs.Add('IDEVENTO', ftInteger);
    FieldDefs.Add('EVENTO', ftString, 50);
    FieldDefs.Add('TIPO_EVENTO', ftString, 1);
    FieldDefs.Add('ATIVO_X', ftSmallInt);
    FieldDefs.Add('REFERENCIA', ftSmallInt);
    CreateDataSet;
  end;

  dsTipos   := TDataSource.Create(Self);
  dsEventos := TDataSource.Create(Self);

  dsTipos.DataSet   := cdTipos;
  dsEventos.DataSet := cdEventos;

  PageControl2 := TPageControl.Create(Self);

  with PageControl2 do
  begin
    Parent   := TabDetalhe;
    Align    := alClient;
    Style    := tsButtons;
    OnChange := PageControl2Change;
  end;

  TabDados := TTabSheet.Create(Self);

  with TabDados do
  begin
    PageControl := PageControl2;
    Caption := '&Dados';
  end;

  iLeft := 8;
  iTop  := 8;

  // Grupo

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Name    := 'lbGrupo';
    Caption := 'Grupo ...';
    Top     := iTop;
    Left    := iLeft;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := TabDados;
    Name        := 'dbGrupo';
    Top         := Label1.Top + Label1.Height + 5;
    Left        := iLeft;
    Width       := 50;
    DataSource  := dtsRegistro;
    DataField   := 'IDGE';
    iLeft       := Left + Width + 5;
  end;

  // Nome do grupo

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Caption := 'Nome do Grupo de Empresa';
    Top     := iTop;
    Left    := iLeft;
    Enabled := False;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := TabDados;
    Name        := 'dbGrupoNome';
    Top         := Label1.Top + Label1.Height + 5;
    Left        := iLeft;
    DataSource  := dtsRegistro;
    DataField   := 'GE';
    ParentColor := True;
    Enabled     := False;
  end;

  // Proxima linha
  iLeft := 8;
  iTop  := Control1.Top + Control1.Height + 5;

  // Codigo

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Name    := 'lbCodigo';
    Caption := 'Código';
    Top     := iTop;
    Left    := iLeft;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := TabDados;
    Name        := 'dbCodigo';
    Top         := Label1.Top + Label1.Height + 5;
    Left        := iLeft;
    Width       := 50;
    DataSource  := dtsRegistro;
    DataField   := 'IDBASE';
    iLeft       := Left + Width + 5;
  end;

  // Nome

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Caption := 'Nome da Base de Acumulação';
    Top     := iTop;
    Left    := iLeft;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent     := TabDados;
    Name       := 'dbNome';
    Top        := Label1.Top + Label1.Height + 5;
    Left       := Label1.Left;
    CharCase   := ecUpperCase;
    DataSource := dtsRegistro;
    DataField  := 'NOME';
  end;

  // Proxima Linha
  iTop  := Control1.Top + Control1.Height + 5;
  iLeft := 8;

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent     := TabDados;
    Caption    := ' Cálculo ';
    Top        := iTop;
    Left       := iLeft;
    DataSource := dtsRegistro;
    DataField  := 'CALCULO';
    Items.Add('&Acumulado');
    Items.Add('Contagem');
    Items.Add('Mé&dia');
    Items.Add('Má&ximo');
    Items.Add('Mí&nimo');
    Values.Add('A');
    Values.Add('Q');
    Values.Add('M');
    Values.Add('X');
    Values.Add('N');
    Height := Items.Count*30;
    Width  := 160;
    iHeight:= Height;
    iLeft  := Left + Width + 5;
  end;

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent     := TabDados;
    Caption    := ' &Valor ';
    Top        := iTop;
    Left       := iLeft;
    DataSource := dtsRegistro;
    DataField  := 'VALOR';
    Items.Add('&Informado');
    Items.Add('Calculado');
    Items.Add('&Referência');
    Items.Add('&Totalizado');
    Values.Add('I');
    Values.Add('C');
    Values.Add('R');
    Values.Add('T');
    Height := iHeight;
    Width  := 160;
  end;

  Comp1 := FindComponent('dbGrupoNome');
  if Assigned(Comp1) and (Comp1 is TWinControl) then
    TControl(Comp1).Width := (Control1.Left + Control1.Width) - TControl(Comp1).Left;

  Comp1 := FindComponent('dbNome');
  if Assigned(Comp1) and (Comp1 is TWinControl) then
    TControl(Comp1).Width := (Control1.Left + Control1.Width) - TControl(Comp1).Left;

  // Proxima linha
  iTop   := Control1.Top + Control1.Height + 5;
  iLeft  := 8;
  iWidth := 100;

  // Ciclo

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Name    := 'lbCiclo';
    Caption := 'Ciclo (meses)';
    Top     := iTop;
    Left    := iLeft;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := TabDados;
    Top         := Label1.Top + Label1.Height + 5;
    Left        := iLeft;
    Width       := iWidth;
    DataSource  := dtsRegistro;
    DataField   := 'CICLO';
  end;

  // Proxima Linha
  iTop  := Control1.Top + Control1.Height + 5;
  iLeft := 8;

  // Regime

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent      := TabDados;
    Caption     := 'Regime';
    Top         := iTop;
    Left        := iLeft;
    Width       := iWidth;
    DataSource  := dtsRegistro;
    DataField   := 'REGIME';
    Items.Add('Competência');   Values.Add('C');
    Items.Add('Caixa');         Values.Add('X');
    Height      := Items.Count*30;
    iLeft       := Left + Width + 5;
  end;

  // Mes inicial

  Comp1 := FindComponent('lbCiclo');
  if Assigned(Comp1) and (Comp1 is TControl) then
    iTop := TControl(Comp1).Top;

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Caption := 'Mês Inicial';
    Top     := iTop;
    Left    := iLeft;
  end;

  Control1 := TDBEdit.Create(Self);

  with TDBEdit(Control1) do
  begin
    Parent      := TabDados;
    Top         := Label1.Top + Label1.Height + 5;
    Left        := iLeft;
    Width       := iWidth;
    DataSource  := dtsRegistro;
    DataField   := 'MES_INICIAL';
  end;

  // Proxima Linha
  iTop  := Control1.Top + Control1.Height + 5;
  iLeft := Control1.Left;

  // Competência 13 - Decimo terceiro salário

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent      := TabDados;
    Caption     := 'Competência 13';
    Top         := iTop;
    Left        := iLeft;
    Width       := iWidth;
    DataSource  := dtsRegistro;
    DataField   := 'COMPETENCIA_13';
    Items.Add('Considerar');   Values.Add('C');
    Items.Add('Integrar');     Values.Add('I');
    Height      := Items.Count*30;
    iLeft       := Left + Width + 5;
  end;

  // Meses sem valores

  Control1      := TDBRadioGroup.Create(Self);
  pvLastControl := TWinControl(Control1);
  
  with TDBRadioGroup(Control1) do
  begin
    Parent      := TabDados;
    Caption     := 'Meses sem valor';
    Top         := iTop;
    Left        := iLeft;
    Width       := iWidth;
    DataSource  := dtsRegistro;
    DataField   := 'MES_SEM_VALOR';
    Items.Add('Considerar');      Values.Add('C');
    Items.Add('Desconsiderar');   Values.Add('D');
    Height      := Items.Count*30;
  end;

  TabTipos := TTabSheet.Create(Self);

  with TabTipos do
  begin
    PageControl := PageControl2;
    Caption := '&Tipos de Folhas';
  end;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := TabTipos;
    Align       := alTop;
    Alignment   := taLeftJustify;
    Caption     := ' · Relação de Tipos de Folhas';
    Color       := RxTitulo.Color;
    Font.Assign(RxTitulo.Font);
    Height      := RxTitulo.Height;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  Panel2 := TPanel.Create(Self);

  with Panel2 do
  begin
    Parent      := Panel1;
    Align       := alRight;
    Caption     := '';
    ParentColor := True;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  Button1 := TSpeedButton.Create(Self);

  with Button1 do
  begin
    Parent       := Panel2;
    Caption      := '&Adicionar...';
    ShowHint     := True;
    Hint         := 'Inclui um tipo de folha na lista';
    Font.Assign(btnDetalhar.Font);
    ParentColor  := True;
    Width        := btnDetalhar.Width;
    Flat         := btnDetalhar.Flat;
    Top          := btnDetalhar.Top;
    Left         := 8;
    OnClick      := AdicionarTipo;
  end;

  with TSpeedButton.Create(Self) do
  begin
    Parent       := Panel2;
    Caption      := '&Remover...';
    ShowHint     := True;
    Hint         := 'Retira o tipo de folha da lista';
    Font.Assign(btnDetalhar.Font);
    ParentColor  := True;
    Width        := btnDetalhar.Width;
    Flat         := btnDetalhar.Flat;
    Top          := btnDetalhar.Top;
    Left         := Button1.Left + Button1.Width + 5 ;
    Panel2.Width := Left + Width + 10;
    OnClick      := RemoverTipo;
  end;

  Grid1 := TDBGrid.Create(Self);

  with Grid1 do
  begin
    Parent := TabTipos;
    Align  := alClient;
    ParentColor := True;
    DataSource := dsTipos;
    Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
    Options := Options - [dgColumnResize];
    ReadOnly := True;
    OnDrawColumnCell := dbgRegistro.OnDrawColumnCell;
    OnTitleClick     := dbgRegistro.OnTitleClick;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'IDFOLHA_TIPO';
    Title.Caption := 'ID Tipo';
    Width := 70;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'FOLHA_TIPO';
    Title.Caption := 'Descrição do Tipo';
    Width := 400;
  end;

  // -------- Eventos -------------

  TabEventos := TTabSheet.Create(Self);

  with TabEventos do
  begin
    PageControl := PageControl2;
    Caption := 'E&ventos';
  end;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := TabEventos;
    Align       := alTop;
    Alignment   := taLeftJustify;
    Caption     := ' · Relação de Eventos';
    Color       := RxTitulo.Color;
    Font.Assign(RxTitulo.Font);
    Height      := RxTitulo.Height;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  Panel2 := TPanel.Create(Self);

  with Panel2 do
  begin
    Parent      := Panel1;
    Align       := alRight;
    Caption     := '';
    ParentColor := True;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  Button1 := TSpeedButton.Create(Self);

  with Button1 do
  begin
    Parent       := Panel2;
    Caption      := '&Adicionar...';
    ShowHint     := True;
    Hint         := 'Inclui um evento na lista';
    Font.Assign(btnDetalhar.Font);
    ParentColor  := True;
    Width        := btnDetalhar.Width;
    Flat         := btnDetalhar.Flat;
    Top          := btnDetalhar.Top;
    Left         := 8;
    OnClick      := AdicionarEvento;
  end;

  with TSpeedButton.Create(Self) do
  begin
    Parent       := Panel2;
    Caption      := '&Remover...';
    ShowHint     := True;
    Hint         := 'Retira o evento da lista';
    Font.Assign(btnDetalhar.Font);
    ParentColor  := True;
    Width        := btnDetalhar.Width;
    Flat         := btnDetalhar.Flat;
    Top          := btnDetalhar.Top;
    Left         := Button1.Left + Button1.Width + 5 ;
    Panel2.Width := Left + Width + 10;
    OnClick      := RemoverEvento;
  end;

  Grid1 := TDBGrid.Create(Self);

  with Grid1 do
  begin
    Parent := TabEventos;
    Align  := alClient;
    ParentColor := True;
    DataSource := dsEventos;
    Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
    Options := Options - [dgColumnResize];
    ReadOnly := True;
    OnDrawColumnCell := dbgRegistro.OnDrawColumnCell;
    OnTitleClick     := dbgRegistro.OnTitleClick;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'IDEVENTO';
    Title.Caption := 'ID Evento';
    Width := 70;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'EVENTO';
    Title.Caption := 'Descrição do Evento';
    Width := 400;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'TIPO_EVENTO';
    Title.Caption := 'Tipo';
    Width := 50;
  end;

end;

procedure TFrmBases.Iniciar;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    with mtListagem do
    begin
      FieldDefs.Add( 'IDBASE', ftInteger);
      FieldDefs.Add( 'NOME', ftString, 50);
      FieldDefs.Add( 'CALCULO', ftString, 15);
      FieldDefs.Add( 'VALOR', ftString, 15);
      FieldDefs.Add( 'TIPOS', ftInteger);
      FieldDefs.Add( 'EVENTOS', ftInteger);
      FieldDefs.Add( 'IDGE', ftInteger);
      FieldDefs.Add( 'GE', ftString, 30);
      CreateDataSet;
    end;

    SQL.BeginUpdate;

    if kExistProcedure('SP_BASE') then
      SQL.Add('SELECT * FROM SP_BASE')
    else begin
      { Só funciona a partir da versão 1.5 do Firebird }
      SQL.Add('SELECT');
      SQL.Add('  B.IDGE, B.IDBASE, B.NOME,');
      SQL.Add('  CASE B.CALCULO');
      SQL.Add('    WHEN ''Q'' THEN ''Contagem''');
      SQL.Add('    WHEN ''M'' THEN ''Média''');
      SQL.Add('    WHEN ''X'' THEN ''Máximo''');
      SQL.Add('    WHEN ''N'' THEN ''Mínimo''');
      SQL.Add('    ELSE ''Acumulado''');
      SQL.Add('  END AS CALCULO,');
      SQL.Add('  CASE B.VALOR');
      SQL.Add('    WHEN ''I'' THEN ''Informado''');
      SQL.Add('    WHEN ''R'' THEN ''Referência''');
      SQL.Add('    WHEN ''T'' THEN ''Totalizado''');
      SQL.Add('    ELSE ''Calculado''');
      SQL.Add('  END AS VALOR,');
      SQL.Add('  (SELECT COUNT(*) FROM F_BASE_FOLHA');
      SQL.Add('   WHERE IDGE = B.IDGE AND IDBASE = B.IDBASE) AS TIPOS,');
      SQL.Add('  (SELECT COUNT(*) FROM F_BASE_EVENTO');
      SQL.Add('   WHERE IDGE = B.IDGE AND IDBASE = B.IDBASE) AS EVENTOS,');
      SQL.Add('  GE.NOME AS GE');
      SQL.Add('FROM');
      SQL.Add('  F_BASE B, F_GRUPO_EMPRESA GE');
      SQL.Add('WHERE');
      SQL.Add('  GE.IDGE = B.IDGE')
    end;

    SQL.EndUpdate;

    pvSELECT := SQL.Text;

    kNovaColuna( mtColuna,  50,  6, 'Código');
    kNovaColuna( mtColuna, 250, 40, 'Nome da Base');
    kNovaColuna( mtColuna,  80, 10, 'Cálculo');
    kNovaColuna( mtColuna,  80, 10, 'Valor');
    kNovaColuna( mtColuna,  50,  5, 'Tipos');
    kNovaColuna( mtColuna,  50,  5, 'Eventos');
    kNovaColuna( mtColuna,  50,  6, 'Grupo');
    
  finally
    SQL.Free;
  end;

  inherited;

end;

procedure TFrmBases.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  kEventoDrawColumnCell(Sender, Rect, DataCol, Column, State);
end;

procedure TFrmBases.mtRegistroAfterOpen( DataSet: TDataSet);
begin
  DataSet.FieldByName('IDGE').ProviderFlags := [pfInKey];
  DataSet.FieldByName('IDBASE').ProviderFlags := [pfInKey];
  DataSet.FieldByName('GE').ProviderFlags := [pfHidden];
end;

procedure TFrmBases.mtRegistroAfterCancel( DataSet: TDataSet);
var
  Comp1: TComponent;
begin

  Comp1 := FindComponent('lbGrupo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := True;

  Comp1 := FindComponent('dbGrupo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := True;

  Comp1 := FindComponent('lbCodigo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := True;

  Comp1 := FindComponent('dbCodigo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := True;

end;

procedure TFrmBases.mtRegistroBeforeDelete( DataSet: TDataSet);
var
  sNome: String;
begin

  if (PageControl2.ActivePage <> TabDados) then
    PageControl2.ActivePage := TabDados;

  sNome := DataSet.FieldByName('NOME').AsString;

  if not kConfirme('Excluir a Base "'+sNome+'" ?') then
    SysUtils.Abort;

  inherited;

end;

procedure TFrmBases.mtRegistroBeforeEdit( DataSet: TDataSet);
var
  Comp1: TComponent;
begin

  if (PageControl2.ActivePage <> TabDados) then
    PageControl2.ActivePage := TabDados;

  Comp1 := FindComponent('lbGrupo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := False;

  Comp1 := FindComponent('dbGrupo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := False;

  Comp1 := FindComponent('lbCodigo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := False;

  Comp1 := FindComponent('dbCodigo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := False;

  Comp1 := FindComponent('dbNome');
  if Assigned(Comp1) and (Comp1 is TWinControl) then
    TWinControl(Comp1).SetFocus;

  inherited;

end;

procedure TFrmBases.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDBASE').AsInteger = 0) then
      FieldByName('IDBASE').AsInteger :=
         kMaxCodigo( pvTabela, 'IDBASE', 'IDGE = '+FieldByName('IDGE').AsString);
  inherited;
end;

procedure TFrmBases.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('CALCULO').AsString        := 'A';  // Acumulado
    FieldByName('VALOR').AsString          := 'C';  // Valor Calculado
    FieldByName('CICLO').AsInteger         := 12;
    FieldByName('REGIME').AsString         := 'C';  // Competencia
    FieldByName('MES_INICIAL').AsInteger   := 1;    // Janeiro
    FieldByName('COMPETENCIA_13').AsString := 'D';  // Desconsiderar
    FieldByName('MES_SEM_VALOR').AsString  := 'C';  // Considerar
  end;
end;

procedure TFrmBases.mtRegistroAfterInsert(DataSet: TDataSet);
var
  Comp1: TComponent;
begin
  inherited;
  Comp1 := FindComponent('dbGrupo');
  if Assigned(Comp1) and (Comp1 is TWinControl) then
    TWinControl(Comp1).SetFocus;
end;

procedure TFrmBases.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando: Boolean;
begin

  bEditando := mtRegistro.State in [dsInsert,dsEdit];

  if not Assigned(ActiveControl) then
  else if bEditando and (Key = VK_F12) and (ActiveControl is TDBEDit) and
          (TDBEdit(ActiveControl).DataField = 'IDGE') then
    FindGrupoEmpresa( '*', pvDataSet, Key)
    
  else if bEditando and (Key = VK_RETURN) and (ActiveControl is TDBEDit) and
          (TDBEdit(ActiveControl).DataField = 'IDGE') then
    FindGrupoEmpresa( TDBEdit(ActiveControl).Text, pvDataSet, Key)

  else if bEditando and (Key = VK_RETURN) and (ActiveControl.Parent = pvLastControl) then
    Key := VK_F3;

  inherited;

end;

procedure TFrmBases.dtsRegistroStateChange(Sender: TObject);
var
  bEditando: Boolean;
begin

  bEditando := (TDataSource(Sender).DataSet.State in [dsInsert,dsEdit]);

  TabTipos.TabVisible   := not bEditando;
  TabEventos.TabVisible := not bEditando;

  inherited;

end;

procedure TFrmBases.LerEventos;
begin

  with TStringList.Create do
  try

    BeginUpdate;
    Add('SELECT');
    Add('  B.IDGE, B.IDBASE, B.IDEVENTO,');
    Add('  E.NOME EVENTO, E.TIPO_EVENTO, E.ATIVO_X, B.REFERENCIA');
    Add('FROM');
    Add('  F_BASE_EVENTO B, F_EVENTO E');
    Add('WHERE');
    Add('  B.IDGE = :GE');
    Add('  AND B.IDBASE = :BASE');
    Add('  AND E.IDEVENTO = B.IDEVENTO');
    Add('ORDER BY');
    Add('  E.TIPO_EVENTO, B.IDEVENTO');
    EndUpdate;

    kOpenSQL( cdEventos, Text,
              [pvDataSet.FieldByName('IDGE').AsInteger,
               pvDataSet.FieldByName('IDBASE').AsInteger]);

  finally
    Free;
  end;

end;

procedure TFrmBases.LerTipos;
begin

  with TStringList.Create do
  try

    BeginUpdate;
    Add('SELECT');
    Add('  B.IDGE, B.IDBASE, B.IDFOLHA_TIPO, F.NOME FOLHA_TIPO');
    Add('FROM');
    Add('  F_BASE_FOLHA B, F_FOLHA_TIPO F');
    Add('WHERE');
    Add('  B.IDGE = :GE');
    Add('  AND B.IDBASE = :BASE');
    Add('  AND F.IDFOLHA_TIPO = B.IDFOLHA_TIPO');
    Add('ORDER BY');
    Add('  B.IDFOLHA_TIPO');
    EndUpdate;

    kOpenSQL( cdTipos, Text,
              [pvDataSet.FieldByName('IDGE').AsInteger,
               pvDataSet.FieldByName('IDBASE').AsInteger]);

  finally
    Free;
  end;

end;

procedure TFrmBases.PageControl2Change(Sender: TObject);
begin
  with TPageControl(Sender) do
    if Assigned(TabTipos) and (ActivePage = TabTipos) then
      LerTipos()
    else if Assigned(TabEventos) and (ActivePage = TabEventos) then
      LerEventos();
end;

procedure TFrmBases.AdicionarTipo(Sender: TObject);
var
  iGrupo, iBase, iSequencia: Integer;
  sTipo, sNome: String;
begin

  if PesquisaTipoFolha( '', sTipo, sNome, iSequencia) then
  begin

    iGrupo := pvDataSet.FieldByName('IDGE').AsInteger;
    iBase  := pvDataSet.FieldByName('IDBASE').AsInteger;

    if kExecSQL('INSERT INTO F_BASE_FOLHA'#13+
                '(IDGE, IDBASE, IDFOLHA_TIPO)'#13+
                'VALUES (:GRUPO, :TOTAL, :TIPO)', [ iGrupo, iBase, sTipo]) then
       LerTipos();

  end;

end;

procedure TFrmBases.RemoverTipo(Sender: TObject);
var
  iGrupo, iBase: Integer;
  sTipo, sNome: String;
begin

  if (cdTipos.RecordCount = 0) then
  begin
    SysUtils.Beep;
    Exit;
  end;

  iGrupo := cdTipos.FieldByName('IDGE').AsInteger;
  iBase  := cdTipos.FieldByName('IDBASE').AsInteger;
  sTipo  := cdTipos.FieldByName('IDFOLHA_TIPO').AsString;
  sNome  := cdTipos.FieldByName('FOLHA_TIPO').AsString;

  if not kConfirme('Retirar o Tipo de Folha "'+sNome+'" da lista ?') then
    Exit;

  if kExecSQL('DELETE FROM F_BASE_FOLHA'#13+
              'WHERE IDGE = :GE AND IDBASE = :BASE AND IDFOLHA_TIPO = :TIPO',
              [iGrupo, iBase, sTipo]) then
    LerTipos();

end;

procedure TFrmBases.AdicionarEvento(Sender: TObject);
var
  iGrupo, iBase, iEvento, iAtivo: Integer;
  sNome, sTipo: String;
begin

  iGrupo := pvDataSet.FieldByName('IDGE').AsInteger;
  iBase  := pvDataSet.FieldByName('IDBASE').AsInteger;

  if kEventoFind( '', iEvento, sNome, sTipo, iAtivo) and
     kExecSQL('INSERT INTO F_BASE_EVENTO'#13+
              '( IDGE, IDBASE, IDEVENTO, REFERENCIA)'#13+
              'VALUES ( :IDGE, :BASE, :EVENTO, :REFERENCIA)',
              [iGrupo, iBase, iEvento, 1]) then
    LerEventos();

end;

procedure TFrmBases.RemoverEvento(Sender: TObject);
var
  iGrupo, iBase, iEvento: Integer;
  sNome: String;
begin

  if (cdEventos.RecordCount = 0) then
  begin
    SysUtils.Beep;
    Exit;
  end;

  iGrupo  := cdEventos.FieldByName('IDGE').AsInteger;
  iBase   := cdEventos.FieldByName('IDBASE').AsInteger;
  iEvento := cdEventos.FieldByName('IDEVENTO').AsInteger;
  sNome   := cdEventos.FieldByName('EVENTO').AsString;

  if not kConfirme('Retirar o Evento "'+sNome+'" da lista ?') then
    Exit;

  if kExecSQL('DELETE FROM F_BASE_EVENTO'#13+
              'WHERE IDGE = :GE AND IDBASE = :BASE AND IDEVENTO = :EVENTO',
              [iGrupo, iBase, iEvento]) then
    LerEventos();

end;

end.
