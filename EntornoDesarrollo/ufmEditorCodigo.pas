unit ufmEditorCodigo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvHLEditor, JvEditor, ComCtrls, JvExControls, JvComponent,
  JvEditorCommon;

type
  TfmEditorCodigo = class (TForm)
  private
    function getCodigo: WideString;
    procedure setCodigo(const Value: WideString);
  public
    procedure CambiarIdioma;
  published
    editor: TJvHLEditor;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    property codigoFuente: WideString read getCodigo write setCodigo;
  end;
  
implementation

{$R *.dfm}
uses ufmPrincipal, gnugettext;

{
******************************* TfmEditorCodigo ********************************
}
procedure TfmEditorCodigo.FormActivate(Sender: TObject);
begin
  fmEntornoDesarrollo.setActive(self);
end;

function TfmEditorCodigo.getCodigo: WideString;
begin
  result := editor.Lines.Text;
end;

procedure TfmEditorCodigo.setCodigo(const Value: WideString);
begin
  editor.Lines.Text := Value;
end;

procedure TfmEditorCodigo.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TfmEditorCodigo.CambiarIdioma;
begin
  RetranslateComponent(self);
end;

end.

