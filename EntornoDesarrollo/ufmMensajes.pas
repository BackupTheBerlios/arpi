unit ufmMensajes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfmMensajes = class (TForm)
    procedure FormCreate(Sender: TObject);
    procedure CambiarIdioma;
  private
    function Getmensaje: string;
    procedure Setmensaje(const Value: string);
  published
    txtMensajes: TMemo;
    procedure agregar(valor: string);
    procedure limpiar;
    property mensaje: string read Getmensaje write Setmensaje;
  end;
  
implementation

uses gnugettext;

{$R *.dfm}

{ TfmMensajes }

{
********************************* TfmMensajes **********************************
}
procedure TfmMensajes.agregar(valor: string);
begin
  txtMensajes.Text := txtMensajes.Text + #13#10 + valor;
  Show;
end;

function TfmMensajes.Getmensaje: string;
begin
  result := txtMensajes.Text;
end;

procedure TfmMensajes.limpiar;
begin
  txtMensajes.Clear;
end;

procedure TfmMensajes.Setmensaje(const Value: string);
begin
  txtMensajes.Text := Value;
  Show;
end;

procedure TfmMensajes.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TfmMensajes.CambiarIdioma;
begin
  RetranslateComponent(self);
end;

end.
