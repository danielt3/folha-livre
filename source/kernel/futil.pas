{
Projeto FolhaLivre - Folha de Pagamento Livre
Funções de Pesquisa de Funcionarios

Copyright (c) 2004-2007 Allan Lima, Brazil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@project-name: FolhaLivre
@project-email: folha_livre@yahoo.com.br
@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br

Histórico

* 02/04/2007 - Adicionada a função "kFolhaAtiva()"
}

unit futil;

{$I flivre.inc}

interface

uses
  Classes, SysUtils,
  {$IFDEF CLX}QDialogs,{$ENDIF}
  {$IFDEF VCL}Dialogs,{$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, DBClient;

procedure PesquisaFuncionario( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False);

function kProcuraFuncionario( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome, CPF: String):Boolean;

function ExisteFuncionario( Empresa, Codigo: Integer; var Nome, CPF: String;
  const IniciarTransacao: Boolean = True):Boolean; overload;

function ExisteFuncionario( Empresa, Codigo: Integer;
  const IniciarTransacao: Boolean = True):Boolean; overload;

function kFolhaAtiva: Integer;
function kTipoFolhaAtiva: String;
function kEmpresaAtiva: Integer;
function kGrupoEmpresa: Integer;
function kGrupoPagamentoFolhaAtiva: Integer;

implementation

uses ftext, fdb, ffind, fdeposito;

const
  C_UNIT = 'futil.pas';

procedure PesquisaFuncionario( Pesquisa: String; Empresa: Integer;
  DataSet: TDataSet; var Key: Word; AutoEdit: Boolean = False);
var
  iCodigo: Integer;
  sNome, sCPF: String;
  bSave: Boolean;
begin

  if kProcuraFuncionario( Pesquisa, Empresa, iCodigo, sNome, sCPF) then
  begin

    if Assigned(DataSet) then
    begin

      bSave := False;

      if AutoEdit and (DataSet.State = dsBrowse) then
      begin
        DataSet.Edit;
        bSave := True;
      end;

      if (DataSet.State in [dsInsert,dsEdit]) then
      begin
        if Assigned(DataSet.FindField('IDFUNCIONARIO')) then
          DataSet.FieldByName('IDFUNCIONARIO').AsInteger := iCodigo;
        if Assigned(DataSet.FindField('FUNCIONARIO')) then
          DataSet.FieldByName('FUNCIONARIO').AsString := sNome
        else if Assigned(DataSet.FindField('NOME')) then
          DataSet.FieldByName('NOME').AsString := sNome;
        if Assigned(DataSet.FindField('CPF_CGC')) then
          DataSet.FieldByName('CPF_CGC').AsString := sCPF;
      end;

      if bSave and (DataSet.State in [dsInsert,dsEdit]) then
        DataSet.Post;

    end;

  end else
  begin
    kErro('Funcionário não encontrado !!!');
    Key := 0;
  end;

end;

function kProcuraFuncionario( Pesquisa: String; Empresa: Integer;
  var Codigo: Integer; var Nome, CPF: String):Boolean;
var
  DataSet: TClientDataSet;
  vCodigo: Variant;
  iLen: Integer;
  sWhere: String;
  SQL: TStringList;
begin

  Result := False;

  if (Length(Pesquisa) = 0) then
  begin
    Pesquisa := '*';
    if not InputQuery( 'Pesquisa de Funcionário',
                       'Informe um texto para pesquisar', Pesquisa) then
      Exit;
  end;

  iLen := Length(Pesquisa);

  if (iLen = 0) then
    Exit;

  Pesquisa := kSubstitui( UpperCase(Pesquisa), '*', '%');

  if (Copy(Pesquisa, 1, 2) = 'RG') then
  begin
    Pesquisa := Copy( Pesquisa, 3, iLen);
    sWhere   := 'P.RG LIKE '+QuotedStr(Pesquisa+'%');
  end else if (Pesquisa[1] = '.') then
  begin
    Pesquisa := Copy( Pesquisa, 2, iLen);
    sWhere   := 'P.APELIDO LIKE '+QuotedStr(Pesquisa+'%');
  end else if (iLen < 11) and kNumerico(Pesquisa) then
    sWhere := 'F.IDFUNCIONARIO = '+Pesquisa
  else if (iLen = 11) and kNumerico(Pesquisa) then
    sWhere := 'P.CPF_CGC = '+QuotedStr(Pesquisa)
  else
    sWhere := 'P.NOME LIKE '+QuotedStr(Pesquisa+'%');

  sWhere  := 'F.IDEMPRESA = '+IntToStr(Empresa)+' AND '+sWhere;
  DataSet := TClientDataSet.Create(NIL);
  SQL     := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  F.IDFUNCIONARIO AS ID,');
    SQL.Add('  P.NOME, P.APELIDO,');
    SQL.Add('  P.CPF_CGC AS CPF');
    SQL.Add('FROM');
    SQL.Add('  FUNCIONARIO F');
    SQL.Add('LEFT JOIN PESSOA P ON');
    {$IFDEF FLIVRE}
    SQL.Add('  (P.IDEMPRESA = '+IntToStr(Empresa)+') AND');
    {$ENDIF}
    SQL.Add(' (P.IDPESSOA = F.IDPESSOA)');

    SQL.Add('WHERE '+sWhere);
    SQL.EndUpdate;

    kOpenSQL( DataSet, SQL.Text);

    if (DataSet.RecordCount = 1) or
        kFindDataSet( DataSet, 'Funcionários', 'NOME', vCodigo, [], 'ID') then
    begin
      Codigo  := DataSet.FieldByName('ID').AsInteger;
      Nome    := DataSet.FieldByName('NOME').AsString;
      CPF     := DataSet.FieldByName('CPF').AsString;
      Result := True;
    end;

  except
    on E:Exception do
      kErro(E.Message, C_UNIT, 'kProcuraFuncionario()');
  end;
  finally
    SQL.Free;
    DataSet.Free;
  end;

end;  // kProcuraFuncionario

function ExisteFuncionario( Empresa, Codigo: Integer; var Nome, CPF: String;
  const IniciarTransacao: Boolean = True):Boolean;
var
  SQL: TStringList;
  pvDataSet: TClientDataSet;
begin

  Result := False;

  if (Empresa < 1) or (Codigo < 1) then
    Exit;

  pvDataSet := TClientDataSet.Create(NIL);
  SQL       := TStringList.Create;

  try try

    SQL.BeginUpdate;
    SQL.Add('SELECT');
    SQL.Add('  F.IDFUNCIONARIO, P.NOME,');
    {$IFDEF FLIVRE}SQL.Add('  F.IDTIPO AS TIPO,');{$ENDIF}
    SQL.Add('  P.CPF_CGC AS CPF');
    SQL.Add('FROM');
    SQL.Add('  FUNCIONARIO F');
    SQL.Add('LEFT JOIN PESSOA P ON (P.IDPESSOA = F.IDPESSOA)');
    SQL.Add('WHERE');
    SQL.Add('  F.IDEMPRESA = :EMPRESA AND F.IDFUNCIONARIO = :CODIGO');
    SQL.EndUpdate;

    if not kOpenSQL( pvDataSet, SQL.Text,
                     [Empresa, Codigo], IniciarTransacao) then
      raise Exception.Create( kGetErrorLastSQL);

    with pvDataSet do
    begin
      First;
      if (RecordCount = 1) then
      begin
        Nome   := FieldByName('NOME').AsString;
        CPF    := FieldByName('CPF').AsString;
        Result := True;
      end;
    end;

  except
    on E:Exception do
      kErro( E.Message, C_UNIT, 'ExisteFuncionario()');
  end;
  finally
    SQL.Free;
    pvDataSet.Free;
  end;

end;  // ExisteFuncionario

function ExisteFuncionario( Empresa, Codigo: Integer;
  const IniciarTransacao: Boolean = True):Boolean;
var
  sNome, sCPF: String;
begin
  Result := ExisteFuncionario( Empresa, Codigo, sNome, sCPF);
end;

function kFolhaAtiva: Integer;
begin
  Result := StrToIntDef( kGetDeposito('FOLHA_ID'), 0);
end;

function kTipoFolhaAtiva: String;
begin
  Result := kGetDeposito('EMPRESA_TP');
end;

function kEmpresaAtiva: Integer;
begin
  Result := StrToIntDef( kGetDeposito('EMPRESA_ID'), 0);
end;

function kGrupoEmpresa: Integer;
begin
  Result := StrToIntDef( kGetDeposito('EMPRESA_GE'), 0);
end;

function kGrupoPagamentoFolhaAtiva: Integer;
begin
   Result := StrToIntDef( kGetDeposito('FOLHA_GP'), 0);
end;

end.
