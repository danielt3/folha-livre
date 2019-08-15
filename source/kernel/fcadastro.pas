{
Objetivo: Padronalizacao de Interface para Pesquisa e Cadastro

Copyright (c) 2002, Allan Lima, Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Autor: Allan Lima
Email: allan_kardek@yahoo.com.br
}

{$IFNDEF NO_FCADASTRO}
unit fcadastro;
{$ENDIF}

{$IFNDEF NO_FLIVRE}
{$I flivre.inc}
{$ENDIF}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QStdCtrls, QExtCtrls,
  QGrids, QDBGrids, QComCtrls, QMenus, QButtons, QMask, QDBCtrls,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  Grids, DBGrids, ComCtrls, Menus, Buttons, Mask, DBCtrls,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VOLGAPAK}VolDBEdit,{$ENDIF}
  {$IFDEF RX_LIB}RXDBCtrl,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fbase,Types, DB, DBClient;

type
  TFrmCadastro = class(TFrmBase)
    mtListagem: TClientDataSet;
    dtsListagem: TDataSource;
    PageControl1: TPageControl;
    TabListagem: TTabSheet;
    dbgRegistro: TDBGrid;
    TabDetalhe: TTabSheet;
    btnDetalhar: TSpeedButton;
    mtPesquisa: TClientDataSet;
    mtPesquisaCHAVE: TStringField;
    mtPesquisaVALOR: TStringField;
    mtColuna: TClientDataSet;
    mtColunaCOLUNA: TIntegerField;
    mtColunaTITULO: TStringField;
    mtColunaTAMANHO: TSmallintField;
    mtColunaDISPLAY: TSmallintField;
    mtColunaMASCARA: TStringField;
    mtPesquisaACCEPTALL: TBooleanField;
    mtPesquisaACCEPTEMPTY: TBooleanField;
    dtsPesquisa: TDataSource;
    procedure lblSeparadorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dbgRegistroDblClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure dbgRegistroTitleBtnClick(Sender: TObject; ACol: Integer;
      Field: TField);
    procedure btnDetalharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dtsRegistroStateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure mniOcultarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgRegistroTitleClick(Column: TColumn);
    {$IFDEF RX_LIB}
    procedure dbgRegistroGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure dbgRegistroGetBtnParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; var SortMarker: TSortMarker;
      IsDown: Boolean);
    {$ENDIF}
  protected
    { protected declarations }
    procedure Pesquisar; override;
    procedure FrmDetalharClient; virtual;
    function GetDataSet: TDataSet; virtual;
    procedure PesquisarInterno; virtual;    
  private
    { Private declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    procedure Iniciar; override;
    procedure FrmBtnControlePadrao( Operacao: String); override;
  end;

implementation

uses
  {$IFDEF IBX}fdb, fsystem, fsuporte,{$ENDIF}
  {$IFDEF DBX}fdb_dbx, fsystem_dbx, fsuporte_dbx,{$ENDIF}
  fprint, ftext, fdepvar;

{$R *.dfm}

procedure TFrmCadastro.FormCreate(Sender: TObject);
begin

  inherited;

  pvPesquisado    := False;
  pvImpresso      := False;
  with PageControl1 do
  begin
    {$IFDEF CLX}
    Style := tsNoTabs;
    {$ENDIF}
    {$IFDEF VCL}
    TabHeight := 1;
    TabWidth  := 1;
    {$ENDIF}
    ActivePage := TabListagem;
  end;
end;

procedure TFrmCadastro.Iniciar;
var
  i: Integer;
begin

  if not mtColuna.Active then
    mtColuna.CreateDataSet;

  if not pvDataSet.Active then
    TClientDataSet(pvDataSet).CreateDataSet;

  // Se nao informar a tabela de cadastro o sistema tenta (supor) um nome
  if (pvTabela = '') then
    pvTabela := kRetira( UpperCase(Self.Name), 'FRM');

  kConectar(Self);
  RxTitulo.Caption := ' · '+TabListagem.Caption;

  if (pvSELECT = '') and (mtListagem.Fields.Count > 0) then
  begin
    pvSELECT := 'SELECT';
    for i := 0 to mtListagem.Fields.Count - 1 do
      if (mtListagem.Fields[i].FieldKind = fkData) and
         (not (pfHidden in mtListagem.Fields[i].ProviderFlags)) then
      begin
        if (pvSELECT <> 'SELECT') then
          pvSELECT := pvSELECT + ',';
        pvSELECT := pvSELECT + ' ' + mtListagem.Fields[i].FieldName;
      end;
    if (pvSELECT = 'SELECT') then
      pvSELECT := pvSELECT + ' * ';
    pvSELECT := pvSELECT + ' FROM '+pvTabela;
  end;

  // a tabela SYS_PESQUISA podera conter informacoes sobre a
  // pesquisa de dados para o cadastro atual
  kIniciaPesquisa( Self, mtPesquisa, pvSELECT, pvSELECT_NULL);

  kGrid( Self, mtColuna, pvSELECT, pvSELECT_NULL);

  PesquisarInterno(); { Allan Lima - 24/02/2006 }

  if (not mtPesquisa.Active) or (mtPesquisa.RecordCount = 0) then
    pnlPesquisa.Visible := False; { Allan Lima - 30/11/2004 }

  inherited Iniciar;

  dbgRegistro.SetFocus;  { Allan Limna - 25/01/2005 }

end; // Iniciar

procedure TFrmCadastro.lblSeparadorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{$IFDEF VCL}
var
  PontoCliente, PontoTela: TPoint;
{$ENDIF}
begin
  {$IFDEF VCL}
  // A classe TLabel da CLX não possui a propriedade PopupMenu
  if Assigned(TLabel(Sender).PopupMenu) then
  begin
    PontoCliente.x := X;
    PontoCliente.y := Y;
    PontoTela := TLabel(Sender).ClientToScreen(PontoCliente);
    TLabel(Sender).PopupMenu.Popup( PontoTela.x, PontoTela.y);
  end;
  {$ENDIF}
end;

procedure TFrmCadastro.dbgRegistroDblClick(Sender: TObject);
begin
  inherited;
  btnDetalhar.Click;
end;

procedure TFrmCadastro.btnNovoClick(Sender: TObject);
{var
  StateChange: TNotifyEvent;}
begin
  { O Evento onStateChange esta sendo temporariamente desativado
    porque quando atualizava controle na tela causava muitas piscadas,
    comprometendo a performance. }
  {StateChange := dtsRegistro.OnStateChange;
  dtsRegistro.OnStateChange := NIL;}
  FrmBtnControlePadrao( TSpeedButton(Sender).Caption);
  {if Assigned(StateChange) then
  begin
    dtsRegistro.OnStateChange := StateChange;
    dtsRegistro.OnStateChange( dtsRegistro);
  end;}
end;

procedure TFrmCadastro.dbgRegistroTitleBtnClick(Sender: TObject;
  ACol: Integer; Field: TField);
begin
  inherited;
  kTitleBtnClick(Field);
end;

procedure TFrmCadastro.btnDetalharClick(Sender: TObject);
{var
  StateChange: TNotifyEvent;}
begin
  inherited;
  { O Evento onStateChange esta sendo temporariamente desativado
    porque quando atualiza controle na tela causa muitas piscadas
    comprometendo a performance. }
{  StateChange := dtsRegistro.OnStateChange;
  dtsRegistro.OnStateChange := NIL;}
  FrmDetalharClient;
{  if Assigned(StateChange) then begin
    dtsRegistro.OnStateChange := StateChange;
    dtsRegistro.OnStateChange( dtsRegistro);
  end;}
end;

procedure TFrmCadastro.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (ActiveControl = dbgRegistro) and ((Key = VK_RETURN) or (Key = VK_SPACE)) then
  begin
    Key := 0;
    btnDetalhar.Click;
  end;
  inherited;
end;

procedure TFrmCadastro.dtsRegistroStateChange(Sender: TObject);
var
  bEditando: Boolean;
begin

  bEditando := (TDataSource(Sender).DataSet.State in [dsInsert,dsEdit]);

  {$IFDEF AK_LABEL}
  if bEditando then
    TAKStatus(FindComponent('RXRECORD')).DataSource := dtsRegistro
  else
    TAKStatus(FindComponent('RXRECORD')).DataSource := dtsListagem;
  {$ENDIF}

  inherited;

  if pvPesquisa then
    pnlPesquisa.Visible := not bEditando;

end;

procedure TFrmCadastro.FormResize(Sender: TObject);
begin
  inherited;
  WindowState := wsMaximized;
end;

procedure TFrmCadastro.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  Action := caFree;
end;

procedure TFrmCadastro.FormShow(Sender: TObject);
begin

  inherited;

  PesquisaValor.Width := pnlPesquisa.Width-20;
  PesquisaTipo.Width  := PesquisaValor.Width;

  if PesquisaValor.CanFocus then
    PesquisaValor.SetFocus;

end;

procedure TFrmCadastro.Pesquisar();
begin
  if (PageControl1.ActivePageIndex = 0) then
    PesquisarInterno()
  else
    btnDetalhar.Click;
end;

procedure TFrmCadastro.PesquisarInterno();
begin

  if (PesquisaValor.Text = '') then
  begin
    kAtualizaPesquisa( Self, mtListagem, '*', pvSELECT, pvSELECT_NULL);
    pvPesquisado := True;
  end else
  begin
    kAtualizaPesquisa( Self, mtListagem,
                       PesquisaValor.Text, pvSELECT,
                       mtPesquisa.Fields[1].AsString, {WHERE}
                       mtPesquisa.Fields[2].AsBoolean, {ACCEPTALL}
                       mtPesquisa.Fields[3].AsBoolean); {ACCEPTEMPTY}
    pvPesquisado := True;
  end;

end;

procedure TFrmCadastro.mniOcultarClick(Sender: TObject);
begin
  inherited;
  mtListagem.Delete;
end;

procedure TFrmCadastro.btnImprimirClick(Sender: TObject);
var
  Dep: TDeposito;
begin

  if (PageControl1.ActivePage <> TabListagem) then
    Exit;

  Dep := TDeposito.Create;

  try
    Dep.SetDeposito('TITULO', UpperCase(kRetira( RxTitulo.Caption, ' · ')));
    pvImpresso := kPrintGrid( dbgRegistro, '', False, Dep);
  finally
    Dep.Free;
  end;

end;

procedure TFrmCadastro.FrmBtnControlePadrao( Operacao: String);
var
  Wc: TWinControl;
  dsState: TDataSetState;
  sPergunta: String;
begin

  sPergunta := '';
  Wc := Self.ActiveControl;

  Self.ActiveControl := NIL;
  Self.ActiveControl := Wc;

  if Length(Operacao) > 1 then
    Operacao := Operacao[ Pos('&',Operacao)+1];

  Operacao := UpperCase(Operacao[1]);

  //  A Operacao pode ser: 'O' para Novo, 'E' para Editar, 'C' para cancelar,
  //                       'G' para gravar, 'X' para Excluir, 'D' para detalhar

  if (Operacao = 'X') and (mtListagem.RecordCount = 0) then
  begin
    SysUtils.Beep;   // Não há registro para excluir
    Exit;
  end;

  if (PageControl1.ActivePageIndex = 0) then
    btnDetalhar.Click;

  if (not PnlControle.Visible) or (not PnlControle.Enabled) then
    Exit;

  if (Operacao = 'O') then
  begin   // Novo Registro

    if not pvDataSet.Active then
      TClientDataSet(pvDataSet).CreateDataSet;

    if not (pvDataSet.State in [dsInsert,dsEdit]) then
      pvDataSet.Append;

  end else if (Operacao = 'E') then
  begin  // Editar/Modificar Registro

    if not pvDataSet.Active then
      TClientDataSet(pvDataSet).CreateDataSet;

    pvDataSet.Edit;

  end else if (Operacao = 'G') then
  begin  // Gravar modificacoes

    if pvPerguntar then
      sPergunta := 'Gravar alterações?';

    if not pvDataSet.Modified then
      pvDataSet.Cancel

    else if kConfirme(sPergunta) then
    begin
      if not TableBeforePost() then Exit;
      dsState := pvDataSet.State;
      pvDataSet.Post;
      if (dsState <> pvDataSet.State) then
        TableArraySelect();
    end;

  end else if (Operacao = 'C') then  // Cancelar modificacoes
  begin

    if pvPerguntar then
      sPergunta := 'Cancelar alterações?';

    if (not pvDataSet.Modified) or kConfirme(sPergunta) then
      pvDataSet.Cancel;

  end else if (Operacao = 'X') then   // Excluir Registro
  begin

    if pvPerguntar then
      sPergunta := 'Excluir Registro?';

    if kConfirme(sPergunta) then
    begin
      pvDeleted := False;
      pvDataSet.Delete;
      if pvDeleted then  // o registro foi deletado
      begin
        pvDataSet.Close;
        btnDetalhar.Click;
      end;
    end;

  end else if (Operacao = 'D') then  // Detalhar/Mostrar registro
    TableArraySelect;

end;

procedure TFrmCadastro.FrmDetalharClient;
var
  i: Integer;
  sField: String;
  evBeforePost, evAfterPost: TDataSetNotifyEvent;
begin

  PageControl1.SelectNextPage(True);

  if (PageControl1.ActivePageIndex = 0) then
  begin

    btnDetalhar.Caption := '&Detalhar...';

    if (pvDataSet.State in [dsInsert,dsEdit]) then
      pvDataSet.Cancel;

    pvDataSet.Close;

    {$IFDEF AK_LABEL}
    TAKStatus(FindComponent('RXRECORD')).DataSource := dtsListagem;
    {$ENDIF}

    PesquisarInterno();

  end else
  begin

    btnDetalhar.Caption := '&Listar...';

    pvDataSet.Close;
    TClientDataSet(pvDataSet).CreateDataSet;
    pvDataSet.Append;

    if (mtListagem.RecordCount > 0) then
    begin

      for i := 0 to (mtListagem.FieldCount - 1) do
      begin
        sField := mtListagem.Fields[i].FieldName;
        if Assigned(pvDataSet.FindField(sField)) then
          pvDataSet.FieldByName(sField).Value := mtListagem.Fields[i].Value;
      end; // for i

      evBeforePost          := pvDataSet.BeforePost;
      evAfterPost           := pvDataSet.AfterPost;
      mtRegistro.BeforePost := NIL;
      mtRegistro.AfterPost  := NIL;

      try
        pvDataSet.Post;
      finally
        if Assigned(evBeforePost) then
          pvDataSet.BeforePost := evBeforePost;
        if Assigned(evAfterPost) then
          pvDataSet.AfterPost := evAfterPost;
      end;

      TableArraySelect();

    end;  // if Listagem > 0

  end;

end;  // FrmDetalharClient

procedure TFrmCadastro.PageControl1Change(Sender: TObject);
begin
  RxTitulo.Caption := ' · '+TPageControl(Sender).ActivePage.Caption;
end;

function TFrmCadastro.GetDataSet: TDataSet;
begin
  if (PageControl1.ActivePage = TabListagem) then
    Result := mtListagem
  else
    Result := pvDataSet;
end;

procedure TFrmCadastro.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);
end;

{$IFDEF RX_LIB}
procedure TFrmCadastro.dbgRegistroGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  inherited;
  kGetCellParams( Field, AFont, Background, Highlight, TDBGrid(Sender).Focused);
end;

procedure TFrmCadastro.dbgRegistroGetBtnParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor;
  var SortMarker: TSortMarker; IsDown: Boolean);
begin
  inherited;
  kGetBtnParams( Field, AFont, Background, SortMarker, IsDown);
end;
{$ENDIF}

procedure TFrmCadastro.dbgRegistroTitleClick(Column: TColumn);
begin
  inherited;
  kTitleClick( Column.Grid, Column, nil);
end;

constructor TFrmCadastro.Create(AOwner: TComponent);
begin

  inherited;

  {$IFDEF AK_LABEL}
  with TAKStatus.Create(Self) do
  begin
    Name        := 'RxRecord';
    Parent      := pnlControle;
    DataSource  := dtsRegistro;
    Align       := alRight;
    ParentColor := True;
    Font.Style  := Font.Style + [fsBold];
    Font.Size   := Font.Size + 5;
  end;
  {$ENDIF}
  
end;

end.
