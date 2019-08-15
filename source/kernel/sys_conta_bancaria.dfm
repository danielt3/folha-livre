inherited FrmContaBancaria: TFrmContaBancaria
  Left = 163
  Top = 77
  Caption = 'Contas Banc'#225'rias'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlClaro: TPanel
    inherited PnlTitulo: TPanel
      inherited RxTitulo: TLabel
        Width = 299
        Caption = ' '#183' Listagem de Contas Banc'#225'rias'
      end
    end
    inherited dbgRegistro: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'IDCONTA'
          Title.Caption = 'N'#250'mero'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IDBANCO'
          Title.Caption = 'Banco'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IDAGENCIA'
          Title.Caption = 'Ag'#234'ncia'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TITULO'
          Title.Caption = 'T'#237'tulo (Descri'#231#227'o)'
          Width = 238
          Visible = True
        end>
    end
    inherited Panel: TPanel
      object lbID: TLabel
        Left = 8
        Top = 8
        Width = 37
        Height = 13
        Caption = 'N'#250'mero'
        FocusControl = dbID
      end
      object lbTitulo: TLabel
        Left = 263
        Top = 8
        Width = 146
        Height = 13
        Caption = 'Titulo da Conta (10 caracteres)'
        FocusControl = dbTitulo
      end
      object lbBanco: TLabel
        Left = 93
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Banco'
        FocusControl = dbBanco
      end
      object lbAgencia: TLabel
        Left = 178
        Top = 8
        Width = 39
        Height = 13
        Caption = 'Ag'#234'ncia'
        FocusControl = dbAgencia
      end
      object dbID: TDBEdit
        Left = 8
        Top = 24
        Width = 80
        Height = 21
        DataField = 'IDCONTA'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbTitulo: TDBEdit
        Left = 263
        Top = 24
        Width = 150
        Height = 21
        CharCase = ecUpperCase
        DataField = 'TITULO'
        DataSource = dtsRegistro
        TabOrder = 3
      end
      object dbBanco: TDBEdit
        Left = 93
        Top = 24
        Width = 80
        Height = 21
        DataField = 'IDBANCO'
        DataSource = dtsRegistro
        TabOrder = 1
      end
      object dbAgencia: TDBEdit
        Left = 178
        Top = 24
        Width = 80
        Height = 21
        DataField = 'IDAGENCIA'
        DataSource = dtsRegistro
        TabOrder = 2
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 112
  end
  inherited mtRegistro: TClientDataSet
    AfterPost = mtRegistroAfterCancel
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDCONTA: TStringField
      FieldName = 'IDCONTA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 9
    end
    object mtRegistroIDBANCO: TStringField
      FieldName = 'IDBANCO'
      Size = 3
    end
    object mtRegistroIDAGENCIA: TStringField
      FieldName = 'IDAGENCIA'
      Size = 4
    end
    object mtRegistroTITULO: TStringField
      FieldName = 'TITULO'
      Size = 10
    end
  end
end
