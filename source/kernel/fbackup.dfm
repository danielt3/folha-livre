object FrmBackup: TFrmBackup
  Left = 111
  Top = 98
  BorderStyle = bsDialog
  Caption = 'C'#243'pia de Seguran'#231'a'
  ClientHeight = 295
  ClientWidth = 298
  Color = clWindow
  Ctl3D = False
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 298
    Height = 295
    Align = alClient
    BevelInner = bvLowered
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 151
      Height = 13
      Caption = 'Arquivo da C'#243'pia de Seguran'#231'a'
    end
    object RxSpeedButton1: TRxSpeedButton
      Left = 8
      Top = 53
      Width = 280
      Height = 31
      Caption = 'Iniciar o &Backup'
      Layout = blGlyphLeft
      Spacing = 20
      OnClick = RxSpeedButton1Click
    end
    object Edit2: TFilenameEdit
      Left = 8
      Top = 24
      Width = 280
      Height = 21
      Filter = 'Base Interbase|*.gdb'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      NumGlyphs = 1
      ParentFont = False
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 306
      Top = 20
      Width = 167
      Height = 114
      Caption = ' Op'#231#245'es de Backup '
      TabOrder = 1
      object CheckBox1: TCheckBox
        Left = 16
        Top = 16
        Width = 137
        Height = 17
        Caption = 'Non-Transportable'
        Checked = True
        State = cbChecked
        TabOrder = 0
      end
      object CheckBox2: TCheckBox
        Left = 16
        Top = 35
        Width = 97
        Height = 17
        Caption = 'Ignore Limbo'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object CheckBox3: TCheckBox
        Left = 16
        Top = 54
        Width = 97
        Height = 17
        Caption = 'Metadata Only'
        TabOrder = 2
      end
      object CheckBox4: TCheckBox
        Left = 16
        Top = 72
        Width = 169
        Height = 17
        Caption = 'No Garbage Collection'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
      object CheckBox5: TCheckBox
        Left = 16
        Top = 90
        Width = 97
        Height = 17
        Caption = 'Ignore Checksums'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
    object Animate1: TAnimate
      Left = 8
      Top = 220
      Width = 272
      Height = 60
      CommonAVI = aviCopyFiles
      StopFrame = 34
    end
    object Memo1: TMemo
      Left = 8
      Top = 96
      Width = 280
      Height = 113
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
  end
  object IBBackupService1: TIBBackupService
    TraceFlags = []
    BlockingFactor = 0
    Options = [IgnoreChecksums, IgnoreLimbo, NoGarbageCollection, NonTransportable]
    Left = 226
    Top = 16
  end
end
