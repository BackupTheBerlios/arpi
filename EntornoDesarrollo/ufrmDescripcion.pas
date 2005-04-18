unit ufrmDescripcion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmDescripcion = class (TFrame)
    lbAutor: TLabel;
    lbContacto: TLabel;
    lbDescricion: TLabel;
    lbExlicacion: TLabel;
    txtAutor: TEdit;
    txtContato: TMemo;
    txtDescripcion: TEdit;
    txtExplicacion: TMemo;
  end;
  
implementation

{$R *.dfm}

end.
