inherited FrmDialogo: TFrmDialogo
  Left = 65
  Top = 33
  HorzScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Cadastro'
  ClientHeight = 402
  ClientWidth = 594
  OldCreateOrder = True
  Visible = False
  WindowState = wsNormal
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Width = 1
    Height = 402
    Visible = False
    inherited lblSeparador: TLabel
      Width = 1
    end
    inherited lblPrograma: TPanel
      Width = 1
      Caption = 'Lota'#231#227'o'
    end
    inherited pnlPesquisa: TPanel
      Top = 302
      Width = 1
      inherited lblPesquisa: TLabel
        Width = 1
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 1
    Width = 593
    Height = 402
    inherited PnlControle: TPanel
      Top = 362
      Width = 593
      TabOrder = 3
      inherited btnImprimir: TSpeedButton
        OnClick = btnImprimirClick
      end
    end
    inherited PnlTitulo: TPanel
      Width = 593
      UseDockManager = False
      DockSite = True
      inherited RxTitulo: TLabel
        Width = 100
        Caption = ' '#183' Listagem'
      end
      inherited PnlFechar: TPanel
        Left = 553
      end
    end
    object dbgRegistro: TDBGrid
      Tag = 1
      Left = 0
      Top = 30
      Width = 593
      Height = 272
      Align = alClient
      BorderStyle = bsNone
      DataSource = dtsRegistro
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Pitch = fpVariable
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentColor = True
      ParentFont = False
      TabOrder = 1
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Pitch = fpVariable
      TitleFont.Style = []
      OnDrawColumnCell = dbgRegistroDrawColumnCell
      OnTitleClick = dbgRegistroTitleClick
    end
    object Panel: TPanel
      Left = 0
      Top = 302
      Width = 593
      Height = 60
      Align = alBottom
      BevelInner = bvLowered
      ParentColor = True
      TabOrder = 2
      OnExit = PanelExit
    end
  end
  inherited dtsRegistro: TDataSource
    Top = 224
  end
  inherited mtRegistro: TClientDataSet
    StoreDefs = True
    BeforeInsert = mtRegistroBeforeInsert
  end
end
