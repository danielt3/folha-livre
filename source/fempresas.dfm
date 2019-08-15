inherited FrmEmpresa: TFrmEmpresa
  Left = -4
  Top = -4
  Caption = 'Cadastro de Empresas'
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlEscuro: TPanel
    inherited lblPrograma: TPanel
      Caption = 'Empresas'
    end
  end
  inherited PnlClaro: TPanel
    inherited PageControl1: TPageControl
      inherited TabListagem: TTabSheet
        Caption = 'Lista de Empresas'
        inherited dbgRegistro: TDBGrid
          Columns = <
            item
              Expanded = False
              FieldName = 'IDEMPRESA'
              Title.Caption = 'ID'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome da Empresa'
              Width = 300
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'APELIDO'
              Title.Caption = 'Fantasia/Apelido'
              Width = 140
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CPF_CGC'
              Title.Caption = 'CPF/CGC'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'IDGE'
              Title.Caption = 'Grupo'
              Width = 40
              Visible = True
            end>
        end
      end
      inherited TabDetalhe: TTabSheet
        Caption = 'Detalhes da Empresa'
        object pnlDados: TPanel
          Left = 0
          Top = 0
          Width = 632
          Height = 55
          Align = alTop
          BevelOuter = bvNone
          ParentColor = True
          TabOrder = 0
          object lbCodigo: TLabel
            Left = 8
            Top = 8
            Width = 33
            Height = 13
            Caption = 'C'#243'digo'
            FocusControl = dbCodigo
          end
          object lbNome: TLabel
            Left = 63
            Top = 8
            Width = 87
            Height = 13
            Caption = 'Nome da Empresa'
            FocusControl = dbNome
          end
          object Bevel2: TBevel
            Left = 0
            Top = 53
            Width = 632
            Height = 2
            Align = alBottom
            Shape = bsBottomLine
          end
          object lbApelido: TLabel
            Left = 408
            Top = 8
            Width = 86
            Height = 13
            Caption = 'Fantasia / Apelido'
            FocusControl = dbApelido
          end
          object dbCodigo: TDBEdit
            Left = 8
            Top = 24
            Width = 50
            Height = 19
            AutoSize = False
            DataField = 'IDEMPRESA'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbNome: TDBEdit
            Left = 63
            Top = 24
            Width = 340
            Height = 19
            AutoSize = False
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dtsRegistro
            TabOrder = 1
          end
          object dbApelido: TDBEdit
            Left = 408
            Top = 24
            Width = 195
            Height = 21
            CharCase = ecUpperCase
            DataField = 'APELIDO'
            DataSource = dtsRegistro
            TabOrder = 2
          end
        end
        object PageControl2: TPageControl
          Left = 0
          Top = 55
          Width = 632
          Height = 358
          ActivePage = TabSheet2
          Align = alClient
          Style = tsButtons
          TabOrder = 1
          object TabGeral: TTabSheet
            Caption = 'Dados Gerais'
            object pnlDoc: TPanel
              Left = 0
              Top = 0
              Width = 624
              Height = 55
              Align = alTop
              BevelOuter = bvNone
              ParentColor = True
              TabOrder = 0
              object Bevel4: TBevel
                Left = 0
                Top = 53
                Width = 624
                Height = 2
                Align = alBottom
                Shape = bsBottomLine
              end
              object lblCPF: TLabel
                Left = 93
                Top = 8
                Width = 47
                Height = 13
                Caption = 'CPF/CGC'
                FocusControl = dbCPF
              end
              object lblPessoa: TLabel
                Left = 8
                Top = 8
                Width = 72
                Height = 13
                Caption = '&F'#237'sica/Jur'#237'dica'
                FocusControl = dbPessoa
              end
              object lbTelefone: TLabel
                Left = 408
                Top = 8
                Width = 53
                Height = 13
                Caption = 'Telefone(s)'
                FocusControl = dbTelefone
              end
              object lbGrupoEmpresa: TLabel
                Left = 208
                Top = 8
                Width = 93
                Height = 13
                Caption = 'Grupo de Empresas'
                FocusControl = dbGrupoEmpresa
              end
              object dbCPF: TDBEdit
                Left = 93
                Top = 24
                Width = 110
                Height = 21
                Hint = 'efsFrameBump'
                DataField = 'CPF_CGC'
                DataSource = dtsRegistro
                TabOrder = 1
                OnExit = dbCPFExit
              end
              object dbPessoa: TDBLookupComboBox
                Left = 8
                Top = 24
                Width = 80
                Height = 21
                DataField = 'PESSOA'
                DataSource = dtsRegistro
                DropDownRows = 2
                DropDownWidth = 85
                TabOrder = 0
              end
              object dbTelefone: TDBEdit
                Left = 408
                Top = 24
                Width = 195
                Height = 21
                CharCase = ecUpperCase
                DataField = 'TELEFONE'
                DataSource = dtsRegistro
                TabOrder = 3
              end
              object dbGrupoEmpresa: TDBLookupComboBox
                Left = 208
                Top = 24
                Width = 195
                Height = 21
                DataField = 'IDGE'
                DataSource = dtsRegistro
                TabOrder = 2
              end
            end
            object pnlEndereco1: TPanel
              Left = 0
              Top = 55
              Width = 624
              Height = 80
              Align = alTop
              BevelOuter = bvNone
              Locked = True
              ParentColor = True
              TabOrder = 1
              object Bevel1: TBevel
                Left = 0
                Top = 78
                Width = 624
                Height = 2
                Align = alBottom
                Shape = bsBottomLine
              end
              object LblEndereco1: TLabel
                Left = 8
                Top = 8
                Width = 339
                Height = 13
                Caption = 
                  'Endere'#231'o Principal - Logradouro, rua, no., andar, apto. / Bairro' +
                  ' / Cidade'
              end
              object lblComplemento1: TLabel
                Left = 403
                Top = 8
                Width = 156
                Height = 13
                Caption = 'Complemento / PAIS / UF / CEP'
                FocusControl = dbComplemento
              end
              object dbEndereco: TDBEdit
                Left = 8
                Top = 24
                Width = 390
                Height = 21
                CharCase = ecUpperCase
                DataField = 'ENDERECO'
                DataSource = dtsRegistro
                TabOrder = 0
              end
              object dbComplemento: TDBEdit
                Left = 403
                Top = 24
                Width = 200
                Height = 21
                CharCase = ecUpperCase
                DataField = 'COMPLEMENTO'
                DataSource = dtsRegistro
                TabOrder = 1
              end
              object dbBairro: TDBEdit
                Left = 8
                Top = 48
                Width = 195
                Height = 21
                AutoSelect = False
                CharCase = ecUpperCase
                DataField = 'BAIRRO'
                DataSource = dtsRegistro
                TabOrder = 2
              end
              object dbCidade: TDBEdit
                Left = 208
                Top = 48
                Width = 187
                Height = 21
                AutoSelect = False
                CharCase = ecUpperCase
                DataField = 'CIDADE'
                DataSource = dtsRegistro
                TabOrder = 3
              end
              object dbPais: TDBLookupComboBox
                Left = 403
                Top = 48
                Width = 60
                Height = 21
                DataField = 'IDPAIS'
                DataSource = dtsRegistro
                TabOrder = 4
              end
              object dbUF: TDBLookupComboBox
                Left = 468
                Top = 48
                Width = 50
                Height = 21
                DataField = 'IDUF'
                DataSource = dtsRegistro
                TabOrder = 5
              end
              object dbCEP: TDBEdit
                Left = 523
                Top = 48
                Width = 80
                Height = 21
                CharCase = ecUpperCase
                DataField = 'CEP'
                DataSource = dtsRegistro
                TabOrder = 6
              end
            end
          end
          object TabSheet2: TTabSheet
            Caption = '&Observa'#231#245'es'
            ImageIndex = 1
            object dbObservacao: TDBMemo
              Left = 0
              Top = 0
              Width = 624
              Height = 327
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
  inherited dtsRegistro: TDataSource
    Left = 40
    Top = 312
  end
  inherited mtRegistro: TClientDataSet
    AfterPost = mtRegistroAfterCancel
    Left = 42
    Top = 368
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtRegistroCPF_CGC: TStringField
      FieldName = 'CPF_CGC'
      OnGetText = mtRegistroCPF_CGCGetText
      Size = 14
    end
    object mtRegistroAPELIDO: TStringField
      FieldName = 'APELIDO'
      Size = 30
    end
    object mtRegistroENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 50
    end
    object mtRegistroCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
      Size = 30
    end
    object mtRegistroBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 30
    end
    object mtRegistroCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 30
    end
    object mtRegistroIDPAIS: TStringField
      FieldName = 'IDPAIS'
      Size = 3
    end
    object mtRegistroIDUF: TStringField
      FieldName = 'IDUF'
      Size = 2
    end
    object mtRegistroCEP: TStringField
      FieldName = 'CEP'
      Size = 8
    end
    object mtRegistroTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Size = 15
    end
    object mtRegistroOBSERVACAO: TStringField
      FieldName = 'OBSERVACAO'
      Size = 250
    end
    object mtRegistroPESSOA: TStringField
      FieldName = 'PESSOA'
      Size = 1
    end
    object mtRegistroIDGE: TStringField
      FieldName = 'IDGE'
      Size = 10
    end
  end
  inherited mtListagem: TClientDataSet
    StoreDefs = True
    Left = 34
    Top = 200
    object mtListagemIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
    end
    object mtListagemNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtListagemAPELIDO: TStringField
      FieldName = 'APELIDO'
      Size = 30
    end
    object mtListagemCPF_CGC: TStringField
      FieldName = 'CPF_CGC'
      Size = 14
    end
    object mtListagemIDGE: TIntegerField
      FieldName = 'IDGE'
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
end
