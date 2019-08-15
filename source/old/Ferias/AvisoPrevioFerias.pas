unit AvisoPrevioFerias;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TbPrint, Db, ADODB;

type
  TFrmAvisoPrevioFerias = class(TForm)
    TbPrinter1: TTbPrinter;
    TbCustomReport1: TTbCustomReport;
    qryListagem: TADOQuery;
    qryDados: TADOQuery;
    qryCheque: TADOQuery;
    procedure TbCustomReport1Generate(Sender: TObject);
  private
    { Private declarations }
    sEmpresa, sLotacao,
    sTipo, sCargo, sOrdem: String;
    iFolha, iRecurso, iFuncionario: Integer;
    procedure Processa();
  public
    { Public declarations }
  end;

procedure ImprimeAvisoFerias( Conexao: TADOConnection;
  Empresa: String; Folha, Recurso, Funcionario: Integer;
  Lotacao, Tipo, Cargo, Ordem: String; Imprimir: Boolean);

implementation

uses Util2;

{$R *.DFM}

procedure ImprimeAvisoFerias( Conexao: TADOConnection;
  Empresa: String; Folha, Recurso, Funcionario: Integer;
  Lotacao, Tipo, Cargo, Ordem: String; Imprimir: Boolean);
var
  frm: TFrmAvisoPrevioFerias;
begin

  frm := TFrmAvisoPrevioFerias.Create(Application);

  try

    with Frm do begin

      QryDados.Connection := Conexao;
      QryCheque.Connection := Conexao;

      qryListagem.Connection := Conexao;

      sEmpresa := Empresa;
      iFolha   := Folha;
      iRecurso := Recurso;
      iFuncionario := Funcionario;
      sLotacao := Lotacao;
      sTipo    := Tipo;
      sCargo   := Cargo;
      sOrdem   := Ordem;

      Processa();

      TbPrinter1.Preview := not Imprimir;
      TbCustomReport1.Execute;

    end;

  finally
    Frm.Free;
  end;

end;  // procedure

procedure TFrmAvisoPrevioFerias.Processa();
var
  tmpCursor: TCursor;
begin

  tmpCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try

    with qryDados do begin

      Close;

      SQL.BeginUpdate;
      SQL.Clear;
      SQL.Add('SELECT');
      SQL.Add('  e.co_empresa EMPRESA, e.no_razao_social NOME_EMPRESA,');
      SQL.Add('  e.num_cgc CGC_EMPRESA, e.ds_endereco ENDERECO_EMPRESA,');
      SQL.Add('  e.ds_cidade CIDADE_EMPRESA, e.sg_uf UF_EMPRESA,');
      SQL.Add('  f.co_funcionario CODIGO_FUNCIONARIO,');
      SQL.Add('  f.no_funcionario NOME_FUNCIONARIO,');
      SQL.Add('  f.ctps_num_ctps CTPS, f.dt_admissao ADMISSAO,');
      SQL.Add('  f.SalarioMensal SALARIO_BASE, c.no_cargo NOME_CARGO,');
      SQL.Add('  ff.aquisitivo_1, ff.aquisitivo_2, ff.gozo_1, ff.gozo_2,');
      SQL.Add('  ff.pecuniario_1, ff.pecuniario_2, ff.faltas');
      SQL.Add('FROM');
      SQL.Add('  EMPRESA E, FOLHA_PAGAMENTO FP, FUNCIONARIO F,');
      SQL.Add('  CARGO C, FUNCIONARIO_FERIAS FF');
      SQL.Add('WHERE');
      SQL.Add('  (e.co_empresa = '+QuotedStr(sEmpresa)+') AND');
      SQL.Add('  (fp.co_empresa = e.co_empresa) AND');
      SQL.Add('  (fp.co_folha = '+IntToStr(iFolha)+') AND');
      SQL.Add('  (f.co_empresa = e.co_empresa) AND');
      SQL.Add('  (f.co_funcionario = :funcionario) AND');
      SQL.Add('  (c.co_cargo = f.co_cargo) AND');
      SQL.Add('  (ff.co_empresa = f.co_empresa) AND');
      SQL.Add('  (ff.co_funcionario = F.co_funcionario) AND');
      SQL.Add('  ( (ff.gozo_1 >= fp.dt_inicio) AND (ff.gozo_1 <= fp.dt_fim) )');
      SQL.EndUpdate;

    end;  //

    with QryCheque do begin
      Close;
      SQL.BeginUpdate;
      SQL.Clear ;
      SQL.Add('SELECT');
      SQL.Add('  R.co_tipo_rubrica, R.co_rubrica, R.ds_rubrica,');
      SQL.Add('  L.vr_informado, L.vr_calculado');
      SQL.Add('FROM');
      SQL.Add('  lancamento_folha L, rubrica R');
      SQL.Add('WHERE');
      SQL.Add('  L.co_empresa = '+QuotedStr(sEmpresa) );
      SQL.Add('  AND L.co_folha = '+IntToStr(iFolha) );
      SQL.Add('  AND (L.co_funcionario = :funcionario)' );
      SQL.Add('  AND (L.vr_calculado > 0)');
      SQL.Add('  AND (R.co_empresa = L.co_empresa)');
      SQL.Add('  AND (R.co_rubrica = L.co_rubrica)');
      SQL.Add('  AND R.co_tipo_rubrica <> '+QuotedStr('B') );

      SQL.Add('ORDER BY');
      SQL.Add('  R.co_tipo_rubrica desc, R.co_prioridade_calculo, R.co_rubrica');

      SQL.EndUpdate;

    end;

    with qryListagem do begin

      Close ;

      SQL.BeginUpdate;
      SQL.Clear ;
      SQL.Add('SELECT f.co_funcionario, f.no_funcionario');
      SQL.Add('FROM');
      SQL.Add('  folha_pagamento fp, funcionario f, funcionario_ferias ff');
      SQL.Add('WHERE');

      SQL.Add('  fp.co_empresa = '+QuotedStr(sEmpresa) );
      SQL.Add('  AND fp.co_folha = '+IntToStr(iFolha) );

      SQL.Add('  AND (f.co_empresa = fp.co_empresa)' );

      if iFuncionario <> -1 then
        SQL.Add(' AND f.co_funcionario = '+IntToStr(iFuncionario) );

      if sLotacao <> '' then
        SQL.Add(' AND f.co_lotacao LIKE '+QuotedStr(sLotacao+'%') );

      if sTipo <> '' then
        SQL.Add(' AND f.co_tipo_funcionario = '+QuotedStr(sTipo) );

      if iRecurso <> -1 then
        SQL.Add(' AND f.recurso = '+IntToStr(iRecurso) );

      if sCargo <> '' then
        SQL.Add(' AND f.co_cargo = '+QuotedStr(sCargo) );

      SQL.Add('  AND (ff.co_funcionario = F.co_funcionario) AND');
      SQL.Add('  ( (ff.gozo_1 >= fp.dt_inicio) AND (ff.gozo_1 <= fp.dt_fim) )');

      SQL.Add('ORDER BY');
      if sOrdem = 'N' then SQL.Add('  f.no_funcionario')
                      else SQL.Add('  f.co_funcionario');

      SQL.EndUpdate;

      Open;

    end;

  finally
    Screen.Cursor := tmpCursor;
  end;

end; // function Processa

procedure TFrmAvisoPrevioFerias.TbCustomReport1Generate(Sender: TObject);

const
  FMT_REF   = '###,###.##';
  FMT_VALOR = '###,##0.00';

var
  bInicio: Boolean;

  function Formata(const Format: string; Value: Extended): string;
  begin
    Result := FormatFloat( Format, Value);
    Result := PadLeftChar( Result, Length(Format), #32);
  end;

  procedure ProcessaoAviso( Funcionario: Integer);
  var
    lTexto, lCheque: TStringList;
    l, c, i:  Integer;
    sMetaDado, sRealDado, sLinhaTexto: String;
    cTotalVantagem, cTotalDesconto, cLiquido: Currency;

  begin

    lTexto  := TStringList.Create;
    lCheque := TStringList.Create;

    try

      with QryCheque do begin

        Close;
        Parameters[0].Value := Funcionario;
        Open;

        First;

        cTotalVantagem := 0;
        cTotalDesconto := 0;

        while not EOF do begin

          if (Fields[0].AsString = 'V') then begin
            cTotalVantagem := cTotalVantagem + Fields[4].AsCurrency;
            lCheque.Add( Fields[1].AsString+' '+
                         PadRightChar( Fields[2].AsString, 30, #32)+' '+
                         Formata( FMT_REF, Fields[3].AsCurrency)+' '+
                         Formata( FMT_VALOR, Fields[4].AsCurrency)+' '+
                         Formata( FMT_REF, 0) );
          end else begin
            cTotalDesconto := cTotalDesconto + Fields[4].AsCurrency;
            lCheque.Add( Fields[1].AsString+' '+
                         PadRightChar( Fields[2].AsString, 30, #32)+' '+
                         Formata( FMT_REF, Fields[3].AsCurrency)+' '+
                         Formata( FMT_REF, 0)+' '+
                         Formata( FMT_VALOR, Fields[4].AsCurrency) );
          end;

          Next;

        end;  // while not EOF

        cLiquido := cTotalVantagem-cTotalDesconto;

      end;  // with QryContraCheque

      with QryDados do begin

        Close;
        Parameters[0].Value := Funcionario;
        Open;

        if (RecordCount = 0) then
          Exit;

        lTexto.LoadFromFile('AvisoFerias.txt');

        for l := 0 to (lTexto.Count - 1) do begin

          sLinhaTexto := lTexto.Strings[l];

          for c := 0 to (Fields.Count - 1) do begin

            sMetaDado := '&'+UpperCase(Fields[c].FieldName)+'&';
            sRealDado := Fields[c].AsString;

            if (Pos( sMetaDado, sLinhaTexto) > 0) then begin

              case Fields[c].DataType of
                ftDateTime,ftDate:
                  if ( Fields[c].IsNull or (Fields[c].AsDateTime = 0)) then
                    sRealDado := '  /  /    ';
                ftFloat, ftCurrency, ftBCD:
                  sRealDado := FormatFloat( FMT_VALOR, Fields[c].AsFloat);
              end;  // case of

              sLinhaTexto := Substitui( sLinhaTexto, sMetaDado, sRealDado);

            end;  // if Pos > 0

            lTexto.Strings[l] := sLinhaTexto;

          end;  // for c := 0

          if ( Pos( '&CONTRA_CHEQUE&', sLinhaTexto) > 0) then begin

            lTexto.Delete(l);

            for c := 0 to lCheque.Count - 1 do
              lTexto.Insert( l+c, lCheque[c]);

          end else begin

            sMetaDado := '&VANTAGEM&';

            if (Pos( sMetaDado, sLinhaTexto) > 0) then begin
              sRealDado := Formata( FMT_REF, cTotalVantagem);
              sLinhaTexto := Substitui( sLinhaTexto, sMetaDado, sRealDado);
            end;

            sMetaDado := '&DESCONTO&';

            if (Pos( sMetaDado, sLinhaTexto) > 0) then begin
              sRealDado := Formata( FMT_REF, cTotalDesconto);
              sLinhaTexto := Substitui( sLinhaTexto, sMetaDado, sRealDado);
            end;

            sMetaDado := '&LIQUIDO&';

            if (Pos( sMetaDado, sLinhaTexto) > 0) then begin
              sRealDado := Formata( FMT_REF, cLiquido);
              sLinhaTexto := Substitui( sLinhaTexto, sMetaDado, sRealDado);
            end;

            sMetaDado := '&LIQUIDO_EXTENSO&';

            if (Pos( sMetaDado, sLinhaTexto) > 0) then begin
              sRealDado := UpperCase( Extenso(cLiquido));
              sLinhaTexto := Substitui( sLinhaTexto, sMetaDado, sRealDado);
            end;

            lTexto.Strings[l] := sLinhaTexto;

          end;

        end; // for

      end;

      for i := 0 to ( lTexto.Count - 1) do
        TbCustomReport1.Printer.EscribirStd( 1, i+2, lTexto[i]);


    finally
      lTexto.Free;
      lCheque.Free;
    end;

  end;

begin

  with qryListagem do begin
    First;
    bInicio := True;

    while not EOF do begin

      if bInicio then TbPrinter1.Comenzar
                 else TbPrinter1.NuevaPagina;

      bInicio := False;

      ProcessaoAviso( Fields[0].AsInteger);


      Next;

    end;

  end;

end;

end.
