object FrmPesqPlano: TFrmPesqPlano
  Left = 147
  Top = 72
  BorderStyle = bsDialog
  Caption = 'Pesquisando Plano de Contas'
  ClientHeight = 348
  ClientWidth = 432
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
  object dbgPlano: TDBGrid
    Left = 0
    Top = 0
    Width = 432
    Height = 348
    Align = alClient
    DataSource = dts
    Options = [dgTitles, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentColor = True
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnDrawColumnCell = dbgPlanoDrawColumnCell
    OnTitleClick = dbgPlanoTitleClick
    Columns = <
      item
        Expanded = False
        FieldName = 'CODIGO2'
        Title.Caption = 'Classifica'#231#227'o'
        Width = 80
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOME2'
        Title.Caption = 'Nome'
        Width = 280
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IDPLANO'
        Title.Caption = 'ID'
        Width = 50
        Visible = True
      end>
  end
  object dts: TDataSource
    AutoEdit = False
    DataSet = mt
    Left = 232
    Top = 112
  end
  object mt: TClientDataSet
    Aggregates = <>
    Params = <>
    OnCalcFields = mtCalcFields
    Left = 104
    Top = 160
    object mtCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 15
    end
    object mtIDPLANO: TIntegerField
      FieldName = 'IDPLANO'
    end
    object mtNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtTIPO: TStringField
      FieldName = 'TIPO'
      Size = 1
    end
    object mtCODIGO2: TStringField
      FieldKind = fkCalculated
      FieldName = 'CODIGO2'
      Calculated = True
    end
    object mtNOME2: TStringField
      FieldKind = fkCalculated
      FieldName = 'NOME2'
      Size = 50
      Calculated = True
    end
  end
end
