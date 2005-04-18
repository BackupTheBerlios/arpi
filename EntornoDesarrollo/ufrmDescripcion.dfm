object frmDescripcion: TfrmDescripcion
  Left = 0
  Top = 0
  Width = 466
  Height = 389
  TabOrder = 0
  DesignSize = (
    466
    389)
  object lbAutor: TLabel
    Left = 8
    Top = 36
    Width = 41
    Height = 13
    Caption = 'Autor/es'
  end
  object lbDescricion: TLabel
    Left = 8
    Top = 8
    Width = 99
    Height = 13
    Caption = 'Descripci'#243'n Acotada'
  end
  object lbContacto: TLabel
    Left = 8
    Top = 64
    Width = 95
    Height = 13
    Caption = 'Formas de Contacto'
  end
  object lbExlicacion: TLabel
    Left = 8
    Top = 120
    Width = 103
    Height = 13
    Caption = 'Descripci'#243'n Completa'
  end
  object txtAutor: TEdit
    Left = 152
    Top = 32
    Width = 307
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
  end
  object txtContato: TMemo
    Left = 152
    Top = 64
    Width = 307
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object txtExplicacion: TMemo
    Left = 152
    Top = 120
    Width = 307
    Height = 257
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'uno'
      'dos'
      'tres 2')
    TabOrder = 3
  end
  object txtDescripcion: TEdit
    Left = 152
    Top = 4
    Width = 307
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
  end
end
