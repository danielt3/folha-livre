object FrmCAGED: TFrmCAGED
  Left = 135
  Top = 60
  BorderStyle = bsDialog
  Caption = 'Gera'#231#227'o de Arquivo CAGED'
  ClientHeight = 350
  ClientWidth = 423
  Color = 14739951
  Ctl3D = False
  ParentFont = True
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Gauge1: TGauge
    Left = 0
    Top = 329
    Width = 423
    Height = 21
    Align = alBottom
    Progress = 0
  end
  object pnlFGTS: TPanel
    Left = 8
    Top = 8
    Width = 400
    Height = 70
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 0
    object Label3: TLabel
      Left = 8
      Top = 23
      Width = 67
      Height = 13
      Caption = 'Mes/Ano Ref:'
    end
    object Label1: TLabel
      Left = 88
      Top = 23
      Width = 102
      Height = 13
      Caption = 'Atualiza'#231#227'o Cadastral'
    end
    object Label2: TLabel
      Left = 243
      Top = 23
      Width = 96
      Height = 13
      Caption = 'Meio F'#237'sico utilizado'
    end
    object dbAtualizacao: TwwDBComboBox
      Left = 88
      Top = 40
      Width = 150
      Height = 19
      ShowButton = True
      Style = csDropDown
      MapList = True
      AllowClearKey = False
      DropDownCount = 8
      ItemHeight = 0
      Items.Strings = (
        '1 - N'#227'o'#9'1'
        '2 - Sim'#9'2'
        '3 - Encerramento'#9'3')
      ItemIndex = 0
      Sorted = False
      TabOrder = 3
      UnboundDataType = wwDefault
    end
    object StaticText1: TStaticText
      Left = 2
      Top = 2
      Width = 396
      Height = 17
      Align = alTop
      Alignment = taCenter
      BorderStyle = sbsSunken
      Caption = 'Informa'#231#245'es Gerais'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object dbMes: TRxCalcEdit
      Left = 8
      Top = 40
      Width = 30
      Height = 19
      AutoSize = False
      DecimalPlaces = 0
      DisplayFormat = '0'
      FormatOnEditing = True
      ButtonWidth = 0
      MaxValue = 13
      MinValue = 1
      NumGlyphs = 2
      TabOrder = 1
      Value = 13
    end
    object dbAno: TRxCalcEdit
      Left = 43
      Top = 40
      Width = 40
      Height = 19
      AutoSize = False
      DecimalPlaces = 0
      DisplayFormat = '0'
      FormatOnEditing = True
      ButtonWidth = 0
      MaxValue = 2100
      MinValue = 1900
      NumGlyphs = 2
      TabOrder = 2
      Value = 2001
    end
    object dbMeioFisico: TwwDBComboBox
      Left = 243
      Top = 40
      Width = 140
      Height = 19
      ShowButton = True
      Style = csDropDown
      MapList = True
      AllowClearKey = False
      DropDownCount = 8
      ItemHeight = 0
      Items.Strings = (
        '2 - Disquete'#9'2'
        '3 - Fita'#9'3'
        '4 - Outros'#9'4')
      ItemIndex = 0
      Sorted = False
      TabOrder = 4
      UnboundDataType = wwDefault
    end
  end
  object pnlFuncionario: TPanel
    Left = 8
    Top = 88
    Width = 400
    Height = 180
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 1
    object StaticText3: TStaticText
      Left = 2
      Top = 2
      Width = 396
      Height = 17
      Align = alTop
      Alignment = taCenter
      BorderStyle = sbsSunken
      Caption = 'Sele'#231#227'o de Funcion'#225'rios'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object gpLotacao: TGroupBox
      Left = 10
      Top = 100
      Width = 380
      Height = 70
      Caption = '&Lota'#231#227'o'
      TabOrder = 2
      object dbLotacaoX: TCheckBox
        Left = 8
        Top = 19
        Width = 120
        Height = 17
        Caption = 'Todas as Lota'#231#245'es'
        TabOrder = 0
        OnClick = dbLotacaoXClick
      end
      object dbLotacaoCodigo: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'CO_LOTACAO'#9'8'#9'CO_LOTACAO'#9'F'
          'NO_LOTACAO'#9'30'#9'NO_LOTACAO'#9'F'
          'CO_TIPO_LOTACAO'#9'2'#9'CO_TIPO_LOTACAO'#9'F')
        DataField = 'LOTACAO'
        LookupTable = qryLotacao
        LookupField = 'co_lotacao'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 1
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbTipoCodigoEnter
        OnExit = dbTipoCodigoExit
      end
      object dbLotacaoNome: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'NO_LOTACAO'#9'30'#9'NO_LOTACAO'#9'F'
          'CO_LOTACAO'#9'8'#9'CO_LOTACAO'#9'F'
          'CO_TIPO_LOTACAO'#9'2'#9'CO_TIPO_LOTACAO'#9'F')
        DataField = 'LOTACAO'
        LookupTable = qryLotacao
        LookupField = 'co_lotacao'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 2
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbTipoCodigoEnter
        OnExit = dbTipoCodigoExit
      end
    end
    object gpTipo: TGroupBox
      Left = 10
      Top = 24
      Width = 380
      Height = 70
      Caption = '&Tipo'
      TabOrder = 1
      object dbTipoX: TCheckBox
        Left = 8
        Top = 19
        Width = 120
        Height = 17
        Caption = 'Todos os Tipos'
        TabOrder = 0
        OnClick = dbTipoXClick
      end
      object dbTipoCodigo: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'CO_TIPO_FUNCIONARIO'#9'3'#9'CO_TIPO_FUNCIONARIO'#9'F'
          'DS_TIPO_FUNCIONARIO'#9'15'#9'DS_TIPO_FUNCIONARIO'#9'F')
        DataField = 'LOTACAO'
        LookupTable = qryTipo
        LookupField = 'CO_TIPO_FUNCIONARIO'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 1
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbTipoCodigoEnter
        OnExit = dbTipoCodigoExit
      end
      object dbTipoNome: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'DS_TIPO_FUNCIONARIO'#9'20'#9'DS_TIPO_FUNCIONARIO'#9'F'
          'CO_TIPO_FUNCIONARIO'#9'3'#9'CO_TIPO_FUNCIONARIO'#9'F')
        DataField = 'LOTACAO'
        LookupTable = qryTipo
        LookupField = 'CO_TIPO_FUNCIONARIO'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 2
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbTipoCodigoEnter
        OnExit = dbTipoCodigoExit
      end
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 275
    Width = 400
    Height = 45
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 2
    object btnOK: TButton
      Left = 174
      Top = 9
      Width = 100
      Height = 25
      Caption = '&OK'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnFechar: TButton
      Left = 286
      Top = 9
      Width = 100
      Height = 25
      Cancel = True
      Caption = '&Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 2
      OnClick = btnFecharClick
    end
    object dbPrimeiraDeclaracao: TCheckBox
      Left = 8
      Top = 13
      Width = 120
      Height = 17
      Caption = '&Primeira Declara'#231#227'o'
      TabOrder = 0
      OnClick = dbTipoXClick
    end
  end
  object qryLotacao: TADOQuery
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'EMPRESA'
        DataType = ftString
        Size = 3
        Value = '001'
      end>
    SQL.Strings = (
      'SELECT CO_LOTACAO, NO_LOTACAO, CO_TIPO_LOTACAO FROM LOTACAO'
      'WHERE CO_EMPRESA = :EMPRESA')
    Left = 200
    Top = 136
  end
  object qryTipo: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT'
      '  CO_TIPO_FUNCIONARIO, DS_TIPO_FUNCIONARIO,'
      '  DS_NATUREZA, CO_RETENCAO'
      'FROM'
      '  TIPO_FUNCIONARIO'
      '')
    Left = 232
    Top = 136
  end
end
