object LineForm: TLineForm
  Left = 27
  Top = 69
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsNone
  Caption = 'Gr'#225'fico Linha'
  ClientHeight = 636
  ClientWidth = 975
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  WindowState = wsMaximized
  OnActivate = FormResize
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TDBChart
    Left = 0
    Top = 0
    Width = 975
    Height = 636
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Foot.Alignment = taRightJustify
    Title.Text.Strings = (
      'TDBChart')
    Chart3DPercent = 10
    View3DOptions.Elevation = 360
    View3DOptions.Perspective = 0
    View3DOptions.Rotation = 356
    Align = alClient
    TabOrder = 0
    object Series1: TLineSeries
      Marks.ArrowLength = 8
      Marks.Visible = False
      SeriesColor = clRed
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Y'
      YValues.Multiplier = 1
      YValues.Order = loNone
    end
  end
  object MainMenu1: TMainMenu
    Left = 368
    Top = 224
    object mniGrafico: TMenuItem
      Caption = '&Gr'#225'fico'
      GroupIndex = 1
      object mniVisualizacao: TMenuItem
        Caption = 'Visualiza'#231#227'o'
        object mni3D: TMenuItem
          Caption = '3&D'
          OnClick = mni3DClick
        end
        object mniOrtogonal: TMenuItem
          Action = acOrtogonal
        end
        object mniMonocromatico: TMenuItem
          Caption = 'Monocrom'#225'tico'
          OnClick = mniMonocromaticoClick
        end
        object N10: TMenuItem
          Caption = '-'
        end
        object mniGrade: TMenuItem
          Action = acGrade
        end
        object N11: TMenuItem
          Caption = '-'
        end
        object mniEscalaY: TMenuItem
          Action = acEscalaY
        end
        object mniEscalaX: TMenuItem
          Action = acEscalaX
        end
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object mniTitulo: TMenuItem
        Caption = 'T'#237'tulo'
        object mniTituloEsquerdo: TMenuItem
          Action = acTitulo
          AutoCheck = True
          Caption = 'Esquerdo'
          RadioItem = True
        end
        object mniTituloDireito: TMenuItem
          Action = acTitulo
          AutoCheck = True
          Caption = 'Direito'
          RadioItem = True
        end
        object mniTituloCentralizado: TMenuItem
          Action = acTitulo
          AutoCheck = True
          Caption = 'Centralizado'
          RadioItem = True
        end
        object mniTituloNenhum: TMenuItem
          AutoCheck = True
          Caption = 'Nenhum'
          RadioItem = True
          OnClick = mniTituloNenhumClick
        end
        object N7: TMenuItem
          Caption = '-'
        end
        object mniTituloFonte: TMenuItem
          Caption = 'Configurar Fonte...'
          OnClick = mniTituloFonteClick
        end
      end
      object mniRodape: TMenuItem
        Caption = 'Rodap'#233
        object mniRodapeEsquerdo: TMenuItem
          Action = acRodape
          Caption = 'Esquerdo'
          RadioItem = True
        end
        object mniRodapeDireito: TMenuItem
          Action = acRodape
          Caption = 'Direito'
          RadioItem = True
        end
        object mniRodapeCentro: TMenuItem
          Action = acRodape
          Caption = 'Centralizado'
          RadioItem = True
        end
        object mniRodapeNenhum: TMenuItem
          Caption = 'Nenhum'
          RadioItem = True
          OnClick = mniRodapeNenhumClick
        end
        object N12: TMenuItem
          Caption = '-'
        end
        object mniRodapeFonte: TMenuItem
          Caption = 'Configurar Fonte...'
          OnClick = mniRodapeFonteClick
        end
      end
      object mniMarca: TMenuItem
        Caption = 'Marcas'
        object mniMarcaValor: TMenuItem
          Action = acMarca
          Caption = 'Valor'
          RadioItem = True
        end
        object mniMarcaPercentual: TMenuItem
          Action = acMarca
          Caption = 'Percentual'
          RadioItem = True
        end
        object mniMarcaEtiqueta: TMenuItem
          Action = acMarca
          Caption = 'Etiqueta'
          RadioItem = True
        end
        object mniMarcaEtiquetaPercentual: TMenuItem
          Action = acMarca
          Caption = 'Etiqueta/Percentual'
          RadioItem = True
        end
        object mniMarcaEtiquetaValor: TMenuItem
          Action = acMarca
          Caption = 'Etiqueta/Valor'
          RadioItem = True
        end
        object mniMarcaLegenda: TMenuItem
          Action = acMarca
          Caption = 'Legenda'
          RadioItem = True
        end
        object mniMarcaPercentualTotal: TMenuItem
          Action = acMarca
          Caption = 'Percentual/Total'
          RadioItem = True
        end
        object mniMarcaEtiquetaPercentualTotal: TMenuItem
          Action = acMarca
          Caption = 'Etiqueta/Percentual/Total'
          RadioItem = True
        end
        object mniMarcaXValor: TMenuItem
          Action = acMarca
          Caption = 'X Valor'
          RadioItem = True
        end
        object mniMarcaNenhum: TMenuItem
          Action = acMarca
          Caption = 'Nenhuma'
          RadioItem = True
        end
        object N2: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object mniMarcaTransparente: TMenuItem
          Action = acMarcaTransparente
          AutoCheck = True
          GroupIndex = 1
        end
        object mniMarcaBorda: TMenuItem
          Action = acMarcaBorda
          AutoCheck = True
          GroupIndex = 1
        end
        object N4: TMenuItem
          Caption = '-'
          GroupIndex = 1
        end
        object mniMarcaFonte: TMenuItem
          Action = acMarcaFonte
          GroupIndex = 1
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
        object mniLegendaFonte: TMenuItem
          Action = acLegendaFonte
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
      object mniImprimirRetrato: TMenuItem
        Caption = 'Imprimir - Retrato'
        OnClick = mniImprimirRetratoClick
      end
      object mniImprimirPaisagem: TMenuItem
        Caption = 'Imprimir - Paisagem'
        OnClick = mniImprimirPaisagemClick
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
  object pvDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 128
    Top = 48
  end
  object ActionList1: TActionList
    Left = 544
    Top = 168
    object acMarcaBorda: TAction
      AutoCheck = True
      Caption = 'Bordas'
      OnExecute = acMarcaBordaExecute
      OnUpdate = acMarcaBordaUpdate
    end
    object acMarcaTransparente: TAction
      AutoCheck = True
      Caption = 'Transparente'
      OnExecute = acMarcaTransparenteExecute
      OnUpdate = acMarcaTransparenteUpdate
    end
    object acTitulo: TAction
      AutoCheck = True
      Caption = 'acTitulo'
      OnExecute = acTituloExecute
      OnUpdate = acTituloUpdate
    end
    object acRodape: TAction
      OnExecute = acRodapeExecute
      OnUpdate = acRodapeUpdate
    end
    object acMarca: TAction
      Caption = '-'
      OnExecute = acMarcaExecute
      OnUpdate = acMarcaUpdate
    end
    object acOrtogonal: TAction
      Caption = 'Ortogonal'
      OnExecute = acOrtogonalExecute
      OnUpdate = acOrtogonalUpdate
    end
    object acMarcaFonte: TAction
      Caption = 'Configurar Fonte...'
      OnExecute = acMarcaFonteExecute
    end
    object acLegendaFonte: TAction
      Caption = 'Configurar Fonte...'
      OnExecute = acLegendaFonteExecute
    end
    object acEscalaY: TAction
      Caption = 'Escala Y'
      OnExecute = acEscalaYExecute
      OnUpdate = acEscalaYUpdate
    end
    object acEscalaX: TAction
      Caption = 'Escala X'
      OnExecute = acEscalaXExecute
      OnUpdate = acEscalaXUpdate
    end
    object acGrade: TAction
      Caption = 'Grade'
      OnExecute = acGradeExecute
      OnUpdate = acGradeUpdate
    end
  end
end
