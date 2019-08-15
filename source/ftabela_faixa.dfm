inherited FrmTabelaFaixa: TFrmTabelaFaixa
  Left = 109
  Top = 61
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
    inherited lblPrograma: TPanel
      Width = 0
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
      Enabled = False
    end
    inherited PnlTitulo: TPanel
      Width = 592
      inherited RxTitulo: TLabel
        Width = 295
        Caption = ' '#183' Tabela: 1 - Imposto de Renda'
      end
      inherited PnlFechar: TPanel
        Left = 552
      end
    end
    object dbgFaixa: TDBGrid
      Tag = 1
      Left = 0
      Top = 30
      Width = 332
      Height = 353
      Align = alClient
      BorderStyle = bsNone
      DataSource = dtsRegistro
      Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
      ParentColor = True
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = dbgFaixaDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'FAIXA'
          Title.Caption = 'Faixa - At'#233
          Width = 88
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TAXA'
          Title.Caption = 'Taxa %'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'REDUZIR'
          Title.Caption = 'A reduzir'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ACRESCENTAR'
          Title.Caption = 'A acrescentar'
          Width = 80
          Visible = True
        end>
    end
    object dbgItem: TDBGrid
      Tag = 1
      Left = 332
      Top = 30
      Width = 260
      Height = 353
      Align = alRight
      BorderStyle = bsNone
      DataSource = dsItem
      Options = [dgEditing, dgTitles, dgIndicator, dgColLines, dgRowLines, dgConfirmDelete, dgCancelOnExit]
      ParentColor = True
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnDrawColumnCell = dbgFaixaDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'NOME'
          ReadOnly = True
          Title.Caption = 'Item'
          Width = 158
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALOR'
          Title.Caption = 'Valor'
          Width = 70
          Visible = True
        end>
    end
  end
  inherited dtsRegistro: TDataSource
    AutoEdit = True
    OnStateChange = nil
    Left = 48
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
    StoreDefs = True
    BeforeEdit = nil
    AfterDelete = mtRegistroAfterDelete
    Left = 48
    Top = 256
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDTABELA: TIntegerField
      FieldName = 'IDTABELA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroCOMPETENCIA: TDateField
      FieldName = 'COMPETENCIA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDFAIXA: TIntegerField
      FieldName = 'IDFAIXA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroFAIXA: TCurrencyField
      FieldName = 'FAIXA'
      DisplayFormat = ',0.00'
    end
    object mtRegistroTAXA: TCurrencyField
      FieldName = 'TAXA'
      DisplayFormat = ',0.## %'
    end
    object mtRegistroREDUZIR: TCurrencyField
      FieldName = 'REDUZIR'
      DisplayFormat = ',0.00'
    end
    object mtRegistroACRESCENTAR: TCurrencyField
      FieldName = 'ACRESCENTAR'
      DisplayFormat = ',0.00'
    end
  end
  object cdItem: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforeInsert = cdItemBeforeInsert
    BeforePost = mtRegistroBeforePost
    OnNewRecord = mtRegistroNewRecord
    Left = 208
    Top = 264
    object cdItemIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdItemIDTABELA: TIntegerField
      FieldName = 'IDTABELA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdItemCOMPETENCIA: TDateField
      FieldName = 'COMPETENCIA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdItemITEM: TSmallintField
      FieldName = 'ITEM'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdItemNOME: TStringField
      FieldName = 'NOME'
      ProviderFlags = [pfInUpdate, pfInWhere, pfHidden]
      Size = 30
    end
    object cdItemVALOR: TCurrencyField
      FieldName = 'VALOR'
      DisplayFormat = ',0.##'
    end
  end
  object dsItem: TDataSource
    DataSet = cdItem
    Left = 208
    Top = 200
  end
end
