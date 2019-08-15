Unit SEFIP;

interface

uses
  SysUtils, Classes, Math;

procedure GeraArquivoSEFIP( Reg00, Reg10, Reg12, Reg13, Reg14,
                           Reg20, Reg21, Reg30, Reg32, Reg40,
                           Reg50, Reg51: TStringList );

// entrada de dados para o registro tipo '00' - Header do arquivo
function SetResponsavel( Tipo, Inscricao, Responsavel, Contato,
  Endereco, Bairro, CEP, Cidade, UF, Telefone, Internet: String):Boolean;
procedure SetCompetencia( Ano, Mes: Smallint);
procedure SetRecolhimento( CR,
  Indicador_FGTS, Modalidade_FGTS,
  Indicador_PS, Indice_PS: Smallint;
  Data_FGTS, Data_PS: TDateTime);
procedure SetFornecedor( Tipo, Inscricao: String);

// entrada de dados para o registro tipo '10' - Header da empresa
function SetEmpresa_SEFIP( Tipo, Inscricao, Empresa, Endereco,
  Bairro, CEP, Cidade, UF, Telefone, Alterar: String):Boolean;
procedure Set10Codigo( CNAE, CNAE_Alteracao, Centralizacao,
  SIMPLES, FPAS, Terceiros, Pagamento_GPS: String);
procedure Set10Valor( AliquotaSAT, Filantropia, SalarioFamilia,
  SalarioMaternidade, ContEmpregado, Previdencia: Currency);

// entrada de dados para o registro tipo '12' -
// informacoes adcionais do recolhimento da empresa
procedure Set12Valor( n11: Integer; v05, v06, v08, v09, v15, v18, v19,
  v20, v21, v22, v23, v24, v25, v26: Currency );
procedure Set12Texto( t07, t10, t12, t13, t14, t16, t17:String);

// ----------------------------------------------------------------
function SetTomador( Tipo, Inscricao, Nome,
  Endereco, Bairro, CEP, Cidade, UF: String):Boolean;

procedure SetFuncionario( PIS: String; Admissao, Opcao, Nascimento: TDateTime;
  Categoria: Integer; Nome, Matricula, CTPS, Serie, CBO: String);
procedure SetFuncionarioEndereco( Data: TDatetime; Endereco, Bairro, CEP, Cidade, UF: String);
// -----------------------------------------------------------------

// Entrada de dados para o registro tipo '13' - Alteracao Cadastral Trabalhador
procedure Set13Codigo( n12, n13, n14: Integer; t15:String);
procedure Set20Valor( t13:String; v14, v15, v17, v18, v19: Currency);
procedure Set21Valor( v07, v10, v11, v12, v13, v14: Currency; d08, d09: String);

// entrada de dados para o registro tipo '30' - registro do trabalhador
procedure Set30Valor( Sem13, Sobre13, Retido, Base, Base13, Rem13: Currency;
  Classe, Ocorrencia: String );

procedure Set32Valor( t10, d11, t12: String);

// ========================================================================

// geracao dos registros do arquivo
function Header_Arquivo: String;
function Header_Empresa: String;
function Registro12:String;
function Registro13:String;
function Registro14:String;
function Registro20:String;
function Registro21:String;
function Registro30:String;
function Registro32:String;
function Trailler_arquivo:String;

implementation

uses ftext;

const
  FIM_LINHA = '*';
  FORMATO_DATA = 'DDMMYYYY';

var
  // Variaveis HEADER DO ARQUIVO
  HA_TIPO_RESPONSAVEL, HA_INSCRICAO_RESPONSAVEL: String;
  HA_NOME_RESPONSAVEL, HA_CONTATO: String;
  HA_ENDERECO, HA_BAIRRO, HA_CEP, HA_CIDADE, HA_UF: String;
  HA_TELEFONE, HA_INTERNET: String;
  HA_COMPETENCIA_ANO, HA_COMPETENCIA_MES: Smallint;
  HA_CODIGO_RECOLHIMENTO: Smallint;
  HA_INDICADOR_RECOLHIMENTO_FGTS: String;
  HA_MODALIDADE_PARCELAMENTO_FGTS: String;
  HA_DATA_RECOLHIMENTO_FGTS: TDateTime;
  HA_INDICADOR_RECOLHIMENTO_PS: SmallInt;
  HA_DATA_RECOLHIMENTO_PS: TDateTime;
  HA_INDICE_RECOLHIMENTO_PS: SmallInt;
  HA_TIPO_INSCRICAO_FORNECEDOR, HA_INSCRICAO_FORNECEDOR: String;

  // Variaveis HEADER DA EMPRESA
  HE_TIPO_INSCRICAO, HE_INSCRICAO, HE_EMPRESA: String;
  HE_ENDERECO, HE_BAIRRO, HE_CEP, HE_CIDADE, HE_UF: String;
  HE_TELEFONE, HE_ENDERECO_ALTERACAO: String;
  HE_CNAE_FISCAL, HE_CNAE_FISCAL_ALTERACAO: String;
  HE_CODIGO_CENTRALIZACAO, HE_SIMPLES: String;
  HE_FPAS, HE_CODIGO_TERCEIROS: String;
  HE_CODIGO_PAGAMENTO_GPS: String;
  HE_SAT, HE_FILATROPIA, HE_SALARIO_FAMILIA: Currency;
  HE_SALARIO_MATERNIDADE, HE_CONT_DESC_EMPREGADO, HE_PREVIDENCIA: Currency;

  H_TOMADOR_TIPO, H_TOMADOR_INSCRICAO, H_TOMADOR_NOME: String;
  H_TOMADOR_ENDERECO, H_TOMADOR_BAIRRO, H_TOMADOR_CEP: String;
  H_TOMADOR_CIDADE, H_TOMADOR_UF: String;

// entrada de dados para o registro tipo '12' -
// informacoes adcionais do recolhimento da empresa
  H12_v05, H12_v06, H12_v08, H12_v09, H12_v15: Currency;
  H12_v18, H12_v19, H12_v20, H12_v21, H12_v22: Currency;
  H12_v23, H12_v24, H12_v25, H12_v26: Currency;
  H12_t07, H12_t10, H12_t12, H12_t13, H12_t14, H12_t16, H12_t17:String;
  H12_n11: Integer;

  // Variaveis para o REGISTRO 13 - ALTERACAO CADASTRAL DO TRABALHADOR
  H13_n12, H13_n13, H13_n14: Integer;
  H13_t15: String;

  // Variaveis para o REGISTRO 14 - INCLUSAO/ALTERACAO ENDERECO DO TRABALHADOR
  H14_ENDERECO_ALT: TDateTime;
  H14_ENDERECO, H14_BAIRRO, H14_CEP, H14_CIDADE, H14_UF: String;

  // Variaveis para o REGISTRO 20
  H20_t13: String;
  H20_v14, H20_v15, H20_v17, H20_v18, H20_v19: Currency;

  H21_v07, H21_v10, H21_v11, H21_v12, H21_v13, H21_v14: Currency;
  H21_d08, H21_d09: String;

  // Variaveis para o REGISTRO TIPO 30 - REGISTRO DO TRABALHADOR
  HT_NOME, HT_MATRICULA, HT_CTPS, HT_SERIE, HT_CBO: String;
  HT_PIS, HT_CLASSE, HT_OCORRENCIA: String;
  HT_ADMISSAO, HT_OPCAO, HT_NASCIMENTO: TDateTime;
  HT_CATEGORIA: Integer;
  HT_SEM13, HT_SOBRE13: Currency;
  HT_RETIDO, HT_BASE, HT_BASE13, HT_REM13: Currency;

  H32_t10, H32_d11, H32_t12: String;

(* ================================================================ *)

function CriticaEndereco( var Endereco:String):Boolean;
var
  i: Integer;
begin

  Result := False;

  // A primeira posicao nao pode ser branco
  Endereco := UpperCase(Trim(Endereco));

  // Campo obrigatorio
  if Length(Endereco) = 0 then
    Exit;

  // Nao pode conter mais de um espaco entre nomes
  if Pos( #32#32, Endereco) > 0 then
    Exit;

  // O nome nao pode conter numero, caracter especial, acento,
  // mais de duas letras igual consecutivas
  for i := 1 to Length(Endereco) do
    if ( not (Endereco[i] in ['A'..'Z',#32,'0'..'9']) ) or
       ( Pos( StringOfChar( Endereco[i], 3), Endereco) > 0) then
      Exit;

  Result := True;

end;

function CriticaNome( var Nome:String):Boolean;
var
  i: Integer;
begin

  Result := False;

  Nome := UpperCase(Trim(Nome));

  // Campo obrigatorio
  if Length( Trim(Nome)) = 0 then
    Exit;

  // Nao pode conter mais de um espaco entre nomes
  if Pos( #32#32, Nome) > 0 then
    Exit;

  // O nome nao pode conter numero, caracter especial, acento,
  // mais de duas letras igual consecutivas
  for i := 1 to Length(Nome) do
    if ( not (Nome[i] in ['A'..'Z',#32]) ) or
       ( Pos( StringOfChar( Nome[i], 3), Nome) > 0) then
      Exit;

  Result := True;

end;

function MsgCriticaNome( var Nome:String; Campo: String):Boolean;
begin

  Result := CriticaNome( Nome);

  if not Result then
    kErro(
        'O campo ('+Campo+') é obrigatorio e '+#13+
        'não pode conter número, caracter especial, acênto,'+#13+
        'mais de um espaço entre os nomes, mais de duas letras iguais'+#13+
        'consecutivas e a primeira posição não pode ser branco.'+#13+
        'Pode conter apenas caracteres de A a Z.');

end;

function MsgCriticaEndereco( var Endereco:String; Campo: String):Boolean;
begin

  Result := CriticaEndereco( Endereco);

  if not Result then
    kErro(
        'O campo ('+Campo+') é obrigatorio e '+#13+
        'não pode conter caracter especial, acênto,'+#13+
        'mais de um espaço entre os nomes, mais de duas letras iguais'+#13+
        'consecutivas e a primeira posição não pode ser branco.'+#13+
        'Pode conter apenas caracteres de A a Z e números de 0 a 9.');

end;

(* ==  ENTRADA DE DADOS PARA O REGISTRO 00 - HEADER DO ARQUIVO ===== *)

function SetResponsavel( Tipo, Inscricao, Responsavel, Contato, Endereco,
  Bairro, CEP, Cidade, UF, Telefone, Internet:String):Boolean;
begin

  Result := False;

  if not MsgCriticaEndereco( Responsavel, 'NOME RESPONSAVEL/RAZAO SOCIAL') then
    Exit;

  if not MsgCriticaNome( Contato, 'NOME PESSOA CONTATO') then
    Exit;

  if not MsgCriticaEndereco( Endereco, 'LOGRADOURO, RUA, No., ANDAR, APARTAMENTO') then
    Exit;

  if not MsgCriticaEndereco( Bairro, 'BAIRRO') then
    Exit;

  if not MsgCriticaEndereco( Cidade, 'CIDADE') then
    Exit;

  if ( Length(Tipo) <> 1) or not ( Tipo[1] in ['1','2','3'] ) then begin
    kErro('O Tipo de Inscricao do Responsavel e obrigatorio e so'+#13+
            'podera ser 1 (CNPJ), 2 (CEI) ou  3 (CPF).');
    Exit;
  end;

  Inscricao := Trim(Inscricao);

  if (Tipo = '1') and not kChecaCGC(Inscricao) then begin
    kErro('O CNPJ do Responsavel nao e valido.');
    Exit;
  end else if (Tipo = '3') and not kChecaCPF(Inscricao) then begin
    kErro('O CPF do Responsavel nao e valido.');
    Exit;
  end;

  HA_TIPO_RESPONSAVEL      := Tipo;
  HA_INSCRICAO_RESPONSAVEL := Inscricao;
  HA_NOME_RESPONSAVEL      := PadRightChar( Responsavel, 30, #32) ;
  HA_CONTATO               := PadRightChar( Contato, 20, #32) ;
  HA_ENDERECO              := PadRightChar( Endereco, 50, #32);
  HA_BAIRRO                := PadRightChar( Bairro, 20, #32);
  HA_CEP                   := CEP;
  HA_CIDADE                := PadRightChar( Cidade, 20, #32);
  HA_UF                    := UF;
  HA_TELEFONE              := Telefone;
  HA_INTERNET              := Internet;

  Result := True;

end;

procedure SetCompetencia( Ano, Mes: Smallint);
begin
  HA_COMPETENCIA_ANO := Ano;
  HA_COMPETENCIA_MES := Mes;
end;

procedure SetRecolhimento( CR,
  Indicador_FGTS, Modalidade_FGTS,
  Indicador_PS, Indice_PS: Smallint;
  Data_FGTS, Data_PS: TDateTime);
begin

  HA_CODIGO_RECOLHIMENTO := CR;

  if Indicador_FGTS in [1,2] then
    HA_INDICADOR_RECOLHIMENTO_FGTS := IntToStr(Indicador_FGTS)
  else
    HA_INDICADOR_RECOLHIMENTO_FGTS := '';

  if Modalidade_FGTS in [1,2,3] then
    HA_MODALIDADE_PARCELAMENTO_FGTS  := IntToStr(Modalidade_FGTS)
  else
    HA_MODALIDADE_PARCELAMENTO_FGTS  := '';

  HA_DATA_RECOLHIMENTO_FGTS := Data_FGTS;

  if not Indicador_PS in [1,2,3] then begin
    kErro( 'O INDICADOR DE RECOLHIMENTO DA PREVIDENCIA SOCIAL'#13+
             'deve ser "1", "2" ou "3"');
    Exit;
  end;

  HA_INDICADOR_RECOLHIMENTO_PS := Indicador_PS;

  HA_INDICE_RECOLHIMENTO_PS := Indice_PS;
  HA_DATA_RECOLHIMENTO_PS   := Data_PS;

end;

procedure SetFornecedor( Tipo, Inscricao: String);
begin

  if Tipo = '1' then begin
    if not kChecaCGC(Inscricao) then
      kErro( 'CNPJ: '+Inscricao+#13+
               'O CNPJ do Fornecedor da folha não é valido');
  end else if Tipo = '3' then begin
    if not kChecaCPF(Inscricao) then
      kErro( 'CPF: '+Inscricao+#13+
               'O CPF do Fornecedor da folha não é valido');
  end;

  HA_TIPO_INSCRICAO_FORNECEDOR := Tipo;
  HA_INSCRICAO_FORNECEDOR      := Inscricao;

end;

(* ==  ENTRADA DE DADOS PARA O REGISTRO 10 - HEADER DA EMPRESA ===== *)

function SetEmpresa_SEFIP( Tipo, Inscricao, Empresa, Endereco,
  Bairro, CEP, Cidade, UF, Telefone, Alterar: String):Boolean;
begin

  Result := True;

  if not (Tipo[1] in ['1','2']) then begin
    kErro( 'Tipo Informado: '+QuotedStr(Tipo)+#13+
             'O TIPO DE INSCRIÇÃO DA EMPRESA só poderá'#13+
             'ser 1 (CNPJ) ou 2 (CEI)');
    Result := False;
  end;

   Inscricao := Trim(Inscricao);

  if (Tipo = '1') and not kChecaCGC(Inscricao) then begin
    kErro( 'CNPJ informado: '+QuotedStr(Inscricao)+#13+
             'O CNPJ da empresa não é valido');
    Result := False;
  end;

  if not MsgCriticaEndereco( Empresa, 'NOME EMPRESA/RAZAO SOCIAL') then
    Result := False;

  if not MsgCriticaEndereco( Endereco, 'ENDERECO DA EMPRESA') then
    Result := False;

  if not MsgCriticaEndereco( Cidade, 'CIDADE DA EMPRESA') then
    Result := False;

  if not MsgCriticaEndereco( Bairro, 'BAIRRO DA EMPRESA') then
    Result := False;

  // %% Falta validar a inscricao da empresa
  HE_TIPO_INSCRICAO     := Tipo;
  HE_INSCRICAO          := Inscricao;
  HE_EMPRESA            := Empresa;

  HE_ENDERECO           := Endereco;
  HE_BAIRRO             := Bairro;
  HE_CEP                := CEP;
  HE_CIDADE             := Cidade;
  HE_UF                 := UF;
  HE_TELEFONE           := Telefone;
  HE_ENDERECO_ALTERACAO := Alterar;

end;

procedure Set10Codigo( CNAE, CNAE_Alteracao, Centralizacao,
  SIMPLES, FPAS, Terceiros, Pagamento_GPS: String);
begin
  HE_CNAE_FISCAL           := CNAE;
  HE_CNAE_FISCAL_ALTERACAO := CNAE_Alteracao;
  HE_CODIGO_CENTRALIZACAO  := Centralizacao;
  HE_SIMPLES               := SIMPLES[1];
  HE_FPAS                  := FPAS;
  HE_CODIGO_TERCEIROS      := Terceiros;
  HE_CODIGO_PAGAMENTO_GPS  := Pagamento_GPS;
end;

procedure Set10Valor( AliquotaSAT, Filantropia, SalarioFamilia,
  SalarioMaternidade, ContEmpregado, Previdencia: Currency);
begin
  HE_SAT                 := AliquotaSAT;
  HE_FILATROPIA          := Filantropia;
  HE_SALARIO_FAMILIA     := SalarioFamilia;
  HE_SALARIO_MATERNIDADE := SalarioMaternidade;
  HE_CONT_DESC_EMPREGADO := ContEmpregado;
  HE_PREVIDENCIA         := Previdencia;
end;

// entrada de dados para o registro tipo '12' -
// informacoes adcionais do recolhimento da empresa
procedure Set12Valor( n11: Integer; v05, v06, v08, v09, v15, v18, v19, v20,
  v21, v22, v23, v24, v25, v26: Currency );
begin
   H12_n11 := n11;
   H12_v05 := v05;
   H12_v06 := v06;
   H12_v08 := v08;
   H12_v09 := v09;
   H12_v15 := v15;
   H12_v18 := v18;
   H12_v19 := v19;
   H12_v20 := v20;
   H12_v21 := v21;
   H12_v22 := v22;
   H12_v23 := v23;
   H12_v24 := v24;
   H12_v25 := v25;
   H12_v26 := v26;
end;

procedure Set12Texto( t07, t10, t12, t13, t14, t16, t17:String);
begin
  H12_t07 := t07 ;
  H12_t10 := t10 ;
  H12_t12 := t12 ;
  H12_t13 := t13 ;
  H12_t14 := t14 ;
  H12_t16 := t16 ;
  H12_t17 := t17 ;
end;

(* ==  ENTRADA DE DADOS PARA O REGISTRO 30 - TRABALHADOR ===== *)
function SetTomador( Tipo, Inscricao, Nome,
  Endereco, Bairro, CEP, Cidade, UF: String):Boolean;
begin

  Result := True;

  if MsgCriticaEndereco( Nome, ' NOME DO TOMADOR/OBRA DE CONST. CIVIL') then
    Result := False;

  if not MsgCriticaEndereco( Endereco, 'ENDEREO DO TOMADOR') then
    Result := False;

  if not MsgCriticaEndereco( Cidade, 'CIDADE DO TOMADOR') then
    Result := False;

  if not MsgCriticaEndereco( Bairro, 'BAIRRO DO TOMADOR') then
    Result := False;

  if (Tipo = '1') and (not kChecaCGC(Inscricao)) then begin
    kErro( 'CNPJ informado: '+Inscricao+#13+
             'O CNPJ do Tomador não é valido');
    Result := False;
  end else if (Tipo = '3') and (not kChecaCPF(Inscricao)) then begin
    kErro( 'CPF informado: '+Inscricao+#13+
             'O CPF do Tomador não é valido');
    Result := False;
  end;

  H_TOMADOR_TIPO      := Tipo;
  H_TOMADOR_INSCRICAO := Inscricao;
  H_TOMADOR_NOME      := PadRightChar( Nome, 40, #32);

  H_TOMADOR_ENDERECO := PadRightChar( Endereco, 50, #32);
  H_TOMADOR_BAIRRO   := PadRightChar( Bairro, 20, #32);
  H_TOMADOR_CEP      := CEP;
  H_TOMADOR_CIDADE   := PadRightChar( Cidade, 20, #32);
  H_TOMADOR_UF       := UF;

end;  // function SetTomador

procedure SetFuncionario( PIS: String; Admissao, Opcao, Nascimento: TDateTime;
  Categoria: Integer; Nome, Matricula, CTPS, Serie, CBO: String);
begin
  HT_NOME       := PadRightChar( Nome, 70, #32);
  HT_MATRICULA  := Matricula;
  HT_CTPS       := CTPS;
  HT_SERIE      := Serie;
  HT_CBO        := CBO;
  HT_PIS        := PadLeftChar( PIS, 11, #32);

  if Admissao > EncodeDate( HA_COMPETENCIA_ANO,
                            Min( 12, HA_COMPETENCIA_MES), 28) then
  begin
    kErro( 'Funcionário: '+Matricula+' - '+Nome+#13+
           'Admissão: '+ DateToStr(Admissao)+#13#13+
           'A ADMISSAO deve ser menor ou igual a competencia informada.');
    HT_ADMISSAO := 0;
  end else
    HT_ADMISSAO := Admissao;

  HT_OPCAO      := Opcao;
  HT_NASCIMENTO := Nascimento;
  HT_CATEGORIA  := Categoria;
end;  // procedure SetFuncionario

procedure SetFuncionarioEndereco( Data: TDateTime; Endereco, Bairro, CEP, Cidade, UF: String);
begin
  H14_ENDERECO_ALT := Data;
  H14_ENDERECO     := Endereco;
  H14_BAIRRO       := Bairro;
  H14_CEP          := CEP;
  H14_CIDADE       := Cidade;
  H14_UF           := UF;
end;

procedure Set30Valor( Sem13, Sobre13, Retido, Base, Base13, Rem13: Currency;
  Classe, Ocorrencia: String );
begin
  HT_CLASSE     := Classe;
  HT_OCORRENCIA := Ocorrencia;
  HT_SEM13      := Sem13;
  HT_SOBRE13    := Sobre13;
  HT_RETIDO     := Retido;
  HT_BASE       := Base;
  HT_BASE13     := Base13;
  HT_REM13      := Rem13;
end;

procedure Set32Valor( t10, d11, t12: String);
begin
  H32_t10 := PadLeftChar( t10, 2, #32);
  H32_d11 := d11;
  H32_t12 := t12;
end;

(* ================================================================= *)
procedure Set13Codigo( n12, n13, n14: Integer; t15:String);
begin
  H13_n12 := n12;
  H13_n13 := n13;
  H13_n14 := n14;
  H13_t15 := t15;
end;

procedure Set20Valor( t13:String; v14, v15, v17, v18, v19: Currency);
begin
  H20_t13 := t13;
  H20_v14 := v14;
  H20_v15 := v15;
  H20_v17 := v17;
  H20_v18 := v18;
  H20_v19 := v19;
end;

procedure Set21Valor( v07, v10, v11, v12, v13, v14: Currency; d08, d09: String);
begin
  H21_v07 := v07;
  H21_v10 := v10;
  H21_v11 := v11;
  H21_v12 := v12;
  H21_v13 := v13;
  H21_v14 := v14;
  H21_d08 := d08;
  H21_d09 := d09;
end;

(* ================================================================= *)

function Header_Arquivo: String;
const
  CABECALHO = 'Erro no registro Tipo "00" - Header do arquivo';
var
  sLinha: String;
  wAno, wMes, wDia: Word;
begin

  // 1+. Tipo do Registro Header - sempre '00'
  sLinha := '00';  // Chave

  // 2+. Preencher com brancos
  sLinha := sLinha + Espaco(51);  // Chave

  // 3+. Tipo de Remessa - 1 (GFIP), 2 (GRFP) ou 3 (DERF)
  //                 - as opcoes 2 e 3 serao implementadas futuramente
  sLinha := sLinha + '1';  // GFIP

  // 4+. Tipo de Inscricao do Responsavel - 1 (CNPJ), 2 (CEI) ou 3 (CPF)
  sLinha := sLinha + HA_TIPO_RESPONSAVEL;

  // 5+. Inscricao do Responsavel - CNPJ ou CEI ou CPF - Tam 14 Numerico
  sLinha := sLinha + PadLeftChar( HA_INSCRICAO_RESPONSAVEL, 14, #32);

  // 6+. Nome do Responsavel - Tam 30 - Campo obrigatorio
  sLinha := sLinha + HA_NOME_RESPONSAVEL;

  // 7+. Nome Pessoa Contato - Tam 20 - Alfabetica
  sLinha := sLinha + HA_CONTATO;

  // 8+. Logradouro, rua, no., andar, apartamento - Tam 50
  sLinha := sLinha + HA_ENDERECO;

  // 9+. Bairro - Tam 20 AN -
  sLinha := sLinha + HA_BAIRRO;

  // 10+. CEP - Tam 8 N
  sLinha := sLinha + HA_CEP;

  // 11+. Cidade - Tam 20 AN
  sLinha := sLinha + HA_CIDADE;

  // 12+. Unidade da Federacao
  sLinha := sLinha + HA_UF;

  (* 13+. Telefone Contato - Tam 12 N
     Deve conter no minimo 02 digito do DDD e 06 digitos no telefone  *)
  sLinha := sLinha + PadRightChar( HA_TELEFONE, 12, #32);

  // 14. Endereco INTERNET contato - Tam 60 AN
  sLinha := sLinha + PadRightChar( HA_INTERNET, 60, #32);

  (* 15+. Competencia - Tam 6 D
     # Formato AAAAMM, onde AAAA indica o ano e MM o mes da competencia
     # O mes informado de ser de 1 a 13 e o ano maior ou igual a 1967.
     # So acatar o mes de competencia 13 para ano maior ou igual a 1998
     # Nao acatar mes de competencia 13 para os CR 130, 145, 307, 317, 327,
       337, 345, 640, 650, 660, 904, 909, 911
     # Acatar apenas competencia maior ou igual a OUT/1998 para os CR 903, 904,
       905, 907, 908, 909 e 910.
     # Acatar apenas competencia maior ou igual a MAR/2000 para CR 911.
     # Acatar apenas competencia menor que OUT/1998 para o CR 640. *)

  if not ( (HA_COMPETENCIA_MES in [1..13]) and
           (HA_COMPETENCIA_ANO > 1967) ) then begin
    kErro( CABECALHO + #13#13+
            'A mês da competência deve ser de 1 a 13 e ano maior que 1967');
    Exit;
  end;

  if (HA_COMPETENCIA_MES = 13) and (HA_COMPETENCIA_ANO < 1998) then begin
    kErro( CABECALHO + #13#13+
            'Para competência 13 o ano deve ser maior ou igual a 1998');
    Exit;
  end;

  if (HA_COMPETENCIA_MES = 13) then
    case HA_CODIGO_RECOLHIMENTO of
      130, 145, 307, 317, 327, 337, 345, 640, 650, 660, 904, 909, 911: begin
        kErro( CABECALHO + #13#13+
                'Não é aceito competência 13 para os seguintes códigos de recolhimento:'#13+
                '130, 145, 307, 317, 327, 337, 345, 640, 650, 660, 904, 909, 911');
        Exit;
      end;
    end; // case

  case HA_CODIGO_RECOLHIMENTO of
    903..905, 907..910:
      if (HA_COMPETENCIA_ANO < 1998) or ( (HA_COMPETENCIA_ANO = 1998) and
         (HA_COMPETENCIA_MES < 10) ) then begin
        kErro( CABECALHO + #13#13+
                'É aceito apenas competência maior ou igual a OUT/1998'+#13+
                'para os seguintes códigos de recolhimento:'#13+
                '903, 904, 905, 907, 908, 909, 910');
        Exit;
      end;
    911:
      if (  HA_COMPETENCIA_ANO < 2000 ) or
         ( (HA_COMPETENCIA_ANO = 2000) and (HA_COMPETENCIA_MES < 3) ) then begin
        kErro( CABECALHO + #13#13+
                'É aceito apenas competência maior ou igual a MAR/2000'+#13+
                'para o código de recolhimento 911');
        Exit;
      end;
    640:
      if (HA_COMPETENCIA_ANO > 1988) or
         ( (HA_COMPETENCIA_ANO = 1988) and (HA_COMPETENCIA_MES >= 10) ) then begin
        kErro( CABECALHO + #13#13+
                'É aceito apenas competência menor OUT/1988'+#13+
                'para o código de recolhimento 640');
        Exit;
      end;
  end;  // case

  sLinha := sLinha + kStrZero( HA_COMPETENCIA_ANO, 4)+kStrZero( HA_COMPETENCIA_MES, 2);

  (* 16+. Codigo de recolhimento - Tam 3 Numerico
     Informacao deve estar contida na tabela de Codigo de Recolhimento *)
  sLinha := sLinha + kStrZero( HA_CODIGO_RECOLHIMENTO, 3);

  (* 17. Indicador de Recolhimento FGTS - Tam 1 - Numerico
     # So podera ser 1 (GFIP no prazo), 2 (GFIP em atraso) ou branco
     # CR 145, 345, 640 so aceita indicador igual a 2 (GFIP em atraso)
     # Campo obrigatorio para os CR 115, 130, 150, 155, 307, 317,
       327, 337, 608, 640, 650 e 660.
     # Nao pode ser informado, para os CRs 903, 904, 905, 907, 908, 909, 910 e 911.
     # Nao podera ser informado na competencia 13.
     # Sempre que nao informado, campo deve ficar em branco.*)
  case HA_CODIGO_RECOLHIMENTO of
    115, 130, 150, 155, 307, 317, 327, 337, 608, 650, 660:
      if not (HA_INDICADOR_RECOLHIMENTO_FGTS[1] in ['1','2']) then begin
        kErro( CABECALHO + #13#13+
                'INDICADOR DE RECOLHIMENTO FGTS obrigatório para'+#13+
                'os códigos de recolhimento iguais a'+#13+
                '115, 130, 150, 155, 307, 317, 327, 337, 608, 650 e 660');
        Exit;
      end;
    145, 345, 640:
      HA_INDICADOR_RECOLHIMENTO_FGTS := '2';
    903, 904, 905, 907, 908, 909, 910, 911:
      HA_INDICADOR_RECOLHIMENTO_FGTS := #32;
  end;

  if HA_COMPETENCIA_MES = 13 then
    HA_INDICADOR_RECOLHIMENTO_FGTS := #32;

  sLinha := sLinha + HA_INDICADOR_RECOLHIMENTO_FGTS;

  (* 18. Modalidade do Parcelamento do FGTS - Tam 1 - Numerico
     So podera ser: 1 - Recolhimento do FGTS com individualizacao dos valores
                    2 - Apenas recolhimento do FGTS
                    3 - Apenas individualizacao dos valores para os trabalhadores
     Campo obrigatorio para CRs 307, 317, 327 e 337 (O SEFIP 4.0 so admite a modalidade 1).
     Sempre que nao informado, campo deve ficar em branco. *)
  case HA_CODIGO_RECOLHIMENTO of
    307, 317, 327, 337: HA_MODALIDADE_PARCELAMENTO_FGTS := '1';
  end;

  sLinha := sLinha + HA_MODALIDADE_PARCELAMENTO_FGTS;

  (* 19. DATA DE RECOLHIMENTO DO FGTS - Tam 8 - Data
     * Formato DDMMAAAA.
     * So podera ser informado se o Indicador de Recolhimento FGTS for igual a 2
       e a data informada devera ser posterior ao dia 07 do mes seguinte ao da competencia.
     * Nao podera ser informado quando o indicador de recolhimento do FGTS for
       diferente de 2 (GFIP em atraso).
     * Sempre que nao informado, campo deve ficar em branco. *)
  if (HA_INDICADOR_RECOLHIMENTO_FGTS = '2') then begin

    wAno := HA_COMPETENCIA_ANO;
    wMes := HA_COMPETENCIA_MES;

    if (wMes <= 12) then begin
      wMes := 1;
      wAno := wAno + 1;
    end else
      wMes := wMes + 1;

    if HA_DATA_RECOLHIMENTO_FGTS <= EncodeDate( wAno, wMes, 07) then begin
      kErro( CABECALHO + #13#13+
              'A DATA DE RECOLHIMENTO DO FGTS para o INDICADOR igual a 2'#13+
              'deve ser posterior ao dia 07 do mês seguinte ao da competência');
      Exit;
    end;

    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HA_DATA_RECOLHIMENTO_FGTS);

  end else
    sLinha := sLinha + Espaco(8);

  (* 20+. Indicador de Recolhimento da Previdencia Social
     * Campo obrigatorio.
     * So podera ser 1 (no prazo), 2 (em atraso) ou 3 (nao gera GPS).
     * Deve ser sempre igual a 3, para competencia anterior a OUT/1998.
     * Deve ser sempre igual a 3, para os CRs 145, 317, 337, 345, 640, 660 e 911.
     * Deve ser 1 ou 2, para competencia 13. *)
  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 10) ) then
    HA_INDICADOR_RECOLHIMENTO_PS := 3;

  case HA_CODIGO_RECOLHIMENTO of
    145, 317, 337, 345, 640, 660, 911: HA_INDICADOR_RECOLHIMENTO_PS := 3;
  end;

  if (HA_COMPETENCIA_MES = 13) and (HA_INDICADOR_RECOLHIMENTO_PS <> 1) and
                                  (HA_INDICADOR_RECOLHIMENTO_PS <> 2) then begin
    kErro( CABECALHO + #13#13+
            'O INDICADOR DE RECOLHIMENTO DA PREVIDENCIA SOCIAL'#13+
            'deve ser "1" ou "2", para competência 13');
    Exit;
  end;

  sLinha := sLinha + IntToStr(HA_INDICADOR_RECOLHIMENTO_PS);

  (* 21. Data de Recolhimento da Previdencia Social - Tam 8 Data
     # Formato DDMMAAAA.
     # So pode ser informado se Indicador de Recolhimento Previdencia Social
       for igual a 2 e a data informada for posterior ao dia 02 do mes
       seguinte ao da competencia.
     # Deve ser posterior a 2012AAAA para competencia 13.
     # Nao deve ser informada, se Indicador de Recolhimento da Previdencia
       Social for diferente de 2.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if (HA_INDICADOR_RECOLHIMENTO_PS = 2) then begin

    wAno := HA_COMPETENCIA_ANO;

    if (HA_COMPETENCIA_MES = 12) then begin
      wDia := 2;
      wMes := 1;
      wAno := wAno + 1;
    end else if (HA_COMPETENCIA_MES = 13) then begin
      wDia := 20;
      wMes := 12;
    end else begin
      wDia := 2;
      wMes := wMes + 1;
    end;

    if HA_DATA_RECOLHIMENTO_PS <= EncodeDate( wAno, wMes, wDia) then begin
      kErro( CABECALHO + #13#13+
              'A DATA DE RECOLHIMENTO DA PREVIDENCIA SOCIAL para o INDICADOR igual a 2'#13+
              'deve ser posterior ao dia 02 do mês seguinte ao da competência ou'#13+
              'posterior ao dia 20/12 para competência 13');
      Exit;
    end;

    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HA_DATA_RECOLHIMENTO_PS);

  end else
    sLinha := sLinha + Espaco(8);

  (* 22. INDICE DE RECOLHIMENTO EM ATRASO DA PREVIDENCIA SOCIAL - Tam 7 Numerico
     # So deve ser informado para o Indicador de Recolhimento da Previdencia Social igual a 2.
     # A competencia deve ser maior ou igual a OUT/1998.
     # AAAAMM da data de recolhimento da Previdencial Social > AAAAMM de competencia + 2.
     # Nao deve ser informado para Indicador de Recolhimento da Previdencial Social diferente de 2.
     # A informacao tambem nao deve ser prestada para indicador de Recolhimento da
       Previdencia Social = 2, porem com data de recolhimento da Previdencia Social <
       AAAAMM de competencia + 2.
     # Se competencia = 13, e' exigido preenchimento deste campo quando AAAAMM da data
       de recolhimneto da Previdencia Social for > Mes 01 do ano seguinte ao da competencia.
     # Sempre que nao informado, campo deve ficar em branco. *)

   if HA_INDICADOR_RECOLHIMENTO_PS <> 2 then
     HA_INDICE_RECOLHIMENTO_PS := 0;

   if HA_INDICE_RECOLHIMENTO_PS = 0 then
     sLinha := sLinha + Espaco(7)
   else
     sLinha := sLinha + PadLeftChar( IntToStr(HA_INDICE_RECOLHIMENTO_PS), 7, #32);

  (* 23+. Tipo de Inscricao - Fornecedor Folha de Pagamento
     # So pode ser 1 (CNPJ), 2 (CEI) ou 3 (CPF). *)
  sLinha := sLinha + HA_TIPO_INSCRICAO_FORNECEDOR;

  (* 24+. Inscricao do fornecedor Folha de Pagamento - Tam. 14 Numerico
    # Se tipo Inscricao = 1, CNPJ valido,
      Se tipo Inscricao = 2, CEI valido,
      Se Tipo Inscricao = 3, CPF valido *)
  sLinha := sLinha + PadLeftChar( HA_INSCRICAO_FORNECEDOR, 14, #32);

  (* 25+. Brancos - Tam 18 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(18);

  (* 26+. Final de Linha - Tam 1 AN - Constante "*" *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;  // function HEADER_ARQUIVO

// ================================================================

function Header_Empresa:String;
const
  CABECALHO = 'Erro no registro Tipo "10" - Header da empresa';
var
  sLinha: String;
begin

  Result := '';

  (* 1+. TIPO DE REGISTRO - Tam 2 Numerico - Sempre '10' *)
  sLinha := '10';     // Chave

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido *)
   sLinha := sLinha + PadLeftChar( HE_INSCRICAO, 14, #32); // chave

  (* 4+. ZEROS - Tam 36 Numerico *)
  sLinha := sLinha + StringOfChar( '0', 36);   // chave

  (* 5+. NOME EMPRESA/RAZAO SOCIAL - Tam 40 AlfaNumerico *)
  sLinha := sLinha + PadRightChar( HE_EMPRESA, 40, #32);

  (* 6+. LOGRADOURO, RUA, N, ANDAR, APARTAMENTO - Tam 50 AN *)
  sLinha := sLinha + PadRightChar( HE_ENDERECO, 50, #32) ;

  // 7+. Bairro - Tam 20 AN -
  sLinha := sLinha + PadRightChar( HE_BAIRRO, 20, #32) ;

  // 8+. CEP - Tam 8 N
  sLinha := sLinha + PadRightChar( HE_CEP, 8, #32) ;

  // 9+. Cidade - Tam 20 AN
  sLinha := sLinha + PadRightChar( HE_CIDADE, 20, #32) ;

  // 10+. Unidade da Federacao
  sLinha := sLinha + HE_UF;

  (* 11+. Telefone Contato - Tam 12 N
     Deve conter no minimo 02 digito do DDD e 06 digitos no telefone  *)
  sLinha := sLinha + PadRightChar( HE_TELEFONE, 12, #32);

  (* 12+. INDICADOR DE ALTERACAO DE ENDERECO - Tam 1 A
     # So podera se 'S' ou 's' quando a empresa desejar alterar o endereco
       e 'N' ou 'n' quando nao desejar modifica-lo
     # Para a competencia 13, preencher com 'N' ou 'n' *)
  if (HA_COMPETENCIA_MES = 13) or (Pos( HE_ENDERECO_ALTERACAO, 'SsNn') = 0) then
    HE_ENDERECO_ALTERACAO := 'N';

  sLinha := sLinha + HE_ENDERECO_ALTERACAO;

  (* 13+. CNAE FISCAL - Tam 7 Numerico - Numero valido de CNAE FISCAL *)
  if Length(Trim(HE_CNAE_FISCAL)) = 0 then begin
    kErro( CABECALHO+#13#13+'O CNAE FISCAL é obrigatório');
    Exit;
  end;

  sLinha := sLinha + PadLeftChar( HE_CNAE_FISCAL, 7, #32);

  (* 14+. INDICADOR DE ALTERACAO CNAE FISCAL - Tam 1 A
     # So podera se 'S' ou 's' quando a empresa desejar alterar o CNAE FISCAL
       e 'N' ou 'n' quando nao desejar modifica-lo
     # Para a competencia 13, preencher com 'N' ou 'n' *)
  if (HA_COMPETENCIA_MES = 13) or (Pos( HE_CNAE_FISCAL_ALTERACAO, 'SsNn') = 0) then
    HE_CNAE_FISCAL_ALTERACAO := 'N';

  sLinha := sLinha + HE_CNAE_FISCAL_ALTERACAO;

  (* 15+. ALIQUOTA SAT - Tam 2 Numerico
     # Campo obrigatorio para competencia maior ou igual a OUT/1998.
     # Campo com uma posicao inteira e uma decimal
     # Nao pode ser informado para competencias anteriores a OUT/1998.
     # Sera sempre zeros para FPAS 604 e 647 e para a empresa optante pelo SIMPLES.
     # Sempre que nao informado, campo deve ficar em branco.  *)

  if (HE_FPAS = '604') or (HE_FPAS = '647') or (HE_SIMPLES = '2') then
    HE_SAT := 0;

  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 10) ) then
    HE_SAT := 0

  else if HE_SAT = 0 then begin
    kErro( CABECALHO+#13#13+
            'O campo (Alíquota SAT) é obrigatório para'+#13+
            'competência igual ou maior a OUT/1998.');
    Exit;
  end;

  if HE_SAT = 0 then
    sLinha := sLinha + Espaco(2)
  else
    sLinha := sLinha + kStrZero( Trunc(HE_SAT*10), 2);

  (* 16+. CODIGO DE CENTRALIZACAO - Tam 1 Numerico
     # So podera ser 0 (nao centralizada), 1 (centralizadora) ou 2 (centralizada).
     # Deve ser igual a zero (0), para os codigos de recolhimentos 130, 150,
       155, 317, 337, 608, 903, 904, 907, 908, 909, 910 e 911.
     # Quando existir empresa centralizadora deve existir, no minimo, uma
       empresa centralizada e vice-versa.
     # Quando existir centralizacao, as oitos primeiras posicoes do CNPJ da
       centralizadora e da centralizada devem ser iguais.
     # Empresa com inscricao CEI nao possui centralizacao. *)
  case HA_CODIGO_RECOLHIMENTO of
    130, 150, 155, 317, 337, 608, 903,
    904, 907, 908, 909, 910, 911: HE_CODIGO_CENTRALIZACAO := '0';
  end;

  if HE_TIPO_INSCRICAO = '2' then     // empresa com inscricao CEI
    HE_CODIGO_CENTRALIZACAO := '0';   // nao possui centralizacao

  if Pos( HE_CODIGO_CENTRALIZACAO, '_0_1_2_') = 0 then begin
    kErro( CABECALHO + #13#13+
             'O campo (CODIGO DE CENTRALIZACAO) é obrigatório e só poderá'+#13+
             'ser 0 (não centralizada), 1 (centralizadora) ou 2 (centralizada).');
    Exit;
  end;

  sLinha := sLinha + HE_CODIGO_CENTRALIZACAO;

  (* 17+. SIMPLES - Tam 1 Numerico
     # So podera ser 1 (nao optante), 1 (optante) ou branco.
     # Deve ser igual a 1 (um), para os codigos de recolhimentos 130, 608,
       903, 909 e 910 ou FPAS 523, 582, 639 e 655.
     # Nao deve se informado para os codigos de recolhimento 145, 345, 640 e 660.
     # Deve se igual a 1, para competencia anterior a OUT/1998.
     # Sempre que nao informado, campo deve ficar em branco *)

  if Pos( HE_FPAS, '_523_582_639_655_') > 0 then
    HE_SIMPLES := '1';

  case HA_CODIGO_RECOLHIMENTO of
    130, 608, 903, 909, 910: HE_SIMPLES := '1';
    145, 345, 640, 660:      HE_SIMPLES := '';
  end;

  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 10) ) then
    HE_SIMPLES := '1';

  if not (HE_SIMPLES[1] in ['1','2']) then
    HE_SIMPLES := '';

  sLinha := sLinha + PadLeftChar( HE_SIMPLES, 1, #32);

  (* 18+. FPAS - Tam 3 Numerico - Campo obrigatorio
     (Informar o codigo referente a atividade economica principal da empresa
      que identifica as contribuicoes ao Fundo de Previdencia e Assistencia
      Social e a terceiros ).
     # Deve ser diferente de 744 e 779, pois as GPS desses codigos serao
       geradas automaticamente, sempre que forem informados os respectivos
       fatos geradores dessas contribuicoes.
     # Deve ser diferente de 620, pois a informacao das categorias 15 e 16 indica
       os respectivos fatos geradores dessas contribuicoes. *)

  if (HE_FPAS = '744') or (HE_FPAS = '779') then begin
    kErro( CABECALHO + #13#13+
             'O campo (FPAS) é obrigatório e deve ser diferente'+#13+
             'de 744 e 779, pois as GPS desses códigos serão geradas'+#13+
             'automaticamente, sempre que forem informados os respectivos'+#13+
             'fatos geradores dessas contribuições.');
    Exit;
  end;

  if (HE_FPAS = '620') then begin
    kErro( CABECALHO +#13#13+
            'O campo (FPAS) é obrigatório e deve ser diferente'+#13+
            'de 620, pois a informação das categorias 15 e 16 indica'+#13+
            'os respectivos fatos geradores dessas contribuições.');
    Exit;
  end;

  if Length( Trim(HE_FPAS)) <> 3 then begin
    kErro( CABECALHO +#13#13 + 'O campo (FPAS) é obrigatório.');
    Exit;
  end;

  sLinha := sLinha + HE_FPAS;

  (* 19+. CODIGO DE TERCEIROS - Tam 4 Numerico
     ( Informar o codigo das Entidades para os quais a Previdencia Social
       arrecada e repassa contribuicoes )
     # Campo obrigatorio para os codigos de recolhimento 115, 130, 150, 155,
       307, 317, 327, 337, 608, 650, 903, 904, 905, 907, 908, 909, 910 e 911.
     # Nao deve ser informado para os codigos de recolhimento 145, 345, 640 e 660.
     # Nao deve ser informado para competencias anteriores a OUT/1998.
     # Se SIMPLES for igual a 1, o codigo deve estar contido na tabela de terceiros,
       inclusive zeros.
     # Se SIMPLES for igual a 2, o campo deve ficar em branco.
     # Sempre que nao informado, campo deve ficar em branco.   *)

  case HA_CODIGO_RECOLHIMENTO of
    115, 130, 150, 155, 307, 317, 327, 337, 608, 650, 903..905, 907..911:
      if Length( Trim(HE_CODIGO_TERCEIROS)) <> 4 then begin
        kErro( CABECALHO + #13#13+
                'O campo (CODIGO DE TERCEIROS) é obrigatório para os'+#13+
                'códigos de recolhimento 115, 130, 150, 155, 307, 317, 327,'+#13+
                '337, 608, 650, 903, 904, 905, 907, 908, 909, 910 e 911.');
        Exit;
      end;
    145, 345, 640, 660:
      HE_CODIGO_TERCEIROS := '';
  end;

  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 10) ) then
    HE_CODIGO_TERCEIROS := '';

  if HE_SIMPLES = '2' then
    HE_CODIGO_TERCEIROS := '';

  sLinha := sLinha + PadLeftChar( HE_CODIGO_TERCEIROS, 4, #32);

  (* 20+. CODIGO DE PAGAMENTO GPS - Tam 4 Numerico
     (Informar o codigo de pagamento da GPS, conforme tabela divulgada pelo INSS).
     # Campo obrigatorio para competencia maior ou igual a OUT/1998.
     # Acatar apenas para os codigos de recolhimento 115, 150, 307, 327, 650,
       903, 904, 905 e 907.
     # Nao acatar para os codigos de recolhimentos 147, 345, 640 e 660.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if (HA_COMPETENCIA_ANO > 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES >= 10) ) then
    case HA_CODIGO_RECOLHIMENTO of
      115, 150, 307, 327, 650, 903, 904, 905, 907:
        if Length( Trim(HE_CODIGO_PAGAMENTO_GPS)) <> 4 then begin
          kErro( CABECALHO + #13#13+
                  'O campo (CODIGO DE PAGAMENTO GPS) é obrigatório para os'+#13+
                  'códigos de recolhimento 115, 130, 150, 307, 327, 650, 903,'+#13+
                  '904, 905, 907 com competência maior ou igual a OUT/1998.');
          Exit;
        end;
    end;  // case

  case HA_CODIGO_RECOLHIMENTO of
    147, 345, 640, 660: HE_CODIGO_PAGAMENTO_GPS := '';
  end;

  sLinha := sLinha + PadLeftChar( HE_CODIGO_PAGAMENTO_GPS, 4, #32);

  (* 21. PERCENTUAL DE ISENCAO DE FILANTROPIA - Tam 5 Numerico
     (Indicar o percentual de isencao correspondente ao numero de atendimentos
      gratuitos prestados pela entidade - LEI 9732/98 ).
     # Valor deve ser composto de tres inteiros e duas decimais.
     # Nao deve ser informado para competencias anteriores a 04/1999.
     # So podera ser informado quando o FPAS for igual a 639.
     # Sempre que nao informado, preencher com brancos. *)

  if (HA_COMPETENCIA_ANO < 1999) or
     ( (HA_COMPETENCIA_ANO = 1999) and (HA_COMPETENCIA_MES < 4) ) then
   HE_FILATROPIA := 0;

  if HE_FPAS <> '639' then
   HE_FILATROPIA := 0;

  if HE_FILATROPIA = 0 then
    sLinha := sLinha + Espaco(5)
  else
    sLinha := sLinha + kStrZero( Trunc(HE_FILATROPIA*100), 5);

  (* 22. SALARIO-FAMILIA - Tam 15 Valor
     (Indicar o total pago pela empresa a titulo de salario-familia. O valor
     informado sera deduzido na GPS ).
     # Opcional para os codigos de recolhimneot 115, 307, 327, 903 e 905.
     # Nao acatar para os codigos de recolhimento 130, 145, 150, 155, 317,
       337, 345, 608, 640, 650, 660, 904, 907, 908, 909, 910 e 911.
     # Nao deve ser informado para a competencia 13.
     # Nao deve ser informado para competencias anteriores a OUT/1998.
     # Sempre que nao informado, preencher com zeros. *)

  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 10) ) then
    HE_SALARIO_FAMILIA := 0

  else if HA_COMPETENCIA_MES = 13 then
    HE_SALARIO_FAMILIA := 0

  else
    case HA_CODIGO_RECOLHIMENTO of
      130, 145, 150, 155, 317, 337, 345, 608, 640, 650,
      660, 904, 907..911: HE_SALARIO_FAMILIA := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(HE_SALARIO_FAMILIA*100), 15);

  (* 23. SALARIO-MATERNIDADE - Tam 15 Valor
     (Indicar o total pago pela empresa a titulo de salario-maternidade no
      mes em referencia. O valor informado sera deduzido na GPS ).
     # Opcional para os codigos de recolhimneot 115, 307, 327, 608, 903, 905 e 910.
     # Opcional para os codigos de recolhimento 150, 155, 317, 337, 907 e 908,
       quando o CNPJ da empresa for igual ao CNPJ do tomador.
     # Nao acatar para os codigos de recolhimento 130, 145, 345, 640, 650,
       660, 904, 909 e 911.
     # Nao deve ser informado para competencias anteriores a OUT/1998 nem
       para licenca maternidade iniciada a partir de 01.12.1999.
     # Nao deve ser informado para a competencia 13.
     # Sempre que nao informado, preencher com zeros. *)

  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 10) ) then
    HE_SALARIO_MATERNIDADE := 0

  else if HA_COMPETENCIA_MES = 13 then
    HE_SALARIO_MATERNIDADE := 0

  else
    case HA_CODIGO_RECOLHIMENTO of
      130, 145, 345, 640, 650, 660, 904, 909, 911: HE_SALARIO_MATERNIDADE := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(HE_SALARIO_MATERNIDADE*100), 15);

  (* 24. CONTRIBUICAO DESC. EMPREGADO REFERENTE A COMPETENCIA 13
    ( Informar o valor total da contribuicao descontada dos segurados na camp. 13)
    # Campo obrigatorio na competencia 12, para os codigos de recolhimento
      115, 307, 327, 903 e 905.
    # Nao deve ser informado para os codigos de recolhimento 145, 345, 640 e 660.
    # Nao deve ser informado nas demais competencias.
    # Sempre que nao informado, preencher com zeros. *)

  if HA_COMPETENCIA_MES = 12 then begin
    case HA_CODIGO_RECOLHIMENTO of
      115, 307, 327, 903, 905:
        if HE_CONT_DESC_EMPREGADO = 0 then begin
          kErro( CABECALHO +#13#13+
                  'O campo (CONTRIB. DESC. EMPREGADO COMP. 13) é obrigatório'+#13+
                  'para os códigos de recolhimento 115, 307, 327, 903 e 905'+#13+
                  'na competência 12.');
          Exit;
        end;
      145, 345, 640, 660:
        HE_CONT_DESC_EMPREGADO := 0;
    end;
  end else
    HE_CONT_DESC_EMPREGADO := 0;

  sLinha := sLinha + kStrZero( Trunc(HE_CONT_DESC_EMPREGADO*100), 15);

  (* 25. INDICADOR DE VALOR NEGATIVO OU POSITIVO - Tam 1 Valor
     Para indicar se o valor devido a Previdencia Social - campo 26 - e'
      (0) positivo ou (1) negativo. *)

  (* 26. VALOR DEVIDO A PREVIDENCIA SOCIAL REFERENTE A COMP. 13 - Tam 14 Valor
    ( Informar o valor total devido a Previdencia Social, na competencia 13).
    # Campo obrigatorio na competencia 12, para os codigos de recolhimento
      115, 307, 327, 903 e 905.
    # Nao deve ser informado para os codigos de recolhimento 145, 345, 640 e 660.
    # Nao deve ser informado nas demais competencias.
    # Sempre que nao informado, preencher com zeros. *)

  if HA_COMPETENCIA_MES = 12 then begin
    case HA_CODIGO_RECOLHIMENTO of
      115, 307, 327, 903, 905:
        if HE_PREVIDENCIA <> 0 then begin
          kErro( CABECALHO +#13#13+
                  'O campo (VALOR DEVIDO A PREV. COMP. 13) é obrigatório'+#13+
                  'para os códigos de recolhimento 115, 307, 327, 903 e 905'+#13+
                  'na competência 12.');
          Exit;
        end;
      145, 345, 640, 660:
        HE_PREVIDENCIA := 0;
    end;
  end else
    HE_PREVIDENCIA := 0;

  sLinha := sLinha + kIfThenStr( HE_PREVIDENCIA < 0, '1', '0');
  sLinha := sLinha + kStrZero( Trunc(Abs(HE_PREVIDENCIA)*100), 14);

  (* 27. Banco - Tam 3 N
  "Para debito em conta corrente. Implementacao futura *)
  sLinha := sLinha + Espaco(3);

  (* 28. Agencia - Tam 4 N
  "Para debito em conta corrente. Implementacao futura *)
  sLinha := sLinha + Espaco(4);

  (* 29. Conta Corrente - Tam 9 AN
  "Para debito em conta corrente. Implementacao futura *)
  sLinha := sLinha + Espaco(9);

  (* 30. Zeros - Tam 15 Valor - Para implementacao futura *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 31. Zeros - Tam 15 Valor - Para implementacao futura *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 32. Zeros - Tam 15 Valor - Para implementacao futura *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 33+. Brancos - Tam 4 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(4);

  (* 34+. Final de Linha - Tam 1 AN - Constante "*" *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;  // function Header_empresa

(* Registro obrigatorio para os codigos de recolhimento 650, 660 e 904. *)
function Registro12:String;
var
  sLinha: String;
begin

  Result := '';

  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 30 - chave *)
  sLinha := '12';

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido *)
   sLinha := sLinha + HE_INSCRICAO; // chave

  (* 4+. Zeros - ~Tam 36 Numerico - Preencher com zeros *)
  sLinha := sLinha + StringOfChar( '0', 36);  // Chave

  (* 5. Deducao 13 salrio Licenca Maternidade - Tam 15 V
     (Para informacao do valor da parcel de 13 salrio referente ao
      periodo em que a trabalhadora esteve em licenca maternidade. Deve
      se informado no arquivo da competencia 13.
      E exigido, ainda, quando uma trabalhadora que sofreu movimentacao
      por motivo de licenca maternidade for afastada por motivo de rescisao
      do contrato de trabalho (exceto rescisao por justa causa),
      aposentadoria ou falecimento. Neste caso a informacao deve constar
      do arquivo das competencias 1 a 12. )
     # Opcicnal para a competencia 13.
     # Opcional para os codigos de recolhimento 115, 307, 327, 608, 903,
       905 e 910.
     # Opcional para os codigos de recolhimento 150, 155, 317, 337, 907 e
       908, quando o CNPJ da empresa foi igual ao CNPJ do tomador.
     # Deve ser informado quando houver movimentacao por rescisao de contrato
       de trabalho (exceto rescisao por justa causa), aposentaria sem
       continuidade de vinculo, aposentaria por invalidez ou falecimento, para
       empregada que possuir afastamento por motivo de licenca maternidade no ano.
     # Nao deve ser informado para os codigos de recolhimento 130, 145, 345, 640,
       650, 660, 904, 909 e 911.
     # Deve ser informado apenas para movimentacoes por licenca maternidade
       ate 30.11.1999.
     # Sempre que nao informado, preencher com zeros.  *)

   case HA_CODIGO_RECOLHIMENTO of
     130, 145, 345, 640, 650, 660, 904, 909, 911: H12_v05 := 0;
   end;

   sLinha := sLinha + kStrZero( Trunc(H12_v05*100), 15);

  (* 6. Receita Evento Desportivo/Patrocinio - Tam 15 V
     Valor total da receita bruta de espetaculos desportivos em qualquer
     modalidade, realizado com qualquer associacao desportiva que matenha
     equipe de futebol profissional ou valor total pago a titulo de contrato
     de patrocinio, liceciamento de marcas e simbolos, publicidade, propaganda
     e transmissao de espetaculos celebrados com essas associacoes desportivas )
    # Campo opcional.
    # Pode ser informado para codigos de recolhimentos 115, 307, 327 e 905.
    # Pode ser informado para codigos de recolhimentos 150, 155, 317, 337, 907 e
      908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
    # Nao pode ser informado para os codigos de recolhimento 130, 145, 345, 608,
      640, 650, 660, 903, 904, 909, 910 e 911.
    # Nao pode ser informado para a competencia 13.
    # Sempre que nao informado, preencher com zeros. *)

   if HA_COMPETENCIA_MES = 13 then
     H12_v06 := 0
   else
     case HA_CODIGO_RECOLHIMENTO of
       130, 145, 345, 608, 640, 650, 660, 903, 904, 909..911:
         H12_v06 := 0;
     end;

   sLinha := sLinha + kStrZero( Trunc(H12_v06*100), 15);

  (* 7. INDICATIVO ORIGEM DA RECEITA - Tam 1 AN
     Indicar a origem da receita de evento desportivo/patrocio
     # Deve ser preenchido se Receita de Evento Desportivo/Patrocinio for
       informada. Se informado, so podera ser:
       "E" (receita referente a arrecadacao de eventos )
       "P" (receita referente a patrocinio)
       "A" (receita referente a arrecadacao de eventos e patrocinio)
     # Sempre que o campo for "P" o programa gerara, automaticamento GPS
       com codigo de pagamento 2500.
    # Nao deve ser informado para a competencia 13.
    # Sempre que nao informado, preencher com branco. *)

   if (H12_v06 > 0) and ( Length(Trim(H12_t07)) = 0 ) then begin
     kErro('Erro no registro Tipo "12" - Recolhimento da Empresa'+#13#13+
             'O Campo 7 - Indicativo Origem da Receita - e obrigatorio'#13+
             'quando o Campo 6 - Receita Evento Desportivo/Patrocinio e'+#13+
             'informado');
     Exit;
   end;

   if HA_COMPETENCIA_MES = 13 then
     H12_t07 := ''
   else

   if Length(H12_t07) = 0 then
     H12_t07 := #32
   else if Pos( H12_t07, '_E_P_A_') = 0 then begin
     kErro('Erro no registro Tipo "12" - Recolhimento da Empresa'+#13#13+
             'O Campo 7 - Indicativo Origem da Receita - quando informado'#13+
             'deve ser "E", "P" ou "A".');
     Exit;
   end;

   sLinha := sLinha + H12_t07;

  (* 8. COMERCIALIZACAO DE PRODUCAO RURAL - PESSOA FISICAL - Tam 15 Valor
     Informar o valor da comercializacao da producao rural no mes de
     competencia, realizada com produtor rural pessoal fisica.
     # Campo opcional.
     # Pode ser informado para codigos de recolhimento 115, 307, 327 e 905.
     # Nao pode ser informado para os codigos de recolhimentos 130, 145, 345,
       608, 640, 650, 660, 903, 904, 909, 9010 e 911.
     # Pode ser informado para os codigos de recolhimentos 150, 155, 317,
       337, 907 e 908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
     # Nao pode ser informado para a competencia 13.
     # Sempre que informado o programa gerara, automaticamente GPS com os
       codigos de pagamento 2607 ou 2704, conforme o caso.
     # Sempre que nao informado, preencher com zeros. *)

   if HA_COMPETENCIA_MES = 13 then
     H12_v08 := 0
   else
     case HA_CODIGO_RECOLHIMENTO of
       130, 145, 345, 608, 640, 650, 660, 903, 904, 909..911:
         H12_v08 := 0;
     end;

   sLinha := sLinha + kStrZero( Trunc(H12_v08*100), 15);

  (* 9. COMERCIALIZACAO DE PRODUCAO RURAL - PESSOA JURIDICA - Tam 15 Valor
     Informar o valor da comercializacao da producao rural no mes de
     competencia, realizada com produtor rural pessoal juridica.
     # Campo opcional.
     # Pode ser informado para codigos de recolhimento 115, 307, 327 e 905.
     # Pode ser informado para os codigos de recolhimentos 150, 155, 317,
       337, 907 e 908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
     # Nao pode ser informado para os codigos de recolhimentos 130, 145, 345,
       608, 640, 650, 660, 903, 904, 909, 9010 e 911.
     # Nao pode ser informado para a competencia 13.
     # Nao pode ser informado para empresa optante pelo SIMPLES.
     # Sempre que informado o programa gerara, automaticamente GPS com os
       codigos de pagamento 2607 ou 2704, conforme o caso.
     # Sempre que nao informado, preencher com zeros. *)

   if HA_COMPETENCIA_MES = 13 then
     H12_v09 := 0
   else if HE_SIMPLES = '2' then  // Optante
     H12_v09 := 0
   else
     case HA_CODIGO_RECOLHIMENTO of
       130, 145, 345, 608, 640, 650, 660, 903, 904, 909..911:
         H12_v09 := 0;
     end;

   sLinha := sLinha + kStrZero( Trunc(H12_v09*100), 15);

  (* 10. OUTRAS INFORMACOES - PROCESSO - Tam 11 Numerico
     # Campo obrigatorio para o codigo de recolhimento 660.
     # Campo opcional, para os codigos de recolhimento 650 e 904.
     # Nao deve ser informado para os demais codigos.
     # Sempre que nao informado, preencher com branco *)

  case HA_CODIGO_RECOLHIMENTO of
    660: if Length(Trim(H12_t10)) = 0 then begin
           kErro('Erro no registro Tipo "12" - Recolhimento da Empresa'+#13#13+
                   'O Campo 10 - Outras informacoes (Processo) - e obrigatorio'#13+
                   'o codigo de recolhimento 660.');
           Exit;
         end;
    650, 904:;
    else
      H12_t10 := '';
  end;

  if Length(H12_t10) = 0 then
    H12_t10 := Espaco(11)
  else
    H12_t10 := PadLeftChar( H12_t10, 11, #32);

  sLinha := sLinha + H12_t10;

  (* 11. OUTRAS INFORMACOES - PROCESSO ANO - Tam 4 Numerico
     # formato AAAA
     # Campo opcional, para os codigos de recolhimento 650 e 904.
     # Nao deve ser informado para os demais codigos.
     # Nao deve ser informado quando na remuneracao do processo nao constar a informacao.
     # Sempre que nao informado, preencher com branco *)

  if (HA_CODIGO_RECOLHIMENTO <> 650) and (HA_CODIGO_RECOLHIMENTO <> 904) then
    H12_n11 := 0;

  if H12_n11 = 0 then
    sLinha := sLinha + Espaco(4)
  else
    sLinha := sLinha + kStrZero( H12_n11, 4);

  (* 12. OUTRAS INFORMACOES - VARA/JCJ - Tam 5 Numerico
     # Campo obrigatorio, para o codigo de recolhimento 660.
     # Campo opcional, para os codigos de recolhimento 650 e 904.
     # Sempre que nao informado, preencher com branco *)

  case HA_CODIGO_RECOLHIMENTO of
    660: if Length(Trim(H12_t12)) = 0 then begin
           kErro('Erro no registro Tipo "12" - Recolhimento da Empresa'+#13#13+
                   'O Campo 12 - Outras informacoes - Vara/JCJ - e obrigatorio'#13+
                   'para o codigo de recolhimento 660.');
           Exit;
         end;
    650, 904:;
    else H12_t12 := '';
  end;

  if Length(Trim(H12_t12)) = 0 then
    sLinha := sLinha + Espaco(5)
  else
    sLinha := sLinha + PadLeftChar( H12_t12, 5, #32);

  (* 13. OUTRAS INFORMACOES - PERIODO INICIO - Tam 6 Data
     Destinado a informacao do AAAAMM de inicio do pleito da Reclamatoria
     Trabalhista/Dissidio Coletivo.
     # Formato AAAAMM.
     # Campo obrigatorio, para o codigo de recolhimento 650, 660 e 904.
     # Sempre que nao informado, preencher com branco *)

  case HA_CODIGO_RECOLHIMENTO of
    650, 660, 904: if Length(Trim(H12_t13)) = 0 then begin
           kErro('Erro no registro Tipo "12" - Recolhimento da Empresa'+#13#13+
                   'O Campo 13 - Outras informacoes (Periodo inicio) - e obrigatorio'#13+
                   'para o codigo de recolhimento 650, 660 e 904.');
           Exit;
         end;
  end;

  if (Length(Trim(H12_t13)) <> 6) then
    sLinha := sLinha + Espaco(6)
  else
    sLinha := sLinha + H12_t13;

  (* 14. OUTRAS INFORMACOES - PERIODO FIM - Tam 6 Data
     Destinado a informacao do AAAAMM de fim do pleito da Reclamatoria
     Trabalhista/Dissidio Coletivo.
     # Formato AAAAMM.
     # Campo obrigatorio, para o codigo de recolhimento 650, 660 e 904.
     # Sempre que nao informado, preencher com branco *)

  case HA_CODIGO_RECOLHIMENTO of
    650, 660, 904:
      if Length(Trim(H12_t14)) = 0 then begin
        kErro('Erro no registro Tipo "12" - Recolhimento da Empresa'+#13#13+
                'O Campo 14 - Outras informacoes (Periodo fim) - e obrigatorio'#13+
                'para o codigo de recolhimento 650, 660 e 904.');
        Exit;
      end;
  end;

  if (Length(Trim(H12_t14)) <> 6) then
    sLinha := sLinha + Espaco(6)
  else
    sLinha := sLinha + H12_t14;

  (* 15. Compensacao - Valor - Tam 15 valor
    Para informacao de valore recolhidos indevidamente ou a maior em competencias
    anteriores e que a empresa deseja compensar na atual Guia Recolhimento
    da Previdencia Social.
    # campo opcional.
    # Pode ser informado para codigos de recolhimento 115, 307, 327, 650, 903, 904 e 905.
    # Nao pode ser informado para os codigos de recolhimento 145, 345, 640 e 660.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Nao deve ser informado para competencia 13.
    # Sempre que nao informado, preencher com zeros. *)

  if HA_COMPETENCIA_MES = 13 then
    H12_v15 := 0
  else if HA_INDICADOR_RECOLHIMENTO_FGTS <> '1' then
    H12_v15 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      145, 345, 640, 660: H12_v15 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H12_v15*100), 15);

  (* 16. Compensacao - Periodo Inicio - Tam 6 Data
     Para informacao AAAAMM fim das competencias recolhidas indevidamente ou a maior.
     # Formato AAAAMM.
     # So deve ser informado se o campo Compensacao - Valor for diferente de zero.
     # Nao deve ser informado para competencia 13.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if (H12_v15 = 0) or ( Length(H12_t16) <> 6) then
    H12_t16 := Espaco(6);

  sLinha := sLinha + H12_t16;

  (* 17. Compensacao - Periodo Fim - Tam 6 Data
     Para informacao AAAAMM fim das competencias recolhidas indevidamente ou a maior.
     # Formato AAAAMM.
     # So deve ser informado se o campo Compensacao - Valor for diferente de zero.
     # Periodo Fim deve ser maior ou igual ao Periodo Inicio e menor que o mes de competencia.
     # Nao deve ser informado para competencia 13.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if (H12_v15 = 0) or
     ( Length(Trim(H12_t16)) <> 6) or ( Length(Trim(H12_t17)) <> 6) then
    H12_t17 := Espaco(6);

  sLinha := sLinha + H12_t17;

  (* 18. Recolhimento de Competencias Anteriores - Valor do INSS
         sobre Folha de Pagamento - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecacao menor que R$ 25,00. Neste campo informar o
    total do campo 6 da GPS.
    # campo opcional.
    # Pode ser informado para codigos de recolhimento 115, 307, 327, 650, 903, 904 e 905.
    # Nao pode ser informado para os codigos de recolhimento 145, 345, 640 e 660.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if HA_INDICADOR_RECOLHIMENTO_FGTS <> '1' then
    H12_v18 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      145, 345, 640, 660: H12_v18 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H12_v18*100), 15);

  (* 19. Recolhimento de Competencias Anteriores - Outras entidades
         sobre Folha de Pagamento - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecacao menor que R$ 25,00. Neste campo informar o
    total do campo 9 da GPS.
    # campo opcional.
    # Pode ser informado para codigos de recolhimento 115, 307, 327, 650, 903, 904 e 905.
    # Nao pode ser informado para os codigos de recolhimento 145, 345, 640 e 660.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if HA_INDICADOR_RECOLHIMENTO_FGTS <> '1' then
    H12_v19 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      145, 345, 640, 660: H12_v19 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H12_v19*100), 15);

  (* 20. Recolhimento de Competencias Anteriores - Comercializacao de
         Producao Rural - Valor do INSS - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecacao menor que R$ 25,00. Neste campo informar o
    total do campo 6 da GPS de codigos de pagamento 2607 ou 2704.
    # campo opcional.
    # Pode ser informado para codigos de recolhimento 115, 307, 327 e 905.
    # Nao pode ser informado para os codigos de recolhimento 145, 345, 640, 650,
      660, 903 e 904.
    # pode ser informado para os codigos de recolhimento 150, 155, 317, 337,
      907 e 908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if HA_INDICADOR_RECOLHIMENTO_FGTS <> '1' then
    H12_v20 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      145, 345, 640, 650, 660, 903, 904: H12_v20 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H12_v20*100), 15);

  (* 21. Recolhimento de Competencias Anteriores - Comercializacao de
         Producao Rural - Outras entidades - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecacao menor que R$ 25,00. Neste campo informar o
    total do campo 9 da GPS de codigos de pagamento 2607 ou 2704.
    # campo opcional.
    # Pode ser informado para codigos de recolhimento 115, 307, 327 e 905.
    # Nao pode ser informado para os codigos de recolhimento 145, 345, 640, 650,
      660, 903 e 904.
    # pode ser informado para os codigos de recolhimento 150, 155, 317, 337,
      907 e 908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if HA_INDICADOR_RECOLHIMENTO_FGTS <> '1' then
    H12_v21 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      145, 345, 640, 650, 660, 903, 904: H12_v21 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H12_v21*100), 15);

  (* 22. Recolhimento de Competencias Anteriores - (Receita/Patrocio)
         Valor do INSS - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecadacao menor que R$ 25,00. Neste campo informar o
    total do campo 9 da GPS de codigos de pagamento 2500.
    # campo opcional.
    # Pode ser informado para codigos de recolhimento 115, 307, 327 e 905.
    # Nao pode ser informado para os codigos de recolhimento 145, 345, 640, 650,
      660, 903 e 904.
    # pode ser informado para os codigos de recolhimento 150, 155, 317, 337,
      907 e 908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if HA_INDICADOR_RECOLHIMENTO_FGTS <> '1' then
    H12_v22 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      145, 345, 640, 650, 660, 903, 904: H12_v22 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H12_v22*100), 15);

  (* 23. Parcelamento do FGTS - Tam 15 numerico
     Somatorio Remuneracoes das Categorias 01,02,03 e 05
     Informar o valor total das remuneracoes das categorias 01, 02, 03 e 05.
     # Para implementacao futura.
     # Campo obrigatorio para os codigos de recolhimento 307 e 327, quando
       modalidade de parcelamento for 2 ou 3.
     # Ate autorizacao da CAIXA, preencher com zeros. *)

  h12_v23 := 0;

  sLinha := sLinha + kStrZero( Trunc(h12_v23*100), 15);

  (* 24. Parcelamento do FGTS - Tam 15 numerico
     Somatorio Remuneracoes das Categorias 04.
     Informar o valor total das remuneracoes das categorias 04.
     # Para implementacao futura.
     # Campo obrigatorio para os codigos de recolhimento 307 e 327, quando
       possuir trabalhador categoria 04 e modalidade de parcelamento for 2 ou 3.
     # Ate autorizacao da CAIXA, preencher com zeros. *)

  h12_v24 := 0;

  sLinha := sLinha + kStrZero( Trunc(h12_v24*100), 15);

  (* 25. Parcelamento do FGTS - Tam 15 numerico
     Valor recolhido
     Informar o valor total recolhido ao FGTS (Deposito+JAM+Multa)
     # Para implementacao futura.
     # Campo obrigatorio para os codigos de recolhimento 307 e 327, quando
       modalidade de parcelamento for 2 ou 3.
     # Ate autorizacao da CAIXA, preencher com zeros. *)

  h12_v25 := 0;

  sLinha := sLinha + kStrZero( Trunc(h12_v25*100), 15);

  (* 26. Valores pagos a Cooperativas de Trabalho - Tam 15 Valor
    Informar o montante da base de calculo da contribuicao previdenciaria
    referente aos valores pagos a Cooperativas de Trabalho.
    # Campo opcional para os codigos de recolhimento 115, 307, 327 e 905.
    # Pode ser informado para os codigos de recolhimento 150, 155, 317, 337,
      907 e 908 quando o CNPJ da empresa for igual ao CNPJ do tomador.
    # Nao pode ser informado para competencias anterios a 03/2000.
    # Nao pode ser informado na competencia 13.
    # Sempre que nao informado, preencher com zeros. *)

  if HA_COMPETENCIA_MES = 13 then
    H12_v26 := 0
  else if (HA_COMPETENCIA_ANO < 2000) or
          ( (HA_COMPETENCIA_ANO = 2000) and (HA_COMPETENCIA_MES < 3) ) then
    H12_v26 := 0;

  sLinha := sLinha + kStrZero( Trunc(H12_v26*100), 15);

  (* 27. Implementacao futura - Tam 15 V - Preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 28. Implementacao futura - Tam 15 V - Preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 29. Implementacao futura - Tam 15 V - Preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 30+. Brancos - Tam 6 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(6);

  (* 31+. Final de Linha - Tam 1 AN - Constante "*" *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end; // function Registro12

(* # Nao acatar para a competencia 13.
   # Nao serao acatadas 03 ou mais alteracoes para o mesmo trabalhador
     em campos sensiveis: Nome, CTPS, PIS e Data de Admissao.
   # Deve existir somente 01 registro 13 por trabalahador (PIS+Data de Admissao+
     Categoria+Empresa) por codigo de alteracao cadastral.
   # Nao acatar para as categorias 11, 12, 13, 14, 15, 16 e 17.
   # Nao acatar para os codigos de recolhimentos 130, 150, 155, 317, 337, 608,
     907 e 910 quando existir somente alteracao cadastral no arquivo. *)

function Registro13:String;
const
  CABECALHO = 'Erro no registro Tipo "13" - Alteracao Cadastral Trabalhador';
var
  sLinha: String;
begin

  Result := '';

  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 13 - chave *)
  sLinha := '13';

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido *)
   sLinha := sLinha + HE_INSCRICAO; // chave

  (* 4+. Zeros - Tam 36 Numerico - Chave *)
  sLinha := sLinha + kStrZero( 0, 36);

  (* 5+. PIS/PASEP/CI - Tam 11 Numerico - Campo obrigatorio e valido *)
  sLinha := sLinha + HT_PIS;

  (* 6. Data de Admissao - Tam 8 data
     # Formato DDMMAAAA
     # Obrigatorio para as categorias de trabalhadores 01, 03, 04, 05, 11 e 12
       e deve conter uma data valida.
     # Nao deve ser informado para a categoria 02.
     # Deve ser menor ou igual a competencia informada.
     # deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04, 05:
      begin
        if HT_ADMISSAO = 0 then begin
          kErro( CABECALHO +#13#13+
                  'A ADMISSAO é obrigatória para as categorias de trabalhador'#13+
                  '01, 03, 04 e 05.');
          Exit;
        end;
        if (HT_CATEGORIA = 04) and
           (HT_ADMISSAO < EncodeDate( 1998, 1, 22)) then begin
          kErro( CABECALHO +#13#13+
                  'A ADMISSAO para a categoria 04 deve ser maior ou igual a 22/01/1998');
          Exit;
        end;
      end;
    02:
      HT_ADMISSAO := 0;
  end;  // case

  if HT_ADMISSAO = 0 then
    sLinha := sLinha + Espaco(8)
  else
    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HT_ADMISSAO);

  (* 7+. CATEGORIA TRABALHADOR * - Tam 2 Numerico - Campo obrigatorio
     ( Codigo deve estar contido na tabela categoria do trabalhador )
     # Campo obrigatorioi
     # Acatar somente as categorias 01, 02, 03, 04 e 05 *)

  if not (HT_CATEGORIA in [01..05]) then begin
    kErro( CABECALHO+#13#13+
             'Para este registro é acatada somente as categorias'+#13+
             '01, 02, 03, 04 e 05.');
    Exit;
  end;

  sLinha := sLinha + kStrZero( HT_CATEGORIA, 2);

  (* 8. MATRICULA DO EMPREGADO - Tam 11 Numerico
     # Numero de matricula atribuido pela empresa ao trabalhador, quando houver.
     # Campo nao deve ser informado para as categorias 13, 14, 15, 16 e 17.
     # Sempre que nao informado, campo deve ficar em branco. *)

  sLinha := sLinha + PadLeftChar( Trim(HT_MATRICULA), 11, #32);

  (* 9. NUMERO CTPS - Tam 7 Numerico
     # Obrigatorio para as categorias de trabalhadores 01, 03 e 04.
     # Opcional a categoria de trabalhador 02.
     # Nao deve ser informado para a categoria 05.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04:
      if Length(HT_CTPS) = 0 then begin
        kErro( CABECALHO +#13#13+
                 'O Numero CTPS é obrigatório para as categoria 01, 03 e 04.');
        Exit;
      end;
    05: HT_CTPS := '';
  end;

  sLinha := sLinha + PadLeftChar( Trim(HT_CTPS), 7, '0');

  (* 10. Serie CTPS - Tam 5 Numerico
     # Obrigatorio para as categorias de trabalhadores 01, 03 e 04.
     # Opcional a categoria de trabalhador 02.
     # Nao deve ser informado para as demais categorias.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if Length(HT_CTPS) = 0 then
    HT_SERIE := '';

  case HT_CATEGORIA of
    01, 03, 04:
      if Length(HT_SERIE) = 0 then begin
        kErro( CABECALHO +#13#13+
                'O Numero de Serie CTPS é obrigatório para as categoria 01, 03 e 04.');
        Exit;
      end;
    05:
      HT_SERIE := '';
  end;

  sLinha := sLinha + PadLeftChar( Trim(HT_SERIE), 5, '0');

  (* 11+. NOME DO TRABALHADOR - Tam 70 Alfanumerico - Campo obrigatorio
     # Nao pode conter numero, caracteres especiais, acento, mais de um
       espaco entre os nomes, mais de duas letras iguais consecutivas e a
       primeira posicao nao pode ser branco.
     # Pode conter apenas caracteres de A a Z.*)
  sLinha := sLinha + HT_NOME;

  (* 12. Codigo empresa CAIXA - Tam 14 Numerico
     # Campo obrigatorio.
     # Preencher com codigo valido fornecido pela CAIXA *)

  sLinha := sLinha + PadLeftChar( IntToStr(H13_n12), 14, #32);

  (* 13. Codigo trabalhador CAIXA - Tam 11 Numerico
     # Campo obrigatorio.
     # Preencher com codigo valido fornecido pela CAIXA *)

  sLinha := sLinha + PadLeftChar( IntToStr(H13_n13), 11, #32);

  (* 14. Codigo Alteracao Cadastral - Tam 3 Numerico
     # Campo obrigatorio.
     # Deve estar contido na tabela de tipos de alteracao do trabalhador,
       conforme descrito no final deste MANUAL. *)

  case H13_n14 of
    403..406, 408, 426..428:
    else begin
      kErro( CABECALHO +#13#13+
               'O Codigo de Alteracao Cadastral deve ser 403,'+#13+
               '404, 405, 406, 408, 426, 427 ou 428.');
      Exit;
    end;
  end;

  sLinha := sLinha + PadLeftChar( IntToStr(H13_n14), 3, #32);

  (* 15. Novo Conteudo do Campo - Tam 70 AN - Campo obrigatorio
     # Criticar conforme as regras estabelecidas para os campos alterador *)

  sLinha := sLinha + PadRightChar( H13_t15, 70, #32);

  (* 16+. Brancos - Tam 94 AN - Preencher com brancos - Campo obrigatorio *)
  sLinha := sLinha + Espaco(94);

  (* 17+. Final de Linha - Tam 1 AN - Constante "*" - Campo obrigatorio *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;  // function Registro13

(* # Categorias permitidas: 01, 02, 03, 04, 05, 11 e 12.
   # Para as demais categorias nao ha registro tipo 14.
   # Nao acatar para a competencia 13.
   # Soh deve existir um registro 14 por trabalhador (PIS+Data de Admissao+
     Categoria+Empresa).
   # Nao acatar para os codigos de recolhimentos 130, 150, 155, 317, 337, 608,
     907, 908, 909 e 910 quando existir somente informacao de endereco no arquivo. *)

function Registro14:String;
const
  CABECALHO = 'Erro no registro Tipo "14" - Inclusao/Alteracao Endereco Trabalhador';
var
  sLinha: String;
begin

  Result := '';

  if (HA_COMPETENCIA_MES = 13) then
    Exit;

  case HT_CATEGORIA of
    01..05, 11, 12:  // categorias permitidas
    else
      Exit;
  end;

  // Se o endereco do trabalhador foi alterado antes da competencia informada
  // nao gerar registro 14
  if ( H14_ENDERECO_ALT <
       EncodeDate( HA_COMPETENCIA_ANO, HA_COMPETENCIA_MES, 01) ) then
    Exit;

  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 14 - chave *)
  sLinha := '14';

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido
     # A inscricao esperada deve ser igual a do registro 10 imediatamente anterior *)
   sLinha := sLinha + HE_INSCRICAO; // chave

  (* 4+. Zeros - Tam 36 Numerico - Chave *)
  sLinha := sLinha + kStrZero( 0, 36);

  (* 5+. PIS/PASEP/CI - Tam 11 Numerico - Campo obrigatorio e valido *)
  sLinha := sLinha + HT_PIS;

  (* 6. Data de Admissao - Tam 8 data
     # Formato DDMMAAAA
     # Obrigatorio para as categorias de trabalhadores 01, 03, 04, 05, 11 e 12
       e deve conter uma data valida.
     # Nao deve ser informado para a categoria 02.
     # Deve ser menor ou igual a competencia informada.
     # deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04, 05:
      begin
        if HT_ADMISSAO = 0 then begin
          kErro( CABECALHO +#13#13+
                  'Funcionário: '+HT_MATRICULA +' - '+HT_NOME+#13+
                  'Categoria: '+kStrZero( HT_CATEGORIA, 2) +#13#13+
                  'A ADMISSÃO é obrigatória para as categorias de trabalhador'#13+
                  '01, 03, 04 e 05.');
          Exit;
        end;
        if (HT_CATEGORIA = 04) and
           (HT_ADMISSAO < EncodeDate( 1998, 1, 22)) then begin
          kErro( CABECALHO +#13#13+
                  'A ADMISSAO para a categoria 04 deve ser maior ou igual a 22/01/1998');
          Exit;
        end;
      end;
    02:
      HT_ADMISSAO := 0;
  end;  // case

  if HT_ADMISSAO = 0 then
    sLinha := sLinha + Espaco(8)
  else
    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HT_ADMISSAO);

  (* 7+. CATEGORIA TRABALHADOR * - Tam 2 Numerico - Campo obrigatorio
     ( Codigo deve estar contido na tabela categoria do trabalhador *)

  sLinha := sLinha + kStrZero( HT_CATEGORIA, 2);

  (* 8. NOME DO TRABALHADOR - Tam 70 Alfanumerico - Campo obrigatorio
     # Nao pode conter numero, caracteres especiais, acento, mais de um
       espaco entre os nomes, mais de duas letras iguais consecutivas e a
       primeira posicao nao pode ser branco.
     # Pode conter apenas caracteres de A a Z.*)
  sLinha := sLinha + HT_NOME;

  (* 9. NUMERO CTPS - Tam 7 Numerico
     # Obrigatorio para as categorias de trabalhadores 01, 03 e 04.
     # Opcional a categoria de trabalhador 02.
     # Nao deve ser informado para a categoria 05, 11 e 12.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04:
      if Length(HT_CTPS) = 0 then begin
        kErro( CABECALHO +#13#13+
                 'O Numero CTPS é obrigatório para as categoria 01, 03 e 04.');
        Exit;
      end;
    05, 11, 12: HT_CTPS := '';
  end;

  sLinha := sLinha + PadLeftChar( Trim(HT_CTPS), 7, '0');

  (* 10. Serie CTPS - Tam 5 Numerico
     # Obrigatorio para as categorias de trabalhadores 01, 03 e 04.
     # Opcional a categoria de trabalhador 02.
     # Nao deve ser informado para as demais categorias.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if Length(HT_CTPS) = 0 then
    HT_SERIE := ''
  else if Length(HT_SERIE) = 0 then begin
    kErro( CABECALHO +#13#13+
             'O Numero de Serie CTPS e obrigatorio para as categoria 01, 03 e 04.');
     Exit;
   end;

  sLinha := sLinha + PadLeftChar( Trim(HT_SERIE), 5, '0');

  // 11. Logradouro, rua, no., andar, apartamento - Tam 50 - Campo obrigatorio
  sLinha := sLinha + PadRightChar( H14_ENDERECO, 50, #32);

  // 12. Bairro - Tam 20 AN -
  sLinha := sLinha + PadRightChar( H14_BAIRRO, 20, #32);

  // 13+. CEP - Tam 8 N - Campo obrigatorio
  sLinha := sLinha + H14_CEP;

  // 14+. Cidade - Tam 20 AN - Campo obrigatorio
  sLinha := sLinha + PadRightChar( H14_CIDADE, 20, #32);

  // 15+. Unidade da Federacao
  sLinha := sLinha + H14_UF;

  (* 16+. Brancos - Tam 103 AN - Preencher com brancos - Campo obrigatorio *)
  sLinha := sLinha + Espaco(103);

  (* 17+. Final de Linha - Tam 1 AN - Constante "*" - Campo obrigatorio *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;  // function Registro14

(* ==========================================================================
   REGISTRO TIPO 20 - Registro do Tomador de Serico / Obra de Construcao Civil
   Obrigatorio para os codigos de recolhimento: 130, 150, 155, 317, 337,
   608, 907, 908, 909, 910 e 911.
   ========================================================================== *)

function Registro20:String;
const
  CABECALHO = 'Erro no registro Tipo "20" - Tomador de Serico/Obra de Construcao Civil';
  TIPO_REGISTRO = '20';
var
  sLinha: String;
begin

  Result := '';

  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 20 - Campo obrigatorio - Chave *)
  sLinha := TIPO_REGISTRO;

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido *)
   sLinha := sLinha + HE_INSCRICAO; // chave

  (* 4+. TIPO DE INSCRICAO - TOMADOR/OBRA DE CONST. CIVIL
      Tam 1 Numerico -  Chave - So podera ser 1 (CNPJ) ou 2 (CEI) *)

  if Pos( H_TOMADOR_TIPO, '_1_2_') = 0 then begin
    kErro( CABECALHO+#13#13+
             'O TIPO DE INSCRIÇÃO DO TOMADOR e obrigatorio.');
    Exit;
  end;

  sLinha := sLinha + H_TOMADOR_TIPO;

  (* 5. INSCRICAO DO TOMADOR - Tam 14 Numerico - CNPJ ou CEI valido
     Destinado a informacao da inscricao da empresa tomadora de servico
     nos recolhimentos de trabalhadores avulsos, prestacao de servicos,
     obras de construcao civil e dirigente sindical.
     # Campo obrigatorio *)
   sLinha := sLinha + PadLeftChar( H_TOMADOR_INSCRICAO, 14, #32); // chave

  (* 6. Zeros - Tam 21 Numerico - Campo obrigatorio - Preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 21);

  (* 7. NOME DO TOMADOR/OBRA CONST. CIVIL - Tam 40 AN - Campo obrigatorio *)
  sLinha := sLinha + H_TOMADOR_NOME;

  // 8+. Logradouro, rua, no., andar, apartamento - Tam 50
  sLinha := sLinha + H_TOMADOR_ENDERECO;

  // 9+. Bairro - Tam 20 AN -
  sLinha := sLinha + H_TOMADOR_BAIRRO;

  // 10+. CEP - Tam 8 N
  sLinha := sLinha + H_TOMADOR_CEP;

  // 11+. Cidade - Tam 20 AN
  sLinha := sLinha + H_TOMADOR_CIDADE;

  // 12+. Unidade da Federacao
  sLinha := sLinha + H_TOMADOR_UF;

  (* 13. CODIGO DE PAGAMENTO GPS - Tam 4 Numerico - Campo obrigatorio
     Informar o codigo de pagamento da GPS, conforme tabela divulgada pelo INSS.
     # Campo obrigatorio para competencia maior ou igual a OUT/1998.
     # Acatar apenas para os codigos de recolhimento 130, 155, 317, 337, 608, 908, 909 e 910.
     # Nao acatar para o codigo de recolhimento 911.
     # Sempre que nao informado, preencher com brancos. *)

  case HA_CODIGO_RECOLHIMENTO of
    130, 155, 317, 337, 608, 908..910:
      if ( HA_COMPETENCIA_ANO > 1998) or
         ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES >= 10) ) then
        if Length(H20_t13) = 0 then begin
          kErro( CABECALHO + #32#32+
                   'O CODIGO DE PAGAMENTO GPS e obrigatorio para'+#32+
                   'competencias maior ou igual a OUT/1998.');
          Exit;
        end;
    else
      H20_t13 := '';
  end;  // case

  sLinha := sLinha + PadLeftChar( H20_t13, 4, #32);

  (* 14. SALARIO FAMILIA - Tam 15 Valor - Campo opcional
     Indicar o total pago pela empresa a titulo de salario familia.
     O Valor informado sera deduzido na GPS.
     # Nao pode ser informado para a competencia 13.
     # so pode ser informado para os codigos de recolhimento 150, 155, 317, 608,
       907, 908 e 910.
     # Nao pode ser informado para os codigos de recolhimento 130, 909 e 911.
     # Sempre que nao informado, preencher com zeros. *)
  if HA_COMPETENCIA_MES = 13 then
    H20_v14 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      150, 155, 317, 608, 907, 908, 910:
      else H20_v14 := 0;
    end;  // case

  sLinha := sLinha + kStrZero( Trunc(H20_v14*100), 15);

  (* 15. CONTRIBUICAO DESC. EMPREGADO REFERENTE A COMPETENCIA 13 -  Tam 15 Valor
     Informar o valot total da comntribuicao descontada dos segurados na competencia 13.
     # Campo obrigatorio para a competencia 12.
     # Nao pode ser informado nas demais competencias.
     # so pode ser informado para os codigos de recolhimento 150, 155, 608, 907, 908 e 910.
     # Nao pode ser informado para os codigos de recolhimento 130, 317, 337, 909 e 911.
     # Sempre que nao informado, preencher com zeros. *)
  if HA_COMPETENCIA_MES = 12 then
    case HA_CODIGO_RECOLHIMENTO of
      150, 155, 608, 907, 908, 910:
        if H20_v15 = 0 then begin
          kErro( CABECALHO+#32#32+
                   'O Campo 15 - Contrib. Desc. Empregado - e obrigatorio'+#32+
                   'para os codigos de recolhimento 150, 155, 608, 907, 908 e 910'+#32+
                   '(Competencia 12)' );
          Exit;
        end;
      else
        H20_v15 := 0;
    end  // case
  else
    H20_v15 := 0;

  sLinha := sLinha + kStrZero( Trunc(H20_v15*100), 15);

  (* 16. INDICADOR DE VALOR NEGATIVO OU POSITIVO -  Tam 1 Valor
     Para indicar se o valor devido a Previdencia Social - campo 17 -
     e (0) positivo ou (1) negativo. *)

  (* 17. VALOR DEVIDO A PREVIDENCIA SOCIAL, REFERENTE A COMPETENCIA 13 -  Tam 15 Valor
     Informar o valor total devido a Previdencia social, na competencia 13.
     # Campo obrigatorio para a competencia 12.
     # Nao pode ser informado nas demais competencias.
     # So pode ser informado para os codigos de recolhimento 150, 155, 608, 907, 908 e 910.
     # Nao pode ser informado para os codigos de recolhimento 130, 317, 337, 909 e 911.
     # Sempre que nao informado, preencher com zeros. *)

  if HA_COMPETENCIA_MES = 12 then
    case HA_CODIGO_RECOLHIMENTO of
      150, 155, 608, 907, 908, 910:
        if H20_v17 = 0 then begin
          kErro( CABECALHO+#32#32+
                   'O Campo 17 - Valor devido a Previdencia Social - e obrigatorio'+#32+
                   'para os codigos de recolhimento 150, 155, 608, 907, 908 e 910'+#32+
                   'na Competencia 12' );
          Exit;
        end;
      else
        H20_v17 := 0;
    end  // case
  else
    H20_v17 := 0;

  sLinha := sLinha + kIfThenStr( H20_v17 < 0, '1', '0');
  sLinha := sLinha + kStrZero( Trunc( Abs(H20_v17)*100), 15);

  (* 18. VALOR DE RETENCAO (LEI 9.711/98) - Tam 15 Valor - Campo opcional
     Informar o somatorio das retencoes efetuadas pelo tomador de servicos.
     O valor informado sera deduzido na GPS.
     # Nao deve ser informado na competencia 13.
     # So deve ser informado para os codigos de recolhimento 150, 155, 907 e 908.
     # Sempre que nao informado, preencher com zeros. *)
   if HA_COMPETENCIA_MES = 13 then
     H20_v18 := 0
   else
     case HA_CODIGO_RECOLHIMENTO of
       150, 155, 907, 908:
       else
         H20_v18 := 0;
     end;

   sLinha := sLinha + kStrZero( Trunc( H20_v18*100), 15);

  (* 19. VALOR DAS FATURAS EMITIDAS PARA O TOMADOR - Tam 15 Valor
     Informar o montante da base de calculo da contribuicao previdenciaria
     referente aos valores das notas fiscais emitidas pelas Cooperativas de
     trabalho aos seus contratantes.
     # Campo obrigatorio para o codigo de recolhimento 911.
     # Nao pode ser informado para os demais codigos de recolhimento.
     # Nao pode ser informado para competencias anteriores a MAR/2000.
     # Sempre que nao informado, preencher com zeros. *)
   if (HA_COMPETENCIA_ANO < 2000) or
      ( (HA_COMPETENCIA_ANO = 2000) and (HA_COMPETENCIA_MES < 3) ) then
     H20_v19 := 0
   else if HA_CODIGO_RECOLHIMENTO <> 911 then
     H20_v19 := 0
   else if H20_v19 = 0 then begin
     kErro( CABECALHO+#32#32+
              'O Campo 19 - Valor das faturas emitidas para o tomador'+#13+
              'e obrigatorio para o codigo de recolhimento 911.' );
     Exit;
   end;

   sLinha := sLinha + kStrZero( Trunc( H20_v19*100), 15);

  (* 20. Zeros - Tam 15 Numerico
     Para implementacao futura. Ate autorizacao da CAIXA preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 21. Zeros - Tam 15 Numerico
     Para implementacao futura. Ate autorizacao da CAIXA preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 22. Zeros - Tam 15 Numerico
     Para implementacao futura. Ate autorizacao da CAIXA preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 15);

  (* 23+. Brancos - Tam 42 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(42);

  (* 24+. Final de Linha - Tam 1 AN - Constante "*" *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;

function Registro21:String;
const
  CABECALHO = 'Erro no registro Tipo "21" - Informacoes adicionais do Tomador de Serico/Obra de Construcao Civil';
  TIPO_REGISTRO = '21';
var
  sLinha: String;
begin

  Result := '';

  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 21 - Campo obrigatorio - Chave *)
  sLinha := TIPO_REGISTRO;

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido *)
   sLinha := sLinha + HE_INSCRICAO; // chave

  (* 4+. TIPO DE INSCRICAO - TOMADOR/OBRA DE CONST. CIVIL
      Tam 1 Numerico -  Chave - So podera ser 1 (CNPJ) ou 2 (CEI) *)

  if Pos( H_TOMADOR_TIPO, '_1_2_') = 0 then begin
    kErro( CABECALHO+#13#13+
             'O TIPO DE INSCRIÇÃO DO TOMADOR e obrigatorio.');
    Exit;
  end;

  sLinha := sLinha + H_TOMADOR_TIPO;

  (* 5. INSCRICAO DO TOMADOR - Tam 14 Numerico - CNPJ ou CEI valido
     Destinado a informacao da inscricao da empresa tomadora de servico
     nos recolhimentos de trabalhadores avulsos, prestacao de servicos,
     obras de construcao civil e dirigente sindical.
     # Campo obrigatorio *)
   sLinha := sLinha + PadLeftChar( H_TOMADOR_INSCRICAO, 14, #32); // chave

  (* 6. Zeros - Tam 21 Numerico - Campo obrigatorio - Preencher com zeros. *)
  sLinha := sLinha + StringOfChar( '0', 21);

  (* 7. COMPENSACAO - VALOR - Tam 15 Valor
     Para informacoes de valores recolhidos indevidamente ou a maior em
     competencias anteriores e que a empresa deseja compensar na atual
     Guia de Recolhimento da Previdencia Social.
     # Campo opcional
     # So deve ser informado para os codigos de recolhimento 130, 150, 155,
       317, 337, 608, 907, 908, 909 e 910.
     # Nao deve ser informado para o codigo de recolhimento 911.
     # Nao deve ser informado para a competencia 13.
     # So deve ser informado se o Indicador de Recolhimento da Previdencia Social
       (campo 20 do registro 00) for igual a 1 (GPS no prazo).
     # Sempre que nao informado, preencher com zeros. *)
  if (HA_COMPETENCIA_MES = 13) or (HA_CODIGO_RECOLHIMENTO = 911) then
    H21_v07 := 0
  else if HA_INDICADOR_RECOLHIMENTO_PS <> 1 then
    H21_v07 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      130, 150, 155, 317, 337, 608, 907..910:
    else
      H21_v07 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H21_v07*100), 15);

  (* 8. COMPENSACAO - PERIODO INICIO - Tam 6 Data - Formato AAAAMM
     Para informacao AAAAMMM de inicio das competencias recolhidas indevidamente ou a maior.
     # So deve ser informado ser o campo COMPENSACAO - VALOR for diferente de zero.
     # Sempre que nao informado, preencher com zeros. *)

  if (H21_v07 = 0) or ( Length(H21_d08) <> 6) then
    H21_d08 := Espaco(6);

  sLinha := sLinha + H21_d08;

  (* 9. Compensacao - Periodo Fim - Tam 6 Data - Formato AAAAMM.
     Para informacao AAAAMM fim das competencias recolhidas indevidamente ou a maior.
     # So deve ser informado se o campo Compensacao - Valor for diferente de zero.
     # Periodo Fim deve ser maior ou igual ao Periodo Inicio e menor que o mes de competencia.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if ( Length(Trim(H21_d08)) <> 6) or ( Length(Trim(H21_d09)) <> 6) then
    H21_d09 := Espaco(6);

  sLinha := sLinha + H21_d09;

  (* 10. Recolhimento de Competencias Anteriores - Valor do INSS
         sobre Folha de Pagamento - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecacao menor que R$ 25,00. Neste campo informar o
    total do campo 6 da GPS.
    # campo opcional.
    # Acatar apenas para os codigos de recolhimento 130, 150, 155, 317,
      337, 608, 907, 908, 909 e 910.
    # Nao acatar para o codigo de recolhimento 911.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if (HA_INDICADOR_RECOLHIMENTO_FGTS <> '1') or (HA_CODIGO_RECOLHIMENTO = 911) then
    H21_v10 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      130, 150, 155, 317, 337, 608, 907, 908, 909, 910:
      else
        H21_v10 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H21_v10*100), 15);

  (* 11. Recolhimento de Competencias Anteriores - Outras entidades
         sobre Folha de Pagamento - Tam 15 valor
    Para informacao de valores de compentencias anteriores nao recolhidas por
    possuirem valor de arrecacao menor que R$ 25,00. Neste campo informar o
    total do campo 9 da GPS.
    # campo opcional.
    # Acatar apenas para os codigos de recolhimento 130, 150, 155, 317,
      337, 608, 907, 908, 909 e 910.
    # Nao acatar para o codigo de recolhimento 911.
    # So deve ser informado se Indicador de Recolhimento da Previdencia Social
      (campo 20 do registro 00) for igual a 1 (GPS no prazo).
    # Sempre que nao informado, preencher com zeros. *)

  if (HA_INDICADOR_RECOLHIMENTO_FGTS <> '1') or (HA_CODIGO_RECOLHIMENTO = 911) then
    H21_v11 := 0
  else
    case HA_CODIGO_RECOLHIMENTO of
      130, 150, 155, 317, 337, 608, 907, 908, 909, 910:
      else
        H21_v11 := 0;
    end;

  sLinha := sLinha + kStrZero( Trunc(H21_v11*100), 15);

  (* 12. Parcelamento do FGTS - Tam 15 numerico
     Somatorio Remuneracoes das Categorias 01,02,03 e 05
     Informar o valor total das remuneracoes das categorias 01, 02, 03 e 05.
     # Para implementacao futura.
     # Campo obrigatorio para os codigos de recolhimento 317 e 337, quando
       modalidade de parcelamento for 2 ou 3.
     # Ate autorizacao da CAIXA, preencher com zeros. *)
  sLinha := sLinha + kStrZero( Trunc(H21_v12*100), 15);

  (* 13. Parcelamento do FGTS - Tam 15 numerico
     Somatorio Remuneracoes das Categorias 04.
     Informar o valor total das remuneracoes das categorias 04.
     # Para implementacao futura.
     # Campo obrigatorio para os codigos de recolhimento 317 e 337, quando
       modalidade de parcelamento for 2 ou 3.
     # Ate autorizacao da CAIXA, preencher com zeros. *)
  sLinha := sLinha + kStrZero( Trunc(H21_v13*100), 15);

  (* 14. Parcelamento do FGTS - Tam 15 numerico
     Valor recolhido
     Informar o valor total recolhido ao FGTS (Deposito+JAM+Multa)
     # Para implementacao futura.
     # Campo obrigatorio para os codigos de recolhimento 317 e 337, quando
       modalidade de parcelamento for 2 ou 3.
     # Ate autorizacao da CAIXA, preencher com zeros. *)
  sLinha := sLinha + kStrZero( Trunc(H21_v14*100), 15);

  (* 15+. Brancos - Tam 204 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(204);

  (* 16+. Final de Linha - Tam 1 AN - Constante "*" *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;  // function Registro21

// ================================ REGISTRO 30 ====================

function Registro30:String;
const
  CABECALHO = 'Erro no registro Tipo "30" - Registro de Trabalhador';
var
  sLinha: String;
begin

  Result := '';

  (* ACATAR CATEGORIA 17 APENAS PARA CODIGO DE RECOLHIMENTO 911 *)

  if (HT_CATEGORIA = 17) and ( HA_CODIGO_RECOLHIMENTO <> 911) then
    Exit;
    
  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 30 - chave *)
  sLinha := '30';

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido *)
   sLinha := sLinha + PadLeftChar( HE_INSCRICAO, 14, #32); // chave

  (* 4+. TIPO DE INSCRICAO - TOMADOR/OBRA DE CONST. CIVIL
      Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI)
     # Obrigatorio para os codigos de recolhimento 130, 150, 155, 317,
       337, 608, 907 e 908
     # Sempre que nao informado, campo deve ficar em branco *)

  case HA_CODIGO_RECOLHIMENTO of
    130, 150, 155, 317, 337, 608, 907, 908:
      if Pos( H_TOMADOR_TIPO, '_1_2_') = 0 then begin
        kErro( CABECALHO+#13#13+
                 'O TIPO DE INSCRIÇÃO DO TOMADOR e obrigatorio para os'#13+
                 'codigos de recolhimento 130,150,155,317,337,608,907 e 908');
        Exit;
      end;
  end;  // case of

  if Pos( H_TOMADOR_TIPO, '_1_2_') = 0 then
    H_TOMADOR_TIPO := #32;

  sLinha := sLinha + H_TOMADOR_TIPO;  // chave

  (* 5+. INSCRICAO DO TOMADOR - Tam 14 Numerico - CNPJ ou CEI valido
     # Obrigatorio para os codigos de recolhimento 130, 150, 155, 317,
       337, 608, 907 e 908
     # Sempre que nao informado, campo deve ficar em branco *)
   sLinha := sLinha + PadLeftChar( H_TOMADOR_INSCRICAO, 14, #32); // chave

  (* 6+. PIS/PASEP/CI - Tam 11 Numerico - Campo obrigatorio e valido *)
  sLinha := sLinha + PadLeftChar( HT_PIS, 11, #32);

  (* 7. Data de Admissao - Tam 8 data - chave
     # Formato DDMMAAAA
     # Obrigatorio para as categorias de trabalhadores 01, 03, 04, 05, 11 e 12
       e deve conter uma data valida.
     # Nao deve ser informado para as demais categorias.
     # Deve ser menor ou igual a competencia informada.
     # deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04, 05, 11, 12:
      begin
        if HT_ADMISSAO = 0 then begin
          kErro( CABECALHO+#13#13+
                  'A ADMISSAO e obrigatoria para as categorias de trabalhador'#13+
                  '01, 03, 04, 05, 11 e 12');
          Exit;
        end;
        if (HT_CATEGORIA = 04) and
           (HT_ADMISSAO < EncodeDate( 1998, 1, 22)) then begin
          kErro(CABECALHO+#13#13+
                  'A ADMISSAO para a categoria 04 deve ser maior ou igual a 22/01/1998');
          Exit;
        end;
      end
    else
      HT_ADMISSAO := 0;
  end;  // case

  if HT_ADMISSAO = 0 then
    sLinha := sLinha + Espaco(8)
  else
    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HT_ADMISSAO);

  (* 8+. CATEGORIA TRABALHADOR * - Tam 2 Numerico - Campo obrigatorio
     ( Codigo deve estar contido na tabela categoria do trabalhador ) *)

  case HT_CATEGORIA of
    01..05, 11..17:
    else begin
      kErro( CABECALHO + #13#13+
              'A CATEGORIA DO TRABALHO e obrigatoria e deve ser'+#13+
              '01, 02, 03, 04, 05, 11, 12, 13, 14, 15, 16 ou 17.');
      Exit;
    end;
  end;

  sLinha := sLinha + kStrZero( HT_CATEGORIA, 2);

  (* 9+. NOME DO TRABALHADOR - Tam 70 Alfanumerico - Campo obrigatorio
     # Nao pode conter numero, caracteres especiais, acento, mais de um
       espaco entre os nomes, mais de duas letras iguais consecutivas e a
       primeira posicao nao pode ser branco.
     # Pode conter apenas caracteres de A a Z.*)
  sLinha := sLinha + PadRightChar( HT_NOME, 70, #32);

  (* 10. MATRICULA DO EMPREGADO - Tam 11 Numerico
     # Numero de matricula atribuido pela empresa ao trabalhador, quando houver.
     # Campo nao deve ser informado para as categorias 13, 14, 15, 16 e 17.
     # Sempre que nao informado, campo deve ficar em branco. *)
  case HT_CATEGORIA of
    13..17: HT_MATRICULA := '';
  end;

  sLinha := sLinha + PadLeftChar( HT_MATRICULA, 11, '0');

  (* 11. NUMERO CTPS - Tam 7 Numerico
     # Obrigatorio para as categorias de trabalhadores 01, 03 e 04.
     # Opcional a categoria de trabalhador 02.
     # Nao deve ser informado para as demais categorias.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04:
      if Length(HT_CTPS) = 0 then begin
        kErro( CABECALHO + #13#13+
                'O Número CTPS é obrigatório para as categoria 01, 03 e 04.');
        Exit;
      end;
    02:
    else
      HT_CTPS := '';
  end;

  sLinha := sLinha + PadLeftChar( Trim(HT_CTPS), 7, '0');

  (* 11. NUMERO CTPS - Tam 7 Numerico
     # Obrigatorio para as categorias de trabalhadores 01, 03 e 04.
     # Opcional a categoria de trabalhador 02.
     # Nao deve ser informado para as demais categorias.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04:
      if Length(HT_SERIE) = 0 then begin
        kErro( CABECALHO +#13#13+
                'O Número de Série CTPS é obrigatório para as categoria 01, 03 e 04.');
        Exit;
      end;
    02:
    else
      HT_SERIE := '';
  end;

  sLinha := sLinha + PadLeftChar( Trim(HT_SERIE), 5, '0');

  (* 13. DATA DE OPCAO - Tam 8 data
     ( Indicar a data em que o trabalhador optou pelo FGTS )
     # Formato DDMMAAAA
     # Obrigatorio para as categorias de trabalhadores 01, 03, 04 e 05
       e deve conter uma data valida.
     # Nao deve ser informado para as demais categorias.
     # Deve ser maior ou igual a data de admissao.
     # Deve ser maior ou igual a data de admissao e limitada a 05/10/1988 quando
       a data de admissao for menor que 05/10/1988.
     # Deve ser igual a admissao quando a admissao for maior ou igual a 05/10/1988.
     # Deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04.
     # Deve ser maior ou igual a data de admissao, para a categoria de trabalhador 05.
     # Nao deve ser informada para o codigo de recolhimento 640.
     # Nao deve ser menor uqe 01/01/1967.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if HA_CODIGO_RECOLHIMENTO = 640 then
    HT_OPCAO := 0
  else
    case HT_CATEGORIA of
      01..05:
        begin
          if HT_OPCAO = 0 then begin
            kErro( CABECALHO + #13#13+
                    'A OPCÃO é obrigatória para as categorias 01, 03, 04 e 05');
            Exit;
          end;
          if HT_OPCAO < HT_ADMISSAO then begin
            kErro( CABECALHO +#13#13+
                    'A DATA DE OPCAO deve ser maior ou igual a ADMISSAO.');
            Exit;
          end;
          if ( HT_ADMISSAO < EncodeDate( 1988, 10, 5) ) and
             ( HT_OPCAO > EncodeDate( 1988, 10, 5) ) then begin
            kErro( CABECALHO + #13#13+
                    'A DATA DE OPCAO deve ser maior ou igual a 05/10/1988'+#13+
                    'a ADMISSAO for menor que 05/10/1988.');
            Exit;
          end;
          if ( HT_ADMISSAO >= EncodeDate( 1988, 10, 5) ) and
             ( HT_OPCAO <> HT_ADMISSAO) then begin
            kErro( CABECALHO + #13#13+
                    'A DATA DE OPCAO deve ser igual a ADMISSAO quando'+#13+
                    'a DATA DE ADMISSAO for maior ou igual a 05/10/1988.');
            Exit;
          end;
          if (HT_CATEGORIA = 04) and ( HT_OPCAO < EncodeDate( 1998, 01, 22) ) then begin
            kErro( CABECALHO + #13#13+
                    'A DATA DE OPCAO deve ser maior ou igual a 22/01/1998 quando'+#13+
                    'a categoria de trabalhador for 04.');
            Exit;
          end;
          if HT_OPCAO < EncodeDate( 1967, 01, 01) then begin
            kErro( CABECALHO + #13#13+
                    'A DATA DE OPCAO nao deve ser menor que 01/01/1967.');
            Exit;
          end;
        end
      else
        HT_OPCAO := 0;
    end;  // case

  if HT_OPCAO = 0 then
    sLinha := sLinha + Espaco(8)
  else
    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HT_OPCAO);

  (* 14. DATA DE NASCIMENTO - Tam 8 data
     # Formato DDMMAAAA
     # Obrigatorio para as categorias de trabalhadores 01, 03, 04, 05 e 12
       e deve conter uma data valida.
     # Nao deve ser informado para as demais categorias.
     # Deve ser menor que a data de admissao.
     # Deve ser maior ou igual a 01/01/1900.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01..05, 12:
      begin
        if HT_NASCIMENTO = 0 then begin
          kErro( CABECALHO + #13#13+
                  'A DATA DE NASCIMENTO é obrigatória para as categorias'+#13+
                  '01, 03, 04, 05 e 12.');
          Exit;
        end;
        if HT_NASCIMENTO >= HT_ADMISSAO then begin
          kErro( CABECALHO + #13#13+
                  'A DATA DE NASCIMENTO deve ser menor que a ADMISSAO.');
          Exit;
        end;
        if ( HT_NASCIMENTO < EncodeDate( 1900, 1, 1) ) then begin
          kErro( CABECALHO + #13#13+
                  'A DATA DE NASCIMENTO deve ser maior ou igual a 01/01/1900.');
          Exit;
        end;
      end
    else
      HT_NASCIMENTO := 0;
  end;  // case

  if HT_NASCIMENTO = 0 then
    sLinha := sLinha + Espaco(8)
  else
    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HT_NASCIMENTO);

  (* 15+. CBO - CODIGO BRASILEIRO DE OCUPACAO Tam 5 AN - Campo obrigatorio
     # Codigo deve estar contido na tabela CBO. *)
  if Length( HT_CBO) <> 5 then begin
    kErro( CABECALHO + #13#13+
            'O CBO é obrigatório e deve estar contido na tabela CBO.');
    Exit;
  end;

  sLinha := sLinha + PadRightChar( HT_CBO, 5, #32);

  (* 16. Remuneracao sem 13 - Tam 15 Valor
     ( Destinado a informacao da remuneracao paga, devida ou creditada ao
       tabalhador no mes, conforme base de incidencia. Excluir o valor da
       remuneracao o 13 salario pago no mes).
     # Campo obrigatorio para as categorias 05, 11, 13, 14, 15, 16 e 17.
     # Opcional para as categorias 01, 02, 03, 04 e 12.
     # As remuneracoes pagas apos rescisao de contrato de trabalho e conforme
       determinacao do Art. 466 da CLT, nao devem vir acompanhada das rspectivas
       movimentacoes.
     # Se informado deve ter 2 casas decimais validas.
     # Nao deve ser informado para a competencia 13.
     # Sempre que nao informado, preecher com zeros. *)
  if HA_COMPETENCIA_MES = 13 then
    HT_SEM13 := 0
  else
    case HT_CATEGORIA of
      05, 11, 13..17:
        if HT_SEM13 = 0 then begin
          kErro( CABECALHO + #13#13+
                  'A REMUNERACAO SEM 13 é obrigatoria para as categorias de'+#13+
                  'trabalhador 05, 11, 13, 14, 15, 16 e 17.');
          Exit;
        end;
    end;

  sLinha := sLinha + kStrZero( Trunc(HT_SEM13*100), 15);

  (* 17. Remuneracao sobre 13 - Tam 15 Valor
     ( Destinado a informacao da parcela de 13 salario pago no mes ao trab.)
     # Campo obrigatorio para a categoria 02.
     # Nao deve ser informado para a competencia 13.
     # So deve ser informado para as categorias 01, 02 03, 04 e 12.
     # Sempre que nao informado, preecher com zeros. *)
  if HA_COMPETENCIA_MES = 13 then
    HT_SOBRE13 := 0
  else if (HT_CATEGORIA = 02) and (HT_SOBRE13 = 0) then begin
    kErro( CABECALHO + #13#13+
            'A REMUNERACAO SOBRE 13o. é obrigatoria para a categoria 02.');
    Exit;
  end;

  case HT_CATEGORIA of
    01, 02, 03, 04, 12:
    else HT_SOBRE13 := 0;
  end;

  sLinha := sLinha + kStrZero( Trunc(HT_SOBRE13*100), 15);

  (* 18. CLASSE DE CONTRIBUICAO - Tam 2 Numerico
    ( Indicar a classe de contribuicao do autonomo, quando a empresa opta
      por contribuir sobre seu salario-base e os classifica como categoria 14
      ou 16. A classe deve estar compreendida em tabela fornecida pelo INSS).
    # Campo obrigatorio para as categorias 14 e 16 (apenas em recolhimentos
      de competencias anteriores a 03/2000.
    # Nao deve ser informado para as demais categorias
    # Nao deve ser informado para a campetencia 13.
    # Sempre que nao informado, campo deve ficar em branco. *)

  if HA_COMPETENCIA_MES = 13 then
    HT_CLASSE := ''
  else if (HT_CATEGORIA = 14) or (HT_CATEGORIA = 16) then begin
    if (HA_COMPETENCIA_ANO < 2000) or ( (HA_COMPETENCIA_ANO = 2000) and
                                        (HA_COMPETENCIA_MES < 3) ) then
      if Length(HT_CLASSE) = 0 then begin
        kErro( CABECALHO + #13#13+
                'A CLASSE DE CONTRIBUICAO é obrigatória para as categoria'+#13+
                '14 e 16 para competências anteriores a 03/2000.');
        Exit;
      end;
  end else
    HT_CLASSE := '';

  if Length(HT_CLASSE) = 0 then
    sLinha := sLinha + Espaco(2)
  else
    sLinha := sLinha + PadLeftChar( HT_CLASSE, 2, '0');

  (* 19. OCORRENCIA - Tam 2 Numerico
     ( Destinado a informacao de exposicao do trabalhador a agente nocivo e/ou
       para indicacao de multiplicidade de vinculo para um mesmo trabalhador.)
     # Campo opcional para as categorias 01, 03, 04 e 12.
     # Deve ficar em branco se trabalhador nao esteve exposto a agente novivo
       e nao possui mais de um vinculo empregaticio.
     # Nao deve ser informado para as demais categorias.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04, 12:
    else HT_OCORRENCIA := '';
  end;

  if Length(HT_OCORRENCIA) = 0 then
    HT_OCORRENCIA := Espaco(2);

  if ( Length( HT_OCORRENCIA) <> 2) or
     ( Pos( HT_OCORRENCIA, '_  _01_02_03_04_') = 0 ) then begin
    kErro( CABECALHO + #13#13+
            'A OCORRENCIA só poderá ser 01, 02, 03, 04 ou branco.');
    Exit;
  end;

  sLinha := sLinha + HT_OCORRENCIA;

  (* 20. VALOR RETIDO SEGURADO - Tam 15 Valor
     ( Destino a informacao do valor da contribuicao do trabalhador que possuir
      mais de um vinculo empregaticio; ou quando tratar-se de recolhimento de
      trabalhador avulso, dissidio coletivo ou reclamatoria trabalhista, ou, ainda
      nos meses de afastamento e retorno de licenca maternidade com inicio a
      partir de 01/12/1999. O valor informado sera considerado como contribuicao do
      segurado).
     # Campo opcional para as ocorrencias 05, 06, 07 e 08.
     # Campo opcional para a categoria de trabalhador 02.
     # Campo opcional para os codigos de recolhimento 130, 650, 904 e 909.
     # Campo opcional para competencias maior ou igual a 12/1999 nos meses de
       afastamento e retorno por motivo de licenca-maternidade iniciada a partir
       de 01/12/1999.
     # Sempre que nao informado, preencher com zeros. *)

  sLinha := sLinha + kStrZero( Trunc(HT_RETIDO*100), 15);

  (* 21. Remuneracao base de calculo da contribuicao previdencia - Tam 15 Numerico
     (Destinado a informacao da parcela de remuneracao sobre a qual incide a
      contribuicao previdenciaria, quando o trabalhador estiver afastado por
      motivo de acidente de trabalho e/ou prestacao de servico militar obrigatorio).
     # Campo obrigatorio para as movimentacoes (Registro 32) por
       O1, O2, R, Z2, Z3 e Z4.
     # pode ser informado apenas para as categorias 01 e 04.
     # Nao pode ser informado para a competencia 13.
     # Sempre que nao informado, preencher com zeros. *)

  if (HA_COMPETENCIA_MES = 13) or ( not (HT_CATEGORIA in [01,04]) ) then
    HT_BASE := 0;

  sLinha := sLinha + kStrZero( Trunc(HT_BASE*100), 15);

  (* 22. Base de calculo 13 salario Previdencial Social - Tam 15 Valor
     ( Indicar o valor total do 13 salario pago no ano ao trabalhador. Sobre o
       valor informado incide contribuicao previdenciaria.
       Na competencia 12 - indicar eventuais diferencas de gratificacao natalina
       de empregados que recebem remuneracao variavel - Art. 216, Paragrafo 25,
       Decreto 3.265 de 29.11.1999 ).
     # Obrigatorio para a competencia 13.
     # Obrigatorio para quem trabalhou mais de 15 dias no ano e possui codigo
       de movimentacao por motivo de rescisao (exceto rescisao com justa causa),
       aposentaria com quebra de vinculo ou falecimento.
     # Obrigatorio para os codigos de recolhimento 130 e 909.
     # Obrigatorio para os codigos de recolhimento 608 e 910, quando houver
       trabalhador da categoria 02 no arquivo.
     # so deve ser informado para as categorias 01, 02, 04 e 12.
     # Sempre que nao informado, preencher com zeros. *)

  if (HA_COMPETENCIA_MES = 13) and (HT_BASE13 <= 0) then begin
    kErro( CABECALHO + #13#13+
            'A BASE DE CALCULO 13o. SALARIO PREV SOC é obrigatório+'#13+
            'para a competência 13.');
    Exit;
  end;

  if ( Pos( IntToStr(HA_CODIGO_RECOLHIMENTO), '_130_909_') > 0 ) and (HT_BASE13 <= 0) then begin
    kErro( CABECALHO + #13#13+
            'A BASE DE CALCULO 13o. SALARIO PREV SOC é obrigatório+'#13+
            'para os códigos de recolhimentos 130 e 909.');
    Exit;
  end;

  case HT_CATEGORIA of
    01, 02, 04, 12:
    else HT_BASE13 := 0;
  end;  // case

  sLinha := sLinha + kStrZero( Trunc(HT_BASE13*100), 15);

 (* 23. Remuneracao 13o. salario Prev. Social - Base de calculo para a
    competencia 13. - Tam 15 numerico
    (deve se utilizado apenas na competencia 12, quando a remuneracao informada
     para calculo das contribuicoes previdenciarias da competencia 13 estiver
     sendo complementada. Informar a remuneracao apurada ate 20/12, sobre o
     qual ja houve recolhimento em GPS, para o correto enquadramento na tabela
     de faixas de salario-de-contribuicao.).
    # Opcional para a competencia 12.
    # Nao deve ser informado nas demais competencias.
    # so deve ser informado para as categorias 01, 02, 04 e 12.
    # Se informado, o campo 22 (registro 30) deve ser diferente de zeros.
    # Sempre  que nao informado, preencher com zeros. *)

   if HA_COMPETENCIA_MES = 12 then begin
     case HT_CATEGORIA of
       01, 02, 04, 12:
         if (HT_REM13 > 0) and (HT_BASE13 = 0) then begin
           kErro( CABECALHO + #13#13+
                   'Quando a (23) REMUN. 13o. SALARIO PREV SOC for informada'+#13+
                   'é obrigatório o campo (22) BASE DE CALCULO 13 PREV. SOCIAL');
           Exit;
         end;
       else
         HT_REM13 := 0;
     end;
   end else
     HT_REM13 := 0;

   sLinha := sLinha + kStrZero( Trunc(HT_REM13*100), 15);

  (* 24+. Brancos - Tam 98 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(98);

  (* 25+. Final de Linha - Tam 1 AN - Constante "*" *)
  sLinha := sLinha + FIM_LINHA;

  // +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  Result := sLinha;

end;  // function Registro30 - Trabalhador

// ============== REGISTRO 32 ======================== //

function Registro32:String;
const
  CABECALHO = 'Erro no registro Tipo "32" - Movimentacao do Trabalhador';
  TIPO_REGISTRO = '32';
var
  sLinha, sTemp: String;
begin

  Result := '';

(* ===================================================================
   Permitido para as categorias de trabalhador 01, 02, 03, 04, 05, 11 e 12
   Nao acatar para competencia 13.
   Nao acatar para os codigos de recolhimento 145 e 345.
   =================================================================== *)

  if (HA_COMPETENCIA_MES = 13) or
     (HA_CODIGO_RECOLHIMENTO = 145) or (HA_CODIGO_RECOLHIMENTO = 345) then
    Exit;

  (* 1. TIPO DE REGISTRO - Tam 2 Numerico - Sempre 32 - chave *)
  sLinha := TIPO_REGISTRO;

  (* 2+. TIPO DE INSCRICAO - EMPRESA - Tam 1 Numerico -  So podera ser 1 (CNPJ) ou 2 (CEI) *)
  sLinha := sLinha + HE_TIPO_INSCRICAO;  // chave

  (* 3+. INSCRICAO DA EMPRESA - Tam 14 Numerico - CNPJ ou CEI valido
     # A inscricao esperada deve ser igual a do registro 10 imediatamente anterior *)
   sLinha := sLinha + HE_INSCRICAO; // chave

  (* 4+. TIPO DE INSCRICAO - TOMADOR/OBRA DE CONST. CIVIL
      Tam 1 Numerico -  Chave - So podera ser 1 (CNPJ) ou 2 (CEI)
      # Para os codigos de recolhimento 130, 150, 155, 317, 337,
        608, 907, 908, 909 e 910 tipo informado so podera ser 1 ou 2
      # Para os demais codigos de recolhimento, campo deve ficar em branco  *)

  sTemp := H_TOMADOR_TIPO;

  case HA_CODIGO_RECOLHIMENTO of
    130, 150, 155, 317, 337, 608, 907..910:
       if Pos( sTemp, '_1_2_') = 0 then begin
         kErro( CABECALHO+#13#13+
                  'O TIPO DE INSCRIÇÃO DO TOMADOR é obrigatório.');
         Exit;
       end;
    else
       sTemp := '';
  end;

  sLinha := sLinha + PadLeftChar( sTemp, 1, #32);

  (* 5. INSCRICAO DO TOMADOR - Tam 14 Numerico - CNPJ ou CEI valido
     Destinado a informacao da inscricao da empresa tomadora de servico
     nos recolhimentos de trabalhadores avulsos, prestacao de servicos,
     obras de construcao civil e dirigente sindical.
     # Campo obrigatorio *)

   if Length( Trim(sTemp)) = 0 then
     sLinha := sLinha + Espaco(14)
   else
     sLinha := sLinha +  PadLeftChar( H_TOMADOR_INSCRICAO, 14, #32); // chave

  (* 6+. PIS/PASEP/CI - Tam 11 Numerico - Campo obrigatorio e valido *)
  sLinha := sLinha + PadLeftChar( HT_PIS, 11, #32);

  (* 7. Data de Admissao - Tam 8 data
     # Formato DDMMAAAA
     # Obrigatorio para as categorias de trabalhadores 01, 03, 04, 05, 11 e 12
       e deve conter uma data valida.
     # Nao deve ser informado para a categoria 02.
     # Deve ser menor ou igual a competencia informada.
     # deve ser maior ou igual a 22/01/1998 para a categoria de trabalhador 04.
     # Sempre que nao informado, campo deve ficar em branco. *)

  case HT_CATEGORIA of
    01, 03, 04, 05:
      begin
        if HT_ADMISSAO = 0 then begin
          kErro( CABECALHO +#13#13+
                  'A ADMISSAO e obrigatoria para as categorias de trabalhador'#13+
                  '01, 03, 04 e 05.');
          Exit;
        end;
        if (HT_CATEGORIA = 04) and
           (HT_ADMISSAO < EncodeDate( 1998, 1, 22)) then begin
          kErro( CABECALHO +#13#13+
                  'A ADMISSAO para a categoria 04 deve ser maior ou igual a 22/01/1998');
          Exit;
        end;
      end;
    02:
      HT_ADMISSAO := 0;
  end;  // case

  if HT_ADMISSAO = 0 then
    sLinha := sLinha + Espaco(8)
  else
    sLinha := sLinha + FormatDateTime( FORMATO_DATA, HT_ADMISSAO);

  (* 8+. CATEGORIA TRABALHADOR * - Tam 2 Numerico - Campo obrigatorio
     Codigo deve estar contido na tabela categoria do trabalhador *)

  sLinha := sLinha + kStrZero( HT_CATEGORIA, 2);

  (* 9. NOME DO TRABALHADOR - Tam 70 Alfanumerico - Campo obrigatorio
     # Nao pode conter numero, caracteres especiais, acento, mais de um
       espaco entre os nomes, mais de duas letras iguais consecutivas e a
       primeira posicao nao pode ser branco.
     # Pode conter apenas caracteres de A a Z.*)

  sLinha := sLinha + HT_NOME;

  (* 10. CODIGO DE MOVIMENTACAO - Tam 2 AN - Campo obrigatorio
     # Deve ser informado apenas para as categorias de trabalhador 01, 02,
       03, 04, 05, 11 e 12.
     # Nao deve ser informada mais de uma movimentacao definitiva por trabalhador.
     # Deve ser informado o codigo e a data de afastamento sempre que houver a
       informacao de uma movimentacao de retorno.
     # Nao devem ser informadas movimentacoes por Q1, Q2, Q3 e Z1, nos codigos
       de recolhimento 150, 155, 317, 337, 907 e 908, exceto quando o CNPJ da
       empresa for igual ao CNPJ do tomador.
     # Devem ser informadas as movimentacoes definitivas H, I, J, K e L em todos
       os tomadores (codigos de recolhimento 150, 155, 317, 337, 907 e 908) em
       que o trabalhador estiver alocado, quando ocorrer a movimentacao. *)
  sLinha := sLinha + H32_t10;

  (* 11. DATA DE MOVIMENTACAO - Tam 8 Data - Formato DDMMAAAA - Campo obrigatorio
     # Deve ser uma data valida, considerando como data de afastamento o dia
       imediatamente anterior ao efetivo afastamento e como data de retorno o
       ultimo dia do afastamento.
     # Deve ser maior que a data de admissao.
     # Deve estar compreendida no mes anterior ou no mes da competencia, para
       os codigos de movimentacao H, J, K, M, N, S, U1 e U2.
     # Deve estar compreendida no mes da competencia, se o
       os codigos de movimentacao for Z1, Z2, Z3, Z4 e Z5.
     # Deve estar compreendida no mes anterior, no mes da competencia ou no mes
       posterior (se o recolhimento do FGTS ja tiver sido efetuado) e o codigo
       de movimentacao for I ou L.
     # Deve ser menor ou igual ao mes de competencia, para codigos de movimentacao
       O1, O2, P1, P2, Q1, Q2, Q3, R, U3, W, X e Y.
     # Deve ser informada para os codigos de movimentacao O1, O2, Q1, Q2, Q3 e R,
       mensalmente, ate que se de o efetivo retorno. *)
  sLinha := sLinha + H32_d11;

  (* 12. INDICATIVO RECOLHIMENTO FGTS - Tam 1 AN
     Indica se o empregador ja efetuou arrecadacao FGTS em Guia de Recolhimento
     Rescisorio - GRFP para trabalhadores com movimentacao codigo I ou L. Se
     indicativo for igual a "S" o valor da remuneracao sera considerado apenas para
     calculo da contribuicao previdenciaria e o trabalhador nao sera incluido na RE.
     # Caracteres possiveis: "S" ou "s", "N" ou "n" e "Branco".
     # So deve ser informado para competencia maior que JAN/1998.
     # Obrigatorio para codigos de movimentacao I ou L.
     # Nao deve ser informado para os demais codigos de movimentacao.
     # Deve ser informado o indicativo "S" apenas para as categorias 01, 03 e 04.
     # Nao deve ser informado para a competencia 13.
     # Sempre que nao informado, campo deve ficar em branco. *)

  if (HA_COMPETENCIA_ANO < 1998) or
     ( (HA_COMPETENCIA_ANO = 1998) and (HA_COMPETENCIA_MES < 2) ) then
    H32_t12 := ''
  else if HA_COMPETENCIA_MES = 13 then
    H32_t12 := ''
  else if not (H32_t10[1] in ['I','L']) then
    H32_t12 := ''
  else if Length(Trim(H32_t12)) = 0 then
    begin
      kErro( CABECALHO + #13#13+
               'O campo 12 - INDICATIVO RECOLHIMENTO FGTS - é obrigatório'+#13+
               'para os codigos de movimentacao "I" ou "L"');
      Exit;
    end;

  if (H32_t12 = 'S') and ( not (HT_CATEGORIA in [1, 3, 4]) ) then begin
    kErro( CABECALHO + #13#13 +
             'O campo 12 - INDICATIVO RECOLHIMENTO FGTS - só poderá'+#13+
             'ser "S" se a categoria do trabalhador for 01, 03, 04.');
    Exit;
  end;

  sLinha := sLinha + PadLeftChar( H32_t12, 1, #32);

  (* 13. Brancos - Tam 225 AN - Preencher com brancos *)
  sLinha := sLinha + Espaco(225);

  (* 14. Final de linha - Tam 1 AN - Deve uma constante "*" para marcar fim de linha *)
  sLinha := sLinha + FIM_LINHA;

  // **********************************************

  Result := sLinha;

end;  // function Registro32

function Trailler_arquivo:String;
var
  sLinha: String;
begin

  Result := '';

  (* 1. tipo de registro - Tam 2 Numerico - Sempre '90' *)
  sLinha := '90';

  (* 2. Marca de final de registro - Tam 51 AN - Preencher com 9 *)
  sLinha := sLinha + StringOfChar( '9', 51);

  (* 3. Brancos - Tam 306 AN - Preencher com brancos *)
  sLinha := sLinha + StringOfChar( #32, 306);

  (* 4. Final de linha - Tam 1 AN - Deve uma constante "*" para marcar fim de linha *)
  sLinha := sLinha + FIM_LINHA;

  // **********************************************

  Result := sLinha;

end;  // function Trailler_arquivo

procedure GeraArquivoSEFIP( Reg00, Reg10, Reg12, Reg13, Reg14,
                           Reg20, Reg21, Reg30, Reg32, Reg40,
                           Reg50, Reg51: TStringList );
var
  Arquivo: TextFile;
  i: Integer;
  sTemp: String;
begin

  sTemp := ExtractFilePath( ParamStr(0))+'SEFIP.RE';

  AssignFile( Arquivo, sTemp );

  try

    Rewrite(Arquivo);

    for i := 0 to Reg00.Count - 1 do
      WriteLn( Arquivo, Reg00.Strings[i]);

    for i := 0 to Reg10.Count - 1 do
      WriteLn( Arquivo, Reg10.Strings[i]);

    for i := 0 to Reg12.Count - 1 do
      WriteLn( Arquivo, Reg12.Strings[i]);

    for i := 0 to Reg13.Count - 1 do
      WriteLn( Arquivo, Reg13.Strings[i]);

    for i := 0 to Reg14.Count - 1 do
      WriteLn( Arquivo, Reg14.Strings[i]);

    for i := 0 to Reg20.Count - 1 do
      WriteLn( Arquivo, Reg20.Strings[i]);

    for i := 0 to Reg21.Count - 1 do
      WriteLn( Arquivo, Reg21.Strings[i]);

    for i := 0 to Reg30.Count - 1 do
      WriteLn( Arquivo, Reg30.Strings[i]);

    for i := 0 to Reg32.Count - 1 do
      WriteLn( Arquivo, Reg32.Strings[i]);

    for i := 0 to Reg40.Count - 1 do
      WriteLn( Arquivo, Reg40.Strings[i]);

    for i := 0 to Reg50.Count - 1 do
      WriteLn( Arquivo, Reg50.Strings[i]);

    for i := 0 to Reg51.Count - 1 do
      WriteLn( Arquivo, Reg51.Strings[i]);

    sTemp := Trailler_Arquivo;

    WriteLn( Arquivo, sTemp);

  finally
    CloseFile( Arquivo);
  end;  // try

end;

end.
