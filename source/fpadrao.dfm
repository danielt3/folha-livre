inherited FrmPadrao: TFrmPadrao
  Left = -4
  Top = -4
  HorzScrollBar.Range = 0
  BorderIcons = [biSystemMenu, biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Eventos Padr'#245'es'
  ClientHeight = 712
  ClientWidth = 1024
  FormStyle = fsMDIChild
  OldCreateOrder = True
  OnActivate = FormResize
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Width = 0
    Height = 712
    Visible = False
    inherited lblSeparador: TLabel
      Width = 0
    end
    inherited lblPrograma: TPanel
      Width = 0
      Caption = 'Tabelas'
    end
    inherited pnlPesquisa: TPanel
      Top = 612
      Width = 0
      inherited lblPesquisa: TLabel
        Width = 0
      end
    end
  end
  inherited PnlClaro: TPanel
    Left = 0
    Width = 1024
    Height = 712
    inherited PnlControle: TPanel
      Top = 672
      Width = 1024
      TabOrder = 2
    end
    inherited PnlTitulo: TPanel
      Width = 1024
      TabOrder = 1
      inherited RxTitulo: TLabel
        Width = 174
        Caption = ' '#183' Eventos Padr'#245'es'
      end
      inherited PnlFechar: TPanel
        Left = 984
      end
    end
    object dbgRegistro: TDBGrid
      Tag = 1
      Left = 0
      Top = 90
      Width = 1024
      Height = 389
      Align = alClient
      BorderStyle = bsNone
      DataSource = dtsRegistro
      Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      ParentColor = True
      TabOrder = 3
      TitleFont.Charset = ANSI_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Arial'
      TitleFont.Style = []
      OnDrawColumnCell = dbgRegistroDrawColumnCell
      OnTitleClick = dbgRegistroTitleClick
      Columns = <
        item
          Expanded = False
          FieldName = 'SEQUENCIA'
          Title.Alignment = taRightJustify
          Title.Caption = 'Sequ'#234'ncia'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'IDEVENTO'
          Title.Alignment = taRightJustify
          Title.Caption = 'ID Evento'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'EVENTO'
          Title.Caption = 'Descri'#231#227'o do Evento'
          Width = 285
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'INFORMADO'
          Title.Alignment = taRightJustify
          Title.Caption = 'V. Informado'
          Width = 80
          Visible = True
        end>
    end
    object Panel1: TPanel
      Left = 0
      Top = 30
      Width = 1024
      Height = 60
      Align = alTop
      BevelOuter = bvNone
      Color = 8101828
      TabOrder = 0
      object lbGE: TLabel
        Left = 9
        Top = 9
        Width = 26
        Height = 14
        Caption = 'ID GE'
        FocusControl = dbGE
      end
      object lbGE2: TLabel
        Left = 68
        Top = 9
        Width = 157
        Height = 14
        Caption = 'Descri'#231#227'o do Grupo de Empresa'
        FocusControl = dbGE2
      end
      object lbGP: TLabel
        Left = 267
        Top = 9
        Width = 26
        Height = 14
        Caption = 'ID GP'
        FocusControl = dbGP
      end
      object lbGP2: TLabel
        Left = 326
        Top = 9
        Width = 168
        Height = 14
        Caption = 'Descri'#231#227'o do Grupo de Pagamento'
        FocusControl = dbGP2
      end
      object lbFolha: TLabel
        Left = 547
        Top = 9
        Width = 64
        Height = 14
        Caption = 'Tipo de Folha'
        FocusControl = dbFolha
      end
      object dbGE: TAKDBEdit
        Left = 9
        Top = 26
        Width = 32
        Height = 22
        CharCase = ecUpperCase
        DataField = 'IDGE'
        DataSource = dsGP
        ParentColor = True
        ReadOnly = True
        TabOrder = 0
        ButtonSpacing = 3
        OnButtonClick = dbGEButtonClick
      end
      object dbGE2: TDBEdit
        Left = 68
        Top = 26
        Width = 194
        Height = 22
        TabStop = False
        DataField = 'GE'
        DataSource = dsGP
        ParentColor = True
        ReadOnly = True
        TabOrder = 1
      end
      object dbGP: TAKDBEdit
        Left = 267
        Top = 26
        Width = 32
        Height = 22
        CharCase = ecUpperCase
        DataField = 'IDGP'
        DataSource = dsGP
        ParentColor = True
        ReadOnly = True
        TabOrder = 2
        ButtonSpacing = 3
        OnButtonClick = dbGEButtonClick
      end
      object dbGP2: TDBEdit
        Left = 326
        Top = 26
        Width = 216
        Height = 22
        TabStop = False
        DataField = 'GP'
        DataSource = dsGP
        ParentColor = True
        ReadOnly = True
        TabOrder = 3
      end
      object dbFolha: TAKDBEdit
        Left = 547
        Top = 26
        Width = 32
        Height = 22
        CharCase = ecUpperCase
        DataField = 'IDFOLHA_TIPO'
        DataSource = dsGP
        ParentColor = True
        ReadOnly = True
        TabOrder = 4
        ButtonSpacing = 3
        OnButtonClick = dbFolhaButtonClick
      end
      object dbFolha2: TDBEdit
        Left = 608
        Top = 26
        Width = 97
        Height = 22
        TabStop = False
        DataField = 'FOLHA_TIPO'
        DataSource = dsGP
        ParentColor = True
        ReadOnly = True
        TabOrder = 5
      end
    end
    object PageControl1: TPageControl
      Left = 0
      Top = 479
      Width = 1024
      Height = 193
      ActivePage = TabEvento
      Align = alBottom
      Style = tsButtons
      TabOrder = 4
      OnChange = PageControl1Change
      object TabEvento: TTabSheet
        Caption = 'Evento'
        object Panel: TPanel
          Left = 0
          Top = 0
          Width = 1016
          Height = 161
          Align = alClient
          ParentColor = True
          TabOrder = 0
          object lbEvento: TLabel
            Left = 9
            Top = 9
            Width = 51
            Height = 14
            Caption = 'Evento [...]'
          end
          object lbEvento2: TLabel
            Left = 68
            Top = 9
            Width = 100
            Height = 14
            Caption = 'Descri'#231#227'o do Evento'
            Enabled = False
            FocusControl = dbEvento2
          end
          object lbInformado: TLabel
            Left = 353
            Top = 9
            Width = 77
            Height = 14
            Caption = 'Valor Informado'
          end
          object lbSequencia: TLabel
            Left = 448
            Top = 9
            Width = 51
            Height = 14
            Caption = 'Sequ'#234'ncia'
            FocusControl = dbSequencia
          end
          object dbEvento2: TDBEdit
            Left = 68
            Top = 26
            Width = 280
            Height = 22
            DataField = 'EVENTO'
            DataSource = dtsRegistro
            Enabled = False
            ParentColor = True
            TabOrder = 1
          end
          object dbCompetencias: TGroupBox
            Left = 10
            Top = 56
            Width = 530
            Height = 90
            Caption = 'Compet'#234'ncias'
            TabOrder = 4
            object dbJaneiro: TDBCheckBox
              Tag = 1
              Left = 8
              Top = 16
              Width = 75
              Height = 19
              Caption = '&Janeiro'
              DataField = 'JANEIRO_X'
              DataSource = dtsRegistro
              TabOrder = 0
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbFevereiro: TDBCheckBox
              Tag = 2
              Left = 8
              Top = 38
              Width = 75
              Height = 18
              Caption = 'Fevereiro'
              DataField = 'FEVEREIRO_X'
              DataSource = dtsRegistro
              TabOrder = 1
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbMarco: TDBCheckBox
              Tag = 3
              Left = 8
              Top = 60
              Width = 75
              Height = 19
              Caption = '&Mar'#231'o'
              DataField = 'MARCO_X'
              DataSource = dtsRegistro
              TabOrder = 2
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbAbril: TDBCheckBox
              Tag = 4
              Left = 88
              Top = 16
              Width = 75
              Height = 18
              Caption = '&Abril'
              DataField = 'ABRIL_X'
              DataSource = dtsRegistro
              TabOrder = 3
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbMaio: TDBCheckBox
              Tag = 5
              Left = 88
              Top = 38
              Width = 76
              Height = 19
              Caption = 'Maio'
              DataField = 'MAIO_X'
              DataSource = dtsRegistro
              TabOrder = 4
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbJunho: TDBCheckBox
              Tag = 6
              Left = 88
              Top = 60
              Width = 76
              Height = 18
              Caption = '&Junho'
              DataField = 'JUNHO_X'
              DataSource = dtsRegistro
              TabOrder = 5
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbJulho: TDBCheckBox
              Tag = 7
              Left = 168
              Top = 16
              Width = 76
              Height = 19
              Caption = 'Julho'
              DataField = 'JULHO_X'
              DataSource = dtsRegistro
              TabOrder = 6
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbAgosto: TDBCheckBox
              Tag = 8
              Left = 168
              Top = 38
              Width = 76
              Height = 18
              Caption = 'Agosto'
              DataField = 'AGOSTO_X'
              DataSource = dtsRegistro
              TabOrder = 7
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbSetembro: TDBCheckBox
              Tag = 9
              Left = 168
              Top = 60
              Width = 75
              Height = 19
              Caption = '&Setembro'
              DataField = 'SETEMBRO_X'
              DataSource = dtsRegistro
              TabOrder = 8
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbOutubro: TDBCheckBox
              Tag = 10
              Left = 248
              Top = 16
              Width = 75
              Height = 18
              Caption = '&Outubro'
              DataField = 'OUTUBRO_X'
              DataSource = dtsRegistro
              TabOrder = 9
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbNovembro: TDBCheckBox
              Tag = 11
              Left = 248
              Top = 38
              Width = 75
              Height = 19
              Caption = '&Novembro'
              DataField = 'NOVEMBRO_X'
              DataSource = dtsRegistro
              TabOrder = 10
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbDezembro: TDBCheckBox
              Tag = 12
              Left = 248
              Top = 60
              Width = 75
              Height = 18
              Caption = '&Dezembro'
              DataField = 'DEZEMBRO_X'
              DataSource = dtsRegistro
              TabOrder = 11
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object db13salario: TDBCheckBox
              Tag = 13
              Left = 328
              Top = 16
              Width = 75
              Height = 19
              Caption = '13 &Sal'#225'rio'
              DataField = 'SALARIO13_X'
              DataSource = dtsRegistro
              TabOrder = 12
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object dbMarcar: TCheckBox
              Left = 328
              Top = 60
              Width = 145
              Height = 19
              TabStop = False
              Caption = '[&Des]Marcar Todos'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -12
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 13
              OnClick = dbMarcarClick
            end
          end
          object dbInformado: TDBEdit
            Left = 353
            Top = 26
            Width = 90
            Height = 22
            DataField = 'INFORMADO'
            DataSource = dtsRegistro
            TabOrder = 2
          end
          object dbSequencia: TDBEdit
            Left = 448
            Top = 26
            Width = 90
            Height = 22
            DataField = 'SEQUENCIA'
            DataSource = dtsRegistro
            TabOrder = 3
          end
          object dbEvento: TDBEdit
            Left = 8
            Top = 26
            Width = 55
            Height = 22
            DataField = 'IDEVENTO'
            DataSource = dtsRegistro
            TabOrder = 0
          end
        end
      end
      object TabTipo: TTabSheet
        Caption = 'Tipo de Funcion'#225'rio'
        ImageIndex = 2
        object Label2: TLabel
          Left = 0
          Top = 0
          Width = 180
          Height = 161
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Este evento somente ser'#225' lan'#231'ado para os funcion'#225'rios que perten' +
            #231'am a algum dos tipos selecionados.'#13#10'Se nenhum tipo for selecion' +
            'ado, o tipo do funcion'#225'rio ser'#225' desconsiderado.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Label3: TLabel
          Left = 886
          Top = 0
          Width = 130
          Height = 161
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Utilize a tecla de espa'#231'o ou o duplo clique para incluir ou remo' +
            'ver as categorias.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object dbgTipo: TDBGrid
          Left = 180
          Top = 0
          Width = 706
          Height = 161
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
        end
      end
      object TabFGTS: TTabSheet
        Caption = 'Categoria de FGTS'
        ImageIndex = 1
        object Label6: TLabel
          Left = 886
          Top = 0
          Width = 130
          Height = 161
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Utilize a tecla de espa'#231'o ou o duplo clique para incluir ou remo' +
            'ver as categorias.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Label1: TLabel
          Left = 0
          Top = 0
          Width = 180
          Height = 161
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Este evento somente ser'#225' lan'#231'ado para os funcion'#225'rios que perten' +
            #231'am a alguma das categorias de FGTS selecionadas.'#13#10'Se nenhuma ca' +
            'tegoria for selecionada, a categoria do funcion'#225'rio ser'#225' descons' +
            'iderada.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object dbgFGTS: TDBGrid
          Left = 180
          Top = 0
          Width = 706
          Height = 161
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          OnDblClick = dbgFGTSDblClick
        end
      end
      object TabSituacao: TTabSheet
        Caption = 'Situa'#231#227'o do Funcion'#225'rio'
        ImageIndex = 3
        object Label4: TLabel
          Left = 0
          Top = 0
          Width = 180
          Height = 161
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Este evento somente ser'#225' lan'#231'ado para os funcion'#225'rios que perten' +
            #231'am a alguma das situa'#231#245'es selecionadas.'#13#10'Se nenhuma situa'#231#227'o fo' +
            'r selecionada, a situa'#231#227'o do funcion'#225'rio ser'#225' desconsiderada.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Label5: TLabel
          Left = 886
          Top = 0
          Width = 130
          Height = 161
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Utilize a tecla de espa'#231'o ou o duplo clique para incluir ou remo' +
            'ver as categorias.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object dbgSituacao: TDBGrid
          Left = 180
          Top = 0
          Width = 706
          Height = 161
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          OnDblClick = dbgFGTSDblClick
        end
      end
      object TabVinculo: TTabSheet
        Caption = 'V'#237'nculos Empregat'#237'cio'
        ImageIndex = 4
        object Label7: TLabel
          Left = 0
          Top = 0
          Width = 180
          Height = 161
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Este evento somente ser'#225' lan'#231'ado para os funcion'#225'rios que perten' +
            #231'am a algum dos v'#237'nculos selecionados.'#13#10'Se nenhum v'#237'nculo for se' +
            'lecionado, o v'#237'nvulo do funcion'#225'rio ser'#225' desconsiderado.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Label8: TLabel
          Left = 886
          Top = 0
          Width = 130
          Height = 161
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Utilize a tecla de espa'#231'o ou o duplo clique para incluir ou remo' +
            'ver as categorias.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object dbgVinculo: TDBGrid
          Left = 180
          Top = 0
          Width = 706
          Height = 161
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          OnDblClick = dbgFGTSDblClick
        end
      end
      object TabSalario: TTabSheet
        Caption = 'Tipos de Sal'#225'rio'
        ImageIndex = 5
        object Label10: TLabel
          Left = 886
          Top = 0
          Width = 130
          Height = 161
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Utilize a tecla de espa'#231'o ou o duplo clique para incluir ou remo' +
            'ver as categorias.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object Label9: TLabel
          Left = 0
          Top = 0
          Width = 180
          Height = 161
          Align = alLeft
          Alignment = taCenter
          AutoSize = False
          Caption = 
            'Este evento somente ser'#225' lan'#231'ado para os funcion'#225'rios que perten' +
            #231'am a algum dos tipos de sal'#225'rio selecionados.'#13#10'Se nenhum tipo d' +
            'e sal'#225'rio for selecionado, o tipo de sal'#225'rio do funcion'#225'rio ser'#225 +
            ' desconsiderado.'
          Font.Charset = ANSI_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          Layout = tlCenter
          WordWrap = True
        end
        object dbgSalario: TDBGrid
          Left = 180
          Top = 0
          Width = 706
          Height = 161
          Align = alClient
          TabOrder = 0
          TitleFont.Charset = ANSI_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Arial'
          TitleFont.Style = []
          OnDblClick = dbgFGTSDblClick
        end
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 32
    Top = 136
  end
  inherited mtRegistro: TClientDataSet
    BeforeInsert = mtRegistroBeforeInsert
    AfterDelete = mtRegistroAfterPost
    AfterScroll = mtRegistroAfterScroll
    Left = 32
    Top = 200
    object mtRegistroIDGP: TIntegerField
      FieldName = 'IDGP'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDPADRAO: TIntegerField
      FieldName = 'IDPADRAO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDFOLHA_TIPO: TStringField
      FieldName = 'IDFOLHA_TIPO'
      Size = 1
    end
    object mtRegistroIDEVENTO: TIntegerField
      FieldName = 'IDEVENTO'
    end
    object mtRegistroINFORMADO: TCurrencyField
      FieldName = 'INFORMADO'
      DisplayFormat = ',0.00'
    end
    object mtRegistroEVENTO: TStringField
      FieldName = 'EVENTO'
      ProviderFlags = [pfHidden]
      Size = 50
    end
    object mtRegistroJANEIRO_X: TSmallintField
      FieldName = 'JANEIRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroFEVEREIRO_X: TSmallintField
      FieldName = 'FEVEREIRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroMARCO_X: TSmallintField
      FieldName = 'MARCO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroABRIL_X: TSmallintField
      FieldName = 'ABRIL_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroMAIO_X: TSmallintField
      FieldName = 'MAIO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroJUNHO_X: TSmallintField
      FieldName = 'JUNHO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroJULHO_X: TSmallintField
      FieldName = 'JULHO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroAGOSTO_X: TSmallintField
      FieldName = 'AGOSTO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroSETEMBRO_X: TSmallintField
      FieldName = 'SETEMBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroOUTUBRO_X: TSmallintField
      FieldName = 'OUTUBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroNOVEMBRO_X: TSmallintField
      FieldName = 'NOVEMBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroDEZEMBRO_X: TSmallintField
      FieldName = 'DEZEMBRO_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroSALARIO13_X: TSmallintField
      FieldName = 'SALARIO13_X'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroTIPO_EVENTO: TStringField
      FieldName = 'TIPO_EVENTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfHidden]
      Size = 1
    end
    object mtRegistroATIVO_X: TSmallintField
      FieldName = 'ATIVO_X'
      ProviderFlags = [pfInUpdate, pfInWhere, pfHidden]
    end
    object mtRegistroSEQUENCIA: TSmallintField
      FieldName = 'SEQUENCIA'
    end
  end
  object cdGP: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 104
    Top = 216
    object cdGPIDGE: TIntegerField
      FieldName = 'IDGE'
    end
    object cdGPIDGP: TIntegerField
      FieldName = 'IDGP'
    end
    object cdGPGE: TStringField
      FieldName = 'GE'
      Size = 30
    end
    object cdGPGP: TStringField
      FieldName = 'GP'
      Size = 30
    end
    object cdGPIDFOLHA_TIPO: TStringField
      FieldName = 'IDFOLHA_TIPO'
      Size = 1
    end
    object cdGPFOLHA_TIPO: TStringField
      FieldName = 'FOLHA_TIPO'
      Size = 30
    end
    object cdGPSEQUENCIA_X: TSmallintField
      FieldName = 'SEQUENCIA_X'
    end
  end
  object dsGP: TDataSource
    DataSet = cdGP
    Left = 104
    Top = 136
  end
  object cdFolhaTipo: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 448
    Top = 176
    object cdFolhaTipoIDFOLHA_TIPO: TStringField
      FieldName = 'IDFOLHA_TIPO'
      Size = 1
    end
    object cdFolhaTipoNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
end
