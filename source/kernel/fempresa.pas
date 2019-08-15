{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (C) 2002 Allan Lima

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
}

{$I flivre.inc}

unit fempresa;

interface

uses
  Classes, SysUtils, fdepstr, fdeposito;

function kGetEmpresaNome():String;stdcall;
procedure kOpenEmpresa;stdcall;
function kGetEmpresa( Nome: String; Length: Integer = 0):String;stdcall;
procedure kFreeEmpresa;stdcall;
procedure kSetEmpresa( Nome: String; const Valor: String);stdcall;
procedure kEmpresaLojaPadrao;stdcall;
procedure kEmpresaLoader;stdcall;

implementation

uses
  {$IFDEF MSWINDOWS}MidasLib,{$ENDIF}
  {$IFDEF LINUX}Midas,{$ENDIF}
  DB, DBClient, fdb, ftext, fusuario, fsuporte, fuser;

var
  lEmpresa: TDepStr;

function kGetEmpresaNome():String;
begin
  Result := kGetEmpresa( 'NOME', 50);
end;

procedure kOpenEmpresa;
var
  cdEmpresa: TClientDataSet;
begin

  if not Assigned(lEmpresa) then
    lEmpresa := TDepStr.Create;

  lEmpresa.Clear;
  cdEmpresa := TClientDataSet.Create(NIL);

  try try

    if not kExistTable('SYS_EMPRESA') then
    begin

      if not kExecSQL( 'CREATE TABLE SYS_EMPRESA ('#13+
                       '    CHAVE VARCHAR(15) NOT NULL,'#13+
                       '    VALOR VARCHAR(200),'#13+
                       '    ATIVO SMALLINT DEFAULT 1 NOT NULL)') then
        raise Exception.Create('');

      if not kExecSQL( 'ALTER TABLE SYS_EMPRESA'#13+
                       'ADD CONSTRAINT PK_SYS_EMPRESA PRIMARY KEY (CHAVE)') then
        raise Exception.Create('');

    end;

    if not kOpenSQL( cdEmpresa, 'SYS_EMPRESA', 'ATIVO = 1', []) then
      raise Exception.Create('');

    with cdEmpresa do
    begin
      First;
      while not EOF do
      begin
        kSetEmpresa( FieldByName('CHAVE').AsString,
                     FieldByName('VALOR').AsString);
        Next;
      end;  // while not EOF
    end;  // with cdEmpresa

  except
    on E:Exception do
      kErro(E.Message);
  end;

  finally
    cdEmpresa.Free;
  end;

end;

procedure kSetEmpresa( Nome: String; const Valor: String);
begin
  if not Assigned(lEmpresa) then
    lEmpresa := TDepStr.Create;
  lEmpresa.SetValue( Nome, Valor);
end;

function kGetEmpresa( Nome: String; Length: Integer = 0):String;
var
 i, iRandom: Integer;
begin

  if not Assigned(lEmpresa) then
    lEmpresa := TDepStr.Create;

  Result := lEmpresa.GetValue(Nome);

  if (Result = '') and (Length > 0) then
  begin
    Randomize;
    for i := 1 to Length do
    begin
      iRandom := Random(255);
      if (iRandom = 0) then iRandom := 1;
      Result  := Result + Chr(iRandom);
    end;
  end;

end;

procedure kFreeEmpresa;
begin
  lEmpresa.Free;
end;

//*****

procedure kEmpresaLojaPadrao;
var
  cdEmpresa, cdLoja: TClientDataSet;
  sEmpresa, sLoja, sGE: String;

  procedure Empresa;
  begin

    if kExistTable('EMPRESA') then
      Exit;

    if not kExecSQL( 'CREATE TABLE EMPRESA (IDEMPRESA ID NOT NULL,'#13+
                     'NOME NOME NOT NULL, IDGE ID NOT NULL)') then
      Exit;

    if kExecSQL( 'ALTER TABLE EMPRESA ADD CONSTRAINT PK_EMPRESA PRIMARY KEY (IDEMPRESA)') then
      Exit;

    if kExecSQL( 'INSERT INTO EMPRESA '+
                 'VALUES ( 1, '+QuotedStr('EMPRESA PADRAO')+', 1)') then
      Exit;

  end;

  procedure Loja;
  begin

    if kExistTable('LOJA') then
      Exit;

    if not kExecSQL('CREATE TABLE LOJA ( IDEMPRESA ID NOT NULL,'+
                    ' IDLOJA ID NOT NULL, NOME DESCRICAO NOT NULL)') then
      Exit;

    if not kExecSQL( 'ALTER TABLE LOJA'#13+
                     'ADD CONSTRAINT PK_LOJA PRIMARY KEY (IDEMPRESA,IDLOJA)') then
      Exit;

    if not kExecSQL( 'INSERT INTO LOJA'#13+
                     'VALUES ( '+sEmpresa+', 1, '+QuotedStr('LOJA PADRAO')+')') then
      Exit;
  end;

begin

  sLoja    := kGetUsuario( IntToStr(kGetUsuarioAtivo), 'LOJA_ID', '1');
  sEmpresa := kGetUsuario( IntToStr(kGetUsuarioAtivo), 'EMPRESA_ID', '1');
  sGE      := kGetUsuario( IntToStr(kGetUsuarioAtivo), 'EMPRESA_GE', '1');


  kSetDeposito( 'LOJA_ID',   sLoja);
  kSetDeposito( 'LOJA_NOME', 'PADRAO');

  kSetDeposito( 'EMPRESA_ID',   sEmpresa);
  kSetDeposito( 'EMPRESA_NOME', 'PADRAO');
  kSetDeposito( 'EMPRESA_GE', sGE);

  Empresa();
  Loja();

  // Campo IDGE de EMPRESA
  if not kIsField( 'EMPRESA', 'IDGE') then
  begin
    kExecSQL( 'ALTER TABLE EMPRESA ADD IDGE ID NOT NULL');
    kExecSQL( 'UPDATE EMPRESA SET IDGE = 1');
  end;

  cdEmpresa := TClientDataSet.Create(nil);
  cdLoja    := TClientDataSet.Create(nil);

  try try

    if not kOpenSQL( cdEmpresa,
                     'SELECT IDEMPRESA, NOME, IDGE FROM EMPRESA'#13+
                     'ORDER BY IDEMPRESA') then
      raise Exception.Create('');

    with cdEmpresa do
    begin
      First;
      if (RecordCount > 0) then
      begin
        kSetDeposito( 'EMPRESA_ID', Fields[0].AsString);
        kSetDeposito( 'EMPRESA_NOME', Fields[1].AsString);
        kSetDeposito( 'EMPRESA_GE', Fields[2].AsString);
      end;
      while not EOF do
      begin
         if (Fields[0].AsString = sEmpresa) then
         begin
           kSetDeposito( 'EMPRESA_ID', Fields[0].AsString);
           kSetDeposito( 'EMPRESA_NOME', Fields[1].AsString);
           kSetDeposito( 'EMPRESA_GE', Fields[2].AsString);
           Break;
         end;
         Next;
      end;

    end; // with cdEmpresa

    if not kOpenSQL( cdLoja, 'SELECT IDLOJA, NOME FROM LOJA'#13+
                             'WHERE IDEMPRESA = '+sEmpresa+#13+
                             'ORDER BY IDLOJA') then
      raise Exception.Create('');

    with cdLoja do
    begin
      First;
      if (RecordCount > 0) then
      begin
        kSetDeposito( 'LOJA_ID',   Fields[0].AsString);
        kSetDeposito( 'LOJA_NOME', Fields[1].AsString);
      end;
      while not Eof do begin
        if (Fields[0].AsString = sLoja) then
        begin
          kSetDeposito( 'LOJA_ID',   Fields[0].AsString);
          kSetDeposito( 'LOJA_NOME', Fields[1].AsString);
          Break;
        end;
        Next;
      end;  // while
    end;  // with cdLoja

  except
    on E:Exception do kErro( E.Message);
  end;
  finally
    cdEmpresa.Free;
    cdLoja.Free;
  end;

end;  // proc kEmpresaLojaPadrao

procedure kEmpresaLoader;
var
  cdEmpresa, cdLoja: TClientDataSet;
  sEmpresa, sLoja: String;
begin

  sEmpresa := kGetDeposito( 'EMPRESA_ID', '1');
  sLoja    := kGetDeposito( 'LOJA_ID', '1');

  cdEmpresa := TClientDataSet.Create(nil);
  cdLoja    := TClientDataSet.Create(nil);

  try try

    if not kOpenSQL( cdEmpresa,
                     'SELECT IDEMPRESA, NOME, IDGE FROM EMPRESA'#13+
                     'ORDER BY IDEMPRESA') then
      raise Exception.Create('');

    with cdEmpresa do
    begin
      First;
      if (RecordCount > 0) then
      begin
        kSetDeposito( 'EMPRESA_ID', Fields[0].AsString);
        kSetDeposito( 'EMPRESA_NOME', Fields[1].AsString);
        kSetDeposito( 'EMPRESA_GE', Fields[2].AsString);
      end;
      while not EOF do
      begin
         if (Fields[0].AsString = sEmpresa) then
         begin
           kSetDeposito( 'EMPRESA_ID', Fields[0].AsString);
           kSetDeposito( 'EMPRESA_NOME', Fields[1].AsString);
           kSetDeposito( 'EMPRESA_GE', Fields[2].AsString);
           Break;
         end;
         Next;
      end;
    end;  // with cdEmpresa

    if kExistTable('LOJA') then
    begin

      if not kOpenSQL( cdLoja,
                       'SELECT IDLOJA, NOME FROM LOJA'#13+
                       'WHERE IDEMPRESA = '+sEmpresa+' ORDER BY IDLOJA') then
        raise Exception.Create('');

      with cdLoja do
      begin
        First;
        if (RecordCount > 0) then
        begin
          kSetDeposito( 'LOJA_ID',   Fields[0].AsString);
          kSetDeposito( 'LOJA_NOME', Fields[1].AsString);
        end;
        while not Eof do
        begin
          if (Fields[0].AsString = sLoja) then
          begin
            kSetDeposito( 'LOJA_ID',   Fields[0].AsString);
            kSetDeposito( 'LOJA_NOME', Fields[1].AsString);
            Break;
          end;
          Next;
        end;  // while

      end;

    end;  // if LOJA

  except
    on E:Exception do kErro( E.Message);
  end;
  finally
    cdLoja.Free;
    cdEmpresa.Free;
  end;

end;  // proc kEmpresaLoader

end.
