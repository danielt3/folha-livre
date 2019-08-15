unit FrmCAGED;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, ExtCtrls, CurrEdit, ToolEdit, RxLookup, Db,
  ADODB, wwdblook, wwdbedit, Wwdotdot, Wwdbcomb, ComCtrls, Gauges;

type
  TFrmCAGED = class(TForm)
    qryLotacao: TADOQuery;
    qryTipo: TADOQuery;
    pnlFGTS: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    dbAtualizacao: TwwDBComboBox;
    StaticText1: TStaticText;
    pnlFuncionario: TPanel;
    StaticText3: TStaticText;
    dbMes: TRxCalcEdit;
    dbAno: TRxCalcEdit;
    Gauge1: TGauge;
    Panel1: TPanel;
    btnOK: TButton;
    btnFechar: TButton;
    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacaoCodigo: TwwDBLookupCombo;
    dbLotacaoNome: TwwDBLookupCombo;
    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipoCodigo: TwwDBLookupCombo;
    dbTipoNome: TwwDBLookupCombo;
    dbPrimeiraDeclaracao: TCheckBox;
    Label2: TLabel;
    dbMeioFisico: TwwDBComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure dbTipoXClick(Sender: TObject);
    procedure dbLotacaoXClick(Sender: TObject);
    procedure dbTipoCodigoEnter(Sender: TObject);
    procedure dbTipoCodigoExit(Sender: TObject);
  private
    { Private declarations }
    CodigoEmpresa: String;
  public
    { Public declarations }
  end;

procedure CriaCAGED( Conexao: TADOConnection; Empresa: String);

implementation

uses CAGED_Processa;

{$R *.DFM}

procedure CriaCAGED( Conexao: TADOConnection; Empresa: String);
var
  Frm: TFrmCAGED;
begin

  Frm := TFrmCAGED.Create(Application);

  try
    with Frm do begin

      CodigoEmpresa := Empresa;

      qryLotacao.Connection := Conexao;
      qryLotacao.Parameters[0].Value := Empresa;
      qryLotacao.Open;
      
      qryTipo.Connection    := Conexao;
      qryTipo.Open;

      ShowModal;

    end;
  finally
    Frm.Free;
  end;  // try

end;

procedure TFrmCAGED.FormShow(Sender: TObject);
var
  wAno, wMes, wDia: Word;
begin

  DecodeDate( Date, wAno, wMes, wDia);

  dbMes.AsInteger := wMes;
  dbAno.AsInteger := wAno;

  dbLotacaoCodigo.LookupTable.Open;
  dbTipoCodigo.LookupTable.Open;

  dbLotacaoX.Checked := True;
  dbLotacaoX.OnClick( dbLotacaoX);

  dbTipoX.Checked := True;
  dbTipoX.OnClick( dbTipoX);

end;

procedure TFrmCAGED.FormCreate(Sender: TObject);
begin

  Ctl3D := False;
  Color := $00E0E9EF;

  dbAno.Height      := 19;
  dbMes.Height      := 19;

end;

procedure TFrmCAGED.btnFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TFrmCAGED.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    Key := 0;
    Perform( WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmCAGED.btnOKClick(Sender: TObject);
var
  sLotacao, sTipo: String;
begin

  sTipo    := '';
  sLotacao := '';

  if not dbLotacaoX.Checked then
    sLotacao := dbLotacaoCodigo.LookupValue;

  if not dbTipoX.Checked then
    sTipo := dbTipoCodigo.LookupValue;

  ProcessaCAGED( qryLotacao.Connection,
                 dbAno.AsInteger, dbMes.AsInteger,
                 dbPrimeiraDeclaracao.Checked,
                 dbAtualizacao.Value, dbMeioFisico.Value,
                 CodigoEmpresa, sLotacao, sTipo, Gauge1);

end;

procedure TFrmCAGED.dbTipoXClick(Sender: TObject);
begin

  if TCheckBox(Sender).Checked then  begin
    dbTipoCodigo.Enabled     := False;
    dbTipoNome.Enabled       := False;
    dbTipoCodigo.ParentColor := True;
    dbTipoNome.ParentColor   := True;
  end else begin
    dbTipoCodigo.Enabled := True;
    dbTipoNome.Enabled   := True;
    dbTipoCodigo.Color   := clWindow;
    dbTipoNome.Color     := clWindow;
  end;

end;

procedure TFrmCAGED.dbLotacaoXClick(Sender: TObject);
begin

  if TCheckBox(Sender).Checked then  begin
    dbLotacaoCodigo.Enabled     := False;
    dbLotacaoNome.Enabled       := False;
    dbLotacaoCodigo.ParentColor := True;
    dbLotacaoNome.ParentColor   := True;
  end else begin
    dbLotacaoCodigo.Enabled := True;
    dbLotacaoNome.Enabled   := True;
    dbLotacaoCodigo.Color   := clWindow;
    dbLotacaoNome.Color     := clWindow;
  end;

end;

procedure TFrmCAGED.dbTipoCodigoEnter(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).Grid.Color := clInfoBk;
  TwwDBLookupCombo(Sender).ShowButton := True;
  TwwDBLookupCombo(Sender).DropDown;
end;

procedure TFrmCAGED.dbTipoCodigoExit(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).ShowButton := False;
end;

end.
