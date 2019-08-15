{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2007 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

Visite o web site do Projeto FolhaLivre em
http://sourceforge.net/project/folha-livre/

Contate o autor enviando uma mensagem para
allan_kardek@yahoo.com.br

--------------------------
Historico das modificacoes
--------------------------

* 11/01/2007 - Primeira versao

}

unit cnab240;

interface

uses SysUtils, Classes, Math;

  type

    TDensidade = (cd1600, cd6250); {BPI - Bloco por Polegada }
    TCamara = (ccTED,ccDOC);
    TRemessa = (crRemessa, crRetorno);
    TSituacaoFuncional = (sfAtivo, stPensaoAtivo,
                          sfAposentado, sfPensaoAposentado,
                          sfPensionista, sfPensaoPensionista);

    TEndereco = record
      Logradouro: String;
      Numero: String;
      Complemento: String;
      Cidade: String;
      UF: String;
      CEP: String;
    end;

    TCNAB240 = class
    private
      FAgencia: String; // Agencia Bancária
      FBanco: String;
      FContaCorrente: String;
      FConvenio: String;  // Codigo do Convenio
      FRecords: TStringList;
      FDensidade: TDensidade;
      FDetalhe: Integer;
      FDigitoAgenciaConta: String;
      FEndereco: TEndereco;
      FFileName: TFileName;
      FInscricao: String; // Numero do CNPJ ou CPF
      FLote: Integer; // Incrementar em 1 a cada lote acrescentado ao arquivo
      {Número seqüencial para identificar univocamente um lote de serviço. Criado
      e controlado pelo responsável pela geração magnética dos dados contidos no arquivo.}
      FNomeBanco: String;
      FNomeEmpresa: String;
      FNSA: Integer;  // Numero Sequencia de Arquivo
      FOriginalConta: String;
      FRelease: String;
      FRemessa: TRemessa; // Codigo da Remessa
      FTipoInscricao: String; // '1' para CPF ou '2' para CNPJ
      FRegistroLote: Integer;
      FRegistroTotal: Integer;
      FValorTotal: Currency;
      FValorLote: Currency;
      FVersao: String;
      function Pad(S:String; const ALen:Integer;
                   const ASide: TAlignment; const AChar:String = #32):String;
      procedure SetAgencia(Value: String);
      procedure SetBanco(Value: String);
      procedure SetContaCorrente(Value: String);
      procedure SetConvenio(Value: String);
      procedure SetInscricao(Value: String);
      procedure SetInternaContaCorrente(Value: String;
                                        var ContaCorrente: String;
                                        var DigitoAgenciaConta: String);
    protected
    public
      constructor Create;
      destructor Destroy; override;
      property Agencia: String read FAgencia write SetAgencia;
      property Banco: String read FBanco write SetBanco;
      property ContaCorrente: String read FContaCorrente write SetContaCorrente;
      property Convenio: String read FConvenio write SetConvenio;
      property Densidade: TDensidade read FDensidade write FDensidade default cd6250;
      property Endereco: TEndereco read FEndereco write FEndereco;
      property Inscricao: String read FInscricao write SetInscricao;
      property NomeEmpresa: String read FNomeEmpresa write FNomeEmpresa;
      property NomeBanco: String read FNomeBanco write FNomeBanco;
      property NumeroSequencial: Integer read FNSA write FNSA;
      property Remessa: TRemessa read FRemessa write FRemessa default crRemessa;
      property Versao: String read FVersao write FVersao;
      property FileName: TFileName read FFileName write FFileName;
      function AddHeaderFile: String;
      function AddHeaderLote: String;
      function AddDetalhe(Camara: TCamara;
                          Banco, Agencia, Conta, Nome, Documento: String;
                          Data: TDateTime; Valor: Currency;
                          SituacaoFuncional: TSituacaoFuncional):String;
      function AddTraillerLote: String;
      function AddTraillerFile: String;
      procedure SaveToFile(const NomeArquivo: String = ''); virtual;
    end;

implementation

{ TCNAB240 }

constructor TCNAB240.Create;
begin

  inherited Create;

  FDensidade := cd6250;
  FRemessa := crRemessa;
  FNSA := 1;
  FVersao := '08';   { 12/07/2006 }
  FRelease := '2';

  FRecords := TStringList.Create;

end;

destructor TCNAB240.Destroy;
begin
  FRecords.Free;
  inherited Destroy;
end;

function TCNAB240.Pad(S: String; const ALen: Integer;
  const ASide: TAlignment; const AChar: String = #32): String;
begin

  case ASide of
    taLeftJustify:
      while (Length(S) < ALen) do
        S := S + AChar;
    taRightJustify:
      while (Length(S) < ALen) do
        S := AChar + S;
    taCenter:
      while (Length(S) < ALen) do
        if ((Length(S) mod 2) = 0)
          then S := S + AChar
          else S := AChar + S;
  end;

  if (Length(S) > ALen) then
    S := Copy(S, 1, ALen);

  Result := S;

end;

procedure TCNAB240.SetAgencia(Value: String);
begin
  if (Value <> FAgencia) then
  begin
    Value := Trim(Value);
    if (Length(Value) > 6) then
      raise Exception.Create('O código do agência excedeu 6 (seis) posições.');
    FAgencia := Value;
  end;
end;

procedure TCNAB240.SetBanco(Value: String);
begin
  if (Value <> FBanco) then
  begin
    Value := Trim(Value);
    if (Length(Value) <> 3) then
      raise Exception.Create('O código do banco deve conter 3 (três) posições.');
    FBanco := Value;
  end;
end;

procedure TCNAB240.SetInternaContaCorrente(Value: String;
  var ContaCorrente: String; var DigitoAgenciaConta: String);
var
  S, DV: String;
begin

    if (Value = '') then
      raise Exception.Create('A conta corrente é obrigatória.');

    if (Pos('-', Value) = 0) then
      raise Exception.Create('A conta corrente precisa de dígito verificador.');

    // Retira os espaços e os '.' da conta corrente
    S := StringReplace(Value, #32, '', [rfReplaceAll]);
    S := StringReplace(S, '.', '', [rfReplaceAll]);

    DV := Copy(S, Pos('-', S)+1, MaxInt);  // Corpo principal da conta
    S  := Copy(S, 1, Pos('-', S)-1);       // Digito verificado da conta

    if (DV = '') then
      raise Exception.Create('A conta corrente não possui dígito verificador.');

    if (Length(DV) = 1) then
    begin
      ContaCorrente := S+DV;
      DigitoAgenciaConta := #32;
    end else
    if (Length(DV) = 2) then
    begin
      ContaCorrente := S+DV[1];
      DigitoAgenciaConta := DV[2];
    end else
      raise Exception.Create('O dígito verificador da conta não pode exceder 2 (duas) posições.');

end;

procedure TCNAB240.SetContaCorrente(Value: String);
begin

  if (Value <> FOriginalConta) then
  begin
    SetInternaContaCorrente(Value, FContaCorrente, FDigitoAgenciaConta);
    FOriginalConta := Value;
  end;

end;

procedure TCNAB240.SetConvenio(Value: String);
begin
  if (Value <> FConvenio) then
  begin
    if (Value = '') then
      raise Exception.Create('O número do convêncio é obrigatório.');
    FConvenio := Trim(Value);
  end;
end;

procedure TCNAB240.SetInscricao(Value: String);
begin

  if (Value <> FInscricao) then
  begin

    if (Value = '') then
      raise Exception.Create('O número de inscrição é obrigatório.');

    Value := StringReplace(Value, '.', '', [rfReplaceAll]);
    Value := StringReplace(Value, '-', '', [rfReplaceAll]);

    if (Length(Value) = 11) then // CPF
      FTipoInscricao := '1'
    else if (Length(Value) = 14) then // CNPJ
      FtipoInscricao := '2'
    else
      raise Exception.Create('Número de Inscrição Inválido.');

    FInscricao := Value;

  end;

end;

{
Formato dos campos

* Os campos alfabéticos e alfanuméricos deverão ser alinhados à esquerda e
  preenchidos com brancos à direita, quando for o caso.
* Os campos numéricos deverão se alinhados à direita e preenchidos com zeros à
  esquerda, quando for o caso.
* Todos os dados alfabéticos devem ser informados com caracteres maiúsculos.
  Os caracteres de edição ou máscara deverão ser omitidos (ponto, vírgula, etc.).
}

{
Registro Header de Arquivo

+-------------------------------------------------------------------------------------------------------------------+
| Campo                                                                     Posição  No.  No. Formato Default Des-  |
|                                                                           De   Até Dig  Dec                 crição|
+-------------------------------------------------------------------------------------------------------------------+
| 01.0            Banco                 Código do Banco na Compensação      1    3   3    -   Num             G001  |
| 02.0  Controle  Lote                  Lote de Serviço                     4    7   3    -   Num     '0000'  *G002 |
| 03.0            Registro              Tipo de Registro                    8    8   1    -   Num     '0'     *G003 |
+-------------------------------------------------------------------------------------------------------------------+
| 04.0  CNAB                            Uso Exclusivo FEBRABAN / CNAB       9   17   9    -   Alfa    Brancos G004  |
+-------------------------------------------------------------------------------------------------------------------+
| 05.0  E         Inscri- Tipo          Tipo de Inscrição da Empresa        18  18   1    -   Num             *G005 |
| 06.0  M         ção     Número        Numero de Inscrição da Empresa      19  32   14   -   Num             *G006 |
| 07.0  P         Convênio              Código do Convêncio no Banco        33  52   20   -   Alfa            *G007 |
| 08.0  R         Conta   Agên- Código  Agência Mantenedora da Conta        53  57   5    -   Num             *G008 |
| 09.0  E                 cia   DV      Dígito Verificador da Agência       58  58   1    -   Alfa            *G009 |
| 10.0  S         Cor-          Número  Número da Conta Corrente            59  70   12   -   Num             *G010 |
| 11.0  A         ren-    Conta DV      Dígito Verificador da Conta         71  71   1    -   Alfa            *G011 |
| 12.0            te      DV            Dígito Verificador da Ag/Conta      72  72   1    -   Alfa            *G012 |
| 13.0            Nome                  Nome da Empresa                     73  102  30   -   Alfa            G013  |
| 14.0  Nome do Banco                   Nome do Banco                       103 132  30   -   Alfa            G014  |
+-------------------------------------------------------------------------------------------------------------------+
| 15.0  CNAB                            Uso Exclusivo FEBRABAN / CNAB       9   17   9    -   Alfa    Brancos G004  |
+-------------------------------------------------------------------------------------------------------------------+
| 16.0  A         Código                Código Remessa / Retorno            143 143  1    -   Num             G015  |
| 17.0  R         Data de Geração       Data de Geração do Arquivo          144 151  8    -   Num             G016  |
| 18.0  Q         Hora de Geração       Hora de Geração do Arquivo          152 157  6    -   Num             G017  |
| 19.0  U         Seqüência (NSA)       Número Seqüencial do Arquivo        158 163  6    -   Num             *G018 |
| 20.0  I         Layout do Arquivo     No. da Versão do Layout do Arquivo  164 166  3    -   Num     '082'   *G019 |
| 21.0  VO        Densidade             Densidade de Gravação do Arquivo    167 171  5    -   Num             G020  |
+-------------------------------------------------------------------------------------------------------------------+
| 22.0  Reservado Banco                 Para Uso Reservado do Banco         172 191  20   -   Alfa            G021  |
| 23.0  Reservado Empresa               Para Uso Reservado da Empresa       192 211  20   -   Alfa            G022  |
+-------------------------------------------------------------------------------------------------------------------+
| 24.0  CNAB                            Uso Exclusivo FEBRABAN / CNAB       212 240  29   -   Alfa    Brancos G004  |
+-------------------------------------------------------------------------------------------------------------------+

**Controle** - Banco origem ou destino do arquivo
**Empresa** - Empresa que firmou o convênio de prestação de serviços com o Banco
**Conta Corrente** (Empresa) - Número da conta do corrente do convênio firmado
entre Banco e Empresa para a prestação de um tipo de serviço.
Quando o arquivo contiver mais que um tipo de serviço diferente, os dados da
conta corrente a serem colocados aqui devem ser acordados entre o Banco e a Empresa.

}

function TCNAB240.AddHeaderFile: String;
begin

  FRecords.Clear;
  FLote := 0;
  FValorTotal := 0.0;
  FRegistroTotal := 0;

  {01.0 Código do Banco na compensação.}
  Result := FBanco;

  {02.0 Lote de Serviço.}
  Result := Result + '0000';

  {03.0 Tipo de Registro.}
  Result := Result + '0';

  {04.0 Uso Exclusivo FEBRABAN/CNAB.}
  Result := Result + StringOfChar(#32, 9);

  {05.0 Tipo de Inscrição da Empresa.}
  Result := Result + FTipoInscricao;

  // 06.0 Numero de Inscrição da Empresa - Num(14).
  Result := Result + Pad( FInscricao, 14, taRightJustify, '0');

  {07.0 Código do Convêncio no Banco.}
  if (Length(FConvenio) > 20) then
    raise Exception.Create('O número do convênio excedeu 20 (vinte) posições.');

  Result := Result + Pad( FConvenio, 20, taLeftJustify);

  {08.0 Agência Mantenedora da Conta
   09.0 Dígito Verificador da Agência.}
  Result := Result + Pad( FAgencia, 6, taRightJustify, '0');

  // 10.0 Número da Conta Corrente - Num(12).
  // 11.0 Dígito Verificador da Conta - Alfa(1).
  Result := Result + Pad( FContaCorrente, 13, taRightJustify, '0');

  {12.0 Dígito Verificador da Ag/Conta.}
  Result := Result + FDigitoAgenciaConta;

  {13.0 Nome da Empresa.}
  Result := Result + Pad( FNomeEmpresa, 30, taLeftJustify);

  // 14.0 Nome do Banco - Alfa(30).
  Result := Result + Pad( FNomeBanco, 30, taLeftJustify);

  {15.0 Uso Exclusivo FEBRABAN / CNAB.}
  Result := Result + StringOfChar(#32, 9);

  {16.0 Código Remessa / Retorno.
        "1" - REMESSA - Enviado pela Empresa para o Banco
        "2" - RETORNO - Enviado pelo Banco para a Empresa.}

  if (FRemessa = crRemessa) then
    Result := Result + '1'
  else if (FRemessa = crRetorno) then
    Result := Result + '2';

  {17.0 Data de Geração do Arquivo.}
  {18.0 Hora de Geração do Arquivo.}
  Result := Result + FormatDateTime('YYYMMDDHHNNSS', Now());

  {19.0 Número seqüencial do Arquivo (NSA).
   Este número deverá evoluir de 1 em 1 para cada arquivo gerado e
   terá uma seqüência para o Banco e outro para a Empresa.}
  Result := Result + Format('%.6d', [FNSA]);

  {20.0 No. da Versão do Layout do Arquivo.}
  Result := Result + FVersao + FRelease;

  {21.0	Densidade de Gravação do Arquivo (BPI).}
  if (FDensidade = cd1600) then
    Result := Result + '01600'
  else if (FDensidade = cd6250) then
    Result := Result + '06250';

  {22.0 Para Uso Reservado do Banco.}
  Result := Result + StringOfChar(#32, 20);

  {23.0 Para Uso Reservado da Empresa.}
  Result := Result + StringOfChar(#32, 20);

  {24.0 Uso Exclusivo FEBRABAN / CNAB.}
  Result := Result + StringOfChar(#32, 29);

  FRecords.Add(Result);

end;

{

HEADER DE LOTE     -     REGISTRO  1

+-------------------------------------------------------------------------------------------------------------------+
| Campo                                                                     Posição  No.  No. Formato Default Des-  |
|                                                                           De  Até  Dig  Dec                 crição|
+-------------------------------------------------------------------------------------------------------------------+
| 01.1            Banco                  Código do Banco na Compensação     1   3    3    -   Num              G001 |
| 02.1	 Controle Lote                   Lote de Serviço                    4   7    4    -   Num             *G002 |
| 03.1            Registro               Tipo de Registro                   8   8    1    -   Num     '1'     *G003 |
+-------------------------------------------------------------------------------------------------------------------+
| 04.1   Serviço  Operação               Tipo da Operação                   9   9    1    -   Alfa    'C'     *G028 |
| 05.1            Serviço                Tipo do Serviço                   10  11    2    -   Num             *G025 |
| 06.1            Forma Lançamento       Forma de Lançamento               12  13    2    -   Num             *G029 |
| 07.1            Layout do Lote         Nº da Versão do Layout do Lote    14  16    3    -   Num     '042'   *G030 |
+-------------------------------------------------------------------------------------------------------------------+
| 08.1   CNAB                            Uso Exclusivo da FEBRABAN/CNAB    17  17    1    -   Alfa    Brancos  G004 |
+===================================================================================================================+
| 09.1   E        Inscri-  Tipo          Tipo de Inscrição da Empresa      18  18    1    -   Num             *G005 |
| 10.1   m        ção      Número        Número de Inscrição da Empresa    19  32   14    -   Num             *G006 |
| 11.1   p        Convênio               Código do Convênio no Banco       33  52   20    -   Alfa            *G007 |
| 12.1   r                 Agê-  Código  Agência Mantenedora da Conta      53  57    5    -   Num             *G008 |
| 13.1   e        Conta    cia   DV      Dígito Verificador da Agência     58  58    1    -   Alfa            *G009 |
| 14.1   s        Cor-     Conta Número  Número da Conta Corrente          59  70   12    -   Num             *G010 |
| 15.1   a        rente          DV      Dígito Verificador da Conta       71  71    1    -   Alfa            *G011 |
| 16.1                     DV            Dígito Verificador da Ag/Conta    72  72    1    -   Alfa            *G012 |
| 17.1            Nome                   Nome da Empresa                   73 102   30    -   Alfa             G013 |
+-------------------------------------------------------------------------------------------------------------------+
| 18.1   Informação 1                    Mensagem                         103 142   40    -   Alfa            *G031 |
+===================================================================================================================+
| 19.1	Endere-   Logradouro             Nome da Rua, Av, Pça, Etc        143 172   30    -   Alfa             G032 |
| 20.1  ço        Número                 Número do Local                  173 177    5    -   Num              G032 |
| 21.1            Complemento            Casa, Apto, Sala, Etc            178 192   15    -   Alfa             G032 |
| 22.1  da        Cidade                 Nome da Cidade                   193 212   20    -   Alfa             G033 |
| 23.1            CEP                    CEP                              213 217    5    -   Num              G034 |
| 24.1  Empresa   Complemento CEP        Complemento do CEP               218 220    3    -   Alfa             G035 |
| 25.1            Estado                 Sigla do Estado                  221 222    2    -   Alfa             G036 |
+-------------------------------------------------------------------------------------------------------------------+
| 26.1  CNAB                             Uso Exclusivo FEBRABAN/CNAB      223 230    8    -   Alfa    Brancos  G004 |
+-------------------------------------------------------------------------------------------------------------------+
| 27.1  Ocorrências                   Códigos das Ocorrências p/ Retorno  231 240   10    -   Alfa            *G059 |
+-------------------------------------------------------------------------------------------------------------------+
}

function TCNAB240.AddHeaderLote:String;
begin

  FLote := FLote + 1;
  FDetalhe := 0;

  {01.1 Código do Banco na compensação.}
  Result := FBanco;

  {02.1 Lote de Serviço.}
  Result := Result +  Format('%.4d',[FLote]);

  {03.1 Tipo de Registro.}
  Result := Result + '1';

  {04.1 Tipo de Operação.}
  Result := Result + 'C';  // 'C' = Lançamento a Crédito

  {05.1 Tipo do Serviço.}
  Result := Result + '30';  // '30'  =  Pagamento Salários

  {06.1 Forma de Lançamento.}
  Result := Result + '04';  //'04'  =  Cartão Salário (somente para Tipo de Serviço = '30')

  {07.1 Nº da Versão do Layout do Lote.}
  Result := Result + '042';

  {08.1 Uso Exclusivo da FEBRABAN/CNAB.}
  Result := Result + #32;

  {09.1 Tipo de Inscrição da Empresa.}
  Result := Result + FTipoInscricao;

  // 10.1 Numero de Inscrição da Empresa - Num(14).
  Result := Result + Pad(FInscricao, 14, taRightJustify, '0');

  // 11.1 Código do Convêncio no Banco - Alfa(20).
  if Length(FConvenio) > 20 then
    raise Exception.Create('O número do convênio excedeu 20 (vinte) posições.');

  Result := Result + Pad(FConvenio, 20, taLeftJustify);

  {12.1 Agência Mantenedora da Conta
   13.1 Dígito Verificador da Agência.}
  Result := Result + Pad(FAgencia, 6, taRightJustify, '0');

  // 14.1 Número da Conta Corrente - Num(12).
  // 15.1 Dígito Verificador da Conta - Alfa(1).
  if (FContaCorrente = '') then
    raise Exception.Create('A conta corrente é obrigatória.');

  if (Length(FContaCorrente) > 13) then
    raise Exception.Create('O número da conta corrente excedeu 13 (treze) posições.');

  Result := Result + Pad(FContaCorrente, 13, taRightJustify, '0');

  {16.1 Dígito Verificador da Ag/Conta.}
  Result := Result + FDigitoAgenciaConta;

  {17.1 Nome da Empresa.}
  Result := Result + Pad(FNomeEmpresa, 30, taLeftJustify);

  {18.1 Informação 1 (Mensagem).}
  Result := Result + StringOfChar(#32, 40);

  {Endereço}

  {19.1  Logradouro-Nome da Rua, Av, Pça, Etc.}
  if Length(FEndereco.Logradouro) > 30 then
    raise Exception.Create('O Logradouro do endereço excedeu 30 (trinta) posições.');

  Result := Result + Pad(FEndereco.Logradouro, 30, taLeftJustify);

  {20.1  Número do Local.}
  if Length(FEndereco.Numero) > 5 then
    raise Exception.Create('O número do local excedeu 5 (cinco) posições.');

  Result := Result + Format('%.5d',[FEndereco.Numero]);

  {21.1  Complemento-Casa, Apto, Sala, Etc.}
  if Length(FEndereco.Complemento) > 15 then
    raise Exception.Create('O complemento do endereço excedeu 15 (quinze) posições.');

  Result := Result + Pad(FEndereco.Complemento, 15, taLeftJustify);

  {22.1  Nome da Cidade.}
  if Length(FEndereco.Cidade) > 20 then
    raise Exception.Create('O nome da cidade excedeu 20 (vinte) posições.');

  Result := Result + Pad(FEndereco.Cidade, 20, taLeftJustify);

  {23.1  CEP
   24.1  Complemento do CEP.}
  if (FEndereco.CEP <> '') then
    raise Exception.Create('O CEP da empresa é obrigatório.');


  if Length(FEndereco.CEP) <> 8 then
    raise Exception.Create('O CEP deve possuir 8 (oito) posições.');

  Result := Result + FEndereco.CEP;

  {25.1  Sigla do Estado.}
  if Length(FEndereco.UF) <> 2 then
    raise Exception.Create('a sigla do Estado (UF) deve possuir 2 (duas) posições.');
  Result := Result + FEndereco.UF;

  {26.1  Uso Exclusivo FEBRABAN/CNAB.}
  Result := Result + StringOfChar(#32, 8);

  {27.1  Códigos das Ocorrências p/ Retorno.}
  Result := Result + StringOfChar(#32, 10);

  FRecords.Add(Result);

end;


{

02. DETALHE  -  REGISTRO 3  -  SEGMENTO  A  /OBRIGATORIO/

+-------------------------------------------------------------------------------------------------------------------+
| Campo                                                                     Posição  No.  No. Formato Default Des-  |
|                                                                           De  Até  Dig  Dec                 crição|
+-------------------------------------------------------------------------------------------------------------------+
| 01.3A           Banco                  Código do Banco na Compensação      1    3   3    -  Num              G001 |
| 02.3A  Controle Lote                   Lote de Serviço                     4    7   3    -  Num             *G002 |
| 03.3A           Registro               Tipo de Registro                    8    8   1    -  Num     '3'     *G003 |
+-------------------------------------------------------------------------------------------------------------------+
| 04.3A  Serviço  Nº do Registro         Nº Seqüencial do Registro no Lote   9   13   5    -  Num             *G038 |
| 05.3A           Segmento               Código de Segmento do Reg. Detalhe 14   14   1    -  Alfa    'A'     *G039 |
| 06.3A           Movi-   Tipo           Tipo de Movimento                  15   15   1    -  Num             *G060 |
| 07.3A		  mento   Código         Código da Instrução p/ Movimento   16   17   2    -  Num              G061 |
+===================================================================================================================+
| 08.3A  F        Câmara                 Código da Câmara Centralizadora    18   20   3    -  Num             *P001 |
| 09.3A  a        Banco                  Código do Banco do Favorecido      21   23   3    -  Num              P002 |
| 10.3A  v        Con-     Agên- Código	 Ag. Mantenedora da Cta do Favor.   24   28   5    -  Num             *G008 |
| 11.3A	 o        ta       cia   DV      Dígito Verificador da Agência      29   29   1    -  Alfa            *G009 |
| 12.3A  r        Cor-     Conta Número  Número da Conta Corrente           30   41  12    -  Num             *G010 |
| 13.3A	 e	  rente          DV      Dígito Verificador da Conta        42   42   1    -  Alfa            *G011 |
| 14.3A  c i               DV            Dígito Verificador da AG/Conta     43   43   1    -  Alfa            *G012 |
| 15.3A  d o      Nome                   Nome do Favorecido                 44   73  30    -  Alfa             G013 |
+-------------------------------------------------------------------------------------------------------------------+
| 16.3A  C        Seu Número             Nº do Docum. Atribuído p/ Empresa  74   93  20    -  Alfa             G064 |
| 17.3A  r        Data Pagamento         Data do Pagamento                  94  101   8    -  Num              P009 |
| 18.3A  e        Moeda   Tipo           Tipo da Moeda                     102  104   3    -  Alfa            *G040 |
| 19.3A  d                Quantidade     Quantidade da Moeda               105  119  10    5  Num              G041 |
| 20.3A  i        Valor Pagamento        Valor do Pagamento                120  134  13    2  Num              P010 |
| 21.3A  t        Nosso Número           Nº do Docum. Atribuído pelo Banco 135  154  20    -  Alfa            *G043 |
| 22.3A  o        Data Real              Data Real da Efetivação Pagto     155  162   8    -  Num              P003 |
| 23.3A           Valor Real             Valor Real da Efetivação do Pagto 163  177  13    2  Num              P004 |
+-------------------------------------------------------------------------------------------------------------------+
| 24.3A	 Informação 2                    Outras Informações - Vide forma-  178  217  40    -  Alfa            *G031 |
|                                        tação em G031 para identificação                                           |
|                                        de Deposito Judicial e Pgto.                                               |
|                                        Salários de servidores pelo SIAPE                                          |
+-------------------------------------------------------------------------------------------------------------------+
| 25.3A  Código Finalidade Doc           Compl. Tipo Serviço               218  219   2    -  Alfa            *P005 |
| 26.3A  Código Finalidade TED           Codigo finalidade da TED          220  224   5    -  Alfa            *P011 |
| 27.3A	 Código Finalidade Complementar  Complemento de finalidade pagto.  225  226   2    -  Alfa             P013 |
| 28.3A  CNAB                            Uso Exclusivo FEBRABAN/CNAB       227  229   3    -  Alfa   Brancos   G004 |
| 29.3A  Aviso                           Aviso ao Favorecido               230  230   1    -  Num             *P006 |
| 29.3A  Ocorrências                     Códigos das Ocorrências p Retorno 231  240  10    -  Alfa            *G059 |
+-------------------------------------------------------------------------------------------------------------------+
}

function TCNAB240.AddDetalhe(Camara: TCamara;
  Banco, Agencia, Conta, Nome, Documento: String;
  Data: TDateTime; Valor: Currency;
  SituacaoFuncional: TSituacaoFuncional):String;
var
  SContaCorrente, SDigitoAgenciaConta: String;
begin

  FDetalhe := FDetalhe + 1;

  {01.3A Código do Banco na compensação.}
  Result := FBanco;

  {02.3A Lote de Serviço.}
  Result := Result +  Format('%.4d',[FLote]);

  {03.3A Tipo de Registro.}
  Result := Result + '3';

  // 04.3A Numero Sequencial do Registro no Lote.
  Result := Result + Format('%.5d', [FDetalhe]);

  {05.3A Código de Segmento do Reg. Detalhe.}
  Result := Result + 'A';

  {06.3A Tipo de Movimento.}
  Result := Result + '0';  // '0'   =  Indica INCLUSÃO

  {07.3A Código da Instrução p/ Movimento.}
  Result := Result + '00';  // '00' = Inclusão de Registro Detalhe Liberado

  {08.3A Código da Câmara Centralizadora.}
  if Camara = ccTED then
    Result := Result + '018'
  else if Camara = ccDOC then
    Result := Result + '700';

  {09.3A Código do Banco do Favorecido.}
  Result := Result + Pad(Banco, 3, taRightJustify, '0');

  {10.3A Ag. Mantenedora da Cta do Favor.
   11.3A Dígito Verificador da Agência.}
  Agencia := StringReplace(Agencia, '-', '', [rfReplaceAll]);
  Result := Result + Pad(Agencia, 6, taRightJustify, '0');

  {12.3A Número da Conta Corrente - Num(12).
   13.3A Dígito Verificador da Conta - Alfa(1).
   14.3A Dígito Verificador da AG/Conta - Alfa(1).}
  SetInternaContaCorrente(Conta, SContaCorrente, SDigitoAgenciaConta);
  Result := Result + Pad(SContaCorrente, 13, taRightJustify, '0')+SDigitoAgenciaConta;

  {15.3A Nome do Favorecido - Alfa(30).}
  Result := Result + Pad(Nome, 30, taLeftJustify);

  {16.3A Numero do Docum. Atribuído p/ Empresa - Alfa(20).}
  Result := Result + Pad(Documento, 20, taLeftJustify);

  {17.3A Data do Pagamento - Num(8).}
  Result := Result + FormatDateTime('DDMMYYYY', Data);

  {18.3A Tipo da Moeda - Alfa(3).}
  Result := Result + 'BRL';  // BRL - Real

  {19.3A Quantidade da Moeda - Num(15,5).}
  Result := Result + Format('%.15d', [Trunc(Valor*100000)]);

  {20.3A Valor do Pagamento  - Num(15,2).}
  Result := Result + Format('%.15d', [Trunc(Valor*100)]);

  {21.3A Numero do Docum. Atribuído pelo Banco - Alfa(20).
   Obs: Campo a ser preenchido quando o arquivo eh Retorno }
  Result := Result + StringOfChar(#32, 20);

  {22.3A Data Real da Efetivação Pagto - Num(8).
   Obs: Campo a ser preenchido quando o arquivo eh Retorno }
  Result := Result + StringOfChar('0', 8);

  {23.3A Valor Real da Efetivação do Pagto - Num(15).
   Obs: Campo a ser preenchido quando o arquivo eh Retorno }
  Result := Result + StringOfChar('0', 15);

  {24.3A Informação 2.
   Formatação para Identificação da Situação Funcional : Posição 216 a 216 (1 posição).}
  Result := Result + StringOfChar(#32, 38)+IntToStr(Ord(SituacaoFuncional))+#32;

  {25.3A Compl. Tipo Serviço - Alfa(2).
   26.3A Codigo finalidade da TED - Alfa(5).
   27.3A Complemento de finalidade pagto - Alfa(2).
   28.3A Uso Exclusivo FEBRABAN/CNAB - Alfa(3).}
  Result := Result + StringOfChar(#32, 12);

  {29.3A Aviso ao Favorecido - Num(1).
   Dominio - '0' = Não Emite Aviso
             '2'  = Emite Aviso Somente para o Remetente
             '5' = Emite Aviso Somente para o Favorecido
             '6'  = Emite Aviso para o Remetente e Favorecido
             '7'  = Emite Aviso para o Favorecido e 2 Vias para o Remetente}
  Result := Result + '0';

  {29.3A Códigos das Ocorrências p Retorno - Alfa(10).}
  Result := Result + StringOfChar(#32, 10);

  FRecords.Add(Result);

  FRegistroLote := FRegistroLote + 1;
  FValorLote := FValorLote + Valor;

  FRegistroTotal := FRegistroTotal + 1;
  FValorTotal := FValorTotal + Valor;


end;

{

Registro Trailer de Lote

+-------------------------------------------------------------------------------------------------------------------+
| Campo                                                                     Posição  No.  No. Formato Default Des-  |
|                                                                           De   Até Dig  Dec                 crição|
+-------------------------------------------------------------------------------------------------------------------+
| 01.5  Controle  Banco                 Código do Banco na Compensação      1    3   3    -   Num             G001  |
| 02.5            Lote                  Lote de Serviço                     4    7   4    -   Num             *G002 |
| 03.5            Registro              Tipo de Registro                    8    8   1    -   Num     '5'     *G003 |
+-------------------------------------------------------------------------------------------------------------------+
| 04.5  CNAB                            Uso Exclusivo FEBRABAN/CNAB         9    17  9    -   Alfa    Brancos G004  |
+===================================================================================================================+
| 05.5  Totais    Qtde de Registros     Quantidade de Registros do Lote     18   23  6    -   Num            *G057  |
| 06.5            Valor                 Somatória dos Valores               24   41  16   2   Num             P007  |
| 07.5            Qtde de Moeda         Somatória de Quantidade de Moedas   42   59  13   5   Num             G058  |
+-------------------------------------------------------------------------------------------------------------------+
| 08.5  Número Aviso Débito             Número Aviso de Débito              60   65  6    -   Num             G066  |
+-------------------------------------------------------------------------------------------------------------------+
| 09.5  CNAB                            Uso Exclusivo FEBRABAN/CNAB         66   230 165  -   Alfa    Brancos G004  |
+-------------------------------------------------------------------------------------------------------------------+
| 10.5  Ocorrências                     Códigos das Ocorrências p/ Retorno  231  240 10   -   Alfa            *G059 |
+-------------------------------------------------------------------------------------------------------------------+
}

function TCNAB240.AddTraillerLote: String;
begin

  // 01.5 Código do Banco na compensação - Num(3).
  Result := FBanco;

  // 02.5 Lote de Serviço - Num(4).
  Result := Result + Format('%.4d', [FLote]);

  // 03.5 Tipo de Registro - Num(1).
  Result := Result + '5';

  // 04.5 Uso Exclusivo FEBRABAN/CNAB - Alfa(9).
  Result := Result + StringOfChar(#32, 9);

  // 05.5 Quantidade de Registros do Lote - Num(6).
  Result := Result + Format('%.6d', [FRegistroLote]);

  // 06.5 Somatória dos Valores - Num(18,2).
  Result := Result + Format('%.18d', [Trunc(FValorLote*100)]);

  // 07.5 Somatória de Quantidade de Moedas - Num(18,5).
  Result := Result + Format('%.18d', [Trunc(FValorLote*100000)]);

  // 08.5 Número Aviso de Débito - Num(6).
  Result := Result + StringOfChar(#32, 6);

  // 09.5 Uso Exclusivo FEBRABAN/CNAB - Alfa(165).
  Result := Result + StringOfChar(#32, 165);

  // 10.5 Códigos das Ocorrências p/ Retorno - Alfa(10).
  Result := Result + StringOfChar(#32, 10);

end;  // AddTraillerLote

{

Registro Tailer de Arquivo

+-------------------------------------------------------------------------------------------------------------------+
| Campo                                                                     Posição  No.  No. Formato Default Des-  |
|                                                                           De   Até Dig  Dec                 crição|
+-------------------------------------------------------------------------------------------------------------------+
| 01.9            Banco                 Código do Banco na Compensação      1    3   3    -   Num             G001  |
| 02.9  Controle  Lote                  Lote de Serviço                     4    7   4    -   Num     '9999'  *G002 |
| 03.9            Registro              Tipo de Registro                    8    8   1    -   Num     '9'     *G003 |
+-------------------------------------------------------------------------------------------------------------------+
| 04.9  CNAB                            Uso Exclusivo FEBRABAN / CNAB       9   17   9    -   Alfa    Brancos G004  |
+-------------------------------------------------------------------------------------------------------------------+
| 05.9            Qtde de Lotes         Quantidade de Lotes do Arquivo      18  23   6    -   Num             G049  |
| 06.9  Totais    Qtde de Registros     Quantidade de Registros do Arquivo  24  29   6    -   Num             G056  |
| 07.9            Qtde de Contas Concil Qtde de Contas p/ Conc. (Lotes)     30  35   6    -   Num             *G037 |
+-------------------------------------------------------------------------------------------------------------------+
| 08.9  CNAB                            Uso Exclusivo FEBRABAN / CNAB       36  240  205  -   Alfa    Brancos G004  |
+-------------------------------------------------------------------------------------------------------------------+

**Controle** - Banco origem ou destino do arquivo
**Totais** - Totais de controle para checagem do arquivo

}

function TCNAB240.AddTraillerFile: String;
begin

  {01.9 Código do Banco na compensação.}
  Result := FBanco;

  {02.9 Lote de Serviço.}
  Result := Result + '9999';

  {03.9 Tipo de Registro.}
  Result := Result + '9';

  {04.9 Uso Exclusivo FEBRABAN/CNAB.}
  Result := Result + StringOfChar(#32, 9);

  {05.9 Quantidade de Lotes do Arquivo.}
  Result := Result + Format('%.6d', [FLote]);

  {06.9 Quantidade de Registros do Arquivo.}
  Result := Result + Format('%.6d', [FRegistroLote]);

  {07.9 Qtde de Contas p/ Conc. (Lotes).}
  Result := Result + StringOfChar('0', 6);

  { 08.9 Uso Exclusivo FEBRABAN / CNAB.}
  Result := Result + StringOfChar( #32, 205);

end;  // TraillerFile

procedure TCNAB240.SaveToFile( const NomeArquivo: String = '');
var
  Arquivo: TextFile;
  i: Integer;
  sFileName: String;
begin

  if (NomeArquivo = '') then
    sFileName := FFileName
  else
    sFileName := NomeArquivo;

  if (sFileName = '') then
    raise Exception.Create('O nome do arquivo deve ser informado.');

  AssignFile( Arquivo, sFileName);

  try
    Rewrite(Arquivo);
    for i := 0 to FRecords.Count - 1 do
      WriteLn( Arquivo, FRecords.Strings[i]);
  finally
    CloseFile(Arquivo);
  end;  // try


end;  // SaveToFile

end.
