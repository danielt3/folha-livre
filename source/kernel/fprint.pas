{
Projeto FolhaLivre - Folha de Pagamento Livre
Copyright (c) 2002-2007 Allan Lima

Este programa é um software de livre distribuição, que pode ser copiado e
distribuído sob os termos da Licença Pública Geral GNU, conforme publicada
pela Free Software Foundation, versão 2 da licença ou qualquer versão posterior.

Este programa é distribuído na expectativa de ser útil aos seus usuários,
porém  NÃO TEM NENHUMA GARANTIA, EXPLÍCITAS OU IMPLÍCITAS,
COMERCIAIS OU DE ATENDIMENTO A UMA DETERMINADA FINALIDADE.

Consulte a Licença Pública Geral GNU para maiores detalhes.

@autor-name: Allan Lima
@autor-email: allan_kardek@yahoo.com.br
@project-email: folha_livre@yahoo.com.br
}

unit fprint;

{$I flivre.inc}

interface

uses
  SysUtils, Classes,
  {$IFDEF MSWINDOWS}Windows, Messages,{$ENDIF}
  {$IFDEF LINUX}Midas,{$ENDIF}
  {$IFDEF VCL}
  Graphics, Controls, Forms, Dialogs, ExtCtrls, Printers, DBGrids, AKPrint,
  {$ENDIF}
  {$IFDEF CLX}
  QGraphics, QControls, QForms, QDialogs, QExtCtrls, QPrinters, QDBGrids, QAKPrint,
  {$ENDIF}
  {$IFDEF FL_MIDASLIB}MidasLib,{$ENDIF}
  DB, dbClient, fdepvar, Variants, MaskUtils;

type
  TFrmPrint = class(TComponent)
  protected
    { Private declarations }
    procedure CustomReportGenerate( Sender: TObject);
  private
    { Private declarations }
    FReport: TTbCustomReport;
    FPrinter: TTbPrinter;
    FDeposito: TDeposito;
    FTitle: String;
    FSubTitle: String;
    procedure SetDeposito( Deposito: TDeposito);
    procedure SetReport( Report: TTbCustomReport);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
//    procedure Assign(Source: TFrmPrint); override;
    property Deposito: TDeposito read FDeposito write SetDeposito;
    property Report: TTbCustomReport read FReport write SetReport;
    property Title: String read FTitle write FTitle;
    property SubTitle: String read FSubTitle write FSubTitle;
  end;

  TFrmPrintLines = class(TComponent)
  protected
    { Private declarations }
    procedure CustomReportGenerate(Sender: TObject);
  private
    { Private declarations }
    FReport: TTbCustomReport;
    FPrinter: TTbPrinter;
    FLines: TStringList;
    procedure SetReport( Report: TTbCustomReport);
    procedure SetLines(Lines:TStringList);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Report: TTbCustomReport read FReport write SetReport;
    property Lines: TStringList read FLines write SetLines;
    procedure Preview;
    procedure Print;
  end;

function kPrint( DataSet: TDataSet;
  Print: Boolean; Dep: TDeposito):Boolean;stdcall;

function kPrintGrid( Grid: TDBGrid; Titulo: String;
  Printer: Boolean; Dep: TDeposito):Boolean;stdcall;

function kPrintDataSet( DataSet: TDataSet; Titulo: String;
  Imprimir: Boolean; SubTotal: Boolean = True; Total: Boolean = True):Boolean;

procedure ReportGenerate( Sender: TObject; Dep: TDeposito);

implementation

uses
  fempresa, ftext;

function kPrintDataSet( DataSet: TDataSet; Titulo: String;
  Imprimir: Boolean; SubTotal: Boolean = True; Total: Boolean = True):Boolean;
var
  Dep: TDeposito;
begin

  Dep := TDeposito.Create;

  try
    Dep.SetDeposito('TITULO', Titulo);
    Dep.SetDeposito('SUBTOTAL', SubTotal);
    Dep.SetDeposito('TOTAL', Total);
    Result := kPrint( DataSet, Imprimir, Dep);
  finally
    Dep.Free;
  end;

end;

function kPrint( DataSet: TDataSet; Print: Boolean; Dep: TDeposito):Boolean;
var
  Frm: TFrmPrint;
begin

  if (DataSet.RecordCount = 0) then
  begin
    Result := False;
    kErro('Não há registro a serem impressos. Verifique');
    Exit;
  end;

  Frm := TFrmPrint.Create(NIL);

  try try

    with Frm do
    begin
      Deposito := Dep;
      Report.Printer.Preview := not Print;
      Report.DataSet := DataSet;
      Report.OnGenerate := CustomReportGenerate;
      Report.Printer.Zoom := zReal;
      Report.Execute;
      Result := True;
    end;  // with frm

  except
    on E:Exception do
    begin
      Result := False;
      MessageDlg( 'Relatório '#13#13+E.Message, mtError, [mbOK], 0);
    end;
  end;

  finally
    Frm.Free;
  end;

end;

function kPrintGrid( Grid: TDBGrid; Titulo: String;
  Printer: Boolean; Dep: TDeposito):Boolean;
var
  i: Integer;
  _Dep: TDeposito;
  sFieldName: String;
begin

  for i := 0 to Grid.DataSource.DataSet.Fields.Count -1 do
    Grid.DataSource.DataSet.Fields[i].Tag := 0;  // Nao imprimir

  for i := 0 to ( Grid.Columns.Count-1) do
  begin
    sFieldName := Grid.Columns[i].FieldName;
    with Grid.DataSource.DataSet.FindField(sFieldName) do
    begin
      Tag := 1;
      DisplayLabel := Grid.Columns[i].Title.Caption;
      if (Grid.Columns[i].DropDownRows > 0) and
         (Grid.Columns[i].DropDownRows <> 7) then
        DisplayWidth := Grid.Columns[i].DropDownRows;
    end;
  end;

  if Assigned(Dep) then
    Result := kPrint( Grid.DataSource.DataSet, Printer, Dep)
  else begin
    _Dep := TDeposito.Create;
    try
      _Dep.SetDeposito( 'TITULO', Titulo);
      _Dep.SetDeposito( 'MARGEM_DIREITA', 80);
      _Dep.SetDeposito( 'COMPRIMIDO', False);
      Result := kPrint( Grid.DataSource.DataSet, Printer, _Dep);
    finally
      _Dep.Free;
    end;
  end;

end;

constructor TFrmPrint.Create(AOwner: TComponent);
begin
  inherited;
  FPrinter := TTbPrinter.Create(Self);
  FReport := TTbCustomReport.Create(Self);
  FReport.Printer := FPrinter;
  FDeposito := TDeposito.Create;
end;

destructor TFrmPrint.Destroy;
begin
  FDeposito.Free;
  FReport.Free;
  FPrinter.Free;
  inherited;
end;

procedure TFrmPrint.SetDeposito(Deposito: TDeposito);
begin
  if (FDeposito <> Deposito) then
    FDeposito.Assign(Deposito);
end;

procedure TFrmPrint.SetReport(Report: TTbCustomReport);
begin
  if (FReport <> Report) then
    FReport.Assign(Report);
end;

procedure TFrmPrint.CustomReportGenerate( Sender: TObject);
begin
  ReportGenerate( Sender, Deposito);
end;  // proc TbCustomReport1Generate

procedure ReportGenerate( Sender: TObject; Dep: TDeposito);
var
  i, iFlag, iDetalheFlag,
  iLinhaFinal, NumeroColuna: Integer;
  LinhaFinal, SeparaLinha: String;
  mtTotal: TClientDataSet;
  ListGrupo: TList;
  varGrupo: array[0..9] of Variant;
  varField: array[0..9] of Integer;
  bk: TBookmark;

  pvEmpresa, pvLoja: String;
  pvNegrito, pvSublinhado, pvComprimido, pvItalico,
  pvSubTotal, pvTotal,
  pvEscreveSistema, { allan_lima 23/11/2006 }
  pvSepQuebra: Boolean;  { Recurso implementado em 12/03/2002 - Mocajuba }

  function Report: TTbCustomReport;
  begin
    Result := TTbCustomReport(Sender);
  end;

  function RepData: TDataSet;
  begin
    Result := Report.DataSet;
  end;

  function Printer: TAKPrinter;
  begin
    Result := Report.Printer;
  end;

  function IsGrupo:Boolean;
  var i: Integer;
  begin
    Result := False;
    for i := 0 to ListGrupo.Count-1 do
      if Assigned(ListGrupo[i]) then
      begin
        Result := True;
        Break;
      end;
  end;

  procedure Escreve( Linha, Coluna: Byte; Texto: String;
    ProximaLinha: Boolean = False);
  begin
    with Printer do
    begin
      Escribir( Coluna, Linha, Texto, FastFont);
      if ProximaLinha then LineaActual := LineaActual + 1;
    end;
  end;

  procedure Escreve2( Linha, Coluna:Byte; Texto: String; Fonte: TFuente;
    ProximaLinha: Boolean = False);
  begin
    with Printer do
    begin
      Escribir( Coluna, Linha, Texto, Fonte );
      if ProximaLinha then LineaActual := LineaActual + 1;
    end;
  end;

  procedure EscreveLinha( Texto: Char = '-');
  begin
    Escreve( Printer.LineaActual, Printer.MargenIzquierdo,
             Replicate( Texto, NumeroColuna), True) ;
  end;  // EscreveLinha

  procedure EscreveDetalhe( Detalhe, Total: TDataSet; SubTotal: TList);
  var
    Texto, FieldName, ValorDoCampo: String;
    Valor: Double;
    i, t: Integer;
  begin

    Texto := '';

    if Assigned(Total) then
      Total.Edit;

    if Assigned(SubTotal) and (SubTotal.Count > 0) then
      for t := 0 to SubTotal.Count-1 do
        if Assigned(SubTotal[t]) then
          TDataSet(SubTotal[t]).Edit;

    with Detalhe do
    begin

      for i := 0 to (Fields.Count-1) do
      begin

        if (Fields[i].Tag = 1) then
        begin

          FieldName := Fields[i].FieldName;

          if (Fields[i] is TNumericField) then
          begin

            Valor := Fields[i].AsFloat;  // Atualiza acumuladores

            if Assigned(Total) and Assigned(Total.FindField(FieldName)) then
            begin
              try
                Total.FieldByName(FieldName).AsFloat :=
                   Total.FieldByName(FieldName).AsFloat + Valor;
              except
                // Os erros aqui normalmente sao o estouro de limite
                Total.FieldByName(FieldName).AsFloat := 0.0;
              end;
            end;

            if Assigned(SubTotal) and (SubTotal.Count > 0) then
              for t := 0 to SubTotal.Count-1 do
                if Assigned(SubTotal[t]) and
                   Assigned( TDataSet(SubTotal[t]).FindField(FieldName)) then
                  try
                    TDataSet(SubTotal[t]).FieldByName(FieldName).AsFloat :=
                      TDataSet(SubTotal[t]).FieldByName(FieldName).AsFloat + Valor;
                  except
                    // Os erros aqui normalmente sao o estouro de limite
                    TDataSet(SubTotal[t]).FieldByName(FieldName).AsFloat := 0;
                  end;

            if ( TNumericField(Fields[i]).DisplayFormat <> '') then
              ValorDoCampo := FormatFloat( TNumericField(Fields[i]).DisplayFormat, Valor)
            else
              ValorDoCampo := Fields[i].Text;

          end else
          begin
            ValorDoCampo := Fields[i].Text;
            if (Fields[i] is TStringField) and (Fields[i].EditMask <> '')
              then ValorDoCampo := FormatMaskText(Fields[i].EditMask, ValorDoCampo);
          end;

          if (Length(ValorDoCampo) > 0) then
          begin  // Atualiza contadores
            if Assigned(Total) and Assigned(Total.FindField(FieldName)) then
              Total.FieldByName(FieldName).Tag := Total.FieldByName(FieldName).Tag + 1;
            if Assigned(SubTotal) and (SubTotal.Count > 0) then
              for t := 0 to SubTotal.Count-1 do
                if Assigned(SubTotal[t]) and
                   Assigned( TDataSet(SubTotal[t]).FindField(FieldName)) then
                  TDataSet(SubTotal[t]).FieldByName(FieldName).Tag :=
                    TDataSet(SubTotal[t]).FieldByName(FieldName).Tag + 1;
          end;

          if (Fields[i].Alignment = taRightJustify) then
            ValorDoCampo := PadLeftChar( ValorDoCampo, Fields[i].DisplayWidth)
          else if (Fields[i].Alignment = taLeftJustify) then
            ValorDoCampo := PadRightChar( ValorDoCampo, Fields[i].DisplayWidth)
          else
            ValorDoCampo := PadCenter( ValorDoCampo, Fields[i].DisplayWidth);

          Texto := Texto + ValorDoCampo + Printer.SeparacionColumnas;

        end;  // if

      end;  // for i := 0

    end;  // with Detalhe

    if Assigned(Total) then
      Total.Post;

    if Assigned(SubTotal) and (SubTotal.Count > 0) then
      for t := 0 to SubTotal.Count-1 do
        if Assigned(SubTotal[t]) then
          TDataSet(SubTotal[t]).Post;

    Escreve( Printer.LineaActual, Printer.MargenIzquierdo, Texto, True);

    iDetalheFlag := 1;  // Sinaliza que se estar imprimindo o detalhe

    if (SeparaLinha <> '') then
      Escreve( Printer.LineaActual, Printer.MargenIzquierdo,
               Replicate( SeparaLinha, NumeroColuna), True);

  end;  // proc EscreveDetalhe

  procedure CabecalhoGrupo( Grupo: Integer);
  var
    Texto, ValorDoCampo: String;
    i : integer;
  begin

    varGrupo[Grupo] := RepData.Fields[varField[Grupo]].Value;
    Texto  := '';

    with RepData do
    begin
      for i := 0 to (Fields.Count-1) do
      begin

        if (Fields[i].Tag = Grupo) then
        begin

          if (Fields[i] is TNumericField) then
          begin
            if (TNumericField(Fields[i]).DisplayFormat <> '') then
               ValorDoCampo := FormatFloat(
                     TNumericField(Fields[i]).DisplayFormat, Fields[i].AsFloat)
             else
               ValorDoCampo := Fields[i].AsString;
          end else
            ValorDoCampo := Fields[i].AsString;

          Texto := Texto + #32;

          if (Pos( '%', Fields[i].DisplayLabel) > 0) then
            Texto := Texto + Format( Fields[i].DisplayLabel, [ValorDoCampo] )
          else if (Trim(Fields[i].DisplayLabel) = EmptyStr) then
            Texto := Texto + PadCenter( ValorDoCampo,
                                        Printer.MargenDerecho-Printer.MargenIzquierdo)
          else
            Texto := Texto + Fields[i].DisplayLabel + #32 + ValorDoCampo;

        end;  // if

      end;  // for
    end; // with

    if (Printer.MargenDerecho = 132) then
      Escreve( Printer.LineaActual, Printer.MargenIzquierdo, Texto, True)
    else
      Escreve2( Printer.LineaActual,
                Printer.MargenIzquierdo, Texto, [Negrita], True );

    EscreveLinha;

  end;  // procedure CabecalhoGrupo

  procedure PrintCabecalhoGrupo;
  var i: Integer;
  begin
    for i := 0 to ListGrupo.Count-1 do
      if Assigned(ListGrupo[i]) then
         if (RepData.Fields[varField[i]].Value <> varGrupo[i]) then // O grupo foi quebrado?
           CabecalhoGrupo(i);
  end;  // procedure PrintCabecalhoGrupo

  procedure CabecalhoColunas( DataSet: TDataSet);
  var
    Titulo, Texto: String;
    i, iPos: Integer;
    Campo: TField;
  begin

    Titulo := '';
    Texto  := '';

    for i := 0 to (DataSet.Fields.Count-1) do
    begin
      Campo := DataSet.Fields[i];
      if (Campo.Tag = 1) then
      begin
        Titulo := Campo.DisplayLabel;
        iPos := Pos( ';', Titulo);
        if iPos > 0 then
          Delete( Titulo, iPos, Length(Titulo));
        if Titulo = '.' then Titulo := '';
        if Campo.Alignment = taRightJustify then
          Titulo := PadLeftChar( Titulo, Campo.DisplayWidth)
        else if Campo.Alignment = taLeftJustify then
          Titulo := PadRightChar( Titulo, Campo.DisplayWidth)
        else
          Titulo := PadCenter( Titulo, Campo.DisplayWidth);

        Texto := Texto + Titulo + Printer.SeparacionColumnas;

      end;
    end;  // for

    Escreve( Printer.LineaActual, Printer.MargenIzquierdo, Texto, True);

    EscreveLinha;

  end;  // procedure CabecalhoColunas

  procedure Cabecalho;
  var
    sTexto, sSistema, sData: String;
    bTitle: Boolean;
  begin

    if (Printer.LineaActual = 0) or
       (Printer.LineaActual >= Printer.LineaPiePagina) then
      Report.Printer.NuevaPagina
    else
      Exit;

    iDetalheFlag := 0;
    Printer.LineaActual := 2;
    sTexto := '';
    sData := '';

    {$IFDEF FLIVRE}
    sSistema := 'FolhaLivre - Folha de Pagamento Livre';
    {$ELSE}
    sSistema := kGetEmpresa( 'SISTEMA', 30);
    {$ENDIF}

    if Printer.EscribirData then
      sData := FormatDateTime('dd/mm/yyyy', Now);

    if Printer.EscribirHora then
      sData := sData + ' ' + FormatDateTime('hh:nn', Now);

    if Printer.EscribirPaginas then
      sData := sData + ' Pag: '+FormatFloat( '000', Printer.PaginaActual);

    if pvEscreveSistema then
      sTexto := sSistema;

    if (sData <> '') then
      sTexto := sTexto + kEspaco(NumeroColuna-Length(sTexto+sData)) + sData;

    if sTexto <> '' then
      Escreve( Printer.LineaActual, Printer.MargenIzquierdo, sTexto, True);

    if (pvEmpresa <> '') then
      if (Printer.MargenDerecho = 132) then
        Escreve( Printer.LineaActual, Printer.MargenIzquierdo, pvEmpresa, True)
      else
        Escreve2( Printer.LineaActual, Printer.MargenIzquierdo, pvEmpresa, [Negrita], True);

    if (pvLoja <> '') then
      Escreve( Printer.LineaActual, Printer.MargenIzquierdo, pvLoja, True);

    EscreveLinha;

    bTitle := False;

    if (Printer.Title <> '') then
    begin
      sTexto := PadCenter( Printer.Title, NumeroColuna);
      if (Printer.MargenDerecho = 132) then
        Escreve( Printer.LineaActual, Printer.MargenIzquierdo, sTexto, True )
      else
        Escreve2( Printer.LineaActual, Printer.MargenIzquierdo, sTexto, [Negrita], True );
      bTitle := True;
    end;

    if (Printer.SubTitulo <> '') then
    begin
      sTexto := PadCenter( Printer.SubTitulo, NumeroColuna);
      if (Printer.MargenDerecho = 132) then
        Escreve( Printer.LineaActual, Printer.MargenIzquierdo, sTexto, True)
      else
        Escreve2( Printer.LineaActual, Printer.MargenIzquierdo, sTexto, [Negrita], True);
      bTitle := True;
    end;

    if bTitle then
      EscreveLinha;

    CabecalhoColunas(RepData);

  end;  // procedure Cabecalho

  procedure ImprimeTotal( DataSet: TDataSet; const Grupo: Integer; PrintLine: Boolean = False);
  var
    sTexto, sCampo, sFormat, sFieldName, sTitulo: String;
    i, iGrupo: Integer;
    fValor: Double;
    stCaption: TStringList;

    function MaxGrupo: Integer;
    var i: Integer;
    begin
      Result := 1;
      for i := 0 to ListGrupo.Count-1 do
        if Assigned(ListGrupo[i]) then
          Result := i;
    end;

    function Total:TDataSet;
    begin
      if (Grupo = 0) then Result := mtTotal
                     else Result := TDataSet(ListGrupo[Grupo]);
    end;

  begin

    sTexto := '';
    sCampo := '';

    stCaption := TStringList.Create;

    for i := 0 to (DataSet.Fields.Count-1) do
    begin

      if (DataSet.Fields[i].Tag <> 1) then
        Continue;

      sTitulo    := DataSet.Fields[i].DisplayLabel;
      sFieldName := DataSet.Fields[i].FieldName;
      sCampo     := '';

      if (DataSet.Fields[i].DataType in [ftDateTime, ftDate]) then
        //
      else if (DataSet.Fields[i] is TNumericField) then
      begin
        // Totalizador
        if Assigned(Total.FindField(sFieldName)) then
        begin
          fValor  := Total.FieldByName(sFieldName).AsFloat;
          sCampo  := Total.FieldByName(sFieldName).AsString;
          sFormat := TNumericField(DataSet.Fields[i]).DisplayFormat;
          if (sFormat <> '') then
            sCampo := FormatFloat( sFormat, fValor);
        end;
      end else
      begin
        // Contador
        if Assigned(Total.FindField(sFieldName)) then
          sCampo := IntToStr( Total.FieldByName(sFieldName).Tag);
      end;

      kBreakApart( sTitulo, ';', stCaption);

      iGrupo := Grupo;

      if (iGrupo = 0) then
        iGrupo := MaxGrupo() + 1;

      if (stCaption.Count >= iGrupo) then
      begin
        if (Length(stCaption[iGrupo-1]) > 0) then
          sCampo := Format( stCaption[iGrupo-1], [sCampo])
        else
          sCampo := '';
      end;

      if (Length(sCampo) > DataSet.Fields[i].DisplayWidth) or (Trim(sTitulo) = '') then
        sCampo := '';

      if (DataSet.Fields[i].Alignment = taRightJustify) then
        sCampo := PadLeftChar( sCampo, DataSet.Fields[i].DisplayWidth)
      else if (DataSet.Fields[i].Alignment = taLeftJustify) then
        sCampo := PadRightChar( sCampo, DataSet.Fields[i].DisplayWidth)
      else
        sCampo := PadCenter( sCampo, DataSet.Fields[i].DisplayWidth);

      sTexto := sTexto + sCampo + kEspaco(Length(Printer.SeparacionColumnas));

    end;  // for

    stCaption.Free;
    sTexto := PadRightChar( sTexto, NumeroColuna, ' ');

    if (Trim(sTexto) <> EmptyStr) then
    begin
      Escreve( Printer.LineaActual, Printer.MargenIzquierdo, sTexto, True);
      EscreveLinha;
    end;

    // Fecha e recria o ClientDataSet para zerar os totalizadores
    TClientDataSet(Total).Close;
    TClientDataSet(Total).CreateDataSet;

  end;  // procedure ImprimeTotal

begin

  pvEmpresa   := Dep.VarDeposito( 'EMPRESA', kGetEmpresaNome() );
  pvLoja      := Dep.VarDeposito( 'LOJA', '');
  pvSubTotal  := Dep.VarDeposito( 'SUBTOTAL', True);
  pvTotal     := Dep.VarDeposito( 'TOTAL', True);
  pvSepQuebra := Dep.VarDeposito( 'SEPARA_QUEBRA', False);

  Printer.Titulo             := Dep.VarDeposito( 'TITULO', '');
  Printer.SubTitulo          := Dep.VarDeposito( 'SUBTITULO', '');
  Printer.SeparacionColumnas := Dep.VarDeposito( 'SEPARA_COLUNA', #32#32);
  SeparaLinha                := Dep.VarDeposito( 'SEPARA_LINHA', '');
  Printer.MargenIzquierdo    := Dep.VarDeposito( 'MARGEM_ESQUERDA', 2);

  Printer.MargenDerecho      := Dep.VarDeposito( 'MARGEM_DIREITA', 132);

  Printer.PageOrientation    := Dep.VarDeposito('PAGEORIENTATION', poPortrait );
  Printer.LineTotal          := Dep.VarDeposito('LINETOTAL', True);

  if Printer.PageOrientation = poLandscape then
    Printer.LineaPiePagina := 49;

  // Margem Direita e FastFont nao influenciam o cabecalho

  pvNegrito    := Dep.VarDeposito( 'NEGRITO', False);
  pvSublinhado := Dep.VarDeposito( 'SUBLINHADO', False);
  pvComprimido := Dep.VarDeposito( 'COMPRIMIDO', True);
  pvItalico    := Dep.VarDeposito( 'ITALICO', False);
  pvEscreveSistema := Dep.VarDeposito( 'SISTEMA_X', True);

  Printer.EscribirPaginas := Dep.VarDeposito('PAGINA', True);
  Printer.EscribirData    := Dep.VarDeposito('DATA', True);
  Printer.EscribirHora    := Dep.VarDeposito('HORA', True);

  with Report do
  begin

    if pvNegrito then
      Printer.FastFont := Printer.FastFont + [Negrita]
    else
      Printer.FastFont := Printer.FastFont - [Negrita];

    if pvSublinhado then
      Printer.FastFont := Printer.FastFont + [Subrayado]
    else
      Printer.FastFont := Printer.FastFont - [Subrayado];

    if pvComprimido then
      Printer.FastFont := Printer.FastFont + [Comprimido]
    else
      Printer.FastFont := Printer.FastFont - [Comprimido];

    if pvItalico then
      Printer.FastFont := Printer.FastFont + [Italica]
    else
      Printer.FastFont := Printer.FastFont - [Italica];

  end;  // with Report

  ListGrupo := TList.Create;  // Lista dos totalizadores de grupos

  for i := 0 to 9 do
  begin
    ListGrupo.Add(NIL);
    varField[i] := 0;
  end;

  mtTotal := TClientDataSet.Create(Application);

  NumeroColuna := Printer.MargenDerecho - Printer.MargenIzquierdo;

  bk := RepData.GetBookmark;
  RepData.DisableControls;

  RepData.First;

  for i := 0 to (RepData.Fields.Count - 1) do
  begin

    iFlag := RepData.Fields[i].Tag;
    mtTotal.FieldDefs.Add( RepData.Fields[i].FieldName,
                           RepData.Fields[i].DataType,
                           RepData.Fields[i].Size );

    if (iFlag > 1) and (not Assigned(ListGrupo[iFlag])) then
    begin
      // Cria uma tabela temporaria para controlar o grupo
      varField[iFlag] := i;  // Guarda o indice do Field
      ListGrupo.Items[iFlag] := TClientDataSet.Create(NIL);
    end;

  end;

  for i := 0 to RepData.Fields.Count - 1 do
    for iFlag := 0 to ListGrupo.Count-1 do
      if Assigned(ListGrupo[iFlag]) then
        TDataSet(ListGrupo[iFlag]).FieldDefs.Add(
                                    RepData.Fields[i].FieldName,
                                    RepData.Fields[i].DataType,
                                    RepData.Fields[i].Size );

  mtTotal.CreateDataSet;

  for i := 0 to ListGrupo.Count-1 do
    if Assigned(ListGrupo[i]) then
      TClientDataSet(ListGrupo[i]).CreateDataSet;

  for i := Low(varGrupo) to High(varGrupo) do
   varGrupo[i] := NULL;

  while not RepData.EOF do
  begin

    Cabecalho();
    PrintCabecalhoGrupo();

    EscreveDetalhe( RepData, mtTotal, ListGrupo);

    RepData.Next;

    if IsGrupo then
    begin // Verifica se o relatorio possui grupo

      iFlag := 0;  // Sinaliza se pelo menos um grupo foi totalizado

      for i := ListGrupo.Count-1 downto 0 do
      begin

        if Assigned(ListGrupo[i]) and
           (RepData.Eof or (RepData.Fields[varField[i]].Value <> varGrupo[i])) then
        begin

          // O grupo foi quebrado

          if pvSubTotal then
          begin

            if (iFlag = 0) and (Length(SeparaLinha) = 0) then
              EscreveLinha();

            if (Printer.LineaPiePagina-1) <= (Printer.LineaActual + 2) then
            begin
              Printer.LineaActual := Printer.LineaPiePagina + 1;
              Cabecalho();
            end;

            if (iDetalheFlag = 0) then
            begin
              RepData.Prior;
              CabecalhoGrupo(i);
              RepData.Next;
            end;

            ImprimeTotal( RepData, i);
            iFlag := 1;

          end else if Report.Printer.LineTotal then
            EscreveLinha;

          // Separa os grupos em paginas diferentes
          if pvSepQuebra and (not RepData.Eof)
             and (i = 2) {Quebra apenas no primeiro grupo} then
            Printer.LineaActual := Printer.LineaPiePagina + 1;

        end;

      end; // for

    end;  // if IsGrupo

  end;  // while

  if pvTotal then
  begin
    if (not IsGrupo) and (Length(SeparaLinha) = 0) then
      EscreveLinha;
    ImprimeTotal( RepData, 0, True);
  end else
    EscreveLinha;

  RepData.GotoBookmark(bk);
  RepData.FreeBookmark(bk);
  RepData.EnableControls;

  // FINAL DO RELATORIO
  iLinhaFinal := Dep.VarDeposito('LINHA_FINAL', 0);
  if iLinhaFinal > 0 then
    for i := 1 to iLinhaFinal do
    begin
      LinhaFinal := Dep.VarDeposito('LINHA_FINAL_'+IntToStr(i), '');
      Escreve( Printer.LineaActual, Printer.MargenIzquierdo, LinhaFinal, True);
    end;

  while (ListGrupo.Count > 0) do
  begin
    if Assigned(ListGrupo[0]) then
      TClientDataSet(ListGrupo[0]).Free;
    ListGrupo.Delete(0);
  end;

  ListGrupo.Free;
  mtTotal.Free;

end;  // proc ReportGenerate

{ TFrmPrintLines }

constructor TFrmPrintLines.Create(AOwner: TComponent);
begin
  inherited;
  FLines := TStringList.Create;
  FPrinter := TTbPrinter.Create(Self);
  FReport  := TTbCustomReport.Create(Self);
  FReport.Printer := FPrinter;
end;

procedure TFrmPrintLines.CustomReportGenerate(Sender: TObject);
var
  i, p: Integer;
  sF, sTxt: String;
  Fonte: TFuente;
begin

  with FReport do
  begin

    for i := 0 to FLines.Count - 1 do
    begin

      if (Printer.LineaActual = 0) or
         (Printer.LineaActual >= Printer.LineaPiePagina) then
        Printer.NuevaPagina;

      if (Printer.LineaActual = 0) then
        Printer.LineaActual := 2;

      sTxt := FLines[i];
      p := Pos( ';;', sTxt);
      Fonte := [];

      if (p > 0) then
      begin
        sF := Copy( sTxt, 1, p-1);
        sTxt := Copy( sTxt, p+2, Length(sTxt));
        if Pos( 'N', sF) > 0 then Fonte := Fonte + [Negrita];
        if Pos( 'I', sF) > 0 then Fonte := Fonte + [Italica];
      end;


      Printer.Escribir( Printer.MargenIzquierdo,
                        Printer.LineaActual, sTxt, Fonte);
      Printer.LineaActual := Printer.LineaActual + 1;

    end;

  end;

end;

destructor TFrmPrintLines.Destroy;
begin
  FReport.Free;
  FPrinter.Free;
  FLines.Free;
  inherited;
end;

procedure TFrmPrintLines.Preview;
begin
  FPrinter.Preview := True;
  FReport.OnGenerate := CustomReportGenerate;
  FReport.Printer.Zoom := zReal;
  FReport.Execute;
end;

procedure TFrmPrintLines.Print;
begin
  FPrinter.Preview := False;
  FReport.OnGenerate := CustomReportGenerate;  
  FReport.Execute;
end;

procedure TFrmPrintLines.SetLines(Lines: TStringList);
begin
  if FLines <> Lines then
    FLines.Assign(Lines);
end;

procedure TFrmPrintLines.SetReport(Report: TTbCustomReport);
begin
  if (FReport <> Report) then
    FReport.Assign(Report);
end;

end.
