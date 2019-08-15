unit CalculoFerias;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, RXDBCtrl, ExtCtrls, Mask,
  ToolEdit, CurrEdit, RxLookup, Db, wwdblook, ADODB, RXCtrls, kbmMemTable;

type
  TfrmProgFerias = class(TForm)
    PnlTitulo: TPanel;
    pnlRubrica: TPanel;
    dbgFerias: TDBGrid;
    dbFaltas: TDBEdit;
    lblValor: TLabel;
    pnlFuncionario: TPanel;
    memConfig: TkbmMemTable;
    memConfigco_funcionario: TIntegerField;
    dtsConfig: TDataSource;
    qryFuncionario: TADOQuery;
    Label3: TLabel;
    dbFuncionarioCodigo: TwwDBLookupCombo;
    dbFuncionarioNome: TwwDBLookupCombo;
    PnlControle: TPanel;
    btnNovo: TRxSpeedButton;
    btnEditar: TRxSpeedButton;
    btnGravar: TRxSpeedButton;
    btnCancelar: TRxSpeedButton;
    btnExcluir: TRxSpeedButton;
    dbAfastamento: TDBEdit;
    Label4: TLabel;
    qryFerias: TADOQuery;
    dtsFerias: TDataSource;
    dbAquisitivo1: TDBEdit;
    dbAquisitivo2: TDBEdit;
    dbGozo1: TDBEdit;
    dbGozo2: TDBEdit;
    dbPecuniario2: TDBEdit;
    dbPecuniario1: TDBEdit;
    lblAquisitivo1: TLabel;
    lblGozo: TLabel;
    lblPecuniario: TLabel;
    dbAdmissao: TDBEdit;
    Label1: TLabel;
    dtsFuncionario: TDataSource;
    procedure FormCreate(Sender: TObject);
    procedure dbEmpresaCodigoEnter(Sender: TObject);
    procedure dbEmpresaCodigoExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure dbgFeriasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgFeriasGetCellParams(Sender: TObject; Field: TField;
      AFont: TFont; var Background: TColor; Highlight: Boolean);
    procedure pnlFuncionarioEnter(Sender: TObject);
    procedure dtsFeriasStateChange(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure qryFeriasNewRecord(DataSet: TDataSet);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure pnlRubricaEnter(Sender: TObject);
  private
    { Private declarations }
    CodigoEmpresa: String;
    procedure AtivaRubrica( Ativa:Boolean);
    procedure AtivaConfig( Ativa:Boolean);
  public
    { Public declarations }
  end;

procedure CriaProgramaFerias( Conexao: TADOConnection; Empresa: String);stdcall;

implementation

uses Util2;

{$R *.DFM}

procedure CriaProgramaFerias( Conexao: TADOConnection; Empresa: String);
var
  Frm: TFrmProgFerias;
begin

  Frm := TFrmProgFerias.Create(Application);

  try

    with Frm do begin

      CodigoEmpresa := Empresa;

      memConfig.Append;
      memConfig.Fields[0].Value := 0;   // funcionario
      memConfig.Post;

      qryFuncionario.Connection := Conexao;
      qryFuncionario.Parameters[0].Value := Empresa;
      qryFuncionario.Open;

      qryFerias.Connection := Conexao;
      qryFerias.Parameters[0].Value := Empresa;

      AtivaConfig(True);
      AtivaRubrica(False);

      ShowModal;

    end;  // with Frm do

  finally
    Frm.Free;
  end; // try-finally

end;

procedure TfrmProgFerias.FormCreate(Sender: TObject);
begin
  Ctl3D := False;
  Color := $00E0E9EF;
end;

procedure TfrmProgFerias.AtivaRubrica( Ativa:Boolean);
begin

  with memConfig do begin

    if State in [dsEdit,dsInsert] then Post;

    qryFerias.Close;

    if Ativa then begin
      qryFerias.Close;
      qryFerias.Parameters[1].Value := Fields[0].Value;
      qryFerias.Open;
    end;

    pnlRubrica.Enabled  := Ativa;
    dbgFerias.Enabled   := Ativa;
    pnlControle.Enabled := Ativa;

  end;  // with memConfig

end;  // procedure AtivaRubrica;

procedure TfrmProgFerias.AtivaConfig( Ativa:Boolean);
begin
  dbFuncionarioCodigo.TabStop := Ativa;
  dbFuncionarioNome.TabStop   := Ativa;
end;  // procedure AtivaConfig;

procedure TfrmProgFerias.dbEmpresaCodigoEnter(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).Grid.Color := clInfoBk;
  TwwDBLookupCombo(Sender).ShowButton := True;
  TwwDBLookupCombo(Sender).DropDown;
end;

procedure TfrmProgFerias.dbEmpresaCodigoExit(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).ShowButton := False;
end;

procedure TfrmProgFerias.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (ActiveControl = dbFuncionarioNome) and (Key = VK_RETURN) then
    AtivaRubrica(True)
  else if (ActiveControl = dbAfastamento) and (Key = VK_RETURN) then begin
    if btnGravar.Enabled then
      btnGravar.OnClick(btnGravar)
  end;

  FrmKeyDown( Self, Key, Shift);

end;  // procedure FormKeyDown

procedure TfrmProgFerias.btnExcluirClick(Sender: TObject);
begin

  if (qryFerias.RecordCount = 0) or
     not Confirme( 'Excluir a Programação de Férias do funcionário?') then
    Exit;

  qryFerias.Delete;

end;

procedure TfrmProgFerias.btnEditarClick(Sender: TObject);
begin
  qryFerias.Edit;
end;

procedure TfrmProgFerias.dbgFeriasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (Shift = [ssCtrl]) then
    Key := 0;
end;

procedure TfrmProgFerias.dbgFeriasGetCellParams(Sender: TObject;
  Field: TField; AFont: TFont; var Background: TColor; Highlight: Boolean);
begin
  with TDBGrid(Sender) do
    GetCellParams( DataSource.DataSet, Field,
                   AFont, Background, Highlight, Focused);
end;

procedure TfrmProgFerias.pnlFuncionarioEnter(Sender: TObject);
begin
  AtivaConfig(True);
  AtivaRubrica(False);
end;

procedure TfrmProgFerias.dtsFeriasStateChange(Sender: TObject);
begin
  with (Sender as TDataSource) do begin
    dbgFerias.Enabled := not ( DataSet.State in [dsInsert,dsEdit]);
    FrmControlDataSet( Self, DataSet);
  end;
end;

procedure TfrmProgFerias.btnNovoClick(Sender: TObject);
begin
  qryFerias.Append;
end;

procedure TfrmProgFerias.qryFeriasNewRecord(DataSet: TDataSet);
begin
  with DataSet do begin
    FieldByName('co_empresa').AsString      := CodigoEmpresa;
    FieldByName('co_funcionario').AsInteger := memConfig.Fields[0].AsInteger;
  end;  // with DataSet
end;

procedure TfrmProgFerias.btnGravarClick(Sender: TObject);
begin
  qryFerias.Post;
end;

procedure TfrmProgFerias.btnCancelarClick(Sender: TObject);
begin
  qryFerias.Cancel;
end;

procedure TfrmProgFerias.pnlRubricaEnter(Sender: TObject);
begin
  AtivaConfig(False);
end;

end.


