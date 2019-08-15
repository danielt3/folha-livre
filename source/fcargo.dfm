inherited FrmCargo: TFrmCargo
  Left = 118
  Top = 103
  Caption = 'Cadastro de Cargos'
  ClientWidth = 592
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlClaro: TPanel
    Width = 591
    inherited PnlControle: TPanel
      Width = 591
      inherited RxRecord: TAKStatus
        Left = 509
      end
    end
    inherited PnlTitulo: TPanel
      Width = 591
      inherited RxTitulo: TLabel
        Width = 207
        Caption = ' '#183' Listagem de Cargos'
      end
      inherited PnlFechar: TPanel
        Left = 551
      end
    end
    inherited dbgRegistro: TDBGrid
      Width = 591
      Columns = <
        item
          Expanded = False
          FieldName = 'IDCARGO'
          Title.Caption = 'C'#243'digo'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome do Cargo'
          Width = 400
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CBO'
          Width = 35
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'SALARIO'
          Title.Caption = 'Sal'#225'rio'
          Width = 70
          Visible = True
        end>
    end
    inherited Panel: TPanel
      Width = 591
      object lbCargo: TLabel
        Left = 8
        Top = 8
        Width = 33
        Height = 13
        Caption = 'C'#243'digo'
        FocusControl = dbCargo
      end
      object lbNome: TLabel
        Left = 73
        Top = 8
        Width = 28
        Height = 13
        Caption = 'Nome'
        FocusControl = dbNome
      end
      object lbCBO: TLabel
        Left = 428
        Top = 8
        Width = 31
        Height = 13
        Caption = 'C.B.O.'
        FocusControl = dbCBO
      end
      object lbSalario: TLabel
        Left = 484
        Top = 8
        Width = 69
        Height = 13
        Caption = 'Sal'#225'rio Padr'#227'o'
        FocusControl = dbSalario
      end
      object dbCargo: TDBEdit
        Left = 8
        Top = 23
        Width = 60
        Height = 19
        DataField = 'IDCARGO'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbNome: TDBEdit
        Left = 73
        Top = 23
        Width = 350
        Height = 19
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = dtsRegistro
        TabOrder = 1
      end
      object dbCBO: TDBEdit
        Left = 428
        Top = 23
        Width = 50
        Height = 19
        DataField = 'CBO'
        DataSource = dtsRegistro
        TabOrder = 2
      end
      object dbSalario: TDBEdit
        Left = 483
        Top = 23
        Width = 80
        Height = 19
        DataField = 'SALARIO'
        DataSource = dtsRegistro
        DisplayFormat = ',0.00'
        NumGlyphs = 2
        TabOrder = 3
        ZeroEmpty = False
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 72
    Top = 216
  end
  inherited mtRegistro: TClientDataSet
    IndexFieldNames = 'IDCARGO'
    BeforeInsert = mtRegistroBeforeInsert
    AfterPost = mtRegistroAfterCancel
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDCARGO: TIntegerField
      FieldName = 'IDCARGO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtRegistroCBO: TStringField
      FieldName = 'CBO'
      Size = 5
    end
    object mtRegistroSALARIO: TCurrencyField
      FieldName = 'SALARIO'
      DisplayFormat = ',0.00'
    end
  end
end
