inherited FrmIndiceValor: TFrmIndiceValor
  Left = 108
  Top = 134
  Caption = 'Indices - Valores por Compet'#234'ncia'
  ClientHeight = 423
  ClientWidth = 592
  WindowState = wsNormal
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlEscuro: TPanel
    Width = 0
    Height = 423
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
      TabOrder = 2
    end
    inherited PnlTitulo: TPanel
      Width = 592
      inherited RxTitulo: TLabel
        Width = 86
        Caption = ' '#183' Indices'
      end
      inherited PnlFechar: TPanel
        Left = 552
      end
    end
    inherited dbgRegistro: TDBGrid
      Width = 592
      Height = 298
      Columns = <
        item
          Expanded = False
          FieldName = 'IDINDICE'
          Title.Caption = 'ID Ind'#237'ce'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Nome do Indice'
          Width = 280
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMPETENCIA'
          Title.Caption = 'Compet'#234'ncia'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALOR'
          Title.Caption = 'Valor'
          Width = 100
          Visible = True
        end>
    end
    inherited Panel: TPanel
      Top = 328
      Width = 592
      TabOrder = 3
      object lbCodigo: TLabel
        Left = 8
        Top = 8
        Width = 33
        Height = 13
        Caption = 'C'#243'digo'
      end
      object Label3: TLabel
        Left = 73
        Top = 8
        Width = 254
        Height = 13
        Caption = 'Nome do Indice (Tecle F12 para pesquisar os indices)'
      end
      object lbCompetencia: TLabel
        Left = 358
        Top = 8
        Width = 62
        Height = 13
        Caption = 'Compet'#234'ncia'
        FocusControl = dbCompetencia
      end
      object lbValor: TLabel
        Left = 453
        Top = 8
        Width = 24
        Height = 13
        Caption = 'Valor'
        FocusControl = dbValor
      end
      object dbCodigo: TDBEdit
        Left = 8
        Top = 24
        Width = 60
        Height = 21
        TabStop = False
        DataField = 'IDINDICE'
        DataSource = dtsRegistro
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
      end
      object dbNome: TDBEdit
        Left = 73
        Top = 24
        Width = 280
        Height = 21
        TabStop = False
        DataField = 'NOME'
        DataSource = dtsRegistro
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object dbCompetencia: TDBEdit
        Left = 358
        Top = 24
        Width = 90
        Height = 21
        DataField = 'COMPETENCIA'
        DataSource = dtsRegistro
        TabOrder = 2
      end
      object dbValor: TDBEdit
        Left = 453
        Top = 24
        Width = 100
        Height = 21
        DataField = 'VALOR'
        DataSource = dtsRegistro
        TabOrder = 3
      end
    end
  end
  inherited dtsRegistro: TDataSource
    AutoEdit = True
    Left = 48
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
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
        Name = 'COMPETENCIA'
        DataType = ftDate
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'VALOR'
        DataType = ftCurrency
      end>
    Left = 48
    Top = 256
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInKey]
    end
    object mtRegistroIDINDICE: TIntegerField
      FieldName = 'IDINDICE'
      ProviderFlags = [pfInKey]
    end
    object mtRegistroCOMPETENCIA: TDateField
      FieldName = 'COMPETENCIA'
      ProviderFlags = [pfInKey]
    end
    object mtRegistroVALOR: TCurrencyField
      FieldName = 'VALOR'
      ProviderFlags = [pfInUpdate]
      DisplayFormat = ',0.000'
      Precision = 2
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      ProviderFlags = [pfHidden]
      Size = 50
    end
  end
end
