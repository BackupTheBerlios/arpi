unit ufmStringsIdiomaDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ELPropInsp;

type

  TfmStringsIdiomaDlg = class (TForm)
    txtEditor: TMemo;
  private
    IdiomaActual: Integer;
    values: TStringList;
    function Getvalue: TStrings;
    procedure intGuardarValor;
    procedure Setvalue(const Value: TStrings);
  public
    function Execute: Boolean;
    property value: TStrings read Getvalue write Setvalue;
  published
    btCancel: TButton;
    btOk: TButton;
    selectorIdioma: TTabControl;
    procedure btOkClick(Sender: TObject);
    procedure cambiarIdioma(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure guardarValor(Sender: TObject; var AllowChange: Boolean);
  end;
  
implementation

{$R *.dfm}
uses jclStrings, udmEntorno;

{
***************************** TfmStringsIdiomaDlg ******************************
}
procedure TfmStringsIdiomaDlg.btOkClick(Sender: TObject);
begin
  intGuardarValor;
end;

procedure TfmStringsIdiomaDlg.cambiarIdioma(Sender: TObject);
begin
  idiomaActual := StrIndex(selectorIdioma.Tabs.Strings[selectorIdioma.TabIndex], strIdiomas);
  if idiomaActual >=0 then
    txtEditor.lines.CommaText := values.Values[codIdiomas[Tidiomas(idiomaActual)]];
end;

function TfmStringsIdiomaDlg.Execute: Boolean;
var
  i: TIdiomas;
begin
  selectorIdioma.Tabs.Clear;
  for i := low(TIdiomas) to high(TIdiomas) do
    if values.Values[codIdiomas[i]]<>'' then
      selectorIdioma.Tabs.Add(strIdiomas[i]);
  selectorIdioma.TabIndex := 0;
  Result := (ShowModal = mrOk);
end;

procedure TfmStringsIdiomaDlg.FormCreate(Sender: TObject);
begin
  {TODO: Cambiar por el idioma que corresponda}
  btOk .Caption := '&Aceptar';
  btCancel.Caption := '&Cancelar';
  Caption := 'Editar Propiedad';
end;

procedure TfmStringsIdiomaDlg.FormShow(Sender: TObject);
begin
  cambiarIdioma(Sender);
end;

function TfmStringsIdiomaDlg.Getvalue: TStrings;
begin
  result := values;
end;

procedure TfmStringsIdiomaDlg.guardarValor(Sender: TObject; var AllowChange: 
        Boolean);
begin
  intGuardarValor;
end;

procedure TfmStringsIdiomaDlg.intGuardarValor;
begin
  values.Values[codIdiomas[TIdiomas(idiomaActual)]] := txtEditor.lines.CommaText;
end;

procedure TfmStringsIdiomaDlg.Setvalue(const Value: TStrings);
begin
  Values := TStringlist(Value);
end;

end.
