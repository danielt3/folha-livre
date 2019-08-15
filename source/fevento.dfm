inherited FrmEvento: TFrmEvento
  Left = 6
  Caption = 'Eventos de Folha'
  ClientHeight = 577
  ClientWidth = 834
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Height = 577
    inherited lblPrograma: TPanel
      Caption = 'Eventos'
    end
    inherited pnlPesquisa: TPanel
      Top = 477
    end
  end
  inherited PnlClaro: TPanel
    Width = 672
    Height = 577
    inherited PnlControle: TPanel
      Top = 537
      Width = 672
    end
    inherited PnlTitulo: TPanel
      Width = 672
      inherited PnlFechar: TPanel
        Left = 543
      end
    end
    inherited PageControl1: TPageControl
      Width = 672
      Height = 507
      ActivePage = TabDetalhe
      inherited TabListagem: TTabSheet
        Caption = 'Lista de Eventos'
        inherited dbgRegistro: TDBGrid
          Width = 664
          Height = 475
          Columns = <
            item
              Expanded = False
              FieldName = 'IDEVENTO'
              Title.Caption = 'ID'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome do Evento'
              Width = 375
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TIPO_EVENTO'
              Title.Caption = 'Tp'
              Width = 20
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TIPO_CALCULO'
              Title.Caption = 'Calc.'
              Width = 40
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'VALOR_HORA'
              Title.Caption = 'V/H'
              Width = 40
              Visible = True
            end>
        end
      end
      inherited TabDetalhe: TTabSheet
        Caption = 'Detalhes do Evento'
        object pnlDados: TPanel
          Left = 0
          Top = 0
          Width = 664
          Height = 59
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lbCodigo: TLabel
            Left = 9
            Top = 9
            Width = 33
            Height = 14
            Caption = 'C'#243'digo'
            FocusControl = dbCodigo
          end
          object lbNome: TLabel
            Left = 68
            Top = 9
            Width = 49
            Height = 14
            Caption = 'Descri'#231#227'o'
            FocusControl = dbNome
          end
          object dbCodigo: TDBEdit
            Left = 9
            Top = 26
            Width = 53
            Height = 20
            AutoSize = False
            DataField = 'IDEVENTO'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbNome: TDBEdit
            Left = 68
            Top = 26
            Width = 431
            Height = 20
            AutoSize = False
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dtsRegistro
            TabOrder = 1
          end
        end
        object PageControl2: TPageControl
          Left = 0
          Top = 59
          Width = 664
          Height = 416
          ActivePage = TabGeral
          Align = alClient
          HotTrack = True
          MultiLine = True
          Style = tsButtons
          TabOrder = 1
          OnChange = PageControl2Change
          object TabGeral: TTabSheet
            Caption = 'Geral'
            ImageIndex = 2
            object pnlGeral: TPanel
              Left = 0
              Top = 0
              Width = 656
              Height = 384
              Align = alClient
              BevelInner = bvRaised
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object dbHoraValor: TDBRadioGroup
                Left = 9
                Top = 108
                Width = 107
                Height = 94
                Caption = 'Modo de Entrada'
                DataField = 'VALOR_HORA'
                DataSource = dtsRegistro
                Items.Strings = (
                  'Dia'
                  'Hora'
                  'Valor')
                TabOrder = 1
                Values.Strings = (
                  'D'
                  'H'
                  'V')
              end
              object dbTipo: TDBRadioGroup
                Left = 9
                Top = 9
                Width = 107
                Height = 94
                Caption = 'Tipo do Evento'
                DataField = 'TIPO_EVENTO'
                DataSource = dtsRegistro
                Items.Strings = (
                  'Base'
                  'Desconto'
                  'Provento')
                TabOrder = 0
                Values.Strings = (
                  'B'
                  'D'
                  'P')
              end
              object dbCalculo: TDBRadioGroup
                Left = 122
                Top = 9
                Width = 129
                Height = 193
                Caption = 'Tipo de C'#225'lculo'
                DataField = 'TIPO_CALCULO'
                DataSource = dtsRegistro
                Items.Strings = (
                  'Contra-Partida'
                  'Dia Trabalhado'
                  'F'#243'rmula'
                  'Hora Trabalhada'
                  'Valor Informado')
                TabOrder = 2
                Values.Strings = (
                  'C'
                  'D'
                  'F'
                  'H'
                  'I')
              end
              object gpOutros: TGroupBox
                Left = 394
                Top = 81
                Width = 194
                Height = 70
                Caption = 'Outras Informa'#231#245'es'
                TabOrder = 5
                object lbMultiplicador: TLabel
                  Left = 9
                  Top = 17
                  Width = 59
                  Height = 14
                  Caption = 'Multiplicador'
                  FocusControl = dbMultiplicador
                end
                object Label2: TLabel
                  Left = 89
                  Top = 17
                  Width = 69
                  Height = 14
                  Caption = 'Contra-Partida'
                  FocusControl = dbContraPartida
                end
                object dbMultiplicador: TDBEdit
                  Left = 9
                  Top = 34
                  Width = 75
                  Height = 21
                  AutoSize = False
                  DataField = 'MULTIPLICADOR'
                  DataSource = dtsRegistro
                  TabOrder = 0
                end
                object dbContraPartida: TDBEdit
                  Left = 89
                  Top = 34
                  Width = 76
                  Height = 21
                  AutoSize = False
                  DataField = 'CONTRA_PARTIDA'
                  DataSource = dtsRegistro
                  TabOrder = 1
                end
              end
              object gpIntervalo: TGroupBox
                Left = 394
                Top = 9
                Width = 194
                Height = 70
                Caption = 'Intervalo Permitido'
                TabOrder = 4
                object lbMinimo: TLabel
                  Left = 9
                  Top = 17
                  Width = 61
                  Height = 14
                  Caption = 'Valor M'#237'nimo'
                  FocusControl = dbMinimo
                end
                object Label1: TLabel
                  Left = 89
                  Top = 16
                  Width = 65
                  Height = 14
                  Caption = 'Valor M'#225'ximo'
                  FocusControl = dbMaximo
                end
                object dbMinimo: TDBEdit
                  Left = 9
                  Top = 34
                  Width = 75
                  Height = 21
                  AutoSize = False
                  DataField = 'VALOR_MINIMO'
                  DataSource = dtsRegistro
                  TabOrder = 0
                end
                object dbMaximo: TDBEdit
                  Left = 89
                  Top = 34
                  Width = 76
                  Height = 21
                  AutoSize = False
                  DataField = 'VALOR_MAXIMO'
                  DataSource = dtsRegistro
                  TabOrder = 1
                end
              end
              object dbSalario: TDBRadioGroup
                Left = 257
                Top = 9
                Width = 130
                Height = 193
                Caption = 'Tipo de Sal'#225'rio'
                DataField = 'TIPO_SALARIO'
                DataSource = dtsRegistro
                Items.Strings = (
                  'Sal'#225'rio &Fixo'
                  'Sal'#225'rio &Vari'#225'vel'
                  '&Produ'#231#227'o/Pe'#231'a'
                  '&Indefinido')
                TabOrder = 3
                Values.Strings = (
                  'F'
                  'V'
                  'P'
                  'I')
              end
            end
          end
          object TabFormula: TTabSheet
            Caption = 'F'#243'rmula'
            ImageIndex = 2
            object gpFormula: TGroupBox
              Left = 0
              Top = 0
              Width = 656
              Height = 148
              Align = alTop
              Caption = ' Configura'#231#227'o de F'#243'rmulas '
              TabOrder = 0
              object lbFormula: TLabel
                Left = 9
                Top = 31
                Width = 75
                Height = 14
                Caption = 'F'#243'rmula Padr'#227'o'
                FocusControl = dbFormula
              end
              object Label3: TLabel
                Left = 9
                Top = 94
                Width = 67
                Height = 14
                Caption = 'F'#243'rmula Local'
                FocusControl = dbFormulaLocal
              end
              object Label4: TLabel
                Left = 103
                Top = 120
                Width = 327
                Height = 13
                Caption = 
                  'A f'#243'rmula local ser'#225' avaliada somente se a f'#243'rmula padr'#227'o for 0 ' +
                  '(zero)'
                FocusControl = dbFormulaLocal
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object Label5: TLabel
                Left = 103
                Top = 59
                Width = 349
                Height = 13
                Caption = 
                  'A f'#243'rmula padr'#227'o ser'#225' avaliada somente se o tipo de c'#225'lculo for ' +
                  '"F'#243'rmula"'
                FocusControl = dbFormulaLocal
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clRed
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
              end
              object dbFormula: TAKDBEdit
                Left = 103
                Top = 28
                Width = 60
                Height = 22
                CharCase = ecUpperCase
                DataField = 'IDFORMULA'
                DataSource = dtsRegistro
                TabOrder = 0
                ButtonSpacing = 3
                OnButtonClick = dbFormulaButtonClick
              end
              object dbFormula2: TDBEdit
                Left = 195
                Top = 28
                Width = 323
                Height = 23
                TabStop = False
                AutoSize = False
                CharCase = ecUpperCase
                DataField = 'FORMULA'
                DataSource = dtsRegistro
                ParentColor = True
                ReadOnly = True
                TabOrder = 1
              end
              object dbFormulaLocal: TDBEdit
                Left = 103
                Top = 90
                Width = 415
                Height = 21
                AutoSize = False
                DataField = 'FORMULA_LOCAL'
                DataSource = dtsRegistro
                TabOrder = 2
              end
              object StaticText1: TStaticText
                Left = 529
                Top = 26
                Width = 107
                Height = 108
                Alignment = taCenter
                AutoSize = False
                BevelInner = bvLowered
                BevelKind = bkSoft
                BevelOuter = bvSpace
                BorderStyle = sbsSunken
                Caption = 
                  'Uma outra maneira de personalizar o c'#225'lculo '#233' fornecer uma f'#243'rmu' +
                  'la na sequ'#234'ncia de c'#225'lculo do grupo de pagamento.'
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clBlue
                Font.Height = -12
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
              end
            end
            object gpFormulaTexto: TGroupBox
              Left = 0
              Top = 158
              Width = 656
              Height = 226
              Align = alClient
              Caption = ' Texto da F'#243'rmula Padr'#227'o (somente leitura) '
              TabOrder = 1
            end
            object Panel1: TPanel
              Left = 0
              Top = 148
              Width = 656
              Height = 10
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 2
            end
          end
          object TabIncidencia: TTabSheet
            Caption = 'Incid'#234'ncias'
            ImageIndex = 1
            object Panel2: TPanel
              Left = 0
              Top = 0
              Width = 656
              Height = 384
              Align = alClient
              BevelInner = bvRaised
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object gpIncidencia: TGroupBox
                Left = 1
                Top = 1
                Width = 654
                Height = 382
                Align = alClient
                Caption = 'Grupos de Incid'#234'ncias'
                TabOrder = 0
                object dbInc01: TDBCheckBox
                  Left = 9
                  Top = 24
                  Width = 290
                  Height = 18
                  Caption = '1. Incid'#234'ncia'
                  DataField = 'INC_01_X'
                  DataSource = dtsRegistro
                  TabOrder = 0
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc02: TDBCheckBox
                  Left = 9
                  Top = 50
                  Width = 290
                  Height = 18
                  Caption = '2. Incid'#234'ncia'
                  DataField = 'INC_02_X'
                  DataSource = dtsRegistro
                  TabOrder = 1
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc03: TDBCheckBox
                  Left = 9
                  Top = 75
                  Width = 290
                  Height = 19
                  Caption = '3. Incid'#234'ncia'
                  DataField = 'INC_03_X'
                  DataSource = dtsRegistro
                  TabOrder = 2
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc04: TDBCheckBox
                  Left = 9
                  Top = 101
                  Width = 290
                  Height = 19
                  Caption = '4. Incid'#234'ncia'
                  DataField = 'INC_04_X'
                  DataSource = dtsRegistro
                  TabOrder = 3
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc05: TDBCheckBox
                  Left = 9
                  Top = 127
                  Width = 290
                  Height = 18
                  Caption = '5. Incid'#234'ncia'
                  DataField = 'INC_05_X'
                  DataSource = dtsRegistro
                  TabOrder = 4
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc06: TDBCheckBox
                  Left = 9
                  Top = 153
                  Width = 290
                  Height = 18
                  Caption = '6. Incid'#234'ncia'
                  DataField = 'INC_06_X'
                  DataSource = dtsRegistro
                  TabOrder = 5
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc07: TDBCheckBox
                  Left = 9
                  Top = 179
                  Width = 290
                  Height = 18
                  Caption = '7. Incid'#234'ncia'
                  DataField = 'INC_07_X'
                  DataSource = dtsRegistro
                  TabOrder = 6
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc08: TDBCheckBox
                  Left = 9
                  Top = 205
                  Width = 290
                  Height = 18
                  Caption = '8. Incid'#234'ncia'
                  DataField = 'INC_08_X'
                  DataSource = dtsRegistro
                  TabOrder = 7
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc09: TDBCheckBox
                  Left = 9
                  Top = 230
                  Width = 290
                  Height = 19
                  Caption = '9. Incid'#234'ncia'
                  DataField = 'INC_09_X'
                  DataSource = dtsRegistro
                  TabOrder = 8
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc10: TDBCheckBox
                  Left = 9
                  Top = 256
                  Width = 290
                  Height = 19
                  Caption = '10. Incid'#234'ncia'
                  DataField = 'INC_10_X'
                  DataSource = dtsRegistro
                  TabOrder = 9
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc11: TDBCheckBox
                  Left = 334
                  Top = 24
                  Width = 291
                  Height = 18
                  Caption = '11. Incid'#234'ncia'
                  DataField = 'INC_11_X'
                  DataSource = dtsRegistro
                  TabOrder = 10
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc12: TDBCheckBox
                  Left = 334
                  Top = 50
                  Width = 291
                  Height = 18
                  Caption = '12. Incid'#234'ncia'
                  DataField = 'INC_12_X'
                  DataSource = dtsRegistro
                  TabOrder = 11
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc13: TDBCheckBox
                  Left = 334
                  Top = 75
                  Width = 291
                  Height = 19
                  Caption = '13. Incid'#234'ncia'
                  DataField = 'INC_13_X'
                  DataSource = dtsRegistro
                  TabOrder = 12
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc14: TDBCheckBox
                  Left = 334
                  Top = 101
                  Width = 291
                  Height = 19
                  Caption = '14. Incid'#234'ncia'
                  DataField = 'INC_14_X'
                  DataSource = dtsRegistro
                  TabOrder = 13
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc15: TDBCheckBox
                  Left = 334
                  Top = 127
                  Width = 291
                  Height = 18
                  Caption = '15. Incid'#234'ncia'
                  DataField = 'INC_15_X'
                  DataSource = dtsRegistro
                  TabOrder = 14
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc16: TDBCheckBox
                  Left = 334
                  Top = 153
                  Width = 291
                  Height = 18
                  Caption = '16. Incid'#234'ncia'
                  DataField = 'INC_16_X'
                  DataSource = dtsRegistro
                  TabOrder = 15
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc17: TDBCheckBox
                  Left = 334
                  Top = 179
                  Width = 291
                  Height = 18
                  Caption = '17. Incid'#234'ncia'
                  DataField = 'INC_17_X'
                  DataSource = dtsRegistro
                  TabOrder = 16
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc18: TDBCheckBox
                  Left = 334
                  Top = 205
                  Width = 291
                  Height = 18
                  Caption = '18. Incid'#234'ncia'
                  DataField = 'INC_18_X'
                  DataSource = dtsRegistro
                  TabOrder = 17
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc19: TDBCheckBox
                  Left = 334
                  Top = 230
                  Width = 291
                  Height = 19
                  Caption = '19. Incid'#234'ncia'
                  DataField = 'INC_19_X'
                  DataSource = dtsRegistro
                  TabOrder = 18
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
                object dbInc20: TDBCheckBox
                  Left = 334
                  Top = 256
                  Width = 291
                  Height = 19
                  Caption = '20. Incid'#234'ncia'
                  DataField = 'INC_20_X'
                  DataSource = dtsRegistro
                  TabOrder = 19
                  ValueChecked = '1'
                  ValueUnchecked = '0'
                end
              end
            end
          end
        end
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 40
    Top = 312
  end
  inherited mtRegistro: TClientDataSet
    Left = 42
    Top = 368
    object mtRegistroIDEVENTO: TIntegerField
      FieldName = 'IDEVENTO'
      Origin = 'F_EVENTO.IDEVENTO'
      ProviderFlags = [pfInUpdate, pfInKey]
      Required = True
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtRegistroTIPO_EVENTO: TStringField
      FieldName = 'TIPO_EVENTO'
      Size = 1
    end
    object mtRegistroTIPO_CALCULO: TStringField
      FieldName = 'TIPO_CALCULO'
      Size = 1
    end
    object mtRegistroMULTIPLICADOR: TCurrencyField
      FieldName = 'MULTIPLICADOR'
      DisplayFormat = ',0.00'
    end
    object mtRegistroCONTRA_PARTIDA: TIntegerField
      FieldName = 'CONTRA_PARTIDA'
      Origin = 'F_EVENTO.CONTRA_PARTIDA'
      Required = True
    end
    object mtRegistroPROPORCIONAL_X: TSmallintField
      FieldName = 'PROPORCIONAL_X'
      Origin = 'F_EVENTO.PROPORCIONAL_X'
      Required = True
    end
    object mtRegistroATIVO_X: TSmallintField
      FieldName = 'ATIVO_X'
      Origin = 'F_EVENTO.ATIVO_X'
      Required = True
    end
    object mtRegistroVALOR_HORA: TStringField
      FieldName = 'VALOR_HORA'
      Size = 1
    end
    object mtRegistroINC_01_X: TSmallintField
      FieldName = 'INC_01_X'
    end
    object mtRegistroINC_02_X: TSmallintField
      FieldName = 'INC_02_X'
    end
    object mtRegistroINC_03_X: TSmallintField
      FieldName = 'INC_03_X'
    end
    object mtRegistroINC_04_X: TSmallintField
      FieldName = 'INC_04_X'
    end
    object mtRegistroINC_05_X: TSmallintField
      FieldName = 'INC_05_X'
    end
    object mtRegistroINC_06_X: TSmallintField
      FieldName = 'INC_06_X'
    end
    object mtRegistroINC_07_X: TSmallintField
      FieldName = 'INC_07_X'
    end
    object mtRegistroINC_08_X: TSmallintField
      FieldName = 'INC_08_X'
    end
    object mtRegistroINC_09_X: TSmallintField
      FieldName = 'INC_09_X'
    end
    object mtRegistroINC_10_X: TSmallintField
      FieldName = 'INC_10_X'
    end
    object mtRegistroINC_11_X: TSmallintField
      FieldName = 'INC_11_X'
    end
    object mtRegistroINC_12_X: TSmallintField
      FieldName = 'INC_12_X'
    end
    object mtRegistroINC_13_X: TSmallintField
      FieldName = 'INC_13_X'
    end
    object mtRegistroINC_14_X: TSmallintField
      FieldName = 'INC_14_X'
    end
    object mtRegistroINC_15_X: TSmallintField
      FieldName = 'INC_15_X'
    end
    object mtRegistroINC_16_X: TSmallintField
      FieldName = 'INC_16_X'
    end
    object mtRegistroINC_17_X: TSmallintField
      FieldName = 'INC_17_X'
    end
    object mtRegistroINC_18_X: TSmallintField
      FieldName = 'INC_18_X'
    end
    object mtRegistroINC_19_X: TSmallintField
      FieldName = 'INC_19_X'
    end
    object mtRegistroINC_20_X: TSmallintField
      FieldName = 'INC_20_X'
    end
    object mtRegistroVALOR_MINIMO: TCurrencyField
      FieldName = 'VALOR_MINIMO'
      DisplayFormat = ',0.00'
    end
    object mtRegistroVALOR_MAXIMO: TCurrencyField
      FieldName = 'VALOR_MAXIMO'
      DisplayFormat = ',0.00'
    end
    object mtRegistroIDFORMULA: TIntegerField
      FieldName = 'IDFORMULA'
    end
    object mtRegistroASSUME_X: TSmallintField
      FieldName = 'ASSUME_X'
    end
    object mtRegistroFORMULA: TStringField
      FieldName = 'FORMULA'
      ProviderFlags = [pfHidden]
      Size = 30
    end
    object mtRegistroFORMULA_LOCAL: TStringField
      FieldName = 'FORMULA_LOCAL'
      Size = 50
    end
    object mtRegistroTOTAL_LOTACAO_X: TSmallintField
      FieldName = 'TOTAL_LOTACAO_X'
    end
    object mtRegistroCONTRA_CHEQUE_X: TSmallintField
      FieldName = 'CONTRA_CHEQUE_X'
    end
    object mtRegistroCOMPLEMENTAR: TSmallintField
      FieldName = 'COMPLEMENTAR'
    end
    object mtRegistroTIPO_SALARIO: TStringField
      FieldName = 'TIPO_SALARIO'
      Size = 1
    end
    object mtRegistroFORMULA_SOURCE: TStringField
      FieldName = 'FORMULA_SOURCE'
      ProviderFlags = [pfHidden]
      Size = 500
    end
  end
  inherited mtListagem: TClientDataSet
    StoreDefs = True
    Left = 34
    Top = 200
    object cdListaIDEVENTO: TIntegerField
      FieldName = 'IDEVENTO'
    end
    object cdListaNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object cdListaTIPO_EVENTO: TStringField
      FieldName = 'TIPO_EVENTO'
      Size = 1
    end
    object cdListaVALOR_HORA: TStringField
      FieldName = 'VALOR_HORA'
      Size = 1
    end
    object cdListaTIPO_CALCULO: TStringField
      FieldName = 'TIPO_CALCULO'
      Size = 1
    end
    object cdListaATIVO_X: TSmallintField
      FieldName = 'ATIVO_X'
    end
    object mtListagemFORMULA: TStringField
      FieldName = 'FORMULA'
      Size = 30
    end
    object mtListagemFORMULA_SOURCE: TStringField
      FieldName = 'FORMULA_SOURCE'
      Size = 500
    end
  end
  inherited dtsListagem: TDataSource
    Left = 32
    Top = 256
  end
  inherited mtPesquisa: TClientDataSet
    Left = 114
    Top = 368
  end
  inherited mtColuna: TClientDataSet
    Left = 114
    Top = 312
  end
  inherited dtsPesquisa: TDataSource
    Top = 448
  end
end
