{
FolhaLivre - Folha de Pagamento Livre
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

unit fusuario;

{$I flivre.inc}

interface

uses Classes, SysUtils;

function kGetUsuario( Nome, Chave:String; Default: String = ''):String;
function kSetUsuario( const Nome, Chave: String; const Valor: String = ''):Boolean;

implementation

uses
  DB, DBClient, MidasLib, fdb, ftext;

function kGetUsuario( Nome, Chave:String; Default: String = ''):String;
var
  SQL: TStringList;
  pvDataSet: TClientDataSet;
begin

  SQL       := TStringList.Create;
  pvDataSet := TClientDataSet.Create(NIL);

  try try

    // Verificar se a tabela SYS_USER existe
    if not kExistTable('SYS_USER') then
    begin

      // Cria a tabela na base
      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('CREATE TABLE SYS_USER (');
      SQL.Add('    LOGIN VARCHAR(15) NOT NULL,');
      SQL.Add('    CHAVE VARCHAR(30) NOT NULL,');
      SQL.Add('    VALOR VARCHAR(100),');
      SQL.Add('    ATIVO SMALLINT DEFAULT 1 NOT NULL);');
      SQL.EndUpdate;

      if kExecSQL(SQL.Text) then
      begin

        SQL.BeginUpdate;
        SQL.Clear;
        SQL.Add('ALTER TABLE SYS_USER');
        SQL.Add('   ADD CONSTRAINT PK_SYS_USER PRIMARY KEY (LOGIN,CHAVE);');
        SQL.EndUpdate;

        kExecSQL( SQL.Text);

      end;

    end;

    Result := Default;

    if kOpenSQL(pvDataSet,
                'SELECT VALOR FROM SYS_USER'#13+
                'WHERE LOGIN = :LOGIN AND CHAVE = :CHAVE AND ATIVO = 1',
                [Nome, Chave]) and (pvDataSet.RecordCount = 1) then
      Result := pvDataSet.Fields[0].AsString;

  except
    on E:Exception do
      kErro( E.Message, 'fusuario.pas', 'kGetUsuario()');
  end;
  finally
    pvDataSet.Free;
    SQL.Free;
  end;

end;

function kSetUsuario( const Nome, Chave: String; const Valor:String = ''):Boolean;
var
  i: Integer;
  SQL: TStringList;
begin

  Result := False;
  SQL := TStringList.Create;

  try try

    i := kCountSQL('SELECT COUNT(*) FROM SYS_USER'#13+
                   'WHERE LOGIN = :LOGIN AND CHAVE = :CHAVE', [Nome, Chave]);

    if (i = -1) then
      raise Exception.Create(kGetErrorLastSQL);

    if (i = 1) then
    begin

      SQL.BeginUpdate;
      SQL.Add('UPDATE SYS_USER');
      SQL.Add('SET VALOR = :VALOR');
      SQL.Add('WHERE LOGIN = :LOGIN AND CHAVE = :CHAVE');
      SQL.EndUpdate;

      Result := kExecSQL( SQL.Text, [Valor, Nome, Chave]);

    end else
    begin

      SQL.BeginUpdate;
      SQL.Add('INSERT INTO SYS_USER');
      SQL.Add(' (LOGIN, CHAVE, VALOR, ATIVO)');
      SQL.Add('VALUES (:LOGIN, :CHAVE, :VALOR, 1)');
      SQL.EndUpdate;

      Result := kExecSQL( SQL.Text, [Nome, Chave, Valor])

    end;

  except
    on E:Exception do
      kErro( E.Message, 'fusuario.pas', 'kSetUsuario');
  end;

  finally
    SQL.Free;
  end;

end;  // kSetUsuario

end.
