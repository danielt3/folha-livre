unit FrmRelFunc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, StdCtrls, wwdblook, ExtCtrls, DBCtrls, kbmMemTable;

type
  TfrmFolha2 = class(TForm)
    qryLotacao: TADOQuery;
    qryFolha: TADOQuery;
    mtConfig: TKBMMEMTABLE;
    mtConfigLOTACAO: TStringField;
    mtConfigORDEM: TStringField;
    dtsConfig: TDataSource;
    pnlControle: TPanel;
    btnImprimir: TButton;
    btnCancelar: TButton;
    btnVisualizar: TButton;
    pnlConfig: TPanel;
    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacaoCodigo: TwwDBLookupCombo;
    dbLotacaoNome: TwwDBLookupCombo;
    gpOrdem: TDBRadioGroup;
    qryCargo: TADOQuery;
    gpCargo: TGroupBox;
    dbCargoX: TCheckBox;
    dbCargoCodigo: TwwDBLookupCombo;
    dbCargoNome: TwwDBLookupCombo;
    mtConfigCARGO: TStringField;
    qryTipo: TADOQuery;
    mtConfigTIPO: TStringField;
    qryRecurso: TADOQuery;
    mtConfigRECURSO: TIntegerField;
    gpRecurso: TGroupBox;
    dbRecursoX: TCheckBox;
    dbRecurso: TwwDBLookupCombo;
    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipo: TwwDBLookupCombo;
    dbSalario: TCheckBox;
    dbDemitido: TCheckBox;
    dbAtivo: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure dbEmpresaCodigoEnter(Sender: TObject);
    procedure dbEmpresaNomeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbLotacaoXClick(Sender: TObject);
    procedure mtConfigNewRecord(DataSet: TDataSet);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure dbCargoXClick(Sender: TObject);
    procedure dbTipoXClick(Sender: TObject);
    procedure dbRecursoXClick(Sender: TObject);
  private
    { Private declarations }
    CodigoEmpresa: String;
  public
    { Public declarations }
  end;

procedure CriaRelFunc( Conexao: TADOConnection;
  Empresa: String);stdcall;

implementation

uses FrmRelFunc2;

{$R *.DFM}

procedure CriaRelFunc( Conexao: TADOConnection;
  Empresa: String);
var
  i: Integer;
  frm: TfrmFolha2;
begin

  frm := TfrmFolha2.Create(Application);

  try
    with frm do begin

      CodigoEmpresa := Empresa;

      for i := 0 to  ComponentCount-1 do
        if (Components[i] is TADOQuery) then begin
          TADOQuery(Components[i]).Connection := Conexao;
          if TADOQuery(Components[i]).Parameters.FindParam('EMPRESA') <> NIL then
            TADOQuery(Components[i]).Parameters.ParamByName('EMPRESA').Value := Empresa;
          TADOQuery(Components[i]).Open;
        end;

      if not mtConfig.Active then
        mtConfig.Open;

      mtConfig.Append;
      mtConfig.Post;

      ShowModal;

     end;
  finally
    frm.Free;
  end;

end;

procedure TfrmFolha2.FormCreate(Sender: TObject);
begin

  Ctl3D  := False;
  Color  := $00E0E9EF;

  dbLotacaoX.Checked := True;
  dbLotacaoX.OnClick( dbLotacaoX);

  dbTipoX.Checked := True;
  dbTipoX.OnClick( dbTipoX);

  dbRecursoX.Checked := True;
  dbRecursoX.OnClick( dbRecursoX);

  dbCargoX.Checked := True;
  dbCargoX.OnClick( dbCargoX);

end;

procedure TfrmFolha2.dbEmpresaCodigoEnter(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).Grid.Color := clInfoBk;
  TwwDBLookupCombo(Sender).ShowButton := True;
  TwwDBLookupCombo(Sender).DropDown;
end;

procedure TfrmFolha2.dbEmpresaNomeExit(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).ShowButton := False;
end;

procedure TfrmFolha2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Screen.ActiveControl <> NIL) and (Key = VK_RETURN) then begin
    Key := 0;
    Perform( WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmFolha2.dbLotacaoXClick(Sender: TObject);
begin

  if (Sender as TCheckBox).Checked then begin
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

procedure TfrmFolha2.mtConfigNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ORDEM').AsString := 'N';
end;

procedure TfrmFolha2.btnCancelarClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmFolha2.btnImprimirClick(Sender: TObject);
var
  iRecurso: Integer;
  sLotacao, sTipo, sCargo, sOrdem: String;
begin

  if mtConfig.State in [dsInsert,dsEdit] then
    mtConfig.Post;

  with mtConfig do begin

    if dbLotacaoX.Checked then sLotacao := ''
                          else sLotacao := FieldByName('LOTACAO').AsString;

    if dbTipoX.Checked then sTipo := ''
                       else sTipo := FieldByName('TIPO').AsString;

    if dbRecursoX.Checked then iRecurso := -1
                          else iRecurso := FieldByName('RECURSO').AsInteger;

    if dbCargoX.Checked then sCargo := ''
                        else sCargo := FieldByName('CARGO').AsString;

    sOrdem := FieldByName('ORDEM').AsString;

  end;  // with mtConfig do

  ImprimeFuncionario( qryFolha.Connection, CodigoEmpresa, iRecurso,
                       sLotacao, sTipo, sCargo, sOrdem, dbSalario.Checked,
                       dbDemitido.Checked, dbAtivo.Checked, (Sender = btnImprimir) );

end;

procedure TfrmFolha2.dbCargoXClick(Sender: TObject);
begin

  if (Sender as TCheckBox).Checked then  begin
    dbCargoCodigo.Enabled     := False;
    dbCargoNome.Enabled       := False;
    dbCargoCodigo.ParentColor := True;
    dbCargoNome.ParentColor   := True;
  end else begin
    dbCargoCodigo.Enabled := True;
    dbCargoNome.Enabled   := True;
    dbCargoCodigo.Color   := clWindow;
    dbCargoNome.Color     := clWindow;
  end;

end;

procedure TfrmFolha2.dbTipoXClick(Sender: TObject);
begin

  if (Sender as TCheckBox).Checked then begin
    dbTipo.Enabled     := False;
    dbTipo.ParentColor := True;
  end else begin
    dbTipo.Enabled  := True;
    dbTipo.Color    := clWindow;
  end;

end;

procedure TfrmFolha2.dbRecursoXClick(Sender: TObject);
begin

  if (Sender as TCheckBox).Checked then begin
    dbRecurso.Enabled     := False;
    dbRecurso.ParentColor := True;
  end else begin
    dbRecurso.Enabled  := True;
    dbRecurso.Color    := clWindow;
  end;

end;

end.
