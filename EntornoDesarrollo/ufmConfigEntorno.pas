unit ufmConfigEntorno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, JvBaseDlg, JvSelectDirectory,
  JvComponent, JvBrowseFolder, Mask, JvExMask, JvToolEdit, JvDialogs,
  ComCtrls, uEntornoDesarrollo, JvHLEditor, ufrmCompilador, JvExStdCtrls,
  JvListComb;

type
  TfmConfigEntorno = class (TForm)
    btEliminar: TButton;
    btNuevo: TButton;
    frmCompilador: TfrmCompilador;
    lbCompiladores: TListBox;
    lvIdiomasDisponibles: TJvImageListBox;
    sbCompilador: TScrollBox;
    tsCompiladores: TTabSheet;
    procedure cancelarCompilador(Sender: TObject);
    procedure eliminarCompilador(Sender: TObject);
    procedure guardarCompilador(Sender: TObject);
    procedure Modificado(Sender: TObject);
    procedure nuevoCompilador(Sender: TObject);
    procedure teclaCompilador(Sender: TObject; var Key: Word; Shift: 
            TShiftState);
    procedure verCompilador(Sender: TObject);
  private
    entorno: TEntornoDesarrollo;
    nombreCompilador: string;
    procedure habilitarSeleccion(Value:boolean);
    procedure propiedadesEditorDialogClosed(Sender: TObject; Form: TForm; 
            Apply: Boolean);
    procedure propiedadesEditorDialogPopup(Sender: TObject; Form: TForm);
  public
    procedure Execute(unEditor: TJvHLEditor);
    procedure Load;
    procedure Save;
  published
    lbDirectorioTrabajo: TLabel;
    lbIdiomaEntorno: TLabel;
    leDirTrabajo: TJvDirectoryEdit;
    pcConfiguracion: TPageControl;
    tsGeneral: TTabSheet;
  end;
  
var
  fmConfigEntorno: TfmConfigEntorno;

implementation

{$R *.dfm}

uses JvHLEditorPropertyForm, udmEntorno, gnugettext;

{
******************************* TfmConfigEntorno *******************************
}
procedure TfmConfigEntorno.cancelarCompilador(Sender: TObject);
begin
  if frmCompilador.modificado then
    if MessageDlg('¿Está seguro que desea cancelar las modificaciones realizadas?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      if frmCompilador.esNuevo then
        frmCompilador.Nuevo
      else
        verCompilador(Sender);
      habilitarSeleccion(True);
    end;
end;

procedure TfmConfigEntorno.eliminarCompilador(Sender: TObject);
begin
  if MessageDlg('¿Está seguro que desea eliminar el Compilador seleccionado?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    entorno.eliminarCompilador(lbCompiladores.Items.Strings[lbCompiladores.ItemIndex]);
    lbCompiladores.DeleteSelected;
  end;
end;

procedure TfmConfigEntorno.Execute(unEditor: TJvHLEditor);
var
  propiedadesEditor: TJvHLEdPropDlg;
begin
  entorno := TEntornoDesarrollo.Instance;
  with TJvHLEdPropDlg.Create(self) do
  begin
    JvHLEditor := unEditor;
    ReadFrom := rfHLEditor;
    Pages := [epEditor, epColors];
    OnDialogPopup := propiedadesEditorDialogPopup;
    OnDialogClosed := propiedadesEditorDialogClosed;
    Execute;
  end;
end;

procedure TfmConfigEntorno.guardarCompilador(Sender: TObject);
begin
  if frmCompilador.esNuevo then
    entorno.agregarCompilador(frmCompilador.getNombre, '', frmCompilador.getLenguaje, frmCompilador.getLineaComandos)
  else
    entorno.editarCompilador(nombreCompilador, frmCompilador.getNombre, '', frmCompilador.getLenguaje, frmCompilador.getLineaComandos);
  habilitarSeleccion(True);
end;

procedure TfmConfigEntorno.habilitarSeleccion(Value:boolean);
begin
  if Value then //lleno la lista
  begin
    lbCompiladores.Items.Clear;
    lbCompiladores.Items := entorno.mostrarCompiladores;
  end;
  lbCompiladores.Enabled := Value;
  btNuevo.Enabled := Value;
  btEliminar.Enabled := Value;
  frmCompilador.btGuardar.Enabled := not Value;
  frmCompilador.btCancelar.Enabled := not Value;
end;

procedure TfmConfigEntorno.Load;
var
  aux: TStringList;
  item : TJvImageItem;
  i: integer;
begin
  TranslateComponent(self);
  lvIdiomasDisponibles.Items.Clear;
  aux:= TStringList.Create;
  DefaultInstance.GetListOfLanguages('default', aux);
  for i:= 0 to aux.Count -1 do
  begin
    item := lvIdiomasDisponibles.Items.Add;
    item.Text := strIdiomas[buscarCodIdioma(aux.Strings[i])];
    item.ImageIndex := buscarIdxIdioma(aux.Strings[i]);
  end;

  leDirTrabajo.Text := entorno.getDirectorioTrabajo;
  frmCompilador.cbLenguajes.Items := entorno.mostrarLenguajes;
  lbCompiladores.Items := entorno.mostrarCompiladores;
  frmCompilador.onModificar := Modificado;
  i := lvIdiomasDisponibles.items.Count -1;
  while (i>=0) and (lvIdiomasDisponibles.items.Items[i].Text <> strIdiomas[buscarCodIdioma(entorno.mostrarIdiomaDesarrollo)]) do
    dec(i);
  lvIdiomasDisponibles.ItemIndex:= i;
end;

procedure TfmConfigEntorno.Modificado(Sender: TObject);
begin
  habilitarSeleccion(False);
end;

procedure TfmConfigEntorno.nuevoCompilador(Sender: TObject);
begin
  frmCompilador.Nuevo;
  sbCompilador.Show;
end;

procedure TfmConfigEntorno.propiedadesEditorDialogClosed(Sender: TObject; Form:
        TForm; Apply: Boolean);
begin
  if Apply then
  begin
    Save;
  end;
end;

procedure TfmConfigEntorno.propiedadesEditorDialogPopup(Sender: TObject; Form:
        TForm);
begin
  Load;
  tsGeneral.PageControl := TJvHLEditorParamsForm(Form).Pages;
  tsGeneral.PageIndex := 0;
  tsCompiladores.PageControl := TJvHLEditorParamsForm(Form).Pages;
  tsCompiladores.PageIndex := 1;
end;

procedure TfmConfigEntorno.Save;
begin
  entorno.configurarDirectorioTrabajoDesarrollo(leDirTrabajo.Text);
  entorno.cambiarIdiomaDesarrollo(codIdiomas[buscarStrIdioma(lvIdiomasDisponibles.Items.Items[lvIdiomasDisponibles.Itemindex].Text)]);
  UseLanguage(codIdiomas[buscarStrIdioma(lvIdiomasDisponibles.Items.Items[lvIdiomasDisponibles.Itemindex].Text)]);
end;

procedure TfmConfigEntorno.teclaCompilador(Sender: TObject; var Key: Word;
        Shift: TShiftState);
begin
  if key = VK_DELETE then
    eliminarCompilador(Sender);
end;

procedure TfmConfigEntorno.verCompilador(Sender: TObject);
begin
  {TODO: de la selección buscar en el entorno y obtener todos los parámetros del compilador}
  nombreCompilador := lbCompiladores.Items.Strings[lbCompiladores.ItemIndex];
  frmCompilador.setCompilador(nombreCompilador, entorno.mostrarLenguajeCompilador(nombreCompilador), entorno.mostrarLineaComandosCompilador(nombreCompilador));
  sbCompilador.Show;
end;

end.

