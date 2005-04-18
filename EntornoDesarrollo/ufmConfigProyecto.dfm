object fmConfigProyecto: TfmConfigProyecto
  Left = 288
  Top = 209
  Width = 551
  Height = 443
  Caption = 'Configuraci'#243'n del Proyecto'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 371
    Width = 543
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      543
      38)
    object BitBtn1: TBitBtn
      Left = 365
      Top = 8
      Width = 81
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Aceptar'
      TabOrder = 0
      Kind = bkOK
    end
    object BitBtn2: TBitBtn
      Left = 453
      Top = 8
      Width = 81
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Cancelar'
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 543
    Height = 371
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    OnChange = PageControl1Change
    object TabSheet1: TTabSheet
      Caption = 'Datos Generales'
      DesignSize = (
        535
        343)
      object Label1: TLabel
        Left = 8
        Top = 48
        Width = 127
        Height = 13
        Caption = 'Lenguaje de Programaci'#243'n'
      end
      object Label2: TLabel
        Left = 8
        Top = 80
        Width = 98
        Height = 13
        Caption = 'Idiomas del Proyecto'
      end
      object Label3: TLabel
        Left = 320
        Top = 80
        Width = 93
        Height = 13
        Caption = 'Idiomas Disponibles'
      end
      object lbNombre: TLabel
        Left = 8
        Top = 16
        Width = 99
        Height = 13
        Caption = 'Nombre del Proyecto'
      end
      object Label4: TLabel
        Left = 8
        Top = 320
        Width = 108
        Height = 13
        Caption = 'Idioma Predeterminado'
      end
      object cbLenguaje: TComboBox
        Left = 144
        Top = 44
        Width = 177
        Height = 21
        Enabled = False
        ItemHeight = 13
        TabOrder = 1
        Text = 'Pascal'
        Items.Strings = (
          'C'
          'Pascal')
      end
      object lvIdiomasProyecto: TListView
        Left = 8
        Top = 96
        Width = 200
        Height = 209
        Anchors = [akLeft, akTop, akBottom]
        Columns = <>
        DragMode = dmAutomatic
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        FullDrag = True
        IconOptions.Arrangement = iaLeft
        IconOptions.WrapText = False
        LargeImages = dmEntorno.ilIdiomasGrandes
        MultiSelect = True
        ParentFont = False
        ShowColumnHeaders = False
        SmallImages = dmEntorno.ilIdiomasChicas
        SortType = stText
        TabOrder = 2
        ViewStyle = vsList
        OnDblClick = btQuitarClick
        OnDragDrop = lvIdiomasProyectoDragDrop
        OnDragOver = lvIdiomasProyectoDragOver
      end
      object lvIdiomasDisponibles: TListView
        Left = 320
        Top = 96
        Width = 200
        Height = 209
        Anchors = [akLeft, akTop, akBottom]
        Columns = <>
        DragMode = dmAutomatic
        IconOptions.Arrangement = iaLeft
        IconOptions.WrapText = False
        LargeImages = dmEntorno.ilIdiomasGrandes
        MultiSelect = True
        SmallImages = dmEntorno.ilIdiomasChicas
        SortType = stText
        TabOrder = 5
        ViewStyle = vsList
        OnDblClick = btAgregarClick
        OnDragDrop = lvIdiomasDisponiblesDragDrop
        OnDragOver = lvIdiomasProyectoDragOver
      end
      object txtNombre: TEdit
        Left = 144
        Top = 12
        Width = 375
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object btAgregar: TButton
        Left = 216
        Top = 96
        Width = 97
        Height = 25
        Caption = '< &Agregar'
        TabOrder = 3
        OnClick = btAgregarClick
      end
      object btQuitar: TButton
        Left = 216
        Top = 128
        Width = 97
        Height = 25
        Caption = '&Quitar >'
        TabOrder = 4
        OnClick = btQuitarClick
      end
      object cbIdiomaPredeterminado: TComboBoxEx
        Left = 144
        Top = 315
        Width = 177
        Height = 22
        ItemsEx = <>
        Anchors = [akLeft, akBottom]
        ItemHeight = 16
        TabOrder = 6
        Images = dmEntorno.ilIdiomasChicas
        DropDownCount = 8
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Descripci'#243'n del Proyecto'
      ImageIndex = 1
      object tcDescripcion: TTabControl
        Left = 0
        Top = 0
        Width = 535
        Height = 343
        Align = alClient
        Style = tsFlatButtons
        TabOrder = 0
        Tabs.Strings = (
          'Espa'#241'ol'
          'English')
        TabIndex = 0
        OnChange = cambiarIdioma
        OnChanging = guardarValor
        object Label5: TLabel
          Left = 96
          Top = 168
          Width = 351
          Height = 13
          Caption = 
            'El poyecto debe tener al menos un idioma para poder editar su de' +
            'scripci'#243'n'
        end
        inline frmDescripcion: TfrmDescripcion
          Left = 4
          Top = 27
          Width = 527
          Height = 312
          Align = alClient
          TabOrder = 0
          inherited txtAutor: TEdit
            Width = 368
          end
          inherited txtContato: TMemo
            Width = 368
          end
          inherited txtExplicacion: TMemo
            Width = 368
            Height = 185
          end
          inherited txtDescripcion: TEdit
            Width = 368
          end
        end
      end
    end
  end
end
