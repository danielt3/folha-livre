object frmAviso: TfrmAviso
  Left = 126
  Top = 31
  BorderStyle = bsDialog
  Caption = 'Aviso Pr'#233'vio de F'#233'rias'
  ClientHeight = 460
  ClientWidth = 397
  Color = 14739951
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlControle: TPanel
    Left = 0
    Top = 418
    Width = 397
    Height = 42
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnImprimir: TButton
      Left = 132
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
      Left = 308
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
      Left = 220
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
    Width = 397
    Height = 418
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lblFolha: TLabel
      Left = 8
      Top = 16
      Width = 26
      Height = 13
      Caption = '&Folha'
      FocusControl = dbFolhaNome
    end
    object dbFolhaCodigo: TwwDBLookupCombo
      Left = 55
      Top = 12
      Width = 70
      Height = 21
      CharCase = ecUpperCase
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'co_folha'#9'10'#9'co_folha'#9'F'
        'ds_observacao'#9'40'#9'ds_observacao'#9'F')
      DataField = 'FOLHA'
      DataSource = dtsConfig
      LookupTable = qryFolha
      LookupField = 'co_folha'
      Options = [loColLines, loRowLines]
      Style = csDropDownList
      TabOrder = 0
      AutoDropDown = False
      ShowButton = False
      AllowClearKey = False
      ShowMatchText = True
      OnEnter = dbEmpresaCodigoEnter
      OnExit = dbEmpresaNomeExit
    end
    object dbFolhaNome: TwwDBLookupCombo
      Left = 130
      Top = 12
      Width = 260
      Height = 21
      CharCase = ecUpperCase
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'ds_observacao'#9'40'#9'ds_observacao'#9'F'
        'co_folha'#9'10'#9'co_folha'#9'F')
      DataField = 'FOLHA'
      DataSource = dtsConfig
      LookupTable = qryFolha
      LookupField = 'co_folha'
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
    object gpLotacao: TGroupBox
      Left = 8
      Top = 112
      Width = 380
      Height = 70
      Caption = '&Lota'#231#227'o'
      TabOrder = 3
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
        Height = 21
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
      object dbLotacaoNome: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 21
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
    object gpOrdem: TDBRadioGroup
      Left = 8
      Top = 372
      Width = 380
      Height = 40
      Caption = 'Cla&ssifica'#231#227'o dos funcion'#225'rios'
      Columns = 2
      DataField = 'ORDEM'
      DataSource = dtsConfig
      Items.Strings = (
        'Nome'
        'C'#243'digo')
      TabOrder = 7
      Values.Strings = (
        'N'
        'C')
    end
    object gpCargo: TGroupBox
      Left = 8
      Top = 297
      Width = 380
      Height = 70
      Caption = '&Cargo'
      TabOrder = 6
      object dbCargoX: TCheckBox
        Left = 8
        Top = 19
        Width = 120
        Height = 17
        Caption = 'Todos os cargos'
        TabOrder = 0
        OnClick = dbCargoXClick
      end
      object dbCargoCodigo: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 21
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'co_cargo'#9'8'#9'co_cargo'#9'F'
          'no_cargo'#9'25'#9'no_cargo'#9'F')
        DataField = 'CARGO'
        DataSource = dtsConfig
        LookupTable = qryCargo
        LookupField = 'co_cargo'
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
      object dbCargoNome: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 21
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'no_cargo'#9'25'#9'no_cargo'#9'F'
          'co_cargo'#9'8'#9'co_cargo'#9'F')
        DataField = 'CARGO'
        DataSource = dtsConfig
        LookupTable = qryCargo
        LookupField = 'co_cargo'
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
    object gpRecurso: TGroupBox
      Left = 8
      Top = 242
      Width = 380
      Height = 50
      Caption = '&Recursos'
      TabOrder = 5
      object dbRecursoX: TCheckBox
        Left = 8
        Top = 19
        Width = 110
        Height = 17
        Caption = 'Todos os Recursos'
        TabOrder = 0
        OnClick = dbRecursoXClick
      end
      object dbRecurso: TwwDBLookupCombo
        Left = 123
        Top = 17
        Width = 240
        Height = 21
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
    object gpTipo: TGroupBox
      Left = 8
      Top = 187
      Width = 380
      Height = 50
      Caption = '&Tipo de Funcion'#225'rio'
      TabOrder = 4
      object dbTipoX: TCheckBox
        Left = 8
        Top = 19
        Width = 100
        Height = 17
        Caption = 'Todos os Tipos'
        TabOrder = 0
        OnClick = dbTipoXClick
      end
      object dbTipo: TwwDBLookupCombo
        Left = 123
        Top = 17
        Width = 240
        Height = 21
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
    object gpFuncionario: TGroupBox
      Left = 8
      Top = 39
      Width = 380
      Height = 70
      Caption = '&Funcion'#225'rios'
      TabOrder = 2
      object dbFuncionarioX: TCheckBox
        Left = 8
        Top = 19
        Width = 250
        Height = 17
        Caption = 'Selecionar Funcion'#225'rio'
        TabOrder = 0
        OnClick = dbFuncionarioXClick
      end
      object dbFuncionarioCodigo: TwwDBLookupCombo
        Left = 8
        Top = 39
        Width = 70
        Height = 21
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'co_funcionario'#9'10'#9'co_funcionario'#9'F'
          'no_funcionario'#9'60'#9'no_funcionario'#9'F')
        DataField = 'FUNCIONARIO'
        DataSource = dtsConfig
        LookupTable = qryFuncionario
        LookupField = 'co_funcionario'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 1
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
      end
      object dbFuncionarioNome: TwwDBLookupCombo
        Left = 83
        Top = 39
        Width = 280
        Height = 21
        CharCase = ecUpperCase
        DropDownAlignment = taLeftJustify
        Selected.Strings = (
          'no_funcionario'#9'60'#9'no_funcionario'#9'F'
          'co_funcionario'#9'10'#9'co_funcionario'#9'F')
        DataField = 'FUNCIONARIO'
        DataSource = dtsConfig
        LookupTable = qryFuncionario
        LookupField = 'co_funcionario'
        Options = [loColLines, loRowLines]
        Style = csDropDownList
        TabOrder = 2
        AutoDropDown = False
        ShowButton = False
        UseTFields = False
        AllowClearKey = False
        ShowMatchText = True
        OnEnter = dbEmpresaCodigoEnter
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
    Left = 312
    Top = 40
  end
  object qryFolha: TADOQuery
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
      'SELECT co_folha, ds_observacao FROM FOLHA_PAGAMENTO'
      'WHERE co_empresa = :empresa AND tp_folha = '#39'F'#39
      'ORDER BY co_folha')
    Left = 248
    Top = 40
  end
  object mtConfig: TkbmMemTable
    DesignActivation = True
    AttachedAutoRefresh = True
    AttachMaxCount = 1
    FieldDefs = <>
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
    Left = 312
    Top = 96
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
    object mtConfigCARGO: TStringField
      FieldName = 'CARGO'
      Size = 8
    end
    object mtConfigORDEM: TStringField
      DefaultExpression = 'N'
      FieldName = 'ORDEM'
      Size = 1
    end
    object mtConfigRECURSO: TIntegerField
      FieldName = 'RECURSO'
    end
    object mtConfigFUNCIONARIO: TIntegerField
      FieldName = 'FUNCIONARIO'
    end
  end
  object dtsConfig: TDataSource
    DataSet = mtConfig
    Left = 248
    Top = 96
  end
  object qryCargo: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT  co_cargo, no_cargo FROM CARGO'
      'ORDER BY co_cargo')
    Left = 168
    Top = 160
  end
  object qryTipo: TADOQuery
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
      'SELECT co_tipo_funcionario, ds_tipo_funcionario'
      'FROM TIPO_FUNCIONARIO'
      'ORDER BY co_tipo_funcionario'
      ' ')
    Left = 224
    Top = 160
  end
  object qryRecurso: TADOQuery
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM RECURSO'
      'ORDER BY nome')
    Left = 344
    Top = 224
  end
  object qryFuncionario: TADOQuery
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
      'SELECT'
      '  co_funcionario, no_funcionario'
      'FROM'
      '  funcionario'
      'WHERE'
      '  co_empresa = :empresa'
      'ORDER BY'
      '  co_funcionario'
      ''
      ' ')
    Left = 264
    Top = 224
  end
end
