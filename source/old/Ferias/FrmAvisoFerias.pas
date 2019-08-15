unit FrmAvisoFerias;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, StdCtrls, wwdblook, ExtCtrls, DBCtrls, kbmMemTable;

type
  TfrmAviso = class(TForm)
    qryLotacao: TADOQuery;
    qryFolha: TADOQuery;
    mtConfig: TKBMMEMTABLE;
    mtConfigFOLHA: TIntegerField;
    mtConfigLOTACAO: TStringField;
    mtConfigORDEM: TStringField;
    dtsConfig: TDataSource;
    pnlControle: TPanel;
    btnImprimir: TButton;
    btnCancelar: TButton;
    btnVisualizar: TButton;
    pnlConfig: TPanel;
    lblFolha: TLabel;
    dbFolhaCodigo: TwwDBLookupCombo;
    dbFolhaNome: TwwDBLookupCombo;
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
    qryFuncionario: TADOQuery;
    gpFuncionario: TGroupBox;
    dbFuncionarioX: TCheckBox;
    dbFuncionarioCodigo: TwwDBLookupCombo;
    dbFuncionarioNome: TwwDBLookupCombo;
    mtConfigFUNCIONARIO: TIntegerField;
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
    procedure FormShow(Sender: TObject);
    procedure dbRecursoXClick(Sender: TObject);
    procedure dbFuncionarioXClick(Sender: TObject);
  private
    { Private declarations }
    CodigoEmpresa: String;
    CodigoFolha: Integer;
  public
    { Public declarations }
  end;

procedure CriaAvisoFerias( Conexao: TADOConnection;
  Empresa: String; Folha:Integer);stdcall;

implementation

uses AvisoPrevioFerias;

{$R *.DFM}

procedure CriaAvisoFerias( Conexao: TADOConnection;
  Empresa: String; Folha:Integer);
var
  i: Integer;
  frm: TfrmAviso;
begin

  frm := TfrmAviso.Create(Application);

  try
    with frm do begin

      CodigoEmpresa := Empresa;
      CodigoFolha   := Folha;

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
      mtConfig.FieldByName('FOLHA').Value   := Folha;
      mtConfig.Post;

      if (Folha > 0) then begin

        lblFolha.Enabled := False;

        dbFolhaCodigo.Enabled := False;
        dbfolhaCodigo.ParentColor := True;

        dbFolhaNome.Enabled := False;
        dbFolhaNome.ParentColor := True;

      end;

      ShowModal;

     end;
  finally
    frm.Free;
  end;

end;

procedure TfrmAviso.FormCreate(Sender: TObject);
begin

  Ctl3D  := False;
  Color  := $00E0E9EF;

  dbFuncionarioX.Checked := True;
  dbFuncionarioX.OnClick(dbFuncionarioX);

  dbLotacaoX.Checked := True;
  dbLotacaoX.OnClick( dbLotacaoX);

  dbTipoX.Checked := True;
  dbTipoX.OnClick( dbTipoX);

  dbRecursoX.Checked := True;
  dbRecursoX.OnClick( dbRecursoX);

  dbCargoX.Checked := True;
  dbCargoX.OnClick( dbCargoX);

end;

procedure TfrmAviso.dbEmpresaCodigoEnter(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).Grid.Color := clInfoBk;
  TwwDBLookupCombo(Sender).ShowButton := True;
  TwwDBLookupCombo(Sender).DropDown;
end;

procedure TfrmAviso.dbEmpresaNomeExit(Sender: TObject);
begin
  TwwDBLookupCombo(Sender).ShowButton := False;
end;

procedure TfrmAviso.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Screen.ActiveControl <> NIL) and (Key = VK_RETURN) then begin
    Key := 0;
    Perform( WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmAviso.dbLotacaoXClick(Sender: TObject);
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

procedure TfrmAviso.mtConfigNewRecord(DataSet: TDataSet);
begin
  DataSet.FieldByName('ORDEM').AsString := 'N';
end;

procedure TfrmAviso.btnCancelarClick(Sender: TObject);
begin
  Close();
end;

procedure TfrmAviso.btnImprimirClick(Sender: TObject);
var
  iFolha, iRecurso, iFuncionario: Integer;
  sLotacao, sTipo, sCargo, sOrdem: String;
begin

  if mtConfig.State in [dsInsert,dsEdit] then
    mtConfig.Post;

  with mtConfig do begin

    iFolha := FieldByName('FOLHA').AsInteger;

    if dbFuncionarioX.Checked
       then iFuncionario := -1
       else iFuncionario := FieldByName('FUNCIONARIO').AsInteger;

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

  ImprimeAvisoFerias( qryFolha.Connection,
                            CodigoEmpresa, iFolha, iRecurso,
                            iFuncionario, sLotacao, sTipo, sCargo,
                            sOrdem, (Sender = btnImprimir) );

end;

procedure TfrmAviso.dbCargoXClick(Sender: TObject);
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

procedure TfrmAviso.dbTipoXClick(Sender: TObject);
begin

  if (Sender as TCheckBox).Checked then begin
    dbTipo.Enabled     := False;
    dbTipo.ParentColor := True;
  end else begin
    dbTipo.Enabled  := True;
    dbTipo.Color    := clWindow;
  end;

end;

procedure TfrmAviso.FormShow(Sender: TObject);
begin
  if dbFolhaCodigo.Enabled then
    dbFolhaCodigo.SetFocus
  else
    dbLotacaoX.SetFocus;
end;

procedure TfrmAviso.dbRecursoXClick(Sender: TObject);
begin

  if (Sender as TCheckBox).Checked then begin
    dbRecurso.Enabled     := False;
    dbRecurso.ParentColor := True;
  end else begin
    dbRecurso.Enabled  := True;
    dbRecurso.Color    := clWindow;
  end;

end;

procedure TfrmAviso.dbFuncionarioXClick(Sender: TObject);
begin

  dbFuncionarioCodigo.Enabled := not (Sender as TCheckBox).Checked;
  dbFuncionarioNome.Enabled   := not (Sender as TCheckBox).Checked;

  if (Sender as TCheckBox).Checked then  begin
    dbFuncionarioCodigo.ParentColor := True;
    dbFuncionarioNome.ParentColor   := True;
  end else begin
    dbFuncionarioCodigo.Color   := clWindow;
    dbFuncionarioNome.Color     := clWindow;
  end;

end;

end.
