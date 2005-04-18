object fmEditorPropiedades: TfmEditorPropiedades
  Left = 666
  Top = 313
  Width = 198
  Height = 421
  BorderStyle = bsSizeToolWin
  Caption = 'Editor de Propiedades'
  Color = clBtnFace
  DockSite = True
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object propiedades: TELPropertyInspector
    Left = 0
    Top = 0
    Width = 190
    Height = 387
    Splitter = 84
    Align = alClient
    BorderStyle = bsNone
    TabOrder = 0
    OnFilterProp = propiedadesFilterProp
  end
end
