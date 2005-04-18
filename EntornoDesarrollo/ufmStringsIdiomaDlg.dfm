object fmStringsIdiomaDlg: TfmStringsIdiomaDlg
  Left = 416
  Top = 220
  Width = 275
  Height = 167
  BorderStyle = bsSizeToolWin
  Caption = 'fmStringsIdiomaDlg'
  Color = clBtnFace
  Constraints.MinHeight = 120
  Constraints.MinWidth = 200
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object selectorIdioma: TTabControl
    Left = 0
    Top = 0
    Width = 267
    Height = 133
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    OnChange = cambiarIdioma
    OnChanging = guardarValor
    DesignSize = (
      267
      133)
    object btOk: TButton
      Left = 96
      Top = 105
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btOk'
      Default = True
      ModalResult = 1
      TabOrder = 0
      OnClick = btOkClick
    end
    object btCancel: TButton
      Left = 177
      Top = 105
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btCancel'
      ModalResult = 2
      TabOrder = 1
    end
    object txtEditor: TMemo
      Left = 16
      Top = 24
      Width = 233
      Height = 68
      Anchors = [akLeft, akTop, akRight, akBottom]
      Lines.Strings = (
        'txtEditor')
      TabOrder = 2
    end
  end
end
