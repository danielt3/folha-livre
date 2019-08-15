object frmLista: TfrmLista
  Left = 131
  Top = 133
  Width = 299
  Height = 187
  Caption = 'Listagem Banc'#225'ria'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object TbPrinter1: TTbPrinter
    FastPrinter = Epson_FX
    FastPort = 'LPT1'
    FastFont = [Comprimido]
    Zoom = zReal
    Preview = False
    WinPrinter = 'Epson LX-810'
    WinPort = 'LPT1:'
    LineaTitulo = 3
    LineaSubTitulo = 4
    Left = 28
    Top = 20
  end
  object TbCustomReport1: TTbCustomReport
    Printer = TbPrinter1
    OnGenerate = TbCustomReport1Generate
    Left = 92
    Top = 20
  end
  object qryLiquido: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    Left = 184
    Top = 16
  end
end
