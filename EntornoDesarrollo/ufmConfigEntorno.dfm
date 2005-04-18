object fmConfigEntorno: TfmConfigEntorno
  Left = 412
  Top = 179
  Width = 457
  Height = 301
  Caption = 'Configuraci'#243'n'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pcConfiguracion: TPageControl
    Left = 0
    Top = 0
    Width = 449
    Height = 267
    ActivePage = tsGeneral
    Align = alClient
    TabOrder = 0
    object tsGeneral: TTabSheet
      Caption = 'Configuraci'#243'n General'
      DesignSize = (
        441
        239)
      object lbDirectorioTrabajo: TLabel
        Left = 16
        Top = 16
        Width = 102
        Height = 13
        Caption = 'Directorio de Trabajo:'
      end
      object lbIdiomaEntorno: TLabel
        Left = 16
        Top = 48
        Width = 91
        Height = 13
        Caption = 'Idioma del Entorno:'
      end
      object leDirTrabajo: TJvDirectoryEdit
        Left = 128
        Top = 16
        Width = 285
        Height = 21
        ClipboardCommands = []
        DialogKind = dkWin32
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000000000000000000000000000000000008000FF8000FF
          8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF8000
          FF8000FF8000FF8000FF000000A86039A32E13A32E13A32E12A32F13A22F12A3
          2F13A22F13A32E13A22F13A22F13A32F13A32F13A32E13000000AC6239FEBC64
          AA3716D1BCBCD1BCBCD1BCBCD1BCBCD1BCBCD1BCBCD1BCBCD1BCBCD1BCBCD1BC
          BCD1BCBCD1BCBCAA3717AF653AFEC477B2401CFEFEFEFEFEFEFEFEFEFEFEFEFE
          FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFED1BCBCB2401CB3673BFEC477
          B94B21FEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFEFE
          FEFEFEFED1BCBCBB4B21B76A3CFECA82C25527FE903AFE903AFE8F3AFE903AFE
          8F3AFE8F3AFE8F3AFE8F39FE8F3AFE8F39FE8F3AFE8F3AC25427BC6D3DFECF8E
          C95E2CFE9A4DFE9B4DFE9B4DFE9A4DFE9B4DFE9A4DFE9A4DFE9B4DFE9B4DFE9B
          4DFE9A4DFE9B4DC95E2BBF6F3EFED59BD06730FEA965FEA964FEA964FEA864FE
          A965FEA964FEA964FEA964FEA964FEA965FEA964FEA864D0672FC5733FFEDCAA
          D56E34FEB980FEFDFDFEFDFDFEFDFDFEFDFDFEFDFDFEB880FEB980FEB880FEB8
          80FEB880FEB880D66E34C97640FEE1B8FEE2B8DA7437DA7437DA7437DA7437DA
          7437F0C699FEFDFDFEC99EFECA9CFECA9CFEC99CFEC99CDA7437CC7841FEE8C6
          FEE8C6FEE8C8FEE8C6FEE8C8FEE7C6FEE7C8DA7437F2D1AEFEFDFDFEFDFDFEFD
          FDFEFDFDFEDABBDA7437D17B42FEEDD5FEEDD5FEEDD5FEEDD5FEEDD5FEEDD5FE
          EDD5FEEED5DA7437DA7437DA7437DA7437DA7437DA7437DA7437D67F44FEF3E2
          FEF3E2FEF3E2FEF3E2FEF3E2FEF2E1FEF3E2FEF2E2FEF2E2FEF2E1FEF3E2FEF2
          E2FEF3E2FEF3E1D67F44DB8244FEF7EDFEF7EDFEF7EDFEF8EDFEF7EDFEF7EEFE
          F7EDBF9174DA8245DA8344DB8345DA8344DA8244DA82458000FF8000FFDE8545
          FEFCF7FEFBF7FEFCF7FEFBF7FEFBF7FEFBF7DE85458000FF8000FF8000FF8000
          FF8000FF8000FF8000FF8000FF8000FFE28846E28746E28747E38846E28846E2
          88468000FF8000FF8000FF8000FF8000FF8000FF8000FF8000FF}
        ImageKind = ikCustom
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object lvIdiomasDisponibles: TJvImageListBox
        Left = 128
        Top = 48
        Width = 284
        Height = 171
        Anchors = [akLeft, akTop, akRight, akBottom]
        DragMode = dmAutomatic
        Items = <>
        ImageHeight = 0
        ImageWidth = 0
        ButtonStyle = fsLighter
        Images = dmEntorno.ilIdiomasChicas
        ItemHeight = 17
        TabOrder = 1
      end
    end
    object tsCompiladores: TTabSheet
      Caption = 'Compiladores'
      ImageIndex = 1
      DesignSize = (
        441
        239)
      object lbCompiladores: TListBox
        Left = 8
        Top = 16
        Width = 161
        Height = 172
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        TabOrder = 0
        OnClick = verCompilador
        OnKeyDown = teclaCompilador
      end
      object sbCompilador: TScrollBox
        Left = 176
        Top = 16
        Width = 258
        Height = 216
        Anchors = [akLeft, akTop, akRight, akBottom]
        BorderStyle = bsNone
        TabOrder = 1
        Visible = False
        inline frmCompilador: TfrmCompilador
          Left = 0
          Top = 0
          Width = 258
          Height = 216
          Align = alClient
          Constraints.MinHeight = 200
          Constraints.MinWidth = 250
          TabOrder = 0
          inherited txtNombre: TEdit
            Width = 148
          end
          inherited cbLenguajes: TComboBox
            Width = 148
          end
          inherited txtLineaComandos: TMemo
            Width = 236
            Height = 100
          end
          inherited btGuardar: TButton
            Left = 91
            Top = 187
            OnClick = guardarCompilador
          end
          inherited btCancelar: TButton
            Left = 169
            Top = 187
            OnClick = cancelarCompilador
          end
        end
      end
      object btNuevo: TButton
        Left = 8
        Top = 203
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&Nuevo'
        TabOrder = 2
        OnClick = nuevoCompilador
      end
      object btEliminar: TButton
        Left = 96
        Top = 203
        Width = 75
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = '&Eliminar'
        TabOrder = 3
        OnClick = eliminarCompilador
      end
    end
  end
end
