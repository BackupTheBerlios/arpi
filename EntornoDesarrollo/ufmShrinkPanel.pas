unit ufmShrinkPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, JvComponent, StdCtrls, JvButton, JvMenus,
  Buttons, JvSpeedButton, JvBitBtn, ImgList, ComCtrls, ExtCtrls,
  JvExControls, ELDsgnr, JvExButtons;

type
  TfmShrinkPanel = class (TForm)
  published
    btnIdiomas: TJvBitBtn;
    btnEjecutar: TJvBitBtn;
    btnGuardar: TJvBitBtn;
    Panel1: TPanel;
    Panel2: TPanel;
    panelDisenio: TELDesignPanel;
    btnCerrar: TSpeedButton;
    btnExpandir: TSpeedButton;
    TabControl: TTabControl;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mostrarIdiomas(unaListaIdiomas: TStringlist);
    procedure idiomSelec(Sender: TObject);
    procedure Panel1StartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure CerrarVentana(Sender: TObject);
    procedure CambiarIdioma;
  private
    procedure cambioDeIdioma(Sender: TObject);
  end;
  
implementation

{$R *.dfm}
uses ufmPrincipal, gnugettext, udmEntorno, uComponentesARPI;

{
******************************** TfmShrinkPanel ********************************
}
procedure TfmShrinkPanel.FormActivate(Sender: TObject);
begin
  fmEntornoDesarrollo.setActive(self);
end;

procedure TfmShrinkPanel.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TfmShrinkPanel.mostrarIdiomas(unaListaIdiomas: TStringlist);
var
  list : TPopupMenu;
  item : TMenuItem;
  i, j:integer;
begin
  list := TPopupMenu.Create(nil);
  list.Images := dmEntorno.ilIdiomasChicas;
  for i := 0 to unaListaIdiomas.Count -1 do
  begin
    item := TMenuItem.Create(list.Items);
    item.OnClick := cambioDeIdioma;
    item.Caption := getStrIdioma(unaListaIdiomas.Strings[i]);
    item.Hint := unaListaIdiomas.Strings[i];
    item.ImageIndex := buscarIdxIdioma(unaListaIdiomas.Strings[i]);
    list.Items.Add(item);
    if i = 0 then
      cambioDeIdioma(item); //Cambio el idioma al idioma por defecto
  end;
  btnIdiomas.DropDownMenu :=list;
end;

procedure TfmShrinkPanel.idiomSelec(Sender: TObject);
begin
  btnIdiomas.Glyph := TMenuItem(Sender).Bitmap;
end;

procedure TfmShrinkPanel.Panel1StartDock(Sender: TObject; var DragObject: 
        TDragDockObject);
begin
  DragObject:=TDragDockObject.Create(Self);
end;

procedure TfmShrinkPanel.CerrarVentana(Sender: TObject);
begin
  Close;
end;

procedure TfmShrinkPanel.cambioDeIdioma(Sender: TObject);
var
  i:integer;
begin
  btnIdiomas.Glyph:= nil;
  dmEntorno.ilIdiomasChicas.GetBitmap((Sender as TMenuItem).ImageIndex, btnIdiomas.Glyph);

  for i := 0 to panelDisenio.Form.Controls[0].ComponentCount - 1 do
    if supports(panelDisenio.Form.Controls[0].Components[i], IARPIControl) then
      (panelDisenio.Form.Controls[0].Components[i] as IARPIControl).setIdioma((Sender as TMenuItem).Hint);
end;

procedure TfmShrinkPanel.CambiarIdioma;
begin
  RetranslateComponent(self);
end;

end.
