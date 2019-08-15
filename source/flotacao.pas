{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Lota��o

Copyright (C) 2007, Allan Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
}

unit flotacao;

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
  TFrmLotacao = class(TFrmDialogo)
    mtRegistroIDEMPRESA: TIntegerField;
    mtRegistroNOME: TStringField;
    Label2: TLabel;
    lbLotacao: TLabel;
    dbNome: TDBEdit;
    dbLotacao: TDBEdit;
    mtRegistroIDLOTACAO: TIntegerField;
    mtRegistroDEPARTAMENTO: TIntegerField;
    mtRegistroSETOR: TIntegerField;
    mtRegistroSECAO: TIntegerField;
    mtRegistroCODIGO: TStringField;
    mtRegistroATIVO_X: TSmallintField;
    mtRegistroENDERECO: TStringField;
    mtRegistroCIDADE: TStringField;
    mtRegistroBAIRRO: TStringField;
    mtRegistroRESPONSAVEL: TStringField;
    mtRegistroCEP: TStringField;
    mtRegistroTELEFONE: TStringField;
    mtRegistroFAX: TStringField;
    lbEndereco: TLabel;
    dbEndereco: TDBEdit;
    lbBairro: TLabel;
    dbBairro: TDBEdit;
    dbCidade: TDBEdit;
    lbCidade: TLabel;
    dbCEP: TDBEdit;
    lbCEP1: TLabel;
    lbResponsavel: TLabel;
    dbResponsavel: TDBEdit;
    dbTelefone: TDBEdit;
    lbTelefone: TLabel;
    lbFax: TLabel;
    dbFax: TDBEdit;
    dbAtivo: TDBCheckBox;
    lbDepartamento: TLabel;
    dbDepartamento: TDBEdit;
    dbSetor: TDBEdit;
    lbSetor: TLabel;
    lbSecao: TLabel;
    dbSecao: TDBEdit;
    mtRegistroTIPO: TStringField;
    procedure mtRegistroCalcFields(DataSet: TDataSet);
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroAfterPost(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure btnImprimirClick(Sender: TObject);
    procedure dbgRegistroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure mtRegistroNewRecord(DataSet: TDataSet);
    procedure dbgRegistroTitleClick(Column: TColumn);    
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Iniciar; override;
  end;

procedure CriaLotacao;

function FindLotacao( Pesquisa: String; Empresa: Integer;
  var Lotacao: Integer; var Nome: String; var Departamento, Setor, Secao: Integer):Boolean;

procedure PesquisaLotacao( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);

implementation

uses ftext, fsuporte, fsystem, fdb, fprint, fdepvar, ffind, sys_empresa_dados;

{$R *.dfm}

function FindLotacao( Pesquisa: String; Empresa: Integer;
  var Lotacao: Integer; var Nome: String; var Departamento, Setor, Secao: Integer):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa de Lota��o',
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
    SQL.Add('SELECT IDLOTACAO AS ID, NOME, DEPARTAMENTO, SETOR, SECAO');
    SQL.Add('FROM F_LOTACAO');
    SQL.Add('WHERE IDEMPRESA = :EMPRESA');
    if kIsNumerico(Pesquisa) then
      SQL.Add('AND IDLOTACAO = '+Pesquisa)
    else
      SQL.Add('AND NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text, [Empresa]) then
      Exit;

    with DataSet do
    begin
      if (RecordCount = 1) or
         kFindDataSet( DataSet, 'Lota��o',
                       Fields[1].FieldName, vCodigo, [foNoPanel],
                       Fields[0].FieldName) then
      begin
        Lotacao := Fields[0].AsInteger;
        Nome    := Fields[1].AsString;
        Departamento  := Fields[2].AsInteger;
        Setor  := Fields[3].AsInteger;
        Secao  := Fields[4].AsInteger;
        Result := True;
      end;
    end;  // with DataSet

  finally
    DataSet.Free;
    SQL.Free;
  end;

end;  // FindLotacao

procedure PesquisaLotacao( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);
var
  iLotacao, iDepartamento, iSetor, iSecao: Integer;
  sNome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDLOTACAO';

  if FindLotacao( Pesquisa, Empresa, iLotacao, sNome,
                  iDepartamento, iSetor, iSecao) then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField(FieldName)) then
          DataSet.FieldByName(FieldName).AsInteger := iLotacao;
        if Assigned(DataSet.FindField('LOTACAO')) then
          DataSet.FieldByName('LOTACAO').AsString := sNome;
      end;

    end;

  end else
  begin
    kErro('Lota��o n�o encontrada !!!');
    Key := 0;
  end;

end;  // PesquisaLotacao

procedure CriaLotacao;
begin

  with TFrmLotacao.Create(Application) do
  try
    Iniciar();
    ShowModal;
  finally
    Free;
  end;

end;  // CriaLotacao

procedure TFrmLotacao.Iniciar;
var
  i, iMaxWidth: Integer;
begin

  pvTabela := 'F_LOTACAO';
  pvWhere  := 'IDLOTACAO > 0';

  inherited;

  pvDataSet.First;

  if Assigned(Application.MainForm) then
  begin
    ClientHeight := Round(Application.MainForm.Height * 0.70);
    ClientWidth := Round(Application.MainForm.Width * 0.75);
  end;

  // Calcular a largura do formulario para conter o Grid
  iMaxWidth  := Round( Rate * (30 + dbgRegistro.Columns.Count));
  for i := 0 to dbgRegistro.Columns.Count-1 do
    iMaxWidth := iMaxWidth + dbgRegistro.Columns[i].Width;

  if (dbgRegistro.ClientWidth > iMaxWidth) then
    dbgRegistro.Columns[1].Width := dbgRegistro.Columns[1].Width +
                                    (dbgRegistro.ClientWidth - iMaxWidth);

  dbgRegistro.OnTitleClick := dbgRegistroTitleClick;
                                    
end;  // iniciar

procedure TFrmLotacao.mtRegistroCalcFields(DataSet: TDataSet);
begin
  with DataSet do
    FieldByName('CODIGO').AsString :=
             kStrZero( FieldByName('DEPARTAMENTO').AsInteger, 3)+'.'+
             kStrZero( FieldByName('SETOR').AsInteger, 3)+'.'+
             kStrZero( FieldByName('SECAO').AsInteger, 3);

end;

procedure TFrmLotacao.mtRegistroBeforeDelete(DataSet: TDataSet);
var
  sNome: String;
begin
  sNome := QuotedStr(DataSet.FieldByName('NOME').AsString);
  if not (kConfirme( 'Excluir a Lota��o '+QuotedStr(sNome)+' ?')) then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmLotacao.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  dbDepartamento.SetFocus;
  lbLotacao.Enabled := False;
  dbLotacao.Enabled := False;
end;

procedure TFrmLotacao.mtRegistroAfterPost(DataSet: TDataSet);
begin
  lbLotacao.Enabled := True;
  dbLotacao.Enabled := True;
end;

procedure TFrmLotacao.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  dbLotacao.SetFocus;
end;

procedure TFrmLotacao.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
  begin
    if (FieldByName('IDLOTACAO').AsInteger = 0) and (State = dsInsert) then
      FieldByName('IDLOTACAO').AsInteger := kMaxCodigo( pvTabela, 'IDLOTACAO', pvEmpresa);
    if (FieldByName('DEPARTAMENTO').AsInteger = 0) then
      FieldByName('SETOR').AsInteger := 0;
    if (FieldByName('SETOR').AsInteger = 0) then
      FieldByName('SECAO').AsInteger := 0;
    if (FieldByName('DEPARTAMENTO').AsInteger = 0) or
       (FieldByName('SETOR').AsInteger = 0) or (FieldByName('SECAO').AsInteger = 0) then
      FieldByName('TIPO').AsString := 'S'
    else
      FieldByName('TIPO').AsString := 'A';
  end;
  inherited;
end;

procedure TFrmLotacao.btnImprimirClick(Sender: TObject);
var
  Dep: TDeposito;
begin
  Dep := TDeposito.Create;
  try
    Dep.SetDeposito( 'TITULO', 'CADASTRO DE LOTACOES');
    Dep.SetDeposito( 'MARGEM_DIREITA', 132);
    Dep.SetDeposito( 'COMPRIMIDO', True);
    Dep.SetDeposito( 'TOTAL', False);
    kPrintGrid( dbgRegistro, '', False, Dep);
  finally
    Dep.Free;
  end;
end;

procedure TFrmLotacao.dbgRegistroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  kDrawColumnCell( Sender, Rect, DataCol, Column, State, TWinControl(Sender).Focused);
  if (Column.Field.DataSet.FieldByName('TIPO').AsString = 'S') then   // Sintetico
    TDBGrid(Sender).Canvas.Font.Color := clRed;
  if (Column.Field.DataSet.FieldByName('ATIVO_X').AsInteger = 0) then   // Inativo
    TDBGrid(Sender).Canvas.Font.Style := [fsStrikeOut];
  TDBGrid(Sender).DefaultDrawColumnCell( Rect, DataCol, Column, State);
end;

procedure TFrmLotacao.mtRegistroNewRecord(DataSet: TDataSet);
begin
  inherited;
  DataSet.FieldByName('ATIVO_X').AsInteger := 1;
end;

procedure TFrmLotacao.dbgRegistroTitleClick(Column: TColumn);
begin
  if (Column.Field.FieldName <> 'CODIGO') then
    inherited;
end;

end.
