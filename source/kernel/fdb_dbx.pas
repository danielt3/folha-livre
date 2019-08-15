{
Projeto FolhaLivre - Folha de Pagamento Livre
Biblioteca de funções genéricas para manipulação de dados

Copyright (c) 2001-2007 Allan Lima, Belém-Pará-Brasil.

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.
}

unit fdb_dbx;

{$DEFINE DBX}        // Define que os componentes do dbExpress serão usados
{$DEFINE INTERBASE}  // Por padrão é usado o SGDB Firebird/Interbase
{$DEFINE FIREBIRD}

{$DEFINE NO_DEFINE_ACESS}  // Desativa a definição de acesso dentro do flivre.inc
{$I flivre.inc}

{$DEFINE NO_FDB}  // Não escreve 'uses fdb;' nesta unidade (foi escrito acima)
{$DEFINE NO_FLIVRE}  // Não escreve '{$I flivre.inc}' nesta unidade (foi escrito acima)

{$I fdb.pas}
