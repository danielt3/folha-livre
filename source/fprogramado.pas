{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2007 Allan Lima, Belém-Pará-Brasil.

Cadastro de Eventos Programados

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br

Histórico

* 01/04/2007 - Versão Inicial - Request ID 1686344  Eventos Programados
}

{$IFNDEF QFLIVRE}
unit fprogramado;
{$ENDIF}

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls, QDBCtrls,
  QMask, QGrids, QDBGrids, QComCtrls, QButtons, QMenus,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls, DBCtrls,
  Mask, Grids, DBGrids, ComCtrls, Buttons, Menus,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF F_MIDASLIB}MidasLib,{$ENDIF}
  SysUtils, Classes, fdialogo, DBClient, StrUtils, DB, Types;

type
  TFrmProgramado = class(TFrmDialogo)
    mtRegistroIDEVENTO: TIntegerField;
    mtRegistroEVENTO: TStringField;
    lbEvento: TLabel;
    lbEvento2: TLabel;
    dbEvento: TAKDBEdit;
    dbEvento2: TDBEdit;
    lbInformado: TLabel;
    dbInformado: TDBEdit;
    mtRegistroTIPO_EVENTO: TStringField;
    mtRegistroATIVO_X: TSmallintField;
    mtRegistroTIPO_CALCULO: TStringField;
    mtRegistroINFORMADO: TCurrencyField;
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroIDFUNCIONARIO: TIntegerField;
    cdFuncionario: TClientDataSet;
    dsFuncionario: TDataSource;
    cdFuncionarioFUNCIONARIO: TStringField;
    Panel1: TPanel;
    lbFunc: TLabel;
    lbFunc2: TLabel;
    lbTipo: TLabel;
    dbFunc: TAKDBEdit;
    dbFunc2: TDBEdit;
    cdFuncionarioIDFUNCIONARIO: TStringField;
    mtRegistroID: TIntegerField;
    dbTipo: TAKDBEdit;
    dbTipo2: TDBEdit;
    cdFuncionarioIDFOLHA_TIPO: TStringField;
    cdFuncionarioFOLHA_TIPO: TStringField;
    mtRegistroIDFOLHA_TIPO: TStringField;
    dbPeriodo: TGroupBox;
    dbSuspenso: TDBCheckBox;
    dbInicio: TDBEdit;
    dbTermino: TDBEdit;
    mtRegistroINICIO: TDateField;
    mtRegistroTERMINO: TDateField;
    lblA: TLabel;
    lblDe: TLabel;
    mtRegistroSUSPENSO_X: TSmallintField;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure dbEventoButtonClick(Sender: TObject);
    procedure dbFuncButtonClick(Sender: TObject);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure dbTipoButtonClick(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
  protected
    { Protected declarations }
    procedure GetData; override;
  private
    { Private declarations }
    function GetFuncionario: String;
    function GetTipoFolha: String;
  public
    { Public declarations }
    procedure Pesquisar; override;
    procedure Iniciar; override;
  end;

procedure CriaProgramado;

implementation

uses
  fdeposito, fdb, ftext, fsuporte, fevento, fgrupo_pagamento, futil,
  ffolha_tipo, ffolha;

{$R *.dfm}

procedure CriaProgramado;
begin

  if not kIsDeposito('FOLHA_ID') then
    Exit;

  with TFrmProgramado.Create(Application) do
  try
    pvTabela := 'F_PROGRAMADO';
    cdFuncionario.CreateDataSet;
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // CriaAutomatico

procedure TFrmProgramado.Iniciar;
var
  iFolha: Integer;
  SQL: TStringList;
begin

  iFolha := kFolhaAtiva();
  SQL := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  F.IDFOLHA_TIPO, T.NOME AS FOLHA_TIPO');
    SQL.Add('FROM');
    SQL.Add('  F_FOLHA F, F_FOLHA_TIPO T');
    SQL.Add('WHERE F.IDEMPRESA = :EMPRESA AND F.IDFOLHA = :FOLHA');
    SQL.Add('  AND T.IDFOLHA_TIPO = F.IDFOLHA_TIPO');
    SQL.EndUpdate;

    kOpenSQL( cdFuncionario, SQL.Text, [pvEmpresa, iFolha]);

  finally
    SQL.Free;
  end;

end;

procedure TFrmProgramado.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  bEditando: Boolean;
begin

  bEditando := (pvDataSet.State in [dsInsert,dsEdit]);

  if (Key = VK_RETURN) and (ActiveControl = dbFunc) then
  begin

    if not (cdFuncionario.State in [dsInsert,dsEdit]) then
      cdFuncionario.Edit;

    PesquisaFuncionario( dbFunc.Text, pvEmpresa, cdFuncionario, Key);

    if (cdFuncionario.State in [dsInsert,dsEdit]) then
      cdFuncionario.Post;

    if (Key <> 0) then
      GetData();

  end else if (Key = VK_RETURN) and (ActiveControl = dbTipo) then
  begin

    if PesquisaTipoFolha( dbTipo.Text, cdFuncionario, Key, True) then
      GetData();

  end else if (Key = VK_SPACE) and (ActiveControl is TDBGrid) and
      Assigned(TDBGrid(ActiveControl).OnDblClick) then
    TDBGrid(ActiveControl).OnDblClick(ActiveControl)

  else if (Key = VK_RETURN) and (ActiveControl = dbEvento) and bEditando then
    FindEvento( dbEvento.Text, pvDataSet, Key)

  else if (Key = VK_RETURN) and (ActiveControl = dbSuspenso) and bEditando then
    Key := VK_F3;

  inherited;

end;

procedure TFrmProgramado.mtRegistroNewRecord(DataSet: TDataSet);
var
  i: Integer;
begin
  inherited;
  for i := 0 to cdFuncionario.FieldCount-1 do
    if Assigned(DataSet.FindField(cdFuncionario.Fields[i].FieldName)) then
      DataSet.FieldByName(cdFuncionario.Fields[i].FieldName).Value :=
                                               cdFuncionario.Fields[i].Value;
  DataSet.FieldByName('IDEVENTO').AsString := '';
end;

procedure TFrmProgramado.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Retirar o Evento "'+
                   DataSet.FieldByName('EVENTO').AsString+
                   '" para o funcionário ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmProgramado.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbEvento.SetFocus;
end;

procedure TFrmProgramado.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbEvento.SetFocus;
end;

procedure TFrmProgramado.dbEventoButtonClick(Sender: TObject);
var Key: Word;
begin
  FindEvento( '', TAKDBEdit(Sender).DataSource.DataSet, Key);
end;

procedure TFrmProgramado.GetData;
var
 SQL: TStringList;
begin

  SQL := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  P.*, E.NOME EVENTO, E.TIPO_EVENTO, E.TIPO_CALCULO, E.ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_PROGRAMADO P, F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  P.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND P.IDFUNCIONARIO = :FUNCIONARIO');
    SQL.Add('  AND P.IDFOLHA_TIPO = :TIPO');
    SQL.Add('  AND E.IDEVENTO = P.IDEVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( pvDataSet, SQL.Text, [pvEmpresa, GetFuncionario, GetTipoFolha]) then
      raise Exception.Create(kGetErrorLastSQL);

    pvDataSet.Last;
    pvDataSet.First;

  except
    on E:Exception do
      kErro( E.Message, 'fprogramado.pas', 'GetData()');
  end;
  finally
    SQL.Free;
  end;

end;  // procedure GetData

procedure TFrmProgramado.Pesquisar;
begin
  GetData();
end;

procedure TFrmProgramado.dbFuncButtonClick(Sender: TObject);
var
  Key: Word;
begin

  if not (cdFuncionario.State in [dsInsert,dsEdit]) then
    cdFuncionario.Edit;

  PesquisaFuncionario( '', pvEmpresa, cdFuncionario, Key);

  if (cdFuncionario.State in [dsInsert,dsEdit]) then
    cdFuncionario.Post;

  GetData();

end;

procedure TFrmProgramado.dbTipoButtonClick(Sender: TObject);
var
  Key: Word;
begin

  if PesquisaTipoFolha( '*', cdFuncionario, Key, True) then
    GetData();

end;

procedure TFrmProgramado.mtRegistroAfterPost(DataSet: TDataSet);
begin
  inherited;
  if (DataSet.Tag = 1) then
  begin
    GetData();
    DataSet.Append;
  end;
end;

procedure TFrmProgramado.mtRegistroBeforePost(DataSet: TDataSet);
var
  iMax: Integer;
  sTipo, sWhere: String;
begin
  if (DataSet.FieldByName('ID').AsInteger = 0) then
  begin
    sTipo := QuotedStr(GetTipoFolha);
    sWhere := 'IDFUNCIONARIO = '+GetFuncionario; // Bug fix: 1686285
    iMax  := kMaxCodigo( pvTabela, 'ID', pvEmpresa, sWhere);
    DataSet.FieldByName('ID').AsInteger := iMax;
  end;
  inherited;
end;

function TFrmProgramado.GetFuncionario: String;
begin
  Result := cdFuncionario.FieldByName('IDFUNCIONARIO').AsString;
end;

function TFrmProgramado.GetTipoFolha: String;
begin
  Result := cdFuncionario.FieldByName('IDFOLHA_TIPO').AsString;
end;

procedure TFrmProgramado.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kEventoDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

end.
