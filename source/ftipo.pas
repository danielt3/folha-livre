{
FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002 Allan Kardek Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

@file-name: ftipo.pas
@license: GNU GPL
@autor-name: Allan Kardek Lima
@email: allan_kardek@yahoo.com.br;folha_livre@yahoo.com.br
@date: 30-12-2003
}

unit ftipo;

{$I flivre.inc}

interface

uses
  {$IFDEF CLX}QDialogs,{$ENDIF}
  {$IFDEF VCL}Dialogs,{$ENDIF}
  SysUtils, Classes, DB, DBClient, MidasLib;

function FindTipo( Pesquisa: String; var Codigo, Nome: String):Boolean;

procedure PesquisaTipo( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);

implementation

uses fdb, ffind, ftext;

function FindTipo( Pesquisa: String; var Codigo, Nome: String):Boolean;
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
    SQL.Add('SELECT IDTIPO AS ID, NOME');
    SQL.Add('FROM F_TIPO');
    if kNumerico(Pesquisa) then
      SQL.Add('WHERE IDTIPO = '+QuotedStr(Pesquisa))
    else
      SQL.Add('WHERE NOME LIKE '+QuotedStr(Pesquisa+'%'));
    SQL.EndUpdate;

    if not kOpenSQL( DataSet1, SQL.Text) then
      Exit;

    with DataSet1 do
    begin
      if (RecordCount = 1) or
         kFindDataSet( DataSet1, 'Tipo',
                       Fields[1].FieldName {nome do campo a procurar},
                       vCodigo {variavel que conter� o valor retornado},
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

end;  // function FindTipo

procedure PesquisaTipo( Pesquisa: String;
  DataSet: TDataSet; var Key: Word; FieldName: String = '';
  AutoEdit: Boolean = False);
var
  sCodigo, sNome: String;
begin

  if (FieldName = '') then
    FieldName := 'IDTIPO';

  if FindTipo( Pesquisa, sCodigo, sNome) then
  begin

    if Assigned(DataSet) then
    begin

      if AutoEdit and not(DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Edit;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField(FieldName)) then
          DataSet.FieldByName(FieldName).AsString := sCodigo;
        if Assigned(DataSet.FindField('TIPO')) then
          DataSet.FieldByName('TIPO').AsString := sNome;
      end;

    end;

  end else
  begin
    kErro('Tipo n�o encontrado !!!');
    Key := 0;
  end;

end;  // procedure PesquisaTipo

end.
