object FrmFGTS: TFrmFGTS
  Left = 135
  Top = 60
  BorderStyle = bsDialog
  Caption = 'Relação de Funcionários para FGTS - SEFIP'
  ClientHeight = 470
  ClientWidth = 423
  Color = 14739951
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
    Top = 449
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
      Left = 130
      Top = 25
      Width = 127
      Height = 13
      Caption = 'Indicador de Recolhimento'
    end
    object Label8: TLabel
      Left = 85
      Top = 23
      Width = 33
      Height = 13
      Caption = 'Codigo'
    end
    object Label2: TLabel
      Left = 285
      Top = 25
      Width = 79
      Height = 13
      Caption = 'Data pagamento'
    end
    object dbIndicador_FGTS: TwwDBComboBox
      Left = 130
      Top = 40
      Width = 150
      Height = 21
      ShowButton = True
      Style = csDropDown
      MapList = True
      AllowClearKey = False
      DropDownCount = 8
      ItemHeight = 0
      Items.Strings = (
        '  '#9'0'
        '1 - GFIP no prazo'#9'1'
        '2 - GFIP em atraso'#9'2')
      ItemIndex = 1
      Sorted = False
      TabOrder = 4
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
      Caption = 'F G T S'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object dbCR: TRxCalcEdit
      Left = 85
      Top = 40
      Width = 40
      Height = 21
      AutoSize = False
      DecimalPlaces = 0
      DisplayFormat = '0'
      FormatOnEditing = True
      ButtonWidth = 0
      MaxValue = 911
      MinValue = 115
      NumGlyphs = 2
      TabOrder = 3
      Value = 115
    end
    object dbMes: TRxCalcEdit
      Left = 8
      Top = 40
      Width = 30
      Height = 21
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
      Left = 40
      Top = 40
      Width = 40
      Height = 21
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
    object dbDataFGTS: TDateEdit
      Left = 285
      Top = 40
      Width = 97
      Height = 21
      NumGlyphs = 2
      TabOrder = 5
    end
  end
  object pnlPS: TPanel
    Left = 8
    Top = 88
    Width = 400
    Height = 70
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 1
    object Label4: TLabel
      Left = 9
      Top = 25
      Width = 127
      Height = 13
      Caption = 'Indicador de Recolhimento'
    end
    object Label5: TLabel
      Left = 168
      Top = 25
      Width = 79
      Height = 13
      Caption = 'Data pagamento'
    end
    object Label6: TLabel
      Left = 273
      Top = 25
      Width = 97
      Height = 13
      Caption = 'Indice Recolhimento'
    end
    object StaticText2: TStaticText
      Left = 2
      Top = 2
      Width = 396
      Height = 17
      Align = alTop
      Alignment = taCenter
      BorderStyle = sbsSunken
      Caption = 'Previdência Social'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object dbIndicador_PS: TwwDBComboBox
      Left = 9
      Top = 40
      Width = 150
      Height = 21
      ShowButton = True
      Style = csDropDown
      MapList = True
      AllowClearKey = False
      DropDownCount = 8
      ItemHeight = 0
      Items.Strings = (
        '1 - GFIP no prazo'#9'1'
        '2 - GFIP em atraso'#9'2'
        '3 - Nao gera GPS'#9'3')
      ItemIndex = 0
      Sorted = False
      TabOrder = 1
      UnboundDataType = wwDefault
    end
    object dbDataPS: TDateEdit
      Left = 168
      Top = 40
      Width = 97
      Height = 21
      NumGlyphs = 2
      TabOrder = 2
    end
    object dbIndicePS: TRxCalcEdit
      Left = 272
      Top = 40
      Width = 100
      Height = 21
      AutoSize = False
      DisplayFormat = ',0.00'
      NumGlyphs = 2
      TabOrder = 3
    end
  end
  object pnlFuncionario: TPanel
    Left = 8
    Top = 168
    Width = 400
    Height = 180
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 2
    object StaticText3: TStaticText
      Left = 2
      Top = 2
      Width = 396
      Height = 17
      Align = alTop
      Alignment = taCenter
      BorderStyle = sbsSunken
      Caption = 'Seleção de Funcionários'
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
      Caption = '&Lotação'
      TabOrder = 2
      object dbLotacaoX: TCheckBox
        Left = 8
        Top = 19
        Width = 120
        Height = 17
        Caption = 'Todas as Lotações'
        TabOrder = 0
        OnClick = dbTipoXClick
      end
      object dbLotacaoCodigo: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 21
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
        Height = 21
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
        Height = 21
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
        Height = 21
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
  object pnlSaida: TPanel
    Left = 8
    Top = 355
    Width = 400
    Height = 30
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 3
    object radArquivo: TRadioButton
      Left = 10
      Top = 8
      Width = 100
      Height = 17
      Caption = 'Arquivo'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object radGuia: TRadioButton
      Left = 130
      Top = 8
      Width = 100
      Height = 17
      Caption = 'Guia'
      TabOrder = 1
    end
    object radResumo: TRadioButton
      Left = 240
      Top = 8
      Width = 100
      Height = 17
      Caption = 'Resumo'
      TabOrder = 2
    end
  end
  object Panel1: TPanel
    Left = 8
    Top = 395
    Width = 400
    Height = 45
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 4
    object Button1: TButton
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
      TabOrder = 0
      OnClick = Button1Click
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
      TabOrder = 1
      OnClick = btnFecharClick
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
    Left = 56
    Top = 392
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
    Left = 104
    Top = 392
  end
end
