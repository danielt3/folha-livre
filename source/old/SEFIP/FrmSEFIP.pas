unit FrmSEFIP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Mask, ExtCtrls, CurrEdit, ToolEdit, RxLookup, Db,
  ADODB, wwdblook, wwdbedit, Wwdotdot, Wwdbcomb, ComCtrls, Gauges;

type
  TFrmFGTS = class(TForm)
    qryLotacao: TADOQuery;
    qryTipo: TADOQuery;
    pnlFGTS: TPanel;
    Label3: TLabel;
    Label1: TLabel;
    dbIndicador_FGTS: TwwDBComboBox;
    StaticText1: TStaticText;
    pnlPS: TPanel;
    StaticText2: TStaticText;
    Label4: TLabel;
    dbIndicador_PS: TwwDBComboBox;
    dbDataPS: TDateEdit;
    Label5: TLabel;
    Label6: TLabel;
    dbIndicePS: TRxCalcEdit;
    pnlFuncionario: TPanel;
    StaticText3: TStaticText;
    pnlSaida: TPanel;
    radArquivo: TRadioButton;
    radGuia: TRadioButton;
    radResumo: TRadioButton;
    Label8: TLabel;
    dbCR: TRxCalcEdit;
    dbMes: TRxCalcEdit;
    dbAno: TRxCalcEdit;
    Gauge1: TGauge;
    Panel1: TPanel;
    Button1: TButton;
    btnFechar: TButton;
    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacaoCodigo: TwwDBLookupCombo;
    dbLotacaoNome: TwwDBLookupCombo;
    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipoCodigo: TwwDBLookupCombo;
    dbTipoNome: TwwDBLookupCombo;
    Label2: TLabel;
    dbDataFGTS: TDateEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure dbTipoXClick(Sender: TObject);
    procedure dbTipoCodigoEnter(Sender: TObject);
    procedure dbTipoCodigoExit(Sender: TObject);
  private
    { Private declarations }
    CodigoEmpresa: String;
  public
    { Public declarations }
  end;

procedure CriaSEFIP( Conexao: TADOConnection; Empresa: String);stdcall;

implementation

uses SEFIP_Processa;

{$R *.DFM}

procedure CriaSEFIP( Conexao: TADOConnection; Empresa: String);
var
  Frm: TFrmFGTS;
begin

  Frm := TFrmFGTS.Create(Application);

  try
    with Frm do begin

      CodigoEmpresa := Empresa;
      
      with qryLotacao do begin
        Connection := Conexao;
        Parameters[0].Value := Empresa;
        Open;
      end;

      qryTipo.Connection  := Conexao;
      qryTipo.Open;

      ShowModal;

    end;  // with Frm
  finally
    Frm.Free;
  end;  // try

end;

procedure TFrmFGTS.FormShow(Sender: TObject);
var
  wAno, wMes, wDia: Word;
begin

  DecodeDate( Date, wAno, wMes, wDia);

  dbMes.AsInteger := wMes;
  dbAno.AsInteger := wAno;

  dbLotacaoX.Checked := True;
  dbLotacaoX.OnClick( dbLotacaoX);

  dbTipoX.Checked := True;
  dbTipoX.OnClick( dbTipoX);

end;

procedure TFrmFGTS.FormCreate(Sender: TObject);
begin

  Ctl3D := False;
  Color := $00E0E9EF;

  dbAno.Height      := 19;
  dbMes.Height      := 19;
  dbCR.Height       := 19;

  dbDataFGTS.Height := 19;
  dbDataPS.Height   := 19;
  dbIndicePS.Height := 19;

end;

procedure TFrmFGTS.btnFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TFrmFGTS.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then begin
    Key := 0;
    Perform( WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TFrmFGTS.dbTipoXClick(Sender: TObject);
begin

  if Sender = dbTipoX then
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

  if Sender = dbLotacaoX then
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

procedure TFrmFGTS.dbTipoCodigoEnter(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).Grid.Color := clInfoBk;
  TwwDBLookupCombo(Sender).ShowButton := True;
  TwwDBLookupCombo(Sender).DropDown;
end;

procedure TFrmFGTS.dbTipoCodigoExit(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).ShowButton := False;
end;

procedure TFrmFGTS.Button1Click(Sender: TObject);
var
  sLotacao, sTipo, sSaida: String;
begin

  sTipo    := '';
  sLotacao := '';
  sSaida   := 'A';  // Arquivo

  if not dbLotacaoX.Checked then
    sLotacao := dbLotacaoCodigo.LookupValue;

  if not dbTipoX.Checked then
    sTipo  := dbTipoCodigo.LookupValue;

  if radGuia.Checked then
    sSaida := 'G'     // Guia
  else if radResumo.Checked then
    sSaida := 'R';    // Resumo - Relatorio

  ProcessaSEFIP( qryLotacao.Connection,
                 dbAno.AsInteger, dbMes.AsInteger, dbCR.AsInteger,
                 dbIndicador_FGTS.ItemIndex, dbIndicador_PS.ItemIndex+1,
                 dbIndicePS.AsInteger,
                 dbDataFGTS.Date, dbDataPS.Date,
                 CodigoEmpresa, sLotacao, sTipo, sSaida, Gauge1);

end;
end.
