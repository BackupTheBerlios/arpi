unit ufmConfigProyecto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ufrmDescripcion, ComCtrls, Buttons, ExtCtrls;

type
  TfmConfigProyecto = class (TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    btAgregar: TButton;
    btQuitar: TButton;
    cbIdiomaPredeterminado: TComboBoxEx;
    cbLenguaje: TComboBox;
    frmDescripcion: TfrmDescripcion;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lbNombre: TLabel;
    lvIdiomasDisponibles: TListView;
    lvIdiomasProyecto: TListView;
    PageControl1: TPageControl;
    Panel1: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tcDescripcion: TTabControl;
    txtNombre: TEdit;
    procedure btAgregarClick(Sender: TObject);
    procedure btQuitarClick(Sender: TObject);
    procedure cambiarIdioma(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure guardarValor(Sender: TObject; var AllowChange: Boolean);
    procedure lvIdiomasDisponiblesDragDrop(Sender, Source: TObject; X, Y: 
            Integer);
    procedure lvIdiomasProyectoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lvIdiomasProyectoDragOver(Sender, Source: TObject; X, Y: Integer; 
            State: TDragState; var Accept: Boolean);
    procedure PageControl1Change(Sender: TObject);
  private
    Descripcion: TStrings;
    IdiomaActual: string;
    procedure intGuardarValor;
  public
    function Execute(esNuevo: boolean= false): TModalResult;
  end;
  
var
  fmConfigProyecto: TfmConfigProyecto;

implementation

{$R *.dfm}

uses udmEntorno, uEntornoDesarrollo, gnugettext;

type
  TString = class (TObject)
  private
    Fvalor: string;
  public
    constructor create(unvalor:string); overload;
  published
    property valor: string read Fvalor write Fvalor;
  end;
  
{ TString }

{
*********************************** TString ************************************
}
constructor TString.create(unvalor:string);
begin
  valor:= unvalor;
end;


{ TfmProyecto }


{
****************************** TfmConfigProyecto *******************************
}
procedure TfmConfigProyecto.btAgregarClick(Sender: TObject);
var
  Item: TListItem;
begin
  Item := lvIdiomasDisponibles.Selected;
  while Item <> nil do
  begin
    with lvIdiomasProyecto.Items.Add do
    begin
      Caption := Item.Caption;
      ImageIndex := Item.ImageIndex;
    end;
    with cbIdiomaPredeterminado.ItemsEx.Add do
    begin
      Caption := Item.Caption;
      ImageIndex := Item.ImageIndex;
    end;
    Freeandnil(Item);
    if cbIdiomaPredeterminado.ItemsEx.Count = 1 then
      cbIdiomaPredeterminado.ItemIndex := 0;
    Item := lvIdiomasDisponibles.GetNextItem(Item, sdAll, [isSelected]);
  end;
end;

procedure TfmConfigProyecto.btQuitarClick(Sender: TObject);
var
  Item: TListItem;
  aux: Integer;
begin
  Item := lvIdiomasProyecto.Selected;
  while Item <> nil do
  begin
    with lvIdiomasDisponibles.Items.Add do
    begin
      Caption := Item.Caption;
      ImageIndex := Item.ImageIndex;
    end;
    aux := cbIdiomaPredeterminado.Items.IndexOf(Item.Caption);
    if cbIdiomaPredeterminado.ItemIndex = aux then
    begin
      cbIdiomaPredeterminado.ItemsEx.Delete(aux);
      if cbIdiomaPredeterminado.ItemsEx.Count > 0 then
        cbIdiomaPredeterminado.ItemIndex := 0
      else
      begin
        cbIdiomaPredeterminado.ItemIndex := -1;
        cbIdiomaPredeterminado.Text := '';
      end;
    end
    else
      cbIdiomaPredeterminado.ItemsEx.Delete(aux);
    Freeandnil(Item);
    Item := lvIdiomasProyecto.GetNextItem(Item, sdAll, [isSelected]);
  end;
end;

procedure TfmConfigProyecto.cambiarIdioma(Sender: TObject);
var
  aux: TStrings;
begin
  if tcDescripcion.TabIndex >=0 then
    idiomaActual := codIdiomas[buscarStrIdioma(tcDescripcion.Tabs.Strings[tcDescripcion.TabIndex])]
  else
    idiomaActual := '';
  if idiomaActual <>'' then
  begin
    aux := TStringlist.Create;
    aux.CommaText := Descripcion.Values[idiomaActual];
    with frmDescripcion do
    begin
      txtDescripcion.text:= aux.Values['descripcion'];
      txtAutor.Text := aux.Values['autor'];
      txtContato.Text := aux.Values['contacto'];
      txtExplicacion.Text := aux.Values['explicacion'];
    end;
  end;
end;

function TfmConfigProyecto.Execute(esNuevo: boolean= false): TModalResult;
var
  entorno: TEntornoDesarrollo;
  i, j: Integer;
  aux: TStringList;
  idiomas: TStrings;
begin
  entorno:= TEntornoDesarrollo.Instance;
  aux := TStringlist.Create;
  Show;
  cbLenguaje.Enabled := esNuevo;
  if not esNuevo then
  //inicializar las variables
  begin
    //Obtengo la lista de idiomas del proyecto
    idiomas := entorno.mostrarIdiomasProyecto;
    for i:= 0 to idiomas.Count - 1 do
    begin
      j:=0;
      while (j<lvIdiomasDisponibles.Items.Count) and
            (lvIdiomasDisponibles.Items[j].Caption <> strIdiomas[buscarCodIdioma(idiomas.Strings[i])]) do
        inc(j);
      if j<lvIdiomasDisponibles.Items.Count then
        lvIdiomasDisponibles.Items[j].Selected := true;
      txtNombre.Text := entorno.getAtributo('nombre', idiomas.Strings[i]);
      aux.Values['descripcion'] := entorno.getAtributo('descripcion', idiomas.Strings[i]);
      aux.Values['autor']:= entorno.getAtributo('autor', idiomas.Strings[i]);
      aux.Values['contacto']:= entorno.getAtributo('contacto', idiomas.Strings[i]);
      aux.Values['explicacion'] := entorno.getAtributo('explicacion', idiomas.Strings[i]);
      Descripcion.Values[idiomas.Strings[i]] := aux.CommaText;
    end;
    btAgregarClick(self);
    cbIdiomaPredeterminado.ItemIndex := cbIdiomaPredeterminado.Items.IndexOf(strIdiomas[buscarCodIdioma(entorno.mostrarIdiomaPredeterminadoProyecto)]);
  end;
  Hide;
  result := Showmodal;
  if result = mrOk then
  begin
    if esNuevo then
      entorno.nuevoProyecto(TString(cbLenguaje.Items.Objects[cbLenguaje.ItemIndex]).Valor);
    entorno.modificarValorAtributo('nombre',txtNombre.Text,'');
    for i:= 0 to lvIdiomasDisponibles.Items.Count - 1 do
      entorno.quitarIdiomaProyecto(codIdiomas[TIdiomas(lvIdiomasDisponibles.Items[i].ImageIndex)]);
    for i:= 0 to lvIdiomasProyecto.Items.Count - 1 do
    begin
      entorno.agregarIdiomaProyecto(codIdiomas[TIdiomas(lvIdiomasProyecto.Items[i].ImageIndex)]);
      aux.CommaText := Descripcion.Values[codIdiomas[TIdiomas(lvIdiomasProyecto.Items[i].ImageIndex)]];
      entorno.modificarValorAtributo('descripcion', aux.Values['descripcion'], codIdiomas[TIdiomas(lvIdiomasProyecto.Items[i].ImageIndex)]);
      entorno.modificarValorAtributo('autor', aux.Values['autor'], codIdiomas[TIdiomas(lvIdiomasProyecto.Items[i].ImageIndex)]);
      entorno.modificarValorAtributo('contacto', aux.Values['contacto'], codIdiomas[TIdiomas(lvIdiomasProyecto.Items[i].ImageIndex)]);
      entorno.modificarValorAtributo('explicacion', aux.Values['explicacion'], codIdiomas[TIdiomas(lvIdiomasProyecto.Items[i].ImageIndex)]);
    end;
  end;
end;

procedure TfmConfigProyecto.FormCloseQuery(Sender: TObject; var CanClose: 
        Boolean);
begin
  guardarValor(Sender, CanClose);
end;

procedure TfmConfigProyecto.FormCreate(Sender: TObject);
var
  aux: TStringList;
  item : TListItem;
  i: integer;
begin
  TranslateComponent(self);
  Descripcion:= TStringlist.Create;
  cbLenguaje.Clear;
  {TODO: Cargar la lista de lenguajes de la config del sistema}
  cbLenguaje.AddItem('Pascal / Object Pascal', TString.Create('pascal'));
  cbLenguaje.AddItem('C / ANSI C', TString.Create('c'));
  cbLenguaje.ItemIndex := 0;

  lvIdiomasDisponibles.Items.Clear;
  aux:= TStringList.Create;
  DefaultInstance.GetListOfLanguages('default', aux);
  for i:= 0 to aux.Count -1 do
  begin
    item := lvIdiomasDisponibles.Items.Add;
    item.Caption := strIdiomas[buscarCodIdioma(aux.Strings[i])];
    item.ImageIndex := buscarIdxIdioma(aux.Strings[i]);
  end;
end;

procedure TfmConfigProyecto.guardarValor(Sender: TObject; var AllowChange: 
        Boolean);
begin
  intGuardarValor;
end;

procedure TfmConfigProyecto.intGuardarValor;
var
  aux: TStrings;
begin
  aux := TStringlist.Create;
  with frmDescripcion do
  begin
    aux.Values['descripcion'] := txtDescripcion.text;
    aux.Values['autor']:= txtAutor.Text;
    aux.Values['contacto']:= txtContato.Text;
    aux.Values['explicacion'] := txtExplicacion.Text;
  end;
  Descripcion.Values[idiomaActual] := aux.CommaText;
end;

procedure TfmConfigProyecto.lvIdiomasDisponiblesDragDrop(Sender, Source: 
        TObject; X, Y: Integer);
begin
  btQuitarClick(nil);
end;

procedure TfmConfigProyecto.lvIdiomasProyectoDragDrop(Sender, Source: TObject; 
        X, Y: Integer);
begin
  btAgregarClick(nil);
end;

procedure TfmConfigProyecto.lvIdiomasProyectoDragOver(Sender, Source: TObject; 
        X, Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := (Source is TListView);
end;

procedure TfmConfigProyecto.PageControl1Change(Sender: TObject);
var
  i: Integer;
begin
  if PageControl1.ActivePageIndex > 0 then
  begin
    tcDescripcion.Tabs.Clear;
    for i:=0 to lvIdiomasProyecto.Items.Count -1 do
      tcDescripcion.Tabs.Add(lvIdiomasProyecto.Items[i].Caption);
    frmDescripcion.Visible := lvIdiomasProyecto.Items.Count>0;
    cambiarIdioma(sender);
  end
  else
    intguardarValor;
end;

end.
