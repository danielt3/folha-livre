inherited FrmCadastro_dbx: TFrmCadastro_dbx
  Left = -4
  Top = -4
  HorzScrollBar.Range = 0
  BorderStyle = bsNone
  ClientHeight = 553
  ClientWidth = 800
  FormStyle = fsMDIChild
  OnActivate = FormResize
  OnClose = FormClose
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlEscuro: TPanel
    Width = 150
    Height = 553
    inherited lblSeparador: TLabel
      Width = 150
    end
    inherited lblPrograma: TLabel
      Width = 150
    end
    inherited pnlPesquisa: TPanel
      Top = 453
      Width = 150
      Visible = True
      inherited lblPesquisa: TLabel
        Width = 150
      end
      inherited PesquisaTipo: TDBLookupComboBox
        KeyField = 'CHAVE'
        ListField = 'CHAVE'
        ListSource = dtsPesquisa
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 150
    Width = 650
    Height = 553
    inherited PnlControle: TPanel
      Top = 513
      Width = 650
      inherited btnExcluir: TSpeedButton
        Hint = 'Exclui Registro - [Ctrl+Delete]'
      end
      inherited btnImprimir: TSpeedButton
        OnClick = btnImprimirClick
      end
    end
    inherited PnlTitulo: TPanel
      Width = 650
      inherited PnlFechar: TPanel
        Left = 530
        Width = 120
        inherited RxFechar: TSpeedButton
          Left = 92
        end
        object btnDetalhar: TSpeedButton
          Left = 4
          Top = 5
          Width = 80
          Height = 20
          Caption = '&Detalhar...'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWhite
          Font.Height = -8
          Font.Name = 'MS Sans Serif'
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
      Width = 650
      Height = 483
      ActivePage = TabListagem
      Align = alClient
      Style = tsButtons
      TabIndex = 0
      TabOrder = 2
      TabStop = False
      OnChange = PageControl1Change
      object TabListagem: TTabSheet
        Caption = 'TabListagem'
        object dbgRegistro: TDBGrid
          Left = 0
          Top = 0
          Width = 642
          Height = 452
          Align = alClient
          BorderStyle = bsNone
          DataSource = dtsListagem
          Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentColor = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
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
