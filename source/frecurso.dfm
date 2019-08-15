inherited FrmRecurso: TFrmRecurso
  Top = 49
  Caption = 'Recursos'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlClaro: TPanel
    inherited PnlTitulo: TPanel
      inherited RxTitulo: TLabel
        Width = 226
        Caption = ' '#183' Listagem de Recursos'
      end
    end
    inherited dbgRegistro: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'IDRECURSO'
          Title.Caption = 'ID'
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
        Top = 24
        Width = 80
        Height = 21
        DataField = 'IDRECURSO'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbNome: TDBEdit
        Left = 93
        Top = 24
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
    Left = 48
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
    AfterPost = mtRegistroAfterCancel
    Left = 48
    Top = 256
    object mtRegistroIDRECURSO: TIntegerField
      FieldName = 'IDRECURSO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
end
