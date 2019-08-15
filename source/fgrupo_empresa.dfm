inherited FrmGrupoEmpresa: TFrmGrupoEmpresa
  Left = 90
  Top = 84
  Caption = 'Grupo de Empresas'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlClaro: TPanel
    inherited PnlTitulo: TPanel
      inherited RxTitulo: TLabel
        Width = 216
        Caption = ' '#183' Grupos de Empresas'
      end
    end
    inherited dbgRegistro: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'IDGE'
          Title.Caption = 'ID'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Width = 460
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
      object dbID: TDBEdit
        Left = 8
        Top = 23
        Width = 80
        Height = 21
        DataField = 'IDGE'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbNome: TDBEdit
        Left = 93
        Top = 23
        Width = 400
        Height = 21
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = dtsRegistro
        TabOrder = 1
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 112
  end
  inherited mtRegistro: TClientDataSet
    object mtRegistroIDGE: TIntegerField
      FieldName = 'IDGE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
end
