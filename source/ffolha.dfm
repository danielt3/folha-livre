inherited FrmFolha: TFrmFolha
  Caption = 'Folhas de Pagamento'
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    inherited lblPrograma: TPanel
      Caption = 'Folhas'
    end
  end
  inherited PnlClaro: TPanel
    inherited PageControl1: TPageControl
      ActivePage = TabDetalhe
      inherited TabListagem: TTabSheet
        Caption = 'Lista de Folhas de Pagamento'
      end
      inherited TabDetalhe: TTabSheet
        Caption = 'Detalhe da Folha de Pagamento'
        object pnlFolha: TPanel
          Left = 0
          Top = 0
          Width = 620
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
          object lblNome: TLabel
            Left = 79
            Top = 9
            Width = 49
            Height = 14
            Caption = 'Descri'#231#227'o'
            FocusControl = dbNome
          end
          object lbTipo: TLabel
            Left = 450
            Top = 9
            Width = 20
            Height = 14
            Caption = 'Tipo'
            FocusControl = dbTipo
            ParentShowHint = False
            ShowHint = False
          end
          object dbCodigo: TDBEdit
            Left = 9
            Top = 26
            Width = 64
            Height = 22
            DataField = 'IDFOLHA'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbNome: TDBEdit
            Left = 79
            Top = 26
            Width = 366
            Height = 22
            Hint = 'efsFrameSingle'
            CharCase = ecUpperCase
            DataField = 'DESCRICAO'
            DataSource = dtsRegistro
            TabOrder = 1
          end
          object dbTipo: TAKDBEdit
            Left = 450
            Top = 26
            Width = 54
            Height = 22
            CharCase = ecUpperCase
            DataField = 'IDFOLHA_TIPO'
            DataSource = dtsRegistro
            TabOrder = 2
            ButtonSpacing = 3
            OnButtonClick = dbTipoButtonClick
          end
          object dbTipo2: TDBEdit
            Left = 535
            Top = 26
            Width = 108
            Height = 22
            TabStop = False
            DataField = 'FOLHA_TIPO'
            DataSource = dtsRegistro
            ParentColor = True
            ReadOnly = True
            TabOrder = 3
          end
        end
        object PageControl2: TPageControl
          Left = 0
          Top = 59
          Width = 620
          Height = 353
          ActivePage = TabGeral
          Align = alClient
          HotTrack = True
          MultiLine = True
          Style = tsButtons
          TabOrder = 1
          OnChange = PageControl2Change
          object TabGeral: TTabSheet
            Caption = '&Dados Gerais'
            ImageIndex = -1
            object pnlDados: TPanel
              Left = 0
              Top = 0
              Width = 612
              Height = 59
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object Bevel2: TBevel
                Left = 0
                Top = 57
                Width = 612
                Height = 2
                Align = alBottom
                Shape = bsBottomLine
              end
              object lblNascimento: TLabel
                Left = 312
                Top = 9
                Width = 62
                Height = 14
                Caption = 'Compet'#234'ncia'
                FocusControl = dbCompetencia
              end
              object lbInicio: TLabel
                Left = 9
                Top = 9
                Width = 24
                Height = 14
                Caption = 'In'#237'cio'
                FocusControl = dbInicio
              end
              object lbFim: TLabel
                Left = 110
                Top = 9
                Width = 16
                Height = 14
                Caption = 'Fim'
                FocusControl = dbFim
              end
              object lbCredito: TLabel
                Left = 211
                Top = 9
                Width = 74
                Height = 14
                Caption = 'Data de Cr'#233'dito'
                FocusControl = dbCredito
              end
              object dbInicio: TDBEdit
                Left = 9
                Top = 26
                Width = 97
                Height = 22
                DataField = 'PERIODO_INICIO'
                DataSource = dtsRegistro
                TabOrder = 0
              end
              object dbFim: TDBEdit
                Left = 110
                Top = 26
                Width = 97
                Height = 22
                DataField = 'PERIODO_FIM'
                DataSource = dtsRegistro
                TabOrder = 1
              end
              object dbCredito: TDBEdit
                Left = 211
                Top = 26
                Width = 97
                Height = 22
                DataField = 'DATA_CREDITO'
                DataSource = dtsRegistro
                TabOrder = 2
              end
              object dbCompetencia: TDBEdit
                Left = 312
                Top = 26
                Width = 70
                Height = 22
                DataField = 'COMPETENCIA'
                DataSource = dtsRegistro
                TabOrder = 3
              end
            end
            object pnlArquivar: TPanel
              Left = 0
              Top = 59
              Width = 612
              Height = 63
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 1
              object Bevel1: TBevel
                Left = 0
                Top = 61
                Width = 612
                Height = 2
                Align = alBottom
                Shape = bsBottomLine
              end
              object lbGP: TLabel
                Left = 9
                Top = 9
                Width = 101
                Height = 14
                Caption = 'Grupo de Pagamento'
                FocusControl = dbGP
                ParentShowHint = False
                ShowHint = False
              end
              object dbComplementar: TDBCheckBox
                Left = 319
                Top = 26
                Width = 129
                Height = 18
                Caption = 'Folha Complementar'
                DataField = 'COMPLEMENTAR_X'
                DataSource = dtsRegistro
                TabOrder = 2
                ValueChecked = '1'
                ValueUnchecked = '0'
              end
              object dbArquivar: TDBCheckBox
                Left = 477
                Top = 26
                Width = 108
                Height = 18
                Caption = 'Arquivar'
                DataField = 'ARQUIVAR_X'
                DataSource = dtsRegistro
                TabOrder = 3
                ValueChecked = '1'
                ValueUnchecked = '0'
              end
              object dbGP: TAKDBEdit
                Left = 9
                Top = 26
                Width = 53
                Height = 22
                CharCase = ecUpperCase
                DataField = 'IDGP'
                DataSource = dtsRegistro
                TabOrder = 0
                ButtonSpacing = 3
                OnButtonClick = dbGPButtonClick
              end
              object dbGP2: TDBEdit
                Left = 95
                Top = 26
                Width = 215
                Height = 22
                TabStop = False
                DataField = 'GP'
                DataSource = dtsRegistro
                ParentColor = True
                ReadOnly = True
                TabOrder = 1
              end
            end
          end
          object TabObservacao: TTabSheet
            Caption = 'O&bserva'#231#227'o'
            ImageIndex = 2
            object dbObservacao: TDBMemo
              Left = 0
              Top = 0
              Width = 612
              Height = 321
              Align = alClient
              DataField = 'OBSERVACAO'
              DataSource = dtsRegistro
              ScrollBars = ssVertical
              TabOrder = 0
            end
          end
        end
      end
    end
  end
  inherited mtRegistro: TClientDataSet
    BeforeInsert = mtRegistroBeforeInsert
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      Origin = 'F_FOLHA.IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object mtRegistroIDFOLHA: TIntegerField
      FieldName = 'IDFOLHA'
      Origin = 'F_FOLHA.IDFOLHA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object mtRegistroDESCRICAO: TStringField
      FieldName = 'DESCRICAO'
      Size = 30
    end
    object mtRegistroDATA_CREDITO: TDateField
      FieldName = 'DATA_CREDITO'
      Origin = 'F_FOLHA.DATA_CREDITO'
    end
    object mtRegistroPERIODO_INICIO: TDateField
      FieldName = 'PERIODO_INICIO'
      Origin = 'F_FOLHA.PERIODO_INICIO'
    end
    object mtRegistroPERIODO_FIM: TDateField
      FieldName = 'PERIODO_FIM'
      Origin = 'F_FOLHA.PERIODO_FIM'
    end
    object mtRegistroARQUIVAR_X: TSmallintField
      FieldName = 'ARQUIVAR_X'
      Origin = 'F_FOLHA.ARQUIVAR_X'
    end
    object mtRegistroOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 250
    end
    object mtRegistroCOMPETENCIA: TSmallintField
      FieldName = 'COMPETENCIA'
      ProviderFlags = [pfInUpdate]
    end
    object mtRegistroIDFOLHA_TIPO: TStringField
      FieldName = 'IDFOLHA_TIPO'
      Size = 1
    end
    object mtRegistroIDGP: TIntegerField
      FieldName = 'IDGP'
    end
    object mtRegistroFOLHA_TIPO: TStringField
      FieldName = 'FOLHA_TIPO'
      ProviderFlags = [pfHidden]
      Size = 30
    end
    object mtRegistroGP: TStringField
      FieldKind = fkLookup
      FieldName = 'GP'
      LookupDataSet = cdGP
      LookupKeyFields = 'IDGP'
      LookupResultField = 'NOME'
      KeyFields = 'IDGP'
      Size = 30
      Lookup = True
    end
    object mtRegistroCOMPLEMENTAR_X: TSmallintField
      FieldName = 'COMPLEMENTAR_X'
    end
    object mtRegistroMES_ANO: TStringField
      FieldName = 'MES_ANO'
      Size = 7
    end
    object mtRegistroMES: TSmallintField
      FieldName = 'MES'
    end
  end
  inherited mtListagem: TClientDataSet
    StoreDefs = True
  end
  object cdGP: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'IDGP'
        DataType = ftInteger
      end
      item
        Name = 'NOME'
        DataType = ftString
        Size = 30
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 178
    Top = 344
    Data = {
      400000009619E0BD010000001800000002000000000003000000400004494447
      500400010000000000044E4F4D45010049000000010005574944544802000200
      1E000000}
    object cdGPIDGP: TIntegerField
      FieldName = 'IDGP'
    end
    object cdGPNOME: TStringField
      FieldName = 'NOME'
      Size = 30
    end
  end
end
