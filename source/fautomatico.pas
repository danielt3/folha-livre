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

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br

Histórico

* 24/03/2007 - Bug fix: 1686285 - Chave violada em Eventos Automáticos
}

{$IFNDEF QFLIVRE}
unit fautomatico;
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
  TFrmAutomatico = class(TFrmDialogo)
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
    dbCompetencias: TGroupBox;
    dbJaneiro: TDBCheckBox;
    dbFevereiro: TDBCheckBox;
    dbMarco: TDBCheckBox;
    dbAbril: TDBCheckBox;
    dbMaio: TDBCheckBox;
    dbJunho: TDBCheckBox;
    dbJulho: TDBCheckBox;
    dbAgosto: TDBCheckBox;
    dbSetembro: TDBCheckBox;
    dbOutubro: TDBCheckBox;
    dbNovembro: TDBCheckBox;
    dbDezembro: TDBCheckBox;
    db13salario: TDBCheckBox;
    mtRegistroJANEIRO_X: TSmallintField;
    mtRegistroFEVEREIRO_X: TSmallintField;
    mtRegistroMARCO_X: TSmallintField;
    mtRegistroABRIL_X: TSmallintField;
    mtRegistroMAIO_X: TSmallintField;
    mtRegistroJUNHO_X: TSmallintField;
    mtRegistroJULHO_X: TSmallintField;
    mtRegistroAGOSTO_X: TSmallintField;
    mtRegistroSETEMBRO_X: TSmallintField;
    mtRegistroOUTUBRO_X: TSmallintField;
    mtRegistroNOVEMBRO_X: TSmallintField;
    mtRegistroDEZEMBRO_X: TSmallintField;
    mtRegistroSALARIO13_X: TSmallintField;
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
  end;

procedure CriaAutomatico;

implementation

uses
  fdeposito, fdb, ftext, fsuporte, fevento, fgrupo_pagamento, futil, ffolha_tipo;

{$R *.dfm}

procedure CriaAutomatico;
begin

  if not kIsDeposito('FOLHA_ID') then
    Exit;

  with TFrmAutomatico.Create(Application) do
  try
    pvTabela := 'F_AUTOMATICO';
    cdFuncionario.CreateDataSet;
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // CriaAutomatico

procedure TFrmAutomatico.FormKeyDown(Sender: TObject; var Key: Word;
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

  else if (Key = VK_RETURN) and (ActiveControl = db13salario) and bEditando then
    Key := VK_F3;

  inherited;

end;

procedure TFrmAutomatico.mtRegistroNewRecord(DataSet: TDataSet);
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

procedure TFrmAutomatico.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Retirar o Evento "'+
                   DataSet.FieldByName('EVENTO').AsString+
                   '" para o funcionário ?') then
    SysUtils.Abort;
  inherited;
end;

procedure TFrmAutomatico.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbEvento.SetFocus;
end;

procedure TFrmAutomatico.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbEvento.SetFocus;
end;

procedure TFrmAutomatico.dbEventoButtonClick(Sender: TObject);
var Key: Word;
begin
  FindEvento( '', TAKDBEdit(Sender).DataSource.DataSet, Key);
end;

procedure TFrmAutomatico.GetData;
var
 SQL: TStringList;
begin

  SQL := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  A.*, E.NOME EVENTO, E.TIPO_EVENTO, E.TIPO_CALCULO, E.ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_AUTOMATICO A, F_EVENTO E');
    SQL.Add('WHERE');
    SQL.Add('  A.IDEMPRESA = :EMPRESA');
    SQL.Add('  AND A.IDFUNCIONARIO = :FUNCIONARIO');
    SQL.Add('  AND A.IDFOLHA_TIPO = :TIPO');
    SQL.Add('  AND E.IDEVENTO = A.IDEVENTO');
    SQL.EndUpdate;

    if not kOpenSQL( pvDataSet, SQL.Text, [pvEmpresa, GetFuncionario, GetTipoFolha]) then
      raise Exception.Create(kGetErrorLastSQL);

    pvDataSet.Last;
    pvDataSet.First;

  except
    on E:Exception do
      kErro( E.Message, 'fautomatico.pas', 'GetData()');
  end;
  finally
    SQL.Free;
  end;

end;  // procedure GetData

procedure TFrmAutomatico.Pesquisar;
begin
  GetData();
end;

procedure TFrmAutomatico.dbFuncButtonClick(Sender: TObject);
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

procedure TFrmAutomatico.dbTipoButtonClick(Sender: TObject);
var
  Key: Word;
begin

  if PesquisaTipoFolha( '*', cdFuncionario, Key, True) then
    GetData();

end;

procedure TFrmAutomatico.mtRegistroAfterPost(DataSet: TDataSet);
begin
  inherited;
  if (DataSet.Tag = 1) then
  begin
    GetData();
    DataSet.Append;
  end;
end;

procedure TFrmAutomatico.mtRegistroBeforePost(DataSet: TDataSet);
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

function TFrmAutomatico.GetFuncionario: String;
begin
  Result := cdFuncionario.FieldByName('IDFUNCIONARIO').AsString;
end;

function TFrmAutomatico.GetTipoFolha: String;
begin
  Result := cdFuncionario.FieldByName('IDFOLHA_TIPO').AsString;
end;

end.
