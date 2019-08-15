inherited FrmIndice: TFrmIndice
  Top = 61
  ActiveControl = dbgRegistro
  Caption = 'Indices'
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlClaro: TPanel
    inherited PnlTitulo: TPanel
      inherited RxTitulo: TLabel
        Width = 200
        Caption = ' '#183' Listagem de Ind'#237'ces'
      end
    end
    inherited dbgRegistro: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'IDINDICE'
          Title.Caption = 'C'#243'digo'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome'
          Width = 460
          Visible = True
        end>
    end
    inherited Panel: TPanel
      object lbID: TLabel
        Left = 9
        Top = 9
        Width = 33
        Height = 14
        Caption = 'C'#243'digo'
        FocusControl = dbID
      end
      object Label2: TLabel
        Left = 100
        Top = 9
        Width = 73
        Height = 14
        Caption = 'Nome do '#205'ndice'
        FocusControl = dbNome
      end
      object dbID: TDBEdit
        Left = 9
        Top = 26
        Width = 86
        Height = 22
        DataField = 'IDINDICE'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbNome: TDBEdit
        Left = 100
        Top = 26
        Width = 400
        Height = 22
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = dtsRegistro
        TabOrder = 1
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 48
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
    Active = True
    FieldDefs = <
      item
        Name = 'IDEMPRESA'
        DataType = ftInteger
      end
      item
        Name = 'IDINDICE'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 30
      end>
    AfterPost = mtRegistroAfterCancel
    Left = 48
    Top = 256
    Data = {
      560000009619E0BD010000001800000003000000000003000000560009494445
      4D50524553410400010000000000084944494E44494345040001000000000004
      4E4F4D450100490000000100055749445448020002001E000000}
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDINDICE: TIntegerField
      FieldName = 'IDINDICE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
end
