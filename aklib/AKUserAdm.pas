
{$IFNDEF QAKLIB}
unit AKUserAdm;
{$ENDIF}

{$I aklib.inc}

interface

uses
  {$IFDEF MSWINDOWS}Windows, Messages,{$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QComCtrls, QExtCtrls, QGrids,
  QDBGrids, QMenus, QStdCtrls, QButtons, QDBCtrls, QMask, QImgList, QAKUser,{$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Grids, DBGrids,
  Menus, StdCtrls, Buttons, DBCtrls, Mask, ImgList, AKUser,{$ENDIF}
  {$IFDEF DBX}{$ENDIF}
  {$IFDEF IBX}IBCustomDataSet, IBDatabase, IBQuery, IBTable,{$ENDIF}
  SysUtils, Classes, DB, DBClient;

type

  TFrmAdm = class(TForm)
    ImageList1: TImageList;
    procedure btnAplicarClick(Sender: TObject);
    procedure btnRestaurarClick(Sender: TObject);
    procedure mtGrupoAfterScroll(DataSet: TDataSet);
    procedure dtsUsuarioStateChange(Sender: TObject);
    procedure btnExcluirUsuarioClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnNovoUsuarioClick(Sender: TObject);
    procedure btnEditarUsuarioClick(Sender: TObject);
    procedure btnGravarUsarioClick(Sender: TObject);
    procedure btnCancelarUsuarioClick(Sender: TObject);
    procedure mtUsuarioNewRecord(DataSet: TDataSet);
    procedure dtsGrupoStateChange(Sender: TObject);
    procedure btnNovoGrupoClick(Sender: TObject);
    procedure btnEditarGrupoClick(Sender: TObject);
    procedure btnExcluirGrupoClick(Sender: TObject);
    procedure btnGravarGrupoClick(Sender: TObject);
    procedure btnCancelarGrupoClick(Sender: TObject);
    procedure mtGrupoAfterOpen(DataSet: TDataSet);
    procedure mtGrupoBeforePost(DataSet: TDataSet);
    procedure mtGrupoNewRecord(DataSet: TDataSet);
    procedure mtUsuarioAfterOpen(DataSet: TDataSet);
    procedure mtUsuarioBeforePost(DataSet: TDataSet);
    procedure mtUsuarioAfterPost(DataSet: TDataSet);
    procedure mtUsuarioBeforeDelete(DataSet: TDataSet);
    procedure mtGrupoBeforeDelete(DataSet: TDataSet);
  private
    { Private declarations }
    pvTransaction:
    {$IFDEF DBX}TSQLConnection{$ENDIF}
    {$IFDEF IBX}TIBTransaction{$ENDIF};
  protected
    pnlAcesso: TPanel;
    pnlTitulo: TPanel;
    pnlMenu: TPanel;
    pnlUsuarioButton: TPanel;
    pnlGrupoButton: TPanel;
    dbgGrupo: TDBGrid;
    btnRestaurar: TSpeedButton;
    btnAplicar: TSpeedButton;
    PageControl: TPageControl;
    PopMenuTree: TPopupMenu;
    TreeMenu: TTreeView;
    mtGrupo: TClientDataSet;
    mtUsuario: TClientDataSet;
    dtsUsuario: TDataSource;
    dtsGrupo: TDataSource;
    procedure PageControlOnChange( Sender: TObject);
    procedure ChangeTreeMenu( TreeView: TTreeView; Index: Integer);
  public
    { Public declarations }
    constructor Create( Owner: TComponent); override;
    procedure CreateDialog( AOwner: TComponent);
    procedure CreateData( AOwner: TComponent);
    procedure PopMenuTreeClick( Sender: TObject);
  end;

// exportando
procedure IComAdm( IBUser: TAKIBUser);

implementation

{$IFDEF CLX}
  {$R AKUserAdm.xfm}
{$ENDIF}
{$IFDEF VCL}
  {$R AKUserAdm.dfm}
{$ENDIF}

const
  SEPARATOR_CONTROLS = 5;
  SEPARATOR_BUTTON = SEPARATOR_CONTROLS*2;
  WITH_BUTTON = 20;
  HEIGHT_LABEL = 13;
  TOP_LABEL = 8;
  HEIGHT_CONTROL = 19;

procedure IComAdm( IBUser: TAKIBUser);
var
  Frm: TFrmAdm;
  MainMenu: TMainMenu;
begin

  if not GravaMenu( IBUser.Transaction, IBUser.Menu) then
    Exit;

  Frm := TFrmAdm.Create(NIL);

  MainMenu := TMainMenu.Create(NIL);

  try

    with Frm do
    begin

      pvTransaction := IBUser.Transaction;

      (* Reconstroi o Menu baseado nas informacoes de USER_PROGS *)
      LerMenu( pvTransaction, MainMenu);

      MenuToTreeView( MainMenu, TreeMenu);

      dbSQLSelectFrom( pvTransaction, mtUsuario, 'USER_USERS');
      dbSQLSelectFrom( pvTransaction, mtGrupo, 'USER_GROUP');

      PageControl.OnChange( PageControl);

      ShowModal;

    end;  // with frm

  finally
    Frm.Free;
    MainMenu.Free;
  end;  // try

end;  // procedure IComAdm

{ Usuario }

procedure TFrmAdm.dtsUsuarioStateChange(Sender: TObject);
begin
  WinButtonDataSet( pnlUsuarioButton, TDataSource(Sender).DataSet);
  WinControlDataSet( Self, TDataSource(Sender).DataSet);
end;

procedure TFrmAdm.btnNovoUsuarioClick(Sender: TObject);
begin
  mtUsuario.Append;
end;

procedure TFrmAdm.btnEditarUsuarioClick(Sender: TObject);
begin
  mtUsuario.Edit;
end;

procedure TFrmAdm.btnGravarUsarioClick(Sender: TObject);
begin
  mtUsuario.Post;
end;

procedure TFrmAdm.btnCancelarUsuarioClick(Sender: TObject);
begin
  mtUsuario.Cancel;
end;

procedure TFrmAdm.btnExcluirUsuarioClick(Sender: TObject);
begin
  mtUsuario.Delete;
end;

procedure TFrmAdm.mtUsuarioBeforePost(DataSet: TDataSet);
begin
  if (DataSet.FieldByName('USER_ID').AsInteger = 0) then
    DataSet.FieldByName('USER_ID').AsInteger :=
                         dbNextKey( pvTransaction, 'USER_USERS', 'USER_ID');
  if not dbSQLCacheUpdate( pvTransaction, DataSet, 'USER_USERS', DataSet.Fields) then
    SysUtils.Abort;
end;

procedure TFrmAdm.mtUsuarioNewRecord(DataSet: TDataSet);
begin
  with DataSet do
  begin
    FieldByName('USER_ID').AsInteger     := 0;  // Gera a sequencia
    FieldByName('USER_ACTIVE').AsInteger := 1;  // 1 - Ativo
    FieldByName('GROUP_ID').AsInteger    := 2;  // Convidado - Default
  end;
end;

procedure TFrmAdm.mtUsuarioAfterOpen(DataSet: TDataSet);
begin
  // Esta instrucao permite que seja gerada a instruca SQL corretamente
  DataSet.FieldByName('USER_ID').ProviderFlags := [pfInKey];
end;

procedure TFrmAdm.mtUsuarioAfterPost(DataSet: TDataSet);
begin
  GravaArquivoTreeView( pvTransaction, TreeMenu,
                        DataSet.FieldByName('GROUP_ID').AsInteger);
end;

procedure TFrmAdm.mtUsuarioBeforeDelete(DataSet: TDataSet);
var
  sMensagem: String;
begin

  sMensagem := 'A Exclusão do Usuário eliminará todos os dados'+#13+
               'relacionados ao mesmo, não podendo serem recuperados.'+#13#13+
               'Caso lhe interesse o histórico deste usuário, apenas'+#13+
               'desmarque a opção Usuário Ativo'+#13#13+
               'Deseja realmente excluir o usuário '+
               DataSet.FieldByName('USER_NAME').AsString+' ?';

  if (not Confirme(sMensagem)) or
     (not dbSQLDelete(pvTransaction, DataSet, 'USER_USERS', DataSet.Fields)) then
    SysUtils.Abort;

end;

{ Grupos }


procedure TFrmAdm.dtsGrupoStateChange(Sender: TObject);
begin
  dbgGrupo.Enabled := not (TDataSource(Sender).DataSet.State in [dsInsert,dsEdit]);
  WinButtonDataSet( pnlGrupoButton, TDataSource(Sender).DataSet);
  WinControlDataSet( Self, TDataSource(Sender).DataSet);
end;

procedure TFrmAdm.btnNovoGrupoClick(Sender: TObject);
begin
  mtGrupo.Append;
end;

procedure TFrmAdm.btnEditarGrupoClick(Sender: TObject);
begin
  mtGrupo.Edit;
end;

procedure TFrmAdm.btnExcluirGrupoClick(Sender: TObject);
begin
  mtGrupo.Delete;
end;

procedure TFrmAdm.btnGravarGrupoClick(Sender: TObject);
begin
  mtGrupo.Post;
end;

procedure TFrmAdm.btnCancelarGrupoClick(Sender: TObject);
begin
  mtGrupo.Cancel;
end;

procedure TFrmAdm.mtGrupoAfterOpen(DataSet: TDataSet);
begin
  // Esta instrucao permite que a instrução SQL seja gerada corretamente
  DataSet.FieldByName('GROUP_ID').ProviderFlags := [pfInKey];
end;

procedure TFrmAdm.mtGrupoBeforePost(DataSet: TDataSet);
begin
  if DataSet.FieldByName('GROUP_ID').AsInteger = 0 then
    DataSet.FieldByName('GROUP_ID').AsInteger :=
                          dbNextKey(pvTransaction, 'USER_GROUP', 'GROUP_ID');
  if not dbSQLCacheUpdate( pvTransaction, DataSet, 'USER_GROUP', DataSet.Fields) then
    SysUtils.Abort;
end;

procedure TFrmAdm.mtGrupoNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('GROUP_ID').AsInteger := 0;  // Gera a sequencia
end;

procedure TFrmAdm.mtGrupoAfterScroll(DataSet: TDataSet);
begin
  btnRestaurar.Click;
end;

{ Formulario }

constructor TFrmAdm.Create(Owner: TComponent);
begin

  inherited;

  {$IFDEF VCL}
  Ctl3D := False;
  {$ENDIF}
  Color := $00BAC7CF;
  OnKeyDown := FormKeyDown;

  CreateData(Self);
  CreateDialog(Self);

end;

procedure TFrmAdm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (ActiveControl = TreeMenu) and (Key = VK_SPACE) then
  begin
    Key := 0;
    ChangeTreeMenu( TreeMenu, TreeMenu.Selected.ImageIndex);
  end;

  {$IFDEF VCL}
  if (Key = VK_RETURN) then
  begin
    Key := 0;
    Perform( WM_NEXTDLGCTL, 0, 0);
  end;
  {$ENDIF}

end;

procedure TFrmAdm.ChangeTreeMenu(TreeView: TTreeView; Index: Integer);
begin

  if PageControl.ActivePageIndex = 0 then
    Exit;

  if (Index = 0) then
  begin
    TreeMenu.Selected.ImageIndex := 1;      // Restrito
    TreeMenu.Selected.SelectedIndex := 1;
  end else if (Index = 1) then
  begin
    TreeMenu.Selected.ImageIndex := 2;      // Invisivel
    TreeMenu.Selected.SelectedIndex := 2;
  end else begin
    TreeMenu.Selected.ImageIndex := 0;      // Habilitado
    TreeMenu.Selected.SelectedIndex := 0;
  end;

  TreeMenu.Refresh;

end;

procedure TFrmAdm.PopMenuTreeClick(Sender: TObject);
begin
  ChangeTreeMenu( TreeMenu, TMenuItem(Sender).Tag);
end;

procedure TFrmAdm.PageControlOnChange(Sender: TObject);
begin

  if mtUsuario.State in [dsInsert,dsEdit] then
    mtUsuario.Cancel;

  if mtGrupo.State in [dsInsert,dsEdit] then
    mtGrupo.Cancel;

  if TPageControl(Sender).ActivePageIndex = 1 then
  begin
    btnAplicar.Enabled   := True;
    btnRestaurar.Enabled := True;
    TreeMenu.Color := clWindow;
  end else
  begin
    btnAplicar.Enabled   := False;
    btnRestaurar.Enabled := False;
    TreeMenu.ParentColor := True;
  end;

  btnRestaurar.Click;

end;

procedure TFrmAdm.mtGrupoBeforeDelete(DataSet: TDataSet);
var
  sMensagem: String;
begin

  sMensagem := 'Certifique-se que nenhum usuários esteja ligado a '+#13+
               'este grupo de Usuários.'+#13#13+
               'Deseja realmente excluir o Grupo de Usuários '+
               DataSet.FieldByName('GROUP_NAME').AsString+' ?';

  if (not Confirme(sMensagem)) or
     (not dbSQLDelete( pvTransaction, DataSet, 'USER_GROUP', DataSet.Fields)) then
    SysUtils.Abort;

end;

procedure TFrmAdm.CreateData(AOwner: TComponent);
begin

  mtUsuario := TClientDataSet.Create(AOwner);

  with mtUsuario do
  begin
    AfterOpen := mtUsuarioAfterOpen;
    BeforePost := mtUsuarioBeforePost;
    AfterPost := mtUsuarioAfterPost;
    BeforeDelete := mtUsuarioBeforeDelete;
    AfterScroll := mtGrupoAfterScroll;
    OnNewRecord := mtUsuarioNewRecord;
    FieldDefs.Add( 'USER_ID', ftInteger);
    FieldDefs.Add( 'USER_LOGIN', ftString, 30);
    FieldDefs.Add( 'USER_NAME', ftString, 50);
    FieldDefs.Add( 'LAST_PWD_CHANGE', ftDateTime);
    FieldDefs.Add( 'EXPIRATION_DATE', ftDate);
    FieldDefs.Add( 'USER_ACTIVE', ftInteger);
    FieldDefs.Add( 'USER_PWD', ftString, 30);
    FieldDefs.Add( 'GROUP_ID', ftInteger);
  end;

  mtGrupo := TClientDataSet.Create(AOwner);
  with mtGrupo do
  begin
    AfterOpen    := mtGrupoAfterOpen;
    BeforePost   := mtGrupoBeforePost;
    BeforeDelete := mtGrupoBeforeDelete;
    AfterScroll  := mtGrupoAfterScroll;
    OnNewRecord  := mtGrupoNewRecord;
    FieldDefs.Add('GROUP_ID', ftInteger);
    FieldDefs.Add('GROUP_NAME', ftString, 50);
  end;

  dtsUsuario := TDataSource.Create(AOwner);
  with dtsUsuario do
  begin
    AutoEdit := False;
    DataSet := mtUsuario;
    OnStateChange := dtsUsuarioStateChange;
  end;

  dtsGrupo := TDataSource.Create(AOwner);
  with dtsGrupo do
  begin
    AutoEdit := False;
    DataSet := mtGrupo;
    OnStateChange := dtsGrupoStateChange;
  end;

end;

procedure TFrmAdm.CreateDialog(AOwner: TComponent);
var
  i: Integer;
  MenuItem: TMenuItem;
  TabSheet: TTabSheet;
  Column: TColumn;
  Panel: TPanel;
  pnlUsuario: TPanel;
  pnlGrupo: TPanel;
  Label1: TLabel;
  Edit: TDBEdit;
  Button: TSpeedButton;
  Grid: TDBGrid;
begin

  Height := 450;
  Width  := 700;

  PageControl := TPageControl.Create(AOwner);
  with PageControl do
  begin
    Parent   := Self;
    Align    := alClient;
    HotTrack := True;
    Style    := tsButtons;
    OnChange := PageControlOnChange;
  end;

  // Criacao da interface do Cadastro de Usuarios

  TabSheet := TTabSheet.Create(AOwner);
  TabSheet.Caption := 'Cadastro de Usuários';
  TabSheet.PageControl := PageControl;

  pnlUsuario := TPanel.Create(AOwner);
  with pnlUsuario do
  begin
    Align  := alClient;
    ParentColor := True;
    Parent := TabSheet;
  end;

  Panel := TPanel.Create(AOwner);
  with Panel do
  begin
    Align       := alTop;
    Height      := 100;
    BevelInner  := bvLowered;
    BevelOuter  := bvNone;
    Parent      := pnlUsuario;
    ParentColor := True;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Left := 8;
    Top := TOP_LABEL;
    Height  := HEIGHT_LABEL;
    Caption := 'Usuario ID';
    Enabled := False;
    Parent  := Panel;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Left := Label1.Left;
    Top := Label1.Top+Label1.Height+3;
    Width := 50;
    Height := HEIGHT_CONTROL;
    DataField := 'USER_ID';
    DataSource := dtsUsuario;
    Enabled := False;
    ParentColor := True;
    Parent := Panel;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Left    := Edit.Left + Edit.Width + SEPARATOR_CONTROLS;
    Top     := TOP_LABEL;
    Height  := HEIGHT_LABEL;
    Caption := 'Logon do Usuário';
    Parent  := Panel;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Left   := Label1.Left;
    Top    := Label1.Top+Label1.Height+3;
    Width  := 90;
    Height := HEIGHT_CONTROL;
    CharCase   := ecUpperCase;
    DataField  := 'USER_LOGIN';
    DataSource := dtsUsuario;
    Parent     := Panel;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Left    := Edit.Left + Edit.Width + SEPARATOR_CONTROLS;
    Top     := TOP_LABEL;
    Height  := HEIGHT_LABEL;
    Caption := 'Nome Real do Usuário';
    Parent  := Panel;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Left   := Label1.Left;
    Top    := Label1.Top+Label1.Height+3;
    Width  := 200;
    Height := HEIGHT_CONTROL;
    CharCase   := ecUpperCase;
    DataField  := 'USER_NAME';
    DataSource := dtsUsuario;
    Parent     := Panel;
  end;

  // Cria os controles na proxima linha

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Left    := FirstControl(Panel).Left;
    Top     := Edit.Top+Edit.Height+3;
    Height  := HEIGHT_LABEL;
    Caption := 'Senha do Usuário';
    Parent  := Panel;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Left   := Label1.Left;
    Top    := Label1.Top+Label1.Height+3;
    Width  := 90;
    Height := HEIGHT_CONTROL;
    CharCase     := ecLowerCase;
    DataField    := 'USER_PWD';
    DataSource   := dtsUsuario;
    {$IFDEF VCL}
    PasswordChar := '*';
    {$ENDIF}
    Parent       := Panel;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Left    := Edit.Left + Edit.Width + SEPARATOR_CONTROLS;
    Top     := Edit.Top-(HEIGHT_LABEL+3);
    Height  := HEIGHT_LABEL;
    Caption := 'Senha Expira em';
    Parent  := Panel;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Left   := Label1.Left;
    Top    := Label1.Top+Label1.Height+3;
    Width  := 90;
    Height := HEIGHT_CONTROL;
    DataField  := 'EXPIRATION_DATE';
    DataSource := dtsUsuario;
    Parent     := Panel;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Left    := Edit.Left + Edit.Width + SEPARATOR_CONTROLS;
    Top     := Edit.Top-(HEIGHT_LABEL+3);
    Height  := HEIGHT_LABEL;
    Caption := 'Grupo ID';
    Parent  := Panel;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Left   := Label1.Left;
    Top    := Label1.Top+Label1.Height+3;
    Width  := 50;
    Height := HEIGHT_CONTROL;
    DataField  := 'GROUP_ID';
    DataSource := dtsUsuario;
    Parent     := Panel;
  end;

  with TDBCheckBox.Create(AOwner) do
  begin
    Left    := Edit.Left + Edit.Width + SEPARATOR_CONTROLS;
    Top     := Edit.Top;
    Width   := 50;
    Caption := '&Ativo';
    DataField  := 'USER_ACTIVE';
    DataSource := dtsUsuario;
    ValueChecked := '1';
    ValueUnchecked := '0';
    Parent := Panel;
  end;

  pnlUsuarioButton := TPanel.Create(AOwner);
  with pnlUsuarioButton do
  begin
    Align       := alTop;
    BevelOuter  := bvLowered;
    ParentColor := True;
    Parent      := pnlUsuario;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Left    := 8;
    Top     := 8;
    Height  := 25;
    Caption := 'N&ovo';
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnNovoUsuarioClick;
    Parent  := pnlUsuarioButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := '&Editar';
    Left    := LastControl(pnlUsuarioButton).Left + LastControl(pnlUsuarioButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlUsuarioButton).Height;
    Top     := FirstControl(pnlUsuarioButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnEditarUsuarioClick;
    Parent  := pnlUsuarioButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := '&Gravar';
    Left    := LastControl(pnlUsuarioButton).Left + LastControl(pnlUsuarioButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlUsuarioButton).Height;
    Top     := FirstControl(pnlUsuarioButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnGravarUsarioClick;
    Parent  := pnlUsuarioButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := '&Cancelar';
    Left    := LastControl(pnlUsuarioButton).Left + LastControl(pnlUsuarioButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlUsuarioButton).Height;
    Top     := FirstControl(pnlUsuarioButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnCancelarUsuarioClick;
    Parent  := pnlUsuarioButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := 'E&xcluir';
    Left    := LastControl(pnlUsuarioButton).Left + LastControl(pnlUsuarioButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlUsuarioButton).Height;
    Top     := FirstControl(pnlUsuarioButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnExcluirUsuarioClick;
    Parent  := pnlUsuarioButton;
  end;

  Grid := TDBGrid.Create(AOwner);
  with Grid do
  begin
    Align := alClient;
    DataSource := dtsUsuario;
    Options := [dgTitles, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit];
    Parent  := pnlUsuario;
    ParentColor := True;
    {
    TitleFont.Charset := DEFAULT_CHARSET;
    TitleFont.Color := clWindowText;
    TitleFont.Height := -11;
    TitleFont.Name := 'MS Sans Serif';
    TitleFont.Style := [];
    }
    Column := Columns.Add;
    Column.FieldName := 'USER_ID';
    Column.Title.Alignment := taCenter;
    Column.Title.Caption := 'ID';
    Column.Width := 20;

    Column := Columns.Add;
    Column.FieldName := 'USER_LOGIN';
    Column.Title.Caption := 'Login';
    Column.Width := 80;

    Column := Columns.Add;
    Column.FieldName := 'USER_NAME';
    Column.Title.Caption := 'Usuários';
    Column.Width := 200;

    Column := Columns.Add;
    Column.FieldName := 'GROUP_ID';
    Column.Title.Caption := 'Grupo';
    Column.Width := 50;

  end;

  // Criacao da interface do Grupo de Usuarios

  TabSheet := TTabSheet.Create(AOwner);
  TabSheet.Caption := 'Cadastro de Grupos';
  TabSheet.PageControl := PageControl;

  pnlGrupo := TPanel.Create(AOwner);
  with pnlGrupo do
  begin
    Align := alClient;
    Parent := TabSheet;
    ParentColor := True;
  end;

  Panel := TPanel.Create(AOwner);
  with Panel do
  begin
    Parent := pnlGrupo;
    Height := 55;
    Align := alTop;
    BevelInner := bvLowered;
    BevelOuter := bvNone;
    ParentColor := True;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Parent := Panel;
    Left := 8;
    Top := 8;
    Caption := 'Grupo ID';
    Enabled := False;
  end;

  Edit := TDBEdit.Create(AOwner);
  with Edit do
  begin
    Parent := Panel;
    Left := Label1.Left;
    Top := 24;
    Width := 50;
    Height := 19;
    DataField := 'GROUP_ID';
    DataSource := dtsGrupo;
    Enabled := False;
    ParentColor := True;
  end;

  Label1 := TLabel.Create(AOwner);
  with Label1 do
  begin
    Parent := Panel;
    Left := Edit.Left + Edit.Width + 5;
    Top := 8;
    Caption := 'Nome do Grupo';
  end;

  Edit := TDBEdit.Create(Self);
  with Edit do
  begin
    Parent := Panel;
    Left := Label1.Left;
    Top := Label1.Top+Label1.Height+3;
    Width := 290;
    Height := 19;
    CharCase := ecUpperCase;
    DataField := 'GROUP_NAME';
    DataSource := dtsGrupo;
  end;

  // **** Botoes para o grupo de usuarios

  pnlGrupoButton := TPanel.Create(AOwner);
  with pnlGrupoButton do
  begin
    Align       := alTop;
    BevelOuter  := bvLowered;
    ParentColor := True;
    Parent      := pnlGrupo;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Left    := 8;
    Top     := 8;
    Height  := 25;
    Caption := 'N&ovo';
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnNovoGrupoClick;
    Parent  := pnlGrupoButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := '&Editar';
    Left    := LastControl(pnlGrupoButton).Left + LastControl(pnlGrupoButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlGrupoButton).Height;
    Top     := FirstControl(pnlGrupoButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnEditarGrupoClick;
    Parent  := pnlGrupoButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := '&Gravar';
    Left    := LastControl(pnlGrupoButton).Left + LastControl(pnlGrupoButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlGrupoButton).Height;
    Top     := FirstControl(pnlGrupoButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnGravarGrupoClick;
    Parent  := pnlGrupoButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := '&Cancelar';
    Left    := LastControl(pnlGrupoButton).Left + LastControl(pnlGrupoButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlGrupoButton).Height;
    Top     := FirstControl(pnlGrupoButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnCancelarGrupoClick;
    Parent  := pnlGrupoButton;
  end;

  Button := TSpeedButton.Create(AOwner);
  with Button do
  begin
    Caption := 'E&xcluir';
    Left    := LastControl(pnlGrupoButton).Left + LastControl(pnlGrupoButton).Width + SEPARATOR_BUTTON;
    Height  := FirstControl(pnlGrupoButton).Height;
    Top     := FirstControl(pnlGrupoButton).Top;
    Width   := Canvas.TextWidth(Caption) + WITH_BUTTON;
    OnClick := btnExcluirGrupoClick;
    Parent  := pnlGrupoButton;
  end;

  // *************

  dbgGrupo := TDBGrid.Create(AOwner);
  with dbgGrupo do
  begin

    Parent := pnlGrupo;

    Align := alClient;
    DataSource := dtsGrupo;
    Options := [dgTitles, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit];

    Column := Columns.Add;
    Column.FieldName := 'GROUP_ID';
    Column.Title.Caption := 'ID';
    Column.Title.Alignment := taCenter;
    Column.Width := 20;

    Column := Columns.Add;
    Column.FieldName := 'GROUP_NAME';
    Column.Title.Caption := 'Grupo de Usuários';
    Width := 330;

  end;

  // Cria o painel que ficara no lado direito do formulario
  // que darah acesso a configuracao os itens do menu atraves do treeview

  pnlAcesso := TPanel.Create(AOwner);
  with pnlAcesso do
  begin
    Align  := alRight;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BorderStyle := bsNone;
    Parent := Self;
    ParentColor := True;
    Width  := 290;
  end;

  pnlTitulo := TPanel.Create(AOwner);
  with pnlTitulo do
  begin
    Align  := alTop;
    BevelInner := bvLowered;
    BevelOuter := bvLowered;
    BorderStyle := bsNone;
    Caption := ':::  C o n t r o l e   d e   A c e s s o s  :::';
    Color  := $00800040;
    Font.Color := clWhite;
    Font.Style := [fsBold];
    Height := 30;
    Parent := pnlAcesso;
  end;

  pnlMenu := TPanel.Create(AOwner);

  with pnlMenu do
  begin
    Align   := alTop;
    Caption := '';
    BevelInner := bvNone;
    BevelOuter := bvNone;
    Parent  := pnlAcesso;
    ParentColor := True;
  end;

  btnAplicar := TSpeedButton.Create(AOwner);
  with btnAplicar do
  begin
    Parent := pnlMenu;
    Top    := 8;
    Left   := 8;
    Width  := 100;
    Caption := '&Aplicar';
    OnClick := btnAplicarClick;
  end;

  btnRestaurar := TSpeedButton.Create(AOwner);
  with btnRestaurar do
  begin
    Parent := pnlMenu;
    Top    := 8;
    Left   := btnAplicar.Left+btnAplicar.Width+40;
    Width  := 100;
    Caption := '&Restaurar';
    OnClick := btnRestaurarClick;
  end;

  // **************

  TreeMenu := TTreeView.Create(AOwner);
  TreeMenu.Parent := pnlAcesso;
  TreeMenu.Align := alClient;
  TreeMenu.Images := ImageList1;

  // ************

  PopMenuTree := TPopupMenu.Create(Owner);
  PopMenuTree.Images := ImageList1;

  for i := 0 to 2 do
  begin

    MenuItem := TMenuItem.Create(PopMenuTree);
    MenuItem.OnClick := PopMenuTreeClick;
    MenuItem.ImageIndex := i;

    if i = 0 then
    begin
      MenuItem.Caption := 'Disponivel';
      MenuItem.Tag := 2;
    end else if i = 1 then
    begin
      MenuItem.Caption := 'Restringido';
      MenuItem.Tag := 0;
    end else if i = 2 then
    begin
      MenuItem.Caption := 'Invisivel';
      MenuItem.Tag     := 1;
    end;

    PopMenuTree.Items.Add(MenuItem);

  end;

  TreeMenu.PopupMenu := PopMenuTree;
  TreeMenu.ReadOnly  := True;
  {$IFDEF VCL}
  TreeMenu.HotTrack  := True;
  {$ENDIF}

end;

procedure TFrmAdm.btnAplicarClick(Sender: TObject);
var
  iGroup: Integer;
begin
  iGroup := mtGrupo.FieldByName('GROUP_ID').AsInteger;
  GravaTreeViewArquivo( pvTransaction, TreeMenu, iGroup);
end;

procedure TFrmAdm.btnRestaurarClick(Sender: TObject);
var
  _GrupoID: Integer;
begin
  if (PageControl.ActivePageIndex = 0) then
    _GrupoID := mtUsuario.FieldByName('GROUP_ID').AsInteger
  else
    _GrupoID := mtGrupo.FieldByName('GROUP_ID').AsInteger ;
  GravaArquivoTreeView( pvTransaction, TreeMenu, _GrupoID) ;
end;

end.
