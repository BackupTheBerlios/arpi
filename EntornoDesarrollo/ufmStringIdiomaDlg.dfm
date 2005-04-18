object fmStringIdiomaDlg: TfmStringIdiomaDlg
  Left = 416
  Top = 220
  Width = 275
  Height = 120
  BorderStyle = bsSizeToolWin
  Caption = 'fmStringIdiomaDlg'
  Color = clBtnFace
  Constraints.MaxHeight = 120
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
    Height = 86
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    OnChange = cambiarIdioma
    OnChanging = guardarValor
    DesignSize = (
      267
      86)
    object txtEditor: TEdit
      Left = 13
      Top = 28
      Width = 239
      Height = 21
      Anchors = [akLeft, akRight, akBottom]
      TabOrder = 0
    end
    object btOk: TButton
      Left = 96
      Top = 58
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btOk'
      Default = True
      ModalResult = 1
      TabOrder = 1
      OnClick = btOkClick
    end
    object btCancel: TButton
      Left = 177
      Top = 58
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'btCancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
