object frmZoomImg: TfrmZoomImg
  Left = 413
  Top = 229
  BorderStyle = bsToolWindow
  Caption = 'Zoom'
  ClientHeight = 58
  ClientWidth = 179
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ZoomSlide: TJvxSlider
    Left = 74
    Top = -1
    Width = 105
    Height = 33
    Increment = 1
    MinValue = 1
    MaxValue = 1000
    TabOrder = 0
    Value = 100
    OnChange = ZoomSlideChange
  end
  object VEditZoom: TJvValidateEdit
    Left = 7
    Top = 4
    Width = 65
    Height = 21
    CheckChars = '0123456789,'
    CriticalPoints.CheckPoints = cpNone
    CriticalPoints.ColorAbove = clBlue
    CriticalPoints.ColorBelow = clRed
    DisplayFormat = dfFloat
    EditText = '100'
    TabOrder = 1
    Text = '100'
    Value = 100.000000000000000000
  end
  object BtnOK: TButton
    Left = 7
    Top = 32
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 2
    OnClick = BtnOKClick
  end
end
