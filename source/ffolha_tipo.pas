{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Tipos de Folhas

Copyright (C) 2004-2008, Allan Lima.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br

Histórico das alterações

* 24/05/2005 - Adicionado situação de funcionário por tipo de folha;
* 23/05/2008 - Adicionado o campo sequencia_x para ordem de cálculo independente;
}

unit ffolha_tipo;

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
  TFrmFolhaTipo = class(TFrmBase)
    PageControl: TPageControl;
    TabSituacao: TTabSheet;
    dbgSituacao: TDBGrid;
    cdSituacao: TClientDataSet;
    dsSituacao: TDataSource;
    TabTipo: TTabSheet;
    dbgTipo: TDBGrid;
    pnlQuadro: TPanel;
    dbTipo: TDBEdit;
    dbTipoNome: TDBEdit;
    Panel2: TPanel;
    dbTipoNome2: TDBEdit;
    dbTipo2: TDBEdit;
    lbTipoNome: TLabel;
    lbTipo: TLabel;
    mtRegistroIDBANCO: TStringField;
    mtRegistroNOME: TStringField;
    cdSituacaoIDFOLHA_TIPO: TStringField;
    cdSituacaoIDSITUACAO: TStringField;
    cdSituacaoNOME: TStringField;
    mtRegistroQTDE: TIntegerField;
    mtRegistroSEQUENCIA_X: TSmallintField;
    dbSequencia: TDBCheckBox;
    Label1: TLabel;
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
    procedure dbgTipoDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgTipoTitleClick(Column: TColumn);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    function LerTabela: TDataSource;
    function LerSituacao( Tipo: String):Boolean;
  protected
    procedure Iniciar; override;
    procedure Pesquisar; override;
  public
    { Public declarations }
  end;

function PesquisaTipoFolha( Pesquisa: String; var Codigo, Nome: String;
  var Sequencia: Integer):Boolean; overload;

function PesquisaTipoFolha( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean; overload;

procedure CriaFolhaTipo();

implementation

uses ftext, fdb, fsuporte, fdepvar, fprint, ffind, fsituacao;

{$R *.dfm}

function PesquisaTipoFolha( Pesquisa: String; var Codigo, Nome: String;
  var Sequencia: Integer):Boolean;
var
  DataSet: TClientDataSet;
  vValue: Variant;
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
    SQL.Add('SELECT IDFOLHA_TIPO, NOME, SEQUENCIA_X');
    SQL.Add('FROM F_FOLHA_TIPO');
    if kNumerico(Pesquisa) then
      SQL.Add('WHERE IDFOLHA_TIPO = '+QuotedStr(Pesquisa))
    else
      SQL.Add('WHERE NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text) then
      Exit;

    if not Result then
      Result := kFindDataSet( DataSet,
                              'Pesquisando Tipos de Folha',
                              DataSet.Fields[0].FieldName,
                              vValue, [foNoPanel, foNoTitle] );

    if Result then
    begin
      Codigo    := DataSet.Fields[0].AsString;
      Nome      := DataSet.Fields[1].AsString;
      Sequencia := DataSet.Fields[2].AsInteger;
    end;

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // FindTipoFolha

function PesquisaTipoFolha( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False):Boolean;
var
  Codigo, Nome: String;
  Sequencia: Integer;
begin

  Result := PesquisaTipoFolha( Pesquisa, Codigo, Nome, Sequencia);

  if Result then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDFOLHA_TIPO')) then
          DataSet.FieldByName('IDFOLHA_TIPO').AsString := Codigo;
        if Assigned(DataSet.FindField('FOLHA_TIPO')) then
          DataSet.FieldByName('FOLHA_TIPO').AsString := Nome
        else if Assigned(DataSet.FindField('NOME')) then
          DataSet.FieldByName('NOME').AsString := Nome;
        if Assigned(DataSet.FindField('SEQUENCIA_X')) then
          DataSet.FieldByName('SEQUENCIA_X').AsInteger := Sequencia;
      end;

    end;

  end else
  begin
    kErro('Tipo de Folha não encontrada !!!');
    Key := 0;
  end;

end;  // PesquisaTipoFolha

{ TFrmFolhaTipo }

procedure CriaFolhaTipo();
begin

  with TFrmFolhaTipo.Create(Application) do
  try
    pvTabela := 'F_FOLHA_TIPO';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;

procedure TFrmFolhaTipo.Iniciar;
begin
  inherited;
  PageControl.ActivePageIndex := 0;
  PageControl.OnChange(PageControl);
end;

procedure TFrmFolhaTipo.Pesquisar;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try
    SQL.BeginUpdate;
    SQL.Add('SELECT T.*,');
    SQL.Add('  (SELECT COUNT(*) FROM F_FOLHA_TIPO_SITUACAO S');
    SQL.Add('  WHERE S.IDFOLHA_TIPO = T.IDFOLHA_TIPO) AS QTDE');
    SQL.Add('FROM F_FOLHA_TIPO T');
    SQL.EndUpdate;
    kOpenSQL( mtRegistro, SQL.Text);
  finally
    SQL.Free;
  end;

end;

procedure TFrmFolhaTipo.btnNovoClick(Sender: TObject);
var
  Key: Word;
begin
  LerTabela.DataSet.Append;
  if (LerTabela.DataSet = cdSituacao) then
  begin
    if PesquisaSituacao( '*', cdSituacao, Key) then
      btnGravar.Click
    else
      btnCancelar.Click;
  end;
end;

procedure TFrmFolhaTipo.btnEditarClick(Sender: TObject);
begin
  LerTabela.DataSet.Edit;
end;

procedure TFrmFolhaTipo.btnGravarClick(Sender: TObject);
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

procedure TFrmFolhaTipo.btnCancelarClick(Sender: TObject);
begin
  LerTabela.DataSet.Cancel;
end;

procedure TFrmFolhaTipo.btnExcluirClick(Sender: TObject);
begin
  LerTabela.DataSet.Delete;
end;

procedure TFrmFolhaTipo.PageControlChange(Sender: TObject);
var
  sTipo: String;
begin
  sTipo := pvDataSet.FieldByName('IDFOLHA_TIPO').AsString;
  if (TPageControl(Sender).ActivePage = TabTipo) then
  begin
    Pesquisar();
    pvDataSet.Locate('IDFOLHA_TIPO', sTipo, []);
  end else if (PageControl.ActivePage = TabSituacao) then
    LerSituacao(sTipo);
end;

procedure TFrmFolhaTipo.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  inherited;
  if LerTabela.DataSet.State in [dsInsert,dsEdit] then
    AllowChange := False;
end;

function TFrmFolhaTipo.LerSituacao( Tipo: String): Boolean;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT T.*, S.NOME FROM F_FOLHA_TIPO_SITUACAO T, F_SITUACAO S');
    SQL.Add('WHERE T.IDFOLHA_TIPO = :TIPO AND S.IDSITUACAO = T.IDSITUACAO');
    SQL.EndUpdate;

    Result := kOpenSQL( cdSituacao, SQL.Text, [Tipo]);

  finally
    SQL.Free;
  end;

end;

function TFrmFolhaTipo.LerTabela: TDataSource;
begin
  Result := dtsRegistro;
  if (PageControl.ActivePage = TabSituacao) then
    Result := dsSituacao;
end;

procedure TFrmFolhaTipo.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  if (DataSet = pvDataSet) then
  begin
    lbTipo.Enabled := True;
    dbTipo.Enabled := True;
  end;
end;

procedure TFrmFolhaTipo.mtRegistroNewRecord(DataSet: TDataSet);
begin

  inherited;

  if Assigned(DataSet.FindField('SEQUENCIA_X')) then
    DataSet.FieldByName('SEQUENCIA_X').AsInteger := 1;

  if (DataSet <> pvDataSet) then
    DataSet.FieldByName('IDFOLHA_TIPO').AsString :=
       mtRegistro.FieldByName('IDFOLHA_TIPO').AsString;
       
end;

procedure TFrmFolhaTipo.mtRegistroAfterPost(DataSet: TDataSet);
begin
  inherited;
  if (DataSet <> pvDataSet) and (DataSet.Tag = 1) then
    DataSet.Append
  else if Assigned(DataSet.AfterCancel) then
    DataSet.AfterCancel(DataSet);
end;

procedure TFrmFolhaTipo.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  if (DataSet = pvDataSet) then
    dbTipo.SetFocus;
end;

procedure TFrmFolhaTipo.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome, sMsg, sTable: String;
begin

  sNome := DataSet.FieldByName('NOME').AsString;

  if (DataSet = pvDataSet) then
  begin
    sMsg    := 'Excluir o Tipo "'+sNome+'" ?';
    sTable  := pvTabela;
  end else if (DataSet = cdSituacao) then
  begin
    sMsg    := 'Excluir a situacao "'+sNome+'" ?';
    sTable  := 'F_FOLHA_TIPO_SITUACAO';
  end;

  if (not kConfirme(sMsg)) or
     (not kSQLDelete( DataSet, sTable, DataSet.Fields)) then
    SysUtils.Abort;

end;

procedure TFrmFolhaTipo.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  if (DataSet = pvDataSet) then
  begin
    dbTipoNome.SetFocus;
    lbTipo.Enabled := False;
    dbTipo.Enabled := False;
  end;
end;

procedure TFrmFolhaTipo.mtRegistroBeforePost(DataSet: TDataSet);
var
  sTable: String;
begin

  if (DataSet = pvDataSet) then
    sTable := pvTabela
  else if (DataSet = cdSituacao) then
    sTable := 'F_FOLHA_TIPO_SITUACAO';

  if not kSQLCache( DataSet, sTable, DataSet.Fields) then
    SysUtils.Abort;

end;

procedure TFrmFolhaTipo.dbgTipoDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused );
end;

procedure TFrmFolhaTipo.dbgTipoTitleClick(Column: TColumn);
begin
  kTitleClick( Column.Grid, Column);
end;

procedure TFrmFolhaTipo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) and (ActiveControl = dbSequencia) and
     (pvDataSet.State in [dsInsert,dsEdit]) then
    Key := VK_F3

  else if (Key = VK_SPACE) and (ActiveControl is TDBGrid) then
    PageControl.SelectNextPage(True);

  inherited;

end;

end.
