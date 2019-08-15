{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2007, Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Historico das modificações

* 08/10/2007 - Primeira versão
}

unit r_comprovante_rendimento;


interface

implementation

{
CREATE TABLE F_COMPROVANTE_RENDIMENTO (
    IDGE       ID NOT NULL /* ID = INTEGER DEFAULT 0 NOT NULL */,
    GRUPO      ORDEM /* ORDEM = SMALLINT DEFAULT 0 NOT NULL */,
    SUBGRUPO   ORDEM /* ORDEM = SMALLINT DEFAULT 0 NOT NULL */,
    DESCRICAO  VALOR /* VALOR = VARCHAR(100) */,
    IDEVENTO   ID /* ID = INTEGER DEFAULT 0 NOT NULL */,
    IDTOTAL    ID /* ID = INTEGER DEFAULT 0 NOT NULL */
);
}
end.
 