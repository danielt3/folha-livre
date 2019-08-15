{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Totalizadores

Copyright (c) 2004-2007 Allan Lima.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada pela
Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários, porém
NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS, COMERCIAIS OU DE ATENDIMENTO
A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

- Histórico

* 30/11/2004 - Primeira versão
* 18/12/2007 - Adicionado relação de "Incidências"

}

{$IFNDEF QFLIVRE}
unit ftotalizador;
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
  TFrmTotalizador = class(TFrmCadastro)
  protected
    PageControl2: TPageControl;
    TabDados, TabTipo, TabEventos, TabIncidencia: TTabSheet;
    dsTipo, dsEvento, dsIncidencia: TDataSource;
    cdTipo, cdEvento, cdIncidencia: TClientDataSet;
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
    procedure FrmDetalharClient; override;
  private
    { Private declarations }
    procedure LerTipos;
    procedure LerEvento;
    procedure LerIncidencia;
    function AtivarIncidencia: Boolean;
    function ExcluirTotalizador: Boolean;
    procedure AdicionarEvento(Sender: TObject);
    procedure RemoverEvento(Sender: TObject);
    procedure dbgIncidenciaDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    function AtivarTipo: Boolean;
    procedure OperacaoGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DescontosGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure ProventosGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure DataSetAfterOpen(DataSet: TDataSet);
    function OperarIncidencia(Key: Word): Boolean;
    function ProventosIncidencia: Boolean;
    function DescontosIncidencia: Boolean;
    function OperarEvento(Key: Word): Boolean;
    procedure TipoEventoGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure TotalizarGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Iniciar; override;
  end;

procedure CriaTotalizador;
procedure FindTotalizador( const Pesquisa: String; DataSet: TDataSet); overload;
procedure FindTotalizador( const Pesquisa: String; DataSet: TDataSet; var Key: Word); overload;
function kTotalizadorFind( const Pesquisa: String; var Codigo: Integer;
  var Nome: String):Boolean;

implementation

uses
  fbase, ftext, fdb, fsuporte, fdepvar, fprint, fevento, ffind, StrUtils,
  Math;

const
  C_UNIT = 'ftotalizador.pas';

procedure CriaTotalizador;
var
  i: Integer;
begin

  with Application do
    for i := 0 to MainForm.MDIChildCount -1 do
      if MainForm.MDIChildren[i] is TFrmTotalizador then
      begin
        MainForm.MDIChildren[i].Show;
        Exit;
      end;

  with TFrmTotalizador.Create(Application) do
  try
    pvTabela := 'F_TOTALIZADOR';
    Iniciar();
    Show;
  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'CriaTotalizar()');
  end; // try

end;

procedure FindTotalizador( const Pesquisa: String; DataSet: TDataSet; var Key: Word);
var
  Codigo: Integer;
  Nome: String;
begin

  if kTotalizadorFind( Pesquisa, Codigo, Nome) then
  begin
    if (DataSet.State in [dsInsert,dsEdit]) then
    begin
      if Assigned( DataSet.FindField('IDTOTALIZADOR')) then
        DataSet.FieldByName('IDTOTALIZADOR').AsInteger := Codigo;
      if Assigned( DataSet.FindField('TOTALIZADOR')) then
        DataSet.FieldByName('TOTALIZADOR').AsString := Nome;
    end;
  end else
  begin
    kErro('Totalizador não encontrado. Tente novamente !!!');
    Key := 0;
  end;

end;

procedure FindTotalizador( const Pesquisa: String; DataSet: TDataSet);
var
  Key: Word;
begin
  FindTotalizador( Pesquisa, DataSet, Key);
end;

function kTotalizadorFind( const Pesquisa: String; var Codigo: Integer;
  var Nome: String):Boolean;
var
  sPesquisa: String;
  DataSet1: TClientDataSet;
  SQL: TStringList;
  vResult: Variant;
begin

  Codigo    := 0;
  Nome      := '';
  Result    := False;
  sPesquisa := Pesquisa;

  if (sPesquisa <> EmptyStr) then
    sPesquisa := kSubstitui( sPesquisa, '*', '%');

  SQL := TStringList.Create;
  DataSet1 := TClientDataSet.Create(NIL);

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT IDTOTAL, NOME FROM F_TOTALIZADOR');
    if (sPesquisa = EmptyStr) or (sPesquisa = '%') then
    else if kNumerico(sPesquisa) then
      SQL.Add('WHERE IDTOTAL = '+sPesquisa)
    else
      SQL.Add('WHERE NOME LIKE '+QuotedStr(sPesquisa+'%'));
    SQL.Add('ORDER BY NOME');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text) then
      Exit;

    if not kFindDataSet( DataSet1, 'Procurando Totalizador...', 'IDTOTAL',
                         vResult, [foNoPanel, foNoTitle]) then
      Exit;

    Codigo := DataSet1.FieldByName('IDTOTAL').AsInteger;
    Nome   := DataSet1.FieldByName('NOME').AsString;

    Result := True;

  finally
    SQL.Free;
    DataSet1.Free;
  end;

end;


{ TFrmTotalizador }

constructor TFrmTotalizador.Create(AOwner: TComponent);
var
  Panel1, Panel2: TPanel;
  Button1: TSpeedButton;
  Label1: TLabel;
  Control1: TControl;
  Comp1: TComponent;
  Grid1: TDBGrid;
  iTop, iLeft: Integer;
begin

  inherited;

  Caption := 'Totalizadores';

  lblPrograma.Caption := 'Totalizadores';
  TabListagem.Caption := 'Lista de Totalizadores';
  TabDetalhe.Caption := 'Detalhe do Totalizador';

  OnKeyDown := FormKeyDown;

  dbgRegistro.OnDrawColumnCell := dbgRegistroDrawColumnCell;
  dtsRegistro.OnStateChange := dtsRegistroStateChange;

  btnImprimir.OnClick := btnImprimirClick;

  with mtRegistro do
  begin

    AfterCancel := mtRegistroAfterCancel;
    AfterOpen := mtRegistroAfterOpen;
    AfterInsert := mtRegistroAfterInsert;
    BeforeDelete := mtRegistroBeforeDelete;
    BeforeEdit := mtRegistroBeforeEdit;
    BeforePost := mtRegistroBeforePost;
    OnNewRecord := mtRegistroNewRecord;

    FieldDefs.Add('IDTOTAL', ftInteger);
    FieldDefs.Add('NOME', ftString, 50);
    FieldDefs.Add('CALCULO', ftString, 1);
    FieldDefs.Add('VALOR', ftString, 1);

  end;

  cdTipo := TClientDataSet.Create(Self);
  cdEvento := TClientDataSet.Create(Self);
  cdIncidencia := TClientDataSet.Create(Self);

  with cdTipo do
  begin
    FieldDefs.Add('IDTOTAL', ftInteger);
    FieldDefs.Add('IDFOLHA_TIPO', ftString, 1);
    FieldDefs.Add('FOLHA_TIPO', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    FieldDefs.Add('TOTALIZAR_X', ftSmallint);
    AfterOpen := DataSetAfterOpen;
    CreateDataSet;
  end;

  with cdEvento do
  begin
    FieldDefs.Add('IDTOTAL', ftInteger);
    FieldDefs.Add('IDEVENTO', ftInteger);
    FieldDefs.Add('EVENTO', ftString, 50);
    FieldDefs.Add('TIPO_EVENTO', ftString, 1);
    FieldDefs.Add('OPERACAO', ftSmallint);
    AfterOpen := DataSetAfterOpen;
    CreateDataSet;
  end;

  with cdIncidencia do
  begin
    FieldDefs.Add('IDTOTAL', ftInteger);
    FieldDefs.Add('IDINCIDENCIA', ftInteger);
    FieldDefs.Add('INCIDENCIA', ftString, 30);
    FieldDefs.Add('PROVENTOS_X', ftSmallint);
    FieldDefs.Add('DESCONTOS_X', ftSmallint);
    FieldDefs.Add('OPERACAO', ftSmallint);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    AfterOpen := DataSetAfterOpen;
    CreateDataSet;
  end;

  dsTipo := TDataSource.Create(Self);
  dsEvento := TDataSource.Create(Self);
  dsIncidencia := TDataSource.Create(Self);

  dsTipo.DataSet := cdTipo;
  dsEvento.DataSet := cdEvento;
  dsIncidencia.DataSet := cdIncidencia;

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
    Caption := 'Dados';
  end;

  iLeft := 8;
  iTop  := 8;

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
    Parent     := TabDados;
    Name       := 'dbCodigo';
    Top        := Label1.Top + Label1.Height + 5;
    Left       := iLeft;
    Width      := 60;
    DataSource := dtsRegistro;
    DataField  := 'IDTOTAL';
    iLeft      := Left + Width + 5;
  end;

  // Nome

  Label1 := TLabel.Create(Self);

  with Label1 do
  begin
    Parent  := TabDados;
    Caption := 'Nome do Totalizador';
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
    Width      := 350;
  end;

  // Proxima Linha

  iTop  := Control1.Top + Control1.Height + 5;
  iLeft := 8;

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent     := TabDados;
    Name       := 'dbCalculo';
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
    Height := 130;
    Width  := 160;
    iLeft  := Left + Width + 10;
  end;

  Control1 := TDBRadioGroup.Create(Self);

  with TDBRadioGroup(Control1) do
  begin
    Parent     := TabDados;
    Name       := 'dbValor';
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
    Height := 130;
    Width  := 160;
  end;

  Comp1 := FindComponent('dbNome');
  if Assigned(Comp1) and (Comp1 is TWinControl) then
    TControl(Comp1).Width := (Control1.Left + Control1.Width) - TControl(Comp1).Left;

  // Tipos de Folhas

  TabTipo := TTabSheet.Create(Self);

  with TabTipo do
  begin
    PageControl := PageControl2;
    Caption := '&Tipos de Folha';
  end;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := TabTipo;
    Align       := alTop;
    Alignment   := taLeftJustify;
    Caption     := ' · Relação de Tipos de Folha';
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

  Grid1 := TDBGrid.Create(Self);

  with Grid1 do
  begin
    Name := 'dbgtipo';
    Parent := TabTipo;
    Align  := alClient;
    ParentColor := True;
    DataSource := dsTipo;
    Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
    Options := Options - [dgColumnResize];
    ReadOnly := True;
    OnDrawColumnCell := dbgIncidenciaDrawColumnCell;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'IDFOLHA_TIPO';
    Title.Caption := 'Tipo';
    Width := 70;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'FOLHA_TIPO';
    Title.Caption := 'Descrição do Tipo';
    Width := 400;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'TOTALIZAR_X';
    Alignment := taCenter;
    Title.Caption := 'Totalizar';
    Title.Alignment := taCenter;
    Width := 70;
  end;

  with TLabel.Create(Self) do
  begin
    Parent := TabTipo;
    Align := alBottom;
    Alignment := taCenter;
    Caption := 'Pressione a tecla <espaço> para ativar/desativar o tipo de folha'+sLineBreak+
               'Importante: Se nenhum tipo estiver ativado, o sistema considerará apenas os tipos cujo campo "Totalizar" seja "Sim"';
    Font.Color := clRed;
    Font.Style := [fsBold];
    Height := Trunc(Height * 1.3);
    Layout := tlCenter;
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
    DataSource := dsEvento;
    Name := 'dbgevento';
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
    Width := 100;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'OPERACAO';
    Title.Alignment := taCenter;
    Title.Caption := '+/-';
    Width := 30;
  end;

  with TLabel.Create(Self) do
  begin
    Parent := TabEventos;
    Align := alBottom;
    Alignment := taCenter;
    Caption := 'Pressione as teclas <+> e <-> para escolher a operação';
    Font.Color := clRed;
    Font.Style := [fsBold];
    Height := Trunc(Height * 1.5);
    Layout := tlCenter;
  end;

  // -------- Incidencias -------------

  TabIncidencia := TTabSheet.Create(Self);

  with TabIncidencia do
  begin
    PageControl := PageControl2;
    Caption := '&Incidências';
  end;

  Panel1 := TPanel.Create(Self);

  with Panel1 do
  begin
    Parent      := TabIncidencia;
    Align       := alTop;
    Alignment   := taLeftJustify;
    Caption     := ' · Relação de Incidências';
    Color       := RxTitulo.Color;
    Font.Assign(RxTitulo.Font);
    Height      := RxTitulo.Height;
    BevelInner  := bvNone;
    BevelOuter  := bvNone;
    BorderStyle := bsNone;
  end;

  Grid1 := TDBGrid.Create(Self);

  with Grid1 do
  begin
    Name := 'dbgincidencia';
    Parent := TabIncidencia;
    Align  := alClient;
    ParentColor := True;
    DataSource := dsIncidencia;
    Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
    Options := Options - [dgColumnResize];
    ReadOnly := True;
    OnDrawColumnCell := dbgIncidenciaDrawColumnCell;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'IDINCIDENCIA';
    Title.Caption := 'Código';
    Width := 70;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'INCIDENCIA';
    Title.Caption := 'Descrição da Incidência';
    Width := 400;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'DESCONTOS_X';
    Title.Alignment := taCenter;
    Title.Caption := 'Descontos';
    Width := 70;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'PROVENTOS_X';
    Title.Alignment := taCenter;
    Title.Caption := 'Proventos';
    Width := 70;
  end;

  with Grid1.Columns.Add do
  begin
    FieldName := 'OPERACAO';
    Title.Alignment := taCenter;
    Title.Caption := '+/-';
    Width := 30;
  end;

  with TLabel.Create(Self) do
  begin
    Parent := TabIncidencia;
    Align := alBottom;
    Alignment := taCenter;
    Caption := 'Pressione a tecla <Espaço> para incluir/remover a incidência da lista'+sLineBreak+
               'Pressione a tecla <D> para ativar/desativar o campo "Descontos"'+sLineBreak+
               'Pressione a tecla <P> para ativar/desativar o campo "Proventos"'+sLineBreak+
               'Pressione as teclas <+> e <-> para escolher a operação';
    Font.Color := clRed;
    Font.Style := [fsBold];
    Height := Trunc(Height * 1.5);
    Layout := tlCenter;
  end;

end;

procedure TFrmTotalizador.Iniciar;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    with mtListagem do
    begin
      FieldDefs.Add( 'IDTOTAL', ftInteger);
      FieldDefs.Add( 'NOME', ftString, 50);
      FieldDefs.Add( 'CALCULO', ftString, 15);
      FieldDefs.Add( 'VALOR', ftString, 15);
      FieldDefs.Add( 'TIPOS', ftInteger);
      FieldDefs.Add( 'EVENTOS', ftInteger);
      FieldDefs.Add( 'INCIDENCIAS', ftInteger);
      CreateDataSet;
    end;

    SQL.BeginUpdate;

    SQL.Add('SELECT');
    SQL.Add('  T.IDTOTAL, T.NOME,');

    SQL.Add('  CASE T.CALCULO');
    SQL.Add('    WHEN ''Q'' THEN ''Contagem''');
    SQL.Add('    WHEN ''M'' THEN ''Média''');
    SQL.Add('    WHEN ''X'' THEN ''Máximo''');
    SQL.Add('    WHEN ''N'' THEN ''Mínimo''');
    SQL.Add('    ELSE ''Acumulado''');
    SQL.Add('  END AS CALCULO,');
    SQL.Add('  CASE T.VALOR');
    SQL.Add('    WHEN ''I'' THEN ''Informado''');
    SQL.Add('    WHEN ''R'' THEN ''Referência''');
    SQL.Add('    WHEN ''T'' THEN ''Totalizado''');
    SQL.Add('    ELSE ''Calculado''');
    SQL.Add('  END AS VALOR,');

    SQL.Add('  (SELECT COUNT(IDTOTAL) FROM F_TOTALIZADOR_FOLHA');
    SQL.Add('   WHERE IDTOTAL = T.IDTOTAL AND ATIVO_X = 1) AS TIPOS,');

    SQL.Add('  (SELECT COUNT(IDTOTAL) FROM F_TOTALIZADOR_EVENTO');
    SQL.Add('   WHERE IDTOTAL = T.IDTOTAL) AS EVENTOS,');

    SQL.Add('  (SELECT COUNT(IDTOTAL) FROM F_TOTALIZADOR_INCIDENCIA');
    SQL.Add('   WHERE IDTOTAL = T.IDTOTAL AND ATIVO_X = 1) AS INCIDENCIAS');

    SQL.Add('FROM');
    SQL.Add('  F_TOTALIZADOR T');
  
    SQL.EndUpdate;

    pvSELECT := SQL.Text;

    kNovaColuna( mtColuna,  50,  6, 'Código');
    kNovaColuna( mtColuna, 300, 45, 'Nome do Totalizador');
    kNovaColuna( mtColuna,  80, 10, 'Cálculo');
    kNovaColuna( mtColuna,  80, 10, 'Valor');
    kNovaColuna( mtColuna,  50,  5, 'Tipos');
    kNovaColuna( mtColuna,  50,  5, 'Eventos');
    kNovaColuna( mtColuna,  50,  5, 'Incidências');

  finally
    SQL.Free;
  end;

  inherited;

end;

procedure TFrmTotalizador.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  kEventoDrawColumnCell(Sender, Rect, DataCol, Column, State);
end;

procedure TFrmTotalizador.dbgIncidenciaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin

  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);

  if (Column.Field.DataSet.FieldByName('ATIVO_X').AsInteger = ZeroValue) then // Inativo
    TDBGrid(Sender).Canvas.Font.Color := clGray
  else
    TDBGrid(Sender).Canvas.Font.Style := [fsBold];

  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

procedure TFrmTotalizador.mtRegistroAfterOpen( DataSet: TDataSet);
begin
  DataSet.FieldByName('IDTOTAL').ProviderFlags := [pfInKey];
end;

procedure TFrmTotalizador.mtRegistroAfterCancel( DataSet: TDataSet);
var
  Comp1: TComponent;
begin

  Comp1 := FindComponent('lbCodigo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := True;

  Comp1 := FindComponent('dbCodigo');
  if Assigned(Comp1) then
    TControl(Comp1).Enabled := True;

end;

procedure TFrmTotalizador.mtRegistroBeforeDelete( DataSet: TDataSet);
var
  sNome: String;
begin

  if (PageControl2.ActivePage <> TabDados) then
    PageControl2.ActivePage := TabDados;

  sNome := DataSet.FieldByName('NOME').AsString;

  if not kConfirme('Excluir o Totalizador "'+sNome+'" ?') then
    SysUtils.Abort;

  if not ExcluirTotalizador() then
    SysUtils.Abort;

  pvDeleted := True;

end;

procedure TFrmTotalizador.mtRegistroBeforeEdit( DataSet: TDataSet);
var
  Comp1: TComponent;
begin

  if (PageControl2.ActivePage <> TabDados) then
    PageControl2.ActivePage := TabDados;

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

procedure TFrmTotalizador.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDTOTAL').AsInteger = 0) then
      FieldByName('IDTOTAL').AsInteger := kMaxCodigo( pvTabela, 'IDTOTAL');
  inherited;
end;

procedure TFrmTotalizador.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('CALCULO').AsString := 'A';
    FieldByName('VALOR').AsString   := 'C';
  end;
end;

procedure TFrmTotalizador.mtRegistroAfterInsert(DataSet: TDataSet);
var
  Comp1: TComponent;
begin
  inherited;
  PageControl2.ActivePageIndex := 0;
  Comp1 := FindComponent('dbCodigo');
  if Assigned(Comp1) and (Comp1 is TWinControl) then
    TWinControl(Comp1).SetFocus;
end;

procedure TFrmTotalizador.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando: Boolean;
begin

  bEditando := mtRegistro.State in [dsInsert,dsEdit];

  if not Assigned(ActiveControl) then

  else if bEditando and (UpperCase(ActiveControl.Name) = 'DBVALOR') and
          (Key = VK_RETURN) then
    Key := VK_F3

  else if (LowerCase(ActiveControl.Name) = 'dbgtipo') and
          (Key = VK_SPACE) then
  begin
    if AtivarTipo() then
      LerTipos();
    Key := 0;

  end else if (LowerCase(ActiveControl.Name) = 'dbgevento') and
          (Key in [VK_SUBTRACT,VK_ADD]) then
  begin
    if OperarEvento(Key) then
      LerEvento();
    Key := 0;

  end else if (LowerCase(ActiveControl.Name) = 'dbgincidencia') and
          (Key = VK_SPACE) then
  begin
    if AtivarIncidencia() then
      LerIncidencia();
    Key := 0;

  end else if (LowerCase(ActiveControl.Name) = 'dbgincidencia') and
          (Key in [VK_SUBTRACT,VK_ADD]) then
  begin
    if OperarIncidencia(Key) then
      LerIncidencia();
    Key := 0;

  end else if (LowerCase(ActiveControl.Name) = 'dbgincidencia') and
              ( (Ord('D') = Key) or (Ord('d') = Key) ) then
  begin
    if DescontosIncidencia() then
      LerIncidencia();
    Key := 0;

  end else if (LowerCase(ActiveControl.Name) = 'dbgincidencia') and
              ( (Ord('P') = Key) or (Ord('p') = Key) ) then
  begin
    if ProventosIncidencia() then
      LerIncidencia();
    Key := 0;

  end;

  inherited;

end;

procedure TFrmTotalizador.dtsRegistroStateChange(Sender: TObject);
var
  i: Integer;
  bEditando: Boolean;
begin

  bEditando := (TDataSource(Sender).DataSet.State in [dsInsert,dsEdit]);

  for i := 1 to PageControl2.PageCount - 1 do
   PageControl2.Pages[i].TabVisible := not bEditando;

  inherited;

end;

procedure TFrmTotalizador.LerEvento;
begin

  with TStringList.Create do
  try

    BeginUpdate;
    Add('SELECT');
    Add('  T.IDTOTAL, T.IDEVENTO,');
    Add('  E.NOME EVENTO, E.TIPO_EVENTO, T.OPERACAO, E.ATIVO_X');
    Add('FROM');
    Add('  F_TOTALIZADOR_EVENTO T, F_EVENTO E');
    Add('WHERE');
    Add('  T.IDTOTAL = :TOTAL AND');
    Add('  E.IDEVENTO = T.IDEVENTO');
    Add('ORDER BY');
    Add('  E.TIPO_EVENTO, T.IDEVENTO');
    EndUpdate;

    kOpenSQL( cdEvento, Text,
              [pvDataSet.FieldByName('IDTOTAL').AsInteger]);

  finally
    Free;
  end;

end;

procedure TFrmTotalizador.LerIncidencia;
var
  iTotal, i: Integer;
begin

  iTotal := pvDataSet.FieldByName('IDTOTAL').AsInteger;

  with TStringList.Create do
  try

    BeginUpdate;
    Clear;
    Add('INSERT INTO F_TOTALIZADOR_INCIDENCIA');
    Add(' (IDTOTAL, IDINCIDENCIA, PROVENTOS_X, DESCONTOS_X, OPERACAO, ATIVO_X)');
    Add(' SELECT '+IntToStr(iTotal)+', I.IDINCIDENCIA, 0, 0, 1, 0 FROM F_INCIDENCIA I');
    Add(' WHERE I.IDINCIDENCIA NOT IN');
    Add('          (SELECT IDINCIDENCIA FROM F_TOTALIZADOR_INCIDENCIA');
    Add('           WHERE IDTOTAL = :T)');
    EndUpdate;

    kExecSQL(Text, [iTotal]);

    BeginUpdate;
    Clear;
    Add('SELECT');
    Add('  T.IDTOTAL, T.IDINCIDENCIA, I.NOME AS INCIDENCIA,');
    Add('  T.PROVENTOS_X, T.DESCONTOS_X, T.OPERACAO, T.ATIVO_X');
    Add('FROM');
    Add('  F_TOTALIZADOR_INCIDENCIA T, F_INCIDENCIA I');
    Add('WHERE');
    Add('  T.IDTOTAL = :TOTAL');
    Add('  AND I.IDINCIDENCIA = T.IDINCIDENCIA');
    Add('ORDER BY');
    Add('  T.IDINCIDENCIA');
    EndUpdate;

    i := cdIncidencia.FieldByName('IDINCIDENCIA').AsInteger;

    kOpenSQL( cdIncidencia, Text, [iTotal]);

    cdIncidencia.Locate('IDINCIDENCIA', i, []);

  finally
    Free;
  end;

end;

procedure TFrmTotalizador.LerTipos;
var
  s: String;
  iTotal: Integer;
begin

  iTotal := pvDataSet.FieldByName('IDTOTAL').AsInteger;

  with TStringList.Create do
  try

    BeginUpdate;
    Clear;
    Add('INSERT INTO F_TOTALIZADOR_FOLHA');
    Add(' SELECT '+IntToStr(iTotal)+', IDFOLHA_TIPO, 0 FROM F_FOLHA_TIPO');
    Add(' WHERE IDFOLHA_TIPO NOT IN');
    Add('          (SELECT IDFOLHA_TIPO FROM F_TOTALIZADOR_FOLHA');
    Add('           WHERE IDTOTAL = :T)');
    EndUpdate;

    if not kExecSQL(Text, [iTotal]) then
      raise Exception.Create(kGetErrorLastSQL);

    BeginUpdate;
    Clear;
    Add('SELECT');
    Add('  T.IDTOTAL, T.IDFOLHA_TIPO, F.NOME FOLHA_TIPO,');
    Add('  T.ATIVO_X, F.TOTALIZAR_X');
    Add('FROM');
    Add('  F_TOTALIZADOR_FOLHA T, F_FOLHA_TIPO F');
    Add('WHERE');
    Add('  T.IDTOTAL = :TOTAL AND');
    Add('  F.IDFOLHA_TIPO = T.IDFOLHA_TIPO');
    Add('ORDER BY');
    Add('  T.IDFOLHA_TIPO');
    EndUpdate;

    s := cdTipo.FieldByName('IDFOLHA_TIPO').AsString;

    if not kOpenSQL( cdTipo, Text, [iTotal]) then
      raise Exception.Create(kGetErrorLastSQL);

    cdTipo.Locate('IDFOLHA_TIPO', s, []);

  finally
    Free;
  end;

end;

procedure TFrmTotalizador.PageControl2Change(Sender: TObject);
begin
  with TPageControl(Sender) do
    if Assigned(TabTipo) and (ActivePage = TabTipo) then
      LerTipos()
    else if Assigned(TabEventos) and (ActivePage = TabEventos) then
      LerEvento()
    else if Assigned(TabIncidencia) and (ActivePage = TabIncidencia) then
      LerIncidencia();
end;

procedure TFrmTotalizador.AdicionarEvento(Sender: TObject);
var
  iEvento, iAtivo: Integer;
  sNome, sTipo: String;
begin
  if kEventoFind( '', iEvento, sNome, sTipo, iAtivo) and
     kExecSQL('INSERT INTO F_TOTALIZADOR_EVENTO'#13+
              '( IDTOTAL, IDEVENTO, OPERACAO)'#13+
              'VALUES ( :TOTAL, :EVENTO, 1)', [GetIDInteger, iEvento]) then
    LerEvento();
end;

procedure TFrmTotalizador.RemoverEvento(Sender: TObject);
var
  iEvento: Integer;
  sNome: String;
begin

  if (cdEvento.RecordCount = 0) then
  begin
    SysUtils.Beep;
    Exit;
  end;

  iEvento := cdEvento.FieldByName('IDEVENTO').AsInteger;
  sNome   := cdEvento.FieldByName('EVENTO').AsString;

  if not kConfirme('Retirar o Evento "'+sNome+'" da lista ?') then
    Exit;

  if kExecSQL('DELETE FROM F_TOTALIZADOR_EVENTO'+sLineBreak+
              'WHERE IDTOTAL = :TOTAL AND IDEVENTO = :EVENTO',
              [GetIDInteger, iEvento]) then
    LerEvento();

end;

function TFrmTotalizador.OperarEvento(Key: Word): Boolean;
var
  iTotal, iEvento, iOperacao: Integer;
begin

  with cdEvento do
  begin
    iTotal := FieldByName('IDTOTAL').AsInteger;
    iEvento := FieldByName('IDEVENTO').AsInteger;
    if (Key = VK_SUBTRACT) then iOperacao := -1
    else if (Key = VK_ADD) then iOperacao := 1
    else iOperacao := 0;
  end;

  Result := kExecSQL('UPDATE F_TOTALIZADOR_EVENTO'+sLineBreak+
                     'SET OPERACAO = :O'+sLineBreak+
                     'WHERE IDTOTAL = :T AND IDEVENTO = :E',
                     [iOperacao, iTotal, iEvento]);

end;

function TFrmTotalizador.AtivarIncidencia: Boolean;
var
  sSQL: String;
  iTotal, iIncidencia, i: Integer;
begin

  with cdIncidencia do
  begin
    iTotal := FieldByName('IDTOTAL').AsInteger;
    iIncidencia := FieldByName('IDINCIDENCIA').AsInteger;
    if (FieldByName('ATIVO_X').AsInteger = 1) then i := 0
                                              else i := 1;
  end;

  sSQL := 'UPDATE F_TOTALIZADOR_INCIDENCIA SET ';
  if (i = 0)
    then sSQL := sSQL + 'DESCONTOS_X = 0, PROVENTOS_X = 0, ATIVO_X = 0 '
    else sSQL := sSQL + 'ATIVO_X = 1 ';

  sSQL := sSQL + 'WHERE IDTOTAL = :T AND IDINCIDENCIA = :I';

  Result := kExecSQL( sSQL, [iTotal, iIncidencia]);

end;

function TFrmTotalizador.OperarIncidencia(Key: Word): Boolean;
var
  iTotal, iIncidencia, iOperacao: Integer;
begin

  with cdIncidencia do
  begin
    iTotal := FieldByName('IDTOTAL').AsInteger;
    iIncidencia := FieldByName('IDINCIDENCIA').AsInteger;
    if (Key = VK_SUBTRACT) then iOperacao := -1
    else if (Key = VK_ADD) then iOperacao := 1
    else iOperacao := 0;
  end;

  Result := kExecSQL('UPDATE F_TOTALIZADOR_INCIDENCIA'+sLineBreak+
                     'SET OPERACAO = :O'+sLineBreak+
                     'WHERE IDTOTAL = :T AND IDINCIDENCIA = :I',
                     [iOperacao, iTotal, iIncidencia]);

end;

function TFrmTotalizador.ProventosIncidencia: Boolean;
var
  iTotal, iIncidencia, i: Integer;
begin

  with cdIncidencia do
  begin
    iTotal := FieldByName('IDTOTAL').AsInteger;
    iIncidencia := FieldByName('IDINCIDENCIA').AsInteger;
    if (FieldByName('PROVENTOS_X').AsInteger = 1) then i := 0
                                                  else i := 1;
  end;

  Result := kExecSQL('UPDATE F_TOTALIZADOR_INCIDENCIA'+sLineBreak+
                     'SET PROVENTOS_X = :P'+sLineBreak+
                     'WHERE IDTOTAL = :T AND IDINCIDENCIA = :I',
                     [i, iTotal, iIncidencia]);

end;

function TFrmTotalizador.DescontosIncidencia: Boolean;
var
  iTotal, iIncidencia, i: Integer;
begin

  with cdIncidencia do
  begin
    iTotal := FieldByName('IDTOTAL').AsInteger;
    iIncidencia := FieldByName('IDINCIDENCIA').AsInteger;
    if (FieldByName('DESCONTOS_X').AsInteger = 1) then i := 0
                                                  else i := 1;
  end;

  Result := kExecSQL('UPDATE F_TOTALIZADOR_INCIDENCIA'+sLineBreak+
                     'SET DESCONTOS_X = :D'+sLineBreak+
                     'WHERE IDTOTAL = :T AND IDINCIDENCIA = :I',
                     [i, iTotal, iIncidencia]);

end;

function TFrmTotalizador.AtivarTipo: Boolean;
var
  sTipo: String;
  iTotal, iAtivo: Integer;
begin

  with cdTipo do
  begin
    iTotal := FieldByName('IDTOTAL').AsInteger;
    sTipo := FieldByName('IDFOLHA_TIPO').AsString;
    iAtivo := FieldByName('ATIVO_X').AsInteger;
    if (iAtivo = 1) then iAtivo := 0
                    else iAtivo := 1;
  end;

  Result := kExecSQL('UPDATE F_TOTALIZADOR_FOLHA'+sLineBreak+
                     'SET ATIVO_X = :A'+sLineBreak+
                     'WHERE IDTOTAL = :T AND IDFOLHA_TIPO = :F',
                     [iAtivo, iTotal, sTipo]);

end;

function TFrmTotalizador.ExcluirTotalizador: Boolean;
var
  iTotalizador: Integer;
begin

  Result := False;

  if not kStartTransaction() then
    Exit;

  try try

    iTotalizador := pvDataSet.FieldByName('IDTOTAL').AsInteger;

    if not kExecSQL('DELETE FROM F_TOTALIZADOR_INCIDENCIA'+sLineBreak+
                    'WHERE IDTOTAL = :T', [iTotalizador], False) then
      raise Exception.Create('');

    if not kExecSQL('DELETE FROM F_TOTALIZADOR_FOLHA'+sLineBreak+
                    'WHERE IDTOTAL = :T', [iTotalizador], False) then
      raise Exception.Create('');

    if not kExecSQL('DELETE FROM F_TOTALIZADOR_EVENTO'+sLineBreak+
                    'WHERE IDTOTAL = :T', [iTotalizador], False) then
      raise Exception.Create('');

    if not kExecSQL('DELETE FROM F_TOTALIZADOR'+sLineBreak+
                    'WHERE IDTOTAL = :T', [iTotalizador], False) then
      raise Exception.Create('');

  except
    kRollbackTransaction();
  end
  finally
    Result := kCommitTransaction();
  end;

end;  // ExcluirTotalizador()

procedure TFrmTotalizador.OperacaoGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if (Text = '-1') then     Text := '-'
  else if (Text = '1') then Text := '+'
  else Text := '';
end;

procedure TFrmTotalizador.DescontosGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IfThen( Sender.AsString = '1', 'Descontos', '');
end;

procedure TFrmTotalizador.ProventosGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IfThen( Sender.AsString = '1', 'Proventos', '');
end;

procedure TFrmTotalizador.TipoEventoGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := kEventoTipo(Sender.AsString);
end;

procedure TFrmTotalizador.TotalizarGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := IfThen( Sender.AsString = '1', 'Sim', '');
end;

procedure TFrmTotalizador.DataSetAfterOpen(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if Assigned(FindField('DESCONTOS_X')) then
    begin
       FieldByName('DESCONTOS_X').OnGetText := DescontosGetText;
       FieldByName('PROVENTOS_X').OnGetText := ProventosGetText;
       FieldByName('DESCONTOS_X').Alignment := taCenter;
       FieldByName('PROVENTOS_X').Alignment := taCenter;
    end;
    if Assigned(FindField('OPERACAO')) then
    begin
      FieldByName('OPERACAO').OnGetText := OperacaoGetText;
      FieldByName('OPERACAO').Alignment := taCenter;
    end;
    if Assigned(FindField('TIPO_EVENTO')) then
      FieldByName('TIPO_EVENTO').OnGetText := TipoEventoGetText;
    if Assigned(FindField('TOTALIZAR_X')) then
      FieldByName('TOTALIZAR_X').OnGetText := TotalizarGetText;
  end;
end;

procedure TFrmTotalizador.FrmDetalharClient;
begin
  inherited;
  if (PageControl1.ActivePageIndex = ZeroValue) then
    RxTitulo.Caption := ' · Lista de Totalizadores'
  else
    RxTitulo.Caption := ' · Totalizador: '+
                        mtRegistro.FieldByName('IDTOTAL').AsString+' - '+
                        mtRegistro.FieldByName('NOME').AsString;
end;

end.
