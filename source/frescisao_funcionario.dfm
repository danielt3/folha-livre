object frmRescisaoFuncionario: TfrmRescisaoFuncionario
  Left = 238
  Top = 138
  BorderStyle = bsDialog
  Caption = 'Rescis'#227'o de Contrato de Trabalho'
  ClientHeight = 285
  ClientWidth = 444
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 8
    Top = 69
    Width = 430
    Height = 55
    BevelInner = bvLowered
    TabOrder = 1
    object lbDemissao: TLabel
      Left = 8
      Top = 8
      Width = 87
      Height = 13
      Caption = 'Data de Demiss'#227'o'
      FocusControl = dbDemissao
    end
    object lbRemuneracao: TLabel
      Left = 103
      Top = 8
      Width = 67
      Height = 13
      Caption = 'Remunera'#231#227'o'
      FocusControl = dbRemuneracao
    end
    object Label7: TLabel
      Left = 304
      Top = 8
      Width = 67
      Height = 13
      Caption = 'Data do Aviso'
      FocusControl = dbAvisoData
    end
    object dbDemissao: TDBEdit
      Left = 8
      Top = 24
      Width = 90
      Height = 19
      DataField = 'DEMISSAO'
      DataSource = dsRescisao
      TabOrder = 0
    end
    object dbRemuneracao: TDBEdit
      Left = 103
      Top = 24
      Width = 90
      Height = 19
      DataField = 'REMUNERACAO'
      DataSource = dsRescisao
      TabOrder = 1
    end
    object dbAviso: TDBCheckBox
      Left = 203
      Top = 24
      Width = 90
      Height = 17
      Caption = 'Aviso Pr'#233'vio?'
      DataField = 'AVISO_PREVIO_X'
      DataSource = dsRescisao
      TabOrder = 2
      ValueChecked = '1'
      ValueUnchecked = '0'
    end
    object dbAvisoData: TDBEdit
      Left = 304
      Top = 24
      Width = 100
      Height = 19
      DataField = 'AVISO_PREVIO_DATA'
      DataSource = dsRescisao
      TabOrder = 3
    end
  end
  object Panel2: TPanel
    Left = 8
    Top = 131
    Width = 430
    Height = 94
    BevelInner = bvLowered
    TabOrder = 2
    object Label8: TLabel
      Left = 8
      Top = 8
      Width = 225
      Height = 13
      Caption = 'Causa da Rescis'#227'o de Contrato de Trabalho (+)'
      FocusControl = dbCausa
    end
    object lbCAGED: TLabel
      Left = 8
      Top = 48
      Width = 266
      Height = 13
      Caption = 'CAGED - Cadastro Geral de Empregados e Demitidos (+)'
      FocusControl = dbCAGED
    end
    object dbCausa: TDBEdit
      Left = 8
      Top = 24
      Width = 50
      Height = 19
      DataField = 'IDRESCISAO'
      DataSource = dsRescisao
      TabOrder = 0
    end
    object dbCausa2: TDBEdit
      Left = 63
      Top = 24
      Width = 350
      Height = 19
      DataField = 'RESCISAO'
      DataSource = dsRescisao
      TabOrder = 1
    end
    object dbCAGED: TDBEdit
      Left = 8
      Top = 64
      Width = 50
      Height = 19
      DataField = 'IDCAGED'
      DataSource = dsRescisao
      TabOrder = 2
    end
    object dbCAGED2: TDBEdit
      Left = 63
      Top = 64
      Width = 350
      Height = 19
      DataField = 'CAGED'
      DataSource = dsRescisao
      TabOrder = 3
    end
  end
  object pnlControle: TPanel
    Left = 8
    Top = 232
    Width = 430
    Height = 45
    BevelOuter = bvNone
    TabOrder = 3
    object btnOK: TButton
      Left = 204
      Top = 8
      Width = 100
      Height = 25
      Caption = '&OK'
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancelar: TButton
      Left = 316
      Top = 8
      Width = 100
      Height = 25
      Caption = '&Cancelar'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlFuncionario: TPanel
    Left = 8
    Top = 8
    Width = 430
    Height = 55
    BevelInner = bvLowered
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 70
      Height = 13
      Caption = 'Funcion'#225'rio (+)'
      FocusControl = dbFuncionario
    end
    object dbFuncionario: TDBEdit
      Left = 8
      Top = 24
      Width = 90
      Height = 19
      DataField = 'IDFUNCIONARIO'
      DataSource = dsRescisao
      TabOrder = 0
    end
    object dbNome: TDBEdit
      Left = 103
      Top = 24
      Width = 310
      Height = 19
      DataField = 'NOME'
      DataSource = dsRescisao
      TabOrder = 1
    end
  end
  object cdRescisao: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdRescisaoAfterOpen
    BeforePost = cdRescisaoBeforePost
    OnNewRecord = cdRescisaoNewRecord
    Left = 288
    Top = 184
    object cdRescisaoIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdRescisaoIDFUNCIONARIO: TIntegerField
      FieldName = 'IDFUNCIONARIO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object cdRescisaoNOME: TStringField
      FieldName = 'NOME'
      ProviderFlags = [pfInUpdate, pfInWhere, pfHidden]
      Size = 50
    end
    object cdRescisaoDEMISSAO: TDateField
      FieldName = 'DEMISSAO'
    end
    object cdRescisaoREMUNERACAO: TCurrencyField
      FieldName = 'REMUNERACAO'
    end
    object cdRescisaoAVISO_PREVIO_X: TSmallintField
      FieldName = 'AVISO_PREVIO_X'
    end
    object cdRescisaoAVISO_PREVIO_DATA: TDateField
      FieldName = 'AVISO_PREVIO_DATA'
    end
    object cdRescisaoIDRESCISAO: TStringField
      FieldName = 'IDRESCISAO'
      Size = 2
    end
    object cdRescisaoRESCISAO: TStringField
      FieldName = 'RESCISAO'
      ProviderFlags = [pfHidden]
      Size = 50
    end
    object cdRescisaoIDCAGED: TStringField
      FieldName = 'IDCAGED'
      Size = 2
    end
    object cdRescisaoIDFOLHA: TIntegerField
      FieldName = 'IDFOLHA'
    end
    object cdRescisaoCAGED: TStringField
      FieldName = 'CAGED'
      ProviderFlags = [pfHidden]
      Size = 30
    end
  end
  object dsRescisao: TDataSource
    DataSet = cdRescisao
    Left = 360
    Top = 184
  end
end
