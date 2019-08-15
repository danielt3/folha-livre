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
O layout do Arquivo CAGED é composto de 04 (quatro) tipos de registro.

 ======  Organização do Arquivo CAGED ===============================

A seqüência do arquivo deve ser da seguinte forma:
. O registro de tipo A é único, e é sempre o primeiro registro do Arquivo CAGED
 (dados do estabelecimento responsável pelo meio magnético);

. O segundo registro do arquivo será sempre um tipo B
 (dados do estabelecimento que teve movimentação no mês/ano de referência);

. Após o registro tipo B, relacione todas as admissões e
  desligamentos ocorridos no estabelecimento informado no tipo B
  (dados de movimentação de empregado) gerando para cada movimentação um registro tipo C;

. Para informar mais de um estabelecimento,
  informar novamente um registro tipo B e subseqüentemente os registros tipo C correspondentes.

. Poderá ser incluído no Arquivo CAGED registros de ACERTO (tipo X)
  sempre no final do arquivo (ver ítem Arquivo ACERTO.)

==============================================================================

A - Registro do estabelecimento responsável pela informação no meio magnético (autorizado).

Neste registro informe o meio físico utilizado,
a competência (mês e ano de referência das informações prestadas),
dados cadastrais do estabelecimento responsável,
telefone para contato, total de estabelecimentos e
total de movimentações informadas no arquivo.
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
    MsgErro( 'A Atividade Economica da Empresa é obrigatória'+#13+
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
    MsgErro( 'Funcionário: '+Nome+#13+
             'O codigo de Admissão/demissão deve ser informado');
    Exit;
  end;

  if ( Length(CodigoRescisao) = 2 ) and
     ( Pos( CodigoRescisao, '31_32_40_43_45_50_60_80') = 0) then begin
      MsgErro( 'Funcionário: '+Nome+#13+
               'O codigo de demissão (campo 13) está invalido');
      Exit;
  end;

  if ( Length(CodigoAdmissao) = 2 ) and
     ( Pos( CodigoAdmissao, '10_20_25_35_70') = 0 ) then begin
      MsgErro( 'Funcionário: '+Nome+#13+
               'O codigo de admissão (campo 13) está invalido');
      Exit;
  end;

  Instrucao := StrZero( StrToInt(Instrucao), 1);

  if not (Instrucao[1] in ['1'..'9']) then begin
      MsgErro( 'Funcionário: '+Nome+#13+
               'O Grau de Instrução (campo 8) é obrigatoria');
    Exit;
  end;

  Raca := StrZero( StrToInt(Raca), 1);

  if not (Raca[1] in ['0','2','4','6','8']) then begin
    MsgErro( 'Funcionário: '+Nome+#13+
             'A Raça/Cor informada só poderá ser 0, 2, 4, 6 ou 8');
    Exit;
  end;

  if Length(PIS) <> 11 then begin
    MsgErro( 'Funcionário: '+Nome+#13+
             'O número do PIS não é valido');
    Exit;
  end;

  if Length(CBO) <> 5 then begin
    MsgErro( 'Funcionário: '+Nome+#13+
             'O número do CBO não é valido');
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
    MsgErro( 'Funcionário: '+C_NOME+#13+
             'A Atualização (campo 19) informada só poderá ser 1, 2 ou 3');
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

(* 1. Tipo de Registro, caracter, 1 posição
Define o registro a ser informado. Obrigatoriamente o conteúdo é A. *)
  sLinha := 'A';

(* 2. Meio Físico, numérico, 1 posição
Informe qual o meio físico utilizado para informar o Arquivo CAGED.
2 - disquete, 3 - fita, 4 - outros  *)
  sLinha := sLinha + A_MEIO_FISICO;

(* 3. Autorização, numérico, 7 posições
Número da Autorização fornecido pelo Ministério do Trabalho e Emprego.
Caso não possua este número informar zeros neste campo. *)
  sLinha := sLinha + PadLeftChar( A_AUTORIZACAO, 7, '0');

(* 4. Competência, numérico, 6 posições
Mês e ano de referência das informações do CAGED.
Informar sem máscara (/.\-,).
Para informar movimentações ocorridas em meses anteriores à da competência,
veja como proceder no ítem Arquivo ACERTO. *)
  sLinha := sLinha + StrZero( A_MES, 2)+StrZero( A_ANO, 4);

(* 5. Alteração, numérico, 1 posição
Define se os dados cadastrais informados irão ou não atualizar
o cadastro de Autorizados do CAGED Informatizado.
1 - Nada a alterar, 2 - Alterar dados cadastrais *)
  sLinha := sLinha + '1';

(* 6. Seqüência, numérico, 5 posições - Número seqüencial no arquivo. *)
  sLinha    := sLinha + StrZero( 1, 5);

(* 7. Tipo de Identificador, numérico, 1 posição
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ, 2 - CEI *)
  sLinha := sLinha + Iif( Length(A_INSCRICAO) = 14, '1', '2');

(* 8. No de Identificador, numérico, 14 posições
Número de Identificador do estabelecimento.
Não havendo inscrição do estabelecimento no
Cadastro Nacional de Pessoa Jurídica (CNPJ),
informar o número de registro no CEI (Código Específico do INSS).
O número do CEI tem 12 posições, preencher este campo com 00 (zeros) à esquerda. *)
  sLinha := sLinha + PadLeftChar( A_INSCRICAO, 14, '0');

(* 9. Nome/Razão Social, caracter, 35 posições
Nome / Razão Social do estabelecimento autorizado. *)
  sLinha := sLinha + PadRightChar( A_NOME, 35, #32);

(*  10. Endereço, caracter, 40 posições
Informar o endereço do estabelecimento (Rua, Av., Trav., Pç.) com número e complemento. *)
  sLinha := sLinha + PadRightChar( A_ENDERECO, 40, #32);

(* 11. CEP, numérico, 8 posições
Informar o Código de Endereçamento Postal do estabelecimento
conforme a tabela da ECT - Empresa de Correios e Telégrafos.
Informar sem máscara (\./-,). *)
  sLinha := sLinha + A_CEP;

(* 12. UF, caracter, 2 posições
Informar a Unidade da Federação. *)
  sLinha := sLinha + A_UF;

(* 13. DDD, caracter, 4 posições
Informar o DDD do telefone para contato com o Ministério do Trabalho e Emprego. *)
  sLinha := sLinha + PadRightChar( A_DDD, 4, #32);

(* 14. Telefone, caracter, 8 posições
Informar o número do telefone para contato do responsável pelas informações contidas no arquivo CAGED. *)
  sLinha := sLinha + PadRightChar( A_TELEFONE, 8, #32);

(* 15. Ramal, caracter, 5 posições
Informar o ramal, se houver, complemento do telefone informado. *)
  sLinha := sLinha + PadRightChar( A_RAMAL, 5, #32);

(* 16. Total Estabelecimentos Informados, numérico, 5 posições
Quantidade de registros tipo B informados no Arquivo CAGED. *)
  sLinha := sLinha + StrZero( 1, 5);

(* 17. Total de Movimentos Informados, numérico, 5 posições
Quantidade de registros tipo C informados no Arquivo CAGED. *)
  sLinha := sLinha + StrZero( TOTAL_C, 5);

(* 18. Filler, caracter, 2 posições - Deixar em branco. *)
  sLinha := sLinha + Espaco(2);

// =====================================

  Result := sLinha ;

end;  // function CAGED_REG_A

(* ----------------------------------------------------------------------------
B - Registro de estabelecimento informado.

Informe neste registro os dados cadastrais do estabelecimento
que teve movimentação (admissões e/ou desligamentos) e
total de empregados existentes no início do primeiro dia do mês informado
(estoque de funcionários).
---------------------------------------------------------------------------- *)

function CAGED_REG_B:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posição
Define o registro a ser informado. Obrigatoriamente o conteúdo é B. *)
  sLinha := 'B';

(* 2. Tipo de Identificador, numérico, 1 posição
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ, 2 - CEI *)
  sLinha := sLinha + Iif( Length(B_INSCRICAO) = 14, '1', '2');

(* 3. No de Identificador, numérico, 14 posições
Número de Identificador do estabelecimento.
Não havendo inscrição do estabelecimento no Cadastro Nacional de Pessoa Jurídica
CNPJ, informar o número de registro no CEI (Código Específico do INSS).
O número do CEI tem 12 posições, preencher este campo com 00 (zeros) à esquerda. *)
  sLinha := sLinha + PadLeftChar( B_INSCRICAO, 14, '0');

(* 4. Seqüência, numérico, 5 posições
Número seqüencial no arquivo. *)
  SEQUENCIA := SEQUENCIA + 1;
  sLinha    := sLinha + StrZero( SEQUENCIA, 5);

(* 6. Primeira Declaração, numérico, 1 posição
Define se é ou não a primeira declaração do estabelecimento ao
CAGED - Cadastro Geral de Empregados e Desempregados - Lei No 4923/65.
1 - primeira declaração, 2 - já informou ao CAGED anteriormente *)
  sLinha := sLinha + Iif( B_PRIMEIRA_DECLARACAO, '1', '2');

(* 7. Alteração, numérico, 1 posição
Define as seguintes ações:
1 - Nada a atualizar
2 - Alterar dados cadastrais do estabelecimento
    (Razão Social, Endereço, CEP, Bairro, UF, ou Atividade Econômica)
3 - Encerramento de Atividades (Fechamento do estabelecimento) *)
  sLinha := sLinha + B_ALTERACAO;

(* 8. CEP, numérico, 8 posições
Informar o Código de Endereçamento Postal do estabelecimento
conforme a tabela da ECT - Empresa de Correios e Telégrafos. Informar sem máscara (\./-,). *)
  sLinha := sLinha + B_CEP;

(* 9. Atividade Econômica, numérico, 5 posições
Informar a Atividade Econômica principal do estabelecimento,
de acordo com a nova Classificação Nacional de Atividades
Econômicas publicada no D.O.U. no dia 26/12/94. Informar o código sem máscara(/.\-,). *)
  sLinha := sLinha + B_ATIVIDADE_ECONOMICA;

(* 10. Nome do Estabelecimento/Razão Social, caracter, 40 posições
Nome / Razão Social do estabelecimento. *)
  sLinha := sLinha + PadRightChar( B_NOME, 40, #32);

  (* 11. Endereço, caracter, 40 posições
  Informar o endereço do estabelecimento (Rua, Av., Trav., Pç.) com número e complemento. *)
  sLinha := sLinha + PadRightChar( B_ENDERECO, 40, #32);

  (* 12. Bairro, caracter, 20 posições - Informar o bairro correspondente. *)
  sLinha := sLinha + PadRightChar( B_BAIRRO, 20, #32);

  (* 13. UF, caracter, 2 posições - Informar a Unidade da Federação. *)
  sLinha := sLinha + B_UF;

(* 14. Total Empregados Existentes 1o dia, numérico, 5 posições
Total de empregados existentes na empresa no início do primeiro
dia do mês de referência (competência). *)
  sLinha := sLinha + StrZero( B_TOTAL_EMPREGADO, 5);

(* 15. Empresa Pequeno Porte/Micro Empresa, alfa-numérico, 1 posição
No módulo analisador, preencher com:
1 – Sim, 2 – Não
No módulo gerador, preencher com:
S – Sim, N - Não *)
   sLinha := sLinha + Iif( B_PEQUENO_PORTE, '1', '2');

  (* 16. Filler, caracter, 6 posições - Deixar em branco. *)
  sLinha := sLinha + Espaco(6);

  // =================================
  Result := sLinha;

end;  // function CAGED_REG_B

(* ----------------------------------------------------------------------------
C - Registro da movimentação do empregado informado.

Informe aqui a identificação do estabelecimento,
os dados cadastrais do empregado e a sua respectiva movimentação.
Informe um registro tipo C para cada movimentação ocorrida.
No caso de empregado admitido e desligado no mesmo mês de competência,
informar dois registros tipo C, o primeiro com a admissão e o outro com o desligamento.
---------------------------------------------------------------------------- *)

function CAGED_REG_C:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posição
Define o registro a ser informado. Obrigatoriamente o conteúdo é C. *)

  sLinha := 'C';

(* 2. Tipo de Identificador, numérico, 1 posição
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ ou 2 - CEI *)
  sLinha := sLinha + Iif( Length(B_INSCRICAO) = 14, '1', '2');

(* 3. No de Identificador, numérico, 14 posições
Número de Identificador do estabelecimento.
Não havendo inscrição do estabelecimento no Cadastro Nacional de Pessoa Jurídica (CNPJ),
informar o número de registro no CEI (Código Específico do INSS).
O número do CEI tem 12 posições, preencher este campo com 00 (zeros) à esquerda. *)
  sLinha := sLinha + PadLeftChar( B_INSCRICAO, 14, '0');

(* 4. Seqüência, numérico, 5 posições
Número seqüencial no arquivo. *)
  SEQUENCIA := SEQUENCIA + 1;
  sLinha    := sLinha + StrZero( SEQUENCIA, 5);

(* 5. PIS/PASEP, numérico, 11 posições
Número do PIS/PASEP do empregado movimentado. Informar sem máscara (/.\-,). *)
  sLinha := sLinha + C_PIS;

(* 6. Sexo, numérico, 1 posição
Define o sexo do empregado:
1 - Masculino ou 2 - Feminino *)
  sLinha := sLinha + Iif( UpperCase(C_SEXO) = 'M', '1', '2');

(* 7. Nascimento, numérico, 8 posições
Dia, mês e ano de nascimento do empregado.
Informar a data do nascimento sem máscara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_NASCIMENTO);

(* 8. Instrução, numérico, 1 posição
Define grau de instrução do empregado:
1 - analfabeto, inclusive os que embora tenham recebido instrução,não se alfabetizaram ou tenham esquecido;
2 - até 4a série incompleta do 1o grau (primário incompleto ou que se tenha alfabetizado sem ter freqüentado escola regular);
3 - 4a série completa do 1o grau (primário completo);
4 - da 5a à 8a série incompleta do 1o grau (ginasial incompleto);
5 - 1o grau (ginasial) completo;
6 - 2o grau (colegial) incompleto;
7 - 2o grau (colegial) completo;
8 - superior incompleto;
9 - superior completo. *)
  sLinha := sLinha + C_INSTRUCAO;

(* 9. CBO, numérico, 5 posições
Informe o código de ocupação conforme a
Classificação Brasileira de Ocupação - CBO. Informar sem máscara (/.\-,). *)
  sLinha := sLinha + C_CBO;

(* 10. Remuneração, numérico, 8 posições
Informar o salário recebido, ou a receber.
Informar com centavos sem pontos e sem vírgulas. Ex.: R$134,60 informar: 13460. *)
  sLinha := sLinha + StrZero( Trunc(C_SALARIO*100), 8);

(* 11. Horas Trabalhadas, numérico, 2 posições
Informar a quantidade de horas trabalhadas por semana. (de 1 até 44 horas). *)
  sLinha := sLinha + StrZero( C_HORAS_SEMANA, 2);

(* 12. Admissão, numérico de 8 posições
Dia, mês e ano de admissão do empregado. Informar a data de admissão sem máscara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_ADMISSAO);

(* 13. Tipo de Movimentação, numérico, 2 posições - Define o tipo de movimento:
ADMISSÕES -    10 - primeiro emprego;
               20 - reemprego;
               25 - Contr, Prazo determinado;
               35 - reintegração;
               70 - transferência de entrada.

DESLIGAMENTOS - 31 - dispensa sem justa causa;
                32 - dispensa por justa causa;
                40 - a pedido (espontâneo);
                43 - Term. Prazo determinado;
                45 - término de contrato;
                50 - aposentado;
                60 - morte;
                80 - transferência de saída. *)
  sLinha := sLinha + C_TIPO_MOVIMENTACAO ;

(* 14. Dia de Desligamento, numérico, 2 posições
Se o tipo de movimentação for desligamento,
informar o dia da saída do empregado, se for admissão deixar em branco. *)
  if (C_RESCISAO = 0) then
    sLinha := sLinha + Espaco(2)
  else
    sLinha := sLinha + FormatDateTime( 'DD', C_RESCISAO);

(* 15. Nome do Empregado, caracter, 40 posições
Informar o nome do empregado movimentado. *)
  sLinha := sLinha + PadRightChar( C_NOME, 40, #32);

(* 16. Número da Carteira de Trabalho, numérico, 7 posições
Informar o número da Carteira de Trabalho e Previdência Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS, 7, '0');

(* 17. Série da Carteira de Trabalho, numérico, 3 posições
Informar o número de série da Carteira de Trabalho e Previdência Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS_SERIE, 3, '0');

(* 18. UF da Carteira de Trabalho, caracter, 2 posições
Informar a UF da Carteira de Trabalho e Previdência Social do empregado. *)
  sLinha := sLinha + C_CTPS_UF;

(* 19. Filler, caracter, 7 posições - Deixar em branco. *)
  sLinha := sLinha + Espaco(7);

  (* 20. Raça/Cor, numérico, 1 posição
  Preencher com: 2 – Branca, 4 – Preta, 6 – Amarela, 8 – Parda, 0 – Indígena *)
  sLinha := sLinha + C_RACA ;

(* 21. Deficiente Físico, alfanumérico, 1 posição
Preencher com, no módulo analisador:
1 – Sim ou 2 – Não
Preencher com, no módulo gerador:
S – Sim ou N - Não *)
  sLinha := sLinha + Iif( C_DEFICIENTE, '1', '2');

(* 22. Filler, caracter, 20 posições - Deixar em branco. *)
  sLinha := sLinha + Espaco(20);

  // ===================================================================
  Result := sLinha ;
  TOTAL_C := TOTAL_C + 1;

end;  // function CAGED_REG_C

(* ----------------------------------------------------------------------------
X - Registro da Movimentação do empregado para atualizar.

 Informe a identificação do estabelecimento,
 os dados cadastrais do empregado com a respectiva movimentação,
 o tipo de acerto a efetuar e a competência ( mês e ano de referência da informação ).
---------------------------------------------------------------------------- *)

function CAGED_REG_X:String;
var
  sLinha: String;
begin

  Result := '';

(* 1. Tipo de Registro, caracter, 1 posição
Define o registro a ser informado. Obrigatoriamente o conteúdo é X. *)
  sLinha := 'X';

(* 2. Tipo de Identificador, numérico, 1 posição
Define o tipo de identificador do estabelecimento a informar.
1 - CNPJ ou 2 - CEI *)
  sLinha := sLinha + Iif( Length(B_INSCRICAO) = 14, '1', '2');

  (* 3. No de Identificador, numérico, 14 posições
Número de Identificador do estabelecimento. Não havendo
inscrição do estabelecimento no Cadastro Nacional de Pessoa Jurídica (CNPJ),
informar o número de registro no CEI (Código Específico do INSS).
O número do CEI tem 12 posições, preencher este campo com 00 (zeros) à esquerda. *)
  sLinha := sLinha + PadLeftChar( B_INSCRICAO, 14, '0');

(* 4. Seqüência, numérico, 5 posições
Número seqüencial no arquivo. *)
  SEQUENCIA := SEQUENCIA + 1;
  sLinha    := sLinha + StrZero( SEQUENCIA, 5);

(* 5. PIS/PASEP, numérico, 11 posições
Número do PIS/PASEP do empregado movimentado. Informar sem máscara (/.\-,). *)
  sLinha := sLinha + C_PIS;

(* 6. Sexo, numérico, 1 posição
Define o sexo do empregado: 1 - Masculino ou 2 - Feminino *)
  sLinha := sLinha + Iif( UpperCase(C_SEXO) = 'M', '1', '2');

(* 7. Nascimento, numérico,8 posições
Dia, mês e ano de nascimento do empregado.
Informar a data do nascimento sem máscara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_NASCIMENTO);

(* 8. Instrução, numérico, 1 posição
Define grau de instrução do empregado:
1 - analfabeto, inclusive os que embora tenham recebido instrução,não se alfabetizaram ou tenham esquecido;
2 - até 4a série incompleta do 1o grau (primário incompleto ou que se tenha alfabetizado sem ter freqüentado escola regular;
3 - 4a série completa do 1o grau (primário completo);
4 - da 5a a 8asérie incompleta do 1o grau (ginasial incompleto);
5 - 1o grau (ginasial) completo;
6 - 2o grau (colegial) incompleto;
7 - 2o grau (colegial) completo;
8 - superior incompleto;
9 - superior completo. *)
  sLinha := sLinha + C_INSTRUCAO;

(* 9. CBO, numérico, 5 posições
Informe o código de ocupação conforme a Classificação Brasileira de Ocupação - CBO.
Informar sem máscara (/.\-,). *)
  sLinha := sLinha + C_CBO;

(* 10. Remuneração, numérico, 8 posições
Informar o salário recebido ou a receber.
Informar com centavos sem pontos e sem vírgulas. Ex.: R$134,60 informar: 13460. *)
  sLinha := sLinha + StrZero( Trunc(C_SALARIO*100), 8);

(* 11. Horas Trabalhadas, numérico, 2 posições
Informar a quantidade de horas trabalhadas por semana (de 1 até 44 horas). *)
  sLinha := sLinha + StrZero( C_HORAS_SEMANA, 2);

(* 12. Admissão, numérico de 8 posições
Dia, mês e ano de admissão do empregado.
Informar a data de admissão sem máscara (/.\-,). *)
  sLinha := sLinha + FormatDateTime( 'DDMMYYYY', C_ADMISSAO);

(* 13. Tipo de Movimentação, numérico, 2 posições
Define o tipo de movimento:
ADMISSÕES   10 - primeiro emprego
            20 - reemprego
            25 - Contr, Prazo determinado;
            35 - reintegração
            70 - transferência de entrada

DESLIGAMENTOS 31 - dispensa sem justa causa
              32 - dispensa por justa causa
              40 - a pedido (espontâneo);
              43 - Term. Prazo determinado;
              45 - término de contrato;
              50 - aposentado;
              60 - morte
              80 - transferência de saída  *)
  sLinha := sLinha + C_TIPO_MOVIMENTACAO;

(* 14. Dia de Desligamento, numérico, 2 posições
Se o tipo de movimentação for desligamento,
informar o dia da saída do empregado, se for admissão deixar em branco. *)
  sLinha := sLinha + Iif( (C_RESCISAO = 0), Espaco(2),
                          FormatDateTime( 'DD', C_RESCISAO) ) ;

(* 15. Nome do Empregado, caracter, 40 posições
Informar o nome do empregado movimentado. *)
  sLinha := sLinha + PadRightChar( C_NOME, 40, #32);

(* 16. Número da Carteira de Trabalho, numérico, 7 posições
Informar o número da Carteira de Trabalho e Previdência Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS, 7, '0');

(* 17. Série da Carteira de Trabalho, numérico, 3 posições
Informar o número de série da Carteira de Trabalho e Previdência Social do empregado. *)
  sLinha := sLinha + PadLeftChar( C_CTPS_SERIE, 3, '0');

(* 18. UF da Carteira de Trabalho, caracter, 2 posições
Informar a UF da Carteira de Trabalho e Previdência Social do empregado. *)
  sLinha := sLinha + C_CTPS_UF;

(* 19. Atualização, numérico, 1 posição
Informar o procedimento a ser seguido:
1 - exclusão de registro, 2 - inclusão de registro, 3 - alteração de registro *)
  sLinha := sLinha + X_ATUALIZACAO;

(* 20. Competência, numérico, 6 posições
Mês e ano de referência das informações do registro. Informar sem máscara (/.\-,). *)
  sLinha := sLinha + StrZero( A_MES, 2)+StrZero( A_ANO, 4);

(* 21. Raça/Cor, numérico, 1 posição
Preencher com: 2 – Branca, 4 – Preta, 6 – Amarela, 8 – Parda, 0 – Indígena *)
  sLinha := sLinha + C_RACA;

(* 22. Deficiente Físico, alfanumérico, 1 posição
Preencher com, no módulo analisador:
1 – Sim ou 2 – Não
Preencher com, no módulo gerador:
S – Sim ou N - Não *)
  sLinha := sLinha + Iif( C_DEFICIENTE, '1', '2');

(* 23. Filler, caracter, 22 posições
Deixar em branco. *)
  sLinha := sLinha + Espaco(22);

  // =====================================================================
  Result := sLinha;

end;  // function CAGED_REG_X


(* ========================================================
     Arquivo ACERTO
   ==================================

Utilize este arquivo sempre que for informar movimentações referentes a meses
anteriores à competência atual.
Se for encaminhar no mesmo mês o Arquivo CAGED,
estes acertos poderão ser relacionados no final do arquivo,
sempre após o último registro informado.

Neste caso não será necessário um outro registro A, somente os registros X.

Layout do arquivo ACERTO ---------------------------------------

A - Registro do estabelecimento responsável pelo arquivo CAGED.

Neste registro informe o meio físico utilizado,
dados cadastrais do estabelecimento responsável,
telefone para contato, totais de movimentações informadas no arquivo.

X - Registro da movimentação do empregado para atualizar.
Informe a identificação do estabelecimento,
os dados cadastrais do empregado com a respectiva movimentação,
o tipo de acerto a efetuar e a competência (mês e ano de referência da informação).

Organização do arquivo ACERTO ----------------------------------------

A seqüência do arquivo deve ser da seguinte forma:
. O registro de tipo A é único,
  e é sempre o primeiro registro do Arquivo ACERTO
  (dados do estabelecimento responsável pelo meio magnético)

. Todos os outros registros serão do tipo X (dados da movimentação a acertar)

(* =====================================================================
      Possíveis erros
========================================================================

001 - Registro A não é o primeiro registro no arquivo.
O primeiro registro do arquivo CAGED tem que ser do tipo A,
contendo os dados cadastrais do estabelecimento autorizado e totais de registros informados.

002 - Mais de um registro A no arquivo.
O registro tipo A é único e é o primeiro registro no arquivo.

003 - Tipo de registro em branco.
Sem definição do tipo de registro não é possível continuar a crítica.
O tipo de registro pode ser  A, B ou C.

004 - Registro diferente de A, B, C e X.
Tipos de Registro válidos para o CAGED:
A - É o primeiro registro do arquivo. Registro tipo “A”  usado  para  informar dados  cadastrais do  estabelecimento autorizado e totais do arquivo CAGED.
B - Registro   tipo  “B”  usado   para   informar   os   dados  de   estabelecimento  que   teve movimentação.
C - Registro tipo “C”  usado  para  informar  movimentações de trabalhadores ocorridas  no  mês e  ano  de referência.
X - Registro de Acerto, se presente no arquivo CAGED, deverão estar relacionados no final do arquivo.

Qualquer outro tipo de registro não é válido para informar ao CAGED.

005 - Registro B ou X não é o segundo no arquivo.
O segundo registro do arquivo tem que ser do tipo B,
informando os dados de estabelecimento que teve movimentação.

006 - Autorização não numérico.
Este campo deve ter o número de autorização fornecido pelo MTE,
caso ainda não possua tal número, deixar em branco.

007 - Dígito Verificador da autorização não confere.
O DV do número informado diferente do calculado.
Persistindo o erro, favor entrar em contato com o MTE.

008 - Autorização informada com máscara (/.\-,)
Informar o número da autorização e o DV juntos  sem hífen,
ponto ou  barra.  Ex: Número de Autorização: 013579-8, informar 0135798.

009 - Competência não confere com a informada
O mês e ano de referência informado no aplicativo é diferente do mês e ano de referência do arquivo.

010 - Competência em branco, ou zerado.
O campo data de competência não está preenchido. O preenchimento é obrigatório.

011 - Competência informada com máscara (/.\-,)
Informar o campo de competência sem hífen, ponto ou barra. Ex: Competência 02/1996, informar 021996.

012 - Competência não numérico.
Informar somente número  neste campo (mês com dois dígitos e ano com quatro dígitos).

013 - Código de alteração  diferente de 1, 2 e 3.
Utilize os seguintes códigos:
1 - Nada a alterar
2 - Alterar dados cadastrais
3 - Estabelecimento encerrando atividades (fechamento).

014 - Código de alteração em branco ou zerado.
Preenchimento obrigatório. Utilize os seguintes códigos:
1 - Nada a alterar
2 - Alterar dados cadastrais
3 - Estabelecimento encerrando atividades (fechamento).

015 - Código de alteração não numérico.
Utilize os seguintes códigos:
1 - Nada a alterar
2 - Alterar dados cadastrais
3 - Estabelecimento encerrando atividades (fechamento).
016 - Número de sequência fora de ordem.
Número de registro fora de seqüência.

017 - Número de seqüência em branco ou zerado.
Este campo é numérico não pode estar em branco.

018 - Número de sequência não numérico.
Este campo é numérico não pode estar em branco e nem ter caracteres.

019 - Tipo de identificador diferente de 1 e 2
O número de identificador tem que ser 1=CNPJ ou 2=CEI.

020 - Tipo de identificador em branco ou zerado.
Este campo não pode estar em branco, preencher com 1 ou 2

021 - Tipo de identificador não numérico.
Preenchimento obrigatório, preencher com o Tipo de Identificador:
1 - CNPJ
2 - CEI

022 - Número de identificador não numérico.
Não pode conter letras, só números, referente ao CNPJ ou CEI.

023 - Número de identificador em branco ou zerado.
Preenchimento obrigatório com o número do CNPJ ou do CEI

024 - Dígito(s) Verificador(es) do identificador não confere(m).
Dígito Verificador informado diferente do valor calculado, ou número do identificador errado.

025 - Número de identificador informado com máscara (/.\-,).
Preencha o número de identificador sem pontos ou barras.
Ex: O número 33.387.382/0001-07 deverá ser informado 33387382000107.

026 - Número de identificador já informado neste arquivo.
Informe as movimentações mensais de um estabelecimento em um mesmo arquivo.
Agrupe todas as movimentações e informe apenas uma vez.

027 - Número de identificador diferente do informado no registro B.
No registro C foi identificado um movimento para estabelecimento
diferente do informado no registro B pendente.

028 - Código da Primeira Declaração em branco ou zerado.
Este campo não pode estar em branco.
Dever ser:
1 - primeira declaração do CAGED
2 - já declarou o CAGED anteriormente

029 - Código da Primeira Declaração diferente de 1 e 2.
Código da Primeira Declaração tem que ser:
1 - primeira declaração do CAGED
2 - já declarou ao CAGED anteriormente

030 - Código da Primeira Declaração não numérico.
Campo numérico e preenchimento obrigatório. Códigos:
1 - primeira declaração
2 - já declarou ao CAGED anteriormente

031 - Nome / Razão Social em branco.
Preencher com o nome do estabelecimento (razão social).

032 – Endereço do estabelecimento em branco.
Preencher com o endereço do estabelecimento.

033 - Bairro em branco.
Preencher com o nome do bairro em que está localizado o estabelecimento.

034 - CEP em branco, ou zerado.
Preenchimento obrigatório.
Não pode estar em branco. Preencher de acordo com a tabela de CEP do ECT.

035 - CEP com complemento em branco.
O complemento do CEP (3 últimas posições) está em branco.
Favor verificar o código correto na tabela da ECT.

036 - Código não consta na tabela de CEP da ECT.
Favor verificar este número com a ECT,
pois não consta  na Tabela de CEP fornecida pela própria ECT.

037 - CEP não numérico.
Campo numérico, não informe letras.
Informe o número do CEP do estabelecimento de acordo com tabela de CEP dos Correios.

038 - CEP informado com máscara (/.\-,).
Informe apenas o número do CEP sem hífen ou traços. Ex: 20250-130 informe 20250130.

039 - Atividade Econômica em branco, ou zerado.
Campo Código Nacional de Atividade Econômica está vazio.
Preencher com o código conforme a Tabela CNAE-95.
A opção Ferramentas possibilita a pesquisa nessa tabela que também esta disponível no manual do CAGED.

040 - Atividade Econômica informada com máscara (/.\-,).
Informe o código de atividade econômica sem hífen, ponto, vírgula, barras  ou traços.
Ex: Para o código 7220-9 informar 72209.

041 - Atividade Econômica não consta na tabela CNAE
O código informado não existe.
Preencher com o código conforme a Tabela CNAE-95.
A opção Ferramentas possibilita a pesquisa nessa tabela que também esta disponível no manual CAGED.

042 - Atividade Econômica não numérico.
Preencher com o código conforme a tabela CNAE-95,
a opção ferramentas possibilita a pesquisa nessa tabela que também esta disponível no manual do CAGED.

043 - Sigla da UF em branco.
Preenchimento obrigatório. Verificar qual a Unidade da Federação correspondente.

044 - Sigla não consta na tabela de UF.
 A sigla informada inexiste, verifique na tabela de UF a sigla correta.

045 - Sigla da UF não pertence ao CEP informado.
Verifique o CEP informado e a sigla da UF. Estas informações estão em conflito.

046 - DDD em branco ou zerado.
Preenchimento obrigatório. Informar o DDD do telefone para contato com o estabelecimento.

047 - DDD informado com máscara (/.\-,)
Informar o código DDD sem parênteses. Ex: Para o código DDD (011) informar 011.

048 - DDD não numérico.
Campo numérico, informe somente números.
Informar o DDD do telefone para contato com o estabelecimento.

049 - Telefone em branco ou zerado.
Preenchimento obrigatório.
Informar o número do telefone de contato do estabelecimento autorizado.
O número de telefone, o DDD e o ramal (se houver) são imprescindíveis para o MTE,
caso necessário contatar com o estabelecimento.

050 - Telefone não numérico.
Campo numérico, não informe letras, somente números.
Informar o telefone de contato do estabelecimento.

051 - Telefone informado com máscara (/.\-,).
Informe o número de telefone sem hífen, pontos, vírgulas ou barras.
Ex: Para informar o número 563-7264 informe 5637264.

052 - Total de estabelecimentos não confere com a quantidade do arquivo.
O total de estabelecimentos informados no registro tipo A
não confere com a quantidade de registros tipo B contida no arquivo CAGED.
Verifique o total de registros tipo B informados e atualize a quantidade no registro tipo A.

053 - Total de estabelecimentos não numérico.
Campo numérico, não informe letras.
Preencher o campo total de estabelecimento no registro A
com as quantidades de estabelecimentos informados no movimento (disquete).

054 - Total de estabelecimentos em branco, ou zerado.
Preenchimento obrigatório.
Preencher o campo total de estabelecimentos no registro A,
com a quantidade  de estabelecimentos informados no movimento, registro tipo B.

055 - Total de movimentações não confere com a quantidade do arquivo.
Total de movimentos informados no registro tipo A
não confere com a quantidade de registros tipo C contida no arquivo CAGED.
Verifique o total de registros tipo C informados e atualize a quantidade no registro tipo A (movimento) informados.

056 - Total de movimentações não numérico.
Campo numérico, não informe letras.
Preencher o campo total de movimentações com o total de movimentações  de empregados,
informados no movimento, registro tipo C.

057 - Total de movimentações em branco ou zerado.
Preenchimento obrigatório.
Preencher o campo total de movimentações, registro tipo A,
com a quantidade de movimentações informadas no movimento, registro tipo C.

058 - Total de empregados no primeiro dia em branco ou zerado.
Preenchimento obrigatório.
Preencher com o total de empregados existentes no início do primeiro dia do mês e ano informado.

059 - Total de empregados no primeiro dia não numérico.
Campo numérico, não informe letras. Preencher com o total de empregados existentes no início do primeiro dia do mês e ano informado.

060 - PIS/PASEP em branco .
Preenchimento obrigatório.
Preencher com o número do PIS/PASEP do empregado movimentado.
O Aplicativo permite informar o PIS/PASEP gerado somente para primeiro emprego.

061 - PIS/PASEP não numérico.
Campo numérico, não informe letras.
Preencher com o número do PIS/PASEP do empregado movimentado.

062 - PIS/PASEP informado com máscara (/.\-,).
Preencha o número do PIS/PASEP sem hífens, pontos ou barras.
Ex: o número do PIS/PASEP 103.28379.39/2 deverá ser informado 10328379392.

063 - Não é PIS/PASEP. Pode ser contribuinte individual.
O número iniciado de 109 a 119 não é PIS/PASEP é
número de Contribuinte Individual (INSS).
Neste caso, entre em contato com a CEF para identificar o número correto do PIS/PASEP.

064 - Dígito Verificador do PIS/PASEP não confere.
Dígito Verificador informado diferente do valor calculado.
Verificar o número do PIS/PASEP informado, caso permaneça a dúvida,
entrar em contato com a CEF.

065 - Registro Acerto com PIS/PASEP  em branco ou zerado .
Para registro tipo X, o campo PIS/PASEP não pode ser zerado.
Preencher com o número do PIS/PASEP.
A utilização do registro tipo X (Acerto) serve para corrigir informações omitidas ou erradas.

066 - Sexo em branco ou zerado.
Preenchimento obrigatório. Preencher com  1- Masculino ou 2- Feminino.

067 - Sexo não numérico.
Campo numérico, não informe letra.
Preencher com o número 1 para Masculino ou número 2 para Feminino.

068 - Sexo  diferente de 1 e 2.
Preencher com o número 1 para Masculino ou 2 para Feminino.

069 - Data de nascimento em branco  ou zerado.
Preenchimento obrigatório.
Preencher com o dia, mês e ano de nascimento do empregado movimentado no formato (ddmmaaaa).

070 - Data de Nascimento informado com máscara (/.\-,).
Informar data de nascimento sem barras, vírgula, ponto ou traços.
Ex: Para a data 16/04/1997, informar 16041997.

071 - Data de nascimento não numérico.
Campo numérico, não informe letras.
Preencher com a data de nascimento do empregado informado, no formato (ddmmaaa).

072 - Dia de Nascimento menor que 1 ou maior que 31.
Informar neste campo somente valores entre 1 e 31. Preencher com o dia correto

073 - Mês de Nascimento em branco ou zerado.
Preenchimento obrigatório. Informar o mês de nascimento correto.
Preencher neste campo somente valores entre 1 a 12.

074 - Mês de Nascimento menor que 1 ou maior que 12
Informe neste campo valores entre 1 a 12 (Informe o mês correto).

075 - Ano de Nascimento em branco ou zerado.
Preenchimento obrigatório.
Informar o ano de nascimento correto no formato (aaaa). Ex: 58 informar 1958.

076 - Empregado com menos de 12 anos.
O Ministério do Trabalho proíbe o trabalho para menores de 14 anos de idade.
Salvo como menor aprendiz, a partir dos  12 anos de idade.
O trabalho para menor de 12 anos de idade é proibido.

077 - Dia de Nascimento em branco ou zerado.
Preenchimento obrigatório.
Informar o dia de nascimento correto.
Preencher neste campo somente valores entre 1 a 31.

078 -  Grau de instrução em branco ou zerado.
Preenchimento obrigatório.
Informar o grau de instrução conforme tabela abaixo:
1 - analfabeto, inclusive os que embora tenham recebido instrução, não se alfabetizaram ou tenham esquecido.
2 - até 4a série incompleta do 1o grau (primário incompleto) ou que se tenha alfabetizado sem ter frequentado escola regular.
3 - 4a série do1o grau (primário) completo.
4 - da 5a a 8a série incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) incompleto.
7 - 2o grau (colegial) completo.
8 - Superior incompleto.
9 - Superior completo.

 079 – Grau de instrução não numérico.
Campo numérico, não informe letras. Preencher conforme tabela abaixo:
1 - analfabeto, inclusive os que embora tenham recebido instrução, não se alfabetizaram ou tenham esquecido.
2 - até 4a série incompleta do 1o grau (primário incompleto) ou que se tenha alfabetizado sem ter freqüentado escola regular.
3 - 4a série do1o grau (primário) completo.
4 - da 5a a 8a série incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) incompleto.
7 - 2o grau (colegial) completo.
8 - Superior incompleto.
9 - Superior completo.

080 –Grau de Instrução diferente de 1, 2, 3, 4, 5, 6, 7, 8, e 9.
Informar o grau de instrução conforme tabela abaixo:
1 - analfabeto, inclusive os que embora tenham recebido instrução, não se alfabetizaram ou tenham esquecido.
2 - até 4a série incompleta do 1o grau (primário incompleto)ou que se tenha alfabetizado sem ter frequentado escola regular.
3 - 4a série do 1o grau (primário) completo.
4 - da 5a a 8a série incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) completo.
7 - 2º grau (colegial) completo
8 - superior incompleto.
9 - superior completo.

081 - CBO em branco ou zerado.
Preenchimento obrigatório.
Informar o código CBO conforme tabela contida no
Manual do CAGED Informatizado ou se preferir,
acesse a tabela através da opção Ferramentas no Menu Principal do ACI.

082 - Código não consta na Tabela de CBO do MTE.
O código de ocupação informado não faz parte da tabela de
CBO fornecida pelo Ministério do Trabalho.
Preencher com o código CBO conforme ocupação do empregado.
Consultar a tabela que consta na Opção FERRAMENTAS do Menu Principal do ACI ou no Manual do CAGED.

083 - CBO não numérico.
Campo numérico, não informe letras.
Preencher com o código CBO conforme ocupação do empregado.
Ver tabela que consta no Manual do CAGED informatizado ou se preferir,
acesse através da opção Ferramentas no Menu Principal do Aplicativo.

084 - CBO informado com máscara (/.\-,).
Informar o código sem pontos, hífens, vírgulas ou barras.
Ex: Para informar o código de Economista Rural - CBO: 091.40, informar: 09140.

085 - Remuneração em branco ou zerado.
Preenchimento obrigatório. Preencher com a remuneração do empregado informado.

086 - Remuneração não numérico.
Campo numérico, não informe letras. Preencher com a remuneração do empregado informado.

087 - Remuneração informada com máscara (/.\-,).
Informar a remuneração com centavos, sem colocar a vírgula ou ponto.
Ex: Para informar remuneração de R$ 1.870,35  informe 187035.

089 - Horas trabalhadas em branco ou zerado.
Preenchimento obrigatório.
Informar o total de horas trabalhadas por semana.
Este valor não pode ultrapassar 44 horas semanais.

090 - Horas trabalhadas não numérico.
Campo numérico, não informe letras, somente números.
Preencher com as horas trabalhadas do empregado informado.

091 - Horas trabalhadas menor que 1 ou maior que 44.
A quantidade mínima de horas trabalhadas semanais é 1 hora e a máxima 44,
conforme determinação do Ministério do Trabalho.

092 - Data de admissão em branco ou zerado.
Preenchimento obrigatório.
Informar a data de admissão do empregado informado.
(dia com dois dígitos, mês com dois dígitos e ano com quatro dígitos)

093 - Data de admissão informada com  máscara (/.\-,).
Informar a data de admissão sem barras, vírgulas, pontos ou hífens.
Ex: Para informar a admissão 13/05/96, informar: 13051996.

094 - Dia de admissão em branco ou zerado.
O dia da data de admissão não está preenchido.
Preencher o dia da admissão do empregado informado.

095 - Mês de admissão em branco ou zerado.
O mês da data de admissão não está preenchido.
Preencher com o mês da admissão do empregado informado.

096 - Mês e ano para admissão diferente da competência.
O mês e ano para Primeiro Emprego,
Reemprego e Transferência de Entrada tem que ser o mesmo da competência informada.
Para informar esses tipos de admissões referentes a meses anteriores,
fazer através do arquivo Acerto.

097 - Data de admissão não numérico.
Campo numérico, não informe letras, somente números.
Preencher com a data de admissão do empregado informado.
(dia com dois dígitos, mês com dois dígitos e ano com quatro dígitos)

098 - Dia de admissão menor que 1 ou maior que 31.
O valor  informado equivalente ao dia da data de admissão não é válido.
Informar o dia corretamente. Preencher neste campo somente valores entre 1 a 31.

099 - Mês de admissão menor que 1 ou maior que 12.
O valor informado equivalente ao mês da data de admissão não é válido.
Informar o mês corretamente. Preencher neste campo somente valores entre 1 a 12.

100 - Ano de Admissão em branco ou zerado.
Preenchimento obrigatório.
Informar o valor equivalente ao ano da data de admissão.
Preencher o ano com quatro dígitos.

101 - Data de Admissão maior que a data do sistema.
A data de admissão informada é superior a “Data de Hoje” do seu microcomputador
confirmada como data legal na abertura do Aplicativo.
Verificar qual a data que esta incorreta e proceder o acerto.

102 - Tipo de Movimento diferente 10, 20, 25, 31, 32, 35, 40, 43, 45, 50, 60, 70, 80.
O código do Tipo de Movimento informado não existe.
Verificar o código conforme tabela abaixo.
Códigos para Admissões:
10 - Primeiro Emprego  35 -  Reintegração
20 - Reemprego 70 -  Transferência de Entrada
25 - Contr. Prazo Determinado
Códigos para Desligamentos:
31 - Dispensa sem justa causa 50 -  Aposentado
32 - Dispensa por justa causa 60 -  Morte
40 - A pedido (espontâneo) 80 -  Transferência de Saída
43 - Term. Prazo Determinado
45 - Término de Contrato

103 - Tipo de Movimento em branco ou zerado.
Preenchimento obrigatório.
Informar o código do Tipo de Movimento conforme tabela abaixo.
Códigos para Admissões:
10 - Primeiro Emprego  35 -  Reintegração
20 -  Reemprego 70 -  Transferência de Entrada
25 -  Contr. Prazo Determinado
Códigos para Desligamentos:
31 -  Dispensa sem justa causa 50 -  Aposentado
32 -  Dispensa por justa causa 60 -  Morte
40 - A pedido (espontâneo) 80 -  Transferência de Saída
43 -  Term. Prazo Determinado
45 - Término de Contrato

104 - Tipo de Movimento não numérico.
Campo numérico, não informe letras, somente números.
Informar o código do tipo de movimento conforme tabela abaixo.
Códigos para Admissões:
10 - Primeiro Emprego  35 -  Reintegração
20 -  Reemprego 70 -  Transferência de Entrada
25 -  Contr. Prazo Determinado
Códigos para Desligamentos:
31 -  Dispensa sem justa causa 50 -  Aposentado
32 -  Dispensa por justa causa 60 -  Morte
40 - A pedido (espontâneo) 80 -  Transferência de Saída
43 -  Term. Prazo Determinado
45 - Término de Contrato

105 - Dia de Desligamento em branco ou zerado.
Preenchimento obrigatório para movimentação referente a desligamento.
Preencher o dia do desligamento do empregado informado.

106 - Dia de desligamento menor que 1 ou maior que 31.

Valor equivalente ao dia de desligamento não é válido.
Preencher neste campo somente valores entre 1 a 31.

107 - Nome do empregado em branco.
Preenchimento obrigatório. Informar o nome do empregado informado.

108 - Número da Carteira de Trabalho em branco.
Preenchimento obrigatório. Informar o número da Carteira de Trabalho neste campo.

109 - Série da Carteira de Trabalho em branco.
Preenchimento obrigatório. Informar o número da Série da Carteira de Trabalho neste campo.

110 –Atualização  diferente de 1, 2, e 3.
O valor informado não é válido. Observar os valores corretos, conforme tabela abaixo:
1 -  Exclusão de registro informado anteriormente.
2 -  Inclusão de registro corrente.
3 -  Alteração de registro informado anteriormente com os dados do registro corrente.

111 - Atualização em branco ou zerado.
Preenchimento obrigatório. Informar este código conforme tabela abaixo:
1 -  Exclusão de registro informado anteriormente.
2 -  Inclusão de registro corrente.
3 -  Alteração de registro informado anteriormente com os dados do registro corrente.

112 - Movimentação incompatível, último dia negativo.
Foi detectado um erro na informação do arquivo.
O total de empregados calculado no último dia é menor que zero.
Veja a equação: T_Ult = T_Prin + T_Adm - T_Desl.
O total de empregados no último dia (T_Ult) é igual ao total de empregados
no primeiro dia informado (T_Prin) mais todas as admissões (T_Adm) menos
todos os desligamentos ocorridos no mês (T_Desl). Este total não pode ser negativo.

113 - Dia de desligamento não numérico.
Informar somente número neste campo (dia com dois dígitos).

114 - Competência do Acerto diferente da admissão.
Sendo tipo de movimento de admissão, mês/ano de admissão tem que ser igual a da competência.

115 - Ano do nascimento não pode ser inferior a 1900.
O empregado com mais de 70 anos não precisa informar à Lei 4923/65.

116 - Competência para arquivo Acerto deixar em branco.
Não pode preencher o campo competência para arquivo acerto, deixar em branco.

117 - Total de Estabelecimento para arquivo Acerto deixar em branco.
Não pode preencher o campo total de Estabelecimento para arquivo acerto, deixar em branco.

118 - Competência maior que a data do Sistema.
Verificar a data de  competência, se estiver correta, acertar data do Sistema.

119 - Registro fora de ordem impossível continuar.
Os registros não estão na ordem correta: A,B,C e X.

120 - Tipo de movimento inválido para PIS/PASEP zerado.
Só é aceito PIS/PASEP zerado quando o tipo de movimento é 10 - Primeiro Emprego.

122 - CEP não pertence a UF informada.
O número do cep não pertence a Unidade da Federação - UF informada.
Verifique o CEP correto na tabela dos Correios
.
123. Endereço sem complemento
O endereço deve conter  número e complemento se não houver informe s/n.

125 – Registro ‘z’ não é o último registro do arquivo.
O último registro do arquivo tem que ser o ‘z.’

126 – Registro  diferente de ‘A’ e ‘X’ para arquivo Acerto
Registro acerto só pode ter registro tipo  ‘A’ e ‘X’

127 – Somente um registro no arquivo
Arquivo tem que conter no mínimo 02 registros.
(autorizado e o Estabelecimento que está sendo informando)

132 – Salário Mínimo em branco ou zerado.
Preenchimento obrigatório, preencher com o salário mínimo vigente na competência.

133 – Contato em Branco
Preencher com o nome da pessoa responsável junto ao MTE.

134 – Micro Empresa em branco ou zerado.
Preenchimento obrigatório, preencher com : 1 – Sim ou 2 – Não

135 – Micro Empresa diferente de 1 ou 2.
Preenchimento obrigatório, preencher com: 1 – Sim ou 2 - Não

137 –Raça / cor diferente de  0, 2, 4, 6, ou 8.
Preencher com: 2 – Branca
               4 – Preta
               6 – Amarela
               8 – Parda
               0 - Indígena

138 – Deficiente Físico em branco ou zerado
Preenchimento obrigatório, preencher com:   1 – Sim ou 2 – Não

139 – Deficiente Físico diferente de 1 ou 2.
Preenchimento diferente de 1 ou 2

140 – Data de admissão inexistente.
Data inválida .Ex. 30/02/1980

141 – Data de nascimento inexistente.
Data inválida .Ex. 30/02/1980

142 – Código do posto em branco ou zerado
 Preenchimento obrigatório, preencher com código do posto

143 – Código do posto não consta na tabela.
 O código do posto não faz parte da tabela do MTE.
 Consultar o Ministério do Trabalho e Emprego para conseguir o código correto.

144 – Uso indevido de identificador.
 Esse identificador não pertence ao Autorizado /  Estabelecimento informado.
 Informar o identificador correto.

145 – Dia de desligamento inválido para competência informada.
 Dia desligamento inexistente para competência informada.
 Ex. dia de desligamento 31 para competência 09/1980.

146 – Nome/razão social e CNAE-95 incompatíveis.
 Razão social é incompatível. com o tipo de atividade do código do CNAE informado.

147 – CNAE-95 incompatível com a identificação informada.
 O código do CNAE-95 é incompatível com a identificação informada.
 Verifique na tabela da CNAE-95 o código correto.

148 -  Ano de admissão inferior a 1900.
 Ano de admissão inválido.  Informe o ano de admissão correto

149 – Este numero não é PIS/PASEP.
 O número informado não é PIS/PASEP.
 Verifique com a CEF- Caixa Econômica federal,  o número correto para informar

150 – Apenas um registro no arquivo.
 Tem que ter pelo menos dois ( 2 ) registros no arquivo

151 – Competência do Acerto inválido para dia de desligamento.
 Competência do Acerto inválida para o dia desligamento informado.
 Ex. competência do Acerto: 09/1980 e dia de desligamento 31.

152 – Nome/razão social incompleto
 Informe o Nome/razão social completo

153 – Data de Admissão menor que a Data de Nascimento
 Data inválida, preencher com a data de admissão correta.

400 – Horas trabalhadas incompatível com a remuneração.
 A quantidade de horas trabalhadas não é compatível com a remuneração do empregado.
 A remuneração mínima para empregados com mais de 12 horas trabalhadas por semana é ½ salário mínimo vigente.
 Para empregados com menos de 12 horas por semana é aceito qualquer remuneração.

401 – Remuneração incompatível com as horas trabalhadas.
 A remuneração não é compatível com as horas trabalhadas do empregado.
 A remuneração mínima para empregados com mais de 12 horas trabalhadas por semana é ½ salário mínimo vigente.
 Para empregados com menos de 12 horas por semana é aceito qualquer remuneração

402 – Remuneração maior que 150 salários mínimos.
 Mensagem de alerta.

403 – Raça / cor em branco.
 Preencher com:
 2 – Branca
 4 – Preta
 6 – Amarela
 8 – Parda
 0 – Indígena

404 – Grau de instrução incompatível com o CBO informado.
 Grau de instrução informado é incompatível com o CBO informado.
 Verifique o grau de instrução na tabela abaixo, se correto  verifique o código do CBO informado na tabela de CBO.

1 - analfabeto, inclusive os que embora tenham recebido instrução, não se alfabetizaram ou tenham esquecido.
2 - até 4a série incompleta do 1o grau (primário incompleto) ou que se tenha alfabetizado sem ter freqüentado escola regular.
3 - 4a série do1o grau (primário) completo.
4 - da 5a a 8a série incompleta do 1o grau (ginasial incompleto).
5 - 1o grau (ginasial) completo.
6 - 2o grau (colegial) incompleto.
7 - 2o grau (colegial) completo.
8 - Superior incompleto.
9 - Superior completo.

405 – Confirma PIS /PASEP zerados informados.
 Mensagem de alerta

406 – Confirma remuneração menor que ½ salário mínimo.
 Mensagem de alerta - A remuneração mínima para empregados com
 mais de 12 horas trabalhadas por semana é ½ salário mínimo vigente.
 Para empregados com menos de 12 horas por semana é aceito qualquer remuneração

407 – CNAE-95 incompatível com nome / razão social informado.
 O código do CNAE-95 é incompatível com o tipo de atividade da
 razão social informada. Verifique na tabela da CNAE-95 o código correto.

408 – CBO desativado.
 Verifique na tabela de CBO o código correto para a ocupação do empregado.

*)


(* =============================================================
Considerações gerais
================================================================

O Ministério do Trabalho e Emprego emitirá, para cada estabelecimento
informado e processado, o Extrato da Movimentação Processada,
contendo os dados cadastrais do estabelecimento e o
resumo da movimentação processada.
Este recibo é comprovante legal junto à Fiscalização do Trabalho.

Os extratos dos Estabelecimentos serão encaminhados ao Estabelecimento
responsável pela declaração do CAGED perante o MTE
(será encaminhada ao endereço constante no registro tipo A ).

Os estabelecimentos ficam obrigados a emitir/apresentar,
quando solicitado pela Fiscalização,
a Relação de Movimentação Mensal do Cadastro Geral de
Empregados e Desempregados  contendo o resumo da movimentação e a relação
de empregados movimentados. O ACI permite a emissão deste relatório
a partir da leitura do Arquivo CAGED.

É facultativa a informação aos estabelecimentos que não tiverem movimentação.
Não háobrigatoriedade de informar ao CAGED todos os meses, salvo se ocorrer movimentação.

Qualquer estabelecimento poderá utilizar os meios magnéticos para informar ao
CAGED - Lei No 4923/65, desde que atenda à essas exigências

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
