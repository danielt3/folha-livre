inherited FrmAutomatico: TFrmAutomatico
  Left = 49
  Top = 54
  Caption = 'Eventos Autom'#225'ticos'
  ClientHeight = 423
  ClientWidth = 592
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlEscuro: TPanel
    Width = 0
    Height = 423
    inherited lblSeparador: TLabel
      Width = 0
    end
    inherited lblPrograma: TPanel
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
        Width = 397
        Caption = ' '#183' Eventos Autom'#225'ticos para o Funcion'#225'rio'
      end
      inherited PnlFechar: TPanel
        Left = 552
      end
    end
    inherited dbgRegistro: TDBGrid
      Top = 85
      Width = 592
      Height = 183
      TabOrder = 2
      TitleFont.Charset = DEFAULT_CHARSET
      Columns = <
        item
          Expanded = False
          FieldName = 'IDEVENTO'
          Title.Caption = 'ID Evento'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EVENTO'
          Title.Caption = 'Descri'#231#227'o do Evento'
          Width = 310
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TIPO_EVENTO'
          Title.Caption = 'Tipo'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TIPO_CALCULO'
          Title.Caption = 'C'#225'lculo'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'INFORMADO'
          Title.Caption = 'Valor Informado'
          Width = 85
          Visible = True
        end>
    end
    inherited Panel: TPanel
      Top = 268
      Width = 592
      Height = 115
      TabOrder = 4
      object lbEvento: TLabel
        Left = 8
        Top = 8
        Width = 48
        Height = 13
        Caption = 'ID E&vento'
        FocusControl = dbEvento
      end
      object lbEvento2: TLabel
        Left = 93
        Top = 8
        Width = 100
        Height = 13
        Caption = 'Descri'#231#227'o do Evento'
        FocusControl = dbEvento2
      end
      object lbInformado: TLabel
        Left = 408
        Top = 8
        Width = 74
        Height = 13
        Caption = 'Valor Informado'
      end
      object dbEvento: TAKDBEdit
        Left = 8
        Top = 24
        Width = 58
        Height = 21
        CharCase = ecUpperCase
        DataField = 'IDEVENTO'
        DataSource = dtsRegistro
        TabOrder = 0
        ButtonSpacing = 3
        OnButtonClick = dbEventoButtonClick
      end
      object dbEvento2: TDBEdit
        Tag = 1
        Left = 93
        Top = 24
        Width = 310
        Height = 21
        TabStop = False
        DataField = 'EVENTO'
        DataSource = dtsRegistro
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object dbInformado: TDBEdit
        Left = 408
        Top = 24
        Width = 90
        Height = 21
        DataField = 'INFORMADO'
        DataSource = dtsRegistro
        TabOrder = 2
      end
      object dbCompetencias: TGroupBox
        Left = 8
        Top = 48
        Width = 550
        Height = 60
        Caption = 'Compet'#234'ncias'
        TabOrder = 3
        object dbJaneiro: TDBCheckBox
          Tag = 1
          Left = 8
          Top = 16
          Width = 70
          Height = 17
          Caption = '&Janeiro'
          DataField = 'JANEIRO_X'
          DataSource = dtsRegistro
          TabOrder = 0
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbFevereiro: TDBCheckBox
          Tag = 2
          Left = 8
          Top = 36
          Width = 70
          Height = 17
          Caption = 'Fevereiro'
          DataField = 'FEVEREIRO_X'
          DataSource = dtsRegistro
          TabOrder = 1
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbMarco: TDBCheckBox
          Tag = 3
          Left = 84
          Top = 16
          Width = 73
          Height = 17
          Caption = '&Mar'#231'o'
          DataField = 'MARCO_X'
          DataSource = dtsRegistro
          TabOrder = 2
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbAbril: TDBCheckBox
          Tag = 4
          Left = 84
          Top = 36
          Width = 70
          Height = 17
          Caption = '&Abril'
          DataField = 'ABRIL_X'
          DataSource = dtsRegistro
          TabOrder = 3
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbMaio: TDBCheckBox
          Tag = 5
          Left = 161
          Top = 16
          Width = 70
          Height = 17
          Caption = 'Maio'
          DataField = 'MAIO_X'
          DataSource = dtsRegistro
          TabOrder = 4
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbJunho: TDBCheckBox
          Tag = 6
          Left = 161
          Top = 36
          Width = 70
          Height = 17
          Caption = '&Junho'
          DataField = 'JUNHO_X'
          DataSource = dtsRegistro
          TabOrder = 5
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbJulho: TDBCheckBox
          Tag = 7
          Left = 238
          Top = 16
          Width = 70
          Height = 17
          Caption = 'Julho'
          DataField = 'JULHO_X'
          DataSource = dtsRegistro
          TabOrder = 6
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbAgosto: TDBCheckBox
          Tag = 8
          Left = 238
          Top = 36
          Width = 70
          Height = 17
          Caption = 'Agosto'
          DataField = 'AGOSTO_X'
          DataSource = dtsRegistro
          TabOrder = 7
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbSetembro: TDBCheckBox
          Tag = 9
          Left = 314
          Top = 16
          Width = 70
          Height = 17
          Caption = '&Setembro'
          DataField = 'SETEMBRO_X'
          DataSource = dtsRegistro
          TabOrder = 8
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbOutubro: TDBCheckBox
          Tag = 10
          Left = 314
          Top = 36
          Width = 70
          Height = 17
          Caption = '&Outubro'
          DataField = 'OUTUBRO_X'
          DataSource = dtsRegistro
          TabOrder = 9
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbNovembro: TDBCheckBox
          Tag = 11
          Left = 391
          Top = 16
          Width = 70
          Height = 17
          Caption = '&Novembro'
          DataField = 'NOVEMBRO_X'
          DataSource = dtsRegistro
          TabOrder = 10
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object dbDezembro: TDBCheckBox
          Tag = 12
          Left = 391
          Top = 36
          Width = 70
          Height = 17
          Caption = '&Dezembro'
          DataField = 'DEZEMBRO_X'
          DataSource = dtsRegistro
          TabOrder = 11
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
        object db13salario: TDBCheckBox
          Tag = 13
          Left = 468
          Top = 16
          Width = 70
          Height = 17
          Caption = '13 &Sal'#225'rio'
          DataField = 'SALARIO13_X'
          DataSource = dtsRegistro
          TabOrder = 12
          ValueChecked = '1'
          ValueUnchecked = '0'
        end
      end
    end
    object Panel1: TPanel
      Left = 0
      Top = 30
      Width = 592
      Height = 55
      Align = alTop
      BevelOuter = bvNone
      Color = 8101828
      TabOrder = 1
      object lbFunc: TLabel
        Left = 8
        Top = 8
        Width = 41
        Height = 13
        Caption = 'ID &Func.'
        FocusControl = dbFunc
      end
      object lbFunc2: TLabel
        Left = 95
        Top = 8
        Width = 101
        Height = 13
        Caption = 'Nome do Funcion'#225'rio'
        FocusControl = dbFunc2
      end
      object lbTipo: TLabel
        Left = 440
        Top = 8
        Width = 65
        Height = 13
        Caption = 'Tipo de Folha'
        FocusControl = dbTipo
        ParentShowHint = False
        ShowHint = False
      end
      object dbFunc: TAKDBEdit
        Left = 8
        Top = 24
        Width = 60
        Height = 21
        CharCase = ecUpperCase
        DataField = 'IDFUNCIONARIO'
        DataSource = dsFuncionario
        TabOrder = 0
        ButtonSpacing = 3
        OnButtonClick = dbFuncButtonClick
      end
      object dbFunc2: TDBEdit
        Left = 95
        Top = 24
        Width = 340
        Height = 21
        TabStop = False
        DataField = 'FUNCIONARIO'
        DataSource = dsFuncionario
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object dbTipo: TAKDBEdit
        Left = 440
        Top = 24
        Width = 30
        Height = 21
        CharCase = ecUpperCase
        DataField = 'IDFOLHA_TIPO'
        DataSource = dsFuncionario
        TabOrder = 2
        ButtonSpacing = 3
        OnButtonClick = dbTipoButtonClick
      end
      object dbTipo2: TDBEdit
        Left = 495
        Top = 24
        Width = 90
        Height = 21
        TabStop = False
        DataField = 'FOLHA_TIPO'
        DataSource = dsFuncionario
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 32
    Top = 120
  end
  inherited mtRegistro: TClientDataSet
    Left = 32
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDFUNCIONARIO: TIntegerField
      FieldName = 'IDFUNCIONARIO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroID: TIntegerField
      FieldName = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDFOLHA_TIPO: TStringField
      FieldName = 'IDFOLHA_TIPO'
      ProviderFlags = [pfInUpdate, pfInKey]
      Size = 1
    end
    object mtRegistroIDEVENTO: TIntegerField
      FieldName = 'IDEVENTO'
    end
    object mtRegistroEVENTO: TStringField
      FieldName = 'EVENTO'
      ProviderFlags = [pfHidden]
      Size = 50
    end
    object mtRegistroTIPO_EVENTO: TStringField
      FieldName = 'TIPO_EVENTO'
      ProviderFlags = [pfHidden]
      Size = 1
    end
    object mtRegistroTIPO_CALCULO: TStringField
      FieldName = 'TIPO_CALCULO'
      ProviderFlags = [pfInWhere, pfHidden]
      Size = 1
    end
    object mtRegistroATIVO_X: TSmallintField
      FieldName = 'ATIVO_X'
      ProviderFlags = [pfInWhere, pfHidden]
    end
    object mtRegistroINFORMADO: TCurrencyField
      FieldName = 'INFORMADO'
      DisplayFormat = ',0.##'
    end
    object mtRegistroJANEIRO_X: TSmallintField
      FieldName = 'JANEIRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroFEVEREIRO_X: TSmallintField
      FieldName = 'FEVEREIRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroMARCO_X: TSmallintField
      FieldName = 'MARCO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroABRIL_X: TSmallintField
      FieldName = 'ABRIL_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroMAIO_X: TSmallintField
      FieldName = 'MAIO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroJUNHO_X: TSmallintField
      FieldName = 'JUNHO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroJULHO_X: TSmallintField
      FieldName = 'JULHO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroAGOSTO_X: TSmallintField
      FieldName = 'AGOSTO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroSETEMBRO_X: TSmallintField
      FieldName = 'SETEMBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroOUTUBRO_X: TSmallintField
      FieldName = 'OUTUBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroNOVEMBRO_X: TSmallintField
      FieldName = 'NOVEMBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroDEZEMBRO_X: TSmallintField
      FieldName = 'DEZEMBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroSALARIO13_X: TSmallintField
      FieldName = 'SALARIO13_X'
      ProviderFlags = [pfInUpdate]
    end
  end
  object cdFuncionario: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 128
    Top = 200
    object cdFuncionarioIDFUNCIONARIO: TStringField
      FieldName = 'IDFUNCIONARIO'
      Size = 10
    end
    object cdFuncionarioFUNCIONARIO: TStringField
      FieldName = 'FUNCIONARIO'
      Size = 50
    end
    object cdFuncionarioIDFOLHA_TIPO: TStringField
      FieldName = 'IDFOLHA_TIPO'
      Size = 1
    end
    object cdFuncionarioFOLHA_TIPO: TStringField
      FieldName = 'FOLHA_TIPO'
      Size = 30
    end
  end
  object dsFuncionario: TDataSource
    DataSet = cdFuncionario
    Left = 144
    Top = 128
  end
end
