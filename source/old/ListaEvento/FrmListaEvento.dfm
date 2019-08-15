object frmEntrada: TfrmEntrada
  Left = 46
  Top = 6
  BorderStyle = bsDialog
  Caption = 'Listamento de Eventos'
  ClientHeight = 459
  ClientWidth = 666
  Color = 14739951
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlControle: TPanel
    Left = 0
    Top = 418
    Width = 666
    Height = 41
    Align = alBottom
    BevelInner = bvLowered
    ParentColor = True
    TabOrder = 1
    object btnImprimir: TButton
      Left = 404
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnImprimirClick
    end
    object btnCancelar: TButton
      Left = 580
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 2
      OnClick = btnCancelarClick
    end
    object btnVisualizar: TButton
      Left = 492
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Visualizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnImprimirClick
    end
  end
  object pnlConfig: TPanel
    Left = 0
    Top = 0
    Width = 666
    Height = 418
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object gpLotacao: TGroupBox
      Left = 8
      Top = 152
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
      object dbLotacao: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'co_lotacao'#9'7'#9'co_lotacao'#9'F'
          'no_lotacao'#9'30'#9'no_lotacao'#9'F')
        DataField = 'LOTACAO'
        DataSource = dtsConfig
        LookupTable = qryLotacao
        LookupField = 'co_lotacao'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 1
        AutoDropDown = False
        ShowButton = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
      object dbLotacao2: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'no_lotacao'#9'30'#9'no_lotacao'#9'F'
          'co_lotacao'#9'7'#9'co_lotacao'#9'F')
        DataField = 'LOTACAO'
        DataSource = dtsConfig
        LookupTable = qryLotacao
        LookupField = 'co_lotacao'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 2
        AutoDropDown = False
        ShowButton = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
    end
    object gpTipo: TGroupBox
      Left = 8
      Top = 227
      Width = 380
      Height = 50
      Caption = '&Tipo de Funcion'#225'rio'
      TabOrder = 3
      object dbTipoX: TCheckBox
        Left = 8
        Top = 19
        Width = 100
        Height = 17
        Caption = 'Todos os Tipos'
        TabOrder = 0
        OnClick = dbLotacaoXClick
      end
      object dbTipo: TwwDBLookupCombo
        Left = 123
        Top = 17
        Width = 240
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'ds_tipo_funcionario'#9'15'#9'ds_tipo_funcionario'#9'F'
          'co_tipo_funcionario'#9'2'#9'co_tipo_funcionario'#9'F')
        DataField = 'TIPO'
        DataSource = dtsConfig
        LookupTable = qryTipo
        LookupField = 'co_tipo_funcionario'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 1
        AutoDropDown = False
        ShowButton = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
    end
    object gpOrdem: TDBRadioGroup
      Left = 8
      Top = 333
      Width = 80
      Height = 70
      Caption = 'Cla&ssifica'#231#227'o'
      DataField = 'ORDEM'
      DataSource = dtsConfig
      Items.Strings = (
        'Nome'
        'Matricula')
      TabOrder = 5
      Values.Strings = (
        'N'
        'M')
    end
    object gpRecurso: TGroupBox
      Left = 8
      Top = 281
      Width = 380
      Height = 50
      Caption = '&Recursos'
      TabOrder = 4
      object dbRecursoX: TCheckBox
        Left = 8
        Top = 19
        Width = 110
        Height = 17
        Caption = 'Todos os Recursos'
        TabOrder = 0
        OnClick = dbLotacaoXClick
      end
      object dbRecurso: TwwDBLookupCombo
        Left = 123
        Top = 17
        Width = 240
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'Nome'#9'20'#9'Nome'#9'F')
        DataField = 'RECURSO'
        DataSource = dtsConfig
        LookupTable = qryRecurso
        LookupField = 'Recurso'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 1
        AutoDropDown = True
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
    end
    object gpDados: TGroupBox
      Left = 394
      Top = 281
      Width = 255
      Height = 123
      Caption = 'Mostrar Dados'
      TabOrder = 10
      object BoxDados: TCheckListBox
        Left = 1
        Top = 14
        Width = 253
        Height = 108
        Align = alClient
        BorderStyle = bsNone
        Columns = 2
        ItemHeight = 16
        Items.Strings = (
          'Lota'#231#227'o'
          'Evento'
          'Matricula'
          'Nome'
          'Cargo'
          'Tipo'
          'Folha'
          'V. Informado'
          'V. Calculado'
          'Assinatura')
        ParentColor = True
        Style = lbOwnerDrawFixed
        TabOrder = 0
      end
    end
    object gpFolha2: TGroupBox
      Left = 393
      Top = 8
      Width = 255
      Height = 142
      Caption = 'Sele'#231#227'o de Folhas'
      TabOrder = 8
      object dbgFolha: TwwDBGrid
        Left = 1
        Top = 14
        Width = 253
        Height = 127
        ControlType.Strings = (
          'X;CheckBox;True;False')
        Selected.Strings = (
          'X'#9'5'#9'X'#9'F'
          'co_folha'#9'6'#9'co_folha'#9'F'
          'ds_observacao'#9'26'#9'ds_observacao'#9'F')
        MemoAttributes = [mSizeable, mWordWrap, mGridShow]
        IniAttributes.Enabled = True
        IniAttributes.SaveToRegistry = True
        IniAttributes.FileName = 'Software\Woll2WollDemo\Grid2000'
        IniAttributes.Delimiter = ';;'
        TitleColor = clBtnFace
        FixedCols = 0
        ShowHorzScrollBar = True
        Align = alClient
        BorderStyle = bsNone
        DataSource = dtsFolha
        KeyOptions = []
        Options = [dgEditing, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap, dgTrailingEllipsis, dgShowCellHint]
        ParentColor = True
        TabOrder = 0
        TitleAlignment = taCenter
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        TitleLines = 2
        TitleButtons = False
        UseTFields = False
      end
    end
    object gpFolha: TGroupBox
      Left = 8
      Top = 8
      Width = 380
      Height = 70
      Caption = '&Folha'
      TabOrder = 0
      object dbFolhaX: TCheckBox
        Left = 8
        Top = 19
        Width = 120
        Height = 17
        Caption = 'Todas as Folhas'
        TabOrder = 0
        OnClick = dbLotacaoXClick
      end
      object dbFolha: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'co_folha'#9'5'#9'co_folha'#9'F'
          'ds_observacao'#9'30'#9'ds_observacao'#9'F')
        DataField = 'FOLHA'
        DataSource = dtsConfig
        LookupTable = mtFolha
        LookupField = 'co_folha'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 2
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
      object dbFolha2: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'ds_observacao'#9'30'#9'ds_observacao'#9'F'
          'co_folha'#9'5'#9'co_folha'#9'F')
        DataField = 'FOLHA'
        DataSource = dtsConfig
        LookupTable = mtFolha
        LookupField = 'co_folha'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 3
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
      object dbFolha2X: TCheckBox
        Left = 150
        Top = 19
        Width = 130
        Height = 17
        Caption = 'Selecionar as Folhas'
        TabOrder = 1
        OnClick = dbLotacaoXClick
      end
    end
    object gpLotacao2: TGroupBox
      Left = 93
      Top = 333
      Width = 145
      Height = 70
      Caption = 'Op'#231#245'es de Lota'#231#227'o'
      TabOrder = 6
      object CheckBox2: TCheckBox
        Left = 8
        Top = 16
        Width = 125
        Height = 17
        Caption = 'Separar por Lota'#231#227'o'
        TabOrder = 0
      end
      object CheckBox3: TCheckBox
        Left = 8
        Top = 41
        Width = 125
        Height = 17
        Caption = 'Quebrar por Lota'#231#227'o'
        TabOrder = 1
      end
    end
    object gpFuncionario2: TGroupBox
      Left = 243
      Top = 333
      Width = 145
      Height = 70
      Caption = 'Op'#231#245'es de Funcion'#225'rio'
      TabOrder = 7
      object dbTotalFunc: TCheckBox
        Left = 8
        Top = 16
        Width = 125
        Height = 17
        Caption = 'Totalizar Funcion'#225'rio'
        TabOrder = 0
      end
      object dbResumoFunc: TCheckBox
        Left = 8
        Top = 41
        Width = 125
        Height = 17
        Caption = 'Resumir Funcion'#225'rio'
        TabOrder = 1
      end
    end
    object gpEvento: TGroupBox
      Left = 8
      Top = 80
      Width = 380
      Height = 70
      Caption = '&Evento'
      TabOrder = 1
      object dbEventoX: TCheckBox
        Left = 8
        Top = 19
        Width = 120
        Height = 17
        Caption = 'Todos os Eventos'
        TabOrder = 0
        OnClick = dbLotacaoXClick
      end
      object dbEvento: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'co_rubrica'#9'5'#9'co_rubrica'#9'F'
          'ds_rubrica'#9'30'#9'ds_rubrica'#9'F')
        DataField = 'EVENTO'
        DataSource = dtsConfig
        LookupTable = mtEvento
        LookupField = 'co_rubrica'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 2
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
      object dbEvento2: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 19
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'ds_rubrica'#9'30'#9'ds_rubrica'#9'F'
          'co_rubrica'#9'5'#9'co_rubrica'#9'F')
        DataField = 'EVENTO'
        DataSource = dtsConfig
        LookupTable = mtEvento
        LookupField = 'co_rubrica'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 3
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
        OnExit = dbEmpresaNomeExit
      end
      object dbEvento2x: TCheckBox
        Left = 150
        Top = 19
        Width = 130
        Height = 17
        Caption = 'Selecionar os Eventos'
        TabOrder = 1
        OnClick = dbLotacaoXClick
      end
    end
    object gpEvento2: TGroupBox
      Left = 393
      Top = 152
      Width = 255
      Height = 125
      Caption = 'Sele'#231#227'o de Eventos'
      TabOrder = 9
      object dbgEvento: TwwDBGrid
        Left = 1
        Top = 14
        Width = 253
        Height = 110
        ControlType.Strings = (
          'X;CheckBox;True;False')
        Selected.Strings = (
          'X'#9'5'#9'X'#9'F'
          'co_rubrica'#9'6'#9'co_rubrica'#9'F'
          'ds_rubrica'#9'26'#9'ds_rubrica'#9'F')
        MemoAttributes = [mSizeable, mWordWrap, mGridShow]
        IniAttributes.Enabled = True
        IniAttributes.SaveToRegistry = True
        IniAttributes.FileName = 'Software\Woll2WollDemo\Grid2000'
        IniAttributes.Delimiter = ';;'
        TitleColor = clBtnFace
        FixedCols = 0
        ShowHorzScrollBar = True
        Align = alClient
        BorderStyle = bsNone
        DataSource = dtsEvento
        KeyOptions = []
        Options = [dgEditing, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgWordWrap, dgTrailingEllipsis, dgShowCellHint]
        ParentColor = True
        TabOrder = 0
        TitleAlignment = taCenter
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = []
        TitleLines = 2
        TitleButtons = False
        UseTFields = False
      end
    end
  end
  object qryLotacao: TADOQuery
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'empresa'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 3
        Value = '001'
      end>
    SQL.Strings = (
      'SELECT  co_lotacao, no_lotacao FROM LOTACAO'
      'WHERE co_empresa = :empresa'
      'ORDER BY co_lotacao')
    Left = 200
    Top = 240
  end
  object dtsConfig: TDataSource
    DataSet = mtConfig
    Left = 344
    Top = 232
  end
  object qryTipo: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT co_tipo_funcionario, ds_tipo_funcionario'
      'FROM TIPO_FUNCIONARIO'
      'ORDER BY co_tipo_funcionario'
      ' ')
    Left = 344
    Top = 184
  end
  object mtConfig: TkbmMemTable
    Active = True
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'FOLHA'
        DataType = ftInteger
      end
      item
        Name = 'LOTACAO'
        DataType = ftString
        Size = 7
      end
      item
        Name = 'TIPO'
        DataType = ftString
        Size = 2
      end
      item
        Name = 'ORDEM'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'SAIDA'
        DataType = ftString
        Size = 1
      end
      item
        Name = 'RECURSO'
        DataType = ftInteger
      end
      item
        Name = 'EVENTO'
        DataType = ftString
        Size = 3
      end>
    IndexDefs = <>
    SortOptions = []
    AllDataOptions = [mtfSaveData, mtfSaveNonVisible, mtfSaveBlobs, mtfSaveFiltered, mtfSaveIgnoreRange, mtfSaveIgnoreMasterDetail, mtfSaveDeltas]
    CommaTextOptions = [mtfSaveData]
    CSVQuote = '"'
    CSVFieldDelimiter = ','
    CSVRecordDelimiter = ','
    CSVTrueString = 'True'
    CSVFalseString = 'False'
    PersistentSaveOptions = [mtfSaveData, mtfSaveNonVisible]
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    FilterOptions = []
    Version = '2.53g'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    OnNewRecord = mtConfigNewRecord
    Left = 152
    Top = 189
    object mtConfigFOLHA: TIntegerField
      FieldName = 'FOLHA'
    end
    object mtConfigLOTACAO: TStringField
      FieldName = 'LOTACAO'
      Size = 7
    end
    object mtConfigTIPO: TStringField
      FieldName = 'TIPO'
      Size = 2
    end
    object mtConfigORDEM: TStringField
      DefaultExpression = 'N'
      FieldName = 'ORDEM'
      Size = 1
    end
    object mtConfigSAIDA: TStringField
      FieldName = 'SAIDA'
      Size = 1
    end
    object mtConfigRECURSO: TIntegerField
      FieldName = 'RECURSO'
    end
    object mtConfigEVENTO: TStringField
      FieldName = 'EVENTO'
      Size = 3
    end
  end
  object qryRecurso: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM RECURSO'
      'ORDER BY nome')
    Left = 296
    Top = 232
  end
  object mtFolha: TkbmMemTable
    Active = True
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'X'
        DataType = ftBoolean
      end
      item
        Name = 'co_folha'
        DataType = ftInteger
      end
      item
        Name = 'ds_observacao'
        DataType = ftString
        Size = 50
      end>
    IndexDefs = <>
    SortOptions = []
    AllDataOptions = [mtfSaveData, mtfSaveNonVisible, mtfSaveBlobs, mtfSaveFiltered, mtfSaveIgnoreRange, mtfSaveIgnoreMasterDetail, mtfSaveDeltas]
    CommaTextOptions = [mtfSaveData]
    CSVQuote = '"'
    CSVFieldDelimiter = ','
    CSVRecordDelimiter = ','
    CSVTrueString = 'True'
    CSVFalseString = 'False'
    PersistentSaveOptions = [mtfSaveData, mtfSaveNonVisible]
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    FilterOptions = []
    Version = '2.53g'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 112
    Top = 245
    object mtFolhaX: TBooleanField
      DisplayWidth = 5
      FieldName = 'X'
    end
    object mtFolhaco_folha: TIntegerField
      FieldName = 'co_folha'
      Visible = False
    end
    object mtFolhads_observacao: TStringField
      FieldName = 'ds_observacao'
      Visible = False
      Size = 50
    end
  end
  object dtsFolha: TDataSource
    DataSet = mtFolha
    Left = 112
    Top = 288
  end
  object mtEvento: TkbmMemTable
    Active = True
    DesignActivation = True
    AttachedAutoRefresh = False
    AttachMaxCount = 1
    FieldDefs = <
      item
        Name = 'co_rubrica'
        DataType = ftString
        Size = 3
      end
      item
        Name = 'ds_rubrica'
        DataType = ftString
        Size = 30
      end
      item
        Name = 'X'
        DataType = ftBoolean
      end>
    IndexDefs = <>
    SortOptions = []
    AllDataOptions = [mtfSaveData, mtfSaveNonVisible, mtfSaveBlobs, mtfSaveFiltered, mtfSaveIgnoreRange, mtfSaveIgnoreMasterDetail, mtfSaveDeltas]
    CommaTextOptions = [mtfSaveData]
    CSVQuote = '"'
    CSVFieldDelimiter = ','
    CSVRecordDelimiter = ','
    CSVTrueString = 'True'
    CSVFalseString = 'False'
    PersistentSaveOptions = [mtfSaveData, mtfSaveNonVisible]
    PersistentBackup = False
    ProgressFlags = [mtpcLoad, mtpcSave, mtpcCopy]
    FilterOptions = []
    Version = '2.53g'
    LanguageID = 0
    SortID = 0
    SubLanguageID = 1
    LocaleID = 1024
    Left = 160
    Top = 245
    object mtEventoco_rubrica: TStringField
      DisplayWidth = 5
      FieldName = 'co_rubrica'
      Size = 3
    end
    object mtEventods_rubrica: TStringField
      FieldName = 'ds_rubrica'
      Size = 30
    end
    object mtEventoX: TBooleanField
      DisplayWidth = 5
      FieldName = 'X'
      Visible = False
    end
  end
  object dtsEvento: TDataSource
    DataSet = mtEvento
    Left = 160
    Top = 288
  end
end
