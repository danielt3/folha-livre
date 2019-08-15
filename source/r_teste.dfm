object frmTeste: TfrmTeste
  Left = 145
  Top = 90
  Width = 828
  Height = 480
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object RLReport1: TRLReport
    Left = 0
    Top = 0
    Width = 794
    Height = 1123
    AllowedBands = [btTitle, btDetail]
    Borders.Width = 2
    Degrade.OppositeColor = clSilver
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'Courier New'
    Font.Style = []
    PageSetup.ForceEmulation = True
  end
  object RLPDFFilter1: TRLPDFFilter
    DocumentInfo.Creator = 'FortesReport v3.23 \251 Copyright '#169' 1999-2004 Fortes Inform'#225'tica'
    ViewerOptions = []
    FontEncoding = feNoEncoding
    FileName = 'C:\Documents and Settings\win98\Desktop\TESTE.pdf'
    DisplayName = 'Documento PDF'
    Left = 160
    Top = 112
  end
end
