inherited frmsysglobal: Tfrmsysglobal
  Left = 97
  Top = 34
  BorderIcons = [biSystemMenu]
  Caption = 'Configura'#231#227'o Globais do Sistema'
  ClientHeight = 456
  ClientWidth = 691
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Width = 0
    Height = 456
    inherited lblSeparador: TLabel
      Width = 0
    end
    inherited lblPrograma: TPanel
      Width = 0
      Caption = 'Global'
    end
    inherited pnlPesquisa: TPanel
      Top = 356
      Width = 0
      inherited lblPesquisa: TLabel
        Width = 0
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 0
    Width = 691
    Height = 456
    inherited PnlControle: TPanel
      Top = 416
      Width = 691
      TabOrder = 2
    end
    inherited PnlTitulo: TPanel
      Width = 691
      inherited RxTitulo: TLabel
        Width = 270
        Caption = ' '#183' Listagem de Configura'#231#245'es'
      end
      inherited PnlFechar: TPanel
        Left = 651
      end
    end
    inherited dbgRegistro: TDBGrid
      Width = 691
      Height = 241
      TabOrder = 3
      TitleFont.Style = [fsBold]
      Columns = <
        item
          Expanded = False
          FieldName = 'LOCAL'
          Title.Caption = 'Local'
          Width = 140
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CHAVE'
          Title.Caption = 'Chave'
          Width = 238
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALOR'
          Title.Caption = 'Valor (max. 100 caracteres)'
          Width = 230
          Visible = True
        end>
    end
    inherited Panel: TPanel
      Top = 271
      Width = 691
      Height = 145
      BevelOuter = bvNone
      TabOrder = 1
      object lbLocal: TLabel
        Left = 9
        Top = 9
        Width = 105
        Height = 14
        Caption = 'Local (15 caracteres)'
        FocusControl = dbLocal
      end
      object lbChave: TLabel
        Left = 176
        Top = 9
        Width = 110
        Height = 14
        Caption = 'Chave (30 caracteres)'
        FocusControl = dbChave
      end
      object lbValor: TLabel
        Left = 9
        Top = 52
        Width = 111
        Height = 14
        Caption = 'Valor (100 caracteres)'
        FocusControl = dbValor
      end
      object lbDescricao: TLabel
        Left = 9
        Top = 95
        Width = 134
        Height = 14
        Caption = 'Descri'#231#227'o (100 caracteres)'
        FocusControl = dbDescricao
      end
      object dbLocal: TDBEdit
        Left = 9
        Top = 25
        Width = 161
        Height = 22
        CharCase = ecUpperCase
        DataField = 'LOCAL'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbChave: TDBEdit
        Left = 176
        Top = 25
        Width = 376
        Height = 22
        CharCase = ecUpperCase
        DataField = 'CHAVE'
        DataSource = dtsRegistro
        TabOrder = 1
      end
      object dbValor: TDBEdit
        Left = 9
        Top = 68
        Width = 543
        Height = 22
        DataField = 'VALOR'
        DataSource = dtsRegistro
        TabOrder = 2
      end
      object dbDescricao: TDBEdit
        Left = 9
        Top = 111
        Width = 543
        Height = 22
        DataField = 'DESCRICAO'
        DataSource = dtsRegistro
        TabOrder = 3
      end
      object dbAtivo: TDBCheckBox
        Left = 560
        Top = 112
        Width = 104
        Height = 18
        Caption = 'Ativo'
        DataField = 'ATIVO'
        DataSource = dtsRegistro
        TabOrder = 4
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 48
    Top = 248
  end
  inherited mtRegistro: TClientDataSet
    object mtRegistroID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroLOCAL: TStringField
      FieldName = 'LOCAL'
      Size = 15
    end
    object mtRegistroCHAVE: TStringField
      FieldName = 'CHAVE'
      Size = 30
    end
    object mtRegistroVALOR: TStringField
      FieldName = 'VALOR'
      Size = 100
    end
    object mtRegistroDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 100
    end
    object mtRegistroATIVO: TSmallintField
      FieldName = 'ATIVO'
    end
  end
end
