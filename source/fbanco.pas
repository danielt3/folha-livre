{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Bancos e Agencias
Copyright (C) 2004, Allan Lima, Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Autor: Allan Kardek Lima
E-mail: allan_kardek@yahoo.com.br / allan-kardek@bol.com.br
}

unit fbanco;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}Windows, Messages,{$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QStdCtrls, QAKLabel,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls, DBCtrls, Mask, Grids,
  DBGrids, Buttons, ComCtrls, AKLabel,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fbase, DB, DBClient, Variants;

type
  TFrmBanco = class(TFrmBase)
    PageControl: TPageControl;
    TabAgencia: TTabSheet;
    dbgAgencia: TDBGrid;
    pnlAgencia: TPanel;
    cdAgencia: TClientDataSet;
    dsAgencia: TDataSource;
    TabBanco: TTabSheet;
    dbgBanco: TDBGrid;
    pnlQuadro: TPanel;
    dbBanco: TDBEdit;
    dbBanco2: TDBEdit;
    Panel2: TPanel;
    dbBancoNome: TDBEdit;
    dbBancoID: TDBEdit;
    lbBanco2: TLabel;
    lbAgencia: TLabel;
    dbAgencia2: TDBEdit;
    lbAgencia2: TLabel;
    lbBanco: TLabel;
    dbAgencia: TDBEdit;
    mtRegistroIDBANCO: TStringField;
    mtRegistroNOME: TStringField;
    cdAgenciaIDBANCO: TStringField;
    cdAgenciaIDAGENCIA: TStringField;
    cdAgenciaNOME: TStringField;
    ComboBox1: TComboBox;
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure dbgBancoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgBancoTitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdAgenciaIDAGENCIAGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
  private
    { Private declarations }
    function LerTabela: TDataSource;
    function LerAgencia( Banco: String):Boolean;
  protected
    procedure Iniciar; override;
  public
    { Public declarations }
  end;

function PesquisaBanco( Pesquisa: String; var Codigo, Nome: String):Boolean; overload;
procedure PesquisaBanco( Pesquisa: String; DataSet: TDataSet;
  var Key: Word; FieldName: String = ''; AutoEdit: Boolean = False); overload;

function PesquisaAgencia( Pesquisa: String;
  var Banco, BancoNome, Codigo, Nome: String):Boolean; overload;
procedure PesquisaAgencia( Pesquisa: String; DataSet: TDataSet;
  var Key: Word; FieldName: String = ''; AutoEdit: Boolean = False); overload;

procedure CriaBanco();

implementation

uses ftext, fdb, fsuporte, fdepvar, fprint, ffind;

{$R *.dfm}

function PesquisaBanco( Pesquisa: String; var Codigo, Nome: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
    Pesquisa := '*';

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT IDBANCO AS ID, NOME FROM BANCO');
    SQL.Add('WHERE');
    if kIsNumerico(Pesquisa) then
      SQL.Add('IDBANCO = '+QuotedStr(Pesquisa))
    else
      SQL.Add('NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text) then
      Exit;

    with DataSet do
    begin
      if (RecordCount = 1) or
         kFindDataSet( DataSet, 'Banco',
                       Fields[1].FieldName, vCodigo, [foNoPanel],
                       Fields[0].FieldName) then
      begin
        Codigo := Fields[0].AsString;
        Nome   := Fields[1].AsString;
        Result := True;
      end;
    end;  // with DataSet

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // function FindBanco

procedure PesquisaBanco( Pesquisa: String; DataSet: TDataSet;
  var Key: Word; FieldName: String = ''; AutoEdit: Boolean = False);
var
  Codigo, Nome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDBANCO';

  if PesquisaBanco( Pesquisa, Codigo, Nome) then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField(FieldName)) then
          DataSet.FieldByName(FieldName).AsString := Codigo;
        if Assigned(DataSet.FindField('BANCO')) then
          DataSet.FieldByName('BANCO').AsString := Nome;
      end;

    end;

  end else
  begin
    kErro('Banco não encontrado !!!');
    Key := 0;
  end;

end;  // procedure PesquisaBanco

function PesquisaAgencia( Pesquisa: String;
  var Banco, BancoNome, Codigo, Nome: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  SQL: TStringList;
  sWhere: String;
begin

  Result := False;
  sWhere := '';

  if (Length(Pesquisa) = 0) then
    Pesquisa := '*';

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT A.IDBANCO, B.NOME AS BANCO, A.IDAGENCIA, A.NOME');
    SQL.Add('FROM AGENCIA A, BANCO B');
    if Length(Banco) > 0 then
      sWhere := 'A.IDBANCO = '+QuotedStr(Banco);
    if Length(sWhere) > 0 then
      sWhere := sWhere + ' AND ';
    if kIsNumerico(Pesquisa) then
      sWhere := sWhere + 'A.IDAGENCIA = '+QuotedStr(Pesquisa)
    else
      sWhere := sWhere + 'A.NOME LIKE '+QuotedStr(Pesquisa+'%');
    sWhere := sWhere + ' AND B.IDBANCO = A.IDBANCO';
    SQL.Add('WHERE '+sWhere);
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text) then
      Exit;

    with DataSet do
    begin
      if (RecordCount = 1) or
         kFindDataSet( DataSet, 'Agência',
                       Fields[3].FieldName, vCodigo, [foNoPanel],
                       Fields[2].FieldName) then
      begin
        Banco     := Fields[0].AsString;
        BancoNome := Fields[1].AsString;
        Codigo    := Fields[2].AsString;
        Nome      := Fields[3].AsString;
        Result    := True;
      end;
    end;  // with DataSet

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // function FindAgencia

procedure PesquisaAgencia( Pesquisa: String; DataSet: TDataSet;
  var Key: Word; FieldName: String = ''; AutoEdit: Boolean = False);
var
  Banco, BancoNome, Codigo, Nome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDAGENCIA';

  if Assigned(DataSet) and Assigned(DataSet.FindField('IDBANCO')) then
    Banco := DataSet.FieldByName('IDBANCO').AsString;

  if PesquisaAgencia( Pesquisa, Banco, BancoNome, Codigo, Nome) then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField(FieldName)) then
          DataSet.FieldByName(FieldName).AsString := Codigo;
        if Assigned(DataSet.FindField('IDBANCO')) then
          DataSet.FieldByName('IDBANCO').AsString := Banco;
        if Assigned(DataSet.FindField('BANCO')) then
          DataSet.FieldByName('BANCO').AsString := BancoNome;
        if Assigned(DataSet.FindField('AGENCIA')) then
          DataSet.FieldByName('AGENCIA').AsString := Nome;
      end;

    end;

  end else
  begin
    kErro('Agência não encontrada !!!');
    Key := 0;
  end;

end;  // procedure PesquisaAgencia

procedure CriaBanco();
begin

  with TFrmBanco.Create(Application) do
  try
    pvTabela := 'BANCO';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // procedure

procedure TFrmBanco.btnNovoClick(Sender: TObject);
begin
  LerTabela.DataSet.Append;
end;

procedure TFrmBanco.btnEditarClick(Sender: TObject);
begin
  LerTabela.DataSet.Edit;
end;

procedure TFrmBanco.btnGravarClick(Sender: TObject);
var
  win: TWinControl;
begin
  win := ActiveControl;
  ActiveControl := NIL;
  if (LerTabela.DataSet.Modified) then
    LerTabela.DataSet.Post
  else
    LerTabela.DataSet.Cancel;
  ActiveControl := win;
end;

procedure TFrmBanco.btnCancelarClick(Sender: TObject);
begin
  LerTabela.DataSet.Cancel;
end;

procedure TFrmBanco.btnExcluirClick(Sender: TObject);
begin
  LerTabela.DataSet.Delete;
end;

procedure TFrmBanco.PageControlChange(Sender: TObject);
begin
  inherited;
  if (PageControl.ActivePage = TabAgencia) then
    LerAgencia( pvDataSet.FieldByName('IDBANCO').AsString);
end;

procedure TFrmBanco.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  if LerTabela.DataSet.State in [dsInsert,dsEdit] then
    AllowChange := False;
end;

function TFrmBanco.LerAgencia( Banco: String): Boolean;
begin
  Result := kOpenSQL( cdAgencia,
                      'SELECT * FROM AGENCIA WHERE IDBANCO = :BANCO', [Banco]);
end;  // function LerAgencia

function TFrmBanco.LerTabela: TDataSource;
begin
  Result := dtsRegistro;
  if (PageControl.ActivePage = TabAgencia) then
    Result := dsAgencia;
end;

procedure TFrmBanco.Iniciar;
begin
  inherited;
  PageControl.ActivePageIndex := 0;
  PageControl.OnChange(PageControl);
end;

procedure TFrmBanco.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  if (DataSet = pvDataSet) then
  begin
    lbBanco.Enabled := True;
    dbBanco.Enabled := True;
  end else
  begin
    lbAgencia.Enabled := True;
    dbAgencia.Enabled := True;
  end;
end;

procedure TFrmBanco.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  if (DataSet <> pvDataSet) then
    DataSet.FieldByName('IDBANCO').AsString :=
                            mtRegistro.FieldByName('IDBANCO').AsString;
end;

procedure TFrmBanco.mtRegistroAfterPost(DataSet: TDataSet);
begin
  inherited;
  if (DataSet <> pvDataSet) and (DataSet.Tag = 1) then
    DataSet.Append
  else if Assigned(DataSet.AfterCancel) then
    DataSet.AfterCancel(DataSet);
end;

procedure TFrmBanco.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  if (DataSet = pvDataSet) then
    dbBanco.SetFocus
  else if (DataSet = cdAgencia) then
    dbAgencia.SetFocus;
end;

procedure TFrmBanco.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sBanco, sAgencia: String;
  sNome, sMsg, sTable: String;
begin

  sNome := DataSet.FieldByName('NOME').AsString;

  if (DataSet = pvDataSet) then
  begin
    sMsg    := 'Excluir o Banco "'+sNome+'" ?';
    sTable  := pvTabela;

  end else if (DataSet = cdAgencia) then
  begin

    sBanco := DataSet.FieldByName('IDBANCO').AsString;
    sAgencia := DataSet.FieldByName('IDAGENCIA').AsString;

    if kExistTable('FUNCIONARIO') and
       (kCountSQL('FUNCIONARIO', 'IDBANCO = :B AND IDAGENCIA = :A',
                  [sBanco, sAgencia]) > 0) then
      raise Exception.Create('Não é possível excluir esta agência.'#13+
                             'Há funcionários que possuem conta nesta agência.');

    sMsg    := 'Excluir a Agência "'+sNome+'" ?';
    sTable  := 'AGENCIA';

  end;

  if (not kConfirme(sMsg)) or
     (not kSQLDelete( DataSet, sTable, DataSet.Fields)) then
    SysUtils.Abort;

end;

procedure TFrmBanco.mtRegistroBeforeEdit(DataSet: TDataSet);
begin

  if (DataSet = pvDataSet) then
  begin
    dbBanco2.SetFocus;
    lbBanco.Enabled := False;
    dbBanco.Enabled := False;
  end else if (DataSet = cdAgencia) then
  begin
    dbAgencia2.SetFocus;
    lbAgencia.Enabled := False;
    dbAgencia.Enabled := False;
  end;

end;

procedure TFrmBanco.mtRegistroBeforePost(DataSet: TDataSet);
var
  sTable: String;
begin

  if (DataSet = pvDataSet) then
    sTable := pvTabela
  else if (DataSet = cdAgencia) then
    sTable := 'AGENCIA';

  if not kSQLCache( DataSet, sTable, DataSet.Fields) then
    SysUtils.Abort;

end;

procedure TFrmBanco.dbgBancoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmBanco.dbgBancoTitleClick(Column: TColumn);
begin
  kTitleClick( Column.Grid, Column);
end;

procedure TFrmBanco.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) and (dbAgencia = ActiveControl) and
     (cdAgencia.State in [dsInsert,dsEdit]) then
  begin
  
    if (dbAgencia.Text <> '') and (not kChecaBCO(dbAgencia.Text)) then
    begin
      kErro('O número da agência bancária está inválida. Verifique !!!');
      Key := 0;
    end;

  end else if (Key = VK_RETURN) and (dbAgencia2 = ActiveControl) and
     (cdAgencia.State in [dsInsert,dsEdit]) then
    Key := VK_F3

  else if (Key = VK_RETURN) and (dbBanco2 = ActiveControl) and
     (pvDataSet.State in [dsInsert,dsEdit]) then
    Key := VK_F3

  else if (Key = VK_SPACE) and (ActiveControl is TDBGrid) then
    PageControl.SelectNextPage(True);

  inherited;
end;

procedure TFrmBanco.cdAgenciaIDAGENCIAGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  Text := Sender.AsString;
  if not (Sender.DataSet.State in [dsInsert,dsEdit]) then
    Text := kFormatAgencia(Text);
end;

end.
