unit RelListaEvento;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  QuickRpt, Qrctrls, ExtCtrls, Db, ADODB, AKPrint, Mask, MaskUtils;

type
  TfrmLista = class(TForm)
    TbPrinter1: TTbPrinter;
    TbCustomReport1: TTbCustomReport;
    qryLiquido: TADOQuery;
    procedure TbCustomReport1Generate(Sender: TObject);
  private
    { Private declarations }
    pvFolha, pvRecurso: Integer;
    pvEmpresa, pvLotacao, pvTipo,
    pvBanco, pvAgencia,
    pvFormato, pvOrdem: String;
    pvExc_Sem_Conta, pvExc_Sem_Liquido: Boolean;

    function Processa:Boolean;
    function GeraArquivo:Boolean;

  public
    { Public declarations }
  end;

procedure ImprimeListaEvento( Conexao: TADOConnection;
  Empresa: String; Folha, Recurso: Integer;
  Lotacao, Tipo, Banco, Agencia, Formato, Ordem: String;
  Exc_Sem_Conta, Exc_Sem_Liquido: Boolean; Saida: String) ;

implementation

uses Util2;

{$R *.DFM}

(* ============== INTERFACE ========================================= *)

procedure ImprimeListaEvento( Conexao: TADOConnection;
  Empresa: String; Folha, Recurso: Integer;
  Lotacao, Tipo, Banco, Agencia, Formato, Ordem: String;
  Exc_Sem_Conta, Exc_Sem_Liquido: Boolean; Saida: String) ;
var
  frm : TfrmLista;
begin

   frm := TfrmLista.Create(Application);

   try
     with frm do begin

         qryLiquido.Connection := Conexao;

         pvEmpresa := Empresa;
         pvFolha   := Folha;
         pvRecurso := Recurso;
         pvLotacao := Lotacao;
         pvTipo    := Tipo;
         pvBanco   := Banco;
         pvAgencia := Agencia;
         pvFormato := Formato;
         pvOrdem   := Ordem;

         pvExc_Sem_Conta   := Exc_Sem_Conta;
         pvExc_Sem_Liquido := Exc_Sem_Liquido;

         if (Saida = 'A') then begin
           pvExc_Sem_Conta   := True;
           pvExc_Sem_Liquido := True;
         end;

         Processa();

         case Saida[1] of
           'A': if GeraArquivo() then
                  Informe( 'O Arquivo foi gerado com sucesso');
         else
           TbPrinter1.Preview := (Saida = 'V');
           TbCustomReport1.Execute;
         end;

       end;

   finally
     frm.Free;
   end;

end;  // procedure ImprimeListaBancaria

(* =====================================================
   IMPLEMENTACAO E PROCESSAMENTO
   ===================================================== *)

function TfrmLista.GeraArquivo: Boolean;
begin
//
end;

function TfrmLista.Processa():Boolean;
begin

  Result := True;  // Default

  try

    with QryLiquido do begin
        SQL.BeginUpdate;
        SQL.Add('SELECT');
        SQL.Add('  F.co_banco BANCO, B.no_banco BANCO_NOME,');
        SQL.Add('  F.co_agencia AGENCIA, A.no_agencia AGENCIA_NOME,');
        SQL.Add('  F.co_funcionario CODIGO, F.no_funcionario NOME,');
        SQL.Add('  F.vr_salario SALARIO, F.num_cpf CPF,');
        SQL.Add('  LF.co_lotacao LOTACAO, L.no_lotacao LOTACAO_NOME, F.num_conta_corrente CONTA,');
        SQL.Add('  SUM(LF.vr_calculado*R.ref) LIQUIDO');
        SQL.Add('FROM');
        SQL.Add('  LANCAMENTO_FOLHA LF, ');
        SQL.Add('  FUNCIONARIO F, RUBRICA R,');
        SQL.Add('  BANCO B, AGENCIA A, LOTACAO L');
        SQL.Add('WHERE');

        // Valida lancamentos da folha
        SQL.Add('   LF.co_empresa = '+QuotedStr(pvEmpresa) );
        SQL.Add('   AND LF.co_folha = '+IntToStr(pvFolha) );

        if pvLotacao <> '' then
          SQL.Add(' AND LF.co_lotacao = '+QuotedStr(pvLotacao) );

        // valida funcionarios
        SQL.Add('   AND (F.co_empresa = LF.co_empresa)');
        SQL.Add('   AND (F.co_funcionario = LF.co_funcionario)');

        if pvTipo <> '' then
          SQL.Add(' AND F.co_tipo_funcionario = '+QuotedStr(pvTipo) );

        if pvRecurso > -1 then
          SQL.Add(' AND F.recurso = '+IntToStr(pvRecurso) );

        if (pvBanco <> '') then
          SQL.Add(' AND F.co_banco = '+QuotedStr(pvBanco) );

        if (pvAgencia <> '') then
          SQL.Add(' AND F.co_agencia = '+QuotedStr(pvAgencia) );

        if pvExc_Sem_Conta then begin
          SQL.Add(' AND F.num_conta_corrente IS NOT NULL');
          SQL.Add(' AND F.num_conta_corrente <> '+QuotedStr('') );
        end;

        SQL.Add('   AND R.co_empresa = LF.co_empresa');
        SQL.Add('   AND R.co_rubrica = LF.co_rubrica');

        SQL.Add('   AND B.co_banco = F.co_banco');
        SQL.Add('   AND A.co_banco = F.co_banco');
        SQL.Add('   AND A.co_agencia = F.co_agencia');

        SQL.Add('   AND L.co_empresa = LF.co_empresa');
        SQL.Add('   AND L.co_lotacao = LF.co_lotacao');

        SQL.Add('GROUP BY');
        SQL.Add('   F.co_banco, B.no_banco,');
        SQL.Add('   F.co_agencia, A.no_agencia,');
        SQL.Add('   F.co_funcionario, F.no_funcionario,');
        SQL.Add('   F.vr_salario, F.num_cpf,');
        SQL.Add('   LF.co_lotacao, L.no_lotacao, F.num_conta_corrente');

        if pvExc_Sem_Liquido then
          SQL.Add('HAVING SUM(LF.vr_calculado*R.ref) > 0');

        SQL.Add(' ORDER BY');
        SQL.Add('   F.co_banco, F.co_agencia');

        if (pvOrdem = 'N') then
          SQL.Add(', f.no_funcionario')
        else
          SQL.Add(', f.co_funcionario');

        SQL.EndUpdate;
        Open;

      end;  // with Query.SQL do

  except
    Result := False;
  end;

end; // function Processa

procedure TfrmLista.TbCustomReport1Generate(Sender: TObject);
const
  FMT_VALOR = '#,###,##0.00';

var
  sEmpresa: String;
  iMargem, iPaginaAtual, iLinhaAtual, iLinhaPorPagina: Integer;
  sTitulo, sSubTitulo, sCabecalhoColuna, Texto: String;
  iMargemDireita: Integer;
  sBanco, sBancoNome, sAgencia, sAgenciaNome: String;
  cLiquido, cTotalBanco, cTotalAgencia: Currency;
  cTotalPagina, cTotalGeral: Currency;

  function FormataCpf( const Cpf:String):String;
  var
    Texto: String;
  begin

    Texto := RetiraChar( Cpf, '.-/');
    Texto := Trim(Cpf);

    if (Length(Texto) = 11) then
      Result := FormatMaskText( '999.999.999-99;0;_', Texto)
    else if (Length(Texto) = 14) then
      Result := FormatMaskText( '99.999.999/9999-99;0;_', Texto)
    else
      Result := Espaco(14);

  end;  // FormataCpf

  function FormataConta( const Conta:String):String;
  var
    Texto: String;
  begin

    Texto := RetiraChar( Trim(Conta), '.-');

    if (Length(Texto) = 0) then
      Result := Espaco(13)
    else begin

      Texto := PadLeftChar( Texto, 10);
      Texto := Trim(FormatMaskText( '999.999.999-9;0;_', Texto));

      while (Texto[1] = '.') or (Texto[1] = ' ') do
        Texto := Copy( Texto, 2, Length(Texto));

      Result := PadLeftChar( Texto, 13);

    end;

  end;  // FormataConta

  function Formata(const Formato, Prefixo: string; Valor: Extended): string;
  begin
    Result := FormatFloat( Formato, Valor);
    Result := StringOfChar( Prefixo[1], Length(Formato)-Length(Result))+Result;
  end;

  procedure Escreve( Linha, Coluna:Byte; Texto: String);
  begin
    with TbCustomReport1.Printer do
      Escribir( Coluna, Linha, Texto, FastFont );
    Inc(iLinhaAtual);
  end;

  procedure CabecalhoBanco();
  begin

    sBanco     := QryLiquido.FieldByName('BANCO').AsString;
    sBancoNome := QryLiquido.FieldByName('BANCO_NOME').AsString;

    sAgencia     := QryLiquido.FieldByName('AGENCIA').AsString;
    sAgenciaNome := QryLiquido.FieldByName('AGENCIA_NOME').AsString;

    Escreve( iLinhaAtual, iMargem, Replicate('-', iMargemDireita) );
    Escreve( iLinhaAtual, iMargem, 'BANCO: '+sBanco+' - '+sBancoNome+
                                   ' * AGENCIA: '+sAgencia+' - '+sAgenciaNome );
    Escreve( iLinhaAtual, iMargem, Replicate('-', iMargemDireita) );

  end;

  procedure Cabecalho;
  begin

     with QryLiquido do begin

     sEmpresa   := FieldByName('no_razao_social').AsString;
     sTitulo    := 'Endereco: '+FieldByName('ds_endereco').AsString+Espaco(10)+
                   'CNPJ/CEI: '+FormataCpf( FieldByName('num_cgc').AsString);
     sSubTitulo := 'Ref.: '+FormatDateTime( 'dd/mm/yyyy', FieldByName('dt_inicio').AsDateTime)+' a '+
                            FormatDateTime( 'dd/mm/yyyy', FieldByName('dt_fim').AsDateTime) +
                   '  -  Folha no.: '+FieldByName('co_folha').AsString + ' - '+
                   FieldByName('ds_observacao').AsString ;

    sCabecalhoColuna := PadRightChar( 'C/C', 13) + Espaco(2) +
                        'Mat.' +  Espaco(2) +
                        PadRightChar( 'Nome do Funcionario', 50) + Espaco(2) +
                        PadRightChar( 'CPF', 14) + Espaco(2) +
                        PadLeftChar( 'Liquido', Length(FMT_VALOR) ) + Espaco(2) +
                        PadLeftChar( 'Tot. Agencia', Length(FMT_VALOR) ) + Espaco(2) +
                        PadLeftChar( 'Total Banco', Length(FMT_VALOR) );

    end;
                        
    TbCustomReport1.Printer.NuevaPagina;
    iPaginaAtual := iPaginaAtual + 1;

    Escreve( 2, iMargem, 'Informatize Sistemas');
    Escreve( 2, (iMargemDireita-iMargem-Length(sEmpresa)) div 2, sEmpresa );
    Escreve( 2, iMargemDireita-18, FormatDateTime('dd/mm/yyyy - hh:nn',Now) );

    Escreve( 3, (iMargemDireita-iMargem-Length(sTitulo)) div 2, sTitulo );
    Escreve( 3, iMargemDireita-8, 'Pag. '+StrZero( iPaginaAtual, 3) );

    Escreve( 4, (iMargemDireita-iMargem-Length(sSubTitulo)) div 2, sSubTitulo);

    Escreve( 5, iMargem, Replicate('-', iMargemDireita)) ;
    Escreve( 6, iMargem, sCabecalhoColuna);

    iLinhaAtual  := 7;
    cTotalPagina := 0.00;

  end;

begin

  iLinhaPorPagina := 60;
  iPaginaAtual    := 0;
  iMargemDireita  := 132;
  iMargem         := 1;

  cTotalAgencia   := 0.00;
  cTotalBanco     := 0.00;
  cTotalPagina    := 0.00;
  cTotalGeral     := 0.00;

  with QryLiquido do begin

    First;

    sAgencia := '';
    sBanco   := '';

    while not EOF do begin

      if (iPaginaAtual = 0) or (iLinhaAtual > iLinhaPorPagina) then begin
        Cabecalho();
        CabecalhoBanco();

      end else if (sBanco = '') or (sBanco <> FieldByName('BANCO').AsString) then begin

        cTotalBanco   := 0;
        cTotalAgencia := 0;

        if (iLinhaAtual > iLinhaPorPagina) then
          Cabecalho();

        CabecalhoBanco();

      end else if (sAgencia = '') or (sAgencia <> FieldByName('AGENCIA').AsString) then begin

        cTotalAgencia := 0;

        if (iLinhaAtual > iLinhaPorPagina) then
          Cabecalho();

        CabecalhoBanco();

      end;

      cLiquido      := FieldByName('LIQUIDO').AsCurrency;

      cTotalAgencia := cTotalAgencia + cLiquido;
      cTotalBanco   := cTotalBanco   + cLiquido;

      cTotalPagina  := cTotalPagina + cLiquido;
      cTotalGeral   := cTotalGeral  + cLiquido;

      Texto :=
         FormataConta( FieldByName('CONTA').AsString ) + Espaco(2) +
         Formata( '####', #32, FieldByName('CODIGO').AsInteger) + Espaco(2) +
         PadRightChar( FieldByName('NOME').AsString, 50 ) + Espaco(2)+
         FormataCpf( FieldByName('CPF').AsString) + Espaco(2) +
         Formata( FMT_VALOR, #32, cLiquido ) ;

      Next;

      if (not Eof) and (sAgencia <> FieldByName('AGENCIA').AsString) and
                       (sBanco = FieldByName('BANCO').AsString) then begin
        Texto := Texto + Espaco(2) +
                 Formata( FMT_VALOR, #32, cTotalAgencia ) ;

        Escreve( iLinhaAtual, iMargem, Texto);

      end else if Eof or (sBanco <> FieldByName('BANCO').AsString) then begin
        Texto := Texto + Espaco(2) +
                 Formata( FMT_VALOR, #32, cTotalAgencia ) +  Espaco(2) +
                 Formata( FMT_VALOR, #32, cTotalBanco ) ;

        Escreve( iLinhaAtual, iMargem, Texto);

      end else
        Escreve( iLinhaAtual, iMargem, Texto);

      if Eof or (iLinhaAtual > iLinhaPorPagina) then begin
        Texto := Espaco(70) + 'Total da Pagina -> ' +
                 Formata( FMT_VALOR, #32, cTotalPagina) +
                 '  Total Acum. ->'+
                  Formata( FMT_VALOR, #32, cTotalGeral);
        Escreve( iLinhaAtual, iMargem, Replicate( '-', iMargemDireita));
        Escreve( iLinhaAtual, iMargem, Texto);
      end;

    end; // while

  end;

end;

end.
