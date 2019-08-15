{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2002 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

unit ftabela;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs,
  QGrids, QDBGrids, QComCtrls, QButtons, QMask, QStdCtrls,
  QExtCtrls, QDBCtrls, {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  Grids, DBGrids, ComCtrls, Buttons, Mask, StdCtrls,
  ExtCtrls, DBCtrls, {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  Variants, fcadastro, DB, DBClient, SysUtils, Classes, fbase, Types;

type
  TFrmTabela = class(TFrmBase)
    cdModelo: TClientDataSet;
    dsModelo: TDataSource;
    cdModeloIDEMPRESA: TIntegerField;
    cdModeloIDTABELA: TIntegerField;
    cdModeloNOME: TStringField;
    cdModeloITEM: TSmallintField;
    PageControl: TPageControl;
    TabTabela: TTabSheet;
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroIDTABELA: TIntegerField;
    mtRegistroNOME: TStringField;
    TabModelo: TTabSheet;
    dbgTabela: TDBGrid;
    Panel: TPanel;
    lbCodigo: TLabel;
    lbNome: TLabel;
    dbCodigo: TDBEdit;
    dbNome: TDBEdit;
    dbgModelo: TDBGrid;
    Panel1: TPanel;
    lbItem: TLabel;
    lbItemNome: TLabel;
    dbItem: TDBEdit;
    dbItemNome: TDBEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure btnNovoClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
    procedure dbgTabelaDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgTabelaTitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
    procedure Pesquisar; override;
    function GetIDInteger:Integer; override;
    function GetIDString:String; override;
  end;

function FindTabela( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean;

procedure PesquisaTabela( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '');

procedure CriaTabela;

implementation

uses fdb, ftext, fsuporte, ffind;

{$R *.dfm}

function FindTabela( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa de Tabela',
                       'Informe um texto para pesquisar', Pesquisa) then
      Exit;
  end;

  if (Length(Pesquisa) = 0) then
    Exit;

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT IDTABELA, NOME FROM F_TABELA');
    SQL.Add('WHERE IDEMPRESA = :EMPRESA');
    if kNumerico(Pesquisa) then
      SQL.Add('AND IDTABELA = '+Pesquisa)
    else
      SQL.Add('AND NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.Add('ORDER BY 1');
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text, [Empresa]) then
      Exit;

    with DataSet do
    begin
      if (RecordCount = 1) or
         kFindDataSet( DataSet, 'Tabelas',
                       Fields[1].FieldName, vCodigo,
                       [foNoPanel, foNoTitle], Fields[0].FieldName) then
      begin
        Codigo := Fields[0].AsInteger;
        Nome   := Fields[1].AsString;
        Result := True;
      end;
    end;  // with DataSet

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // function FindTabela

procedure PesquisaTabela( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '');
var
  Codigo: Integer;
  Nome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDTABELA';

  if FindTabela( Pesquisa, Empresa, Codigo, Nome) then
  begin
    if Assigned(DataSet) and (DataSet.State in [dsInsert,dsEdit]) then
    begin
      if Assigned(DataSet.FindField(FieldName)) then
        DataSet.FieldByName(FieldName).AsInteger := Codigo;
      if Assigned(DataSet.FindField('TABELA')) then
        DataSet.FieldByName('TABELA').AsString := Nome;
    end;
  end else
  begin
    kErro('Tabela não encontrada !!!');
    Key := 0;
  end;

end;  // procedure PesquisaTabela

procedure CriaTabela;
begin

  with TFrmTabela.Create(Application) do
  try
    pvTabela := 'F_TABELA';
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // procedure CriaTabelaCalculo

procedure TFrmTabela.Iniciar;
begin
 if (pvEmpresa = 0) then
   Caption := 'Tabelas Globais de Cálculo';
 RxTitulo.Caption := ' + Listagem de '+Caption;
 inherited;
end;

procedure TFrmTabela.Pesquisar;
begin
  kSQLSelectFrom( pvDataSet, pvTabela, pvEmpresa);
  kTitleClick( dbgTabela, dbgTabela.Columns[0]);
  pvDataSet.First;
end;

procedure TFrmTabela.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_SPACE) and (ActiveControl = dbgTabela) then
    PageControl.SelectNextPage(True)
  else if (Key = VK_RETURN) and (ActiveControl = dbNome) and
          (pvDataSet.State in [dsInsert,dsEdit]) then
    Key := VK_F3
  else if (Key = VK_RETURN) and (ActiveControl = dbItemNome) and
          (cdModelo.State in [dsInsert,dsEdit]) then
    Key := VK_F3;
  inherited
end;

procedure TFrmTabela.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if (pvDataSet.State in [dsInsert,dsEdit]) or (cdModelo.State in [dsInsert,dsEdit]) then
    AllowChange := False;
end;

procedure TFrmTabela.btnNovoClick(Sender: TObject);
var s: String;
begin
  s := TSpeedButton(Sender).Caption;
  if (PageControl.ActivePage = TabTabela) then
    kOperationDefault( Self, mtRegistro, s, 'Tabela de Cálculo', False)
  else if (PageControl.ActivePage = TabModelo) then
    kOperationDefault( Self, cdModelo, s, 'Modelo', False);
end;

procedure TFrmTabela.PageControlChange(Sender: TObject);
begin
  inherited;
  if (TPageControl(Sender).ActivePage <> TabTabela) then
    RxTitulo.Caption := ' · Tabela: '+GetIDString+ ' - ' +
                         mtRegistro.FieldByName('NOME').AsString
  else
    RxTitulo.Caption := ' · '+Caption;

  if (TPageControl(Sender).ActivePage = TabModelo) then
    kSQLSelectFrom( cdModelo, 'F_TABELA_MODELO', pvEmpresa, 'IDTABELA = '+GetIDString);

end;

procedure TFrmTabela.FormCreate(Sender: TObject);
begin
  inherited;
  PageControl.ActivePageIndex := 0;
end;

procedure TFrmTabela.mtRegistroBeforeDelete(DataSet: TDataSet);
var sMsg, sTabela: String;
begin

  if (DataSet = mtRegistro) then
  begin
    sTabela := pvTabela;
    sMsg := 'Excluir a Tabela "'+DataSet.FieldByName('NOME').AsString + '" ?';
  end else if (DataSet = cdModelo) then
  begin
    sTabela := 'F_TABELA_MODELO';
    sMsg := 'Excluir o Modelo';
  end;

  if (not kConfirme(sMsg)) or (not kSQLDelete( DataSet, sTabela, DataSet.Fields)) then
    SysUtils.Abort;

end;

procedure TFrmTabela.mtRegistroBeforePost(DataSet: TDataSet);
var sTabela: String;
begin

  with DataSet do
    if (DataSet = pvDataSet) then
    begin
      sTabela := 'F_TABELA';
      if (FieldByName('IDTABELA').AsInteger = 0) then
        FieldByName('IDTABELA').AsInteger := kMaxCodigo( sTabela, 'IDTABELA', pvEmpresa);
    end else if (DataSet = cdModelo) then
    begin
      sTabela := 'F_TABELA_MODELO';
      if (FieldByName('ITEM').AsInteger = 0) then
        FieldByName('ITEM').AsInteger :=
           kMaxCodigo( sTabela, 'ITEM', pvEmpresa, 'IDTABELA = '+GetIDString);
    end;

  if not kSQLCache( DataSet, sTabela, DataSet.Fields) then
    SysUtils.Abort;

end;

procedure TFrmTabela.mtRegistroNewRecord(DataSet: TDataSet);
begin

  if (DataSet = mtRegistro) then
    kDataSetDefault( DataSet, 'F_TABELA')
  else if (DataSet = cdModelo) then
    kDataSetDefault( DataSet, 'F_TABELA_MODELO');

  if Assigned(DataSet.FindField('IDEMPRESA')) then
    DataSet.FieldByName('IDEMPRESA').AsInteger := pvEmpresa;

  if Assigned(DataSet.FindField('IDTABELA')) then
    DataSet.FieldByName('IDTABELA').AsInteger := GetIDInteger();

end;

function TFrmTabela.GetIDInteger: Integer;
begin
  Result := mtRegistro.FieldByName('IDTABELA').AsInteger;
end;

function TFrmTabela.GetIDString: String;
begin
  Result := mtRegistro.FieldByName('IDTABELA').AsString;
end;

procedure TFrmTabela.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  if (DataSet = pvDataSet) then
  begin
    lbCodigo.Enabled := False;
    dbCodigo.Enabled := False;
    dbNome.SetFocus;
  end else
  begin
    lbItem.Enabled := False;
    dbItem.Enabled := False;
    dbItemNome.SetFocus;
  end;
end;

procedure TFrmTabela.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  if (DataSet = pvDataSet) then
    dbCodigo.SetFocus
  else
    dbItem.SetFocus;
end;

procedure TFrmTabela.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  if (DataSet = pvDataSet) then
  begin
    lbCodigo.Enabled := True;
    dbCodigo.Enabled := True;
  end else
  begin
    lbItem.Enabled := True;
    dbItem.Enabled := True;
  end;
end;

procedure TFrmTabela.dbgTabelaDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmTabela.dbgTabelaTitleClick(Column: TColumn);
begin
  kTitleClick( Column.Grid, Column);
end;

end.
