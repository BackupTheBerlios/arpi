unit ufrmCompilador;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmCompilador = class (TFrame)
  private
    FModificado: Boolean;
    FNuevo: Boolean;
    FonModificar: TNotifyEvent;
    Loading: Boolean;
  public
    function getLenguaje: string;
    function getLineaComandos: string;
    function getNombre: string;
    procedure Nuevo;
    procedure setCompilador(const nombre, lenguaje, lineaComandos:string);
  published
    btCancelar: TButton;
    btGuardar: TButton;
    cbLenguajes: TComboBox;
    lbLenguaje: TLabel;
    lbLineaComandos: TLabel;
    lbNombre: TLabel;
    txtLineaComandos: TMemo;
    txtNombre: TEdit;
    procedure cambiarValor(Sender: TObject);
    property esNuevo: Boolean read FNuevo;
    property Modificado: Boolean read FModificado write FModificado;
    property onModificar: TNotifyEvent read FonModificar write FonModificar;
  end;
  
implementation

{$R *.dfm}

{ TfrmCompilador }

{
******************************** TfrmCompilador ********************************
}
procedure TfrmCompilador.cambiarValor(Sender: TObject);
begin
  if not Loading then
  begin
    Modificado := True;
    if Assigned(FonModificar) then
      FonModificar(Sender);
  end;
  //  btGuardar.Enabled := Modificado;
  //  btCancelar.Enabled := Modificado;
end;

function TfrmCompilador.getLenguaje: string;
begin
  result := cbLenguajes.Items.Strings[cbLenguajes.ItemIndex];
end;

function TfrmCompilador.getLineaComandos: string;
begin
  result := txtLineaComandos.Text;
end;

function TfrmCompilador.getNombre: string;
begin
  result := txtNombre.Text;
end;

procedure TfrmCompilador.Nuevo;
begin
  Loading := True;
  
  FNuevo := true;
  txtNombre.Clear;
  cbLenguajes.ItemIndex := -1;
  txtLineaComandos.Clear;
  Modificado := False;
  
  Loading := False;
end;

procedure TfrmCompilador.setCompilador(const nombre, lenguaje, 
        lineaComandos:string);
begin
  Loading := True;
  
  Modificado := False;
  txtNombre.Text := nombre;
  cbLenguajes.ItemIndex := cbLenguajes.Items.IndexOf(lenguaje);
  txtLineaComandos.Text := lineaComandos;
  FNuevo := False;
  
  Loading := False;
end;

end.
