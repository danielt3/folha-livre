object frmc_rendimento: Tfrmc_rendimento
  Left = 100
  Top = 72
  BorderStyle = bsDialog
  Caption = 'Configura'#231#227'o do Comprovante de Rendimentos'
  ClientHeight = 473
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object pnlControle: TPanel
    Left = 0
    Top = 413
    Width = 692
    Height = 60
    Align = alBottom
    ParentColor = True
    TabOrder = 3
    object btnNovo: TButton
      Left = 8
      Top = 16
      Width = 80
      Height = 30
      Caption = 'N&ovo'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnNovoClick
    end
    object btnExcluir: TButton
      Left = 399
      Top = 16
      Width = 80
      Height = 30
      Caption = 'E&xcluir'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = btnExcluirClick
    end
    object btnPrevisao: TButton
      Left = 497
      Top = 16
      Width = 80
      Height = 30
      Caption = '&Previs'#227'o'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object btnFechar: TButton
      Left = 595
      Top = 16
      Width = 80
      Height = 30
      Caption = '&Fechar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 6
    end
    object btnGravar: TButton
      Left = 203
      Top = 16
      Width = 80
      Height = 30
      Caption = '&Gravar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnGravarClick
    end
    object btnCancelar: TButton
      Left = 301
      Top = 16
      Width = 80
      Height = 30
      Caption = '&Cancelar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = btnCancelarClick
    end
    object btnEditar: TButton
      Left = 105
      Top = 16
      Width = 80
      Height = 30
      Caption = '&Editar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnEditarClick
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 288
    Width = 692
    Height = 125
    Align = alBottom
    TabOrder = 2
    object lbGrupo: TLabel
      Left = 8
      Top = 8
      Width = 30
      Height = 14
      Caption = 'Grupo'
    end
    object lbSubGrupo: TLabel
      Left = 82
      Top = 8
      Width = 49
      Height = 14
      Caption = 'SubGrupo'
    end
    object lbDescricao: TLabel
      Left = 146
      Top = 8
      Width = 49
      Height = 14
      Caption = 'Descri'#231#227'o'
    end
    object lbEvento: TLabel
      Left = 8
      Top = 52
      Width = 50
      Height = 14
      Caption = 'Evento (+)'
    end
    object lbTotalizador: TLabel
      Left = 8
      Top = 76
      Width = 70
      Height = 14
      Caption = 'Totalizador (+)'
    end
    object Label1: TLabel
      Left = 1
      Top = 94
      Width = 690
      Height = 30
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 
        'Para pesquisar "Eventos" ou "Totalizadores" pressione [F12] nos ' +
        'respectivos campos ou informe 0 (zero) para nenhum.'
      Layout = tlCenter
    end
    object dbGrupo: TDBEdit
      Left = 8
      Top = 24
      Width = 70
      Height = 22
      DataField = 'GRUPO'
      DataSource = DataSource1
      TabOrder = 0
    end
    object dbSubGrupo: TDBEdit
      Left = 82
      Top = 24
      Width = 60
      Height = 22
      DataField = 'SUBGRUPO'
      DataSource = DataSource1
      TabOrder = 1
    end
    object dbDescricao: TDBEdit
      Left = 146
      Top = 24
      Width = 500
      Height = 22
      CharCase = ecUpperCase
      DataField = 'DESCRICAO'
      DataSource = DataSource1
      TabOrder = 2
    end
    object dbEvento: TDBEdit
      Left = 82
      Top = 48
      Width = 60
      Height = 22
      CharCase = ecUpperCase
      DataField = 'IDEVENTO'
      DataSource = DataSource1
      TabOrder = 3
    end
    object dbEvento2: TDBEdit
      Left = 146
      Top = 48
      Width = 500
      Height = 22
      TabStop = False
      CharCase = ecUpperCase
      DataField = 'EVENTO'
      DataSource = DataSource1
      ParentColor = True
      ReadOnly = True
      TabOrder = 4
    end
    object dbTotalizador: TDBEdit
      Left = 82
      Top = 72
      Width = 60
      Height = 22
      CharCase = ecUpperCase
      DataField = 'IDTOTALIZADOR'
      DataSource = DataSource1
      TabOrder = 5
    end
    object dbTotalizador2: TDBEdit
      Left = 146
      Top = 72
      Width = 500
      Height = 22
      TabStop = False
      CharCase = ecUpperCase
      DataField = 'TOTALIZADOR'
      DataSource = DataSource1
      ParentColor = True
      ReadOnly = True
      TabOrder = 6
    end
  end
  object dbGrid1: TDBGrid
    Left = 0
    Top = 70
    Width = 692
    Height = 218
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = ANSI_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Arial'
    TitleFont.Style = []
    OnDrawColumnCell = dbGrid1DrawColumnCell
  end
  object pnlGrupo: TPanel
    Left = 0
    Top = 0
    Width = 692
    Height = 70
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object lbInforme: TLabel
      Left = 0
      Top = 43
      Width = 692
      Height = 27
      Align = alBottom
      Alignment = taCenter
      AutoSize = False
      Caption = 'Pressione a tecla [F4] para pesquisar os grupos de empresas    '
      Layout = tlCenter
    end
    object dbGE: TEdit
      Left = 8
      Top = 8
      Width = 600
      Height = 22
      TabStop = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object DataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterInsert = DataSet1AfterInsert
    BeforeEdit = DataSet1BeforeEdit
    AfterEdit = DataSet1AfterEdit
    BeforePost = DataSet1BeforePost
    AfterPost = DataSet1AfterPost
    AfterCancel = DataSet1AfterCancel
    BeforeDelete = DataSet1BeforeDelete
    OnNewRecord = DataSet1NewRecord
    Left = 200
    Top = 144
    object DataSet1IDGE: TIntegerField
      FieldName = 'IDGE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object DataSet1GRUPO: TSmallintField
      FieldName = 'GRUPO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object DataSet1SUBGRUPO: TSmallintField
      FieldName = 'SUBGRUPO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object DataSet1DESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 100
    end
    object DataSet1IDEVENTO: TStringField
      Alignment = taRightJustify
      FieldName = 'IDEVENTO'
    end
    object DataSet1IDTOTALIZADOR: TStringField
      Alignment = taRightJustify
      FieldName = 'IDTOTALIZADOR'
      Size = 10
    end
    object DataSet1EVENTO: TStringField
      FieldName = 'EVENTO'
      ProviderFlags = [pfHidden]
      Size = 50
    end
    object DataSet1TOTALIZADOR: TStringField
      FieldName = 'TOTALIZADOR'
      ProviderFlags = [pfHidden]
      Size = 50
    end
  end
  object DataSource1: TDataSource
    DataSet = DataSet1
    OnStateChange = DataSource1StateChange
    Left = 296
    Top = 144
  end
end
