unit pie;

{$I flivre.inc}

{
Historico das modificações

* 17/10/2003 - Primeira versão

}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Chart, Series, ExtCtrls, StdCtrls, Teengine,
  Buttons, teeprocs, DbChart,
  DB, DBClient, {$IFDEF FL_MIDASLB}MidasLib,{$ENDIF} fdepstr, Menus;

type
  TPieForm = class(TForm)
    Chart1: TDBChart;
    PieSeries1: TPieSeries;
    DataSet1: TClientDataSet;
    DataSet1NAME: TStringField;
    DataSet1VALUE: TCurrencyField;
    MainMenu1: TMainMenu;
    mniGrafico: TMenuItem;
    mniLegenda: TMenuItem;
    Nenhuma1: TMenuItem;
    Inferior1: TMenuItem;
    Superior1: TMenuItem;
    Direita1: TMenuItem;
    Esquerda1: TMenuItem;
    mniMarca: TMenuItem;
    Nenhuma2: TMenuItem;
    N2: TMenuItem;
    XValor1: TMenuItem;
    EtiquetaPercentualTotal1: TMenuItem;
    PercentualTotal1: TMenuItem;
    Legenda1: TMenuItem;
    EtiquetaValor1: TMenuItem;
    EtiquetaPercentual1: TMenuItem;
    Etiqueta1: TMenuItem;
    Percentual1: TMenuItem;
    mniMarcaValor: TMenuItem;
    N3: TMenuItem;
    mniPattern: TMenuItem;
    mniGradiente: TMenuItem;
    mniCircular: TMenuItem;
    mni3D: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    Imprimir1: TMenuItem;
    GravarImagem1: TMenuItem;
    ImprimitPaisagem1: TMenuItem;
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
    mniMarcaBordas: TMenuItem;
    N1: TMenuItem;
    ConfiguraCor1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SemMarcar1Click(Sender: TObject);
    procedure mniMarcaValorClick(Sender: TObject);
    procedure mni3DClick(Sender: TObject);
    procedure mniCircularClick(Sender: TObject);
    procedure mniPatternsClick(Sender: TObject);
    procedure Esquerda1Click(Sender: TObject);
    procedure GravarImagem1Click(Sender: TObject);
    procedure Imprimir1Click(Sender: TObject);
    procedure ImprimitPaisagem1Click(Sender: TObject);
    procedure mniMonocromaticoClick(Sender: TObject);
    procedure mniTituloFonteClick(Sender: TObject);
    procedure mniTituloEsquerdoClick(Sender: TObject);
    procedure Fechar1Click(Sender: TObject);
    procedure mniMarcaTransparenteClick(Sender: TObject);
    procedure mniGradienteCimaBaixoClick(Sender: TObject);
    procedure mniGradienteCorInicialClick(Sender: TObject);
    procedure mniGradienteCorFinalClick(Sender: TObject);
    procedure mniMarcaBordasClick(Sender: TObject);
    procedure ConfiguraCor1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    procedure PieSeries1Click(Sender: TChartSeries; ValueIndex: Integer;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    { Private declarations }
  public
    { Public declarations }
    constructor Create( AOwner: TComponent); override;
    procedure SetDataSet( DataSet: TDataSet; NameField: String = ''; ValueField: String = '');
  end;

procedure CreatePie( DataSet: TDataSet; Cfg: TDepStr; NameField, ValueField: String);

implementation

{$R *.dfm}

uses
  {$IFDEF VCL}Dialogs,{$ENDIF}
  {$IFDEF CLX}QDialogs,{$ENDIF}
  TypInfo, fsuporte, TeCanvas;

procedure CreatePie( DataSet: TDataSet; Cfg: TDepStr;  NameField, ValueField: String);
var
  sTitulo, sSubTitulo: String;
begin

  with TPieForm.Create(Application) do
  begin

    sTitulo    := Cfg.GetValue('TITULO', 'Gráfico Pizza');
    sSubTitulo := Cfg.GetValue('SUBTITULO', '');

    Caption := sTitulo;
    Chart1.Title.Text.Clear;
    Chart1.Title.Text.Add(sTitulo);

    if (sSubTitulo <> '') then
      Chart1.Title.Text.Add(sSubTitulo);

    SetDataSet( DataSet, NameField, ValueField);

    Show;

  end;

end;

constructor TPieForm.Create( AOwner: TComponent);
begin

  inherited Create( AOwner);

  with TPieSeries(Chart1.Series[0]) do
  begin
    DataSource := DataSet1;
    XLabelsSource := 'NAME';
    PieValues.ValueSource := 'VALUE';
    PieValues.DateTime := False;
    //PieValues.Order := loAscending;
    PieValues.Order := loNone;
    PieValues.Multiplier := 1;
    Dark3D := False;
    OtherSlice.Text := 'Other';
    PieValues.Name := 'Pie';
    SeriesColor := clRed;
    OnClick := PieSeries1Click;
  end;

  if Chart1.Title.Visible then
    mniTitulo.Items[Integer(Chart1.Title.Alignment)].Checked := True
  else
    mniTituloNenhum.Checked := True;

  if Chart1.Gradient.Visible then
    Chart1.Title.Font.Color := clWhite
  else
    Chart1.Title.Font.Color := clBlue;

  mni3D.Checked            := Chart1.View3D;
  mniCircular.Checked      := Chart1.Gradient.Visible;
  mniPattern.Checked       := PieSeries1.UsePatterns;
  mniMonocromatico.Checked := Chart1.Monochrome;

  if not PieSeries1.Marks.Visible then
    mniMarca.Items[mniMarca.Count-1].Checked := True
  else
    mniMarca.Items[Integer(PieSeries1.Marks.Style)].Checked := True;

  mniMarcaTransparente.Checked := Chart1.Series[0].Marks.Transparent;
  mniMarcaBordas.Checked       := Chart1.Series[0].Marks.Frame.Visible;

  if not Chart1.Legend.Visible then
    mniLegenda.Items[mniLegenda.Count-1].Checked := True
  else
    mniLegenda.Items[Integer(Chart1.Legend.Alignment)].Checked := True;

  if not Chart1.Gradient.Visible then
    mniGradienteNenhum.Checked := True
  else
    mniGradiente.Items[Integer(Chart1.Gradient.Direction)].Checked := True;

end;

procedure TPieForm.PieSeries1Click( Sender: TChartSeries;
  ValueIndex: Integer; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
  // On Clicked Pie, let the user change the clicked pie color
  with PieSeries1 do
    ValueColor[ValueIndex] := EditColor( Self, ValueColor[ValueIndex]);
end;

{procedure TPieForm.Chart1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var tmp:Longint;
begin
  tmp := PieSeries1.Clicked( x, y);
  if (tmp = -1) then
    Shape1.Visible := False
  else begin
    Shape1.Visible := True;
    Shape1.Brush.Color := PieSeries1.ValueColor[tmp];
  end;
end;}

procedure TPieForm.SetDataSet( DataSet: TDataSet;
  NameField: String = ''; ValueField: String = '');
begin

  DataSet1.Close;
  DataSet1.CreateDataSet;

  if (NameField = '') then
    NameField := DataSet.Fields[0].FieldName;

  if (NameField = '') then
    ValueField := DataSet.Fields[1].FieldName;

  with DataSet do
  begin
    First;
    while not Eof do
    begin
      DataSet1.AppendRecord( [ FieldByName(NameField).AsString,
                               FieldByName(ValueField).AsCurrency]);
      Next;
    end;
  end; // with DataSet do

  Chart1.Series[0].CheckDataSource;

end;

procedure TPieForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TPieForm.SemMarcar1Click(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := True;
    PieSeries1.Marks.Visible := False;
  end;
end;

procedure TPieForm.mniMarcaValorClick(Sender: TObject);
var
  i: Integer;
begin

  i := TMenuItem(Sender).Parent.IndexOf( TMenuItem(Sender));
  TMenuItem(Sender).Checked := True;

  PieSeries1.Marks.Visible := (i < 9);

  if PieSeries1.Marks.Visible then
    PieSeries1.Marks.Style := TSeriesMarksStyle(i);

end;

procedure TPieForm.mni3DClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    Chart1.View3D := Checked;
  end; // with TMenuItem
end;

procedure TPieForm.mniCircularClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    PieSeries1.Circled := Checked;
  end; // with TMenuItem
end;

procedure TPieForm.mniPatternsClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    PieSeries1.UsePatterns := Checked;
  end; // with TMenuItem
  if PieSeries1.UsePatterns then
    PieSeries1.CircleBackColor := clWhite;
end;

procedure TPieForm.Esquerda1Click(Sender: TObject);
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

procedure TPieForm.GravarImagem1Click(Sender: TObject);
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

procedure TPieForm.Imprimir1Click(Sender: TObject);
begin
  Chart1.PrintPortrait;
end;

procedure TPieForm.ImprimitPaisagem1Click(Sender: TObject);
begin
  Chart1.PrintLandscape;
end;

procedure TPieForm.mniMonocromaticoClick(Sender: TObject);
begin
  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    Chart1.Monochrome := Checked;
  end;
end;

procedure TPieForm.mniTituloFonteClick(Sender: TObject);
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

procedure TPieForm.mniTituloEsquerdoClick(Sender: TObject);
var
  i: Integer;
begin

  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    i := Parent.IndexOf( TMenuItem(Sender));
  end;

  Chart1.Title.Visible := (i < 3);

  if Chart1.Title.Visible then
    Chart1.Title.Alignment := TAlignment(i);

end;

procedure TPieForm.Fechar1Click(Sender: TObject);
begin
  Close;
end;

procedure TPieForm.mniMarcaTransparenteClick(Sender: TObject);
begin

  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    Chart1.Series[0].Marks.Transparent := Checked;
  end;

end;

procedure TPieForm.mniGradienteCimaBaixoClick(Sender: TObject);
var
  i: Integer;
  pDirection: PPropInfo;
begin

  with TMenuItem(Sender) do
    Checked := not Checked;

  i := TMenuItem(Sender).Parent.IndexOf( TMenuItem(Sender));

  Chart1.Gradient.Visible := ( i <  7);

  if Chart1.Gradient.Visible then
  begin
    pDirection := GetPropInfo( Chart1.Gradient.ClassInfo , 'Direction');
    if Assigned(pDirection) then
      SetOrdProp( Chart1.Gradient, pDirection, i);
  end;

end;

procedure TPieForm.mniGradienteCorInicialClick(Sender: TObject);
begin
  Chart1.Gradient.StartColor := EditColor( Self, Chart1.Gradient.StartColor);
end;

procedure TPieForm.mniGradienteCorFinalClick(Sender: TObject);
begin
  Chart1.Gradient.EndColor := EditColor( Self, Chart1.Gradient.EndColor);
end;

procedure TPieForm.mniMarcaBordasClick(Sender: TObject);
begin

  with TMenuItem(Sender) do
  begin
    Checked := not Checked;
    Chart1.Series[0].Marks.Frame.Visible := Checked;
  end;

end;

procedure TPieForm.ConfiguraCor1Click(Sender: TObject);
begin
  Chart1.Legend.Color := EditColor( Self, Chart1.Legend.Color);
end;

procedure TPieForm.FormResize(Sender: TObject);
begin
  WindowState := wsMaximized;
end;

end.
