object frmCompilador: TfrmCompilador
  Left = 0
  Top = 0
  Width = 250
  Height = 205
  Constraints.MinHeight = 200
  Constraints.MinWidth = 250
  TabOrder = 0
  DesignSize = (
    250
    205)
  object lbNombre: TLabel
    Left = 8
    Top = 4
    Width = 37
    Height = 13
    Caption = 'Nombre'
  end
  object lbLenguaje: TLabel
    Left = 8
    Top = 32
    Width = 44
    Height = 13
    Caption = 'Lenguaje'
  end
  object lbLineaComandos: TLabel
    Left = 8
    Top = 56
    Width = 96
    Height = 13
    Caption = 'L'#237'nea de Comandos'
  end
  object txtNombre: TEdit
    Left = 96
    Top = 0
    Width = 140
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'txtNombre'
    OnChange = cambiarValor
  end
  object cbLenguajes: TComboBox
    Left = 96
    Top = 28
    Width = 140
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 1
    OnChange = cambiarValor
  end
  object txtLineaComandos: TMemo
    Left = 8
    Top = 72
    Width = 228
    Height = 97
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'txtLineaComandos')
    TabOrder = 2
    OnChange = cambiarValor
  end
  object btGuardar: TButton
    Left = 75
    Top = 180
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Guardar'
    Enabled = False
    TabOrder = 3
  end
  object btCancelar: TButton
    Left = 161
    Top = 180
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cancelar'
    Enabled = False
    TabOrder = 4
  end
end
