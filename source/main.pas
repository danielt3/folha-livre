{
Projeto FolhaLivre - Folha de Pagamento Livre
Formulário Principal do FolhaLivre

Copyright (c) 2002-2008 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br

Histórico das alterações

* 21/05/2005 - Adicionado a tela "sobre" (splash)

}

unit main;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QMenus, QComCtrls, QStdCtrls,
  QExtCtrls,{$IFDEF AK_USER}QAKUser,{$ENDIF}
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs, Menus, ComCtrls, StdCtrls, ExtCtrls,
  {$IFDEF AK_USER}AKUser,{$ENDIF}
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF MDI_WALLPAPER}MDIWallp,{$ENDIF}
  {$IFDEF ADO}ADODB,{$ENDIF}
  {$IFDEF DBX}SqlExpr,{$ENDIF}
  {$IFDEF IBX}IBDatabase,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Mask, Types, DB, DBClient, Variants, ScktComp;

type
  TFrmFLivre = class(TForm)
    MainMenu: TMainMenu;
    mniCadastro: TMenuItem;
    mniFerramenta: TMenuItem;
    mniBackup: TMenuItem;
    mniAcesso: TMenuItem;
    mniFuncionario: TMenuItem;
    mniMovimento: TMenuItem;
    mniGeraRel: TMenuItem;
    Sair: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    mniFuncionarioIncluir: TMenuItem;
    mniFuncionarioEditar: TMenuItem;
    mniFuncionarioExcluir: TMenuItem;
    mniRelatorio: TMenuItem;
    StatusBar1: TStatusBar;
    mniCalculo: TMenuItem;
    mniCalcular: TMenuItem;
    mniFuncionarioImprimir: TMenuItem;
    mniAutomatico: TMenuItem;
    mniRelSalProf: TMenuItem;
    Funcionrios1: TMenuItem;
    mniImportar: TMenuItem;
    mniExportar: TMenuItem;
    mniUpgrade: TMenuItem;
    N19: TMenuItem;
    mniLotacao: TMenuItem;
    mniFolhaPagamento: TMenuItem;
    mniEvento: TMenuItem;
    mniIncidencia: TMenuItem;
    mniMovFixo: TMenuItem;
    N2: TMenuItem;
    mniEventoGrupo: TMenuItem;
    mniSysGlobal: TMenuItem;
    mniSysEmpresa: TMenuItem;
    mniSysUser: TMenuItem;
    mniCargo: TMenuItem;
    N4: TMenuItem;
    mniFormula: TMenuItem;
    mniTabela: TMenuItem;
    mniMovTabela: TMenuItem;
    mniPlanoConta: TMenuItem;
    N5: TMenuItem;
    mniIndice: TMenuItem;
    mniMovIndice: TMenuItem;
    N6: TMenuItem;
    mniGrupoEmpresa: TMenuItem;
    N1: TMenuItem;
    mniGrupoPagamento: TMenuItem;
    mniEmpresas: TMenuItem;
    mniSequencia: TMenuItem;
    mniFolhaTipo: TMenuItem;
    N3: TMenuItem;
    mniPlanoGrupo: TMenuItem;
    N7: TMenuItem;
    mniPadrao: TMenuItem;
    N8: TMenuItem;
    mniInformado: TMenuItem;
    N9: TMenuItem;
    mniPosicionarFolha: TMenuItem;
    mni_r_folha_analitica: TMenuItem;
    mni_r_total_lotacao: TMenuItem;
    mni_r_contra_cheque: TMenuItem;
    mniPosicionarEmpresa: TMenuItem;
    mni_r_lista_bancaria: TMenuItem;
    N13: TMenuItem;
    BancoseAgncias1: TMenuItem;
    mniDependente: TMenuItem;
    N14: TMenuItem;
    mniDependenteTipo: TMenuItem;
    N15: TMenuItem;
    mniSysEmpresaDados: TMenuItem;
    mniListagemLiquidos: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    mniSindicato: TMenuItem;
    mniTotalizador: TMenuItem;
    mniRAIS: TMenuItem;
    mniSituacao_RAIS: TMenuItem;
    mniBases: TMenuItem;
    mniEventoRescisao: TMenuItem;
    mniRescisaoCausa: TMenuItem;
    mniRescisaoContrato: TMenuItem;
    mniAjuda: TMenuItem;
    mniSobre: TMenuItem;
    mniCAGED: TMenuItem;
    mniFeriado: TMenuItem;
    mniImportarInformado: TMenuItem;
    N12: TMenuItem;
    mniProgramado: TMenuItem;
    mniRecurso: TMenuItem;
    mnic_rendimento: TMenuItem;
    N18: TMenuItem;
    mni_configuracao: TMenuItem;
    mni_cfg_c_rendimento: TMenuItem;
    mniMovTabelaIRRF: TMenuItem;
    N20: TMenuItem;
    mniMovTabelaGlobal: TMenuItem;
    mniIndiceGlobal: TMenuItem;
    procedure mniSairClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure mniAcessoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure mniFuncionarioClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniLotacaoClick(Sender: TObject);
    procedure StatusBar1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mniFolhaPagamentoClick(Sender: TObject);
    procedure mniEventoClick(Sender: TObject);
    procedure mniIncidenciaClick(Sender: TObject);
    procedure mniMovFixoClick(Sender: TObject);
    procedure mniEventoGrupoClick(Sender: TObject);
    procedure mniSysGlobalClick(Sender: TObject);
    procedure mniSysEmpresaClick(Sender: TObject);
    procedure mniSysUserClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mniCargoClick(Sender: TObject);
    procedure mniFormulaClick(Sender: TObject);
    procedure mniTabelaClick(Sender: TObject);
    procedure mniMovTabelaClick(Sender: TObject);
    procedure mniPlanoContaClick(Sender: TObject);
    procedure mniIndiceClick(Sender: TObject);
    procedure mniMovIndiceClick(Sender: TObject);
    procedure mniGrupoEmpresaClick(Sender: TObject);
    procedure mniGrupoPagamentoClick(Sender: TObject);
    procedure mniEmpresasClick(Sender: TObject);
    procedure mniSequenciaClick(Sender: TObject);
    procedure mniFolhaTipoClick(Sender: TObject);
    procedure mniPlanoGrupoClick(Sender: TObject);
    procedure mniPadraoClick(Sender: TObject);
    procedure mniInformadoClick(Sender: TObject);
    procedure mniAutomaticoClick(Sender: TObject);
    procedure mniCalcularClick(Sender: TObject);
    procedure mni_r_folha_analiticaClick(Sender: TObject);
    procedure mni_r_total_lotacaoClick(Sender: TObject);
    procedure mni_r_contra_chequeClick(Sender: TObject);
    procedure mni_r_lista_bancariaClick(Sender: TObject);
    procedure mniUpgradeClick(Sender: TObject);
    procedure BancoseAgncias1Click(Sender: TObject);
    procedure mniDependenteClick(Sender: TObject);
    procedure mniDependenteTipoClick(Sender: TObject);
    procedure mniSysEmpresaDadosClick(Sender: TObject);
    procedure mniListagemLiquidosClick(Sender: TObject);
    procedure mniSindicatoClick(Sender: TObject);
    procedure mniTotalizadorClick(Sender: TObject);
    procedure mniSituacao_RAISClick(Sender: TObject);
    procedure mniBasesClick(Sender: TObject);
    procedure mniEventoRescisaoClick(Sender: TObject);
    procedure mniRescisaoCausaClick(Sender: TObject);
    procedure mniRescisaoContratoClick(Sender: TObject);
    procedure mniSobreClick(Sender: TObject);
    procedure mniCAGEDClick(Sender: TObject);
    procedure mniFeriadoClick(Sender: TObject);
    procedure mniAtivarFolhaClick(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure mniImportarInformadoClick(Sender: TObject);
    procedure mniProgramadoClick(Sender: TObject);
    procedure mniRecursoClick(Sender: TObject);
    procedure mnic_rendimentoClick(Sender: TObject);
    procedure mni_cfg_c_rendimentoClick(Sender: TObject);
    procedure mniMovTabelaIRRFClick(Sender: TObject);
    procedure mniMovTabelaGlobalClick(Sender: TObject);
    procedure mniIndiceGlobalClick(Sender: TObject);
  protected
    SocketFolha: TTimer; // verificar se a folha ativa
    {$IFDEF MDI_WALLPAPER}
    ListaPapel: TStringList;
    Timer: TTimer;
    MDIWallpaper: TMDIWallpaper;
    procedure TimerTimer(Sender: TObject);
    {$ENDIF}
  private
    { Private declarations }
    ToolBar: TPanel;

    lbFolha: {$IFDEF AK_LABEL}TAKLabel{$ELSE}TLabel{$ENDIF};
    lbEvento: {$IFDEF AK_LABEL}TAKLabel{$ELSE}TLabel{$ENDIF};
    lbFuncionario: {$IFDEF AK_LABEL}TAKLabel{$ELSE}TLabel{$ENDIF};
    lbFolhaAtiva: {$IFDEF AK_LABEL}TAKLabel{$ELSE}TLabel{$ENDIF};

    {$IFDEF ADO}Conexao: TADOConnection;{$ENDIF}
    {$IFDEF DBX}Conexao: TSQLConnection;{$ENDIF}
    {$IFDEF IBX}Conexao: TIBDataBase;{$ENDIF}
    {$IFDEF AK_USER}
    AKIBUser: TAKIBUser;
    {$ELSE}
    FMainMenu: TMainMenu;
    {$ENDIF}
    procedure AtivarEmpresaClick(Sender: TObject);
    procedure VerificarFolha;
    procedure AtualizaControle;
    procedure CreateControls;
    {$IFDEF AK_LABEL}
    procedure ConfiguraLabel(AKLabel: TAKLabel);
    {$ENDIF}
  public
    { Public declarations }
    procedure PosicionarEmpresa(Sender: TObject);
  end;

var
  FrmFLivre: TFrmFLivre;

implementation

uses
  ftext, DateUtils, fdb, ffuncionario, fsuporte, fdeposito, fsystem,
  flotacao, fbanco, fempresa, ffolha, fevento, fincidencia, fvfixo,
  fevento_grupo, sys_global, sys_empresa, sys_user, fusuario,
  fcargo, fformula, ftabela, fplano, findice,
  fgrupo_empresa, fgrupo_pagamento, fempresas, fsequencia, ffolha_tipo,
  fplano_grupo, fpadrao, finformado, fimportador, fautomatico,
  ftabela_faixa, findice_valor,
  r_total_lotacao, r_contra_cheque, r_analitica,
  fcalculador, r_lista_bancaria, fupgrade, fdependente, fdependente_tipo,
  sys_empresa_dados, r_lista_liquido, fsindicato, ftotalizador, fsituacao,
  fbase_acumulacao, frescisao, frescisao_causa, frescisao_funcionario, fcaged,
  {$IFDEF SPLASH_SCREEN}splash,{$ENDIF} fferiado, fprogramado, frecurso, futil,
  fc_rendimto, r_c_rendimento, fcolor, ftabela_irrf;

const
  MENUITEM_SUF = '2';

{$R *.dfm}

{$IFDEF AK_LABEL}
procedure TFrmFLivre.ConfiguraLabel( AKLabel: TAKLabel);
begin
  with AKLabel do
  begin
    // Enter (ao entrar)
    MouseEffectEnter.Enabled := True;
    MouseEffectEnter.Color   := clBlack;
    MouseEffectEnter.Font.Color := clWhite;
    MouseEffectEnter.Font.Style := [fsBold];
    MouseEffectEnter.Frame := False;
    MouseEffectEnter.ParentColor := False;
    MouseEffectEnter.ParentFont  := False;
    // Leave (ao sair)
    MouseEffectLeave.Enabled := True;
    MouseEffectLeave.Color   := clWindow;
    MouseEffectLeave.Font.Color := clWindowText;
    MouseEffectLeave.Frame := False;
  end;  
end;
{$ENDIF}

procedure TFrmFLivre.CreateControls;
begin

  Caption := Application.Title;

  ToolBar := TPanel.Create(Self);

  with ToolBar do
  begin
    Parent := Self;
    Align  := alTop;
    Height := 21;
    Color  := clWhite;
    BevelInner := bvNone;
    BevelOuter := bvNone;
  end;

  {$IFDEF AK_LABEL}
  lbFolha := TAKLabel.Create(Self);
  lbEvento := TAKLabel.Create(Self);
  lbFuncionario := TAKLabel.Create(Self);
  lbFolhaAtiva := TAKLabel.Create(Self);
  {$ELSE}
  lbFolha := TLabel.Create(Self);
  lbEvento := TLabel.Create(Self);
  lbFuncionario := TLabel.Create(Self);
  lbFolhaAtiva := TLabel.Create(Self);
  {$ENDIF}

  with lbFolha do
  begin
    Parent := ToolBar;
    Cursor := crHandPoint;
    Align := alLeft;
    Caption := ' Folhas ';
    Layout := tlCenter;
    OnClick := mniFolhaPagamento.OnClick;
  end;

  with lbEvento do
  begin
    Parent := ToolBar;
    Cursor := crHandPoint;
    Align := alLeft;
    Caption := ' Eventos ';
    Layout := tlCenter;
    OnClick := mniEventoClick;
  end;

  with lbFuncionario do
  begin
    Parent := ToolBar;
    Cursor := crHandPoint;
    Align := alLeft;
    Caption := ' Funcionários ';
    Layout := tlCenter;
    OnClick := mniFuncionarioClick;
  end;

  {$IFDEF AK_LABEL}
  ConfiguraLabel(lbFolha);
  ConfiguraLabel(lbEvento);  
  ConfiguraLabel(lbFuncionario);
  {$ENDIF}

  with lbFolhaAtiva do
  begin
    Parent := ToolBar;
    Align := alRight;
    Caption := 'Folha Ativa: Código - Descrição - Tipo';
    Font.Color := clGreen;
    Font.Style := [fsBold];
    Layout := tlCenter;
  end;

  with TServerSocket.Create(Self) do
  begin
    Port := 1221;
    OnClientRead := ServerSocketClientRead;
    Active := True;
  end;

end;  // CreateControls

procedure TFrmFLivre.mniSairClick( Sender: TObject);
begin
  Close;
end;

procedure TFrmFLivre.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Abs( GetKeyState( VK_SHIFT)) in [127,128] then
    CanClose := True
  else
    CanClose := kConfirme('Deseja finalizar o aplicativo?');
end;

procedure TFrmFLivre.FormCreate(Sender: TObject);
begin

  CreateControls;

  {$IFDEF ADO}
  Conexao := TADOConnection.Create(Self);
  {$ENDIF}
  {$IFDEF DBX}
  Conexao := TSQLConnection.Create(Self);
  {$ENDIF}
  {$IFDEF IBX}
  Conexao := TIBDatabase.Create(Self);
  Conexao.DefaultTransaction := TIBTransaction.Create(Self);
  {$ENDIF}

  {$IFDEF AK_USER}
  AKIBUser := TAKIBUser.Create(Self);
  AKIBUser.Transaction := Conexao;
  AKIBUser.Menu := MainMenu;
  {$ELSE}
  FMainMenu := TMainMenu.Create(Self);
  {$ENDIF}

  if not kStartConnection(Conexao) then
    Application.Terminate;

  {$IFDEF SPLASH_SCREEN}
  if Assigned(SplashForm) then
  begin
    Sleep(3000);  // Aguarda três sequndos
    SplashForm.Free;
  end;
  {$ENDIF}

  {$IFDEF AK_USER}

  AKIBUser.Login();
  kSetAcesso(AKIBUser);

  {$ELSE}

  kMenuCopy( MainMenu, FMainMenu, MENUITEM_SUF);
  Menu := FMainMenu;

  if not kOpenConnection() then
    Application.Terminate;

  {$ENDIF}

  {$IFDEF MDI_WALLPAPER}

  Timer := TTimer.Create(Self);
  ListaPapel := TStringList.Create;

  MDIWallpaper := TMDIWallpaper.Create(Self);
  MDIWallpaper.Client := Self;
  MDIWallPaper.AutoSizeTile := True;
  MDIWallPaper.Mode   := wpTile;

  kListWallPaper(ListaPapel);

  if (ListaPapel.Count > 1) then
  begin
    Timer.Enabled  := True;
    Timer.Interval := 60000;
    Timer.OnTimer  := TimerTimer;
  end;

  kDisplayWallPaper( MDIWallpaper, ListaPapel);

  {$ENDIF}

  kOpenEmpresa(); // Copia SYS_EMPRESA para GetEmpresa

  kEmpresaLojaPadrao();

  PosicionarEmpresa(kFindMenuCaption( Menu.Items, mniPosicionarEmpresa.Caption));

  AtualizaControle();

  kSetColor($00E0E9EF);

end; //  procedure FormCreate

procedure TFrmFLivre.mniAcessoClick(Sender: TObject);
{$IFDEF VCL}
var
  i:Integer;
{$ENDIF}
begin

  {$IFDEF VCL}
  for i := 0 to (Application.MainForm.MDIChildCount - 1) do
    Application.MainForm.MDIChildren[i].Close;
  {$ENDIF}

  Application.ProcessMessages;

  {$IFDEF AK_USER}
  AKIBUser.Admin();
  {$ENDIF}

  PosicionarEmpresa( kFindMenuCaption( Menu.Items, mniPosicionarEmpresa.Caption));

  VerificarFolha();

  AtualizaControle();

end;  // procedure mniAcessoClick

procedure TFrmFLivre.FormResize(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

{$IFDEF MDI_WALLPAPER}
procedure TFrmFLivre.TimerTimer(Sender: TObject);
begin
  kDisplayWallPaper( MDIWallPaper, ListaPapel);
end;
{$ENDIF}

procedure TFrmFLivre.mniFuncionarioClick(Sender: TObject);
begin
  CriaFuncionario();
end;

procedure TFrmFLivre.FormDestroy(Sender: TObject);
begin
  {$IFDEF WALLPAPER}
  if Assigned(ListaPapel) then
    ListaPapel.Free;
  {$ENDIF}
  kFreeDeposito();
  kFreeEmpresa();
end;

procedure TFrmFLivre.mniLotacaoClick(Sender: TObject);
begin
  CriaLotacao();
end;

procedure TFrmFLivre.StatusBar1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  cdEmpresa: TClientDataSet;
  Menu: TPopupMenu;
  Item: TMenuItem;
  Point: TPoint;
begin

  Menu      := TPopupMenu.Create(Self);
  cdEmpresa := TClientDataSet.Create(nil);

  try

    Menu.AutoHotkeys := maManual;

    if not kOpenSQL( cdEmpresa, 'SELECT IDEMPRESA, NOME FROM EMPRESA') then
      raise Exception.Create('');

    with cdEmpresa do
    begin
      IndexFieldNames := 'IDEMPRESA';
      First;
      while not Eof do
      begin
        Item := TMenuItem.Create(Menu.Items);
        Item.RadioItem := True;
        Item.Tag       := Fields[0].AsInteger;
        Item.Caption   := Fields[0].AsString+' - '+Fields[1].AsString;
        Item.OnClick   := AtivarEmpresaClick;
        if (Item.Tag = kEmpresaAtiva()) then
          Item.Checked := True;
        Menu.Items.Add(Item);
        Next;
      end;
    end;

    if (Menu.Items.Count > 1) then
    begin
      Point.X := X;
      Point.Y := Y;
      Point := TControl(Sender).ClientToScreen(Point);
      Menu.Popup( Point.X, Point.Y);
    end;

  finally
    cdEmpresa.Free;
  end;

end;

procedure TFrmFLivre.mniFolhaPagamentoClick(Sender: TObject);
begin
  CriaFolha();
end;

procedure TFrmFLivre.mniEventoClick(Sender: TObject);
begin
  CriaEvento();
end;

procedure TFrmFLivre.mniIncidenciaClick(Sender: TObject);
begin
  CriaIncidencia();
end;

procedure TFrmFLivre.mniMovFixoClick(Sender: TObject);
begin
  CriaValorFixo();
end;

procedure TFrmFLivre.mniEventoGrupoClick(Sender: TObject);
begin
  CriaEventoGrupo();
end;

procedure TFrmFLivre.mniSysGlobalClick(Sender: TObject);
begin
  CriaSysGlobal();
end;

procedure TFrmFLivre.mniSysEmpresaClick(Sender: TObject);
begin
  CriaSysEmpresa();
end;

procedure TFrmFLivre.mniSysUserClick(Sender: TObject);
begin
  CriaSysUser();
end;

procedure TFrmFLivre.FormClose(Sender: TObject; var Action: TCloseAction);
{$IFDEF VCL}
var i: Integer;
{$ENDIF}
begin

  {$IFDEF VCL}
  for i := 0 to (Application.MainForm.MDIChildCount - 1) do
    Application.MainForm.MDIChildren[i].Close;
  {$ENDIF}

  kSetUsuario( kGetUser(), 'EMPRESA_ID', IntToStr(kEmpresaAtiva()));
  kSetUsuario( kGetUser(), 'FOLHA_'+IntToStr(kEmpresaAtiva), IntToStr(kFolhaAtiva()));

end;

procedure TFrmFLivre.AtualizaControle;

  procedure AtualizaMenuItem( MenuItem: TMenuItem);
  var tMenu: TMenuItem;
  begin
    tMenu := kFindMenuName( Menu.Items, MenuItem.Name, True);
    if Assigned(tMenu) then
      if (kEmpresaAtiva() = 0) then
        tMenu.Enabled := False
      else
        tMenu.Enabled := MenuItem.Enabled;
  end;  // procedure AtualizaMenuName

  function EnabledMenuItem( MenuItem: TMenuItem):Boolean;
  var tMenu: TMenuItem;
  begin
    Result := False;
    tMenu := kFindMenuName( Menu.Items, MenuItem.Name, True);
    if Assigned(tMenu) then
      Result := tMenu.Enabled and tMenu.Visible;
  end;  // procedure AtualizaMenuName

begin

  // ------------ cadastros
  AtualizaMenuItem( mniLotacao);
  AtualizaMenuItem( mniCargo);
  AtualizaMenuItem( mniFuncionario);
  AtualizaMenuItem( mniPlanoConta);
  AtualizaMenuItem( mniPlanoGrupo);

  // ------------- movimentacoes
  AtualizaMenuItem( mniPosicionarFolha);
  AtualizaMenuItem( mniFolhaPagamento);
  AtualizaMenuItem( mniInformado);
  AtualizaMenuItem( mniAutomatico);

  // ------------- calculos
  AtualizaMenuItem( mniCalcular);

  // ------------- relatorios
  AtualizaMenuItem( mniRelatorio);

  // ------------- ferramentas
  AtualizaMenuItem( mniAcesso);

  // Atualiza a barra de ferramentas
  lbFolha.Enabled       := EnabledMenuItem(mniFolhaPagamento);
  lbEvento.Enabled      := EnabledMenuItem(mniEvento);
  lbFuncionario.Enabled := EnabledMenuItem(mniFuncionario);

    // Atualiza a barra de tarefas do aplicativo
  StatusBar1.Panels[0].Text := kGetEmpresaNome();
  StatusBar1.Panels[1].Text := kGetUserName()+' ('+kGetGroupName()+')';
  StatusBar1.Panels[4].Text := IntToStr(kEmpresaAtiva()) + ' - ' +
                               kGetDeposito('EMPRESA_NOME') +
                               ' - Grupo: '+IntToStr(kGrupoEmpresa);


end;  // AtualizaControle

procedure TFrmFLivre.mniCargoClick(Sender: TObject);
begin
  CriaCargo();
end;

procedure TFrmFLivre.mniFormulaClick(Sender: TObject);
begin
  CriaFormula();
end;

procedure TFrmFLivre.mniTabelaClick(Sender: TObject);
begin
  CriaTabela();
end;

procedure TFrmFLivre.mniMovTabelaClick(Sender: TObject);
begin
  CriaFaixa(kEmpresaAtiva());
end;

procedure TFrmFLivre.mniPlanoContaClick(Sender: TObject);
begin
  CriaPlano();
end;

procedure TFrmFLivre.mniIndiceClick(Sender: TObject);
begin
  CriaIndice();
end;

procedure TFrmFLivre.mniMovIndiceClick(Sender: TObject);
begin
  CreateIndex(kEmpresaAtiva);
end;

procedure TFrmFLivre.mniGrupoEmpresaClick(Sender: TObject);
begin
  CriaGrupoEmpresa();
end;

procedure TFrmFLivre.mniGrupoPagamentoClick(Sender: TObject);
begin
  CriaGrupoPagamento();
end;

procedure TFrmFLivre.mniEmpresasClick(Sender: TObject);
begin
  CriaEmpresa();
end;

procedure TFrmFLivre.mniSequenciaClick(Sender: TObject);
begin
  CriaSequencia()
end;

procedure TFrmFLivre.mniFolhaTipoClick(Sender: TObject);
begin
  CriaFolhaTipo();
end;

procedure TFrmFLivre.mniPlanoGrupoClick(Sender: TObject);
begin
  CriaPlanoGrupo();
end;

procedure TFrmFLivre.mniPadraoClick(Sender: TObject);
begin
  CriaPadrao();
end;

procedure TFrmFLivre.mniInformadoClick(Sender: TObject);
begin
  CriaInformado();
end;

procedure TFrmFLivre.PosicionarEmpresa(Sender: TObject);
var
  cdEmpresa: TClientDataSet;
  MenuOpcao: TMenuItem;
  i, iEmpresa: Integer;
begin

  if not Assigned(Sender) then
    Exit;

  TMenuItem(Sender).Clear;

  cdEmpresa := TClientDataSet.Create(nil);

  try try

    if not kOpenSQL( cdEmpresa, 'SELECT IDEMPRESA, NOME FROM EMPRESA') then
      raise Exception.Create('');

    with cdEmpresa do
    begin
      IndexFieldNames := 'IDEMPRESA';
      First;
      while not Eof do
      begin
        MenuOpcao := TMenuItem.Create(TMenuItem(Sender));
        MenuOpcao.RadioItem := True;
        Menuopcao.Tag       := Fields[0].AsInteger;
        MenuOpcao.Caption   := Fields[0].AsString+' - '+Fields[1].AsString;
        MenuOpcao.OnClick   := AtivarEmpresaClick;
        TMenuItem(Sender).Add(MenuOpcao);
        Next;
      end;
    end;

    // Recupera a Empresa Ativa para o Usuario Atual
    iEmpresa := StrToIntDef( kGetUsuario( kGetUser(), 'EMPRESA_ID'), 0);

    // Força a execução de AtivarEmpresaClick()
    kSetDeposito('EMPRESA_ID', -1);

    for i := 0 to TMenuItem(Sender).Count-1 do
    begin
      if (iEmpresa = TMenuItem(Sender).Items[i].Tag) then
      begin
        TMenuItem(Sender).Items[i].Checked := True;
        TMenuItem(Sender).Items[i].Click;  // AtivarEmpresaClick()
        System.Break;
      end;
    end;

  except
    on E:Exception do
      kErro( E.Message, 'main.pas', 'PosicionarEmpresa()');
  end;
  finally
    cdEmpresa.Free;
  end;

end;  // procedure PosicionarEmpresa

procedure TFrmFLivre.AtivarEmpresaClick(Sender: TObject);
var i: Integer;
begin

  if (kEmpresaAtiva() = TMenuItem(Sender).Tag) then
    Exit;

  for i := 0 to MDIChildCount - 1 do
    MDIChildren[i].Close;

  // Muda o codigo da empresa atual
  kSetDeposito( 'EMPRESA_ID', IntToStr(TMenuItem(Sender).Tag));
  // Força a função 'VerificarFolha' a atualizar dados da folha
  kSetDeposito( 'FOLHA_ID', -1);

  // Ler informacoes da empresa atual
  kEmpresaLoader;

  AtualizaControle();

  TMenuItem(Sender).Checked := True;

  VerificarFolha();

end;  // AtivarEmpresa

procedure TFrmFLivre.VerificarFolha;
var
  iFolha, iGrupo: Integer;
  sFolha, sNome, sTipo: String;
begin

  iGrupo := kGrupoPagamentoFolhaAtiva();
  sTipo  := kTipoFolhaAtiva();

  if (kEmpresaAtiva() = 0) then   // Empresa Global
  begin
    sFolha := '';
    iGrupo := 0;
    lbFolhaAtiva.Caption := '';

  end else
  begin

    sFolha := kGetUsuario( kGetUser(), 'FOLHA_'+IntToStr(kEmpresaAtiva));

    // A folha atual difere da folha ativada, atualiza controles
    if (sFolha = '') or (kFolhaAtiva() <> StrToIntDef(sFolha, 0)) then
    begin

      if (sFolha = '') then
        sFolha := '*';

      if FindFolha( sFolha, kEmpresaAtiva, iFolha, sNome, sTipo, iGrupo) then
      begin
        sFolha := IntToStr(iFolha);
        lbFolhaAtiva.Caption := 'Folha Ativa: '+sFolha+' - '+sNome+' ('+sTipo+')'#32#32;
      end else
      begin
        sFolha := '';
        iGrupo := 0;
        lbFolhaAtiva.Caption := 'Nenhuma Folha Ativa'#32#32;
      end;

    end;

  end;

  kSetDeposito('FOLHA_ID', sFolha);
  kSetDeposito('FOLHA_GP', iGrupo);
  kSetDeposito('FOLHA_TP', sTipo);

  kSetUsuario( kGetUser(), 'FOLHA_'+IntToStr(kEmpresaAtiva), sFolha);

end; // VerificarFolha

procedure TFrmFLivre.mniAutomaticoClick(Sender: TObject);
begin
  CriaAutomatico();
end;

procedure TFrmFLivre.mniCalcularClick(Sender: TObject);
var
  cdFuncionario: TClientDataSet;
begin

  if (kFolhaAtiva = 0) then
    Exit;

  cdFuncionario := TClientDataSet.Create(nil);

  try
    cdFuncionario.FieldDefs.Add( 'IDFUNCIONARIO', ftInteger);
    cdFuncionario.FieldDefs.Add( 'NOME', ftString, 50);
    cdFuncionario.FieldDefs.Add( 'X', ftInteger);
    cdFuncionario.CreateDataSet;
    kCalculador( cdFuncionario, kEmpresaAtiva, kFolhaAtiva, False, True);
  finally
    cdFuncionario.Free;
  end;

end;

procedure TFrmFLivre.mni_r_folha_analiticaClick(Sender: TObject);
begin
  CriaFolhaAnalitica( kEmpresaAtiva, kFolhaAtiva);
end;

procedure TFrmFLivre.mni_r_total_lotacaoClick(Sender: TObject);
begin
  CriaTotalLotacao( kEmpresaAtiva, kFolhaAtiva);
end;

procedure TFrmFLivre.mni_r_contra_chequeClick(Sender: TObject);
begin
  CriaContraCheque( kEmpresaAtiva, kFolhaAtiva);
end;

procedure TFrmFLivre.mni_r_lista_bancariaClick(Sender: TObject);
begin
  CriaListaBancaria( kEmpresaAtiva, kFolhaAtiva);
end;

procedure TFrmFLivre.mniUpgradeClick(Sender: TObject);
begin
  UpgradeVersion();
end;

procedure TFrmFLivre.BancoseAgncias1Click(Sender: TObject);
begin
  CriaBanco();
end;

procedure TFrmFLivre.mniDependenteClick(Sender: TObject);
begin
  CriaDependente();
end;

procedure TFrmFLivre.mniDependenteTipoClick(Sender: TObject);
begin
  CriaDependenteTipo();
end;

procedure TFrmFLivre.mniSysEmpresaDadosClick(Sender: TObject);
begin
  CriaSysEmpresaDados();
end;

procedure TFrmFLivre.mniListagemLiquidosClick(Sender: TObject);
begin
  CriaListaLiquido( kEmpresaAtiva, kFolhaAtiva);
end;

procedure TFrmFLivre.mniSindicatoClick(Sender: TObject);
begin
  CriaSindicato();
end;

procedure TFrmFLivre.mniTotalizadorClick(Sender: TObject);
begin
  CriaTotalizador();
end;

procedure TFrmFLivre.mniSituacao_RAISClick(Sender: TObject);
begin
  CriaSituacao();
end;

procedure TFrmFLivre.mniBasesClick(Sender: TObject);
begin
  CriaBase();
end;

procedure TFrmFLivre.mniEventoRescisaoClick(Sender: TObject);
begin
  CriaRescisao();
end;

procedure TFrmFLivre.mniRescisaoCausaClick(Sender: TObject);
begin
  CriaRescisaoCausa();
end;

procedure TFrmFLivre.mniRescisaoContratoClick(Sender: TObject);
begin
  CriaRescisaoFuncionario();
end;

procedure TFrmFLivre.mniSobreClick(Sender: TObject);
begin
  {$IFDEF SPLASH_SCREEN}
  if FileExists('splashscreen') then
  begin
    with TSplashForm.CreateNew(self) do
    try
      FileName := 'splashscreen';
      ShowModal;
    finally
      Free;
    end;
  end;
  {$ENDIF}
end;

procedure TFrmFLivre.mniCAGEDClick(Sender: TObject);
begin
  CriaCAGED();
end;

procedure TFrmFLivre.mniFeriadoClick(Sender: TObject);
begin
  CriaFeriado();
end;

procedure TFrmFLivre.mniAtivarFolhaClick(Sender: TObject);
var
  iFolha, iGrupo: Integer;
  sNome, sTipo: String;
begin
  if FindFolha( '*', kEmpresaAtiva, iFolha, sNome, sTipo, iGrupo) then
    kSetUsuario( kGetUser(), 'FOLHA_'+IntToStr(kEmpresaAtiva), IntToStr(iFolha))
  else
    kSetUsuario( kGetUser(), 'FOLHA_'+IntToStr(kEmpresaAtiva), '');
  VerificarFolha();
end;

procedure TFrmFLivre.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  if (Socket.ReceiveText = 'FOLHA') then
    VerificarFolha();
end;

procedure TFrmFLivre.mniImportarInformadoClick(Sender: TObject);
begin
  ImportarInformado(kEmpresaAtiva, kFolhaAtiva);
end;

procedure TFrmFLivre.mniProgramadoClick(Sender: TObject);
begin
  CriaProgramado();
end;

procedure TFrmFLivre.mniRecursoClick(Sender: TObject);
begin
  CriaRecurso();
end;

procedure TFrmFLivre.mnic_rendimentoClick(Sender: TObject);
begin
  CriaRendimento( kEmpresaAtiva, YearOf(Date())-1 );
end;

procedure TFrmFLivre.mni_cfg_c_rendimentoClick(Sender: TObject);
begin
  ConfigRendimento();
end;

procedure TFrmFLivre.mniMovTabelaIRRFClick(Sender: TObject);
begin
  CriaIRRF();
end;

procedure TFrmFLivre.mniMovTabelaGlobalClick(Sender: TObject);
begin
  CriaFaixa(0);
end;

procedure TFrmFLivre.mniIndiceGlobalClick(Sender: TObject);
begin
  CreateIndex(0);
end;

end.

