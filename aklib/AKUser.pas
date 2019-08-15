{*
*  TAKUser
*
*  Copyright 1999, 2000 by Allan Kardek Nepomuceno Lima
*  GNU GPL - GNU General Public Lisence
*  e-mail: allan_kardek@yahoo.com.br

O componente possui as sequintes propriedades:
Active: Boolean             - Ativar/Desativar o componente
ErrorLogin: Integer         - Qtde de tentativas para os erros de login
Menu: TMenu                 - Menu que o componente ira controlar
Transaction: TIBTransaction - Transacao para acessar a base

Eventos
onLoad - Evento que sera chamado antes de apresentar a tela de login;
onLoadError - Evento que sera chamado quando ocorrer algum erro no login;

Metodos
Admin - Modo de administracao
AcessName - Verifica a permisao de um item

Observações importantes:

1. Na primeira vez que o componente apresentar a tela de login
e o usuario informar um nome e uma senha e confirmar
serao criadas as tabelas necessarias na base e o usuario sera
incluido em USER_USERS como administrador.

Para fazer a administracao dos acesso chame o metodo Admin()
*}

{$IFNDEF QAKLIB}
unit AKUser;
{$ENDIF}

{$I AKLib.inc}

interface

uses
  SysUtils, Classes, Consts,
  {$IFDEF MSWINDOWS}Windows, Messages,{$ENDIF}
  {$IFDEF CLX} Qt, QGraphics, QControls, QForms, QDialogs, QComCtrls,
  QStdCtrls, QExtCtrls, QMenus, QButtons,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs, ComCtrls,
  StdCtrls, ExtCtrls, Menus, Buttons,
  {$ENDIF}
  {$IFDEF DBX}{$ENDIF}
  {$IFDEF IBX}IBDatabase, IBQuery,{$ENDIF}
  {$IFDEF AK_MIDASLIB}MidasLib,{$ENDIF}
  DBClient, DB;

type

  { TAKIBUser }
  TAKIBUser = class(TComponent)
  private
    FActive: Boolean;
    FAppName: String;
    FUserDefault: String;
    FPasswordDefault: String;
    FErrorLogin: Integer;
    FGroup: Integer;
    FGroupName: String;
    FOnLoad: TNotifyEvent;
    FOnLoadError: TNotifyEvent;
    FMenu: TMenu;
    FMenuMain: TMainMenu;
    FOwner: TComponent;
    FPassword: String;
    {$IFDEF DBX}
    FTransaction: TSQLConnection;
    {$ENDIF}
    {$IFDEF IBX}
    FTransaction: TIBTransaction;
    {$ENDIF}
    FUserID: Integer;
    FUser: String;
    FUserName: String;
    procedure ConectarLogin;
    function IsLoginApplication: Boolean;   // Está conectado?
    procedure SetActive(Value: Boolean);
    procedure Validated;
    function Autorization:Integer;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Admin;
    function AcessName( Name: String; const Autorizacao: Integer = 0): Integer;
    procedure Login;
    function SetPassword: Boolean;
  published
    property Active: Boolean read FActive write SetActive;
    property ErrorLogin: Integer read FErrorLogin write FErrorLogin;
    property Group: Integer read FGroup;
    property GroupName: String read FGroupName write FGroupName;
    property OnLoad: TNotifyEvent read FOnLoad write FOnLoad;
    property OnLoadError: TNotifyEvent read FOnLoadError write FOnLoadError;
    property Menu: TMenu read FMenu write FMenu;
    property Transaction: TIBTransaction read FTransaction write FTransaction;
    property UserID: Integer read FUserID;
    property User:String read FUser;
    property UserName:String read FUserName;
    property UserDefault: String read FUserDefault write FUserDefault;
    property PasswordDefault: String read FPasswordDefault write FPasswordDefault;
  end;

  TUser = class(TAKIBUser);

procedure MenuCopy( Origem, Destino: TMenu; Sufixo: String);
procedure IComMenuToMenu( Origem, Destino: TMenu; Sufixo: String);

procedure MenuToTreeView( Menu: TMenu; TreeView: TTreeView);

procedure GravaTreeViewArquivo( Transacao: TIBTransaction;
                                TreeView: TTreeView; Group: Integer);
procedure GravaArquivoTreeView( Transacao: TIBTransaction;
                                TreeView: TTreeView;
                                Group: Integer);
function GravaMenu( Transacao: TIBTransaction; Menu:TMenu ):Boolean;
procedure LerMenu( Transacao: TIBTransaction; Menu:TMenu );
function LerAutorizacao( Menu: TMenuItem):Integer;

procedure LiberaMenu( Menu: TMenu);
procedure ProcuraNameMenu( Menu: TMenu; const Nome:String; const Autorizacao: Integer);

function ExistTable( Transacao: TIBTransaction; Table: String):Boolean;
function dbNextKey( Transacao: TIBTransaction; Table, Field: String):Integer;

function Substitui( Texto, Procura, Troca:String):String;
function Confirme( Mensagem:String):Boolean;
procedure MsgErro( Msg:String);
procedure Mensagem( Mensagem:String);

function FirstControl( win: TWinControl):TControl;
function LastControl( win: TWinControl):TControl;

procedure WinButtonDataSet( Win: TWinControl; DataSet: TDataSet);
procedure WinControlDataSet( Win: TWinControl; DataSet: TDataSet);

procedure DataSetToData( Origem, Destino: TDataSet; Manter: Boolean = False);
function dbSQLSelectFrom( Transacao: TIBTransaction; DataSet: TDataSet;
  TableName: String; Where: String=''):Boolean;

function dbSQLCacheUpdate( Transacao: TIBTransaction; DeltaDS: TDataSet;
  TableName: String; FieldDS: TFields;
  IniciarTransacao: Boolean = True):Boolean;

function dbSQLDelete( Transacao: TIBTransaction;
  DeltaDS: TDataSet; TableName: String; FieldDS: TFields;
  IniciarTransacao: Boolean = True):Boolean;

procedure Register;

implementation

uses
  {$IFDEF CLX}QAKUserAdm,{$ENDIF}
  {$IFDEF VCL}AKUserAdm,{$ENDIF}
  TypInfo;

resourcestring
  SLoginError =  'Não foi possível acessar o sistema.'+#13+
                 'O nome e/ou senha do usuário foram informados incorretamente !!!';
  SConectError = 'Não foi possível acessar o sistema.'#13+
                 'Banco de dados não conectado.'#13#13+
                 'Verifique se a rede está em perfeita condição de uso'#13+
                 'ou se Banco de dados realmente existe.'#13#13+
                 'A mensagem abaixo deve ser anotada e enviada ao'#13+
                 'administrador do sistema/banco.';
  SCaption = 'Login de Acesso';
  SUserName = 'Nome do Usuário:';
  SPassword = 'Senha:';
  SOK = '&OK';
  SCancel = '&Cancelar';

const
  FORM_INDENT = 14;
  FORM_HEIGHT = 32;

type

  TFrmLogin = class(TForm)
  private
    Image: TImage;
    LabName: TLabel;
    LabPass: TLabel;
    EdtName: TEdit;
    EdtPass: TEdit;
    Bevel: TBevel;
    btnOK: TButton;
    btnCancel: TButton;
    Rate: Double;
    procedure CreateButtons;
    procedure CreateEdits;
    procedure CreateLabels;
    procedure CreateBevels;
  public
    procedure CreateDialog(AOwner: TComponent);
    {$IFDEF VCL}
    procedure LocalKeyPress(Sender: TObject; var Key: Char);
    {$ENDIF}
    procedure LocalShow(Sender: TObject);
  end;

{ Código copiado de Dialogs.pas para suportar a função InputPassword }
function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputPassword(const ACaption, APrompt: string;
  var Value: string; APasswordChar: Char = '*'): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
begin
   Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        MaxLength := 255;
        Text := Value;
        SelectAll;
        // linha adicionada para permitir a digitação de senhas
        if (APasswordChar <> '') then
          PasswordChar := APasswordChar;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgOK;
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := SMsgDlgCancel;
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      if ShowModal = mrOk then
      begin
        Value := Edit.Text;
        Result := True;
      end;
    finally
      Form.Free;
    end;
end;

{ TAKIBUser }

// Create
procedure TAKIBUser.Admin;
begin
  IComAdm( Self);
  Autorization();
  IComMenuToMenu( Menu, FMenuMain, '2');
end;

procedure TAKIBUser.ConectarLogin;
var
  sUser, sPassword: String;
begin

  try

    if (FUserDefault = '') then
      sUser :=  FUser
    else
      sUser := FUserDefault;

    if (FPasswordDefault = '') then
      sPassword := FPassword
    else
      sPassword := FPasswordDefault;

    with FTransaction do
    begin
      DefaultDatabase.Open();
      Active := True;
    end;
  except
    on E:Exception do
    begin
      MessageBeep(MB_ICONASTERISK);
      MessageDlg( SConectError + E.Message, mtInformation, [mbOk], 0);
    end;
  end; // try-except

  if not IsLoginApplication then
    Exit;

  if Autorization() = 0 then
    FTransaction.DefaultDatabase.Connected := False
  else
  begin
    if Assigned(FMenu) then
    begin
      MenuCopy( FMenu, FMenuMain, '2');
      IComMenuToMenu( FMenu, FMenuMain, '2');
      TForm(Self.Owner).Menu := FMenuMain;
    end;
  end;

end;

constructor TAKIBUser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive     := True;
  FAppName    := Application.Title;
  FErrorLogin := 3;
  FGroup      := 0;
  FOwner      := AOwner;
  FMenuMain   := TMainMenu.Create(Self);
end;

destructor TAKIBUser.Destroy;
begin
  FMenuMain.Free;
  inherited;
end;

function TAKIBUser.Autorization:Integer;
var
  {$IFDEF IBX}
  Query: TIBQuery;
  {$ENDIF}
  iAutorizacao: Integer;
  sNomeMenu: String;
begin

  if not FTransaction.InTransaction then
    FTransaction.StartTransaction;

  Result := 0;

  {$IFDEF IBX}
  Query  := TIBQuery.Create(NIL);
  {$ENDIF}

  try try

    with Query do
    begin

      Transaction := FTransaction;

      if not ExistTable( FTransaction, 'USER_USERS') then
      begin
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('CREATE TABLE USER_USERS (');
        SQL.Add('    USER_ID INTEGER NOT NULL,');
        SQL.Add('    USER_LOGIN VARCHAR(30) NOT NULL,');
        SQL.Add('    USER_NAME VARCHAR(50) NOT NULL,');
        SQL.Add('    LAST_PWD_CHANGE TIMESTAMP,');
        SQL.Add('    EXPIRATION_DATE DATE,');
        SQL.Add('    USER_ACTIVE SMALLINT DEFAULT 1 NOT NULL,');
        SQL.Add('    USER_PWD VARCHAR(30),');
        SQL.Add('    GROUP_ID INTEGER NOT NULL)');
        SQL.EndUpdate;
        ExecSQL;
        // Primary keys definition
        Close;
        SQL.BeginUpdate; SQL.Clear;
        SQL.Add('ALTER TABLE USER_USERS');
        SQL.Add('ADD CONSTRAINT PK_USER_USERS PRIMARY KEY (USER_ID);');
        SQL.EndUpdate;
        ExecSQL;
        FTransaction.Commit;
        FTransaction.StartTransaction;
        Close;
        SQL.BeginUpdate; SQL.Clear;
        SQL.Add('INSERT INTO USER_USERS');
        SQL.Add('(USER_ID, USER_LOGIN, USER_NAME, USER_ACTIVE, USER_PWD, GROUP_ID)');
        SQL.Add('VALUES ( 1, '+QuotedStr(FUser)+', '+QuotedStr(FUser)+', 1, '+QuotedStr(FPassword)+', 1)');
        SQL.EndUpdate;
        ExecSQL;
        FTransaction.Commit;
        FTransaction.StartTransaction;
      end;

      if not ExistTable(FTransaction, 'USER_GROUP') then
      begin
        // Table: USER_GROUP
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('CREATE TABLE USER_GROUP (');
        SQL.Add('    GROUP_ID INTEGER NOT NULL,');
        SQL.Add('    GROUP_NAME VARCHAR(50) NOT NULL)');
        SQL.EndUpdate;
        ExecSQL;
        // Primary keys definition
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('ALTER TABLE USER_GROUP');
        SQL.Add('ADD CONSTRAINT PK_USER_GROUP PRIMARY KEY (GROUP_ID)');
        SQL.EndUpdate;
        ExecSQL;
        FTransaction.Commit;
        FTransaction.StartTransaction;
        // Group Administrador
        Close;
        SQL.BeginUpdate; SQL.Clear;
        SQL.Add('INSERT INTO USER_GROUP');
        SQL.Add('(GROUP_ID, GROUP_NAME)');
        SQL.Add('VALUES (1, '+QuotedStr('ADMINISTRADOR')+')');
        SQL.EndUpdate;
        ExecSQL;
        FTransaction.Commit;
        FTransaction.StartTransaction;
      end;

      Close;
      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  U.USER_ID, U.USER_NAME, U.GROUP_ID, G.GROUP_NAME,');
      SQL.Add('  U.EXPIRATION_DATE, U.USER_ACTIVE');
      SQL.Add('FROM');
      SQL.Add('  USER_USERS U');
      SQL.Add('LEFT OUTER JOIN USER_GROUP G ON (U.GROUP_ID = G.GROUP_ID)');
      SQL.Add('WHERE');
      SQL.Add('  U.USER_LOGIN = '+QuotedStr(FUser) );
      SQL.Add('  AND U.USER_PWD = '+QuotedStr(FPassword) );
      SQL.EndUpdate;
      Open; Last; First;

      if (RecordCount <> 1) then
      begin
        MsgErro( SLoginError);
        Exit;
      end;

      if FieldByName('USER_ACTIVE').AsInteger = 0 then
      begin
        MsgErro('O usuário '+QuotedStr(FUser)+' está desativado.'+#13+
                'Entre em contato com o Administrador do Sistema.');
        Exit;
      end;

      if FieldByName('EXPIRATION_DATE').AsDateTime > Date then
      begin
        MsgErro('A permisão do usuário '+QuotedStr(FUser)+' expirou.'+#13+
                'Entre em contato com o Administrador do Sistema.');
                Exit;
      end;

      Result     := FieldByName('USER_ID').AsInteger;
      FUserID    := Result;
      FUserName  := FieldByName('USER_NAME').AsString;
      FGroupName := FieldByName('GROUP_NAME').AsString;
      FGroup     := FieldByName('GROUP_ID').AsInteger;

      if not Assigned(FMenu) then
        Exit;

      LiberaMenu(FMenu);  // Libera toda a hierarquia do Menu

      if not ExistTable(FTransaction, 'USER_ACCESS') then
      begin
        // Table: USER_ACCESS
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('CREATE TABLE USER_ACCESS (');
        SQL.Add('    GROUP_ID INTEGER NOT NULL,');
        SQL.Add('    MENU_ID VARCHAR(50) NOT NULL,');
        SQL.Add('    AUTHORIZED SMALLINT DEFAULT 0 NOT NULL)');
        SQL.EndUpdate;
        ExecSQL;
        // Primary keys definition
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('ALTER TABLE USER_ACCESS');
        SQL.Add('ADD CONSTRAINT PK_USER_ACCESS PRIMARY KEY (GROUP_ID, MENU_ID)');
        SQL.EndUpdate;
        ExecSQL;
        FTransaction.Commit;
        FTransaction.StartTransaction;
      end;

      if not ExistTable(FTransaction, 'USER_PROGS') then
      begin
        // Table: USER_PROGS
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('CREATE TABLE USER_PROGS (');
        SQL.Add('    MENU_NAME VARCHAR(50) NOT NULL,');
        SQL.Add('    MENU_ID INTEGER NOT NULL,');
        SQL.Add('    MENU_LEVEL SMALLINT NOT NULL,');
        SQL.Add('    MENU_ORDER SMALLINT NOT NULL,');
        SQL.Add('    MENU_CAPTION VARCHAR(100) NOT NULL,');
        SQL.Add('    MENU_PARENT INTEGER NOT NULL,');
        SQL.Add('    MENU_ACTIVE SMALLINT DEFAULT 1 NOT NULL)');
        SQL.EndUpdate;
        ExecSQL;
        // Primary keys definition
        Close;
        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('ALTER TABLE USER_PROGS');
        SQL.Add('ADD CONSTRAINT PK_USER_PROGS PRIMARY KEY (MENU_NAME)');
        SQL.EndUpdate;
        ExecSQL;
        FTransaction.Commit;
        FTransaction.StartTransaction;
      end;

      Close;
      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('SELECT M.MENU_NAME, A.AUTHORIZED');
      SQL.Add('FROM USER_ACCESS A, USER_PROGS M');
      SQL.Add('WHERE A.GROUP_ID = '+IntToStr(FGroup) );
      SQL.Add('      AND M.MENU_ID = A.MENU_ID');
      SQL.EndUpdate;

      Open;
      First;

      while not EOF do
      begin
        sNomeMenu    := Fields[0].AsString;
        iAutorizacao := Fields[1].AsInteger;
        ProcuraNameMenu( FMenu, sNomeMenu, iAutorizacao);
        Next;
      end; { while }

    end;  { with Query }

  except
    on E:Exception do
    begin
      if FTransaction.InTransaction then
        FTransaction.Rollback;
      MsgErro(E.Message);
      Result := 0;
    end;
  end;
  finally
    if FTransaction.InTransaction then
      FTransaction.Commit;
    Query.Free;
  end;

end;  (* procedure AutorizaUsuario *)

function TAKIBUser.IsLoginApplication: Boolean;
begin
  {$IFDEF DBX}Resilt := FTransaction.Connected;{$ENDIF}
  {$IFDEF IBX}Result := FTransaction.DefaultDatabase.Connected;{$ENDIF}
end;

procedure TAKIBUser.Loaded;
begin

  inherited Loaded;

  if Assigned(FOnLoad) then
    FOnLoad(Self);

  if not (csDesigning in ComponentState) and FActive then
    Login;

end;

procedure TAKIBUser.Login;
var
  i, iCount: Integer;
begin

  with TFrmLogin.CreateNew(Self) do
  begin

    KeyPreview := TRUE;
    {$IFDEF VCL}
    OnKeyPress := LocalKeyPress;
    {$ENDIF}
    OnShow     := LocalShow;

    CreateDialog(FOwner);

    if FErrorLogin = 0 then
      iCount := 1
    else
      iCount := FErrorLogin;

    for i := 1 to iCount do
      case ShowModal of
        mrOk: begin
                FUser     := UpperCase(EdtName.Text);
                FPassword := LowerCase(EdtPass.Text);
                ConectarLogin();
                if IsLoginApplication then
                  Break;
              end;
        mrCancel: Break;
      end;

    Free;

  end;

  Validated();

end;

procedure TAKIBUser.SetActive(Value: Boolean);
begin
  if (FActive <> Value) then
  begin
    FActive := Value;
    if not (csDesigning in ComponentState) and
       not (csLoading in ComponentState) and FActive then
      Login;
  end;
end;

procedure TAKIBUser.Validated;
begin
  if not IsLoginApplication then begin
    if Assigned(FOnLoadError) then
      FOnLoadError(Self)
    else
      Application.Terminate;
  end;
end;

{ TFrmLogin }

procedure TfrmLogin.CreateEdits;
begin
  // nome do usuario
  EdtName := TEdit.Create(Self);
  with EdtName do begin
    Parent := Self;
    CharCase := ecUpperCase;
    Left := LabName.Left + LabName.Width + Round(Rate * FORM_INDENT);
    Top := LabName.Top - 4;
    Width := Round(Rate * 180);
    TabOrder := 0;
    LabName.FocusControl := EdtName;
  end;
  //
  EdtPass := TEdit.Create(Self);
  with EdtPass do  begin
    Parent := Self;
    CharCase := ecLowerCase;
    Left := EdtName.Left;
    {$IFDEF VCL}
    PasswordChar := '*';
    {$ENDIF}
    Top := LabPass.Top - 4;
    Width := EdtName.Width;
    TabOrder := 1;
    LabPass.FocusControl := EdtPass;
  end;
end;

procedure TfrmLogin.CreateLabels;
begin

  LabName := TLabel.Create(Self);
  with LabName do begin
    Parent  := Self;
    Caption := SUserName;
    Left    := Image.Left + Image.Width + Round(Rate * FORM_INDENT);
    Top     := Round(Rate * FORM_INDENT);
  end;

  LabPass := TLabel.Create(Self);
  with LabPass do begin
    Parent  := Self;
    Caption := SPassword;
    Left    := LabName.Left;
    Top     := LabName.Top + LabName.Height + Round(Rate * FORM_INDENT);
  end;

end;

// CreateBevels
procedure TFrmLogin.CreateBevels;
begin
  Bevel := TBevel.Create(Self);
  with Bevel do
  begin
    Parent := Self;
    Height := 2;
    Left := Image.Left;
    Top := LabPass.Top + LabPass.Height + Round(Rate * FORM_INDENT) + 4;
    Width := LabName.Width;
  end;
end;

procedure TFrmLogin.CreateButtons;
begin
  // botão Ok
  BtnOk := TButton.Create(Self);
  with BtnOk do
  begin
    Parent := Self;
    Caption := SOK;
    ModalResult := mrOk;
    Height := Round(Rate * 25);
    Width := Round(Rate * 80);
    Left := Bevel.Left;
    Top := Bevel.Top + Round(Rate * FORM_INDENT) + 2;
    TabOrder := 2;
  end;
  // botão Cancel
  BtnCancel := TButton.Create(Self);
  with BtnCancel do
  begin
    Parent := Self;
    Cancel := True;
    Caption := SCancel;
    Left := BtnOk.Left + BtnOk.Width + Round(Rate * FORM_INDENT * 2);
    Top := BtnOk.Top;
    Height := BtnOk.Height;
    Width := BtnOk.Width;
    ModalResult := mrCancel;
    TabOrder := 3;
  end;
end;

procedure TFrmLogin.CreateDialog(AOwner: TComponent);
begin
  // cria formulário
  {$IFDEF VCL}
  BorderStyle := bsDialog;
  {$ENDIF}
  {$IFDEF CLX}
  BorderStyle := fbsDialog;
  {$ENDIF}
  Caption := SCaption;
  Font.Assign(TForm(AOwner).Font);
  Rate := Canvas.TextWidth('W') / 11;
  Position := poScreenCenter;
  Icon := Application.Icon;
  // cria imagem
  {$IFDEF VCL}
  if Icon.Empty then
    Icon.Handle := LoadIcon( 0, IDI_APPLICATION);
  {$ENDIF}

  Image := TImage.Create(Self);
  Image.Picture.Assign(Icon);

  Image.Parent := Self;
  Image.Left   := Round( Rate * FORM_INDENT);
  Image.Height := Round( Rate * FORM_HEIGHT);
  Image.Width  := Image.Height;

  // cria outros componentes
  CreateLabels;
  CreateEdits;
  CreateBevels;
  CreateButtons;
  // ajusta tamanho do formulário
  ClientHeight := BtnOk.Top + BtnOk.Height + Round(Rate * FORM_INDENT);
  ClientWidth  := EdtName.Left + EdtName.Width + Round(Rate * FORM_INDENT * 2);
  Bevel.Width  := ClientWidth - Round(Rate * FORM_INDENT) * 2;
end;

{$IFDEF VCL}
procedure TFrmLogin.LocalKeyPress(Sender: TObject; var Key: Char);
begin
  if (Screen.ActiveControl <> nil) and (Key = #13) then
  begin
    Key := #0;
     PostMessage( TForm(Sender).Handle, WM_KeyDown, VK_TAB, 0);
  end;
end;
{$ENDIF}

procedure TFrmLogin.LocalShow(Sender: TObject);
begin
  if Length(Trim(EdtName.Text)) = 0 then
    EdtName.SetFocus
  else
    EdtPass.SetFocus;
end;

{ Acesso }

function TAKIBUser.AcessName(Name:String; const Autorizacao:Integer = 0):Integer;

  function MenuItemToAcess( MenuOpcao:TMenuItem): Integer;
  var i: Integer;
  begin

    Result := -1;

    for i := 0 to MenuOpcao.Count - 1 do
      if UpperCase(MenuOpcao.Items[i].Name) = UpperCase(Name) then begin
        Result := LerAutorizacao( MenuOpcao.Items[i]);
        Break;
      end else begin
        Result := MenuItemToAcess( MenuOpcao.Items[i]);  // recursividade
        if Result <> -1 then
          Break;
      end;

  end;  {MenuItemToAcess}

var
  i: Integer;
begin

  Result := -1;

  for i := 0 to FMenu.Items.Count - 1 do
  begin

    if (UpperCase(FMenu.Items[i].Name) = UpperCase(Name)) then
    begin
      Result := LerAutorizacao( Menu.Items[i]);
      Break;
    end else
    begin
      Result := MenuItemToAcess( Menu.Items.Items[i]);
      if (Result <> -1) then
        Break;
    end;

  end;

  if (Result = -1) then
    Result := Autorizacao;

end; { MenuToAcesso }

function TAKIBUSer.SetPassword:Boolean;
var
  Query: TIBQuery;
  sPassword, sNewPassword: String;
begin

  Result := False;
  sPassword := '';

  if not InputPassword( 'Senha Atual',
                        'Informe a senha atual para prosseguir', sPassword) then
    Exit;

  if (sPassword = EmptyStr) then
  begin
    SysUtils.Beep;
    SysUtils.Beep;
    Exit;
  end;

  sPassword := LowerCase(sPassword);

  if (sPassword <> FPassword) then
  begin
    Mensagem('A senha informada não confere. Tente novamente.');
    Exit;
  end;

  sPassword := '';

  if not InputPassword( 'Nova Senha',
                        'Informe a nova senha para prosseguir', sPassword) or
     (sPassword = EmptyStr) then
    Exit;

  sNewPassword := LowerCase(sPassword);;

  sPassword := '';

  if not InputPassword( 'Nova Senha Novamente',
                        'Informe novamente a nova senha para prosseguir', sPassword) then
    Exit;

  if (sPassword = EmptyStr) then
  begin
    Mensagem('Senha em branco permitida. Repita a operação.');
    Exit;
  end;

  sPassword := LowerCase(sPassword);

  if (sNewPassword <> sPassword) then
  begin
    Mensagem('A nova senha não confere. Tente novamente.');
    Exit;
  end;

  Query := TIBQuery.Create(NIL);

  try try

    Query.Transaction := FTransaction;

    Query.SQL.BeginUpdate;
    Query.SQL.Add('UPDATE USER_USERS');
    Query.SQL.Add('SET USER_PWD = :P');
    Query.SQL.Add('WHERE USER_ID = :U');
    Query.SQL.EndUpdate;

    Query.Params[0].AsString := sNewPassword;
    Query.Params[1].AsInteger := UserID;

    Query.ExecSQL;

    Result := True;

  except
    on E:Exception do
      Mensagem(E.Message);
  end;
  finally
    Query.Free;
  end;

  if Result then
    Mensagem('A senha foi alterada com sucesso !!!');
    
end;

procedure Register;
begin
  RegisterComponents('AK Lib', [TAKIBUser]);
end;

// ======= Rotinas Utilitarias ========

function ExistTable( Transacao: TIBTransaction; Table: String):Boolean;
var
  Tables: TStringList;
begin

  Tables := TStringList.Create;

  try
    Transacao.DefaultDatabase.GetTableNames(Tables);
    Result := (Tables.IndexOf(Table) > 0);
  finally
    Tables.Free;
  end;

end;

function dbNextKey( Transacao: TIBTransaction; Table, Field: String):Integer;
var
  {$IFDEF IBX}
  Query: TIBQuery;
  {$ENDIF}
begin

  {$IFDEF IBX}
  Query := TIBQuery.Create(NIL);
  {$ENDIF}

  if not Transacao.InTransaction then
   Transacao.StartTransaction;

  try try

    with Query do
    begin
      Transaction := Transacao;
      SQL.Text := 'SELECT MAX('+Field+')+1 FROM '+Table;
      Open;
      Result := Fields[0].AsInteger;
    end;

  except

    on E:Exception do
    begin
      if Transacao.InTransaction then
        Transacao.Rollback;
      MessageDlg(E.Message, mtError, [mbOK], 0);
      Result := 0;
    end;
  end;
  finally
    if Transacao.InTransaction then
      Transacao.Commit;
    Query.Free;
  end;

end;  // function dbNextKey

function Substitui( Texto, Procura, Troca:String):String;
var
  iPos: Integer;
begin
  if (Procura <> Troca) then
    while Pos( Procura, Texto) > 0 do
    begin
      iPos  := Pos( Procura, Texto);
      Texto := Copy( Texto, 1, iPos-1) + Troca +
               Copy( Texto, iPos+Length(Procura),
                     Length(Texto)-(Length(Procura)+iPos-1));
    end;
  Result := Texto;
end;

function Confirme(Mensagem:String):Boolean;
begin
  Result := True;
  if (Mensagem = '') then
    Exit;
  {$IFDEF VCL}
  Result := (Application.MessageBox( PChar(Mensagem), PChar('Confirme'),
                         mb_iconquestion + mb_YesNo + MB_DEFBUTTON2 ) = idYes);
  {$ENDIF}
  {$IFDEF CLX}
  Result := (Application.MessageBox( Mensagem, 'Confirme', [smbYes, smbNo],
                                     smsInformation, smbNo, smbNo) = smbYes);
  {$ENDIF}
end;

procedure MsgErro(Msg:String);
var
  Cursor: TCursor;
begin
  Cursor := SetCursor(crDefault);
  Sysutils.Beep;
  MessageDlg( Msg, mtError, [mbOK], 0);
  Application.ProcessMessages;
  SetCursor(Cursor);
end;

procedure Mensagem( Mensagem:String);
var
  Cursor: TCursor;
begin
  Cursor := SetCursor(crDefault);
  Sysutils.Beep;
  MessageDlg( Mensagem, mtInformation,[mbOK],0);
  Application.ProcessMessages;
  SetCursor(Cursor);
end;

// ==========================================================================

(*  Constroi um TreeView baseado em um Menu *)
procedure MenuToTreeView( Menu: TMenu; TreeView: TTreeView);
var
  i: Integer;
  TreeNode: TTreeNode;
  sCaption: String;

  (*  Constroi as ramificacoes de um TreeNode baseado em um MenuItem *)
  procedure MenuItemToTreeNode( MenuOpcao: TMenuItem; TreeNode: TTreeNode);
  var
    TreeNode2: TTreeNode;
    i: Integer;
    sCaption: String;
  begin

    for i := 0 to MenuOpcao.Count - 1 do
      if (MenuOpcao.Items[i].Caption <> '-') then
      begin
        sCaption := StripHotkey( MenuOpcao.Items[i].Caption);
        TreeNode2 := TreeView.Items.AddChild( TreeNode, sCaption);
        {$IFDEF VCL}
        TreeNode2.StateIndex := MenuOpcao.Items[i].Tag;
        {$ENDIF}
        MenuItemToTreeNode( MenuOpcao.Items[i], TreeNode2);
      end;

  end;  // procedure MenuItemToTreeNode

begin

  {$IFDEF IDEBUG}
  ShowMessage('Entrada MenuToTreeView');
  {$ENDIF}

  TreeView.Items.Clear;

  for i := 0 to Menu.Items.Count-1 do begin
    sCaption := Substitui( Menu.Items[i].Caption, '&', '');
    TreeNode := TreeView.Items.Add( nil, sCaption);
    {$IFDEF VCL}
    TreeNode.StateIndex := Menu.Items[i].Tag;
    {$ENDIF}
    MenuItemToTreeNode( Menu.Items[i], TreeNode);
  end;

  {$IFDEF IDEBUG}
  ShowMessage('Saída MenuToTreeView');
  {$ENDIF}

end;  // procedure MenuToTreeView

{ *** ================================================================= **** }

(* Reconstroi o Menu baseado nas informacoes de USER_PROGS *)
procedure LerMenu( Transacao: TIBTransaction; Menu: TMenu);
var
  Query: TIBQuery;
  MenuOpcao: TMenuItem;

  (* Constroi o MenuItem baseado nas informacoes de USER_PROGS *)
  procedure LerMenuItem( MenuOpcao: TMenuItem; MenuID:Integer);
  var
    Query: TIBQuery;
    SubMenuItem: TMenuItem;
  begin

    Query := TIBQuery.Create(Application);

    try

      Query.Transaction := Transacao;

      Query.SQL.Clear;
      Query.SQL.BeginUpdate;
      Query.SQL.Add('SELECT   MENU_NAME, MENU_CAPTION, MENU_ID');
      Query.SQL.Add('FROM     USER_PROGS');
      Query.SQL.Add('WHERE    MENU_PARENT = '+IntToStr(MenuID) );
      Query.SQL.Add('ORDER BY MENU_ORDER');
      Query.SQL.EndUpdate;

      Query.Open;
      Query.First;

      while not Query.EOF do begin

        SubMenuItem := TMenuItem.Create(Menu);

        SubMenuItem.Name    := Query.Fields[0].AsString;    // Name
        SubMenuItem.Caption := Query.Fields[1].AsString;    // Caption
        SubMenuItem.Tag     := Query.Fields[2].AsInteger;   // ID

        MenuOpcao.Add(SubMenuItem);

        LerMenuItem( SubMenuItem, SubMenuItem.Tag );

        Query.Next;

      end;  // while not EOF

    finally
      Query.Free;
    end;

  end;  { LerMenuItem }

begin

  if not Transacao.InTransaction then
    Transacao.StartTransaction;

  Query := TIBQuery.Create(Application);

  try try

    Query.Transaction := Transacao;

    Query.SQL.Clear;
    Query.SQL.BeginUpdate;
    Query.SQL.Add('SELECT   MENU_NAME, MENU_CAPTION, MENU_ID');
    Query.SQL.Add('FROM     USER_PROGS');
    Query.SQL.Add('WHERE    MENU_LEVEL = 0');
    Query.SQL.Add('ORDER BY MENU_ORDER');
    Query.SQL.EndUpdate;

    Query.Open;
    Query.First;

    while not Query.EOF do begin

      MenuOpcao := TMenuItem.Create(Menu);

      MenuOpcao.Name    := Query.Fields[0].AsString;
      MenuOpcao.Caption := Query.Fields[1].AsString;
      MenuOpcao.Tag     := Query.Fields[2].AsInteger;

      Menu.Items.Add(MenuOpcao);
      LerMenuItem( MenuOpcao, MenuOpcao.Tag );

      Query.Next;

    end;  // while not EOF

  except
    if Transacao.InTransaction then Transacao.RollbackRetaining;
  end;

  finally
    if Transacao.InTransaction then Transacao.CommitRetaining;
    Query.Free;
  end;  // try


end;  { procedure LerMenu }

{ *** ================================================================= **** }

function LerAutorizacao( Menu: TMenuItem):Integer;
begin

  if not Menu.Visible then
    Result := 2
  else if not Menu.Enabled then
    Result := 1
  else
    Result := 0;

end;

(* Grava em USER_PROGS o modelo hierarquico de Menu *)
function GravaMenu( Transacao: TIBTransaction; Menu:TMenu ):Boolean;
var
  Query: TIBQuery;
  Nivel: SmallInt;

  (* Grava em USER_PROGS o modelo hierarquico de MenuItem *)
  procedure GravaMenuItem( MenuOpcao: TMenuItem; MenuParent: Integer;
    var Nivel: SmallInt);
  var
    sName, sCaption: String;
    i, iOrdem, iID: Integer;
  begin

    Nivel := Nivel + 1;

    for i := 0 to MenuOpcao.Count - 1 do begin

      sName    := UpperCase(MenuOpcao[i].Name);
      sCaption := MenuOpcao[i].Caption;
      iOrdem   := i;
      iID      := 0;

      if Length(sName) = 0 then   // O MenuItem nao possui name nao gravar
        Continue;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.BeginUpdate;
      Query.SQL.Add('SELECT MENU_ID FROM USER_PROGS');
      Query.SQL.Add('WHERE  MENU_NAME = '+QuotedStr(sName) );
      Query.SQL.EndUpdate;

      Query.Open;
      Query.First;

      if (Query.RecordCount > 0) then
        iID := Query.Fields[0].AsInteger;

      Query.Close;
      Query.SQL.Clear;
      Query.SQL.BeginUpdate;

      if iID = 0 then begin    // O Item do menu ainda nao esta cadastrado

        // Calcula um ID para o MenuItem
        Query.SQL.Add('SELECT MAX(MENU_ID) FROM USER_PROGS');
        Query.SQL.EndUpdate;

        Query.Open;

        iID := Query.Fields[0].AsInteger + 1;

        // Cadastra um registro para o MenuItem
        Query.Close;
        Query.SQL.Clear;
        Query.SQL.BeginUpdate;
        Query.SQL.Add('INSERT INTO USER_PROGS');
        Query.SQL.Add('( MENU_NAME, MENU_ID, MENU_LEVEL, MENU_ORDER, ');
        Query.SQL.Add('  MENU_CAPTION, MENU_PARENT, MENU_ACTIVE)');
        Query.SQL.Add('VALUES');
        Query.SQL.Add('( :NAME, :ID, :LEVEL, :ORDER, :CAPTION, :PARENT, 1)');
        Query.SQL.EndUpdate;

        Query.ParamByName('NAME').AsString    := sName;
        Query.ParamByName('ID').AsInteger     := iID;
        Query.ParamByName('LEVEL').AsSmallInt := Nivel;
        Query.ParamByName('ORDER').AsSmallInt := iOrdem;
        Query.ParamByName('CAPTION').AsString := sCaption;
        Query.ParamByName('PARENT').AsInteger := MenuParent;

      end else begin        // Atualizar Item de Menu

        // Atualiza o registro do MenuItem com os eventuais novos dados
        Query.SQL.Add('UPDATE USER_PROGS');
        Query.SQL.Add('SET MENU_LEVEL = :LEVEL, MENU_ORDER = :ORDER,');
        Query.SQL.Add('    MENU_CAPTION = :CAPTION, MENU_PARENT = :PARENT,');
        Query.SQL.Add('    MENU_ACTIVE = 1');
        Query.SQL.Add('WHERE MENU_ID = :ID');
        Query.SQL.EndUpdate;

        Query.ParamByName('LEVEL').AsSmallInt := Nivel;
        Query.ParamByName('ORDER').AsSmallInt := iOrdem;
        Query.ParamByName('CAPTION').AsString := sCaption;
        Query.ParamByName('PARENT').AsInteger := MenuParent;
        Query.ParamByName('ID').AsInteger     := iID;

      end;

      Query.ExecSQL;

      if (MenuOpcao.Count > 0) then
        GravaMenuItem( MenuOpcao[i], iID, Nivel);

    end;  // for

    Nivel := Nivel - 1;

  end;  // procedure GravaMenuItem

begin

  if not Transacao.InTransaction then
    Transacao.StartTransaction;

  Result := True;
  Query  := TIBQuery.Create(Application);

  try try

    Query.Transaction := Transacao;

    Query.SQL.Clear;
    Query.SQL.BeginUpdate;
    Query.SQL.Add('UPDATE USER_PROGS SET MENU_ACTIVE = 0');
    Query.SQL.EndUpdate;
    Query.ExecSQL;

    // Grava em USER_PROGS a hieraquia de um TMenu
    Nivel := -1;
    GravaMenuItem( Menu.Items, 0, Nivel);

    // Elimina todos os MENU_ACTIVE = 0 de USER_PROGS
    Query.Close;
    Query.SQL.BeginUpdate;
    Query.SQL.Clear;
    Query.SQL.Add('DELETE FROM USER_PROGS');
    Query.SQL.Add('WHERE MENU_ACTIVE = 0');
    Query.SQL.EndUpdate;
    Query.ExecSQL;

  except
    on E:Exception do begin
      if Transacao.InTransaction then Transacao.RollbackRetaining;
      Result := False;
      MsgErro( 'Erro na execução de "GRAVAMENU"'+#13#13+E.Message);
    end;
  end;  // except

  finally
    if Transacao.InTransaction then Transacao.CommitRetaining;
    Query.Free;
  end; // finally


end;  // procedure GravaMenu

{ *** ================================================================= **** }

(* Concede Autorizacao a um MenuItem cfe Autorizacao *)
procedure AutorizaMenuItem( MenuOpcao: TMenuItem; Autorizacao: Integer);
begin

  if (Autorizacao = 1) then begin             // Desabilitado
    MenuOpcao.Visible := True;
    MenuOpcao.Enabled := False;
  end else if (Autorizacao = 2) then begin   // Invisivel
    MenuOpcao.Visible := False;
    MenuOpcao.Enabled := False;
  end else begin                           // Habilitado
    MenuOpcao.Visible := True;
    MenuOpcao.Enabled := True;
  end;

end;  // procedure AutorizaMenuItem

(* Libera toda a hierarquia do Menu *)
procedure LiberaMenu( Menu: TMenu);
var
  i: Integer;

  (* Libera toda a hierarquia do MenuItem *)
  procedure LiberaMenuItem( MenuOpcao:TMenuItem);
  var
    i: Integer;
  begin
    for i := 0 to MenuOpcao.Count - 1 do begin
      AutorizaMenuItem( MenuOpcao.Items[i], 0);
      LiberaMenuItem( MenuOpcao.Items[i]);
    end;
  end;  // procedure LiberaMenuItem

begin

  for i := 0 to Menu.Items.Count - 1 do begin
    AutorizaMenuItem( Menu.Items[i], 0);   // Libera MenuItem
    LiberaMenuItem( Menu.Items[i]);
  end;

end; // procedure LiberaMenu

(* ======================================================================== *)

(* Libera toda a hierarquia do TreeView *)
procedure LiberaTreeView( TreeView:TTreeView);
var
  i: Integer;

  (* Libera toda a hierarquia do TreeNode *)
  procedure LiberaTreeNode( TreeNode:TTreeNode);
  var
    i: Integer;
  begin
    TreeNode.ImageIndex    := 0;
    TreeNode.SelectedIndex := 0;
    for i := 0 to TreeNode.Count - 1 do
      LiberaTreeNode( TreeNode.Item[i]);
  end;  // procedure LiberaTreeNode

begin

  for i := 0 to TreeView.Items.Count - 1 do
    LiberaTreeNode( TreeView.Items[i]);

end;  // procedure LiberaTreeView

(* ======================================================================== *)

{ Procura um MenuItem em Menu para autoriza cfe sua propridade tag }
procedure ProcuraTagMenu( Menu: TMenu; MenuTag, Autorizacao: Integer);
var
  i: Integer;

  { Autoriza um MenuItem cfe sua propriedade tag }
  function ProcuraTagMenuItem( MenuOpcao: TMenuItem):Boolean;
  var
    i: Integer;
  begin

    Result := False;

    for i := 0 to MenuOpcao.Count - 1 do
      if MenuOpcao.Items[i].Tag = MenuTag then begin// ID
        AutorizaMenuItem( MenuOpcao.Items[i], Autorizacao);
        Result := True;
        System.Break;
      end else if ProcuraTagMenuItem( MenuOpcao.Items[i]) then begin
        Result := True;
        System.Break;
      end;

  end; //  function ProcuraTagMenuItem

begin

  for i := 0 to Menu.Items.Count - 1 do
    if Menu.Items[i].Tag = MenuTag then begin
      AutorizaMenuItem( Menu.Items[i], Autorizacao);
      System.Break;
    end else if ProcuraTagMenuItem( Menu.Items[i]) then
      System.Break;

end;  // procedure ProcuraTagMenu

(* ======================================================================== *)

{ *** ProcuraNameMenu *** }
procedure ProcuraNameMenu( Menu: TMenu; const Nome:String; const Autorizacao: Integer);
var
  i: Integer;

   { *** ProcuraNameMenuItem *** }
   function ProcuraNameMenuItem( MenuOpcao:TMenuItem):Boolean;
   var
     i: Integer;
   begin

     Result := False;

     for i := 0 to MenuOpcao.Count - 1 do
       if UpperCase( MenuOpcao.Items[i].Name) = UpperCase(Nome) then begin
         AutorizaMenuItem( MenuOpcao.Items[i], Autorizacao);
         Result := True;
         System.Break;
       end else if ProcuraNameMenuItem( MenuOpcao.Items[i]) then begin
         Result := True;
         System.Break;
       end;

   end;  // function ProcuraNameMenuItem

begin

  for i := 0 to Menu.Items.Count - 1 do
    if ( UpperCase(Menu.Items.Items[i].Name) = UpperCase(Nome) ) then begin
      AutorizaMenuItem( Menu.Items.Items[i], Autorizacao);
      System.Break;
    end else if ProcuraNameMenuItem( Menu.Items.Items[i]) then
      System.Break;

end; // procedure ProcuraNameMenu

(* ======================================================================== *)

{ *** ProcuraTreeView *** }
procedure ProcuraTreeView( TreeView: TTreeView; IDMenu, Autorizacao: Integer);
var
  i: Integer;

  function ProcuraTreeNode( TreeNode: TTreeNode):Boolean;
  var
    i: Integer;
  begin

    {$IFDEF CLX}
    Result := True;
    {$ENDIF}
    {$IFDEF VCL}
    Result := False;

    if (TreeNode.StateIndex = IDMenu) then
    begin
      TreeNode.ImageIndex    := Autorizacao;
      TreeNode.SelectedIndex := Autorizacao;
      Result                 := True;
    end else
      for i := 0 to TreeNode.Count-1 do
        if ProcuraTreeNode( TreeNode.Item[i]) then
        begin
          Result := True;
          System.Break;
        end;
    {$ENDIF}

  end;  // function ProcuraTreeNode

begin

  for i := 0 to TreeView.Items.Count-1 do
    if ProcuraTreeNode( TreeView.Items[i]) then
      System.Break;

end;  // procedure ProcuraTreeView

(* ========================================================================= *)

procedure AplicarTreeViewMenu( TreeView: TTreeView; Menu: TMenu);
var
  i: Integer;

  procedure AplicarTreeNodeMenu( TreeNode: TTreeNode);
  var
    i: Integer;
  begin

   (* Procura um MenuItem em Menu para autorizar conforme TreeNode
      Parametros    Menu,  Tag,                Autorizacao        *)
    {$IFDEF VCL}
    ProcuraTagMenu( Menu, TreeNode.StateIndex, TreeNode.ImageIndex);
    {$ENDIF}

    for i := 0 to TreeNode.Count - 1 do
      AplicarTreeNodeMenu( TreeNode.Item[i]);

  end;  // procedure AplicarTreeNodeMenu

begin

  // Libera toda a hierarquisa do "Menu"
  LiberaMenu(Menu);

  for i := 0 to TreeView.Items.Count-1 do
     AplicarTreeNodeMenu( TreeView.Items[i]);

end;  // proceudre AplicarTreeViewMenu

(* ======================================================================== *)

procedure GravaTreeViewArquivo( Transacao: TIBTransaction;
                                TreeView: TTreeView; Group: Integer);
var
  i: Integer;
  Query: TIBQuery;

  procedure GravaTreeNodeArquivo( TreeNode: TTreeNode);
  var
    i, iMenu_ID, Autorizacao: Integer;
  begin

    {$IFDEF VCL}
    iMenu_ID    := TreeNode.StateIndex;
    {$ENDIF}

    Autorizacao := TreeNode.ImageIndex;

    Query.Close;
    Query.SQL.Clear;
    Query.SQL.BeginUpdate;
    Query.SQL.Add('SELECT * FROM USER_ACCESS');
    Query.SQL.Add('WHERE GROUP_ID = '+IntToStr(Group)+' AND ');
    Query.SQL.Add('      MENU_ID = '+IntToStr(iMenu_ID) );
    Query.SQL.EndUpdate;

    Query.Open;

    if Query.RecordCount = 0 then begin     // Inclui a autorizacao

      Query.SQL.Clear; Query.SQL.BeginUpdate;
      Query.SQL.Add('INSERT INTO USER_ACCESS');
      Query.SQL.Add('  ( GROUP_ID, MENU_ID, AUTHORIZED)');
      Query.SQL.Add('VALUES ( '+IntToStr(Group)+', '+
                                IntToStr(iMenu_ID)+', '+
                                IntToStr(Autorizacao)+' )' );
      Query.SQL.EndUpdate;

    end else begin                    // Atualiza a autorizacao

      Query.SQL.Clear; Query.SQL.BeginUpdate;
      Query.SQL.Add('UPDATE USER_ACCESS');
      Query.SQL.Add('SET AUTHORIZED = '+IntToStr(Autorizacao) );
      Query.SQL.Add('WHERE GROUP_ID = '+IntToStr(Group)+' AND' );
      Query.SQL.Add('      MENU_ID = '+IntToStr(iMenu_ID) );
      Query.SQL.EndUpdate;

    end;  // if RecordCount

    Query.ExecSQL;

    for i := 0 to TreeNode.Count - 1 do
      GravaTreeNodeArquivo( TreeNode.Item[i]);

  end;  // procedure GravaTreeNodeArquivo

begin

  if not Transacao.InTransaction then
    Transacao.StartTransaction;

  Query := TIBQuery.Create(Application);

  try try

    Query.Transaction := Transacao;

    for i := 0 to TreeView.Items.Count-1 do
      GravaTreeNodeArquivo( TreeView.Items[i]);

  except
    on E:Exception do begin
      if Transacao.InTransaction then Transacao.RollbackRetaining;
      MsgErro('Erro em GravaTreeViewArquivo'+#13+
              '(Administração de Usuários)'+#13#13+E.Message);
    end;
  end;  // except

  finally
    if Transacao.InTransaction then Transacao.CommitRetaining;
    Query.Free;
  end;  // finally

end;

(* ======================================================================== *)

procedure GravaArquivoTreeView( Transacao: TIBTransaction;
                                TreeView: TTreeView; Group: Integer);
var
  Query: TIBQuery;
begin

  if not Transacao.InTransaction then
    Transacao.StartTransaction;

  Query := TIBQuery.Create(Application);

  try try

    Query.Transaction := Transacao;

    Query.SQL.Clear;
    Query.SQL.BeginUpdate;
    Query.SQL.Add('SELECT MENU_ID, AUTHORIZED FROM USER_ACCESS');
    Query.SQL.Add('WHERE GROUP_ID = '+IntToStr(Group) );
    Query.SQL.EndUpdate;

    Query.Open;

    LiberaTreeView(TreeView);

    Query.First;

    while not Query.EOF do begin
      ProcuraTreeView( TreeView, Query.Fields[0].AsInteger,   // MENU_ID
                                 Query.Fields[1].AsInteger);  // AUTHORIZED
      Query.Next;
    end;

  except
    if Transacao.InTransaction then
      Transacao.RollbackRetaining;
  end;

  finally;
    if Transacao.InTransaction then
      Transacao.CommitRetaining;
     Query.Free;
  end;

  TreeView.Refresh;

end;

procedure MenuCopy( Origem, Destino: TMenu; Sufixo: String);
var
  i, iTag: Integer;
  sNome: String;
  Item: TMenuItem;

  procedure CopyItemMenu( ItemOrigem, ItemDestino: TMenuItem);
  begin
    {$IFNDEF AK_D5}    // nao eh Delphi 5.0
    ItemDestino.AutoCheck   := ItemOrigem.AutoCheck;
    {$ENDIF}
    ItemDestino.AutoHotkeys := ItemOrigem.AutoHotkeys;
    {$IFDEF VCL}
    ItemDestino.Break       := ItemOrigem.Break;
    {$ENDIF}
    ItemDestino.Caption  := ItemOrigem.Caption;
    ItemDestino.Enabled  := ItemOrigem.Enabled;
    ItemDestino.Visible  := ItemOrigem.Visible;
    ItemDestino.Hint     := ItemOrigem.Hint;
    ItemDestino.ShortCut := ItemOrigem.ShortCut;
    if Assigned(ItemOrigem.OnClick) then
      ItemDestino.OnClick := ItemOrigem.OnClick;
  end;

  procedure MenuItemCopy( ItemOrigem, ItemDestino: TMenuItem);
  var
    i: Integer;
    Item: TMenuItem;
  begin

    for i := 0 to ItemOrigem.Count - 1 do begin

      sNome    := ItemOrigem.Items[i].Name+Sufixo;
      iTag     := ItemOrigem.Items[i].Tag;

      if (iTag = 0) then begin

        Item := TMenuItem.Create( ItemDestino);

        Item.Name    := sNome;     // Name
        CopyItemMenu( ItemOrigem.Items[i], Item);

        ItemDestino.Add(Item);

        MenuItemCopy( ItemOrigem.Items[i], Item );

      end;

    end;  // for

  end;  { MenuItemToMenu }

begin

  for i := 0 to Origem.Items.Count - 1 do begin

    sNome    := Origem.Items[i].Name+Sufixo;
    iTag     := Origem.Items[i].Tag;

    if (iTag = 0) then begin

      Item := TMenuItem.Create( Destino);

      Item.Name     := sNome;     // Name
      CopyItemMenu( Origem.Items[i], Item);

      Destino.Items.Add(Item);

      MenuItemCopy( Origem.Items[i], Item );

    end;

  end;  // for i := 0

end;

procedure IComMenuToMenu( Origem, Destino: TMenu; Sufixo: String);
var
  i, iAutorizacao: Integer;
  sNome: String;

  procedure MenuItemToMenu( MenuOpcao:TMenuItem);
  var
    i, iAutorizacao: Integer;
    sNome: String;
  begin

    for i := 0 to MenuOpcao.Count - 1 do
    begin

      sNome := MenuOpcao.Items[i].Name+Sufixo;

      if not MenuOpcao.Items[i].Visible then
        iAutorizacao := 2
      else if not MenuOpcao.Items[i].Enabled then
        iAutorizacao := 1
      else
        iAutorizacao := 0;

      ProcuraNameMenu( Destino, sNome, iAutorizacao);
      MenuItemToMenu( MenuOpcao.Items[i]);

    end;  // for

  end;  { MenuItemToMenu }

begin

  for i := 0 to Origem.Items.Count - 1 do begin

    sNome        := Origem.Items[i].Name+Sufixo;
    iAutorizacao := LerAutorizacao( Origem.Items[i]);

    ProcuraNameMenu( Destino, sNome, iAutorizacao);
    MenuItemToMenu( Origem.Items.Items[i]);

  end;

end;

function FirstControl( win: TWinControl):TControl;
begin
  Result := win.Controls[0];
end;

function LastControl( win: TWinControl):TControl;
begin
  Result := win.Controls[win.ControlCount-1];
end;

procedure WinButtonDataSet( Win: TWinControl; DataSet: TDataSet);
var
  i: Integer;
  bEditando: Boolean;
  Button: TSpeedButton;
begin

  bEditando := (DataSet.State in [dsInsert,dsEdit]);

  for i := 0 to (Win.ControlCount - 1) do
    if (Win.Controls[i] is TSpeedButton) then
    begin
      Button := TSpeedButton(Win.Controls[i]);
      if Button.Visible then
      begin
        if Pos( 'n&ovo', LowerCase( Button.Caption)) > 0 then
          Button.Enabled := not bEditando
        else if Pos( '&editar', LowerCase(Button.Caption)) > 0 then
          Button.Enabled := not bEditando
        else if Pos( '&gravar', LowerCase(Button.Caption)) > 0 then
          Button.Enabled := bEditando
        else if Pos( '&cancelar', LowerCase(Button.Caption)) > 0 then
          Button.Enabled := bEditando
        else if Pos( 'e&xcluir', LowerCase(Button.Caption)) > 0 then
          Button.Enabled := not bEditando;
      end;
    end;  // if

end;  // proc WinButtonDataSet

procedure WinControlDataSet( Win: TWinControl; DataSet: TDataSet);
var
  i, tmpEnabled, tmpTag: Integer;
  bEditando: Boolean;
  tmpCor: TColor;
  tmpDataSource: TObject;
  tmpWin: TWinControl;
  pColorPropInfo,
  pEnabledPropInfo, pTagPropInfo,
  pParentColorPropInfo,
  pDataSourcePropInfo: PPropInfo;
begin

  bEditando := (DataSet.State in [dsInsert,dsEdit]);
  tmpCor    := clWindow;

  if not bEditando then begin
    pColorPropInfo := GetPropInfo( Win.ClassInfo, 'Color' );
    if Assigned(pColorPropInfo) then
      tmpCor := GetOrdProp( Win, 'Color')
    else
      tmpCor := $00E0E9EF;
  end;

  for i := 0 to (Win.ComponentCount - 1) do
    if (Win.Components[i] is TWinControl) then begin

      if (UpperCase( Win.Components[i].ClassName) = 'TDBCHECKBOX') then
        Continue;

      tmpEnabled    := 0;
      tmpTag        := 0;
      tmpDataSource := NIL;
      tmpWin        := TWinControl(Win.Components[i]);

      pColorPropInfo       := GetPropInfo( tmpWin.ClassInfo, 'Color' );
      pEnabledPropInfo     := GetPropInfo( tmpWin.ClassInfo, 'Enabled');
      pTagPropInfo         := GetPropInfo( tmpWin.ClassInfo, 'Tag');
      pParentColorPropInfo := GetPropInfo( tmpWin.ClassInfo, 'ParentColor');
      pDataSourcePropInfo  := GetPropInfo( tmpWin.ClassInfo, 'DataSource');

      if Assigned(pTagPropInfo) then
        tmpTag := GetOrdProp( tmpWin, pTagPropInfo);

      if Assigned(pEnabledPropInfo) then
        tmpEnabled := GetOrdProp( tmpWin, pEnabledPropInfo);

      if Assigned(pDataSourcePropInfo) then
        tmpDataSource := GetObjectProp( tmpWin, pDataSourcePropInfo);

      if Assigned(pColorPropInfo) and Assigned(tmpDataSource) and
         Assigned(TDataSource(tmpDataSource).DataSet) and
         (TDataSource(tmpDataSource).DataSet = DataSet) then begin
        if bEditando and (tmpEnabled = 1) and (tmpTag = 0) then
          SetOrdProp( tmpWin, 'Color', tmpCor)
        else if (not bEditando) and Assigned(pParentColorPropInfo) then
          SetOrdProp( tmpWin, 'ParentColor', 1);
      end;

      WinControlDataSet( tmpWin, DataSet);

    end;  // if

end;  // proc WinControlDataSet

function dbSQLSelectFrom( Transacao: TIBTransaction; DataSet: TDataSet;
  TableName: String; Where: String=''):Boolean;
var
  i: Integer;
  FieldName, sSelect: String;
  evNewRecord, evBeforePost, evAfterPost,
  evBeforeInsert, evAfterInsert,
  evBeforeEdit, evAfterEdit: TDataSetNotifyEvent;
  pFlags: TProviderFlags;
  Query: TIBQuery;
begin

  sSelect := '';
  Result  := True;


  with DataSet do begin

    DisableControls;
    Close;

    if not Active then
      if DataSet is TClientDataSet then begin
        if (Fields.Count = 0) and (FieldDefs.Count = 0) then
          sSelect := '*'
        else
          TClientDataSet(DataSet).CreateDataSet;
      end else
        DataSet.Open;

    for i := 0 to (Fields.Count - 1) do begin

      FieldName := Fields[i].FieldName;
      pFlags    := Fields[i].ProviderFlags;

      if not (pfHidden in pFlags) then begin
        if Length(sSelect) > 0 then
          sSelect := sSelect + ', ';
        sSelect := sSelect + FieldName;
      end;  // if then

    end;  // for i := 0 to do

    evNewRecord    := OnNewRecord;
    evBeforePost   := BeforePost;
    evAfterPost    := AfterPost;
    evBeforeInsert := BeforeInsert;
    evAfterInsert  := AfterInsert;
    evBeforeEdit   := BeforeEdit;
    evAfterEdit    := AfterEdit;

    OnNewRecord  := NIL;
    BeforePost   := NIL;
    AfterPost    := NIL;
    BeforeInsert := NIL;
    AfterInsert  := NIL;
    BeforeInsert := NIL;

  end;  // with DataSet

  if not Transacao.InTransaction then
    Transacao.StartTransaction;

  Query := TIBQuery.Create(Application);

  try try

    with Query do begin
      Transaction := Transacao;
      SQL.BeginUpdate;
      SQL.Add( 'SELECT '+sSelect+' FROM '+TableName);
      if (Where <> '') then
        SQL.Add( 'WHERE '+Where);
      SQL.EndUpdate;
      Open;
    end;

    DataSetToData( Query, DataSet);

  except
    on E:Exception do begin
      if Transacao.InTransaction then
        Transacao.Rollback;
      MessageDlg( E.Message + #13#13 + 'Instrução SQL'#13+
                  Query.SQL.Text+#13#13 + 'dbSQLSelectFrom()', mtError, [mbOK], 0);
      Result := False;
    end;
  end;
  finally
    with DataSet do begin
      if Assigned(evNewRecord)    then OnNewRecord  := evNewRecord;
      if Assigned(evBeforePost)   then BeforePost   := evBeforePost;
      if Assigned(evAfterPost)    then AfterPost    := evAfterPost;
      if Assigned(evBeforeInsert) then BeforeInsert := evBeforeInsert;
      if Assigned(evAfterInsert)  then AfterInsert  := evAfterInsert;
      if Assigned(evBeforeEdit)   then BeforeEdit   := evBeforeEdit;
      if Assigned(evAfterEdit)    then AfterEdit    := evAfterEdit;
      EnableControls;
    end;  // with DeltaDS
    if Transacao.InTransaction then
      Transacao.Commit;
    Query.Free;
  end;

end;  // function dbSQLSelectFrom

procedure DataSetToData( Origem, Destino: TDataSet; Manter: Boolean = False);
var
  i: Integer; sCampo: String;
  evNewRecord, evBeforePost, evAfterPost,
  evBeforeInsert, evAfterInsert,
  evBeforeEdit, evAfterEdit: TDataSetNotifyEvent;
begin

  // Se o DataSet Destino nao conter campos
  // Adicionar os campos baseados no DataSet Origem

  with Destino do begin

    if (Fields.Count = 0) and (FieldDefs.Count = 0) then begin
      FieldDefs.BeginUpdate;
      for i := 0 to Origem.Fields.Count - 1 do
        if Origem.Fields[i].DataType = ftBCD then
          FieldDefs.Add( Origem.Fields[i].FieldName, ftFloat, 0)
        else
          FieldDefs.Add( Origem.Fields[i].FieldName,
                         Origem.Fields[i].DataType, Origem.Fields[i].Size);
      FieldDefs.EndUpdate;
    end;

    evNewRecord    := OnNewRecord;
    evBeforePost   := BeforePost;
    evAfterPost    := AfterPost;
    evBeforeInsert := BeforeInsert;
    evAfterInsert  := AfterInsert;
    evBeforeEdit   := BeforeEdit;
    evAfterEdit    := AfterEdit;

    // Se algum evento precisar ser desativado
    // verifique tambem a function dbSQLCacheSelect na unit dbUtil.pas
    OnNewRecord  := NIL;
    BeforePost   := NIL;
    AfterPost    := NIL;
    BeforeInsert := NIL;
    AfterInsert  := NIL;
    BeforeEdit   := NIL;
    AfterEdit    := NIL;

    DisableControls;

    try try

      if not Manter then
        Close;

      if not Active then
        if (Destino is TClientDataSet) then
          TClientDataSet(Destino).CreateDataSet
        else
          Open;

      Origem.First;

      while not Origem.EOF do begin
        Append;
        for i := 0 to (Fields.Count - 1) do begin
          sCampo := Fields[i].FieldName;
          if Assigned(Origem.FindField(sCampo)) then
            Fields[i].Value := Origem.FieldByName(sCampo).Value;
        end; // for
        Post;
        Origem.Next;
      end;  // while not EOF

      First;

    except
      on E:Exception do
        MessageDlg( E.Message + #13 + 'DataSetToData()', mtError, [mbOK], 0);
    end;

    finally
      if Assigned(evNewRecord)    then OnNewRecord  := evNewRecord;
      if Assigned(evBeforePost)   then BeforePost   := evBeforePost;
      if Assigned(evAfterPost)    then AfterPost    := evAfterPost;
      if Assigned(evBeforeInsert) then BeforeInsert := evBeforeInsert;
      if Assigned(evAfterInsert)  then AfterInsert  := evAfterInsert;
      if Assigned(evBeforeEdit)   then BeforeEdit   := evBeforeEdit;
      if Assigned(evAfterEdit)    then AfterEdit    := evAfterEdit;
      EnableControls;
    end;

  end; // with Destino

end;

function dbSQLCacheUpdate( Transacao: TIBTransaction; DeltaDS: TDataSet;
  TableName: String; FieldDS: TFields;
  IniciarTransacao: Boolean = True):Boolean;
var
  i:Integer;
  FieldName, sInsert, sValues, sUpdate, sWhere: String;
  pFlags: TProviderFlags;
  Query: TIBQuery;
begin

  sInsert := '';
  sValues := '';
  sUpdate := '';
  sWhere  := '';
  Result  := True;

{ TProviderFlag = (pfInUpdate, pfInWhere, pfInKey, pfHidden);
  TProviderFlags = set of TProviderFlag; }

  for i := 0 to (FieldDS.Count - 1) do begin

    FieldName := FieldDS[i].FieldName;
    pFlags    := FieldDS[i].ProviderFlags;

    if ( not (pfHidden in pFlags) ) and
       Assigned(DeltaDS.FindField(FieldName)) and
       (DeltaDS.FieldByName(FieldName).FieldKind = fkData) then begin

      if (DeltaDS.State = dsInsert) then begin

        if (Length(sInsert) > 0) then
          sInsert := sInsert + ', ';

        sInsert := sInsert + FieldName;

        if (Length(sValues) > 0) then
          sValues := sValues + ', ';

        sValues := sValues +  ':' + FieldName;

      end else if (DeltaDS.State = dsEdit) then begin

        if (pfInKey in pFlags) then begin

          if Length(sWhere) > 0 then
            sWhere := sWhere + ' and ';

          sWhere := sWhere + '('+FieldName+' = :_'+FieldName+')';

        end else if (pfInUpdate in pFlags) then begin

          if Length(sUpdate) > 0 then
            sUpdate := sUpdate + ', ';

          sUpdate := sUpdate + FieldName + ' = :'+FieldName;

        end;

      end;

    end;  // if

  end;  // for i

  if IniciarTransacao and (not Transacao.InTransaction) then
    Transacao.StartTransaction;

  Query := TIBQuery.Create(NIL);

  try try

    with Query do begin

      Transaction := Transacao;

      SQL.BeginUpdate;
      if (DeltaDS.State = dsInsert) then begin
        SQL.Add( 'INSERT INTO '+TableName);
        SQL.Add( '('+sInsert+')');
        SQL.Add( 'VALUES ('+sValues+')');
      end else if (DeltaDS.State = dsEdit) then begin
        SQL.Add('UPDATE '+TableName);
        SQL.Add('SET '+sUpdate);
        SQL.Add('WHERE '+sWhere);
      end;
      SQL.EndUpdate;

      for i := 0 to (FieldDS.Count - 1) do begin

        FieldName := FieldDS[i].FieldName;

        if Assigned( Params.FindParam(FieldName)) then
          ParamByName(FieldName).Value :=
                                   DeltaDS.FieldByName(FieldName).Value;

        if Assigned( Params.FindParam( '_'+FieldName)) then
          ParamByName( '_'+FieldName).Value :=
                                   DeltaDS.FieldByName(FieldName).Value;

      end;  // for i

      ExecSQL;

    end;  // with Query do

  except
    on E:Exception do begin
      if IniciarTransacao and Transacao.InTransaction then
        Transacao.Rollback;
      MessageDlg( E.Message + #13#13 + 'Instrução SQL: '+
                  Query.SQL.Text + #13#13 + 'dbSQLCacheUpdate()', mtError, [mbOK], 0);
      Result := False;
    end;
  end;

  finally
    if IniciarTransacao and Transacao.InTransaction then
      Transacao.Commit;
    Query.Free;
  end;

end;  // function dbSQLCacheUpdate

function dbSQLDelete( Transacao: TIBTransaction;
  DeltaDS: TDataSet; TableName: String; FieldDS: TFields;
  IniciarTransacao: Boolean = True):Boolean;
var
  i:Integer;
  FieldName, sWhere: String;
  pFlags: TProviderFlags;
  Query: TIBQuery;
begin

  sWhere  := '';
  Result  := True;

  for i := 0 to (FieldDS.Count - 1) do begin

    FieldName := FieldDS[i].FieldName;
    pFlags    := FieldDS[i].ProviderFlags;

    if (pfInKey in pFlags) and
       Assigned(DeltaDS.FindField(FieldName)) and
       (DeltaDS.FieldByName(FieldName).FieldKind = fkData) then begin
      if (Length(sWhere) > 0) then
        sWhere := sWhere + ' and ';
      sWhere := sWhere + '('+FieldName+' = :'+FieldName+')';
    end;  // if

  end;  // for i

  if IniciarTransacao and (not Transacao.InTransaction) then
    Transacao.StartTransaction;

  Query := TIBQuery.Create(NIL);

  try try

    with Query do begin

      Transaction := Transacao;

      SQL.BeginUpdate; SQL.Clear;
      SQL.Add( 'DELETE FROM '+TableName);
      SQL.Add( 'WHERE '+sWhere);
      SQL.EndUpdate;

      for i := 0 to (FieldDS.Count - 1) do begin
        FieldName := FieldDS[i].FieldName;
        if Assigned( Params.FindParam( FieldName)) then
          ParamByName(FieldName).Value := DeltaDS.FieldByName(FieldName).Value;
      end;  // for i

      ExecSQL;

    end;  // with Query do

  except

    on E:Exception do
    begin

      if IniciarTransacao and Transacao.InTransaction then
        Transacao.Rollback;

      MessageDlg( E.Message+#13#13+
                  '* Instrução SQL *'#13+Query.SQL.Text+#13#13+
                  'Função: dbSQLDelete()', mtError, [mbOK], 0);

      Result := False;

    end;

  end;

  finally
    if IniciarTransacao and Transacao.InTransaction then
      Transacao.Commit;
    Query.Free;
  end;

end;  // function dbSQLDelete

end.
