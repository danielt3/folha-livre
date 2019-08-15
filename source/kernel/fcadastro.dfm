inherited FrmCadastro: TFrmCadastro
  HorzScrollBar.Range = 0
  BorderStyle = bsNone
  FormStyle = fsMDIChild
  OldCreateOrder = True
  OnActivate = FormResize
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Width = 162
    inherited lblSeparador: TLabel
      Width = 162
    end
    inherited lblPrograma: TPanel
      Width = 162
    end
    inherited pnlPesquisa: TPanel
      Width = 162
      Visible = True
      inherited lblPesquisa: TLabel
        Width = 162
      end
      inherited PesquisaTipo: TDBLookupComboBox
        KeyField = 'CHAVE'
        ListField = 'CHAVE'
        ListSource = dtsPesquisa
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 162
    Width = 628
    inherited PnlControle: TPanel
      Width = 628
      inherited btnExcluir: TSpeedButton
        Hint = 'Exclui Registro - [Ctrl+Delete]'
      end
      inherited btnImprimir: TSpeedButton
        OnClick = btnImprimirClick
      end
    end
    inherited PnlTitulo: TPanel
      Width = 628
      inherited PnlFechar: TPanel
        Left = 499
        Width = 129
        inherited RxFechar: TSpeedButton
          Left = 99
        end
        object btnDetalhar: TSpeedButton
          Left = 4
          Top = 5
          Width = 86
          Height = 22
          Caption = '&Detalhar...'
          Flat = True
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          NumGlyphs = 2
          ParentFont = False
          Spacing = 5
          OnClick = btnDetalharClick
        end
      end
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 30
      Width = 628
      Height = 451
      ActivePage = TabListagem
      Align = alClient
      Style = tsButtons
      TabOrder = 2
      TabStop = False
      OnChange = PageControl1Change
      object TabListagem: TTabSheet
        Caption = 'TabListagem'
        object dbgRegistro: TDBGrid
          Left = 0
          Top = 0
          Width = 620
          Height = 419
          Align = alClient
          BorderStyle = bsNone
          DataSource = dtsListagem
          Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentColor = True
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          OnDrawColumnCell = dbgRegistroDrawColumnCell
          OnDblClick = dbgRegistroDblClick
          OnTitleClick = dbgRegistroTitleClick
        end
      end
      object TabDetalhe: TTabSheet
        Caption = 'TabDetalhe'
        ImageIndex = 1
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 48
    Top = 328
  end
  object mtListagem: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 178
    Top = 400
  end
  object dtsListagem: TDataSource
    AutoEdit = False
    DataSet = mtListagem
    Left = 240
    Top = 400
  end
  object mtPesquisa: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'CHAVE'
    Params = <>
    Left = 402
    Top = 456
    object mtPesquisaCHAVE: TStringField
      FieldName = 'CHAVE'
      Size = 30
    end
    object mtPesquisaVALOR: TStringField
      DisplayWidth = 800
      FieldName = 'VALOR'
      Size = 800
    end
    object mtPesquisaACCEPTEMPTY: TBooleanField
      FieldName = 'ACCEPTEMPTY'
    end
    object mtPesquisaACCEPTALL: TBooleanField
      FieldName = 'ACCEPTALL'
    end
  end
  object mtColuna: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 330
    Top = 456
    object mtColunaCOLUNA: TIntegerField
      FieldName = 'COLUNA'
    end
    object mtColunaTITULO: TStringField
      FieldName = 'TITULO'
      Size = 30
    end
    object mtColunaTAMANHO: TSmallintField
      FieldName = 'TAMANHO'
    end
    object mtColunaDISPLAY: TSmallintField
      FieldName = 'DISPLAY'
    end
    object mtColunaMASCARA: TStringField
      FieldName = 'MASCARA'
      Size = 30
    end
  end
  object dtsPesquisa: TDataSource
    AutoEdit = False
    DataSet = mtPesquisa
    Left = 488
    Top = 456
  end
end
