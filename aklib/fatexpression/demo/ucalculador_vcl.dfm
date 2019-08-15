object Calculador: TCalculador
  Left = 30
  Top = 41
  Width = 760
  Height = 474
  VertScrollBar.Range = 31
  AutoScroll = False
  Caption = 'ClipperExpression Demo - VCL'
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -13
  Font.Name = 'Arial'
  Font.Pitch = fpVariable
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 16
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 752
    Height = 416
    ActivePage = TabSheet1
    Align = alClient
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Calculo'
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 489
        Height = 385
        Align = alLeft
        TabOrder = 0
      end
      object LogList: TListBox
        Left = 489
        Top = 0
        Width = 255
        Height = 385
        Hint = 'Log'
        TabStop = False
        Align = alClient
        ItemHeight = 16
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
    end
    object TabSuporte: TTabSheet
      Caption = 'DataSet e Functions'
      ImageIndex = 1
      object FuncList: TMemo
        Left = 503
        Top = 0
        Width = 241
        Height = 385
        Hint = 'Funcoes e variaveis definidas pelo usuario'
        Align = alRight
        Lines.Strings = (
          'sqr(x)=x*x'
          'sqrt(x)=x^(1/2)'
          'n=3'
          's=f:salario')
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
      end
      object dbDataSet: TDBGrid
        Left = 0
        Top = 0
        Width = 503
        Height = 385
        Align = alClient
        DataSource = DataSource1
        TabOrder = 1
        TitleFont.Charset = ANSI_CHARSET
        TitleFont.Color = clBlack
        TitleFont.Height = -13
        TitleFont.Name = 'Arial'
        TitleFont.Pitch = fpVariable
        TitleFont.Style = []
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 416
    Width = 752
    Height = 31
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 11
      Top = 5
      Width = 134
      Height = 20
      Caption = '&Calculate'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 150
      Top = 5
      Width = 145
      Height = 20
      Caption = '&Calculate all'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 300
      Top = 5
      Width = 145
      Height = 20
      Caption = 'Load File Text'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object DataSource1: TDataSource
    DataSet = ClientDataSet1
    Left = 448
    Top = 376
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 352
    Top = 368
    object ClientDataSet1CODIGO: TIntegerField
      FieldName = 'CODIGO'
    end
    object ClientDataSet1SALARIO: TCurrencyField
      FieldName = 'SALARIO'
    end
    object ClientDataSet1NOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
  object OpenCode: TOpenDialog
    Title = 'Open'
    Left = 632
    Top = 368
  end
end
