object FrameEndereco: TFrameEndereco
  Left = 0
  Top = 0
  Width = 619
  Height = 297
  VertScrollBar.Range = 270
  AutoScroll = False
  TabOrder = 0
  object pnlEndereco1: TPanel
    Left = 0
    Top = 0
    Width = 619
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 78
      Width = 619
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
    end
    object LblEndereco1: TLabel
      Left = 8
      Top = 8
      Width = 354
      Height = 13
      Caption = 
        '1 - Endere'#231'o Principal - Logradouro, rua, no., andar, apto. / Ba' +
        'irro / Cidade'
    end
    object lblComplemento1: TLabel
      Left = 403
      Top = 8
      Width = 156
      Height = 13
      Caption = 'Complemento / PAIS / UF / CEP'
      FocusControl = dbComplemento1
    end
    object dbEndereco1: TDBEdit
      Left = 8
      Top = 24
      Width = 390
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object dbComplemento1: TDBEdit
      Left = 403
      Top = 24
      Width = 200
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object dbBairro1: TDBEdit
      Left = 8
      Top = 48
      Width = 195
      Height = 21
      AutoSelect = False
      CharCase = ecUpperCase
      TabOrder = 2
    end
    object dbCidade1: TDBEdit
      Left = 208
      Top = 48
      Width = 187
      Height = 21
      AutoSelect = False
      CharCase = ecUpperCase
      TabOrder = 3
    end
    object dbPais1: TDBLookupComboBox
      Left = 403
      Top = 48
      Width = 60
      Height = 21
      TabOrder = 4
    end
    object dbUF1: TDBLookupComboBox
      Left = 468
      Top = 48
      Width = 50
      Height = 21
      TabOrder = 5
    end
    object dbCEP1: TDBEdit
      Left = 523
      Top = 48
      Width = 80
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 6
    end
  end
  object pnlEndereco2: TPanel
    Left = 0
    Top = 80
    Width = 619
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 1
    object Bevel2: TBevel
      Left = 0
      Top = 78
      Width = 619
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
    end
    object lblEndereco2: TLabel
      Left = 8
      Top = 8
      Width = 381
      Height = 13
      Caption = 
        '2 - Endere'#231'o Complementar - Logradouro, rua, no., andar, apto. /' +
        ' Bairro / Cidade'
      FocusControl = dbEndereco2
    end
    object lblComplemento2: TLabel
      Left = 403
      Top = 8
      Width = 156
      Height = 13
      Caption = 'Complemento / PAIS / UF / CEP'
      FocusControl = dbComplemento2
    end
    object dbEndereco2: TDBEdit
      Left = 8
      Top = 24
      Width = 390
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
    end
    object dbBairro2: TDBEdit
      Left = 8
      Top = 48
      Width = 195
      Height = 21
      AutoSelect = False
      CharCase = ecUpperCase
      TabOrder = 2
    end
    object dbCidade2: TDBEdit
      Left = 208
      Top = 48
      Width = 190
      Height = 21
      AutoSelect = False
      CharCase = ecUpperCase
      TabOrder = 3
    end
    object dbPais2: TDBLookupComboBox
      Left = 403
      Top = 48
      Width = 60
      Height = 21
      TabOrder = 4
    end
    object dbComplemento2: TDBEdit
      Left = 403
      Top = 24
      Width = 200
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object dbUF2: TDBLookupComboBox
      Left = 468
      Top = 48
      Width = 50
      Height = 21
      TabOrder = 5
    end
    object dbCEP2: TDBEdit
      Left = 523
      Top = 48
      Width = 80
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 6
    end
  end
  object pnlTelefone: TPanel
    Left = 0
    Top = 160
    Width = 619
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 2
    object Bevel3: TBevel
      Left = 0
      Top = 53
      Width = 619
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
    end
    object lblTelefone1: TLabel
      Left = 8
      Top = 8
      Width = 85
      Height = 13
      Caption = 'Telefone Principal'
      FocusControl = dbTelefone1
    end
    object lblTelefone2: TLabel
      Left = 108
      Top = 8
      Width = 75
      Height = 13
      Caption = 'Telefone Comp.'
      FocusControl = dbTelefone2
    end
    object lblFax: TLabel
      Left = 208
      Top = 8
      Width = 17
      Height = 13
      Caption = 'Fax'
      FocusControl = dbFax
    end
    object lblCelular: TLabel
      Left = 408
      Top = 8
      Width = 32
      Height = 13
      Caption = 'Celular'
      FocusControl = dbCelular
    end
    object lblBIP: TLabel
      Left = 508
      Top = 8
      Width = 85
      Height = 13
      Caption = '2o. Celular ou BIP'
      FocusControl = dbBIP
    end
    object lblFoneFax: TLabel
      Left = 308
      Top = 8
      Width = 46
      Height = 13
      Caption = 'Fone/Fax'
    end
    object dbTelefone1: TDBEdit
      Left = 8
      Top = 24
      Width = 95
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 0
    end
    object dbTelefone2: TDBEdit
      Left = 108
      Top = 24
      Width = 95
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 1
    end
    object dbFax: TDBEdit
      Left = 208
      Top = 24
      Width = 95
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 2
    end
    object dbCelular: TDBEdit
      Left = 408
      Top = 24
      Width = 95
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 4
    end
    object dbBIP: TDBEdit
      Left = 508
      Top = 24
      Width = 95
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 5
    end
    object dbFoneFax: TDBEdit
      Left = 308
      Top = 24
      Width = 95
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 3
    end
  end
  object pnlInternet: TPanel
    Left = 0
    Top = 215
    Width = 619
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 3
    object Bevel4: TBevel
      Left = 0
      Top = 58
      Width = 619
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
    end
    object lblEmail: TLabel
      Left = 8
      Top = 12
      Width = 56
      Height = 13
      Caption = 'E-Mail (lista)'
      FocusControl = dbEmail
    end
    object lblHP: TLabel
      Left = 8
      Top = 36
      Width = 83
      Height = 13
      Caption = 'Home-Page (lista)'
      FocusControl = dbHomePage
    end
    object dbHomePage: TDBEdit
      Left = 108
      Top = 32
      Width = 300
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 1
    end
    object dbEmail: TDBEdit
      Left = 108
      Top = 8
      Width = 300
      Height = 21
      CharCase = ecLowerCase
      TabOrder = 0
    end
    object dbEnviar: TDBCheckBox
      Left = 430
      Top = 16
      Width = 179
      Height = 21
      Caption = 'Enviar Correspond'#234'ncias'
      TabOrder = 2
      ValueChecked = '1'
      ValueUnchecked = '0'
    end
  end
end
