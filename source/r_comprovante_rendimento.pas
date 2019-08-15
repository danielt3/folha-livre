{
Projeto FolhaLivre - Folha de Pagamento Livre

Copyright (c) 2007, Allan Lima

Este programa � um software de livre distribui��o, que pode ser copiado e
distribu�do sob os termos da Licen�a P�blica Geral GNU, conforme publicada
pela Free Software Foundation, vers�o 2 da licen�a ou qualquer vers�o posterior.

Este programa � distribu�do na expectativa de ser �til aos seus usu�rios,
por�m  N�O TEM NENHUMA GARANTIA, EXPL�CITAS OU IMPL�CITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licen�a P�blica Geral GNU para maiores detalhes.

Historico das modifica��es

* 08/10/2007 - Primeira vers�o
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
 