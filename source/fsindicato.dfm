inherited FrmSindicato: TFrmSindicato
  Left = -4
  Top = -4
  Caption = 'Cadastro de Sindicatos'
  ClientHeight = 596
  ClientWidth = 862
  PixelsPerInch = 96
  TextHeight = 14
  inherited PnlEscuro: TPanel
    Height = 596
    inherited lblPrograma: TPanel
      Caption = 'Sindicatos'
    end
    inherited pnlPesquisa: TPanel
      Top = 496
    end
  end
  inherited PnlClaro: TPanel
    Width = 700
    Height = 596
    inherited PnlControle: TPanel
      Top = 556
      Width = 700
    end
    inherited PnlTitulo: TPanel
      Width = 700
      inherited PnlFechar: TPanel
        Left = 571
      end
    end
    inherited PageControl1: TPageControl
      Width = 700
      Height = 526
      inherited TabListagem: TTabSheet
        Caption = 'Lista de Sindicatos'
        inherited dbgRegistro: TDBGrid
          Width = 692
          Height = 494
          Columns = <
            item
              Expanded = False
              FieldName = 'IDSINDICATO'
              Title.Caption = 'ID'
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'NOME'
              Title.Caption = 'Nome do Sindicato'
              Width = 330
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CNPJ'
              Width = 80
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'TELEFONE'
              Title.Caption = 'Telefone'
              Width = 100
              Visible = True
            end>
        end
      end
      inherited TabDetalhe: TTabSheet
        Caption = 'Detalhes do Sindicato'
        object pnlDados: TPanel
          Left = 0
          Top = 0
          Width = 692
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
            Width = 89
            Height = 14
            Caption = 'Nome do Sindicato'
            FocusControl = dbNome
          end
          object Bevel2: TBevel
            Left = 0
            Top = 57
            Width = 692
            Height = 2
            Align = alBottom
            Shape = bsBottomLine
          end
          object lblCPF: TLabel
            Left = 526
            Top = 9
            Width = 25
            Height = 14
            Caption = 'CNPJ'
            FocusControl = dbCNPJ
          end
          object dbCodigo: TDBEdit
            Left = 9
            Top = 26
            Width = 53
            Height = 22
            DataField = 'IDSINDICATO'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbNome: TDBEdit
            Left = 68
            Top = 26
            Width = 452
            Height = 22
            CharCase = ecUpperCase
            DataField = 'NOME'
            DataSource = dtsRegistro
            TabOrder = 1
          end
          object dbCNPJ: TDBEdit
            Left = 526
            Top = 26
            Width = 118
            Height = 22
            Hint = 'efsFrameBump'
            DataField = 'CNPJ'
            DataSource = dtsRegistro
            TabOrder = 2
            OnExit = dbCNPJExit
          end
        end
        object pnlEndereco1: TPanel
          Left = 0
          Top = 59
          Width = 692
          Height = 149
          Align = alTop
          BevelOuter = bvNone
          Locked = True
          ParentColor = True
          TabOrder = 1
          object LblEndereco1: TLabel
            Left = 9
            Top = 9
            Width = 342
            Height = 14
            Caption = 
              'Endere'#231'o Principal - Logradouro, rua, no., andar, apto. / Bairro' +
              ' / Cidade'
          end
          object lblComplemento1: TLabel
            Left = 434
            Top = 9
            Width = 146
            Height = 14
            Caption = 'Complemento / PAIS / UF / CEP'
            FocusControl = dbComplemento
          end
          object lbTelefone: TLabel
            Left = 9
            Top = 78
            Width = 56
            Height = 14
            Caption = 'Telefone(s)'
            FocusControl = dbTelefone
          end
          object Label1: TLabel
            Left = 9
            Top = 129
            Width = 66
            Height = 14
            Caption = 'Observa'#231#245'es'
          end
          object dbEndereco: TDBEdit
            Left = 9
            Top = 26
            Width = 420
            Height = 22
            CharCase = ecUpperCase
            DataField = 'ENDERECO'
            DataSource = dtsRegistro
            TabOrder = 0
          end
          object dbComplemento: TDBEdit
            Left = 434
            Top = 26
            Width = 215
            Height = 22
            CharCase = ecUpperCase
            DataField = 'COMPLEMENTO'
            DataSource = dtsRegistro
            TabOrder = 1
          end
          object dbBairro: TDBEdit
            Left = 9
            Top = 52
            Width = 210
            Height = 22
            AutoSelect = False
            CharCase = ecUpperCase
            DataField = 'BAIRRO'
            DataSource = dtsRegistro
            TabOrder = 2
          end
          object dbCidade: TDBEdit
            Left = 224
            Top = 52
            Width = 201
            Height = 22
            AutoSelect = False
            CharCase = ecUpperCase
            DataField = 'CIDADE'
            DataSource = dtsRegistro
            TabOrder = 3
          end
          object dbPais: TDBLookupComboBox
            Left = 434
            Top = 52
            Width = 65
            Height = 22
            DataField = 'IDPAIS'
            DataSource = dtsRegistro
            TabOrder = 4
          end
          object dbUF: TDBLookupComboBox
            Left = 504
            Top = 52
            Width = 54
            Height = 22
            DataField = 'IDUF'
            DataSource = dtsRegistro
            TabOrder = 5
          end
          object dbCEP: TDBEdit
            Left = 563
            Top = 52
            Width = 86
            Height = 22
            CharCase = ecUpperCase
            DataField = 'CEP'
            DataSource = dtsRegistro
            TabOrder = 6
          end
          object dbTelefone: TDBEdit
            Left = 9
            Top = 95
            Width = 210
            Height = 22
            CharCase = ecUpperCase
            DataField = 'TELEFONE'
            DataSource = dtsRegistro
            TabOrder = 7
          end
        end
        object dbObservacao: TDBMemo
          Left = 0
          Top = 208
          Width = 692
          Height = 286
          Align = alClient
          DataField = 'OBSERVACAO'
          DataSource = dtsRegistro
          ScrollBars = ssVertical
          TabOrder = 2
        end
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Top = 312
  end
  inherited mtRegistro: TClientDataSet
    AfterPost = mtRegistroAfterCancel
    Left = 42
    Top = 368
    object mtRegistroIDSINDICATO: TIntegerField
      FieldName = 'IDSINDICATO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtRegistroCNPJ: TStringField
      FieldName = 'CNPJ'
      OnGetText = mtRegistroCNPJGetText
      Size = 14
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
    object mtRegistroOBSERVACAO: TMemoField
      FieldName = 'OBSERVACAO'
      BlobType = ftMemo
    end
  end
  inherited mtListagem: TClientDataSet
    StoreDefs = True
    Left = 42
    Top = 200
    object mtListagemIDSINDICATO: TIntegerField
      FieldName = 'IDSINDICATO'
    end
    object mtListagemNOME: TStringField
      FieldName = 'NOME'
      Size = 50
    end
    object mtListagemCNPJ: TStringField
      FieldName = 'CNPJ'
      Size = 14
    end
    object mtListagemTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Size = 15
    end
  end
  inherited dtsListagem: TDataSource
    Left = 48
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
