unit FrmListaEvento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Db, ADODB, StdCtrls, wwdblook, ExtCtrls, DBCtrls, kbmMemTable, RXCtrls,
  CheckLst, Grids, Wwdbgrid, Wwdbigrd;

type
  TfrmEntrada = class(TForm)
    qryLotacao: TADOQuery;
    dtsConfig: TDataSource;
    qryTipo: TADOQuery;
    pnlControle: TPanel;
    btnImprimir: TButton;
    btnCancelar: TButton;
    btnVisualizar: TButton;
    pnlConfig: TPanel;
    gpLotacao: TGroupBox;
    dbLotacaoX: TCheckBox;
    dbLotacao: TwwDBLookupCombo;
    dbLotacao2: TwwDBLookupCombo;
    gpTipo: TGroupBox;
    dbTipoX: TCheckBox;
    dbTipo: TwwDBLookupCombo;
    gpOrdem: TDBRadioGroup;
    mtConfig: TkbmMemTable;
    mtConfigFOLHA: TIntegerField;
    mtConfigLOTACAO: TStringField;
    mtConfigTIPO: TStringField;
    mtConfigORDEM: TStringField;
    mtConfigSAIDA: TStringField;
    qryRecurso: TADOQuery;
    mtConfigRECURSO: TIntegerField;
    gpRecurso: TGroupBox;
    dbRecursoX: TCheckBox;
    dbRecurso: TwwDBLookupCombo;
    gpDados: TGroupBox;
    BoxDados: TCheckListBox;
    gpFolha2: TGroupBox;
    gpFolha: TGroupBox;
    dbFolhaX: TCheckBox;
    dbFolha: TwwDBLookupCombo;
    dbFolha2: TwwDBLookupCombo;
    dbFolha2X: TCheckBox;
    gpLotacao2: TGroupBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    gpFuncionario2: TGroupBox;
    dbTotalFunc: TCheckBox;
    dbResumoFunc: TCheckBox;
    gpEvento: TGroupBox;
    dbEventoX: TCheckBox;
    dbEvento: TwwDBLookupCombo;
    dbEvento2: TwwDBLookupCombo;
    dbEvento2x: TCheckBox;
    mtFolha: TkbmMemTable;
    mtFolhaco_folha: TIntegerField;
    mtFolhads_observacao: TStringField;
    mtFolhaX: TBooleanField;
    dbgFolha: TwwDBGrid;
    dtsFolha: TDataSource;
    gpEvento2: TGroupBox;
    dbgEvento: TwwDBGrid;
    mtEvento: TkbmMemTable;
    dtsEvento: TDataSource;
    mtEventoX: TBooleanField;
    mtEventoco_rubrica: TStringField;
    mtConfigEVENTO: TStringField;
    mtEventods_rubrica: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure dbEmpresaCodigoEnter(Sender: TObject);
    procedure dbEmpresaNomeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbLotacaoXClick(Sender: TObject);
    procedure mtConfigNewRecord(DataSet: TDataSet);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
  private
    { Private declarations }
    sEmpresa: String;
    procedure Configura();
  public
    { Public declarations }
  end;

procedure CriaListaEvento( Conexao: TADOConnection;
  Empresa: String);stdcall;

implementation

uses RelListaEvento, Util2;

{$R *.DFM}

procedure CriaListaEvento( Conexao: TADOConnection;
  Empresa: String);
var
  i: Integer;
  frm: TfrmEntrada;
begin

  frm := TfrmEntrada.Create(Application);

  try
    with frm do begin

      for i := 0 to  ComponentCount-1 do
        if (Components[i] is TADOQuery) then begin
          TADOQuery(Components[i]).Connection := Conexao;
          if TADOQuery(Components[i]).Parameters.FindParam('EMPRESA') <> NIL then
            TADOQuery(Components[i]).Parameters.ParamByName('EMPRESA').Value := Empresa;
          TADOQuery(Components[i]).Open;
        end else if (Components[i] is TADOTable) then begin
          TADOTable(Components[i]).Connection := Conexao;
          TADOTable(Components[i]).Open;
        end;

        sEmpresa := Empresa;

        if not mtConfig.Active then
          mtConfig.Open;

        mtConfig.Append;
        mtConfig.FieldByName('FOLHA').Value := 0;
        mtConfig.Post;

        Configura();

        ShowModal;

      end;

  finally
    Frm.Free;
  end;

end;

procedure TfrmEntrada.Configura;
var
  Query: TADOQuery;
begin

  Query := TADOQuery.Create(Application);

  try

    with Query do begin
      Connection := qryTipo.Connection;
      SQL.Add('SELECT co_folha, ds_observacao FROM FOLHA_PAGAMENTO');
      SQL.Add('WHERE co_empresa = '+QuotedStr(sEmpresa) );
      SQL.Add('ORDER BY co_folha');
      Open;
    end;

    DataSetToData( Query, mtFolha);

    with Query do begin
      Close;
      SQL.Clear;
      SQL.Add('SELECT co_rubrica, ds_rubrica FROM RUBRICA');
      SQL.Add('WHERE co_empresa = '+QuotedStr(sEmpresa) );
      SQL.Add('ORDER BY co_rubrica');
      Open;
    end;

    DataSetToData( Query, mtEvento);
    
  finally
    Query.Free;
  end;

end;

procedure TfrmEntrada.FormCreate(Sender: TObject);
begin

  Ctl3D  := False;
  Color  := $00E0E9EF;

  dbFolhaX.Checked := True;
  dbFolhaX.OnClick( dbFolhaX);

  dbEventoX.Checked := True;
  dbEventoX.OnClick( dbEventoX);

  dbLotacaoX.Checked := True;
  dbLotacaoX.OnClick( dbLotacaoX);

  dbTipoX.Checked := True;
  dbTipoX.OnClick( dbTipoX);

  dbRecursoX.Checked := True;
  dbRecursoX.OnClick( dbRecursoX);

end;

procedure TfrmEntrada.dbEmpresaCodigoEnter(Sender: TObject);
begin
  with (Sender as TwwDBLookupCombo) do begin
    Grid.Color := clInfoBk;
    ShowButton := True;
    DropDown;
  end;
end;

procedure TfrmEntrada.dbEmpresaNomeExit(Sender: TObject);
begin
  (Sender as TwwDBLookupCombo).ShowButton := False;
end;

procedure TfrmEntrada.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Screen.ActiveControl <> NIL) and (Key = VK_RETURN) then begin
    Key := 0;
    Perform( WM_NEXTDLGCTL, 0, 0);
  end;
end;

procedure TfrmEntrada.dbLotacaoXClick(Sender: TObject);
var
  Cor: TColor;
  CheckBox: TCheckBox;
  Checked: Boolean;
begin

  CheckBox := (Sender as TCheckBox);
  Checked  := CheckBox.Checked;
  Cor      := Iif( Checked, Self.Color, clWindow);

  if (CheckBox = dbFolhaX) then begin
    dbFolha2x.Enabled := not Checked;
    dbFolha.Enabled   := not Checked;
    dbFolha2.Enabled  := not Checked;
    dbFolha.Color     := Cor;
    dbFolha2.Color    := Cor;

    if Checked then
      dbFolha2x.Checked := False;

    dbgFolha.Enabled := dbFolha2x.Checked;

  end else if (CheckBox = dbFolha2X) then begin
    dbgFolha.Enabled := Checked;
    dbFolhax.Enabled  := not Checked;
    dbFolha.Enabled   := not Checked;
    dbFolha2.Enabled  := not Checked;
    dbFolha.Color     := Cor;
    dbFolha2.Color    := Cor;

    if Checked then
      dbFolhax.Checked := False;

  end else if (CheckBox = dbEventoX) then begin
    dbEvento2x.Enabled := not Checked;
    dbEvento.Enabled   := not Checked;
    dbEvento2.Enabled  := not Checked;
    dbEvento.Color     := Cor;
    dbEvento2.Color    := Cor;

    if Checked then
      dbEvento2x.Checked := False;

    dbgEvento.Enabled := dbEvento2x.Checked;

  end else if (CheckBox = dbEvento2X) then begin
    dbgEvento.Enabled := Checked;
    dbEventox.Enabled := not Checked;
    dbEvento.Enabled  := not Checked;
    dbEvento2.Enabled := not Checked;
    dbEvento.Color    := Cor;
    dbEvento2.Color   := Cor;

    if Checked then
      dbEventox.Checked := False;

  end else if (CheckBox = dbLotacaoX) then begin
    dbLotacao.Enabled  := not Checked;
    dbLotacao2.Enabled := not Checked;
    dbLotacao.Color    := Cor;
    dbLotacao2.Color   := Cor;

  end else if (CheckBox = dbTipoX) then begin
    dbTipo.Enabled := not Checked;
    dbTipo.Color   := Cor;

  end else if (CheckBox = dbRecursoX) then  begin
    dbRecurso.Enabled := not Checked;
    dbRecurso.Color   := Cor;

  end;
  
end;

procedure TfrmEntrada.mtConfigNewRecord(DataSet: TDataSet);
begin

  with DataSet do begin

    FieldByName('TIPO').AsString     := qryTipo.Fields[0].AsString;
    FieldByName('RECURSO').AsInteger := qryRecurso.Fields[0].AsInteger;

    FieldByName('ORDEM').AsString   := 'N';

  end;

end;

procedure TfrmEntrada.btnCancelarClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEntrada.btnImprimirClick(Sender: TObject);
var
  iFolha, iRecurso: Integer;
  sSaida, sLotacao, sTipo: String;
  sFormato, sOrdem: String;
begin

  if mtConfig.State in [dsInsert,dsEdit] then
    mtConfig.Post;

  sSaida   := Copy( (Sender as TButton).Caption, 2, 1);
  sLotacao := '';
  sTipo    := '';
  iRecurso := -1;

  with mtConfig do begin

    iFolha   := FieldByName('FOLHA').AsInteger;

    if dbLotacaoX.Checked then sLotacao := ''
                          else sLotacao := FieldByName('LOTACAO').AsString;

    if not dbTipoX.Checked then    sTipo := FieldByName('TIPO').AsString;
    if not dbRecursoX.Checked then iRecurso := FieldByName('RECURSO').AsInteger;

    sFormato := FieldByName('FORMATO').AsString;
    sOrdem   := FieldByName('ORDEM').AsString;

  end;  // with mtConfig do

  ImprimeListaEvento( qryTipo.Connection, sEmpresa, iFolha, iRecurso,
                      sLotacao, sTipo, '', '', sFormato, sOrdem,
                      True, True, sSaida);

end;

end.
