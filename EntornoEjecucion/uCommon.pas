unit uCommon;

interface

uses Windows;

type
  pnodo = ^nodo;
  nodo = record
    valor:pointer;
    siguiente: pnodo;
  end;

  RComplejo = Record
    real, imaginario: extended;
  end;

  RValorImagen = Record
    MDatos: Array of Array of Byte;
    Paleta: Array [0..255] of TRGBQuad;
    Mascara: Array of Array of Byte;
    Height, Width:integer;
  end;

implementation

end.

