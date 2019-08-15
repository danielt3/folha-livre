{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (C) 2002-2008, Allan Lima.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

{
Histórico das modificações
==========================

* 11/05/2008 - Adicionado a guia "FGTS" (Categoria de FGTS);
* 16/05/2008 - Adicionado a guia "Tipo de Funcionario";
* 21/05/2008 - Adicionado a guia "Situação do Funcionario";
* 21/05/2008 - Adicionado a guia "Vínculo Empregatício do Funcionario";
* 21/05/2008 - Adicionado a guia "Tipo de Salário do Funcionario";
* 23/05/2008 - Adicionado o campo "SEQUENCIA";
}

{$IFNDEF QFLIVRE}
unit fpadrao;
{$ENDIF}

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls,
  QDBCtrls, QMask, QGrids, QDBGrids, QComCtrls, QButtons, QMenus, QAKLabel,
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons, Menus, AKLabel,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fbase, DBClient, StrUtils, DB, Types;

type
  TFrmPadrao = class(TFrmBase)
    mtRegistroIDGP: TIntegerField;
    mtRegistroIDEVENTO: TIntegerField;
    mtRegistroEVENTO: TStringField;
    cdGP: TClientDataSet;
    cdGPIDGE: TIntegerField;
    cdGPIDGP: TIntegerField;
    dsGP: TDataSource;
    dbgRegistro: TDBGrid;
    mtRegistroINFORMADO: TCurrencyField;
    mtRegistroJANEIRO_X: TSmallIntField;
    mtRegistroFEVEREIRO_X: TSmallIntField;
    mtRegistroMARCO_X: TSmallIntField;
    mtRegistroABRIL_X: TSmallIntField;
    mtRegistroMAIO_X: TSmallIntField;
    mtRegistroJUNHO_X: TSmallIntField;
    mtRegistroJULHO_X: TSmallIntField;
    mtRegistroAGOSTO_X: TSmallIntField;
    mtRegistroSETEMBRO_X: TSmallIntField;
    mtRegistroOUTUBRO_X: TSmallIntField;
    mtRegistroNOVEMBRO_X: TSmallIntField;
    mtRegistroDEZEMBRO_X: TSmallIntField;
    mtRegistroSALARIO13_X: TSmallIntField;
    mtRegistroIDFOLHA_TIPO: TStringField;
    mtRegistroIDPADRAO: TIntegerField;
    Panel1: TPanel;
    dbGE: TAKDBEdit;
    dbGE2: TDBEdit;
    dbGP: TAKDBEdit;
    dbGP2: TDBEdit;
    cdGPGE: TStringField;
    cdGPGP: TStringField;
    cdGPIDFOLHA_TIPO: TStringField;
    cdGPFOLHA_TIPO: TStringField;
    dbFolha: TAKDBEdit;
    dbFolha2: TDBEdit;
    mtRegistroTIPO_EVENTO: TStringField;
    mtRegistroATIVO_X: TSmallintField;
    PageControl1: TPageControl;
    TabEvento: TTabSheet;
    Panel: TPanel;
    lbEvento: TLabel;
    lbEvento2: TLabel;
    lbInformado: TLabel;
    dbEvento2: TDBEdit;
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
    dbMarcar: TCheckBox;
    dbInformado: TDBEdit;
    TabFGTS: TTabSheet;
    Label6: TLabel;
    dbgFGTS: TDBGrid;
    Label1: TLabel;
    TabTipo: TTabSheet;
    Label2: TLabel;
    dbgTipo: TDBGrid;
    Label3: TLabel;
    TabSituacao: TTabSheet;
    Label4: TLabel;
    dbgSituacao: TDBGrid;
    Label5: TLabel;
    TabVinculo: TTabSheet;
    TabSalario: TTabSheet;
    Label7: TLabel;
    dbgVinculo: TDBGrid;
    Label8: TLabel;
    dbgSalario: TDBGrid;
    Label10: TLabel;
    Label9: TLabel;
    mtRegistroSEQUENCIA: TSmallintField;
    lbSequencia: TLabel;
    dbSequencia: TDBEdit;
    cdGPSEQUENCIA_X: TSmallintField;
    dbEvento: TDBEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure dbEventoButtonClick(Sender: TObject);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure dbGEButtonClick(Sender: TObject);
    procedure dbFolhaButtonClick(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgRegistroTitleClick(Column: TColumn);
    procedure dbMarcarClick(Sender: TObject);
    procedure dtsRegistroStateChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure dbgFGTSDblClick(Sender: TObject);
    procedure dbgFGTSDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mtRegistroAfterScroll(DataSet: TDataSet);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
  protected

    cdFGTS: TClientDataSet;
    dsFGTS: TDataSource;

    cdTipo: TClientDataSet;
    dsTipo: TDataSource;

    cdSituacao: TClientDataSet;
    dsSituacao: TDataSource;

    cdVinculo: TClientDataSet;
    dsVinculo: TDataSource;

    cdSalario: TClientDataSet;
    dsSalario: TDataSource;

    procedure GetData; override;

  private
    { Private declarations }
    pvGrupoPagamento: Integer;
    pvTipoFolha: String;
    function AtivarFiltro(DataSet: TDataSet;
      const Filtro: String): Boolean;
    procedure LerFiltro(DataSet: TDataSet; const Filtro: String);
  public
    { Public declarations }
    constructor Create(Owner: TComponent); override;
    procedure Iniciar; override;
    procedure Pesquisar; override;
  end;

procedure CriaPadrao;

implementation

uses Variants, fdb, ftext, fsuporte, fevento, fformula,
  fgrupo_empresa, fgrupo_pagamento, ffolha_tipo, ffind, futil;

{$R *.dfm}

procedure CriaPadrao;
var
  i: Integer;
begin

  for i := 0 to (Screen.FormCount - 1) do
    if (Screen.Forms[i] is TFrmPadrao) then
    begin
      Screen.Forms[i].Show;
      Exit;
    end;

  with TFrmPadrao.Create(Application) do
  try
    pvTabela := 'F_PADRAO';
    Iniciar();
    Show;
  except
    on E:Exception do
    begin
      kErro( E.Message, 'fpadrao.pas', 'CriaSequencia()');
      Free;
    end;
  end;

end;  // CriaPadrao

constructor TFrmPadrao.Create(Owner: TComponent);
var
  i: Integer;

  procedure InitGrid( Grid: TDBGrid; Source: TDataSource; Filtro: String);
  begin

    with Grid do
    begin

      DataSource := Source;
      Font.Size := Trunc(Self.Font.Size * 1.5);
      Options := Options + [dgIndicator, dgEditing, dgRowSelect, dgAlwaysShowSelection];
      Options := Options - [dgColumnResize];
      ParentColor := True;
      ReadOnly := True;

      OnDrawColumnCell := dbgFGTSDrawColumnCell;
      OnDblClick       := dbgFGTSDblClick;

      with Columns.Add do
      begin
        Alignment := taCenter;
        FieldName := 'ID'+Filtro;
        Title.Alignment := taCenter;
        Title.Caption := 'Código';
        Width := 50;
      end;

      with Columns.Add do
      begin
        FieldName := 'NOME';
        Title.Caption := 'Descrição';
        Width := 350;
      end;

      i := kMaxWidthColumn( Columns, Rate);

      Columns[1].Width := Columns[1].Width + (Grid.ClientWidth - i);

    end;

  end;  // InitGrid

begin

  inherited;

  { 11-05-2008 by allan_lima }

  cdFGTS := TClientDataSet.Create(Self);

  with cdFGTS do
  begin
    FieldDefs.Add('IDFGTS', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    CreateDataSet;
  end;

  dsFGTS := TDataSource.Create(Self);
  dsFGTS.DataSet := cdFGTS;

  InitGrid( dbgFGTS, dsFGTS, 'FGTS');

  { 16-05-2008 by allan_lima }

  cdTipo := TClientDataSet.Create(Self);

  with cdTipo do
  begin
    FieldDefs.Add('IDTIPO', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    CreateDataSet;
  end;

  dsTipo := TDataSource.Create(Self);
  dsTipo.DataSet := cdTipo;

  InitGrid( dbgTipo, dsTipo, 'TIPO');

  { 21-05-2008 by allan_lima }

  cdSituacao := TClientDataSet.Create(Self);

  with cdSituacao do
  begin
    FieldDefs.Add('IDSITUACAO', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    CreateDataSet;
  end;

  dsSituacao := TDataSource.Create(Self);
  dsSituacao.DataSet := cdSituacao;

  InitGrid( dbgSituacao, dsSituacao, 'SITUACAO');

  { 21-05-2008 by allan_lima }

  cdVinculo := TClientDataSet.Create(Self);

  with cdVinculo do
  begin
    FieldDefs.Add('IDVINCULO', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    CreateDataSet;
  end;

  dsVinculo := TDataSource.Create(Self);
  dsVinculo.DataSet := cdVinculo;

  InitGrid( dbgVinculo, dsVinculo, 'VINCULO');

  { 21-05-2008 by allan_lima }

  cdSalario := TClientDataSet.Create(Self);

  with cdSalario do
  begin
    FieldDefs.Add('IDSALARIO', ftString, 2);
    FieldDefs.Add('NOME', ftString, 30);
    FieldDefs.Add('ATIVO_X', ftSmallint);
    CreateDataSet;
  end;

  dsSalario := TDataSource.Create(Self);
  dsSalario.DataSet := cdSalario;

  InitGrid( dbgSalario, dsSalario, 'SALARIO');

end;  // Create

procedure TFrmPadrao.Iniciar;
begin

  pvGrupoPagamento := kGrupoPagamentoFolhaAtiva();
  pvTipoFolha := kTipoFolhaAtiva();
  db13salario.Font.Color := clRed;
  PageControl1.ActivePageIndex := 0;

  inherited;

end;

procedure TFrmPadrao.Pesquisar;
var
  SQL: TStringList;
begin

  SQL := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  GP.IDGP, GP.NOME GP, GP.IDGE, GE.NOME GE,');
    SQL.Add('  FT.IDFOLHA_TIPO, FT.NOME FOLHA_TIPO, FT.SEQUENCIA_X');
    SQL.Add('FROM');
    SQL.Add('  F_GRUPO_PAGAMENTO GP, F_GRUPO_EMPRESA GE, F_FOLHA_TIPO FT');
    SQL.Add('WHERE');
    SQL.Add('  GE.IDGE = GP.IDGE');
    SQL.EndUpdate;

    if not kOpenSQL( cdGP, SQL.Text) then
      raise Exception.Create(kGetErrorLastSQL);

    cdGP.Locate('IDGP;IDFOLHA_TIPO',
                VarArrayOf([pvGrupoPagamento,pvTipoFolha]), []);

  except
    on E:Exception do
      kErro( E.Message, 'fpadrao', 'Pesquisar()');
  end;
  finally
    SQL.Free;
  end;

  GetData();

end;  // Pesquisar

procedure TFrmPadrao.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) and (ActiveControl = dbGE) then
  begin
    if FindGrupoEmpresa( dbGE.Text, dbGE.DataSource.DataSet, Key, True) then
      GetData();

  end else if (Key = VK_RETURN) and (ActiveControl = dbGP) then
  begin
    if FindGrupoPagamento( dbGP.Text,
                           dbGP.DataSource.DataSet.FieldByName('IDGE').AsInteger,
                           dbGP.DataSource.DataSet, Key, True) then
      GetData();

  end else if (Key = VK_SPACE) and (ActiveControl is TDBGrid) and
              Assigned(TDBGrid(ActiveControl).OnDblClick) then
  begin
    TDBGrid(ActiveControl).OnDblClick(ActiveControl);
    Key := 0;

  end else if (Key = VK_RETURN) and (ActiveControl = dbEvento) and
              (pvDataSet.State in [dsInsert,dsEdit]) then
    FindEvento( dbEvento.Text, pvDataSet, Key)

  else if (Key = VK_RETURN) and (pvDataSet.State in [dsInsert,dsEdit]) and
         (ActiveControl = db13salario) then
     Key := VK_F3;

  inherited;

end;

procedure TFrmPadrao.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  with DataSet do
  begin
    FieldByName('IDGP').AsInteger := cdGP.FieldByName('IDGP').AsInteger;
    FieldByName('IDFOLHA_TIPO').AsString := cdGP.FieldByName('IDFOLHA_TIPO').AsString;
    FieldByName('JANEIRO_X').AsInteger := 1;
    FieldByName('FEVEREIRO_X').AsInteger := 1;
    FieldByName('MARCO_X').AsInteger := 1;
    FieldByName('ABRIL_X').AsInteger := 1;
    FieldByName('MAIO_X').AsInteger := 1;
    FieldByName('JUNHO_X').AsInteger := 1;
    FieldByName('JULHO_X').AsInteger := 1;
    FieldByName('AGOSTO_X').AsInteger := 1;
    FieldByName('SETEMBRO_X').AsInteger := 1;
    FieldByName('OUTUBRO_X').AsInteger := 1;
    FieldByName('NOVEMBRO_X').AsInteger := 1;
    FieldByName('DEZEMBRO_X').AsInteger := 1;
    FieldByName('SEQUENCIA').AsInteger := 0;
  end;
end;

procedure TFrmPadrao.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme('Retirar o Evento "'+
              DataSet.FieldByName('EVENTO').AsString+'" dos padrões ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmPadrao.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbEvento.SetFocus;
end;

procedure TFrmPadrao.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbEvento.SetFocus;
end;

procedure TFrmPadrao.dbEventoButtonClick(Sender: TObject);
var Key: Word;
begin
  FindEvento( '', TAKDBEdit(Sender).DataSource.DataSet, Key);
end;

procedure TFrmPadrao.mtRegistroBeforePost(DataSet: TDataSet);
var
  iCodigo: Integer;
  sGP: String;
begin

  with DataSet do
  begin
    if (FieldByName('IDPADRAO').AsInteger = 0) then
    begin
      sGP := FieldByName('IDGP').AsString;
      iCodigo :=  kMaxCodigo( 'F_PADRAO', 'IDPADRAO', -1, 'IDGP = '+sGP);
      FieldByName('IDPADRAO').AsInteger := iCodigo;
    end;
  end;

  inherited;

end;

procedure TFrmPadrao.dbGEButtonClick(Sender: TObject);
var
  Key: Word;
  bResult: Boolean;
begin

  bResult := False;

  with TAKDBEdit(Sender).DataSource do
    if (Sender = dbGE) then
       bResult := FindGrupoEmpresa( '*', DataSet, Key, True)
    else if (Sender = dbGP) then
      bResult := FindGrupoPagamento( '*', DataSet.FieldByName('IDGE').AsInteger, DataSet, Key);

  if bResult then
    GetData()

end;

procedure TFrmPadrao.dbFolhaButtonClick(Sender: TObject);
var
  Key: Word;
begin
  if PesquisaTipoFolha( '*', cdGP, Key, True) then
    GetData();
end;

procedure TFrmPadrao.GetData;
var
  iGrupoPagamento, iPadrao: Integer;
  sTipoFolha: String;
  SQL: TStringList;
  bSequencia: Boolean;
begin

  SQL := TStringList.Create;

  try

    iGrupoPagamento := cdGP.FieldByName('IDGP').AsInteger;
    sTipoFolha := cdGP.FieldByName('IDFOLHA_TIPO').AsString;
    bSequencia := (cdGP.FieldByName('SEQUENCIA_X').AsInteger = 1);

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    if bSequencia then
    SQL.Add('  S.SEQUENCIA,')  // Considerar a ordem da sequencia de calculo
    else
    SQL.Add('  P.SEQUENCIA,');  // Considerar a ordem em eventos padroes
    SQL.Add('  P.IDEVENTO, P.IDGP, P.IDPADRAO, P.IDFOLHA_TIPO, P.INFORMADO,');
    SQL.Add('  JANEIRO_X, FEVEREIRO_X, MARCO_X, ABRIL_X,');
    SQL.Add('  MAIO_X, JUNHO_X, JULHO_X, AGOSTO_X,');
    SQL.Add('  SETEMBRO_X, OUTUBRO_X, NOVEMBRO_X, DEZEMBRO_X, SALARIO13_X,');
    SQL.Add('  E.NOME EVENTO, E.TIPO_EVENTO, E.ATIVO_X');
    SQL.Add('FROM');
    SQL.Add('  F_PADRAO P, F_EVENTO E');
    if bSequencia then
      SQL.Add('  , F_SEQUENCIA S');
    SQL.Add('WHERE');
    SQL.Add('  P.IDGP = :GP AND P.IDFOLHA_TIPO = :TIPO');
    SQL.Add('  AND E.IDEVENTO = P.IDEVENTO');
    if bSequencia then
      SQL.Add('  AND S.IDGP = P.IDGP AND S.IDEVENTO = P.IDEVENTO');
    SQL.EndUpdate;

    iPadrao := pvDataSet.FieldByName('IDPADRAO').AsInteger;

    if not kOpenSQL( pvDataSet, SQL.Text, [iGrupoPagamento, sTipoFolha]) then
      Exception.Create(kGetErrorLastSQL);

    mtRegistro.IndexFieldNames := 'SEQUENCIA;IDEVENTO';

    if bSequencia then
    begin
      lbSequencia.Enabled := False;
      dbSequencia.Enabled := False;
      dbSequencia.ParentColor := True;
      pvDataSet.FieldByName('SEQUENCIA').ProviderFlags :=
        pvDataSet.FieldByName('SEQUENCIA').ProviderFlags + [pfHidden];
    end else
    begin
      lbSequencia.Enabled := True;
      dbSequencia.Enabled := True;
      dbSequencia.Color := dbInformado.Color;
      pvDataSet.FieldByName('SEQUENCIA').ProviderFlags :=
        pvDataSet.FieldByName('SEQUENCIA').ProviderFlags - [pfHidden];
    end;

    pvDataSet.Locate('IDPADRAO', iPadrao, []);

  except
    on E:Exception do
      kErro( E.Message, 'fpadrao', 'GetData()');
  end;

end;  // procedure GetData

procedure TFrmPadrao.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kEventoDrawColumnCell( Sender, Rect, DataCol, Column, State);
end;

procedure TFrmPadrao.dbgRegistroTitleClick(Column: TColumn);
begin
  kTitleClick( Column.Grid, Column, NIL);
end;

procedure TFrmPadrao.dbMarcarClick(Sender: TObject);
var
  iMarcar: Integer;
begin

  if TCheckBox(Sender).Checked then
    iMarcar := 1
  else
    iMarcar := 0;

  with mtRegistro do
    if State in [dsInsert,dsEdit] then
    begin
      FieldByName('JANEIRO_X').AsInteger := iMarcar;
      FieldByName('FEVEREIRO_X').AsInteger := iMarcar;
      FieldByName('MARCO_X').AsInteger := iMarcar;
      FieldByName('ABRIL_X').AsInteger := iMarcar;
      FieldByName('MAIO_X').AsInteger := iMarcar;
      FieldByName('JUNHO_X').AsInteger := iMarcar;
      FieldByName('JULHO_X').AsInteger := iMarcar;
      FieldByName('AGOSTO_X').AsInteger := iMarcar;
      FieldByName('SETEMBRO_X').AsInteger := iMarcar;
      FieldByName('OUTUBRO_X').AsInteger := iMarcar;
      FieldByName('NOVEMBRO_X').AsInteger := iMarcar;
      FieldByName('DEZEMBRO_X').AsInteger := iMarcar;
      FieldByName('SALARIO13_X').AsInteger := iMarcar;
    end;

end;

procedure TFrmPadrao.dtsRegistroStateChange(Sender: TObject);
var
  i: Integer;
  bEditando: Boolean;
begin
  inherited;
  bEditando := TDataSource(Sender).DataSet.State in [dsInsert,dsEdit];
  dbMarcar.Enabled := bEditando;
  for i := 1 to PageControl1.PageCount - 1 do
    PageControl1.Pages[i].TabVisible := not bEditando;
end;

procedure TFrmPadrao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrmPadrao.FormResize(Sender: TObject);
begin
  Self.WindowState := wsMaximized;
end;

{ 21-05-2008 by allan_lima }
procedure TFrmPadrao.LerFiltro( DataSet: TDataSet; const Filtro: String);
var
  iGP, iPadrao: Integer;
  s, sFieldName, sTableName, sTableFiltro: String;
begin

  iGP      := pvDataSet.FieldByName('IDGP').AsInteger;
  iPadrao  := pvDataSet.FieldByName('IDPADRAO').AsInteger;

  sFieldName := 'ID'+Filtro;
  sTableName := 'F_PADRAO_'+Filtro;
  sTableFiltro := 'F_'+Filtro;

  with TStringList.Create do
  try

    BeginUpdate;
    Add('SELECT S.'+sFieldName+', S.NOME,');
    Add('  (SELECT COUNT(*) FROM '+sTableName+' E');
    Add('   WHERE E.IDGP = :G AND E.IDPADRAO = :P');
    Add('         AND E.'+sFieldName+' = S.'+sFieldName+') AS ATIVO_X');
    Add('FROM '+sTableFiltro+' S ORDER BY 1');
    EndUpdate;

    s := DataSet.FieldByName(sFieldName).AsString;

    kOpenSQL(DataSet, Text, [iGP, iPadrao]);

    DataSet.Locate(sFieldName, s, []);

  finally
    Free;
  end;

end;  // LerFiltro

{ 21-05-2008 by allan_lima }
function TFrmPadrao.AtivarFiltro( DataSet: TDataSet; const Filtro: String): Boolean;
var
  s, sSQL, sFieldName, sTableName: String;
  iGP, iPadrao: Integer;
begin

  sFieldName := 'ID'+Filtro;
  sTableName := 'F_PADRAO_'+Filtro;

  iGP     := pvDataSet.FieldByName('IDGP').AsInteger;
  iPadrao := pvDataSet.FieldByName('IDPADRAO').AsInteger;
  s       := DataSet.FieldByName(sFieldName).AsString;

  if (DataSet.FieldByName('ATIVO_X').AsInteger = 1) then
    sSQL := 'DELETE FROM '+sTableName+' WHERE IDGP = :G AND IDPADRAO = :P AND '+sFieldName+' = :S'
  else
    sSQL := 'INSERT INTO '+sTableName+' (IDGP,IDPADRAO,'+sFieldName+') VALUES (:G,:P,:S)';

  Result := kExecSQL( sSQL, [iGP, iPadrao, s]);

end;  // AtivarFiltro

procedure TFrmPadrao.PageControl1Change(Sender: TObject);
begin
  with TPageControl(Sender) do
    if ActivePage = TabTipo then LerFiltro( cdTipo, 'TIPO')
    else if ActivePage = TabFGTS then LerFiltro( cdFGTS, 'FGTS')
    else if ActivePage = TabSituacao then LerFiltro( cdSituacao, 'SITUACAO')
    else if ActivePage = TabVinculo then LerFiltro( cdVinculo, 'VINCULO')
    else if ActivePage = TabSalario then LerFiltro( cdSalario, 'SALARIO');
end;

procedure TFrmPadrao.dbgFGTSDblClick(Sender: TObject);
begin

  if (Sender = dbgFGTS) and AtivarFiltro( cdFGTS, 'FGTS') then
    LerFiltro( cdFGTS, 'FGTS')
  else if (Sender = dbgTipo) and AtivarFiltro( cdTipo, 'TIPO') then
    LerFiltro( cdTipo, 'TIPO')
  else if (Sender = dbgSituacao) and AtivarFiltro( cdSituacao, 'SITUACAO') then
    LerFiltro( cdSituacao, 'SITUACAO')
  else if (Sender = dbgVinculo) and AtivarFiltro( cdVinculo, 'VINCULO') then
    LerFiltro( cdVinculo, 'VINCULO')
  else if (Sender = dbgSalario) and AtivarFiltro( cdSalario, 'SALARIO') then
    LerFiltro( cdSalario, 'SALARIO');

end;

procedure TFrmPadrao.dbgFGTSDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kAtivoDrawColumnCell(Sender, Rect, DataCol, Column, State, TDBGrid(Sender).Focused);
end;

procedure TFrmPadrao.mtRegistroAfterScroll(DataSet: TDataSet);
begin
  PageControl1Change(PageControl1.ActivePage);
end;

procedure TFrmPadrao.mtRegistroAfterPost(DataSet: TDataSet);
begin
  GetData();
end;

end.
