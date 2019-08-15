{
Projeto FolhaLivre - Folha de Pagamento Livre
fbase - Formulario da Interface Basica do FolhaLivre

Copyright (c) 2001-2002, Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit fbase;

{$I flivre.inc}

interface

uses
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ComCtrls, StdCtrls,
  ToolWin, ExtCtrls, DBCtrls, Mask, Buttons,
  {$ENDIF}
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QComCtrls, QStdCtrls,
  QExtCtrls, QDBCtrls, QMask, QButtons,
  {$ENDIF}
  {$IFDEF IBX}IBDatabase,{$ENDIF}
  {$IFDEF DBX}SqlExpr,{$ENDIF}
  {$IFDEF RX_LIB}RXDBCtrl, RXCtrls, ToolEdit,{$ENDIF}
  {$IFDEF VOLGAPAK}VolDBEdit,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, DB, DBClient, Math;

type
  TFrmBase = class(TForm)
    PnlEscuro: TPanel;
    PnlClaro: TPanel;
    PnlControle: TPanel;
    PnlTitulo: TPanel;
    RxTitulo: TLabel;
    PnlFechar: TPanel;
    RxFechar: TSpeedButton;
    btnExcluir: TSpeedButton;
    btnEditar: TSpeedButton;
    btnGravar: TSpeedButton;
    btnCancelar: TSpeedButton;
    btnNovo: TSpeedButton;
    btnImprimir: TSpeedButton;
    dtsRegistro: TDataSource;
    pnlPesquisa: TPanel;
    lblPesquisa: TLabel;
    PesquisaValor: TEdit;
    PesquisaTexto: TLabel;
    PesquisaEm: TLabel;
    mtRegistro: TClientDataSet;
    lblSeparador: TLabel;
    PesquisaTipo: TDBLookupComboBox;
    lblPrograma: TPanel;
    procedure RxFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtsRegistroStateChange(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure pnlPesquisaEnter(Sender: TObject);
    procedure PesquisaTipoEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PesquisaTipoKeyPress(Sender: TObject; var Key: Char);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure SetTabela( Tabela: String);
  protected
    pvLastControl: TWinControl;
    pvDataSetList: array of TDataSet;
    pvDataSetName: array of String;
    pvEmpresa, pvLoja, pvGE, pvFolha: Integer;
    FTabela: String;
    pvNomeForm: String;
    pvPerguntar: Boolean;
    pvSELECT: String;
    pvSELECT_NULL: String;
    pvSELECT_COUNT: String;
    pvWhere: String;  // allan_kardek - 14/03/2006
    pvPesquisado: Boolean;
    pvAutoNumeracao: Boolean;
    pvDeleted: Boolean;
    pvImpresso: Boolean;
    pvPesquisa: Boolean;
    pvPnlEscuro: Boolean;
    Rate: Double;
    pvLastKey: Word;  // Ultima Tecla Pressionada
    procedure AddTable( DataSet: TDataSet; DataSetName: String);
    {$IFDEF IBX}
    function pvTransacao: TIBTransaction;
    {$ENDIF}
    {$IFDEF DBX}
    function pvTransacao: TSQLConnection;
    {$ENDIF}
    procedure FrmEmiteSom;
    function pvCompetencia: TDateTime;
    function pvDataSet: TDataSet; virtual;
    procedure FrmBtnControlePadrao( Operacao: String);virtual;
    procedure Pesquisar; virtual;
    procedure Iniciar; virtual;
    function GetID: Variant; virtual;
    function GetIDInteger: Integer; virtual;
    function GetIDString: String; virtual;
    function TableArraySelect: Boolean; virtual;
    function TableBeforePost: Boolean; virtual;
    procedure GetData; virtual;
  public
    { Public declarations }
    function UseCompetencia: Boolean;
    property pvTabela: String read FTabela write SetTabela;
  end;

implementation

uses ftext, fdb, fdeposito, fsystem, fsuporte, futil, fcolor;

{$R *.dfm}

procedure TFrmBase.RxFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmBase.FormCreate(Sender: TObject);

  procedure Teste( Componente: TComponent);
  var
    i: Integer;
  begin

    if (Componente is TDBLookupComboBox) then
      with TDBLookupComboBox(Componente) do
      begin
        if not Assigned(OnDropDown) then
          OnDropDown := PesquisaTipo.OnDropDown;
        if not Assigned(OnEnter) then
          OnEnter := PesquisaTipo.OnEnter;
        if not Assigned(OnExit) then
          OnExit := PesquisaTipo.OnExit;
      end;

    {$IFDEF VOLGAPAK}
    if (Componente is TVolgaDBEdit) then
      with TVolgaDBEdit(Componente) do
      begin
        if not Assigned(OnDropDown) then
          OnDropDown := PesquisaTipo.OnDropDown;
        if not Assigned(OnEnter) then
          OnEnter := PesquisaTipo.OnEnter;
        if not Assigned(OnExit) then
          OnExit := PesquisaTipo.OnExit;
      end;
    {$ENDIF}

    if (Componente is TDBComboBox) then
      with TDBComboBox(Componente) do
      begin
        if not Assigned(OnDropDown) then
          OnDropDown := PesquisaTipo.OnDropDown;
        if not Assigned(OnEnter) then
          OnEnter := PesquisaTipo.OnEnter;
        if not Assigned(OnExit) then
          OnExit := PesquisaTipo.OnExit;
      end;

    for i := 0 to (Componente.ComponentCount - 1) do
      Teste( Componente.Components[i]);

  end;

begin

  kInitForm(Self);
  
  {$IFDEF CLX}
  btnNovo.Flat     := False;
  btnEditar.Flat   := False;
  btnGravar.Flat   := False;
  btnCancelar.Flat := False;
  btnExcluir.Flat  := False;
  btnImprimir.Flat := False;
  {$ENDIF}

  {$IFDEF VCL}
  Ctl3d := False;
  {$ENDIF}

  Color := kGetColor();
  lblPrograma.Color := kGetColorProgram();
  PnlTitulo.Color := kGetColorTitle();

  Rate := Canvas.TextWidth('W') / 11;

  // Este codigo foi colocado no evento Create do Form
  // porque o codigo nao depende de nenhum componente ou configuracao
  // posteriores a criacao do Form

  pvEmpresa   := kEmpresaAtiva();
  pvLoja      := StrToInt( kGetDeposito('LOJA_ID', '1'));
  pvGE        := StrToInt( kGetDeposito('EMPRESA_GE', '1'));
  pvFolha     := kFolhaAtiva();

  pvNomeForm      := UpperCase( Copy( Self.Name, 4, Length(Self.Name)));
  pvAutoNumeracao := (kGetSystem( pvNomeForm+'_AUTONUMERACAO', '1') = '1');

  pvPerguntar := False;

  SetLength(pvDataSetName, 1);
  SetLength(pvDataSetList, 1);

  pvDataSetName[0] := kRetira( UpperCase(Self.Name), 'FRM');
  pvDataSetList[0] := mtRegistro;

  PesquisaTipo.Height := PesquisaValor.Height;

  Teste(Self);

end;

procedure TFrmBase.dtsRegistroStateChange(Sender: TObject);
begin
  inherited;
  // Atualizar os botoes de edicao e os controles de editacao do frm
  if Assigned( TDataSource(Sender).DataSet) then
    kControlDataSet( Self, TDataSource(Sender).DataSet);
end;

procedure TFrmBase.btnNovoClick(Sender: TObject);
begin
  FrmBtnControlePadrao( TSpeedButton(Sender).Caption);
end;

procedure TFrmBase.pnlPesquisaEnter(Sender: TObject);
begin
  PesquisaValor.TabStop  := not PesquisaValor.TabStop;
  PesquisaTipo.TabStop   := PesquisaValor.TabStop;
  PesquisaValor.Color    :=  IfThen( PesquisaValor.TabStop, clInfoBk, clWindow);
  PesquisaTipo.Color     := PesquisaValor.Color;
end;

procedure TFrmBase.PesquisaTipoEnter(Sender: TObject);
begin

{  if (Sender is TDBComboBox) then
  begin
    with TDBComboBox(Sender) do
      if Assigned(DataSource) and Assigned(DataSource.DataSet) then
      begin
         if (DataSource.DataSet.State in [dsInsert,dsEdit]) then

      end else
        DropDown;
  end;
}
  {$IFDEF VOLGAPAK}
  if (Sender is TVolgaDBEdit) then
  begin
    with TVolgaDBEdit(Sender) do
      if Assigned(DataSource) and Assigned(DataSource.DataSet) then
      begin
         if (DataSource.DataSet.State in [dsInsert,dsEdit]) then
          DropDown;
      end else
        DropDown;
  end;
  {$ENDIF}

  if (Sender is TDBLookupComboBox) then
  begin
    with TDBLookupComboBox(Sender) do
      if Assigned(DataSource) and Assigned(DataSource.DataSet) then
      begin
        if (DataSource.DataSet.State in [dsInsert,dsEdit]) then
          DropDown;
      end else
        DropDown;
  end;

end;

function TFrmBase.pvCompetencia: TDateTime;
var sData: String;
begin
  sData := kGetDeposito('COMPETENCIA_DATA');
  if (sData = '') then
    Result := Date()
  else
    Result := StrToDate(sData);
end;

procedure TFrmBase.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  pvLastKey := Key;
  {$IFDEF VCL}
  if (Key = VK_F11) and (Shift = []) and pvPnlEscuro then
    PnlEscuro.Visible := not PnlEscuro.Visible
  else
  {$ENDIF}
  if not kKeyDown( Self, Key, Shift) then  // Enter não processado
    pvLastKey := 0;
end;

procedure TFrmBase.FrmEmiteSom;
var i:Integer;
begin
  for i := 0 to 2 do Beep;
end;

function TFrmBase.pvDataSet: TDataSet;
begin
  Result := NIL;
  if Assigned(dtsRegistro.DataSet) then
    Result := dtsRegistro.DataSet;
end;

procedure TFrmBase.Iniciar;
begin

  kEnabledControl(Self);

  if Assigned(dtsRegistro) and Assigned(dtsRegistro.OnStateChange) then
    dtsRegistro.OnStateChange(dtsRegistro);  // allan_kardek - 28/04/2004

  pvPnlEscuro := PnlEscuro.Visible;
  pvPesquisa  := pnlPesquisa.Visible;

  Pesquisar();

end;

procedure TFrmBase.Pesquisar;
begin
  if (pvTabela <> '') then
    if not kSQLSelectFrom( pvDataSet, pvTabela, pvEmpresa, pvWhere) then
      raise Exception.Create(kGetErrorLastSQL);
end;

procedure TFrmBase.FrmBtnControlePadrao(Operacao: String);
begin

  if (pvDataSet = NIL) then
    Exit;

  Operacao := UpperCase(Operacao[ Pos('&',Operacao)+1]);

  if pnlControle.Visible and pnlControle.Enabled then
  begin
    if (Operacao = 'O') then      pvDataSet.Append
    else if (Operacao = 'E') then pvDataSet.Edit
    else if (Operacao = 'G') then pvDataSet.Post
    else if (Operacao = 'C') then pvDataSet.Cancel
    else if (Operacao = 'X') then pvDataSet.Delete;
  end;

end;  // FrmBtnControlePadrao

function TFrmBase.UseCompetencia: Boolean;
begin
  Result := (kGetSystem('SISTEMA_COMPETENCIA', '1') = '1');
end;

{$IFDEF ADO}
function TFrmBase.pvTransacao: TADOConnection;
begin
  Result := kGetConnection;
end;
{$ENDIF}
{$IFDEF DBX}
function TFrmBase.pvTransacao: TSQLConnection;
begin
  Result := kGetConnection;
end;
{$ENDIF}
{$IFDEF IBX}
function TFrmBase.pvTransacao: TIBTransaction;
begin
  Result := kGetConnection.DefaultTransaction;
end;
{$ENDIF}

procedure TFrmBase.PesquisaTipoKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) then
    Pesquisar()
  else
    Key := #0;
end;

procedure TFrmBase.mtRegistroNewRecord(DataSet: TDataSet);
begin
  kDataSetDefault( DataSet, pvTabela);
  if Assigned(DataSet.FindField('IDEMPRESA')) then
    DataSet.FieldByName('IDEMPRESA').AsInteger := pvEmpresa;
  if Assigned(DataSet.FindField('IDLOJA')) then
    DataSet.FieldByName('IDLOJA').AsInteger := pvLoja;
  if Assigned(DataSet.FindField('IDGE')) then
    DataSet.FieldByName('IDGE').AsInteger := pvGE;
  DataSet.Tag := 1;
end;

function TFrmBase.TableBeforePost: Boolean;  // virtual
begin
  Result := True;
end;

function TFrmBase.TableArraySelect: Boolean;  // virtual
begin
  Result := kSQLSelectArray( pvDataSet, pvDataSetName, pvDataSetList);
end;

procedure TFrmBase.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  {$IFDEF VCL}
  while (ActiveControl = NIL) do
    Perform( WM_NEXTDLGCTL, 0, 0);
  {$ENDIF}
end;

procedure TFrmBase.mtRegistroBeforePost(DataSet: TDataSet);
var
  bSucesso: Boolean;
begin
  if (DataSet.State = dsInsert) then
    bSucesso := kSQLInsertArray( DataSet, pvDataSetName, pvDataSetList)
  else
    bSucesso := kSQLUpdateArray( DataSet, pvDataSetName, pvDataSetList);
  if not bSucesso then
    SysUtils.Abort;
end;

procedure TFrmBase.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  pvDeleted := kSQLDeleteArray( DataSet, pvDataSetName, pvDataSetList);
  if not pvDeleted then
    SysUtils.Abort;
end;

function TFrmBase.GetID: Variant;
begin
  Result := pvDataSet.Fields[0].Value;
end;

function TFrmBase.GetIDInteger: Integer;
begin
  Result := pvDataSet.Fields[0].AsInteger;
end;

function TFrmBase.GetIDString: String;
begin
  Result := pvDataSet.Fields[0].AsString;
end;

procedure TFrmBase.SetTabela(Tabela: String);
begin
  FTabela := Tabela;
  pvDataSetName[0] := Tabela;
end;

procedure TFrmBase.AddTable(DataSet: TDataSet; DataSetName: String);
var i: Integer;
begin
  i := Length(pvDataSetList);
  SetLength( pvDataSetList, i+1);
  SetLength( pvDataSetName, i+1);
  pvDataSetList[i] := DataSet;
  pvDataSetName[i] := DataSetName;
end;

procedure TFrmBase.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  DataSet.Tag := 0;
end;

procedure TFrmBase.GetData;
begin
  raise Exception.Create('método GetData não definido');
end;

procedure TFrmBase.mtRegistroAfterPost(DataSet: TDataSet);
begin
  if Assigned(DataSet.AfterCancel) then
    DataSet.AfterCancel(DataSet);
end;

procedure TFrmBase.FormKeyPress(Sender: TObject; var Key: Char);
begin

  if (Key in ['+','-','=']) and (ActiveControl is TDBEdit) then
  begin
    with TDBEdit(ActiveControl) do
      if Assigned(DataSource.DataSet) and
         (Field.DataSet.State in [dsInsert,dsEdit]) and
         (Field.DataType in [ftDate,ftDateTime]) then
      begin
         if Field.IsNull then Field.AsDateTime := Date;
         if (Key = '=')  then Field.AsDateTime := Date;
         if (Key = '+')  then Field.AsDateTime := Field.AsDateTime + 1;
         if (Key = '-')  then Field.AsDateTime := Field.AsDateTime - 1;
         Key := #0;
      end;
  end;

  inherited;

end;

end.
