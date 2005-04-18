unit ufmConfigMatriz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TfmPropiedadesMatriz = class (TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    EColumnas: TLabeledEdit;
    EFilas: TLabeledEdit;
    EValorInicial: TLabeledEdit;
    Label1: TLabel;
    procedure ComboBox1Change(Sender: TObject);
    procedure EValorInicialChange(Sender: TObject);
  private
    FColumnas: Integer;
    FTipoDato: string;
    FValorInicial: string;
    function GetColumnas: Integer;
    function GetFilas: Integer;
    procedure SetColumnas(const Value: Integer);
    procedure SetFilas(const Value: Integer);
    procedure SetTipoDato(const Value: string);
    procedure SetValorInicial(const Value: string);
  public
    function execute: Boolean;
    property Columnas: Integer read GetColumnas write SetColumnas;
    property Filas: Integer read GetFilas write SetFilas;
    property TipoDato: string read FTipoDato write SetTipoDato;
    property ValorInicial: string read FValorInicial write SetValorInicial;
  end;
  
var
  fmPropiedadesMatriz: TfmPropiedadesMatriz;

implementation

uses Math;

{$R *.dfm}

{
***************************** TfmPropiedadesMatriz *****************************
}
procedure TfmPropiedadesMatriz.ComboBox1Change(Sender: TObject);
begin
  //  TipoDato := LowerCase(ComboBox1.Items[ComboBox1.ItemIndex]);
  
  case ComboBox1.ItemIndex of
  0:tipoDato := 'numeroentero';
  1:tipoDato := 'texto';
  2:tipoDato := 'letra';
  3:tipoDato := 'complejo';
  4:tipoDato := 'numero';
  end
  
end;

procedure TfmPropiedadesMatriz.EValorInicialChange(Sender: TObject);
begin
  ValorInicial := EValorInicial.Text;
end;

function TfmPropiedadesMatriz.execute: Boolean;
begin
  result := ShowModal = mrOk;
  close;
end;

function TfmPropiedadesMatriz.GetColumnas: Integer;
begin
  Result := strToInt(EColumnas.Text);
end;

function TfmPropiedadesMatriz.GetFilas: Integer;
begin
  Result := strToInt(EFilas.text);
end;

procedure TfmPropiedadesMatriz.SetColumnas(const Value: Integer);
begin
  EColumnas.Text := intToStr(value);
end;

procedure TfmPropiedadesMatriz.SetFilas(const Value: Integer);
begin
  EFilas.Text := intTostr(value);
end;

procedure TfmPropiedadesMatriz.SetTipoDato(const Value: string);
var
  i: Integer;
  encontro: Boolean;
begin
  FTipoDato := Value;
  i := 0;
  encontro := false;
  while (i < ComboBox1.Items.Count) and (not encontro) do
  begin
    If LowerCase(ComboBox1.Items[i]) = LowerCase(Value) then
    begin
      ComboBox1.ItemIndex := i;
      encontro := true;
    end;
    inc(i);
  end;
  //  ComboBox1.SelText:= ComboBox1.Items[;
end;

procedure TfmPropiedadesMatriz.SetValorInicial(const Value: string);
begin
  FValorInicial := Value;
  EValorInicial.Text := Value;
end;

end.
