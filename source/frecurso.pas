{
Projeto FolhaLivre - Folha de Pagamento Livre
Cadastro de Recursos

Copyright (C) 2002-2007 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Histórico
=========

* 30-12-2003 - Primeira versão
* 12-05-2007 - Cadastro de Recursos (Request ID: 1717933)
}

unit frecurso;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QStdCtrls, QDBGrids, QDBCtrls,
  QDialogs, QGrids, QMask, QAKLabel, QButtons, QExtCtrls,
  {$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, StdCtrls, DBGrids, DBCtrls,
  Dialogs, Grids, Mask, AKLabel, Buttons, ExtCtrls,
  {$ENDIF}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
   Db, fdialogo, DBClient, Types;    

type
  TFrmRecurso = class(TFrmDialogo)
    lbID: TLabel;
    Label2: TLabel;
    dbID: TDBEdit;
    dbNome: TDBEdit;
    mtRegistroIDRECURSO: TIntegerField;
    mtRegistroNOME: TStringField;
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

function FindRecurso( Pesquisa: String; var Codigo, Nome: String):Boolean;

procedure PesquisaRecurso( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);

procedure CriaRecurso;

implementation

uses fdb, ftext, fsuporte, ffind;

{$R *.dfm}

function FindRecurso( Pesquisa: String; var Codigo, Nome: String):Boolean;
var
  DataSet1: TClientDataSet;
  vCodigo: Variant;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
    Pesquisa := '*';

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  DataSet1 := TClientDataSet.Create(NIL);
  SQL      := TStringList.Create;

  try

    SQL.BeginUpdate;
    SQL.Add('SELECT IDRECURSO AS ID, NOME');
    SQL.Add('FROM F_RECURSO');
    if kIsNumerico(Pesquisa) then
      SQL.Add('WHERE IDRECURSO = '+QuotedStr(Pesquisa))
    else
      SQL.Add('WHERE NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text) then
      Exit;

    with DataSet1 do
    begin
      if (RecordCount = 1) or
         kFindDataSet( DataSet1, 'Recurso',
                       Fields[1].FieldName {nome do campo a procurar},
                       vCodigo {variavel que conterá o valor retornado},
                       [foNoPanel] {opcoes de apresentacao},
                       Fields[0].FieldName {nome do campo a retornado}) then
      begin
        Codigo := Fields[0].AsString;
        Nome   := Fields[1].AsString;
        Result := True;
      end;
    end;  // with DataSet1

  finally
    DataSet1.Free;
    SQL.Free;
  end;

end;  // function FindRecurso

procedure PesquisaRecurso( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);
var
  sCodigo, sNome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDRECURSO';

  if FindRecurso( Pesquisa, sCodigo, sNome) then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField(FieldName)) then
          DataSet.FieldByName(FieldName).AsString := sCodigo;
        if Assigned(DataSet.FindField('RECURSO')) then
          DataSet.FieldByName('RECURSO').AsString := sNome;
      end;

    end;

  end else
  begin
    kErro('Recurso não encontrado !!!');
    Key := 0;
  end;

end;  // procedure PesquisaRecurso

procedure CriaRecurso;
begin

  with TFrmRecurso.Create(Application) do
    try
      RxTitulo.Caption := ' · Listagem de Recursos';
      pvTabela := 'F_RECURSO';
      Iniciar();
      ShowModal;
    finally
      Free;
    end;

end;

procedure TFrmRecurso.mtRegistroBeforeDelete(DataSet: TDataSet);
begin
  if not kConfirme( 'Excluir o Recurso "'+DataSet.FieldByName('NOME').AsString + '" ?') then
    SysUtils.Abort
  else
    inherited;
end;

procedure TFrmRecurso.mtRegistroBeforeEdit(DataSet: TDataSet);
begin
  inherited;
  dbNome.SetFocus;
  lbID.Enabled := False;
  dbID.Enabled := False;
end;

procedure TFrmRecurso.mtRegistroBeforeInsert(DataSet: TDataSet);
begin
  inherited;
  dbID.SetFocus
end;

procedure TFrmRecurso.mtRegistroBeforePost(DataSet: TDataSet);
begin
  with DataSet do
    if (FieldByName('IDRECURSO').AsInteger = 0) then
      FieldByName('IDRECURSO').AsInteger := kMaxCodigo( pvTabela, 'IDRECURSO', pvEmpresa);
  inherited;
end;

procedure TFrmRecurso.mtRegistroAfterCancel(DataSet: TDataSet);
begin
  inherited;
  lbID.Enabled := True;
  dbID.Enabled := True;
end;

end.
