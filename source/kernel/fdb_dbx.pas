{
Projeto FolhaLivre - Folha de Pagamento Livre
Biblioteca de fun��es gen�ricas para manipula��o de dados

Copyright (c) 2001-2007 Allan Lima, Bel�m-Par�-Brasil.

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.
}

unit fdb_dbx;

{$DEFINE DBX}        // Define que os componentes do dbExpress ser�o usados
{$DEFINE INTERBASE}  // Por padr�o � usado o SGDB Firebird/Interbase
{$DEFINE FIREBIRD}

{$DEFINE NO_DEFINE_ACESS}  // Desativa a defini��o de acesso dentro do flivre.inc
{$I flivre.inc}

{$DEFINE NO_FDB}  // N�o escreve 'uses fdb;' nesta unidade (foi escrito acima)
{$DEFINE NO_FLIVRE}  // N�o escreve '{$I flivre.inc}' nesta unidade (foi escrito acima)

{$I fdb.pas}
