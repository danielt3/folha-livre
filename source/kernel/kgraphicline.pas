unit kgraphicline;

{$I flivre.inc}

{Historico das modificações

* 18/07/2006 - Primeira versão

}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, ExtCtrls, StdCtrls, Buttons,
  DB, fdepstr, Menus, {$IFDEF FL_MIDASLB}MidasLib,{$ENDIF}
  DBClient, ActnList, TeeProcs, TeEngine, Chart, DBChart, Series;

type
  TLineForm = class(TForm)
    MainMenu1: TMainMenu;
    mniGrafico: TMenuItem;
    mniLegenda: TMenuItem;
    Nenhuma1: TMenuItem;
    Inferior1: TMenuItem;
    Superior1: TMenuItem;
    Direita1: TMenuItem;
    Esquerda1: TMenuItem;
    mniMarca: TMenuItem;
    mniMarcaNenhum: TMenuItem;
    N2: TMenuItem;
    mniMarcaXValor: TMenuItem;
    mniMarcaEtiquetaPercentualTotal: TMenuItem;
    mniMarcaPercentualTotal: TMenuItem;
    mniMarcaLegenda: TMenuItem;
    mniMarcaEtiquetaValor: TMenuItem;
    mniMarcaEtiquetaPercentual: TMenuItem;
    mniMarcaEtiqueta: TMenuItem;
    mniMarcaPercentual: TMenuItem;
    mniMarcaValor: TMenuItem;
    N3: TMenuItem;
    mniGradiente: TMenuItem;
    mni3D: TMenuItem;
    N5: TMenuItem;
    mniImprimirRetrato: TMenuItem;
    GravarImagem1: TMenuItem;
    mniImprimirPaisagem: TMenuItem;
    mniMonocromatico: TMenuItem;
    N6: TMenuItem;
    mniTitulo: TMenuItem;
    mniTituloFonte: TMenuItem;
    mniTituloNenhum: TMenuItem;
    mniTituloEsquerdo: TMenuItem;
    mniTituloCentralizado: TMenuItem;
    mniTituloDireito: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    Fechar1: TMenuItem;
    mniMarcaTransparente: TMenuItem;
    mniGradienteCimaBaixo: TMenuItem;
    mniGradienteBaixoCima: TMenuItem;
    mniGradienteEsquerdoDireito: TMenuItem;
    mniGradienteDireitoEsquerdo: TMenuItem;
    mniGradienteCentro: TMenuItem;
    mniGradienteCimaEsquerdo: TMenuItem;
    mniGradienteBaixoEsquerdo: TMenuItem;
    mniGradienteNenhum: TMenuItem;
    N9: TMenuItem;
    mniGradienteCorInicial: TMenuItem;
    mniGradienteCorFinal: TMenuItem;
    mniMarcaBorda: TMenuItem;
    N1: TMenuItem;
    ConfiguraCor1: TMenuItem;
    pvDataSet: TClientDataSet;
    ActionList1: TActionList;
    acMarcaBorda: TAction;
    acMarcaTransparente: TAction;
    acTitulo: TAction;
    acMarca: TAction;
    acOrtogonal: TAction;
    mniOrtogonal: TMenuItem;
    acMarcaFonte: TAction;
    N4: TMenuItem;
    mniMarcaFonte: TMenuItem;
    acLegendaFonte: TAction;
    mniLegendaFonte: TMenuItem;
    mniVisualizacao: TMenuItem;
    mniEscalaY: TMenuItem;
    mniGrade: TMenuItem;
    acEscalaY: TAction;
    acEscalaX: TAction;
    mniEscalaX: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    acGrade: TAction;
    acRodape: TAction;
    mniRodape: TMenuItem;
    mniRodapeEsquerdo: TMenuItem;
    mniRodapeDireito: TMenuItem;
    mniRodapeCentro: TMenuItem;
    mniRodapeNenhum: TMenuItem;
    N12: TMenuItem;
    mniRodapeFonte: TMenuItem;
    Chart1: TDBChart;
    Series1: TLineSeries;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mni3DClick(Sender: TObject);
    procedure Esquerda1Click(Sender: TObject);
    procedure GravarImagem1Click(Sender: TObject);
    procedure mniImprimirRetratoClick(Sender: TObject);
    procedure mniImprimirPaisagemClick(Sender: TObject);
    procedure mniMonocromaticoClick(Sender: TObject);
    procedure mniTituloFonteClick(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure mniGradienteCimaBaixoClick(Sender: TObject);
    procedure mniGradienteCorInicialClick(Sender: TObject);
    procedure mniGradienteCorFinalClick(Sender: TObject);
    procedure ConfiguraCor1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure acMarcaBordaExecute(Sender: TObject);
    procedure acMarcaBordaUpdate(Sender: TObject);
    procedure acMarcaTransparenteExecute(Sender: TObject);
    procedure acMarcaTransparenteUpdate(Sender: TObject);
    procedure acTituloExecute(Sender: TObject);
    procedure acTituloUpdate(Sender: TObject);
    procedure mniTituloNenhumClick(Sender: TObject);
    procedure acMarcaExecute(Sender: TObject);
    procedure mniMarcaNenhumClick(Sender: TObject);
    procedure acMarcaUpdate(Sender: TObject);
    procedure acOrtogonalExecute(Sender: TObject);
    procedure acOrtogonalUpdate(Sender: TObject);
    procedure acMarcaFonteExecute(Sender: TObject);
    procedure acLegendaFonteExecute(Sender: TObject);
    procedure acEscalaYExecute(Sender: TObject);
    procedure acEscalaYUpdate(Sender: TObject);
    procedure acEscalaXExecute(Sender: TObject);
    procedure acEscalaXUpdate(Sender: TObject);
    procedure acGradeExecute(Sender: TObject);
    procedure acGradeUpdate(Sender: TObject);
    procedure acRodapeExecute(Sender: TObject);
    procedure acRodapeUpdate(Sender: TObject);
    procedure mniRodapeNenhumClick(Sender: TObject);
    procedure mniRodapeFonteClick(Sender: TObject);
  private
    pvLabels: String;
    pvX: String;
    procedure CreateSerie(YField: String);
    { Private declarations }
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
  end;

procedure CreateLine( DataSet: TDataSet; Cfg: TDepStr; LabelField, XField: String);

implementation

{$R *.dfm}

uses
  {$IFDEF VCL}Dialogs,{$ENDIF}
  {$IFDEF CLX}QDialogs,{$ENDIF}
  TypInfo, fsuporte;

procedure CreateLine( DataSet: TDataSet; Cfg: TDepStr;  LabelField, XField: String);
var
  i: Integer;
  sTitulo, sSubTitulo, sRodape: String;
begin

  with TLineForm.Create(Application) do
  begin

    kDataSetToData(DataSet, pvDataSet);

    pvLabels := LabelField;
    pvX := XField;

    sTitulo := 'Gráfico Séries';
    sSubtitulo := '';

    if Assigned(Cfg) then
    begin
      sTitulo := Cfg.GetValue('TITULO', sTitulo);
      sSubTitulo := Cfg.GetValue('SUBTITULO');
      sRodape := Cfg.GetValue('RODAPE');
    end;

    Caption := sTitulo;

    Chart1.Title.Text.Clear;
    Chart1.Title.Text.Add(sTitulo);

    if (sSubTitulo <> '') then
      Chart1.Title.Text.Add(sSubTitulo);

    if (sRodape = '') then
    begin
      Chart1.Foot.Visible := True;
      Chart1.Foot.Text.Clear;
      Chart1.Foot.Text.Add('Fonte: Sistema Informatize - '+FormatDateTime('yyyy', Date()));
    end;

    Chart1.SeriesList.Clear;

    for i := 0 to DataSet.FieldCount - 1 do
      if DataSet.Fields[i].Visible
         and (DataSet.Fields[i].FieldName <> pvLabels)
         and (DataSet.Fields[i].FieldName <> pvX)
         and (DataSet.Fields[i].DataType in [ftFloat,ftCurrency,ftBCD]) then
        CreateSerie(DataSet.Fields[i].FieldName);

    Show;

  end;

end;

constructor TLineForm.Create( AOwner: TComponent);
begin

  inherited Create( AOwner);

  if Chart1.Gradient.Visible then
    Chart1.Title.Font.Color := clWhite
  else
    Chart1.Title.Font.Color := clBlue;

  Chart1.Foot.Font.Color := clRed;

  mni3D.Checked            := Chart1.View3D;
  mniMonocromatico.Checked := Chart1.Monochrome;

  if not Chart1.Legend.Visible then
    mniLegenda.Items[mniLegenda.Count-1].Checked := True
  else
    mniLegenda.Items[Integer(Chart1.Legend.Alignment)].Checked := True;

  if not Chart1.Gradient.Visible then
    mniGradienteNenhum.Checked := True
  else
    mniGradiente.Items[Integer(Chart1.Gradient.Direction)].Checked := True;

end;

procedure TLineForm.CreateSerie(YField: String);
var
  Line: TLineSeries;
begin

  Line := TLineSeries.Create(Chart1);

  Chart1.AddSeries(Line);

  with Line do
  begin

    Title := pvDataSet.FieldByName(YField).DisplayLabel;

    DataSource := pvDataSet;

    XLabelsSource := pvLabels;

    XValues.ValueSource := pvX;
    XValues.DateTime := (pvDataSet.FieldByName(pvX).DataType in [ftDate,ftDateTime]);

    YValues.ValueSource := YField;
    YValues.DateTime := (pvDataSet.FieldByName(YField).DataType in [ftDate,ftDateTime]);

  end;

end;

procedure TLineForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TLineForm.mni3DClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    Chart1.View3D := Checked;
  end; // with TMenuItem
end;

procedure TLineForm.Esquerda1Click(Sender: TObject);
var
  i: Integer;
begin

  with TMenuItem(Sender) do
    Checked := not Checked;

  i := TMenuItem(Sender).Parent.IndexOf( TMenuItem(Sender));

  Chart1.Legend.Visible := ( i <  4);

  if (i < 4) then
    Chart1.Legend.Alignment := TLegendAlignment(i);

end;

procedure TLineForm.GravarImagem1Click(Sender: TObject);
begin

  with TSaveDialog.Create(Self) do
  begin
    try
      Title := 'Salvar Imagem do Gráfico';
      DefaultExt := '*.bmp';
      Filter := 'Bitmap (*.bmp)|*.bmp|'+
                'Metafiles (*.wmf)|*.wmf|'+
                'Enhanced Metafiles (*.emf)|*.emf|'+
                'Todos os arquivos (*.*)|*.*';
      FilterIndex := 0;
      if Execute then
        Chart1.SaveToBitmapFile( FileName);
    finally
      Free;
    end;
  end;

end;

procedure TLineForm.mniImprimirRetratoClick(Sender: TObject);
begin
  Chart1.PrintPortrait;
end;

procedure TLineForm.mniImprimirPaisagemClick(Sender: TObject);
begin
  Chart1.PrintLandscape;
end;

procedure TLineForm.mniMonocromaticoClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    Chart1.Monochrome := Checked;
  end;
end;

procedure TLineForm.mniTituloFonteClick(Sender: TObject);
begin
  with TFontDialog.Create(Self) do
  begin
    try
      Font.Assign(Chart1.Title.Font);
      if Execute then
        Chart1.Title.Font.Assign(Font);
    finally
      Free;
    end;
  end;
end;

procedure TLineForm.Fechar1Click(Sender: TObject);
begin
  Close;
end;

procedure TLineForm.mniGradienteCimaBaixoClick(Sender: TObject);
var
  i: Integer;
  pDirection: PPropInfo;
begin

  with TMenuItem(Sender) do
    Checked := not Checked;

  i := TMenuItem(Sender).Parent.IndexOf(TMenuItem(Sender));

  Chart1.Gradient.Visible := ( i <  7);

  if Chart1.Gradient.Visible then
  begin
    pDirection := GetPropInfo(Chart1.Gradient.ClassInfo , 'Direction');
    if Assigned(pDirection) then
      SetOrdProp(Chart1.Gradient, pDirection, i);
  end;

end;

procedure TLineForm.mniGradienteCorInicialClick(Sender: TObject);
begin
  Chart1.Gradient.StartColor := EditColor( Self, Chart1.Gradient.StartColor);
end;

procedure TLineForm.mniGradienteCorFinalClick(Sender: TObject);
begin
  Chart1.Gradient.EndColor := EditColor( Self, Chart1.Gradient.EndColor);
end;

procedure TLineForm.ConfiguraCor1Click(Sender: TObject);
begin
  Chart1.Legend.Color := EditColor( Self, Chart1.Legend.Color);
end;

procedure TLineForm.FormResize(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

procedure TLineForm.acMarcaBordaExecute(Sender: TObject);
var
  s: Integer;
  b: Boolean;
begin
  b := not Chart1.Series[0].Marks.Frame.Visible;
  for s := 0 to Chart1.SeriesCount - 1 do
    Chart1.Series[s].Marks.Frame.Visible := b;
end;

procedure TLineForm.acMarcaBordaUpdate(Sender: TObject);
begin
  mniMarcaBorda.Checked := Chart1.Series[0].Marks.Frame.Visible;
end;

procedure TLineForm.acMarcaTransparenteExecute(Sender: TObject);
var
  s: Integer;
  b: Boolean;
begin
  b := not Chart1.Series[0].Marks.Transparent;
  for s := 0 to Chart1.SeriesCount - 1 do
    Chart1.Series[s].Marks.Transparent := b;
end;

procedure TLineForm.acMarcaTransparenteUpdate(Sender: TObject);
begin
  mniMarcaTransparente.Checked := Chart1.Series[0].Marks.Transparent;
end;

procedure TLineForm.acTituloExecute(Sender: TObject);
var
  i: Integer;
begin
  i := mniTitulo.IndexOf(TMenuItem(TAction(Sender).ActionComponent));
  Chart1.Title.Visible := True;
  Chart1.Title.Alignment := TAlignment(i);
end;

procedure TLineForm.acTituloUpdate(Sender: TObject);
begin
  if Chart1.Title.Visible then
    mniTitulo.Items[Integer(Chart1.Title.Alignment)].Checked := True
  else
    mniTituloNenhum.Checked := True;
end;

procedure TLineForm.mniTituloNenhumClick(Sender: TObject);
begin
  Chart1.Title.Visible := not Chart1.Title.Visible;
end;

procedure TLineForm.acMarcaExecute(Sender: TObject);
var
  m: TMenuItem;
  i, s: Integer;
begin

  m := TMenuItem(TAction(Sender).ActionComponent);
  i := m.Parent.IndexOf(m);

  for s := 0 to Chart1.SeriesCount - 1 do
  begin
    Chart1.Series[s].Marks.Visible := True;
    Chart1.Series[s].Marks.Style := TSeriesMarksStyle(i);
  end;

end;

procedure TLineForm.mniMarcaNenhumClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Chart1.SeriesCount - 1 do
    Chart1.Series[i].Marks.Visible := not TMenuItem(Sender).Checked;
end;

procedure TLineForm.acMarcaUpdate(Sender: TObject);
begin
  if Chart1.Series[0].Marks.Visible then
    mniMarca.Items[Integer(Chart1.Series[0].Marks.Style)].Checked := True
  else
    mniMarcaNenhum.Checked := True;
end;

procedure TLineForm.acOrtogonalExecute(Sender: TObject);
begin
  Chart1.View3DOptions.Orthogonal := not Chart1.View3DOptions.Orthogonal;
end;

procedure TLineForm.acOrtogonalUpdate(Sender: TObject);
begin
  mniOrtogonal.Checked := Chart1.View3DOptions.Orthogonal;
end;

procedure TLineForm.acMarcaFonteExecute(Sender: TObject);
var
  s: Integer;
begin
  with TFontDialog.Create(Self) do
  begin
    try
      Font.Assign(Chart1.Series[0].Marks.Font);
      if Execute then
        for s := 0 to Chart1.SeriesCount - 1 do
          Chart1.Series[s].Marks.Font.Assign(Font);
    finally
      Free;
    end;
  end;
end;

procedure TLineForm.acLegendaFonteExecute(Sender: TObject);
begin
  with TFontDialog.Create(Self) do
  begin
    try
      Font.Assign(Chart1.Legend.Font);
      if Execute then
        Chart1.Legend.Font.Assign(Font);
    finally
      Free;
    end;
  end;
end;

procedure TLineForm.acEscalaYExecute(Sender: TObject);
begin
  Chart1.LeftAxis.Visible := not Chart1.LeftAxis.Visible;
  if Chart1.LeftAxis.Visible then
    Chart1.AxisVisible := True;
end;

procedure TLineForm.acEscalaYUpdate(Sender: TObject);
begin
  mniEscalaY.Checked := Chart1.LeftAxis.Visible;
end;

procedure TLineForm.acEscalaXExecute(Sender: TObject);
begin
  Chart1.BottomAxis.Visible := not Chart1.BottomAxis.Visible;
  if Chart1.BottomAxis.Visible then
    Chart1.AxisVisible := True;
end;

procedure TLineForm.acEscalaXUpdate(Sender: TObject);
begin
  mniEscalaX.Checked := Chart1.BottomAxis.Visible;
end;

procedure TLineForm.acGradeExecute(Sender: TObject);
begin
  Chart1.AxisVisible := not Chart1.AxisVisible;
  // Faz com que os eixos X e Y estejam coerente com a exibição da grade
  Chart1.LeftAxis.Visible := Chart1.AxisVisible;
  Chart1.BottomAxis.Visible := Chart1.AxisVisible;
end;

procedure TLineForm.acGradeUpdate(Sender: TObject);
begin
  mniGrade.Checked := Chart1.AxisVisible;
end;

procedure TLineForm.acRodapeExecute(Sender: TObject);
var
  i: Integer;
begin
  i := mniRodape.IndexOf(TMenuItem(TAction(Sender).ActionComponent));
  Chart1.Foot.Visible := True;
  Chart1.Foot.Alignment := TAlignment(i);
end;

procedure TLineForm.acRodapeUpdate(Sender: TObject);
begin
  if Chart1.Foot.Visible then
    mniRodape.Items[Integer(Chart1.Foot.Alignment)].Checked := True
  else
    mniRodapeNenhum.Checked := True;
end;

procedure TLineForm.mniRodapeNenhumClick(Sender: TObject);
begin
  Chart1.Foot.Visible := not Chart1.Foot.Visible;
end;

procedure TLineForm.mniRodapeFonteClick(Sender: TObject);
begin
  with TFontDialog.Create(Self) do
  begin
    try
      Font.Assign(Chart1.Foot.Font);
      if Execute then
        Chart1.Foot.Font.Assign(Font);
    finally
      Free;
    end;
  end;
end;

end.
