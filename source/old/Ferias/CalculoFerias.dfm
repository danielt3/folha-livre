object frmProgFerias: TfrmProgFerias
  Left = 131
  Top = 98
  BorderStyle = bsDialog
  Caption = 'Programa��o de F�rias'
  ClientHeight = 364
  ClientWidth = 538
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
  object PnlTitulo: TPanel
    Left = 0
    Top = 41
    Width = 538
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Periodos de Ferias'
    Color = clBlack
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object pnlRubrica: TPanel
    Left = 0
    Top = 61
    Width = 538
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    OnEnter = pnlRubricaEnter
    object lblValor: TLabel
      Left = 306
      Top = 27
      Width = 28
      Height = 13
      Caption = 'Faltas'
      FocusControl = dbFaltas
    end
    object Label4: TLabel
      Left = 305
      Top = 51
      Width = 59
      Height = 13
      Caption = 'Afastamento'
      FocusControl = dbAfastamento
    end
    object lblAquisitivo1: TLabel
      Left = 8
      Top = 8
      Width = 84
      Height = 13
      Caption = 'P�riodo Aquisitivo'
      FocusControl = dbAquisitivo1
    end
    object lblGozo: TLabel
      Left = 108
      Top = 8
      Width = 79
      Height = 13
      Caption = 'Periodo de Gozo'
      FocusControl = dbAquisitivo1
    end
    object lblPecuniario: TLabel
      Left = 208
      Top = 8
      Width = 89
      Height = 13
      Caption = 'Periodo Pecuniario'
      FocusControl = dbPecuniario1
    end
    object dbFaltas: TDBEdit
      Left = 370
      Top = 24
      Width = 60
      Height = 19
      DataField = 'Faltas'
      DataSource = dtsFerias
      DecimalPlaces = 0
      DisplayFormat = ',0'
      FormatOnEditing = True
      NumGlyphs = 2
      TabOrder = 6
      ZeroEmpty = False
    end
    object dbAfastamento: TDBEdit
      Left = 369
      Top = 48
      Width = 60
      Height = 19
      DataField = 'Afastamento'
      DataSource = dtsFerias
      DecimalPlaces = 0
      DisplayFormat = ',0'
      FormatOnEditing = True
      NumGlyphs = 2
      TabOrder = 7
      ZeroEmpty = False
    end
    object dbAquisitivo1: TDBEdit
      Left = 8
      Top = 24
      Width = 90
      Height = 19
      DataField = 'Aquisitivo_1'
      DataSource = dtsFerias
      NumGlyphs = 2
      TabOrder = 0
    end
    object dbAquisitivo2: TDBEdit
      Left = 8
      Top = 48
      Width = 90
      Height = 19
      DataField = 'Aquisitivo_2'
      DataSource = dtsFerias
      NumGlyphs = 2
      TabOrder = 1
    end
    object dbGozo1: TDBEdit
      Left = 108
      Top = 24
      Width = 90
      Height = 19
      DataField = 'Gozo_1'
      DataSource = dtsFerias
      NumGlyphs = 2
      TabOrder = 2
    end
    object dbGozo2: TDBEdit
      Left = 108
      Top = 48
      Width = 90
      Height = 19
      DataField = 'Gozo_2'
      DataSource = dtsFerias
      NumGlyphs = 2
      TabOrder = 3
    end
    object dbPecuniario2: TDBEdit
      Left = 208
      Top = 48
      Width = 90
      Height = 19
      DataField = 'Pecuniario_2'
      DataSource = dtsFerias
      NumGlyphs = 2
      TabOrder = 5
    end
    object dbPecuniario1: TDBEdit
      Left = 208
      Top = 24
      Width = 90
      Height = 19
      DataField = 'Pecuniario_1'
      DataSource = dtsFerias
      NumGlyphs = 2
      TabOrder = 4
    end
  end
  object dbgFerias: TDBGrid
    Left = 0
    Top = 137
    Width = 538
    Height = 187
    TabStop = False
    Align = alClient
    DataSource = dtsFerias
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentColor = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnKeyDown = dbgFeriasKeyDown
    OnGetCellParams = dbgFeriasGetCellParams
    Columns = <
      item
        Expanded = False
        FieldName = 'Aquisitivo_1'
        Title.Caption = 'Aquisitivo'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Aquisitivo_2'
        Title.Caption = '.'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Gozo_1'
        Title.Caption = 'Gozo Ferias'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Gozo_2'
        Title.Caption = '.'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Pecuniario_1'
        Title.Caption = 'Pecuni�rio'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Pecuniario_2'
        Title.Caption = '.'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Faltas'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Afastamento'
        Title.Caption = 'Afast.'
        Width = 40
        Visible = True
      end>
  end
  object pnlFuncionario: TPanel
    Left = 0
    Top = 0
    Width = 538
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    OnEnter = pnlFuncionarioEnter
    object Label3: TLabel
      Left = 8
      Top = 11
      Width = 55
      Height = 13
      Caption = 'F&uncion�rio'
      FocusControl = dbFuncionarioCodigo
    end
    object Label1: TLabel
      Left = 403
      Top = 11
      Width = 48
      Height = 13
      Caption = 'Admiss�o:'
    end
    object dbFuncionarioCodigo: TwwDBLookupCombo
      Left = 72
      Top = 8
      Width = 70
      Height = 19
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'co_funcionario'#9'10'#9'co_funcionario'#9'F'
        'no_funcionario'#9'60'#9'no_funcionario'#9'F')
      DataField = 'co_funcionario'
      DataSource = dtsConfig
      LookupTable = qryFuncionario
      LookupField = 'co_funcionario'
      Options = [loColLines]
      Style = csDropDownList
      TabOrder = 0
      AutoDropDown = True
      ShowButton = False
      AllowClearKey = False
      ShowMatchText = True
      OnEnter = dbEmpresaCodigoEnter
      OnExit = dbEmpresaCodigoExit
    end
    object dbFuncionarioNome: TwwDBLookupCombo
      Left = 147
      Top = 8
      Width = 250
      Height = 19
      DropDownAlignment = taLeftJustify
      Selected.Strings = (
        'no_funcionario'#9'60'#9'no_funcionario'#9'F'
        'co_funcionario'#9'10'#9'co_funcionario'#9'F')
      DataField = 'co_funcionario'
      DataSource = dtsConfig
      LookupTable = qryFuncionario
      LookupField = 'co_funcionario'
      Options = [loColLines]
      Style = csDropDownList
      TabOrder = 1
      AutoDropDown = True
      ShowButton = False
      AllowClearKey = False
      ShowMatchText = True
      OnEnter = dbEmpresaCodigoEnter
      OnExit = dbEmpresaCodigoExit
    end
    object dbAdmissao: TDBEdit
      Left = 456
      Top = 8
      Width = 70
      Height = 19
      DataField = 'dt_admissao'
      DataSource = dtsFuncionario
      Enabled = False
      ButtonWidth = 0
      NumGlyphs = 2
      ParentColor = True
      TabOrder = 2
    end
  end
  object PnlControle: TPanel
    Left = 0
    Top = 324
    Width = 538
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    Color = 8101828
    TabOrder = 4
    object btnNovo: TRxSpeedButton
      Left = 6
      Top = 6
      Width = 80
      Height = 25
      Caption = 'N&ovo...'
      Flat = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000CE0E0000C40E00000000000000000000800080800080
        800080800080800080800080800080800080C0C0C00000000000000000008000
        8080008080008080008080008080008080008080008080008080008080008080
        0080C0C0C0808080808080808080800080800080800080800080C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000FF000080000080000000008000
        80800080800080800080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0FFFFFFC0C0C0C0C0C0808080800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000FF000080000080000000008000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
        8080FFFFFFC0C0C0C0C0C0808080800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000FF000080000080000000008000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
        8080FFFFFFC0C0C0C0C0C0808080800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFF00000000000000000000FF000080000080000000000000
        00000000000000800080808080FFFFFFFFFFFFFFFFFFFFFFFF80808080808080
        8080FFFFFFC0C0C0C0C0C0808080808080808080808080808080000000000000
        00000000000000FF000080000080000080000080000080000080000080000080
        00008000000000800080808080808080808080808080FFFFFFC0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080808080808080
        80808080808000FF000080000080000080000080000080000080000080000080
        00008000000000800080C0C0C0C0C0C0C0C0C0C0C0C0FFFFFFC0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080000000FFFFFF
        FFFFFFFFFFFF00FF0000FF0000FF0000FF0000FF0000800000800000FF0000FF
        0000FF00C0C0C0800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFC0C0C0C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000FF000080000080000000008000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
        8080FFFFFFC0C0C0C0C0C0808080800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808000FF000080000080000000008000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
        8080FFFFFFC0C0C0C0C0C0808080800080800080800080800080000000000000
        00000000000000000000000000000000000000FF000080000080000000008000
        8080008080008080008080808080808080808080808080808080808080808080
        8080FFFFFFC0C0C0C0C0C0808080800080800080800080800080808080808080
        80808080808080808080808080808080808000FF0000FF0000FF00C0C0C08000
        80800080800080800080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0FFFFFFFFFFFFFFFFFFC0C0C0800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C08000808000808000808000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0800080800080800080800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C08000808000808000808000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0800080800080800080800080800080800080800080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C08000808000808000808000
        80800080800080800080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0800080800080800080800080800080800080800080000000000000
        000000000000000000000000000000000000C0C0C08000808000808000808000
        8080008080008080008080808080808080808080808080808080808080808080
        8080C0C0C0800080800080800080800080800080800080800080}
      Layout = blGlyphLeft
      NumGlyphs = 2
      Spacing = 5
      Transparent = True
      OnClick = btnNovoClick
    end
    object btnEditar: TRxSpeedButton
      Left = 93
      Top = 6
      Width = 80
      Height = 25
      Caption = '&Editar'
      Flat = True
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000000
        000033333377777777773333330FFFFFFFF03FF3FF7FF33F3FF700300000FF0F
        00F077F777773F737737E00BFBFB0FFFFFF07773333F7F3333F7E0BFBF000FFF
        F0F077F3337773F3F737E0FBFBFBF0F00FF077F3333FF7F77F37E0BFBF00000B
        0FF077F3337777737337E0FBFBFBFBF0FFF077F33FFFFFF73337E0BF0000000F
        FFF077FF777777733FF7000BFB00B0FF00F07773FF77373377373330000B0FFF
        FFF03337777373333FF7333330B0FFFF00003333373733FF777733330B0FF00F
        0FF03333737F37737F373330B00FFFFF0F033337F77F33337F733309030FFFFF
        00333377737FFFFF773333303300000003333337337777777333}
      Layout = blGlyphLeft
      NumGlyphs = 2
      Spacing = 5
      Transparent = True
      OnClick = btnEditarClick
    end
    object btnGravar: TRxSpeedButton
      Left = 180
      Top = 6
      Width = 80
      Height = 25
      Caption = '&Gravar'
      Flat = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000CE0E0000C40E00000000000000000000008080008080
        0080800080800080800080800080800080800000000000008080800000008080
        8080808000000000000000808000808000808000808000808000808000808000
        8080808080808080808080808080808080808080808080808080808080808080
        808080808080808080808080808080808080000000000000C0C0C0000000C0C0
        C0C0C0C0000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0808080808080FFFFFF808080FFFFFFFFFFFF808080808080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000000000C0C0C0C0C0C0C0C0
        C0C0C0C0000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0808080808080FFFFFFFFFFFFFFFFFFFFFFFF808080808080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800000000000000000000000000000
        00000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0808080808080808080808080808080808080808080808080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800000000000000000000000000000
        00000000000000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0808080808080808080808080808080808080808080808080000000000000
        000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF00000080808080808080808080808080808080808080808080
        8080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080808080808080
        808080808080808080808080808080808080000000FFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFF000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080000000FF0000FF0000FF00000000
        FFFF0000FF0000000000808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0808080808080808080808080808080808080808080808080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800080800000FF0000
        FF0000FF008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080008080808080808080808080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800000FF0000FF0000
        FF0000FF0000FF008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080808080808080808080808080808080008080000000000000
        0000000000000000000000000000000000000080800000FF0000FF0000FF0000
        FF0000FF0000FF0000FF80808080808080808080808080808080808080808080
        8080008080808080808080808080808080808080808080808080808080808080
        8080808080808080808080808080808080800080800080800080800000FF0000
        FF0000FF008080008080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0008080008080008080808080808080808080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800080800000FF0000
        FF0000FF008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080008080808080808080808080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800080800000FF0000
        FF0000FF008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080008080808080808080808080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800000FF0000FF0000FF0000FF0000
        FF008080008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0808080808080808080808080808080008080008080008080000000000000
        0000000000000000000000000000000000000080800080800080800080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080008080008080008080008080008080008080008080008080}
      Layout = blGlyphLeft
      NumGlyphs = 2
      Spacing = 5
      Transparent = True
      OnClick = btnGravarClick
    end
    object btnCancelar: TRxSpeedButton
      Left = 266
      Top = 6
      Width = 80
      Height = 25
      Caption = '&Cancelar'
      Flat = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000CE0E0000C40E00000000000000000000008080008080
        0080800080800080800080800000000000000080800080800080800080800080
        8000000000000000808000808000808000808000808000808000808080808080
        8080808080008080008080008080008080808080808080008080C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C00000000000800000800000000080800080800080800000
        00000080000080000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080C0C0C0C0
        C0C0808080008080008080008080808080C0C0C0C0C0C0808080000000FFFFFF
        FFFFFFFFFFFFFFFFFF0000FF0000800000800000800000000080800000000000
        800000800000800000FF808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0
        C0C0C0C0C0808080008080808080C0C0C0C0C0C0C0C0C0FFFFFF000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000800000800000800000000000800000
        800000800000FF008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0C0C0C0808080C0C0C0C0C0C0C0C0C0FFFFFF008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000800000800000800000800000
        800000FF008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FFFFFF008080008080000000000000
        0000000000000000000000000000000000000000FF0000800000800000800000
        FF00808000808000808080808080808080808080808080808080808080808080
        8080FFFFFFC0C0C0C0C0C0C0C0C0FFFFFF008080008080008080808080808080
        8080808080808080808080808080800000000000800000800000800000800000
        80000000008080008080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C080
        8080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000000000800000800000800000FF0000800000
        80000080000000008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0
        C0C0C0C0C0C0C0C0FFFFFFC0C0C0C0C0C0C0C0C0808080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFF0000000000800000800000800000FF0080800000FF0000
        80000080000080000000808080FFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C0C0
        C0C0C0C0C0FFFFFF008080FFFFFFC0C0C0C0C0C0C0C0C0808080000000FFFFFF
        FFFFFFFFFFFFFFFFFF0000FF0000800000800000FF0080800080800080800000
        FF0000800000800000FF808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C0C0
        C0C0FFFFFF008080008080008080FFFFFFC0C0C0C0C0C0FFFFFF000000000000
        0000000000000000000000000000FF0000FF0080800080800080800080800080
        800000FF0000FF008080808080808080808080808080808080808080FFFFFFFF
        FFFF008080008080008080008080008080FFFFFFFFFFFF008080808080808080
        8080808080808080808080808080808080800080800080800080800080800080
        80008080008080008080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0008080008080008080008080008080008080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800080800080800080
        80008080008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080008080008080008080008080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800080800080800080
        80008080008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080008080008080008080008080008080008080000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080800080800080800080800080800080
        80008080008080008080808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0008080008080008080008080008080008080008080008080000000000000
        0000000000000000000000000000000000000080800080800080800080800080
        8000808000808000808080808080808080808080808080808080808080808080
        8080008080008080008080008080008080008080008080008080}
      Layout = blGlyphLeft
      NumGlyphs = 2
      Spacing = 5
      Transparent = True
      OnClick = btnCancelarClick
    end
    object btnExcluir: TRxSpeedButton
      Left = 353
      Top = 6
      Width = 80
      Height = 25
      Caption = 'E&xcluir...'
      Flat = True
      Glyph.Data = {
        36060000424D3606000000000000360000002800000020000000100000000100
        18000000000000060000CE0E0000C40E00000000000000000000C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C000FFFF008080008080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0FFFFFF808080808080C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0808080808080C0C0C0C0C0C0C0C0C0C0C0C000FF
        FF00FFFF00FFFF00FFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C080808080
        8080C0C0C0C0C0C0C0C0C0C0C0C0FFFFFFFFFFFFFFFFFFFFFFFF000000C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080C0C0C0C0C0C0C0C0C000FFFF00FF
        FF00808000808000FFFF808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C080
        8080C0C0C0C0C0C0C0C0C0FFFFFFFFFFFF808080808080FFFFFF000000C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000FF0000FF0000FF
        FF00FFFF00808000FFFF808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0FFFFFFFFFFFFFFFFFFFFFFFF808080FFFFFF000000FFFFFF
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C000000000FF000080000080
        0000FFFF00FFFFC0C0C0808080FFFFFFC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0808080FFFFFF808080808080FFFFFFFFFFFFC0C0C0000000000000
        000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0C00000FFFF00FF00000000800000FF
        0000FF00C0C0C0C0C0C0808080808080808080C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0808080FFFFFF808080808080FFFFFFFFFFFFC0C0C0C0C0C0808080808080
        808080808080C0C0C0C0C0C0C0C0C00000FFFF00FFFF00FFFF00FF00000000FF
        00C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C080
        8080FFFFFFFFFFFFFFFFFF808080FFFFFFC0C0C0C0C0C0C0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFC0C0C00000FFFF00FFFF00FFFF00FFFF00FF0000FFC0C0
        C0C0C0C0C0C0C0C0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0808080FF
        FFFFFFFFFFFFFFFFFFFFFF808080C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFF0000FFFF00FFFF00FFFF00FF0000FFC0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80808080
        8080808080FFFFFF808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FFC0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF80
        8080808080808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000
        000000000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C080808080808080808080808080808080808080808080
        8080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0808080808080
        808080808080808080808080808080808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF808080C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C0808080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0
        C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0000000000000
        000000000000000000000000000000000000C0C0C0C0C0C0C0C0C0C0C0C0C0C0
        C0C0C0C0C0C0C0C0C0C080808080808080808080808080808080808080808080
        8080C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0}
      Layout = blGlyphLeft
      NumGlyphs = 2
      Spacing = 5
      Transparent = True
      OnClick = btnExcluirClick
    end
  end
  object memConfig: TkbmMemTable
    Active = True
    AttachedAutoRefresh = True
    EnableIndexes = True
    IndexDefs = <>
    RecalcOnIndex = False
    SortOptions = []
    CommaTextOptions = [mtfSaveData]
    PersistentSaveOptions = [mtfSaveData, mtfSaveNonVisible]
    PersistentSaveFormat = mtsfBinary
    Version = '2.01'
    Left = 328
    Top = 221
    object memConfigco_funcionario: TIntegerField
      FieldName = 'co_funcionario'
    end
  end
  object dtsConfig: TDataSource
    DataSet = memConfig
    Left = 328
    Top = 274
  end
  object qryFuncionario: TADOQuery
    ConnectionString = 
      'FILE NAME=C:\Arquivos de programas\Arquivos comuns\System\OLE DB' +
      '\Data Links\Folha.udl'
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
      '  co_funcionario, no_funcionario, dt_admissao'
      'FROM'
      '  funcionario'
      'WHERE'
      '  co_empresa = :empresa'
      'ORDER BY'
      '  co_funcionario'
      ''
      ' ')
    Left = 256
    Top = 224
  end
  object qryFerias: TADOQuery
    ConnectionString = 
      'FILE NAME=C:\Arquivos de programas\Arquivos comuns\System\OLE DB' +
      '\Data Links\Folha.udl'
    CursorType = ctStatic
    OnNewRecord = qryFeriasNewRecord
    Parameters = <
      item
        Name = 'empresa'
        DataType = ftString
        NumericScale = 255
        Precision = 255
        Size = 3
        Value = '001'
      end
      item
        Name = 'funcionario'
        Attributes = [paSigned]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 1
      end>
    SQL.Strings = (
      'SELECT * FROM FUNCIONARIO_FERIAS'
      'WHERE '
      '  co_empresa = :empresa and'
      '  co_funcionario = :funcionario'
      'ORDER BY'
      '  aquisitivo_1 desc'
      ' '
      ' '
      ' ')
    Left = 448
    Top = 216
  end
  object dtsFerias: TDataSource
    AutoEdit = False
    DataSet = qryFerias
    OnStateChange = dtsFeriasStateChange
    Left = 448
    Top = 266
  end
  object dtsFuncionario: TDataSource
    AutoEdit = False
    DataSet = qryFuncionario
    Left = 256
    Top = 274
  end
end
