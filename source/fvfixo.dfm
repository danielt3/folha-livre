inherited FrmVFixo: TFrmVFixo
  Caption = 'Valores Fixos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlClaro: TPanel
    inherited PnlTitulo: TPanel
      inherited RxTitulo: TLabel
        Width = 266
        Caption = ' '#183' Listagem de Valores Fixos'
      end
    end
    inherited dbgRegistro: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'IDVFIXO'
          Title.Caption = 'ID'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome'
          Width = 380
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALOR'
          Title.Caption = 'Valor'
          Width = 80
          Visible = True
        end>
    end
    inherited Panel: TPanel
      object lbID: TLabel
        Left = 8
        Top = 8
        Width = 53
        Height = 13
        Caption = 'ID (C'#243'digo)'
        FocusControl = dbID
      end
      object Label2: TLabel
        Left = 93
        Top = 8
        Width = 28
        Height = 13
        Caption = 'Nome'
        FocusControl = dbNome
      end
      object lbValor: TLabel
        Left = 448
        Top = 8
        Width = 24
        Height = 13
        Caption = 'Valor'
        FocusControl = dbValor
      end
      object dbID: TDBEdit
        Left = 8
        Top = 24
        Width = 80
        Height = 21
        DataField = 'IDVFIXO'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbNome: TDBEdit
        Left = 93
        Top = 24
        Width = 350
        Height = 21
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = dtsRegistro
        TabOrder = 1
      end
      object dbValor: TDBEdit
        Left = 448
        Top = 24
        Width = 90
        Height = 21
        DataField = 'VALOR'
        DataSource = dtsRegistro
        TabOrder = 2
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 48
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
    AfterPost = mtRegistroAfterCancel
    Left = 48
    Top = 256
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDVFIXO: TIntegerField
      FieldName = 'IDVFIXO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
    object mtRegistroVALOR: TCurrencyField
      FieldName = 'VALOR'
      DisplayFormat = ',0.##'
    end
  end
end
