inherited frmsysempresa: Tfrmsysempresa
  Left = 88
  Top = 11
  HorzScrollBar.Range = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Configura'#231#227'o da Empresa Usu'#225'ria'
  ClientHeight = 456
  ClientWidth = 691
  OldCreateOrder = True
  Visible = False
  WindowState = wsNormal
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Width = 0
    Height = 456
    Visible = False
    inherited lblSeparador: TLabel
      Width = 0
    end
    inherited lblPrograma: TPanel
      Width = 0
      Caption = 'Empresa'
    end
    inherited pnlPesquisa: TPanel
      Top = 356
      Width = 0
      inherited lblPesquisa: TLabel
        Width = 0
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 0
    Width = 691
    Height = 456
    inherited PnlControle: TPanel
      Top = 416
      Width = 691
    end
    inherited PnlTitulo: TPanel
      Width = 691
      inherited RxTitulo: TLabel
        Width = 270
        Caption = ' '#183' Listagem de Configura'#231#245'es'
      end
      inherited PnlFechar: TPanel
        Left = 651
      end
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 30
      Width = 691
      Height = 284
      Align = alClient
      HotTrack = True
      MultiLine = True
      Style = tsButtons
      TabOrder = 2
    end
    object dbgRegistro: TDBGrid
      Tag = 1
      Left = 0
      Top = 30
      Width = 691
      Height = 284
      Align = alClient
      BorderStyle = bsNone
      DataSource = dtsRegistro
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentColor = True
      ParentFont = False
      TabOrder = 3
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = [fsBold]
      OnDrawColumnCell = dbgRegistroDrawColumnCell
      OnTitleClick = dbgRegistroTitleClick
      Columns = <
        item
          Expanded = False
          FieldName = 'CHAVE'
          Title.Caption = 'Chave'
          Width = 230
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'VALOR'
          Title.Caption = 'Valor (max. 100 caracteres)'
          Width = 380
          Visible = True
        end>
    end
    object Panel: TPanel
      Left = 0
      Top = 314
      Width = 691
      Height = 102
      Align = alBottom
      BevelOuter = bvNone
      ParentColor = True
      TabOrder = 4
      OnExit = PanelExit
      object lbChave: TLabel
        Left = 9
        Top = 9
        Width = 110
        Height = 14
        Caption = 'Chave (30 caracteres)'
        FocusControl = dbChave
      end
      object lbValor: TLabel
        Left = 9
        Top = 52
        Width = 111
        Height = 14
        Caption = 'Valor (100 caracteres)'
        FocusControl = dbValor
      end
      object dbChave: TDBEdit
        Left = 9
        Top = 25
        Width = 538
        Height = 22
        CharCase = ecUpperCase
        DataField = 'CHAVE'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbValor: TDBEdit
        Left = 9
        Top = 68
        Width = 538
        Height = 22
        DataField = 'VALOR'
        DataSource = dtsRegistro
        TabOrder = 1
      end
      object dbAtivo: TDBCheckBox
        Left = 560
        Top = 69
        Width = 104
        Height = 18
        Caption = 'Ativo'
        DataField = 'ATIVO'
        DataSource = dtsRegistro
        TabOrder = 2
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 48
    Top = 200
  end
  inherited mtRegistro: TClientDataSet
    BeforeInsert = mtRegistroBeforeInsert
    AfterPost = mtRegistroAfterCancel
    Left = 82
    Top = 144
    object mtRegistroCHAVE: TStringField
      FieldName = 'CHAVE'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Size = 30
    end
    object mtRegistroVALOR: TStringField
      FieldName = 'VALOR'
      Size = 100
    end
    object mtRegistroATIVO: TSmallintField
      FieldName = 'ATIVO'
    end
  end
end
