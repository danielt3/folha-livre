{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Plano de Conta

Copyright (C) 2002-2005, Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br;allan-kardek@bol.com.br
}

unit fplano;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  Qt, QGraphics, QControls, QForms, QDialogs, QExtCtrls, QStdCtrls,
  QDBCtrls, QMask, QGrids, QDBGrids, QComCtrls, QButtons,
  {$IFDEF AK_LABEL}QAKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF VCL}
  Windows, Messages, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  DBCtrls, Mask, Grids, DBGrids, ComCtrls, Buttons,
  {$IFDEF AK_LABEL}AKLabel,{$ENDIF}
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  fbase, fdialogo, DB, DBClient;

type
  TFrmPlano = class(TFrmDialogo)
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroIDPLANO: TIntegerField;
    mtRegistroNOME: TStringField;
    mtRegistroCODIGO: TStringField;
    mtRegistroTIPO: TStringField;
    mtRegistroCODIGO2: TStringField;
    mtRegistroNOME2: TStringField;
    mtRegistroRETIFICADORA_X: TSmallintField;
    mtRegistroIDPLANO_GRUPO: TIntegerField;
    Label1: TLabel;
    Label2: TLabel;
    lbID: TLabel;
    Label3: TLabel;
    dbOrdem: TDBEdit;
    dbNome: TDBEdit;
    dbID: TDBEdit;
    dbGrupo: TDBLookupComboBox;
    dbTipo: TDBCheckBox;
    Label4: TLabel;
    dbPartida: TDBEdit;
    mtRegistroIDPARTIDA: TIntegerField;
    procedure mtRegistroCalcFields(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure dbgRegistroTitleClick(Column: TColumn);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnImprimirClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    cdGrupo: TClientDataSet;
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

function MaskPlano:String;
procedure CriaPlano();

implementation

uses ftext, fsuporte, fsystem, fdb, fprint, fdepvar, fpesqplano;

{$R *.dfm}

function MaskPlano:String;
begin
  Result := kGetSystem( 'PLANO_CONTA_MASCARA', '9\.99\.99\.999;0');
end;

procedure CriaPlano();
begin

  with TFrmPlano.Create(Application) do
  try
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // CriaPlano

procedure TFrmPlano.Iniciar;
var
  dsGrupo: TDataSource;
  sMask: String;
begin

  dbgRegistro.Font.Name := 'Courier New';

  cdGrupo := TClientDataSet.Create(Self);
  kSQLSelectFrom( cdGrupo, 'PLANO_GRUPO', pvEmpresa);
  dsGrupo := TDataSource.Create(Self);
  dsGrupo.DataSet := cdGrupo;

  dbGrupo.ListSource := dsGrupo;
  dbGrupo.ListField  := 'NOME';
  dbGrupo.KeyField   := 'IDPLANO_GRUPO';
  dbGrupo.DropDownRows := cdGrupo.RecordCount;

  sMask := MaskPlano();

  pvDataSet.FieldByName('CODIGO').EditMask := sMask;

  pvTabela := 'PLANO_CONTA';
  pvWhere  := 'IDPLANO > 0';

  inherited;

  kTitleBtnClick( mtRegistro.FieldByName('CODIGO') );
  pvDataSet.First;

end;

procedure TFrmPlano.mtRegistroCalcFields(DataSet: TDataSet);
var
  Texto:String;
  nPos:Integer;
begin

  Texto := StringOfChar( #32, Length(DataSet.FieldByName('CODIGO').AsString)*2);
  Texto := Texto+DataSet.FieldByName('NOME').AsString;

  DataSet.FieldByName('NOME2').AsString := Texto;

  Texto := DataSet.FieldByName('CODIGO').DisplayText;
  nPos  := Pos( #32, Texto);

  if (nPos > 0) then
    Texto := Copy( Texto, 1, nPos-1);

  if (Length(Texto) > 0) and (Texto[Length(Texto)] = '.') then
    Texto := Copy( Texto, 1, Length(Texto)-1);

  DataSet.FieldByName('CODIGO2').AsString := Texto;

end;

procedure TFrmPlano.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := QuotedStr(DataSet.FieldByName('NOME').AsString);
  if not (kConfirme( 'Excluir a Conta '+sNome+' ?')) then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmPlano.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbOrdem.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmPlano.mtRegistroAfterPost(DataSet: TDataSet);
begin
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

procedure TFrmPlano.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbOrdem.SetFocus;
end;

procedure TFrmPlano.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if (FieldByName('IDPLANO').AsInteger = 0) and (State = dsInsert) then
      FieldByName('IDPLANO').AsInteger := kMaxCodigo( 'PLANO_CONTA', 'IDPLANO', pvEmpresa);
    if (FieldByName('TIPO').AsString = 'S') then
      FieldByName('IDPLANO_GRUPO').AsInteger := 0;
    if (Copy(FieldByName('NOME').AsString, 1, 3) = '(-)') then
      FieldByName('RETIFICADORA_X').AsInteger := 1
    else
      FieldByName('RETIFICADORA_X').AsInteger := 0;
  end;
  inherited;
end;

procedure TFrmPlano.dbgRegistroTitleClick(Column: TColumn);
begin
  if (Column.Field.FieldName = 'CODIGO2') then
    kTitleClick( Column.Grid, Column, Column.Field.DataSet.FieldByName('CODIGO') )
  else if (Column.Field.FieldName = 'NOME2') then
    kTitleClick( Column.Grid, Column, Column.Field.DataSet.FieldByName('NOME') )
  else
    inherited;
end;

procedure TFrmPlano.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  with Column.Field.DataSet do
  begin
    if Length(FieldByName('CODIGO').AsString) = 1 then
      TDBGrid(Sender).Canvas.Font.Style := TDBGrid(Sender).Canvas.Font.Style + [fsBold];
    if FieldByName('TIPO').AsString = 'S' then
      TDBGrid(Sender).Canvas.Font.Color := clRed
    else
      TDBGrid(Sender).Canvas.Font.Color := clBlack;
    if FieldByName('RETIFICADORA_X').AsInteger = 1 then
      TDBGrid(Sender).Canvas.Font.Color := clBlue;
  end;  // with
  TDBGrid(Sender).DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

procedure TFrmPlano.btnNovoClick(Sender: TObject);
var
  sClassificacao: String;
begin
  sClassificacao := pvDataSet.FieldByName('CODIGO').AsString;
  pvDataSet.Next;
  pvDataSet.Insert;
pvDataSet.FieldByName('CODIGO').AsString := sClassificacao;
end;

procedure TFrmPlano.btnEditarClick(Sender: TObject);
begin
  pvDataSet.Edit;
end;

procedure TFrmPlano.btnGravarClick(Sender: TObject);
begin
  pvDataSet.Post;
end;

procedure TFrmPlano.btnCancelarClick(Sender: TObject);
begin
  pvDataSet.Cancel;
end;

procedure TFrmPlano.btnExcluirClick(Sender: TObject);
begin
  pvDataSet.Delete;
end;

procedure TFrmPlano.btnImprimirClick(Sender: TObject);
var
  Dep: TDeposito;
begin
  Dep := TDeposito.Create;
  try
    Dep.SetDeposito( 'TITULO', 'PLANO DE CONTAS');
    Dep.SetDeposito( 'MARGEM_DIREITA', 132);
    Dep.SetDeposito( 'COMPRIMIDO', True);
    Dep.SetDeposito( 'TOTAL', False);
    kPrintGrid( dbgRegistro, '', False, Dep);
  finally
    Dep.Free;      
  end;
end;

procedure TFrmPlano.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  iPlano: Integer;
  sCodigo, sNome, sTipo: String;
begin
  if (ActiveControl = dbPartida) and (Key = VK_F12) then
  begin
    if kFindPlano( pvEmpresa, '', iPlano, sCodigo, sNome, sTipo) and
       (pvDataSet.State in [dsInsert,dsEdit]) then
      pvDataSet.FieldByName('IDPARTIDA').AsInteger := iPlano; 
  end;
  inherited;
end;

end.
