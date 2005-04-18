unit ufmStringIdiomaDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ELPropInsp;

type
  TfmStringIdiomaDlg = class (TForm)
  private
    IdiomaActual: Integer;
    values: TStringList;
    function Getvalue: string;
    procedure intGuardarValor;
    procedure Setvalue(const Value: string);
  public
    function Execute: Boolean;
    property value: string read Getvalue write Setvalue;
  published
    btCancel: TButton;
    btOk: TButton;
    selectorIdioma: TTabControl;
    txtEditor: TEdit;
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
****************************** TfmStringIdiomaDlg ******************************
}
procedure TfmStringIdiomaDlg.btOkClick(Sender: TObject);
begin
  intGuardarValor;
end;

procedure TfmStringIdiomaDlg.cambiarIdioma(Sender: TObject);
begin
  idiomaActual := StrIndex(selectorIdioma.Tabs.Strings[selectorIdioma.TabIndex], strIdiomas);
  if idiomaActual >=0 then
    txtEditor.Text := values.Values[codIdiomas[Tidiomas(idiomaActual)]];
end;

function TfmStringIdiomaDlg.Execute: Boolean;
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

procedure TfmStringIdiomaDlg.FormCreate(Sender: TObject);
begin
  {TODO: Cambiar por el idioma que corresponda}
  btOk .Caption := '&Aceptar';
  btCancel.Caption := '&Cancelar';
  Caption := 'Editar Propiedad';
end;

procedure TfmStringIdiomaDlg.FormShow(Sender: TObject);
begin
  cambiarIdioma(Sender);
end;

function TfmStringIdiomaDlg.Getvalue: string;
begin
  result := StringsToStr(values, '|');
end;

procedure TfmStringIdiomaDlg.guardarValor(Sender: TObject; var AllowChange: 
        Boolean);
begin
  intGuardarValor;
end;

procedure TfmStringIdiomaDlg.intGuardarValor;
begin
  values.Values[codIdiomas[TIdiomas(idiomaActual)]] := txtEditor.Text;
end;

procedure TfmStringIdiomaDlg.Setvalue(const Value: string);
begin
  if not Assigned(values) then
    values := TStringList.Create;
  StrToStrings(Value,'|',values);
end;

end.
