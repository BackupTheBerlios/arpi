object frmConfigEntorno: TfrmConfigEntorno
  Left = 332
  Top = 446
  BorderStyle = bsSingle
  Caption = 'Configuraci'#243'n'
  ClientHeight = 221
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 64
    Width = 98
    Height = 13
    Caption = 'Directorio de trabajo:'
  end
  object Label2: TLabel
    Left = 8
    Top = 104
    Width = 113
    Height = 13
    Caption = 'Directorio de algoritmos:'
  end
  object Button1: TButton
    Left = 352
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    ModalResult = 1
    TabOrder = 0
  end
  object Button2: TButton
    Left = 440
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    ModalResult = 2
    TabOrder = 1
  end
  object leDirAlg: TJvDirectoryEdit
    Left = 128
    Top = 100
    Width = 409
    Height = 21
    AcceptFiles = False
    DialogKind = dkWin32
    TabOrder = 2
  end
  object leDirTrabajo: TJvDirectoryEdit
    Left = 128
    Top = 60
    Width = 409
    Height = 21
    AcceptFiles = False
    DialogKind = dkWin32
    TabOrder = 3
  end
  object JvBDialog: TJvBrowseForFolderDialog
    Left = 488
    Top = 16
  end
end
