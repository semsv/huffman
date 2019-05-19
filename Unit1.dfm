object Form1: TForm1
  Left = 299
  Top = 132
  Width = 647
  Height = 566
  Caption = #1044#1077#1084#1086#1085#1089#1090#1088#1072#1094#1080#1103' '#1089#1078#1072#1090#1080#1103' '#1084#1077#1090#1086#1076#1086#1084' '#1061#1072#1092#1092#1084#1072#1085#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 296
    Width = 136
    Height = 13
    Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1079#1083#1080#1095#1085#1099#1093' '#1082#1086#1076#1086#1074' = '
  end
  object Label2: TLabel
    Left = 152
    Top = 296
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label10: TLabel
    Left = 176
    Top = 424
    Width = 105
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1088#1072#1089#1087#1072#1082#1086#1074#1082#1080' : '
  end
  object Label11: TLabel
    Left = 286
    Top = 425
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label12: TLabel
    Left = 287
    Top = 448
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label13: TLabel
    Left = 176
    Top = 448
    Width = 92
    Height = 13
    Caption = #1042#1088#1077#1084#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' : '
  end
  object Label16: TLabel
    Left = 11
    Top = 12
    Width = 179
    Height = 13
    Caption = #1050#1083#1102#1095' ('#1076#1083#1103' '#1088#1072#1089#1087#1072#1082#1086#1074#1082#1080' '#1079#1072#1087#1072#1082#1086#1074#1082#1080'): '
  end
  object Memo1: TMemo
    Left = 8
    Top = 40
    Width = 305
    Height = 249
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object Pack: TButton
    Left = 8
    Top = 423
    Width = 120
    Height = 25
    Caption = #1040#1088#1093#1080#1074#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 1
    OnClick = PackClick
  end
  object UnPack: TButton
    Left = 8
    Top = 456
    Width = 121
    Height = 25
    Caption = #1044#1077#1079#1072#1088#1093#1080#1074#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = UnPackClick
  end
  object Memo2: TMemo
    Left = 320
    Top = 40
    Width = 305
    Height = 249
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 8
    Top = 317
    Width = 618
    Height = 83
    TabOrder = 4
    object Label3: TLabel
      Left = 499
      Top = 57
      Width = 44
      Height = 13
      Caption = #1042' '#1073#1072#1081#1090#1072#1093
    end
    object Label4: TLabel
      Left = 499
      Top = 29
      Width = 44
      Height = 13
      Caption = #1042' '#1073#1072#1081#1090#1072#1093
    end
    object Label5: TLabel
      Left = 556
      Top = 30
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label6: TLabel
      Left = 556
      Top = 57
      Width = 6
      Height = 13
      Caption = '0'
    end
    object Label7: TLabel
      Left = 8
      Top = 31
      Width = 114
      Height = 13
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1085#1099#1093' '#1076#1072#1085#1085#1099#1093
    end
    object Label8: TLabel
      Left = 9
      Top = 55
      Width = 127
      Height = 13
      Caption = #1054#1073#1088#1072#1073#1086#1090#1072#1085#1086' '#1091#1087#1072#1082' '#1076#1072#1085#1085#1099#1093
    end
    object Label9: TLabel
      Left = 8
      Top = 8
      Width = 171
      Height = 13
      Caption = #1048#1085#1080#1094#1080#1072#1083#1080#1079#1072#1094#1080#1103' '#1082#1086#1076#1086#1074#1086#1081' '#1090#1072#1073#1083#1080#1094#1099
    end
    object Label14: TLabel
      Left = 368
      Top = 8
      Width = 149
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1085#1077#1079#1072#1087#1072#1082#1086#1074#1072#1085#1085#1086#1081' '#1080#1085#1092
    end
    object Label15: TLabel
      Left = 368
      Top = 56
      Width = 102
      Height = 13
      Caption = #1056#1072#1079#1084#1077#1088' '#1089#1078#1072#1090#1086#1081' '#1080#1085#1092
    end
    object Gauge1: TProgressBar
      Left = 200
      Top = 32
      Width = 150
      Height = 17
      TabOrder = 0
    end
    object Gauge2: TProgressBar
      Left = 200
      Top = 56
      Width = 150
      Height = 17
      TabOrder = 1
    end
    object Gauge3: TProgressBar
      Left = 200
      Top = 8
      Width = 150
      Height = 17
      TabOrder = 2
    end
  end
  object StopBtn: TButton
    Left = 504
    Top = 456
    Width = 123
    Height = 25
    Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
    Enabled = False
    TabOrder = 5
    OnClick = StopBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 488
    Width = 631
    Height = 19
    Panels = <
      item
        Text = #1060#1072#1081#1083' '#1080#1089#1090#1086#1095#1085#1080#1082':'
        Width = 250
      end
      item
        Text = #1060#1072#1081#1083' '#1087#1088#1080#1077#1084#1085#1080#1082':'
        Width = 50
      end>
  end
  object PassEdit: TEdit
    Left = 192
    Top = 8
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 7
  end
  object OpenDialog1: TOpenDialog
    Left = 136
    Top = 455
  end
  object MainMenu1: TMainMenu
    Left = 328
    Top = 8
    object N1: TMenuItem
      Caption = #1052#1077#1085#1102
      object N3: TMenuItem
        Caption = #1040#1088#1093#1080#1074#1072#1090#1086#1088
        object N4: TMenuItem
          Caption = #1056#1072#1089#1087#1072#1082#1086#1074#1072#1090#1100
          OnClick = N4Click
        end
        object N5: TMenuItem
          Caption = #1047#1072#1087#1072#1082#1086#1074#1072#1090#1100
          OnClick = N5Click
        end
      end
      object N2: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N2Click
      end
    end
    object N6: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      object N7: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      end
    end
  end
  object Huffman1: THuffman
    OnOpenSourceFile = Huffman1OpenSourceFile
    OnInitCodeTable = Huffman1InitCodeTable
    OnAfterCreatePrefics = Huffman1AfterCreatePrefics
    OnAfterLoadHeader = Huffman1AfterLoadHeader
    OnAfterSaveHeader = Huffman1AfterSaveHeader
    OnBeforePackBlock = Huffman1BeforePackBlock
    OnAfterLoadPrefics = Huffman1AfterLoadPrefics
    OnAfterUnPack = Huffman1AfterUnPack
    OnUnPackBlock = Huffman1UnPackBlock
    OnAfterPack = Huffman1AfterPack
    Left = 136
    Top = 424
  end
end
