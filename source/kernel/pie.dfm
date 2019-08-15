object PieForm: TPieForm
  Left = 136
  Top = 40
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsNone
  Caption = 'Gr'#225'fico Pizza'
  ClientHeight = 556
  ClientWidth = 800
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TDBChart
    Left = 0
    Top = 0
    Width = 800
    Height = 556
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    BackWall.Pen.Visible = False
    Gradient.Direction = gdFromBottomLeft
    Title.Font.Charset = DEFAULT_CHARSET
    Title.Font.Color = clBlue
    Title.Font.Height = -19
    Title.Font.Name = 'Arial'
    Title.Font.Style = [fsBold]
    Title.Text.Strings = (
      'Demonstra'#231#227'o de Gr'#225'fico estilo pizza')
    AxisVisible = False
    ClipPoints = False
    Frame.Visible = False
    LeftAxis.Visible = False
    Legend.Alignment = laBottom
    Legend.ColorWidth = 10
    Legend.TextStyle = ltsLeftPercent
    ScaleLastPage = False
    View3DOptions.Elevation = 315
    View3DOptions.Orthogonal = False
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 360
    View3DWalls = False
    Align = alClient
    BevelOuter = bvNone
    Color = clSilver
    TabOrder = 0
    object PieSeries1: TPieSeries
      Marks.ArrowLength = 20
      Marks.Visible = True
      SeriesColor = clRed
      Title = 'PiePieSeries1'
      XLabelsSource = 'NAME'
      Dark3D = False
      OtherSlice.Text = 'Other'
      PieValues.DateTime = False
      PieValues.Name = 'Pie'
      PieValues.Multiplier = 1
      PieValues.Order = loNone
      PieValues.ValueSource = 'VALUE'
    end
  end
  object DataSet1: TClientDataSet
    Active = True
    Aggregates = <>
    Params = <>
    Left = 176
    Top = 48
    Data = {
      550000009619E0BD0100000018000000020000000000030000005500044E414D
      450100490000000100055749445448020002001E000556414C55450800040000
      00010007535542545950450200490006004D6F6E6579000000}
    object DataSet1NAME: TStringField
      FieldName = 'NAME'
      Size = 30
    end
    object DataSet1VALUE: TCurrencyField
      FieldName = 'VALUE'
    end
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 224
    object mniGrafico: TMenuItem
      Caption = '&Gr'#225'fico'
      GroupIndex = 1
      object mni3D: TMenuItem
        Caption = '3&D'
        OnClick = mni3DClick
      end
      object mniCircular: TMenuItem
        Caption = '&Circular'
        OnClick = mniCircularClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object mniPattern: TMenuItem
        Caption = 'Use Patterns'
        OnClick = mniPatternsClick
      end
      object mniMonocromatico: TMenuItem
        Caption = 'Monocrom'#225'tico'
        OnClick = mniMonocromaticoClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mniTitulo: TMenuItem
        Caption = 'T'#237'tulo'
        object mniTituloEsquerdo: TMenuItem
          Caption = 'Esquerdo'
          RadioItem = True
          OnClick = mniTituloEsquerdoClick
        end
        object mniTituloDireito: TMenuItem
          Caption = 'Direito'
          RadioItem = True
          OnClick = mniTituloEsquerdoClick
        end
        object mniTituloCentralizado: TMenuItem
          Caption = 'Centralizado'
          RadioItem = True
          OnClick = mniTituloEsquerdoClick
        end
        object mniTituloNenhum: TMenuItem
          Caption = 'Nenhum'
          RadioItem = True
          OnClick = mniTituloEsquerdoClick
        end
        object N7: TMenuItem
          Caption = '-'
        end
        object mniTituloFonte: TMenuItem
          Caption = 'Configurar Fonte...'
          OnClick = mniTituloFonteClick
        end
      end
      object mniMarca: TMenuItem
        Caption = 'Marcas'
        object mniMarcaValor: TMenuItem
          Caption = 'Valor'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object Percentual1: TMenuItem
          Caption = 'Percentual'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object Etiqueta1: TMenuItem
          Caption = 'Etiqueta'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object EtiquetaPercentual1: TMenuItem
          Caption = 'Etiqueta/Percentual'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object EtiquetaValor1: TMenuItem
          Caption = 'Etiqueta/Valor'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object Legenda1: TMenuItem
          Caption = 'Legenda'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object PercentualTotal1: TMenuItem
          Caption = 'Percentual/Total'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object EtiquetaPercentualTotal1: TMenuItem
          Caption = 'Etiqueta/Percentual/Total'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object XValor1: TMenuItem
          Caption = 'X Valor'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object Nenhuma2: TMenuItem
          Caption = 'Nenhuma'
          GroupIndex = 1
          RadioItem = True
          OnClick = mniMarcaValorClick
        end
        object N2: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object mniMarcaTransparente: TMenuItem
          Caption = 'Transparente'
          GroupIndex = 1
          OnClick = mniMarcaTransparenteClick
        end
        object mniMarcaBordas: TMenuItem
          Caption = 'Bordas'
          GroupIndex = 1
          OnClick = mniMarcaBordasClick
        end
      end
      object mniLegenda: TMenuItem
        Caption = 'Legendas'
        object Esquerda1: TMenuItem
          Caption = 'Esquerda'
          RadioItem = True
          OnClick = Esquerda1Click
        end
        object Direita1: TMenuItem
          Caption = 'Direita'
          RadioItem = True
          OnClick = Esquerda1Click
        end
        object Superior1: TMenuItem
          Caption = 'Superior'
          RadioItem = True
          OnClick = Esquerda1Click
        end
        object Inferior1: TMenuItem
          Caption = 'Inferior'
          RadioItem = True
          OnClick = Esquerda1Click
        end
        object Nenhuma1: TMenuItem
          Caption = 'Nenhuma'
          RadioItem = True
          OnClick = Esquerda1Click
        end
        object N1: TMenuItem
          Caption = '-'
        end
        object ConfiguraCor1: TMenuItem
          Caption = 'Configura Cor...'
          OnClick = ConfiguraCor1Click
        end
      end
      object mniGradiente: TMenuItem
        Caption = 'Gradiente'
        object mniGradienteCimaBaixo: TMenuItem
          Caption = 'Cima/Baixo'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteBaixoCima: TMenuItem
          Caption = 'Baixo/Cima'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteEsquerdoDireito: TMenuItem
          Caption = 'Esquerdo/Direito'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteDireitoEsquerdo: TMenuItem
          Caption = 'Direito/Esquerdo'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteCentro: TMenuItem
          Caption = 'Centro'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteCimaEsquerdo: TMenuItem
          Caption = 'Cima/Esquerdo'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteBaixoEsquerdo: TMenuItem
          Caption = 'Baixo/Esquerdo'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object mniGradienteNenhum: TMenuItem
          Caption = 'Nenhum'
          RadioItem = True
          OnClick = mniGradienteCimaBaixoClick
        end
        object N9: TMenuItem
          Caption = '-'
        end
        object mniGradienteCorInicial: TMenuItem
          Caption = 'Cor inicial...'
          OnClick = mniGradienteCorInicialClick
        end
        object mniGradienteCorFinal: TMenuItem
          Caption = 'Cor final...'
          OnClick = mniGradienteCorFinalClick
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object Imprimir1: TMenuItem
        Caption = 'Imprimir - Retrato'
        OnClick = Imprimir1Click
      end
      object ImprimitPaisagem1: TMenuItem
        Caption = 'Imprimit - Paisagem'
        OnClick = ImprimitPaisagem1Click
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object GravarImagem1: TMenuItem
        Caption = 'Exportar Gr'#225'fico...'
        OnClick = GravarImagem1Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object Fechar1: TMenuItem
        Caption = 'Fechar'
        OnClick = Fechar1Click
      end
    end
  end
end
