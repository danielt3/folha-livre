inherited FrmLotacao: TFrmLotacao
  Left = 40
  Top = 24
  Caption = 'Lota'#231#245'es'
  ClientHeight = 500
  ClientWidth = 594
  WindowState = wsNormal
  PixelsPerInch = 96
  TextHeight = 13
  inherited PnlEscuro: TPanel
    Height = 500
    inherited lblPrograma: TPanel
      Caption = 'Contas'
    end
    inherited pnlPesquisa: TPanel
      Top = 400
    end
  end
  inherited PnlClaro: TPanel
    Width = 593
    Height = 500
    inherited PnlControle: TPanel
      Top = 460
      Width = 593
      TabOrder = 2
    end
    inherited PnlTitulo: TPanel
      Width = 593
      inherited RxTitulo: TLabel
        Width = 231
        Caption = ' '#183' Listagem das Lota'#231#245'es'
      end
      inherited PnlFechar: TPanel
        Left = 553
      end
    end
    inherited dbgRegistro: TDBGrid
      Width = 593
      Height = 250
      TabOrder = 3
      Columns = <
        item
          Expanded = False
          FieldName = 'IDLOTACAO'
          Title.Caption = 'Lota'#231#227'o'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Title.Caption = 'Descri'#231#227'o da Lota'#231#227'o'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CODIGO'
          Title.Caption = 'Dep / Setor / Se'#231#227'o'
          Width = 120
          Visible = True
        end>
    end
    inherited Panel: TPanel
      Top = 280
      Width = 593
      Height = 180
      TabOrder = 1
      object Label2: TLabel
        Left = 183
        Top = 8
        Width = 105
        Height = 13
        Caption = 'Descri'#231#227'o da Lota'#231#227'o'
        FocusControl = dbNome
      end
      object lbLotacao: TLabel
        Left = 8
        Top = 8
        Width = 39
        Height = 13
        Caption = 'Lota'#231#227'o'
        FocusControl = dbLotacao
      end
      object lbEndereco: TLabel
        Left = 8
        Top = 92
        Width = 214
        Height = 13
        Caption = 'Endere'#231'o - Logradouro, rua, no., andar, apto.'
      end
      object lbBairro: TLabel
        Left = 8
        Top = 131
        Width = 27
        Height = 13
        Caption = 'Bairro'
        FocusControl = dbBairro
      end
      object lbCidade: TLabel
        Left = 213
        Top = 131
        Width = 33
        Height = 13
        Caption = 'Cidade'
        FocusControl = dbCidade
      end
      object lbCEP1: TLabel
        Left = 418
        Top = 131
        Width = 21
        Height = 13
        Caption = 'CEP'
        FocusControl = dbCEP
      end
      object lbResponsavel: TLabel
        Left = 8
        Top = 51
        Width = 108
        Height = 13
        Caption = 'Nome do Respons'#225'vel'
        FocusControl = dbResponsavel
      end
      object lbTelefone: TLabel
        Left = 303
        Top = 51
        Width = 42
        Height = 13
        Caption = 'Telefone'
        FocusControl = dbTelefone
      end
      object lbFax: TLabel
        Left = 408
        Top = 51
        Width = 17
        Height = 13
        Caption = 'Fax'
        FocusControl = dbFax
      end
      object lbDepartamento: TLabel
        Left = 73
        Top = 8
        Width = 26
        Height = 13
        Caption = 'Dept.'
        FocusControl = dbDepartamento
        ParentShowHint = False
        ShowHint = False
      end
      object lbSetor: TLabel
        Left = 108
        Top = 8
        Width = 25
        Height = 13
        Caption = 'Setor'
        FocusControl = dbSetor
        ParentShowHint = False
        ShowHint = False
      end
      object lbSecao: TLabel
        Left = 143
        Top = 8
        Width = 31
        Height = 13
        Caption = 'Se'#231#227'o'
        FocusControl = dbSecao
        ParentShowHint = False
        ShowHint = False
      end
      object dbNome: TDBEdit
        Left = 183
        Top = 23
        Width = 325
        Height = 21
        CharCase = ecUpperCase
        DataField = 'NOME'
        DataSource = dtsRegistro
        TabOrder = 4
      end
      object dbLotacao: TDBEdit
        Left = 8
        Top = 23
        Width = 60
        Height = 21
        DataField = 'IDLOTACAO'
        DataSource = dtsRegistro
        TabOrder = 0
      end
      object dbEndereco: TDBEdit
        Left = 8
        Top = 108
        Width = 500
        Height = 21
        CharCase = ecUpperCase
        DataField = 'ENDERECO'
        DataSource = dtsRegistro
        TabOrder = 8
      end
      object dbBairro: TDBEdit
        Left = 8
        Top = 147
        Width = 200
        Height = 21
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'BAIRRO'
        DataSource = dtsRegistro
        TabOrder = 9
      end
      object dbCidade: TDBEdit
        Left = 213
        Top = 147
        Width = 200
        Height = 21
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'CIDADE'
        DataSource = dtsRegistro
        TabOrder = 10
      end
      object dbCEP: TDBEdit
        Left = 418
        Top = 147
        Width = 90
        Height = 21
        CharCase = ecUpperCase
        DataField = 'CEP'
        DataSource = dtsRegistro
        TabOrder = 11
      end
      object dbResponsavel: TDBEdit
        Left = 8
        Top = 67
        Width = 290
        Height = 21
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'RESPONSAVEL'
        DataSource = dtsRegistro
        TabOrder = 5
      end
      object dbTelefone: TDBEdit
        Left = 303
        Top = 67
        Width = 100
        Height = 21
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'TELEFONE'
        DataSource = dtsRegistro
        TabOrder = 6
      end
      object dbFax: TDBEdit
        Left = 408
        Top = 67
        Width = 100
        Height = 21
        CharCase = ecUpperCase
        DataField = 'FAX'
        DataSource = dtsRegistro
        TabOrder = 7
      end
      object dbAtivo: TDBCheckBox
        Left = 520
        Top = 149
        Width = 60
        Height = 17
        Caption = 'Ativo'
        DataField = 'ATIVO_X'
        DataSource = dtsRegistro
        TabOrder = 12
        ValueChecked = '1'
        ValueUnchecked = '0'
      end
      object dbDepartamento: TDBEdit
        Left = 73
        Top = 23
        Width = 30
        Height = 21
        Hint = 'Departamento'
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'DEPARTAMENTO'
        DataSource = dtsRegistro
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object dbSetor: TDBEdit
        Left = 108
        Top = 23
        Width = 30
        Height = 21
        Hint = 'Setor'
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'SETOR'
        DataSource = dtsRegistro
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
      end
      object dbSecao: TDBEdit
        Left = 143
        Top = 23
        Width = 35
        Height = 21
        Hint = 'Se'#231#227'o'
        AutoSelect = False
        CharCase = ecUpperCase
        DataField = 'SECAO'
        DataSource = dtsRegistro
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
      end
    end
  end
  inherited dtsRegistro: TDataSource
    Left = 120
    Top = 72
  end
  inherited mtRegistro: TClientDataSet
    AfterCancel = mtRegistroAfterPost
    OnCalcFields = mtRegistroCalcFields
    Left = 50
    Top = 72
    object mtRegistroIDEMPRESA: TIntegerField
      FieldName = 'IDEMPRESA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroIDLOTACAO: TIntegerField
      FieldName = 'IDLOTACAO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtRegistroNOME: TStringField
      FieldName = 'NOME'
      ProviderFlags = [pfInUpdate]
      Size = 50
    end
    object mtRegistroDEPARTAMENTO: TIntegerField
      FieldName = 'DEPARTAMENTO'
    end
    object mtRegistroSETOR: TIntegerField
      FieldName = 'SETOR'
    end
    object mtRegistroSECAO: TIntegerField
      FieldName = 'SECAO'
    end
    object mtRegistroCODIGO: TStringField
      FieldKind = fkCalculated
      FieldName = 'CODIGO'
      Size = 15
      Calculated = True
    end
    object mtRegistroENDERECO: TStringField
      FieldName = 'ENDERECO'
      Size = 50
    end
    object mtRegistroCIDADE: TStringField
      FieldName = 'CIDADE'
      Size = 30
    end
    object mtRegistroBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Size = 30
    end
    object mtRegistroRESPONSAVEL: TStringField
      FieldName = 'RESPONSAVEL'
      Size = 50
    end
    object mtRegistroCEP: TStringField
      FieldName = 'CEP'
      Size = 8
    end
    object mtRegistroTELEFONE: TStringField
      FieldName = 'TELEFONE'
      Size = 15
    end
    object mtRegistroFAX: TStringField
      FieldName = 'FAX'
      Size = 15
    end
    object mtRegistroATIVO_X: TSmallintField
      FieldName = 'ATIVO_X'
    end
    object mtRegistroTIPO: TStringField
      FieldName = 'TIPO'
      Size = 1
    end
  end
end
