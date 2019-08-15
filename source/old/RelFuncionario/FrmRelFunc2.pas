unit FrmRelFunc2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Forms, Controls, Dialogs,
  StdCtrls, Mask, ExtCtrls, ADODB, TbPrint, Db, kbmMemTable;

type
  TfrmRel = class(TForm)
    tbl: TkbmMemTable;
    tblco_funcionario: TIntegerField;
    tblco_lotacao: TStringField;
    tblco_cargo: TIntegerField;
    tblno_cargo: TStringField;
    tblvr_salario: TCurrencyField;
    tblco_tipo_funcionario: TStringField;
    tblds_tipo_funcionario: TStringField;
    tblno_funcionario: TStringField;
    tblno_lotacao: TStringField;
    tbldt_admissao: TDateField;
    TbPrinter1: TTbPrinter;
    TbCustomReport1: TTbCustomReport;
    procedure TbCustomReport1Generate(Sender: TObject);
  private
    { Private declarations }
    function Processa:Boolean;
  public
    { Public declarations }
  end;

procedure ImprimeFuncionario( Conexao: TADOConnection;
  Empresa: String; Recurso: Integer;
  Lotacao, Tipo, Cargo, Ordem: String;
  Salario, Demitido, Ativo, Imprimir: Boolean);

implementation

uses Util2;

{$R *.DFM}

var
  qryEmpresa, qryFunc: TADOQuery;
  sEmpresa, sLotacao, sTipo, sCargo: String;
  iRecurso: Integer;
  sOrdem: String;
  bSalario, bDemitido, bAtivo: Boolean;

function TfrmRel.Processa:Boolean;
var
  i: Integer;
  tmpCursor: TCursor;
begin

  tmpCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;

  try

    with qryEmpresa do  begin
      Close;
      Parameters[0].Value := sEmpresa;
      Open;
    end;  // with qryEmpresa

    with qryFunc do begin

      Close ;
      SQL.BeginUpdate;
      SQL.Clear ;
      SQL.Add('SELECT');
      SQL.Add('  F.co_funcionario, F.no_funcionario, F.num_cpf,');
      SQL.Add('  F.dt_admissao, F.vr_salario, F.num_carga_horaria,');
      SQL.Add('  F.co_lotacao, L.no_lotacao, ');
      SQL.Add('  F.co_tipo_funcionario, T.ds_tipo_funcionario,');
      SQL.Add('  F.co_cargo, C.no_cargo');
      SQL.Add('FROM');
      SQL.Add('  funcionario F,');
      SQL.Add('  cargo C, lotacao L, tipo_funcionario T');
      SQL.Add('WHERE');
      SQL.Add('  F.co_empresa = '+QuotedStr(sEmpresa) );

      if sLotacao <> '' then
        SQL.Add(' AND F.co_lotacao LIKE '+QuotedStr( Trim(sLotacao)+'%' ) );

      if sTipo <> '' then
        SQL.Add(' AND F.co_tipo_funcionario = '+QuotedStr(sTipo) );

      if iRecurso <> -1 then
        SQL.Add(' AND F.recurso = '+IntToStr(iRecurso) );

      if sCargo <> '' then
        SQL.Add(' AND F.co_cargo = '+QuotedStr(sCargo) );

      if (not bDemitido) and bAtivo then      // Somente ativo
        SQL.Add( '  AND (F.dt_rescisao IS NULL)')

      else if (bDemitido) and (not bAtivo) then
        SQL.Add( '  AND (F.dt_rescisao IS NOT NULL)');

      SQL.Add('  AND (C.co_cargo = F.co_cargo)');
      SQL.Add('  AND (L.co_empresa = F.co_empresa)');
      SQL.Add('  AND (L.co_lotacao = F.co_lotacao)');
      SQL.Add('  AND (T.co_tipo_funcionario = F.co_tipo_funcionario)');

      SQL.Add('ORDER BY');
      if sOrdem = 'N' then
        SQL.Add('  F.no_funcionario')
      else
        SQL.Add('  F.co_funcionario');

      SQL.EndUpdate;

      Open;

      if not tbl.Active then
        tbl.Open;

      First;

      while not EOF do begin

        tbl.Append;

        for i := 0 to Fields.Count - 1 do
          if tbl.FindField( Fields[i].FieldName) <> NIL then
            tbl.FieldByName( Fields[i].FieldName).Value := Fields[i].Value;

        tbl.Post;

        Next;

      end;

    end;

    Result := True;

  finally
    Screen.Cursor := tmpCursor;
  end;

end; // function Processa

//===========================================================

procedure ImprimeFuncionario( Conexao: TADOConnection;
  Empresa: String; Recurso: Integer;
  Lotacao, Tipo, Cargo, Ordem: String; Salario, Demitido, Ativo, Imprimir: Boolean);
var
  frm: TFrmRel;
begin

  frm := TFrmRel.Create(Application);

  qryEmpresa := TADOQuery.Create(Application);
  qryFunc    := TADOQuery.Create(Application);

  try

    with qryEmpresa do begin
      Connection := Conexao;
      SQL.Clear;
      SQL.BeginUpdate;
      SQL.Add('SELECT * FROM EMPRESA');
      SQL.Add('WHERE co_empresa = :empresa');
      SQL.EndUpdate;
    end;

    qryFunc.Connection  := Conexao;

    sEmpresa  := Empresa;
    iRecurso  := Recurso;
    sLotacao  := Lotacao;
    sTipo     := Tipo;
    sCargo    := Cargo;
    sOrdem    := Ordem;
    bSalario  := Salario;
    bDemitido := Demitido;
    bAtivo    := Ativo;
    
    with Frm do begin
      tblvr_salario.Tag := Iif( Salario, 1, 0);
      Processa;
      TbPrinter1.Preview := not Imprimir;
      TbCustomReport1.Execute;
    end;

  finally
    Frm.Free;
    qryEmpresa.Free;
    qryFunc.Free;
  end;

end;


procedure TfrmRel.TbCustomReport1Generate(Sender:TObject);
var
  i, iQtde, Margem, PaginaAtual, LinhaAtual: Integer;
  NumeraPaginas, MostraHora: Boolean;
  Titulo, SubTitulo, Texto, ValorDoCampo: String;
  LinhaTitulo, ColunaTitulo, MargemDireita: Integer;
  LinhaSubTitulo, ColunaSubTitulo: Integer;
  SeparaColuna, LinhaPorPagina: Integer;
  Campo: TField;
  cTotal: Currency;

  procedure Escreve( Linha, Coluna:Byte; Texto: String);
  begin
    with  TbCustomReport1.Printer do
     Escribir( Coluna, Linha, Texto, FastFont );
  end;

  procedure Cabecalho;
  var
    TituloCampo: String;
    i : integer;
  begin

    if (PaginaAtual = 0) or (LinhaAtual > LinhaPorPagina) then begin
      TbCustomReport1.Printer.NuevaPagina;
      PaginaAtual := PaginaAtual + 1;
    end else
      Exit;

    Escreve( 1, Margem, TbCustomReport1.Printer.CompanyData);

    if NumeraPaginas then
      Escreve( 2, Margem, 'Pag. '+FormatFloat('000',PaginaAtual));

    if MostraHora then
      Escreve( 2, MargemDireita-16, FormatDateTime('dd/mm/yy - hh:nn',Now) );

    LinhaAtual := 2;

    if Titulo <> '' then begin
      if ColunaTitulo > 0 then
        Escreve( LinhaTitulo, ColunaTitulo, Titulo )
      else
        Escreve( LinhaTitulo,
                (MargemDireita-Margem-Length(Titulo)) div 2, Titulo );
      LinhaAtual := LinhaTitulo;
    end;

    if SubTitulo <> '' then begin
      if ColunaSubTitulo > 0 then
        Escreve( LinhaSubTitulo, ColunaSubTitulo, SubTitulo)
      else
        Escreve( LinhaSubTitulo,
                (MargemDireita-Margem-Length(SubTitulo)) div 2, SubTitulo );
      LinhaAtual := LinhaSubTitulo;
    end;  // HAY SUBTITULO

    Escreve( LinhaAtual+1, Margem, Replicate('-', MargemDireita)) ;

    LinhaAtual := LinhaAtual+2;
    TituloCampo := '';
    Texto       := '';

    for i := 0 to (tbl.Fields.Count-1) do begin
      Campo := tbl.Fields[i];
      if Campo.Tag = 1 then begin
        TituloCampo := Campo.DisplayLabel;
        if Campo.Alignment = taRightJustify then
          TituloCampo := PadLeftChar( TituloCampo, Campo.DisplayWidth, #32)
        else if Campo.Alignment = taLeftJustify then
          TituloCampo := PadRightChar( TituloCampo, Campo.DisplayWidth, #32);
        Texto := Texto + TituloCampo+StringOfChar( #32, SeparaColuna);
      end;
    end;

    Escreve( LinhaAtual, Margem, Texto );
    Escreve( LinhaAtual+1, Margem, Replicate('-', MargemDireita)) ;

    LinhaAtual := LinhaAtual+2;

  end;

begin

  LinhaPorPagina := 63;
  SeparaColuna := 2;
  Titulo := 'RELATORIO DE FUNCIONARIO';
  SubTitulo := 'PREFEITURA MUNICIPAL DE MOCAJUBA';
  PaginaAtual := 0;
  MostraHora := true;
  NumeraPaginas := True;
  LinhaSubTitulo := 3;
  LinhaTitulo := 2;
  ColunaTitulo := 0;
  ColunaSubTitulo := 0;
  MargemDireita := 132;
  iQtde := 0;
  cTotal := 0;

  with tbl do begin

    First;

    while not EOF do begin

      Cabecalho();

      Inc(iQtde);
      cTotal := cTotal + FieldByName('vr_salario').AsCurrency;
      
      Texto := '';
      for i := 0 to (Fields.Count-1) do
        if (Fields[i].Tag = 1) then begin

          if (Fields[i] is TNumericField) and
             ( TNumericField(Fields[i]).DisplayFormat <> '') then
            ValorDoCampo := FormatFloat( TNumericField(Fields[i]).DisplayFormat,
                                        Fields[i].AsFloat )
          else
            ValorDoCampo := Fields[i].AsString;

          if Fields[i].Alignment = taRightJustify then
            ValorDoCampo := PadLeftChar( ValorDoCampo,
                                 Fields[i].DisplayWidth, #32)
          else if Fields[i].Alignment = taLeftJustify then
            ValorDoCampo := PadRightChar( ValorDoCampo,
                                 Fields[i].DisplayWidth, #32);

          Texto := Texto + ValorDoCampo+StringOfChar( #32, SeparaColuna);
        end;

      Escreve( LinhaAtual, Margem, Texto);
      LinhaAtual := LinhaAtual + 1;

      Next;

    end;  // while

    Escreve( LinhaAtual+1, Margem, '   Qtde de Funcionarios: '+IntToStr(iQtde) );
    Escreve( LinhaAtual+2, Margem, '   Total de Salarios   : '+FormatFloat( ',0.00', cTotal) );

  end; // with

end;

end.
