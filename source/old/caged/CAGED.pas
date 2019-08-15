unit CAGED;

interface

uses
  Classes;

function SetCAGED_A( MeioFisico, Autorizacao, Inscricao, Nome, Endereco,
                     UF, CEP, DDD, Telefone, Ramal: String;
                     Mes, Ano: Word):Boolean;

function SetCAGED_B( Inscricao, Atividade, Alteracao,
                     Nome, Endereco, Bairro, CEP, UF: String;
                     PrimeiraDeclaracao, PequenoPorte: Boolean;
                     TotalEmpregado: Word):Boolean;

function SetCAGED_C( PIS, CBO, Nome, CTPS, CTPS_Serie, CTPS_UF,
                     Sexo, Instrucao, Raca,
                     CodigoAdmissao, CodigoRescisao: String;
                     Nascimento, Admissao, Rescisao: TDateTime;
                     CargaSemana: Byte; Salario: Currency;
                     Deficiente: Boolean):Boolean;

function SetCAGED_X( Atualizacao: String):Boolean;

function CAGED_REG_A:String;  // Primeiro - Somente 1 (um) - Responsavel
function CAGED_REG_B:String;  // Segundo - Estabelecimento
function CAGED_REG_C:String;  // Admissoes e Demissoes
function CAGED_REG_X:String;  // Acerto

procedure GeraArquivoCAGED( RegA, RegB, RegC, RegX: TStringList );

implementation

uses
  Forms, Util2, SysUtils;

var

  SEQUENCIA, TOTAL_C: SmallInt;

  A_MEIO_FISICO, A_AUTORIZACAO, A_INSCRICAO: String;
  A_NOME, A_ENDERECO, A_UF, A_CEP, A_DDD, A_TELEFONE, A_RAMAL: String;
  A_MES, A_ANO: Word;

  B_INSCRICAO, B_ATIVIDADE_ECONOMICA: String;
  B_ALTERACAO: Char;
  B_PRIMEIRA_DECLARACAO, B_PEQUENO_PORTE: Boolean;
  B_NOME, B_ENDERECO, B_BAIRRO, B_CEP, B_UF: String;
  B_TOTAL_EMPREGADO: Word;

  C_PIS, C_CBO, C_NOME, C_CTPS, C_CTPS_SERIE, C_CTPS_UF: String;
  C_SEXO, C_INSTRUCAO, C_RACA: Char;
  C_TIPO_MOVIMENTACAO: String[2];
  C_NASCIMENTO, C_ADMISSAO, C_RESCISAO: TDateTime;
  C_HORAS_SEMANA: Byte;
  C_SALARIO: Currency;
  C_DEFICIENTE: Boolean;

  X_ATUALIZACAO: Char;

(* ================== Layout do Arquivo CAGED =============================
O layout do Arquivo CAGED � composto de 04 (quatro) tipos de registro.

 ======  Organiza��o do Arquivo CAGED ===============================

A seq��ncia do arquivo deve ser da seguinte forma:
. O registro de tipo A � �nico, e � sempre o primeiro registro do Arquivo CAGED
 (dados do estabelecimento respons�vel pelo meio magn�tico);

. O segundo registro do arquivo ser� sempre um tipo B
 (dados do estabelecimento que teve movimenta��o no m�s/ano de refer�ncia);

. Ap�s o registro tipo B, relacione todas as admiss�es e
  desligamentos ocorridos no estabelecimento informado no tipo B
  (dados de movimenta��o de empregado) gerando para cada movimenta��o um registro tipo C;

. Para informar mais de um estabelecimento,
  informar novamente um registro tipo B e subseq�entemente os registros tipo C correspondentes.

. Poder� ser inclu�do no Arquivo CAGED registros de ACERTO (tipo X)
  sempre no final do arquivo (ver �tem Arquivo ACERTO.)

==============================================================================

A - Registro do estabelecimento respons�vel pela informa��o no meio magn�tico (autorizado).

Neste registro informe o meio f�sico utilizado,
a compet�ncia (m�s e ano de refer�ncia das informa��es prestadas),
dados cadastrais do estabelecimento respons�vel,
telefone para contato, total de estabelecimentos e
total de movimenta��es informadas no arquivo.
---------------------------------------------------------------------------- *)

// Procedimentos de entrada e checagem de dados

function SetCAGED_A( MeioFisico, Autorizacao, Inscricao, Nome, Endereco,
                     UF, CEP, DDD, Telefone, Ramal: String;
                     Mes, Ano: Word):Boolean;
begin

  SEQUENCIA := 1;
  TOTAL_C   := 0;

  if (Length(MeioFisico) <> 1) or (not (MeioFisico[1] in ['2','3','4'])) then
    MeioFisico := '2';  // Disquete

  A_MEIO_FISICO := MeioFisico;
  A_AUTORIZACAO := Autorizacao;
  A_INSCRICAO   := Inscricao;

  A_NOME        := Nome;
  A_ENDERECO    := Endereco;
  A_UF          := UF;
  A_CEP         := CEP;
  A_DDD         := DDD;
  A_TELEFONE    := Telefone;
  A_RAMAL       := Ramal;

  A_MES         := Mes;
  A_ANO         := ANo;

  Result := True;

end;

//=============================================================================

function SetCAGED_B( Inscricao, Atividade, Alteracao,
                     Nome, Endereco, Bairro, CEP, UF: String;
                     PrimeiraDeclaracao, PequenoPorte: Boolean;
                     TotalEmpregado: Word):Boolean;
begin

  Result := False;

  if Length(Atividade) > 5 then
    Atividade := Copy( Atividade, 1, 5);

  if Length(Trim(Atividade)) <> 5 then begin
    MsgErro( 'A Atividade Economica da Empresa � obrigat�ria'+#13+
             'e deve ter 5 posicoes');
    Exit;
  end;

  B_INSCRICAO           := Inscricao;
  B_ATIVIDADE_ECONOMICA := Trim(Atividade);
  B_ALTERACAO           := Alteracao[1];
  B_NOME                := Nome;
  B_ENDERECO            := Endereco;
  B_BAIRRO              := Bairro;
  B_CEP                 := CEP;
  B_UF                  := UF;
  B_PRIMEIRA_DECLARACAO := PrimeiraDeclaracao;
  B_PEQUENO_PORTE       := PequenoPorte;
  B_TOTAL_EMPREGADO     := TotalEmpregado;

  Result := True;

end;

//=============================================================================

function SetCAGED_C( PIS, CBO, Nome, CTPS, CTPS_Serie, CTPS_UF,
                     Sexo, Instrucao, Raca,
                     CodigoAdmissao, CodigoRescisao: String;
                     Nascimento, Admissao, Rescisao: TDateTime;
                     CargaSemana: Byte; Salario: Currency;
                     Deficiente: Boolean):Boolean;
begin

  Result := False;

  CodigoAdmissao := Trim(CodigoAdmissao);
  CodigoRescisao := Trim(CodigoRescisao);

  if Length(CodigoRescisao) = 2 then
    CodigoAdmissao := '';

  if Length(CodigoAdmissao) = 2 then begin
    CodigoRescisao := '';
    Rescisao := 0;
  end;

  if (Length(CodigoAdmissao) <> 2) and (Length(CodigoRescisao) <> 2) then begin
    MsgErro( 'Funcion�rio: '+Nome+#13+
             'O codigo de Admiss�o/demiss�o deve ser informado');
    Exit;
  end;

  if ( Length(CodigoRescisao) = 2 ) and
     ( Pos( CodigoRescisao, '31_32_40_43_45_50_60_80') = 0) then begin
      MsgErro( 'Funcion�rio: '+Nome+#13+
               'O codigo de demiss�o (campo 13) est� invalido');
      Exit;
  end;

  if ( Length(CodigoAdmissao) = 2 ) and
     ( Pos( CodigoAdmissao, '10_20_25_35_70') = 0 ) then begin
      MsgErro( 'Funcion�rio: '+Nome+#13+
               'O codigo de admiss�o (campo 13) est� invalido');
      Exit;
  end;

  Instrucao := StrZero( StrToInt(Instrucao), 1);

  if not (Instrucao[1] in ['1'..'9']) then begin
      MsgErro( 'Funcion�rio: '+Nome+#13+
               'O Grau de Instru��o (campo 8) � obrigatoria');
    Exit;
  end;

  Raca := StrZero( StrToInt(Raca), 1);

  if not (Raca[1] in ['0','2','4','6','8']) then begin
    MsgErro( 'Funcion�rio: '+Nome+#13+
             'A Ra�a/Cor informada s� poder� ser 0, 2, 4, 6 ou 8');
    Exit;
  end;

  if Length(PIS) <> 11 then begin
    MsgErro( 'Funcion�rio: '+Nome+#13+
             'O n�mero do PIS n�o � valido');
    Exit;
  end;

  if Length(CBO) <> 5 then begin
    MsgErro( 'Funcion�rio: '+Nome+#13+
             'O n�mero do CBO n�o � valido');
    Exit;
  end;

  C_PIS               := PIS;
  C_CBO               := CBO;
  C_NOME              := Nome;
  C_CTPS              := CTPS;
  C_CTPS_SERIE        := CTPS_SERIE;
  C_CTPS_UF           := CTPS_UF;
  C_SEXO              := Sexo[1];
  C_INSTRUCAO         := Instrucao[1];
  C_RACA              := Raca[1];

  C_TIPO_MOVIMENTACAO := CodigoRescisao+CodigoAdmissao;

  C_NASCIMENTO        := Nascimento;
  C_ADMISSAO          := Admissao;
  C_RESCISAO          := Rescisao;
  C_HORAS_SEMANA      := CargaSemana;
  C_SALARIO           := Salario;
  C_DEFICIENTE        := Deficiente;

  Result := True;

end;

function SetCAGED_X( Atualizacao: String):Boolean;
begin

  Result := False;

  if not (Atualizacao[1] in ['1','2','3']) then begin
    MsgErro( 'Funcion�rio: '+C_NOME+#13+
             'A Atualiza��o (campo 19) informada s� poder� ser 1, 2 ou 3');
    Exit;
  end;

  X_ATUALIZACAO := Atualizacao[1];
  Result := True;
  
end;

//=============================================================================

// Procedimentos de montagem de registro

function CAGED_REG_A:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posi��o
Define o registro a ser informado. Obrigatoriamente o conte�do � A. *)
  sLinha := 'A';

(* 2. Meio F�sico, num�rico, 1 posi��o
Informe qual o meio f�sico utilizado para informar o Arquivo CAGED.
2 - disquete, 3 - fita, 4 - outros  *)
  sLinha := sLinha + A_MEIO_FISICO;

(* 3. Autoriza��o, num�rico, 7 posi��es
N�mero da Autoriza��o fornecido pelo Minist�rio do Trabalho e Emprego.
Caso n�o possua este n�mero informar zeros neste campo. *)
  sLinha := sLinha + PadLeftChar( A_AUTORIZACAO, 7, '0');

(* 4. Compet�ncia, num�rico, 6 posi��es
M�s e ano de refer�ncia das informa��es do CAGED.
Informar sem m�scara (/.\-,).
Para informar movimenta��es ocorridas em meses anteriores � da compet�ncia,
veja como proceder no �tem Arquivo ACERTO. *)
  sLinha := sLinha + StrZero( A_MES, 2)+StrZero( A_ANO, 4);

(* 5. Altera��o, num�rico, 1 posi��o
Define se os dados cadastrais informados ir�o ou n�o atualizar
o cadastro de Autorizados do CAGED Informatizado.
1 - Nada a alterar, 2 - Alterar dados cadastrais *)
  sLinha := sLinha + '1';

(* 6. Seq��ncia, num�rico, 5 posi��es - N�mero seq�encial no arquivo. *)
  sLinha    := sLinha + StrZero( 1, 5);

(* 7. Tipo de Identificador, num�rico, 1 posi��o
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ, 2 - CEI *)
  sLinha := sLinha + Iif( Length(A_INSCRICAO) = 14, '1', '2');

(* 8. No de Identificador, num�rico, 14 posi��es
N�mero de Identificador do estabelecimento.
N�o havendo inscri��o do estabelecimento no
Cadastro Nacional de Pessoa Jur�dica (CNPJ),
informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
O n�mero do CEI tem 12 posi��es, preencher este campo com 00 (zeros) � esquerda. *)
  sLinha := sLinha + PadLeftChar( A_INSCRICAO, 14, '0');

(* 9. Nome/Raz�o Social, caracter, 35 posi��es
Nome / Raz�o Social do estabelecimento autorizado. *)
  sLinha := sLinha + PadRightChar( A_NOME, 35, #32);

(*  10. Endere�o, caracter, 40 posi��es
Informar o endere�o do estabelecimento (Rua, Av., Trav., P�.) com n�mero e complemento. *)
  sLinha := sLinha + PadRightChar( A_ENDERECO, 40, #32);

(* 11. CEP, num�rico, 8 posi��es
Informar o C�digo de Endere�amento Postal do estabelecimento
conforme a tabela da ECT - Empresa de Correios e Tel�grafos.
Informar sem m�scara (\./-,). *)
  sLinha := sLinha + A_CEP;

(* 12. UF, caracter, 2 posi��es
Informar a Unidade da Federa��o. *)
  sLinha := sLinha + A_UF;

(* 13. DDD, caracter, 4 posi��es
Informar o DDD do telefone para contato com o Minist�rio do Trabalho e Emprego. *)
  sLinha := sLinha + PadRightChar( A_DDD, 4, #32);

(* 14. Telefone, caracter, 8 posi��es
Informar o n�mero do telefone para contato do respons�vel pelas informa��es contidas no arquivo CAGED. *)
  sLinha := sLinha + PadRightChar( A_TELEFONE, 8, #32);

(* 15. Ramal, caracter, 5 posi��es
Informar o ramal, se houver, complemento do telefone informado. *)
  sLinha := sLinha + PadRightChar( A_RAMAL, 5, #32);

(* 16. Total Estabelecimentos Informados, num�rico, 5 posi��es
Quantidade de registros tipo B informados no Arquivo CAGED. *)
  sLinha := sLinha + StrZero( 1, 5);

(* 17. Total de Movimentos Informados, num�rico, 5 posi��es
Quantidade de registros tipo C informados no Arquivo CAGED. *)
  sLinha := sLinha + StrZero( TOTAL_C, 5);

(* 18. Filler, caracter, 2 posi��es - Deixar em branco. *)
  sLinha := sLinha + Espaco(2);

// =====================================

  Result := sLinha ;

end;  // function CAGED_REG_A

(* ----------------------------------------------------------------------------
B - Registro de estabelecimento informado.

Informe neste registro os dados cadastrais do estabelecimento
que teve movimenta��o (admiss�es e/ou desligamentos) e
total de empregados existentes no in�cio do primeiro dia do m�s informado
(estoque de funcion�rios).
---------------------------------------------------------------------------- *)

function CAGED_REG_B:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posi��o
Define o registro a ser informado. Obrigatoriamente o conte�do � B. *)
  sLinha := 'B';

(* 2. Tipo de Identificador, num�rico, 1 posi��o
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ, 2 - CEI *)
  sLinha := sLinha + Iif( Length(B_INSCRICAO) = 14, '1', '2');

(* 3. No de Identificador, num�rico, 14 posi��es
N�mero de Identificador do estabelecimento.
N�o havendo inscri��o do estabelecimento no Cadastro Nacional de Pessoa Jur�dica
CNPJ, informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
O n�mero do CEI tem 12 posi��es, preencher este campo com 00 (zeros) � esquerda. *)
  sLinha := sLinha + PadLeftChar( B_INSCRICAO, 14, '0');

(* 4. Seq��ncia, num�rico, 5 posi��es
N�mero seq�encial no arquivo. *)
  SEQUENCIA := SEQUENCIA + 1;
  sLinha    := sLinha + StrZero( SEQUENCIA, 5);

(* 6. Primeira Declara��o, num�rico, 1 posi��o
Define se � ou n�o a primeira declara��o do estabelecimento ao
CAGED - Cadastro Geral de Empregados e Desempregados - Lei No 4923/65.
1 - primeira declara��o, 2 - j� informou ao CAGED anteriormente *)
  sLinha := sLinha + Iif( B_PRIMEIRA_DECLARACAO, '1', '2');

(* 7. Altera��o, num�rico, 1 posi��o
Define as seguintes a��es:
1 - Nada a atualizar
2 - Alterar dados cadastrais do estabelecimento
    (Raz�o Social, Endere�o, CEP, Bairro, UF, ou Atividade Econ�mica)
3 - Encerramento de Atividades (Fechamento do estabelecimento) *)
  sLinha := sLinha + B_ALTERACAO;

(* 8. CEP, num�rico, 8 posi��es
Informar o C�digo de Endere�amento Postal do estabelecimento
conforme a tabela da ECT - Empresa de Correios e Tel�grafos. Informar sem m�scara (\./-,). *)
  sLinha := sLinha + B_CEP;

(* 9. Atividade Econ�mica, num�rico, 5 posi��es
Informar a Atividade Econ�mica principal do estabelecimento,
de acordo com a nova Classifica��o Nacional de Atividades
Econ�micas publicada no D.O.U. no dia 26/12/94. Informar o c�digo sem m�scara(/.\-,). *)
  sLinha := sLinha + B_ATIVIDADE_ECONOMICA;

(* 10. Nome do Estabelecimento/Raz�o Social, caracter, 40 posi��es
Nome / Raz�o Social do estabelecimento. *)
  sLinha := sLinha + PadRightChar( B_NOME, 40, #32);

  (* 11. Endere�o, caracter, 40 posi��es
  Informar o endere�o do estabelecimento (Rua, Av., Trav., P�.) com n�mero e complemento. *)
  sLinha := sLinha + PadRightChar( B_ENDERECO, 40, #32);

  (* 12. Bairro, caracter, 20 posi��es - Informar o bairro correspondente. *)
  sLinha := sLinha + PadRightChar( B_BAIRRO, 20, #32);

  (* 13. UF, caracter, 2 posi��es - Informar a Unidade da Federa��o. *)
  sLinha := sLinha + B_UF;

(* 14. Total Empregados Existentes 1o dia, num�rico, 5 posi��es
Total de empregados existentes na empresa no in�cio do primeiro
dia do m�s de refer�ncia (compet�ncia). *)
  sLinha := sLinha + StrZero( B_TOTAL_EMPREGADO, 5);

(* 15. Empresa Pequeno Porte/Micro Empresa, alfa-num�rico, 1 posi��o
No m�dulo analisador, preencher com:
1 � Sim, 2 � N�o
No m�dulo gerador, preencher com:
S � Sim, N - N�o *)
   sLinha := sLinha + Iif( B_PEQUENO_PORTE, '1', '2');

  (* 16. Filler, caracter, 6 posi��es - Deixar em branco. *)
  sLinha := sLinha + Espaco(6);

  // =================================
  Result := sLinha;

end;  // function CAGED_REG_B

(* ----------------------------------------------------------------------------
C - Registro da movimenta��o do empregado informado.

Informe aqui a identifica��o do estabelecimento,
os dados cadastrais do empregado e a sua respectiva movimenta��o.
Informe um registro tipo C para cada movimenta��o ocorrida.
No caso de empregado admitido e desligado no mesmo m�s de compet�ncia,
informar dois registros tipo C, o primeiro com a admiss�o e o outro com o desligamento.
---------------------------------------------------------------------------- *)

function CAGED_REG_C:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posi��o
Define o registro a ser informado. Obrigatoriamente o conte�do � C. *)

  sLinha := 'C';

(* 2. Tipo de Identificador, num�rico, 1 posi��o
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ ou 2 - CEI *)
  sLinha := sLinha + Iif( Length(B_INSCRICAO) = 14, '1', '2');

(* 3. No de Identificador, num�rico, 14 posi��es
N�mero de Identificador do estabelecimento.
N�o havendo inscri��o do estabelecimento no Cadastro Nacional de Pessoa Jur�dica (CNPJ),
informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
O n�mero do CEI tem 12 posi��es, preencher este campo com 00 (zeros) � esquerda. *)
  sLinha := sLinha + PadLeftChar( B_INSCRICAO, 14, '0');

(* 4. Seq��ncia, num�rico, 5 posi��es
N�mero seq�encial no arquivo. *)
  SEQUENCIA := SEQUENCIA + 1;
  sLinha    := sLinha + StrZero( SEQUENCIA, 5);

(* 5. PIS/PASEP, num�rico, 11 posi��es
N�mero do PIS/PASEP do empregado movimentado. Informar sem m�scara (/.\-,). *)
  sLinha := sLinha + C_PIS;

(* 6. Sexo, num�rico, 1 posi��o
Define o sexo do empregado:
1 - Masculino ou 2 - Feminino *)
  sLinha := sLinha + Iif( UpperCase(C_SEXO) = 'M', '1', '2');

(* 7. Nascimento, num�rico, 8 posi��es
Dia, m�s e ano de nascimento do empregado.
Informar a data do nascimento sem m�scara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_NASCIMENTO);

(* 8. Instru��o, num�rico, 1 posi��o
Define grau de instru��o do empregado:
1 - analfabeto, inclusive os que embora tenham recebido instru��o,n�o se alfabetizaram ou tenham esquecido;
2 - at� 4a s�rie incompleta do 1o grau (prim�rio incompleto ou que se tenha alfabetizado sem ter freq�entado escola regular);
3 - 4a s�rie completa do 1o grau (prim�rio completo);
4 - da 5a � 8a s�rie incompleta do 1o grau (ginasial incompleto);
5 - 1o grau (ginasial) completo;
6 - 2o grau (colegial) incompleto;
7 - 2o grau (colegial) completo;
8 - superior incompleto;
9 - superior completo. *)
  sLinha := sLinha + C_INSTRUCAO;

(* 9. CBO, num�rico, 5 posi��es
Informe o c�digo de ocupa��o conforme a
Classifica��o Brasileira de Ocupa��o - CBO. Informar sem m�scara (/.\-,). *)
  sLinha := sLinha + C_CBO;

(* 10. Remunera��o, num�rico, 8 posi��es
Informar o sal�rio recebido, ou a receber.
Informar com centavos sem pontos e sem v�rgulas. Ex.: R$134,60 informar: 13460. *)
  sLinha := sLinha + StrZero( Trunc(C_SALARIO*100), 8);

(* 11. Horas Trabalhadas, num�rico, 2 posi��es
Informar a quantidade de horas trabalhadas por semana. (de 1 at� 44 horas). *)
  sLinha := sLinha + StrZero( C_HORAS_SEMANA, 2);

(* 12. Admiss�o, num�rico de 8 posi��es
Dia, m�s e ano de admiss�o do empregado. Informar a data de admiss�o sem m�scara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_ADMISSAO);

(* 13. Tipo de Movimenta��o, num�rico, 2 posi��es - Define o tipo de movimento:
ADMISS�ES -    10 - primeiro emprego;
               20 - reemprego;
               25 - Contr, Prazo determinado;
               35 - reintegra��o;
               70 - transfer�ncia de entrada.

DESLIGAMENTOS - 31 - dispensa sem justa causa;
                32 - dispensa por justa causa;
                40 - a pedido (espont�neo);
                43 - Term. Prazo determinado;
                45 - t�rmino de contrato;
                50 - aposentado;
                60 - morte;
                80 - transfer�ncia de sa�da. *)
  sLinha := sLinha + C_TIPO_MOVIMENTACAO ;

(* 14. Dia de Desligamento, num�rico, 2 posi��es
Se o tipo de movimenta��o for desligamento,
informar o dia da sa�da do empregado, se for admiss�o deixar em branco. *)
  if (C_RESCISAO = 0) then
    sLinha := sLinha + Espaco(2)
  else
    sLinha := sLinha + FormatDateTime( 'DD', C_RESCISAO);

(* 15. Nome do Empregado, caracter, 40 posi��es
Informar o nome do empregado movimentado. *)
  sLinha := sLinha + PadRightChar( C_NOME, 40, #32);

(* 16. N�mero da Carteira de Trabalho, num�rico, 7 posi��es
Informar o n�mero da Carteira de Trabalho e Previd�ncia Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS, 7, '0');

(* 17. S�rie da Carteira de Trabalho, num�rico, 3 posi��es
Informar o n�mero de s�rie da Carteira de Trabalho e Previd�ncia Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS_SERIE, 3, '0');

(* 18. UF da Carteira de Trabalho, caracter, 2 posi��es
Informar a UF da Carteira de Trabalho e Previd�ncia Social do empregado. *)
  sLinha := sLinha + C_CTPS_UF;

(* 19. Filler, caracter, 7 posi��es - Deixar em branco. *)
  sLinha := sLinha + Espaco(7);

  (* 20. Ra�a/Cor, num�rico, 1 posi��o
  Preencher com: 2 � Branca, 4 � Preta, 6 � Amarela, 8 � Parda, 0 � Ind�gena *)
  sLinha := sLinha + C_RACA ;

(* 21. Deficiente F�sico, alfanum�rico, 1 posi��o
Preencher com, no m�dulo analisador:
1 � Sim ou 2 � N�o
Preencher com, no m�dulo gerador:
S � Sim ou N - N�o *)
  sLinha := sLinha + Iif( C_DEFICIENTE, '1', '2');

(* 22. Filler, caracter, 20 posi��es - Deixar em branco. *)
  sLinha := sLinha + Espaco(20);

  // ===================================================================
  Result := sLinha ;
  TOTAL_C := TOTAL_C + 1;

end;  // function CAGED_REG_C

(* ----------------------------------------------------------------------------
X - Registro da Movimenta��o do empregado para atualizar.

 Informe a identifica��o do estabelecimento,
 os dados cadastrais do empregado com a respectiva movimenta��o,
 o tipo de acerto a efetuar e a compet�ncia ( m�s e ano de refer�ncia da informa��o ).
---------------------------------------------------------------------------- *)

function CAGED_REG_X:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posi��o
Define o registro a ser informado. Obrigatoriamente o conte�do � X. *)
  sLinha := 'X';

(* 2. Tipo de Identificador, num�rico, 1 posi��o
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ ou 2 - CEI *)
  sLinha := sLinha + Iif( Length(B_INSCRICAO) = 14, '1', '2');

  (* 3. No de Identificador, num�rico, 14 posi��es
N�mero de Identificador do estabelecimento. N�o havendo
inscri��o do estabelecimento no Cadastro Nacional de Pessoa Jur�dica (CNPJ),
informar o n�mero de registro no CEI (C�digo Espec�fico do INSS).
O n�mero do CEI tem 12 posi��es, preencher este campo com 00 (zeros) � esquerda. *)
  sLinha := sLinha + PadLeftChar( B_INSCRICAO, 14, '0');

(* 4. Seq��ncia, num�rico, 5 posi��es
N�mero seq�encial no arquivo. *)
  SEQUENCIA := SEQUENCIA + 1;
  sLinha    := sLinha + StrZero( SEQUENCIA, 5);

(* 5. PIS/PASEP, num�rico, 11 posi��es
N�mero do PIS/PASEP do empregado movimentado. Informar sem m�scara (/.\-,). *)
  sLinha := sLinha + C_PIS;

(* 6. Sexo, num�rico, 1 posi��o
Define o sexo do empregado: 1 - Masculino ou 2 - Feminino *)
  sLinha := sLinha + Iif( UpperCase(C_SEXO) = 'M', '1', '2');

(* 7. Nascimento, num�rico,8 posi��es
Dia, m�s e ano de nascimento do empregado.
Informar a data do nascimento sem m�scara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_NASCIMENTO);

(* 8. Instru��o, num�rico, 1 posi��o
Define grau de instru��o do empregado:
1 - analfabeto, inclusive os que embora tenham recebido instru��o,n�o se alfabetizaram ou tenham esquecido;
2 - at� 4a s�rie incompleta do 1o grau (prim�rio incompleto ou que se tenha alfabetizado sem ter freq�entado escola regular;
3 - 4a s�rie completa do 1o grau (prim�rio completo);
4 - da 5a a 8as�rie incompleta do 1o grau (ginasial incompleto);
5 - 1o grau (ginasial) completo;
6 - 2o grau (colegial) incompleto;
7 - 2o grau (colegial) completo;
8 - superior incompleto;
9 - superior completo. *)
  sLinha := sLinha + C_INSTRUCAO;

(* 9. CBO, num�rico, 5 posi��es
Informe o c�digo de ocupa��o conforme a Classifica��o Brasileira de Ocupa��o - CBO.
Informar sem m�scara (/.\-,). *)
  sLinha := sLinha + C_CBO;

(* 10. Remunera��o, num�rico, 8 posi��es
Informar o sal�rio recebido ou a receber.
Informar com centavos sem pontos e sem v�rgulas. Ex.: R$134,60 informar: 13460. *)
  sLinha := sLinha + StrZero( Trunc(C_SALARIO*100), 8);

(* 11. Horas Trabalhadas, num�rico, 2 posi��es
Informar a quantidade de horas trabalhadas por semana (de 1 at� 44 horas). *)
  sLinha := sLinha + StrZero( C_HORAS_SEMANA, 2);

(* 12. Admiss�o, num�rico de 8 posi��es
Dia, m�s e ano de admiss�o do empregado.
Informar a data de admiss�o sem m�scara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_ADMISSAO);

(* 13. Tipo de Movimenta��o, num�rico, 2 posi��es
Define o tipo de movimento:
ADMISS�ES   10 - primeiro emprego
            20 - reemprego
            25 - Contr, Prazo determinado;
            35 - reintegra��o
            70 - transfer�ncia de entrada

DESLIGAMENTOS 31 - dispensa sem justa causa
              32 - dispensa por justa causa
              40 - a pedido (espont�neo);
              43 - Term. Prazo determinado;
              45 - t�rmino de contrato;
              50 - aposentado;
              60 - morte
              80 - transfer�ncia de sa�da  *)
  sLinha := sLinha + C_TIPO_MOVIMENTACAO;

(* 14. Dia de Desligamento, num�rico, 2 posi��es
Se o tipo de movimenta��o for desligamento,
informar o dia da sa�da do empregado, se for admiss�o deixar em branco. *)
  sLinha := sLinha + Iif( (C_RESCISAO = 0), Espaco(2),
                          FormatDateTime( 'DD', C_RESCISAO) ) ;

(* 15. Nome do Empregado, caracter, 40 posi��es
Informar o nome do empregado movimentado. *)
  sLinha := sLinha + PadRightChar( C_NOME, 40, #32);

(* 16. N�mero da Carteira de Trabalho, num�rico, 7 posi��es
Informar o n�mero da Carteira de Trabalho e Previd�ncia Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS, 7, '0');

(* 17. S�rie da Carteira de Trabalho, num�rico, 3 posi��es
Informar o n�mero de s�rie da Carteira de Trabalho e Previd�ncia Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS_SERIE, 3, '0');

(* 18. UF da Carteira de Trabalho, caracter, 2 posi��es
Informar a UF da Carteira de Trabalho e Previd�ncia Social do empregado. *)
  sLinha := sLinha + C_CTPS_UF;

(* 19. Atualiza��o, num�rico, 1 posi��o
Informar o procedimento a ser seguido:
1 - exclus�o de registro, 2 - inclus�o de registro, 3 - altera��o de registro *)
  sLinha := sLinha + X_ATUALIZACAO;

(* 20. Compet�ncia, num�rico, 6 posi��es
M�s e ano de refer�ncia das informa��es do registro. Informar sem m�scara (/.\-,). *)
  sLinha := sLinha + StrZero( A_MES, 2)+StrZero( A_ANO, 4);

(* 21. Ra�a/Cor, num�rico, 1 posi��o
Preencher com: 2 � Branca, 4 � Preta, 6 � Amarela, 8 � Parda, 0 � Ind�gena *)
  sLinha := sLinha + C_RACA;

(* 22. Deficiente F�sico, alfanum�rico, 1 posi��o
Preencher com, no m�dulo analisador:
1 � Sim ou 2 � N�o
Preencher com, no m�dulo gerador:
S � Sim ou N - N�o *)
  sLinha := sLinha + Iif( C_DEFICIENTE, '1', '2');

(* 23. Filler, caracter, 22 posi��es
Deixar em branco. *)
  sLinha := sLinha + Espaco(22);

  // =====================================================================
  Result := sLinha;

end;  // function CAGED_REG_X


(* ========================================================
     Arquivo ACERTO
   ==================================

Utilize este arquivo sempre que for informar movimenta��es referentes a meses
anteriores � compet�ncia atual.
Se for encaminhar no mesmo m�s o Arquivo CAGED,
estes acertos poder�o ser relacionados no final do arquivo,
sempre ap�s o �ltimo registro informado.

Neste caso n�o ser� necess�rio um outro registro A, somente os registros X.

Layout do arquivo ACERTO ---------------------------------------

A - Registro do estabelecimento respons�vel pelo arquivo CAGED.

Neste registro informe o meio f�sico utilizado,
dados cadastrais do estabelecimento respons�vel,
telefone para contato, totais de movimenta��es informadas no arquivo.

X - Registro da movimenta��o do empregado para atualizar.
Informe a identifica��o do estabelecimento,
os dados cadastrais do empregado com a respectiva movimenta��o,
o tipo de acerto a efetuar e a compet�ncia (m�s e ano de refer�ncia da informa��o).

Organiza��o do arquivo ACERTO ----------------------------------------

A seq��ncia do arquivo deve ser da seguinte forma:
. O registro de tipo A � �nico,
  e � sempre o primeiro registro do Arquivo ACERTO
  (dados do estabelecimento respons�vel pelo meio magn�tico)

. Todos os outros registros ser�o do tipo X (dados da movimenta��o a acertar)

(* =====================================================================
      Poss�veis erros
========================================================================

001 - Registro A n�o � o primeiro registro no arquivo.
O primeiro registro do arquivo CAGED tem que ser do tipo A,
contendo os dados cadastrais do estabelecimento autorizado e totais de registros informados.

002 - Mais de um registro A no arquivo.
O registro tipo A � �nico e � o primeiro registro no arquivo.

003 - Tipo de registro em branco.
Sem defini��o do tipo de registro n�o � poss�vel continuar a cr�tica.
O tipo de registro pode ser  A, B ou C.

004 - Registro diferente de A, B, C e X.
Tipos de Registro v�lidos para o CAGED:
A - � o primeiro registro do arquivo. Registro tipo �A�  usado  para  informar dados  cadastrais do  estabelecimento autorizado e totais do arquivo CAGED.
B - Registro   tipo  �B�  usado   para   informar   os   dados  de   estabelecimento  que   teve movimenta��o.
C - Registro tipo �C�  usado  para  informar  movimenta��es de trabalhadores ocorridas  no  m�s e  ano  de refer�ncia.
X - Registro de Acerto, se presente no arquivo CAGED, dever�o estar relacionados no final do arquivo.

Qualquer outro tipo de registro n�o � v�lido para informar ao CAGED.

005 - Registro B ou X n�o � o segundo no arquivo.
O segundo registro do arquivo tem que ser do tipo B,
informando os dados de estabelecimento que teve movimenta��o.

006 - Autoriza��o n�o num�rico.
Este campo deve ter o n�mero de autoriza��o fornecido pelo MTE,
caso ainda n�o possua tal n�mero, deixar em branco.

007 - D�gito Verificador da autoriza��o n�o confere.
O DV do n�mero informado diferente do calculado.
Persistindo o erro, favor entrar em contato com o MTE.

008 - Autoriza��o informada com m�scara (/.\-,)
Informar o n�mero da autoriza��o e o DV juntos  sem h�fen,
ponto ou  barra.  Ex: N�mero de Autoriza��o: 013579-8, informar 0135798.

009 - Compet�ncia n�o confere com a informada
O m�s e ano de refer�ncia informado no aplicativo � diferente do m�s e ano de refer�ncia do arquivo.

010 - Compet�ncia em branco, ou zerado.
O campo data de compet�ncia n�o est� preenchido. O preenchimento � obrigat�rio.

011 - Compet�ncia informada com m�scara (/.\-,)
Informar o campo de compet�ncia sem h�fen, ponto ou barra. Ex: Compet�ncia 02/1996, informar 021996.

012 - Compet�ncia n�o num�rico.
Informar somente n�mero  neste campo (m�s com dois d�gitos e ano com quatro d�gitos).

013 - C�digo de altera��o  diferente de 1, 2 e 3.
Utilize os seguintes c�digos:
1 - Nada a alterar
2 - Alterar dados cadastrais
3 - Estabelecimento encerrando atividades (fechamento).

014 - C�digo de altera��o em branco ou zerado.
Preenchimento obrigat�rio. Utilize os seguintes c�digos:
1 - Nada a alterar
2 - Alterar dados cadastrais
3 - Estabelecimento encerrando atividades (fechamento).

015 - C�digo de altera��o n�o num�rico.
Utilize os seguintes c�digos:
1 - Nada a alterar
2 - Alterar dados cadastrais
3 - Estabelecimento encerrando atividades (fechamento).
016 - N�mero de sequ�ncia fora de ordem.
N�mero de registro fora de seq��ncia.

017 - N�mero de seq��ncia em branco ou zerado.
Este campo � num�rico n�o pode estar em branco.

018 - N�mero de sequ�ncia n�o num�rico.
Este campo � num�rico n�o pode estar em branco e nem ter caracteres.

019 - Tipo de identificador diferente de 1 e 2
O n�mero de identificador tem que ser 1=CNPJ ou 2=CEI.

020 - Tipo de identificador em branco ou zerado.
Este campo n�o pode estar em branco, preencher com 1 ou 2

021 - Tipo de identificador n�o num�rico.
Preenchimento obrigat�rio, preencher com o Tipo de Identificador:
1 - CNPJ
2 - CEI

022 - N�mero de identificador n�o num�rico.
N�o pode conter letras, s� n�meros, referente ao CNPJ ou CEI.

023 - N�mero de identificador em branco ou zerado.
Preenchimento obrigat�rio com o n�mero do CNPJ ou do CEI

024 - D�gito(s) Verificador(es) do identificador n�o confere(m).
D�gito Verificador informado diferente do valor calculado, ou n�mero do identificador errado.

025 - N�mero de identificador informado com m�scara (/.\-,).
Preencha o n�mero de identificador sem pontos ou barras.
Ex: O n�mero 33.387.382/0001-07 dever� ser informado 33387382000107.

026 - N�mero de identificador j� informado neste arquivo.
Informe as movimenta��es mensais de um estabelecimento em um mesmo arquivo.
Agrupe todas as movimenta��es e informe apenas uma vez.

027 - N�mero de identificador diferente do informado no registro B.
No registro C foi identificado um movimento para estabelecimento
diferente do informado no registro B pendente.

028 - C�digo da Primeira Declara��o em branco ou zerado.
Este campo n�o pode estar em branco.
Dever ser:
1 - primeira declara��o do CAGED
2 - j� declarou o CAGED anteriormente

029 - C�digo da Primeira Declara��o diferente de 1 e 2.
C�digo da Primeira Declara��o tem que ser:
1 - primeira declara��o do CAGED
2 - j� declarou ao CAGED anteriormente

030 - C�digo da Primeira Declara��o n�o num�rico.
Campo num�rico e preenchimento obrigat�rio. C�digos:
1 - primeira declara��o
2 - j� declarou ao CAGED anteriormente

031 - Nome / Raz�o Social em branco.
Preencher com o nome do estabelecimento (raz�o social).

032 � Endere�o do estabelecimento em branco.
Preencher com o endere�o do estabelecimento.

033 - Bairro em branco.
Preencher com o nome do bairro em que est� localizado o estabelecimento.

034 - CEP em branco, ou zerado.
Preenchimento obrigat�rio.
N�o pode estar em branco. Preencher de acordo com a tabela de CEP do ECT.

035 - CEP com complemento em branco.
O complemento do CEP (3 �ltimas posi��es) est� em branco.
Favor verificar o c�digo correto na tabela da ECT.

036 - C�digo n�o consta na tabela de CEP da ECT.
Favor verificar este n�mero com a ECT,
pois n�o consta  na Tabela de CEP fornecida pela pr�pria ECT.

037 - CEP n�o num�rico.
Campo num�rico, n�o informe letras.
Informe o n�mero do CEP do estabelecimento de acordo com tabela de CEP dos Correios.

038 - CEP informado com m�scara (/.\-,).
Informe apenas o n�mero do CEP sem h�fen ou tra�os. Ex: 20250-130 informe 20250130.

039 - Atividade Econ�mica em branco, ou zerado.
Campo C�digo Nacional de Atividade Econ�mica est� vazio.
Preencher com o c�digo conforme a Tabela CNAE-95.
A op��o Ferramentas possibilita a pesquisa nessa tabela que tamb�m esta dispon�vel no manual do CAGED.

040 - Atividade Econ�mica informada com m�scara (/.\-,).
Informe o c�digo de atividade econ�mica sem h�fen, ponto, v�rgula, barras  ou tra�os.
Ex: Para o c�digo 7220-9 informar 72209.

041 - Atividade Econ�mica n�o consta na tabela CNAE
O c�digo informado n�o existe.
Preencher com o c�digo conforme a Tabela CNAE-95.
A op��o Ferramentas possibilita a pesquisa nessa tabela que tamb�m esta dispon�vel no manual CAGED.

042 - Atividade Econ�mica n�o num�rico.
Preencher com o c�digo conforme a tabela CNAE-95,
a op��o ferramentas possibilita a pesquisa nessa tabela que tamb�m esta dispon�vel no manual do CAGED.

043 - Sigla da UF em branco.
Preenchimento obrigat�rio. Verificar qual a Unidade da Federa��o correspondente.

044 - Sigla n�o consta na tabela de UF.
 A sigla informada inexiste, verifique na tabela de UF a sigla correta.

045 - Sigla da UF n�o pertence ao CEP informado.
Verifique o CEP informado e a sigla da UF. Estas informa��es est�o em conflito.

046 - DDD em branco ou zerado.
Preenchimento obrigat�rio. Informar o DDD do telefone para contato com o estabelecimento.

047 - DDD informado com m�scara (/.\-,)
Informar o c�digo DDD sem par�nteses. Ex: Para o c�digo DDD (011) informar 011.

048 - DDD n�o num�rico.
Campo num�rico, informe somente n�meros.
Informar o DDD do telefone para contato com o estabelecimento.

049 - Telefone em branco ou zerado.
Preenchimento obrigat�rio.
Informar o n�mero do telefone de contato do estabelecimento autorizado.
O n�mero de telefone, o DDD e o ramal (se houver) s�o imprescind�veis para o MTE,
caso necess�rio contatar com o estabelecimento.

050 - Telefone n�o num�rico.
Campo num�rico, n�o informe letras, somente n�meros.
Informar o telefone de contato do estabelecimento.

051 - Telefone informado com m�scara (/.\-,).
Informe o n�mero de telefone sem h�fen, pontos, v�rgulas ou barras.
Ex: Para informar o n�mero 563-7264 informe 5637264.

052 - Total de estabelecimentos n�o confere com a quantidade do arquivo.
O total de estabelecimentos informados no registro tipo A
n�o confere com a quantidade de registros tipo B contida no arquivo CAGED.
Verifique o total de registros tipo B informados e atualize a quantidade no registro tipo A.

053 - Total de estabelecimentos n�o num�rico.
Campo num�rico, n�o informe letras.
Preencher o campo total de estabelecimento no registro A
com as quantidades de estabelecimentos informados no movimento (disquete).

054 - Total de estabelecimentos em branco, ou zerado.
Preenchimento obrigat�rio.
Preencher o campo total de estabelecimentos no registro A,
com a quantidade  de estabelecimentos informados no movimento, registro tipo B.

055 - Total de movimenta��es n�o confere com a quantidade do arquivo.
Total de movimentos informados no registro tipo A
n�o confere com a quantidade de registros tipo C contida no arquivo CAGED.
Verifique o total de registros tipo C informados e atualize a quantidade no registro tipo A (movimento) informados.

056 - Total de movimenta��es n�o num�rico.
Campo num�rico, n�o informe letras.
Preencher o campo total de movimenta��es com o total de movimenta��es  de empregados,
informados no movimento, registro tipo C.

057 - Total de movimenta��es em branco ou zerado.
Preenchimento obrigat�rio.
Preencher o campo total de movimenta��es, registro tipo A,
com a quantidade de movimenta��es informadas no movimento, registro tipo C.

058 - Total de empregados no primeiro dia em branco ou zerado.
Preenchimento obrigat�rio.
Preencher com o total de empregados existentes no in�cio do primeiro dia do m�s e ano informado.

059 - Total de empregados no primeiro dia n�o num�rico.
Campo num�rico, n�o informe letras. Preencher com o total de empregados existentes no in�cio do primeiro dia do m�s e ano informado.

060 - PIS/PASEP em branco .
Preenchimento obrigat�rio.
Preencher com o n�mero do PIS/PASEP do empregado movimentado.
O Aplicativo permite informar o PIS/PASEP gerado somente para primeiro emprego.

061 - PIS/PASEP n�o num�rico.
Campo num�rico, n�o informe letras.
Preencher com o n�mero do PIS/PASEP do empregado movimentado.

062 - PIS/PASEP informado com m�scara (/.\-,).
Preencha o n�mero do PIS/PASEP sem h�fens, pontos ou barras.
Ex: o n�mero do PIS/PASEP 103.28379.39/2 dever� ser informado 10328379392.

063 - N�o � PIS/PASEP. Pode ser contribuinte individual.
O n�mero iniciado de 109 a 119 n�o � PIS/PASEP �
n�mero de Contribuinte Individual (INSS).
Neste caso, entre em contato com a CEF para identificar o n�mero correto do PIS/PASEP.

064 - D�gito Verificador do PIS/PASEP n�o confere.
D�gito Verificador informado diferente do valor calculado.
Verificar o n�mero do PIS/PASEP informado, caso permane�a a d�vida,
entrar em contato com a CEF.

065 - Registro Acerto com PIS/PASEP  em branco ou zerado .
Para registro tipo X, o campo PIS/PASEP n�o pode ser zerado.
Preencher com o n�mero do PIS/PASEP.
A utiliza��o do registro tipo X (Acerto) serve para corrigir informa��es omitidas ou erradas.

066 - Sexo em branco ou zerado.
Preenchimento obrigat�rio. Preencher com  1- Masculino ou 2- Feminino.

067 - Sexo n�o num�rico.
Campo num�rico, n�o informe letra.
Preencher com o n�mero 1 para Masculino ou n�mero 2 para Feminino.

068 - Sexo  diferente de 1 e 2.
Preencher com o n�mero 1 para Masculino ou 2 para Feminino.

069 - Data de nascimento em branco  ou zerado.
Preenchimento obrigat�rio.
Preencher com o dia, m�s e ano de nascimento do empregado movimentado no formato (ddmmaaaa).

070 - Data de Nascimento informado com m�scara (/.\-,).
Informar data de nascimento sem barras, v�rgula, ponto ou tra�os.
Ex: Para a data 16/04/1997, informar 16041997.

071 - Data de nascimento n�o num�rico.
Campo num�rico, n�o informe letras.
Preencher com a data de nascimento do empregado informado, no formato (ddmmaaa).

072 - Dia de Nascimento menor que 1 ou maior que 31.
Informar neste campo somente valores entre 1 e 31. Preencher com o dia correto

073 - M�s de Nascimento em branco ou zerado.
Preenchimento obrigat�rio. Informar o m�s de nascimento correto.
Preencher neste campo somente valores entre 1 a 12.

074 - M�s de Nascimento menor que 1 ou maior que 12
Informe neste campo valores entre 1 a 12 (Informe o m�s correto).

075 - Ano de Nascimento em branco ou zerado.
Preenchimento obrigat�rio.
Informar o ano de nascimento correto no formato (aaaa). Ex: 58 informar 1958.

076 - Empregado com menos de 12 anos.
O Minist�rio do Trabalho pro�be o trabalho para menores de 14 anos de idade.
Salvo como menor aprendiz, a partir dos  12 anos de idade.
O trabalho para menor de 12 anos de idade � proibido.

077 - Dia de Nascimento em branco ou zerado.
Preenchimento obrigat�rio.
Informar o dia de nascimento correto.
Preencher neste campo somente valores entre 1 a 31.

078 -  Grau de instru��o em branco ou zerado.
Preenchimento obrigat�rio.
Informar o grau de instru��o conforme tabela abaixo:
1 - analfabeto, inclusive os que embora tenham recebido instru��o, n�o se alfabetizaram ou tenham esquecido.
2 - at� 4a s�rie incompleta do 1o grau (prim�rio incompleto) ou que se tenha alfabetizado sem ter frequentado escola regular.
3 - 4a s�rie do1o grau (prim�rio) completo.
4 - da 5a a 8a s�rie incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) incompleto.
7 - 2o grau (colegial) completo.
8 - Superior incompleto.
9 - Superior completo.

 079 � Grau de instru��o n�o num�rico.
Campo num�rico, n�o informe letras. Preencher conforme tabela abaixo:
1 - analfabeto, inclusive os que embora tenham recebido instru��o, n�o se alfabetizaram ou tenham esquecido.
2 - at� 4a s�rie incompleta do 1o grau (prim�rio incompleto) ou que se tenha alfabetizado sem ter freq�entado escola regular.
3 - 4a s�rie do1o grau (prim�rio) completo.
4 - da 5a a 8a s�rie incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) incompleto.
7 - 2o grau (colegial) completo.
8 - Superior incompleto.
9 - Superior completo.

080 �Grau de Instru��o diferente de 1, 2, 3, 4, 5, 6, 7, 8, e 9.
Informar o grau de instru��o conforme tabela abaixo:
1 - analfabeto, inclusive os que embora tenham recebido instru��o, n�o se alfabetizaram ou tenham esquecido.
2 - at� 4a s�rie incompleta do 1o grau (prim�rio incompleto)ou que se tenha alfabetizado sem ter frequentado escola regular.
3 - 4a s�rie do 1o grau (prim�rio) completo.
4 - da 5a a 8a s�rie incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) completo.
7 - 2� grau (colegial) completo
8 - superior incompleto.
9 - superior completo.

081 - CBO em branco ou zerado.
Preenchimento obrigat�rio.
Informar o c�digo CBO conforme tabela contida no
Manual do CAGED Informatizado ou se preferir,
acesse a tabela atrav�s da op��o Ferramentas no Menu Principal do ACI.

082 - C�digo n�o consta na Tabela de CBO do MTE.
O c�digo de ocupa��o informado n�o faz parte da tabela de
CBO fornecida pelo Minist�rio do Trabalho.
Preencher com o c�digo CBO conforme ocupa��o do empregado.
Consultar a tabela que consta na Op��o FERRAMENTAS do Menu Principal do ACI ou no Manual do CAGED.

083 - CBO n�o num�rico.
Campo num�rico, n�o informe letras.
Preencher com o c�digo CBO conforme ocupa��o do empregado.
Ver tabela que consta no Manual do CAGED informatizado ou se preferir,
acesse atrav�s da op��o Ferramentas no Menu Principal do Aplicativo.

084 - CBO informado com m�scara (/.\-,).
Informar o c�digo sem pontos, h�fens, v�rgulas ou barras.
Ex: Para informar o c�digo de Economista Rural - CBO: 091.40, informar: 09140.

085 - Remunera��o em branco ou zerado.
Preenchimento obrigat�rio. Preencher com a remunera��o do empregado informado.

086 - Remunera��o n�o num�rico.
Campo num�rico, n�o informe letras. Preencher com a remunera��o do empregado informado.

087 - Remunera��o informada com m�scara (/.\-,).
Informar a remunera��o com centavos, sem colocar a v�rgula ou ponto.
Ex: Para informar remunera��o de R$ 1.870,35  informe 187035.

089 - Horas trabalhadas em branco ou zerado.
Preenchimento obrigat�rio.
Informar o total de horas trabalhadas por semana.
Este valor n�o pode ultrapassar 44 horas semanais.

090 - Horas trabalhadas n�o num�rico.
Campo num�rico, n�o informe letras, somente n�meros.
Preencher com as horas trabalhadas do empregado informado.

091 - Horas trabalhadas menor que 1 ou maior que 44.
A quantidade m�nima de horas trabalhadas semanais � 1 hora e a m�xima 44,
conforme determina��o do Minist�rio do Trabalho.

092 - Data de admiss�o em branco ou zerado.
Preenchimento obrigat�rio.
Informar a data de admiss�o do empregado informado.
(dia com dois d�gitos, m�s com dois d�gitos e ano com quatro d�gitos)

093 - Data de admiss�o informada com  m�scara (/.\-,).
Informar a data de admiss�o sem barras, v�rgulas, pontos ou h�fens.
Ex: Para informar a admiss�o 13/05/96, informar: 13051996.

094 - Dia de admiss�o em branco ou zerado.
O dia da data de admiss�o n�o est� preenchido.
Preencher o dia da admiss�o do empregado informado.

095 - M�s de admiss�o em branco ou zerado.
O m�s da data de admiss�o n�o est� preenchido.
Preencher com o m�s da admiss�o do empregado informado.

096 - M�s e ano para admiss�o diferente da compet�ncia.
O m�s e ano para Primeiro Emprego,
Reemprego e Transfer�ncia de Entrada tem que ser o mesmo da compet�ncia informada.
Para informar esses tipos de admiss�es referentes a meses anteriores,
fazer atrav�s do arquivo Acerto.

097 - Data de admiss�o n�o num�rico.
Campo num�rico, n�o informe letras, somente n�meros.
Preencher com a data de admiss�o do empregado informado.
(dia com dois d�gitos, m�s com dois d�gitos e ano com quatro d�gitos)

098 - Dia de admiss�o menor que 1 ou maior que 31.
O valor  informado equivalente ao dia da data de admiss�o n�o � v�lido.
Informar o dia corretamente. Preencher neste campo somente valores entre 1 a 31.

099 - M�s de admiss�o menor que 1 ou maior que 12.
O valor informado equivalente ao m�s da data de admiss�o n�o � v�lido.
Informar o m�s corretamente. Preencher neste campo somente valores entre 1 a 12.

100 - Ano de Admiss�o em branco ou zerado.
Preenchimento obrigat�rio.
Informar o valor equivalente ao ano da data de admiss�o.
Preencher o ano com quatro d�gitos.

101 - Data de Admiss�o maior que a data do sistema.
A data de admiss�o informada � superior a �Data de Hoje� do seu microcomputador
confirmada como data legal na abertura do Aplicativo.
Verificar qual a data que esta incorreta e proceder o acerto.

102 - Tipo de Movimento diferente 10, 20, 25, 31, 32, 35, 40, 43, 45, 50, 60, 70, 80.
O c�digo do Tipo de Movimento informado n�o existe.
Verificar o c�digo conforme tabela abaixo.
C�digos para Admiss�es:
10 - Primeiro Emprego  35 -  Reintegra��o
20 - Reemprego 70 -  Transfer�ncia de Entrada
25 - Contr. Prazo Determinado
C�digos para Desligamentos:
31 - Dispensa sem justa causa 50 -  Aposentado
32 - Dispensa por justa causa 60 -  Morte
40 - A pedido (espont�neo) 80 -  Transfer�ncia de Sa�da
43 - Term. Prazo Determinado
45 - T�rmino de Contrato

103 - Tipo de Movimento em branco ou zerado.
Preenchimento obrigat�rio.
Informar o c�digo do Tipo de Movimento conforme tabela abaixo.
C�digos para Admiss�es:
10 - Primeiro Emprego  35 -  Reintegra��o
20 -  Reemprego 70 -  Transfer�ncia de Entrada
25 -  Contr. Prazo Determinado
C�digos para Desligamentos:
31 -  Dispensa sem justa causa 50 -  Aposentado
32 -  Dispensa por justa causa 60 -  Morte
40 - A pedido (espont�neo) 80 -  Transfer�ncia de Sa�da
43 -  Term. Prazo Determinado
45 - T�rmino de Contrato

104 - Tipo de Movimento n�o num�rico.
Campo num�rico, n�o informe letras, somente n�meros.
Informar o c�digo do tipo de movimento conforme tabela abaixo.
C�digos para Admiss�es:
10 - Primeiro Emprego  35 -  Reintegra��o
20 -  Reemprego 70 -  Transfer�ncia de Entrada
25 -  Contr. Prazo Determinado
C�digos para Desligamentos:
31 -  Dispensa sem justa causa 50 -  Aposentado
32 -  Dispensa por justa causa 60 -  Morte
40 - A pedido (espont�neo) 80 -  Transfer�ncia de Sa�da
43 -  Term. Prazo Determinado
45 - T�rmino de Contrato

105 - Dia de Desligamento em branco ou zerado.
Preenchimento obrigat�rio para movimenta��o referente a desligamento.
Preencher o dia do desligamento do empregado informado.

106 - Dia de desligamento menor que 1 ou maior que 31.

Valor equivalente ao dia de desligamento n�o � v�lido.
Preencher neste campo somente valores entre 1 a 31.

107 - Nome do empregado em branco.
Preenchimento obrigat�rio. Informar o nome do empregado informado.

108 - N�mero da Carteira de Trabalho em branco.
Preenchimento obrigat�rio. Informar o n�mero da Carteira de Trabalho neste campo.

109 - S�rie da Carteira de Trabalho em branco.
Preenchimento obrigat�rio. Informar o n�mero da S�rie da Carteira de Trabalho neste campo.

110 �Atualiza��o  diferente de 1, 2, e 3.
O valor informado n�o � v�lido. Observar os valores corretos, conforme tabela abaixo:
1 -  Exclus�o de registro informado anteriormente.
2 -  Inclus�o de registro corrente.
3 -  Altera��o de registro informado anteriormente com os dados do registro corrente.

111 - Atualiza��o em branco ou zerado.
Preenchimento obrigat�rio. Informar este c�digo conforme tabela abaixo:
1 -  Exclus�o de registro informado anteriormente.
2 -  Inclus�o de registro corrente.
3 -  Altera��o de registro informado anteriormente com os dados do registro corrente.

112 - Movimenta��o incompat�vel, �ltimo dia negativo.
Foi detectado um erro na informa��o do arquivo.
O total de empregados calculado no �ltimo dia � menor que zero.
Veja a equa��o: T_Ult = T_Prin + T_Adm - T_Desl.
O total de empregados no �ltimo dia (T_Ult) � igual ao total de empregados
no primeiro dia informado (T_Prin) mais todas as admiss�es (T_Adm) menos
todos os desligamentos ocorridos no m�s (T_Desl). Este total n�o pode ser negativo.

113 - Dia de desligamento n�o num�rico.
Informar somente n�mero neste campo (dia com dois d�gitos).

114 - Compet�ncia do Acerto diferente da admiss�o.
Sendo tipo de movimento de admiss�o, m�s/ano de admiss�o tem que ser igual a da compet�ncia.

115 - Ano do nascimento n�o pode ser inferior a 1900.
O empregado com mais de 70 anos n�o precisa informar � Lei 4923/65.

116 - Compet�ncia para arquivo Acerto deixar em branco.
N�o pode preencher o campo compet�ncia para arquivo acerto, deixar em branco.

117 - Total de Estabelecimento para arquivo Acerto deixar em branco.
N�o pode preencher o campo total de Estabelecimento para arquivo acerto, deixar em branco.

118 - Compet�ncia maior que a data do Sistema.
Verificar a data de  compet�ncia, se estiver correta, acertar data do Sistema.

119 - Registro fora de ordem imposs�vel continuar.
Os registros n�o est�o na ordem correta: A,B,C e X.

120 - Tipo de movimento inv�lido para PIS/PASEP zerado.
S� � aceito PIS/PASEP zerado quando o tipo de movimento � 10 - Primeiro Emprego.

122 - CEP n�o pertence a UF informada.
O n�mero do cep n�o pertence a Unidade da Federa��o - UF informada.
Verifique o CEP correto na tabela dos Correios
.
123. Endere�o sem complemento
O endere�o deve conter  n�mero e complemento se n�o houver informe s/n.

125 � Registro �z� n�o � o �ltimo registro do arquivo.
O �ltimo registro do arquivo tem que ser o �z.�

126 � Registro  diferente de �A� e �X� para arquivo Acerto
Registro acerto s� pode ter registro tipo  �A� e �X�

127 � Somente um registro no arquivo
Arquivo tem que conter no m�nimo 02 registros.
(autorizado e o Estabelecimento que est� sendo informando)

132 � Sal�rio M�nimo em branco ou zerado.
Preenchimento obrigat�rio, preencher com o sal�rio m�nimo vigente na compet�ncia.

133 � Contato em Branco
Preencher com o nome da pessoa respons�vel junto ao MTE.

134 � Micro Empresa em branco ou zerado.
Preenchimento obrigat�rio, preencher com : 1 � Sim ou 2 � N�o

135 � Micro Empresa diferente de 1 ou 2.
Preenchimento obrigat�rio, preencher com: 1 � Sim ou 2 - N�o

137 �Ra�a / cor diferente de  0, 2, 4, 6, ou 8.
Preencher com: 2 � Branca
               4 � Preta
               6 � Amarela
               8 � Parda
               0 - Ind�gena

138 � Deficiente F�sico em branco ou zerado
Preenchimento obrigat�rio, preencher com:   1 � Sim ou 2 � N�o

139 � Deficiente F�sico diferente de 1 ou 2.
Preenchimento diferente de 1 ou 2

140 � Data de admiss�o inexistente.
Data inv�lida .Ex. 30/02/1980

141 � Data de nascimento inexistente.
Data inv�lida .Ex. 30/02/1980

142 � C�digo do posto em branco ou zerado
 Preenchimento obrigat�rio, preencher com c�digo do posto

143 � C�digo do posto n�o consta na tabela.
 O c�digo do posto n�o faz parte da tabela do MTE.
 Consultar o Minist�rio do Trabalho e Emprego para conseguir o c�digo correto.

144 � Uso indevido de identificador.
 Esse identificador n�o pertence ao Autorizado /  Estabelecimento informado.
 Informar o identificador correto.

145 � Dia de desligamento inv�lido para compet�ncia informada.
 Dia desligamento inexistente para compet�ncia informada.
 Ex. dia de desligamento 31 para compet�ncia 09/1980.

146 � Nome/raz�o social e CNAE-95 incompat�veis.
 Raz�o social � incompat�vel. com o tipo de atividade do c�digo do CNAE informado.

147 � CNAE-95 incompat�vel com a identifica��o informada.
 O c�digo do CNAE-95 � incompat�vel com a identifica��o informada.
 Verifique na tabela da CNAE-95 o c�digo correto.

148 -  Ano de admiss�o inferior a 1900.
 Ano de admiss�o inv�lido.  Informe o ano de admiss�o correto

149 � Este numero n�o � PIS/PASEP.
 O n�mero informado n�o � PIS/PASEP.
 Verifique com a CEF- Caixa Econ�mica federal,  o n�mero correto para informar

150 � Apenas um registro no arquivo.
 Tem que ter pelo menos dois ( 2 ) registros no arquivo

151 � Compet�ncia do Acerto inv�lido para dia de desligamento.
 Compet�ncia do Acerto inv�lida para o dia desligamento informado.
 Ex. compet�ncia do Acerto: 09/1980 e dia de desligamento 31.

152 � Nome/raz�o social incompleto
 Informe o Nome/raz�o social completo

153 � Data de Admiss�o menor que a Data de Nascimento
 Data inv�lida, preencher com a data de admiss�o correta.

400 � Horas trabalhadas incompat�vel com a remunera��o.
 A quantidade de horas trabalhadas n�o � compat�vel com a remunera��o do empregado.
 A remunera��o m�nima para empregados com mais de 12 horas trabalhadas por semana � � sal�rio m�nimo vigente.
 Para empregados com menos de 12 horas por semana � aceito qualquer remunera��o.

401 � Remunera��o incompat�vel com as horas trabalhadas.
 A remunera��o n�o � compat�vel com as horas trabalhadas do empregado.
 A remunera��o m�nima para empregados com mais de 12 horas trabalhadas por semana � � sal�rio m�nimo vigente.
 Para empregados com menos de 12 horas por semana � aceito qualquer remunera��o

402 � Remunera��o maior que 150 sal�rios m�nimos.
 Mensagem de alerta.

403 � Ra�a / cor em branco.
 Preencher com:
 2 � Branca
 4 � Preta
 6 � Amarela
 8 � Parda
 0 � Ind�gena

404 � Grau de instru��o incompat�vel com o CBO informado.
 Grau de instru��o informado � incompat�vel com o CBO informado.
 Verifique o grau de instru��o na tabela abaixo, se correto  verifique o c�digo do CBO informado na tabela de CBO.

1 - analfabeto, inclusive os que embora tenham recebido instru��o, n�o se alfabetizaram ou tenham esquecido.
2 - at� 4a s�rie incompleta do 1o grau (prim�rio incompleto) ou que se tenha alfabetizado sem ter freq�entado escola regular.
3 - 4a s�rie do1o grau (prim�rio) completo.
4 - da 5a a 8a s�rie incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) incompleto.
7 - 2o grau (colegial) completo.
8 - Superior incompleto.
9 - Superior completo.

405 � Confirma PIS /PASEP zerados informados.
 Mensagem de alerta

406 � Confirma remunera��o menor que � sal�rio m�nimo.
 Mensagem de alerta - A remunera��o m�nima para empregados com
 mais de 12 horas trabalhadas por semana � � sal�rio m�nimo vigente.
 Para empregados com menos de 12 horas por semana � aceito qualquer remunera��o

407 � CNAE-95 incompat�vel com nome / raz�o social informado.
 O c�digo do CNAE-95 � incompat�vel com o tipo de atividade da
 raz�o social informada. Verifique na tabela da CNAE-95 o c�digo correto.

408 � CBO desativado.
 Verifique na tabela de CBO o c�digo correto para a ocupa��o do empregado.

*)


(* =============================================================
Considera��es gerais
================================================================

O Minist�rio do Trabalho e Emprego emitir�, para cada estabelecimento
informado e processado, o Extrato da Movimenta��o Processada,
contendo os dados cadastrais do estabelecimento e o
resumo da movimenta��o processada.
Este recibo � comprovante legal junto � Fiscaliza��o do Trabalho.

Os extratos dos Estabelecimentos ser�o encaminhados ao Estabelecimento
respons�vel pela declara��o do CAGED perante o MTE
(ser� encaminhada ao endere�o constante no registro tipo A ).

Os estabelecimentos ficam obrigados a emitir/apresentar,
quando solicitado pela Fiscaliza��o,
a Rela��o de Movimenta��o Mensal do Cadastro Geral de
Empregados e Desempregados  contendo o resumo da movimenta��o e a rela��o
de empregados movimentados. O ACI permite a emiss�o deste relat�rio
a partir da leitura do Arquivo CAGED.

� facultativa a informa��o aos estabelecimentos que n�o tiverem movimenta��o.
N�o h�obrigatoriedade de informar ao CAGED todos os meses, salvo se ocorrer movimenta��o.

Qualquer estabelecimento poder� utilizar os meios magn�ticos para informar ao
CAGED - Lei No 4923/65, desde que atenda � essas exig�ncias

*)

procedure GeraArquivoCAGED( RegA, RegB, RegC, RegX: TStringList );
var
  Arquivo: TextFile;

  procedure Escreve( Reg: TStringList);
  var
    i: Integer;
  begin
    for i := 0 to (Reg.Count - 1) do
      WriteLn( Arquivo, Reg.Strings[i]);
  end;

begin

  AssignFile( Arquivo,
              ExtractFilePath(Application.ExeName)+'CAGED.RE' );

  try

    Rewrite(Arquivo);

    Escreve( RegA);
    Escreve( RegB);
    Escreve( RegC);
    Escreve( RegX);

  finally
    CloseFile( Arquivo);
  end;  // try

end;

end.
