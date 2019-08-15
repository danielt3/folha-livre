{
FolhaLivre - Folha de Pagamento
Copyright (C) 2002 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

}

unit findice;

{$I flivre.inc}

interface

uses
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, QGrids, QMask, QAKLabel, QButtons, QExtCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, Grids, Mask, AKLabel, Buttons, ExtCtrls,
  {$ENDIF}
  SysUtils, Classes, Db, fdialogo, DBClient, Types;

type
  TFrmIndice = class(TFrmDialogo)
    lbID: TLabel;
    Label2: TLabel;
    dbID: TDBEdit;
    dbNome: TDBEdit;
    mtRegistroNOME: TStringField;
    mtRegistroIDINDICE: TIntegerField;
    mtRegistroIDEMPRESA: TIntegerField;
    procedure mtRegistroBeforeDelete(DataSet: TDataSet);
    procedure mtRegistroBeforeEdit(DataSet: TDataSet);
    procedure mtRegistroBeforeInsert(DataSet: TDataSet);
    procedure mtRegistroBeforePost(DataSet: TDataSet);
    procedure mtRegistroAfterCancel(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FindIndice( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome: String):Boolean;

procedure PesquisaIndice( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '');

procedure CriaIndice;


implementation

uses fdb, ftext, fsuporte, ffind;

{$R *.dfm}

function FindIndice( Pesquisa: String; Empresa: Integer;
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
    if not InputQuery( 'Pesquisa de Índices',
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
    SQL.Add('SELECT IDINDICE, NOME FROM F_INDICE');
    SQL.Add('WHERE IDEMPRESA = :EMPRESA');
    if kNumerico(Pesquisa) then
      SQL.Add('AND IDINDICE = '+Pesquisa)
    else
      SQL.Add('AND NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet, SQL.Text, [Empresa]) then
      Exit;

     with DataSet do
     begin
       if (RecordCount = 1) or
          kFindDataSet( DataSet, 'Índices',
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

end;  // function FindIndice

procedure PesquisaIndice( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; FieldName: String = '');
var
  Codigo: Integer;
  Nome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDINDICE';

  if FindIndice( Pesquisa, Empresa, Codigo, Nome) then
  begin
    if Assigned(DataSet) and (DataSet.State in [dsInsert,dsEdit]) then
    begin
      if Assigned(DataSet.FindField(FieldName)) then
        DataSet.FieldByName(FieldName).AsInteger := Codigo;
      if Assigned(DataSet.FindField('INDICE')) then
        DataSet.FieldByName('INDICE').AsString := Nome;
    end;
  end else
  begin
    kErro('Índice não encontrado !!!');
    Key := 0;
  end;

end;  // procedure PesquisaIndice

procedure CriaIndice;
begin

  with TFrmIndice.Create(Application) do
    try
      if (pvEmpresa = 0) then
        Caption := 'Indices Globais';
      RxTitulo.Caption := ' · Listagem de '+Caption;
      pvTabela := 'F_INDICE';
      Iniciar();
      ShowModal;
    finally
      Free;
    end;

end;  // procedure

procedure TFrmIndice.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir o Indice "'+DataSet.FieldByName('NOME').AsString + '" ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmIndice.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmIndice.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus
end;

procedure TFrmIndice.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDINDICE').AsInteger = 0) then
      FieldByName('IDINDICE').AsInteger := kMaxCodigo( pvTabela, 'IDINDICE', pvEmpresa);
  inherited;
end;

procedure TFrmIndice.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

end.
