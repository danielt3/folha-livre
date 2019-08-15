object frmFolha2: TfrmFolha2
  Left = 118
  Top = 80
  BorderStyle = bsDialog
  Caption = 'Relatório de Funcionários'
  ClientHeight = 480
  ClientWidth = 489
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
  PixelsPerInch = 96
  TextHeight = 16
  object pnlControle: TPanel
    Left = 0
    Top = 428
    Width = 489
    Height = 52
    Align = alBottom
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object btnImprimir: TButton
      Left = 162
      Top = 10
      Width = 93
      Height = 31
      Caption = '&Imprimir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnImprimirClick
    end
    object btnCancelar: TButton
      Left = 379
      Top = 10
      Width = 92
      Height = 31
      Cancel = True
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 2
      OnClick = btnCancelarClick
    end
    object btnVisualizar: TButton
      Left = 271
      Top = 10
      Width = 92
      Height = 31
      Caption = '&Visualizar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
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
    Width = 489
    Height = 428
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object gpLotacao: TGroupBox
      Left = 10
      Top = 10
      Width = 468
      Height = 86
      Caption = '&Lotação'
      TabOrder = 0
      object dbLotacaoX: TCheckBox
        Left = 10
        Top = 23
        Width = 148
        Height = 21
        Caption = 'Todas as Lotações'
        TabOrder = 0
        OnClick = dbLotacaoXClick
      end
      object dbLotacaoCodigo: TwwDBLookupCombo
        Left = 10
        Top = 48
        Width = 86
        Height = 24
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
        Left = 102
        Top = 48
        Width = 345
        Height = 24
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
      Left = 10
      Top = 330
      Width = 468
      Height = 49
      Caption = 'Cla&ssificação dos funcionários'
      Columns = 2
      DataField = 'ORDEM'
      DataSource = dtsConfig
      Items.Strings = (
        'Nome'
        'Código')
      TabOrder = 4
      Values.Strings = (
        'N'
        'C')
    end
    object gpCargo: TGroupBox
      Left = 10
      Top = 238
      Width = 468
      Height = 86
      Caption = '&Cargo'
      TabOrder = 3
      object dbCargoX: TCheckBox
        Left = 10
        Top = 23
        Width = 148
        Height = 21
        Caption = 'Todos os cargos'
        TabOrder = 0
        OnClick = dbCargoXClick
      end
      object dbCargoCodigo: TwwDBLookupCombo
        Left = 10
        Top = 48
        Width = 86
        Height = 24
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
        Left = 102
        Top = 48
        Width = 345
        Height = 24
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
      Left = 10
      Top = 170
      Width = 468
      Height = 61
      Caption = '&Recursos'
      TabOrder = 2
      object dbRecursoX: TCheckBox
        Left = 10
        Top = 23
        Width = 135
        Height = 21
        Caption = 'Todos os Recursos'
        TabOrder = 0
        OnClick = dbRecursoXClick
      end
      object dbRecurso: TwwDBLookupCombo
        Left = 151
        Top = 21
        Width = 296
        Height = 24
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
      Left = 10
      Top = 102
      Width = 468
      Height = 62
      Caption = '&Tipo de Funcionário'
      TabOrder = 1
      object dbTipoX: TCheckBox
        Left = 10
        Top = 23
        Width = 123
        Height = 21
        Caption = 'Todos os Tipos'
        TabOrder = 0
        OnClick = dbTipoXClick
      end
      object dbTipo: TwwDBLookupCombo
        Left = 151
        Top = 21
        Width = 296
        Height = 24
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
    object dbSalario: TCheckBox
      Left = 10
      Top = 394
      Width = 123
      Height = 21
      Caption = 'Mostrar salários'
      Checked = True
      State = cbChecked
      TabOrder = 5
    end
    object dbDemitido: TCheckBox
      Left = 170
      Top = 394
      Width = 123
      Height = 21
      Caption = 'Incluir demitido'
      TabOrder = 6
    end
    object dbAtivo: TCheckBox
      Left = 346
      Top = 394
      Width = 123
      Height = 21
      Caption = 'Incluir ativos'
      Checked = True
      State = cbChecked
      TabOrder = 7
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
      'WHERE co_empresa = :empresa'
      'ORDER BY co_folha')
    Left = 248
    Top = 40
  end
  object mtConfig: TkbmMemTable
    AttachedAutoRefresh = True
    EnableIndexes = True
    IndexDefs = <>
    RecalcOnIndex = False
    SortOptions = []
    CommaTextOptions = [mtfSaveData]
    PersistentSaveOptions = [mtfSaveData, mtfSaveNonVisible]
    PersistentSaveFormat = mtsfBinary
    Version = '2.01'
    OnNewRecord = mtConfigNewRecord
    Left = 312
    Top = 96
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
end
