inherited FrmTabela: TFrmTabela
  Left = 95
  Top = 27
  HorzScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Tabelas de C'#225'lculo'
  ClientHeight = 423
  ClientWidth = 592
  Visible = False
  WindowState = wsNormal
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlEscuro: TPanel
    Width = 0
    Height = 423
    Visible = False
    inherited lblSeparador: TLabel
      Width = 0
    end
    inherited lblPrograma: TLabel
      Width = 0
      Caption = 'Tabelas'
    end
    inherited pnlPesquisa: TPanel
      Top = 323
      Width = 0
      inherited lblPesquisa: TLabel
        Width = 0
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 0
    Width = 592
    Height = 423
    inherited PnlControle: TPanel
      Top = 383
      Width = 592
    end
    inherited PnlTitulo: TPanel
      Width = 592
      inherited RxTitulo: TLabel
        Width = 328
        Caption = ' '#183' Listagem de Tabelas de C'#225'lculos'
      end
      inherited PnlFechar: TPanel
        Left = 552
      end
    end
    object PageControl: TPageControl
      Left = 0
      Top = 30
      Width = 592
      Height = 353
      ActivePage = TabTabela
      Align = alClient
      HotTrack = True
      MultiLine = True
      Style = tsButtons
      TabOrder = 2
      OnChange = PageControlChange
      OnChanging = PageControlChanging
      object TabTabela: TTabSheet
        Caption = '&Tabelas de C'#225'lculo'
        object dbgTabela: TDBGrid
          Tag = 1
          Left = 0
          Top = 0
          Width = 584
          Height = 273
          Align = alClient
          BorderStyle = bsNone
          DataSource = dtsRegistro
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentColor = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgTabelaDrawColumnCell
          OnTitleClick = dbgTabelaTitleClick
          Columns = <
            item
              Expanded = False
              FieldName = 'IDTABELA'
              Title.Caption = 'ID'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome da Tabela'
              Width = 450
              Visible = True
            end>
        end
        object Panel: TPanel
          Left = 0
          Top = 273
          Width = 584
          Height = 49
          Align = alBottom
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object lbCodigo: TLabel
            Left = 8
            Top = 8
            Width = 33
            Height = 13
            Caption = 'C'#243'digo'
            FocusControl = dbCodigo
          end
          object lbNome: TLabel
            Left = 73
            Top = 8
            Width = 28
            Height = 13
            Caption = 'Nome'
            FocusControl = dbNome
          end
          object dbCodigo: TDBEdit
            Left = 8
            Top = 23
            Width = 60
            Height = 21
            DataField = 'IDTABELA'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbNome: TDBEdit
            Left = 73
            Top = 23
            Width = 350
            Height = 21
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dtsRegistro
            TabOrder = 1
          end
        end
      end
      object TabModelo: TTabSheet
        Caption = '&Modelo de Itens'
        ImageIndex = 2
        object dbgModelo: TDBGrid
          Tag = 1
          Left = 0
          Top = 0
          Width = 584
          Height = 273
          Align = alClient
          BorderStyle = bsNone
          DataSource = dsModelo
          Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
          ParentColor = True
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgTabelaDrawColumnCell
          OnTitleClick = dbgTabelaTitleClick
          Columns = <
            item
              Expanded = False
              FieldName = 'ITEM'
              Title.Caption = 'ID'
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Descri'#231#227'o do Item'
              Width = 450
              Visible = True
            end>
        end
        object Panel1: TPanel
          Left = 0
          Top = 273
          Width = 584
          Height = 49
          Align = alBottom
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 1
          object lbItem: TLabel
            Left = 8
            Top = 8
            Width = 20
            Height = 13
            Caption = 'Item'
            FocusControl = dbItem
          end
          object lbItemNome: TLabel
            Left = 73
            Top = 8
            Width = 86
            Height = 13
            Caption = 'Descri'#231#227'o do Item'
            FocusControl = dbItemNome
          end
          object dbItem: TDBEdit
            Left = 8
            Top = 23
            Width = 60
            Height = 21
            DataField = 'ITEM'
            DataSource = dsModelo
            TabOrder = 0
          end
          object dbItemNome: TDBEdit
            Left = 73
            Top = 23
            Width = 350
            Height = 21
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dsModelo
            TabOrder = 1
          end
        end
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 48
    Top = 200
  end
  object cdModelo: TClientDataSet [3]
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforeInsert = mtRegistroBeforeInsert
    BeforeEdit = mtRegistroBeforeEdit
    BeforePost = mtRegistroBeforePost
    AfterPost = mtRegistroAfterCancel
    AfterCancel = mtRegistroAfterCancel
    BeforeDelete = mtRegistroBeforeDelete
    OnNewRecord = mtRegistroNewRecord
    Left = 272
    Top = 264
    object cdModeloIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdModeloIDTABELA: TIntegerField
      FieldName = 'IDTABELA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdModeloITEM: TSmallintField
      FieldName = 'ITEM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdModeloNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object dsModelo: TDataSource [4]
    DataSet = cdModelo
    OnStateChange = dtsRegistroStateChange
    Left = 272
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
    Active = True
    BeforeInsert = mtRegistroBeforeInsert
    Left = 48
    Top = 256
    Data = {
      560000009619E0BD010000001800000003000000000003000000560009494445
      4D50524553410400010000000000084944544142454C41040001000000000004
      4E4F4D4501004900000001000557494454480200020032000000}
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDTABELA: TIntegerField
      FieldName = 'IDTABELA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
  end
end
