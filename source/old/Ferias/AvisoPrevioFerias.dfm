object FrmAvisoPrevioFerias: TFrmAvisoPrevioFerias
  Left = 186
  Top = 274
  Width = 441
  Height = 122
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object TbPrinter1: TTbPrinter
    FastPrinter = Epson_FX
    FastPort = 'LPT1'
    FastFont = []
    Zoom = zReal
    Preview = True
    WinPrinter = 'Epson LX-810'
    WinPort = 'LPT1:'
    LineaTitulo = 3
    LineaSubTitulo = 4
    Left = 56
    Top = 24
  end
  object TbCustomReport1: TTbCustomReport
    Printer = TbPrinter1
    OnGenerate = TbCustomReport1Generate
    Left = 128
    Top = 16
  end
  object qryListagem: TADOQuery
    Parameters = <>
    Left = 248
    Top = 24
  end
  object qryDados: TADOQuery
    Parameters = <>
    Left = 312
    Top = 24
  end
  object qryCheque: TADOQuery
    Parameters = <>
    Left = 376
    Top = 24
  end
end
