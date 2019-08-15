inherited FrmBanco: TFrmBanco
  Left = 140
  Top = 69
  HorzScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Bancos e Ag'#234'ncias Banc'#225'rias'
  ClientHeight = 431
  ClientWidth = 646
  OldCreateOrder = True
  Position = poDesktopCenter
  Visible = False
  WindowState = wsNormal
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Width = 1
    Height = 431
    Visible = False
    inherited lblSeparador: TLabel
      Width = 1
    end
    inherited lblPrograma: TPanel
      Width = 1
      Caption = 'Unidades'
    end
    inherited pnlPesquisa: TPanel
      Top = 331
      Width = 1
      inherited lblPesquisa: TLabel
        Width = 1
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 1
    Width = 645
    Height = 431
    inherited PnlControle: TPanel
      Top = 391
      Width = 645
      inherited btnExcluir: TSpeedButton
        OnClick = btnExcluirClick
      end
      inherited btnEditar: TSpeedButton
        OnClick = btnEditarClick
      end
      inherited btnGravar: TSpeedButton
        OnClick = btnGravarClick
      end
      inherited btnCancelar: TSpeedButton
        OnClick = btnCancelarClick
      end
    end
    inherited PnlTitulo: TPanel
      Width = 645
      inherited RxTitulo: TLabel
        Width = 193
        Caption = ' '#183' Bancos e Ag'#234'ncias'
      end
      inherited PnlFechar: TPanel
        Left = 605
      end
    end
    object PageControl: TPageControl
      Left = 0
      Top = 73
      Width = 645
      Height = 318
      ActivePage = TabAgencia
      Align = alClient
      Style = tsButtons
      TabOrder = 2
      OnChange = PageControlChange
      OnChanging = PageControlChanging
      object TabBanco: TTabSheet
        Caption = '&Bancos'
        ImageIndex = 2
        object dbgBanco: TDBGrid
          Tag = 1
          Left = 0
          Top = 0
          Width = 637
          Height = 232
          Align = alClient
          BorderStyle = bsNone
          DataSource = dtsRegistro
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentColor = True
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgBancoDrawColumnCell
          OnTitleClick = dbgBancoTitleClick
          Columns = <
            item
              Expanded = False
              FieldName = 'IDBANCO'
              Title.Caption = 'C'#243'digo'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome do Banco'
              Width = 490
              Visible = True
            end>
        end
        object pnlQuadro: TPanel
          Left = 0
          Top = 232
          Width = 637
          Height = 54
          Align = alBottom
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object lbBanco2: TLabel
            Left = 89
            Top = 9
            Width = 76
            Height = 14
            Caption = 'Nome do Banco'
            FocusControl = dbBanco2
          end
          object lbBanco: TLabel
            Left = 9
            Top = 9
            Width = 33
            Height = 14
            Caption = 'C'#243'digo'
            FocusControl = dbBanco
          end
          object dbBanco: TDBEdit
            Left = 9
            Top = 26
            Width = 75
            Height = 22
            CharCase = ecUpperCase
            DataField = 'IDBANCO'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbBanco2: TDBEdit
            Left = 89
            Top = 26
            Width = 431
            Height = 22
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dtsRegistro
            TabOrder = 1
          end
        end
      end
      object TabAgencia: TTabSheet
        Caption = '&Ag'#234'ncias'
        object dbgAgencia: TDBGrid
          Tag = 1
          Left = 0
          Top = 0
          Width = 637
          Height = 232
          Align = alClient
          BorderStyle = bsNone
          DataSource = dsAgencia
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentColor = True
          ParentFont = False
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgBancoDrawColumnCell
          OnTitleClick = dbgBancoTitleClick
          Columns = <
            item
              Expanded = False
              FieldName = 'IDAGENCIA'
              Title.Caption = 'C'#243'digo'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome da Ag'#234'ncia'
              Width = 490
              Visible = True
            end>
        end
        object pnlAgencia: TPanel
          Left = 0
          Top = 232
          Width = 637
          Height = 54
          Align = alBottom
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object lbAgencia: TLabel
            Left = 9
            Top = 9
            Width = 33
            Height = 14
            Caption = 'C'#243'digo'
          end
          object lbAgencia2: TLabel
            Left = 89
            Top = 9
            Width = 85
            Height = 14
            Caption = 'Nome da Ag'#234'ncia'
            FocusControl = dbAgencia2
          end
          object dbAgencia2: TDBEdit
            Left = 89
            Top = 26
            Width = 442
            Height = 22
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dsAgencia
            TabOrder = 1
          end
          object dbAgencia: TDBEdit
            Left = 9
            Top = 26
            Width = 75
            Height = 22
            CharCase = ecUpperCase
            DataField = 'IDAGENCIA'
            DataSource = dsAgencia
            TabOrder = 0
          end
          object ComboBox1: TComboBox
            Left = 592
            Top = 40
            Width = 145
            Height = 22
            ItemHeight = 14
            TabOrder = 2
            Text = 'ComboBox1'
          end
        end
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 30
      Width = 645
      Height = 43
      Align = alTop
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 3
      object dbBancoNome: TDBEdit
        Tag = 1
        Left = 89
        Top = 9
        Width = 517
        Height = 24
        TabStop = False
        Color = clTeal
        DataField = 'NOME'
        DataSource = dtsRegistro
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object dbBancoID: TDBEdit
        Tag = 1
        Left = 9
        Top = 9
        Width = 75
        Height = 24
        TabStop = False
        Color = clTeal
        DataField = 'IDBANCO'
        DataSource = dtsRegistro
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 88
    Top = 144
  end
  inherited mtRegistro: TClientDataSet
    StoreDefs = True
    BeforeInsert = mtRegistroBeforeInsert
    Left = 90
    Top = 200
    object mtRegistroIDBANCO: TStringField
      FieldName = 'IDBANCO'
      ProviderFlags = [pfInUpdate, pfInKey]
      Size = 3
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
  end
  object cdAgencia: TClientDataSet
    Aggregates = <>
    AggregatesActive = True
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforeInsert = mtRegistroBeforeInsert
    BeforeEdit = mtRegistroBeforeEdit
    BeforePost = mtRegistroBeforePost
    AfterPost = mtRegistroAfterPost
    AfterCancel = mtRegistroAfterCancel
    BeforeDelete = mtRegistroBeforeDelete
    OnNewRecord = mtRegistroNewRecord
    Left = 176
    Top = 200
    object cdAgenciaIDBANCO: TStringField
      FieldName = 'IDBANCO'
      ProviderFlags = [pfInUpdate, pfInKey]
      Size = 3
    end
    object cdAgenciaIDAGENCIA: TStringField
      FieldName = 'IDAGENCIA'
      ProviderFlags = [pfInUpdate, pfInKey]
      OnGetText = cdAgenciaIDAGENCIAGetText
      Size = 5
    end
    object cdAgenciaNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
  end
  object dsAgencia: TDataSource
    AutoEdit = False
    DataSet = cdAgencia
    OnStateChange = dtsRegistroStateChange
    Left = 174
    Top = 144
  end
end
