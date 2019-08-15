object frmRel: TfrmRel
  Left = 80
  Top = 116
  Width = 517
  Height = 213
  Caption = 'frmRel'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object tbl: TkbmMemTable
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
    Left = 176
    Top = 16
    object tblco_funcionario: TIntegerField
      Tag = 1
      DisplayLabel = 'CODIGO'
      DisplayWidth = 6
      FieldName = 'co_funcionario'
    end
    object tblno_funcionario: TStringField
      Tag = 1
      DisplayLabel = 'NOME DO FUNCIONARIO'
      FieldName = 'no_funcionario'
      Size = 50
    end
    object tblco_cargo: TIntegerField
      FieldName = 'co_cargo'
    end
    object tblno_cargo: TStringField
      Tag = 1
      DisplayLabel = 'CARGO'
      FieldName = 'no_cargo'
      Size = 25
    end
    object tblvr_salario: TCurrencyField
      Tag = 1
      DisplayLabel = 'SALARIO'
      FieldName = 'vr_salario'
      DisplayFormat = ',0.00'
    end
    object tblco_tipo_funcionario: TStringField
      FieldName = 'co_tipo_funcionario'
      Size = 2
    end
    object tblds_tipo_funcionario: TStringField
      Tag = 1
      DisplayLabel = 'TIPO'
      DisplayWidth = 4
      FieldName = 'ds_tipo_funcionario'
      Size = 15
    end
    object tbldt_admissao: TDateField
      Tag = 1
      DisplayLabel = 'ADMISSAO'
      FieldName = 'dt_admissao'
    end
    object tblno_lotacao: TStringField
      DisplayLabel = 'LOTACAO'
      FieldName = 'no_lotacao'
      Size = 30
    end
    object tblco_lotacao: TStringField
      Tag = 1
      DisplayLabel = 'LOTACAO'
      FieldName = 'co_lotacao'
      Size = 7
    end
  end
  object TbPrinter1: TTbPrinter
    FastPrinter = Epson_FX
    FastPort = 'LPT1'
    FastFont = [Comprimido]
    Zoom = zReal
    Preview = False
    WinPrinter = 'Epson LX-300'
    WinPort = 'LPT1:'
    LineaTitulo = 3
    LineaSubTitulo = 4
    Left = 256
    Top = 16
  end
  object TbCustomReport1: TTbCustomReport
    Printer = TbPrinter1
    OnGenerate = TbCustomReport1Generate
    Left = 96
    Top = 40
  end
end
