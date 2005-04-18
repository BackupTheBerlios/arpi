unit uFmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uEntornoDesarrollo, StdCtrls, ExtCtrls, ComCtrls, Contnrs, AppEvnts,
  ToolWin, ImgList, StdActns, ActnList, Menus, JvExExtCtrls,
  JvComponent, JvComponentPanel, JvCreateProcess, ufmShrinkPanel, ufmMensajes,
  ufmEditorCodigo, ufmEditorPropiedades, uComponentesARPI, ELDsgnr;

type

  TfmEntornoDesarrollo = class (TForm)
    Archivo1: TMenuItem;
    Edicin1: TMenuItem;
    Ver1: TMenuItem;
    Alinear1: TMenuItem;
    Ayuda1: TMenuItem;
    Nuevo1: TMenuItem;
    Abrir1: TMenuItem;
    Guardar1: TMenuItem;
    CompilarProyecto1: TMenuItem;
    Salir1: TMenuItem;
    aDeshacer1: TMenuItem;
    aRehacer1: TMenuItem;
    Separador1: TMenuItem;
    aCopiar1: TMenuItem;
    aCortar1: TMenuItem;
    aPegar1: TMenuItem;
    aEliminar1: TMenuItem;
    mSeparador2: TMenuItem;
    Alinearalagrilla1: TMenuItem;
    ConfigurarProyecto1: TMenuItem;
    ConfigurarEntorno1: TMenuItem;
    N1: TMenuItem;
    CambiarVista1: TMenuItem;
    Alinear2: TMenuItem;
    Alinearaladerecha1: TMenuItem;
    Alineararriba1: TMenuItem;
    Alinearabajo1: TMenuItem;
    Igualarespaciadohorizontal1: TMenuItem;
    Centrarverticalmente1: TMenuItem;
    Centrarhorizontalmente1: TMenuItem;
    Centrarverticalmente2: TMenuItem;
  private
    FActive: TForm;
    fmEditorCodigo: TfmEditorCodigo;
    fmEditorPropiedades: TfmEditorPropiedades;
    fmMensajes: TfmMensajes;
    formulario: TfmShrinkPanel;
    NombreComponente: string;
    Panel: TARPIPanel;
    procedure CerrarProyecto;
    procedure CrearProyecto(var Panel: TARPIPanel);
    procedure onFormularioResize(Sender: TObject);
    procedure onPanelResize(Sender: TObject);
  published
    aAbrir: TAction;
    aAlinearGrilla: TAction;
    abrir: TOpenDialog;
    aCambiarVista: TAction;
    acciones: TActionList;
    aCompilar: TAction;
    aConfEntorno: TAction;
    aConfProyecto: TAction;
    aCopiar: TAction;
    aCortar: TAction;
    actALBottom: TAction;
    actALHCenter: TAction;
    actALHCenterWindow: TAction;
    actALHSpace: TAction;
    actALLeft: TAction;
    actALRight: TAction;
    actALTop: TAction;
    actALVCenter: TAction;
    actALVCenterWindow: TAction;
    actALVSpace: TAction;
    aDeshacer: TAction;
    aEliminar: TAction;
    aGuardar: TAction;
    aNuevo: TAction;
    aPegar: TAction;
    aRehacer: TAction;
    aSalir: TFileExit;
    BarraHerramientas: TControlBar;
    diseniador: TELDesigner;
    entorno: TEntornoDesarrollo;
    guardar: TSaveDialog;
    ImageList1: TImageList;
    imagenes: TImageList;
    lenguetaComponentes: TTabControl;
    menu: TMainMenu;
    pnlComponentes: TJvComponentPanel;
    tbPrincipal: TToolBar;
    tbVer: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure aAlinearGrillaExecute(Sender: TObject);
    procedure AbrirProyecto(Sender: TObject);
    procedure aCambiarVistaExecute(Sender: TObject);
    procedure aCompilarExecute(Sender: TObject);
    procedure aConfEntornoExecute(Sender: TObject);
    procedure aConfProyectoExecute(Sender: TObject);
    procedure ActualizarPropiedades(Sender: TObject);
    procedure alinearComponentes(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure diseniadorControlInserted(Sender: TObject);
    procedure diseniadorControlInserting(Sender: TObject; var AControlClass: 
            TControlClass);
    procedure diseniadorGetUniqueName(Sender: TObject; const ABaseName: String; 
            var AUniqueName: String);
    procedure diseniadorKeyDown(Sender: TObject; var Key: Word; Shift: 
            TShiftState);
    procedure existeFormulario(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GuardarProyecto(Sender: TObject);
    procedure lenguetaComponentesChange(Sender: TObject);
    procedure NuevoProyecto(Sender: TObject);
    procedure setActive(unFormulario: TForm);
  end;
  

var
  fmEntornoDesarrollo: TfmEntornoDesarrollo;

implementation

uses JvstrUtil, JclStrings, Types, TypInfo, StrUtils, ufmConfigProyecto, 
     ufmConfigEntorno, gnugettext;

{$R *.DFM}
{$R ../../Recursos/Componentes/componentes.res}

{
***************************** TfmEntornoDesarrollo *****************************
}
procedure TfmEntornoDesarrollo.aAlinearGrillaExecute(Sender: TObject);
begin
  diseniador.SelectedControls.AlignToGrid;
end;

procedure TfmEntornoDesarrollo.AbrirProyecto(Sender: TObject);
  
  procedure StringToComponent(const Value: string; AComponent: TComponent);
  var
     Input,aux : TStream;
     Reader    : TReader;
  begin
    if not Assigned(AComponent) then
      exit;
    Aux := TStringStream.Create(Value);
    Input := TMemoryStream.Create;
    Aux.Position :=0;
    ObjectTextToResource(Aux, Input);
    Input.Position :=0;
    try
      Input.ReadResHeader;
      Reader := TReader.Create(Input, 4096);
          //Reader.OnFindMethod := FindMethod;
      Reader.ReadRootComponent(AComponent);
    finally
      Reader.Free;
      Input.Free;
    end;
  end;
  
  //  var
  //    Panel: TARPIPanel;
  
begin
  abrir.Title := _('Abrir Proyecto ARPI');
  abrir.Filter := _('Proyecto ARPI (*.xml)|*.xml|Todos los Archivos (*.*)|*.*');
  if abrir.Execute then
  begin
    cerrarProyecto;
    entorno.abrirProyecto(abrir.FileName);
    CrearProyecto(Panel);
    fmEditorCodigo.codigoFuente := entorno.mostrarCodigoFuente;
    StringToComponent(entorno.mostrarFormulario, Panel);

  end;
end;

procedure TfmEntornoDesarrollo.aCambiarVistaExecute(Sender: TObject);
  
  const
    i: integer = 0;
  
begin
  if FActive = fmEditorCodigo then
    formulario.BringToFront
  else if FActive = formulario then
    fmEditorCodigo.BringToFront;
end;

procedure TfmEntornoDesarrollo.aCompilarExecute(Sender: TObject);
begin
  if not Assigned(fmMensajes) then
    fmMensajes:= TfmMensajes.Create(self);
  fmMensajes.Limpiar;
  fmMensajes.agregar(DateTimeToStr(now)+': '+_('Compilar')+' --------------------');
  fmMensajes.agregar(entorno.compilarProyecto('delphi'));
end;

procedure TfmEntornoDesarrollo.aConfEntornoExecute(Sender: TObject);
begin
  fmConfigEntorno := TfmConfigEntorno.Create(Self);
  fmConfigEntorno.Execute(fmEditorCodigo.editor);
  ReTranslateComponent(self);
  fmEditorPropiedades.CambiarIdioma;
  fmMensajes.CambiarIdioma;
  fmEditorCodigo.CambiarIdioma;
end;

procedure TfmEntornoDesarrollo.aConfProyectoExecute(Sender: TObject);
begin
  with TfmConfigProyecto.Create(self) do
    Execute;
end;

procedure TfmEntornoDesarrollo.ActualizarPropiedades(Sender: TObject);
var
  LObjects: TList;
  aux: Boolean;
begin
  if fmEditorPropiedades.Visible then
  begin
    LObjects := TList.Create;
    try
      diseniador.SelectedControls.GetControls(LObjects);
      fmEditorPropiedades.propiedades.AssignObjects(LObjects);
    finally
      LObjects.Free;
    end;
  end;
  
  //Activo los botones de alineación
  //Si hay al menos un control seleccionado y no es el formulario
  aux := (diseniador.SelectedControls.Count > 0) and not(diseniador.SelectedControls.Items[0] is TARPIPanel);
  aAlinearGrilla.Enabled := aux;
  actALHCenterWindow.Enabled := aux;
  actALVCenterWindow.Enabled := aux;
  
  //Si hay más de dos controles seleccionados
  aux := diseniador.SelectedControls.Count > 1;
  actALLeft.Enabled := aux;
  actALRight.Enabled := aux;
  actALTop.Enabled := aux;
  actALBottom.Enabled := aux;
  actALHSpace.Enabled := aux;
  actALVSpace.Enabled := aux;
  actALHCenter.Enabled := aux;
  actALVCenter.Enabled := aux;
end;

procedure TfmEntornoDesarrollo.alinearComponentes(Sender: TObject);
var
  LHorzAlignType, LVertAlignType: TELDesignerAlignType;
begin
  LHorzAlignType := atNoChanges;
  LVertAlignType := atNoChanges;
  case TAction(Sender).Tag of
    0: LHorzAlignType := atLeftTop;
    1: LHorzAlignType := atRightBottom;
    2: LVertAlignType := atLeftTop;
    3: LVertAlignType := atRightBottom;
    4: LHorzAlignType := atSpaceEqually;
    5: LVertAlignType := atSpaceEqually;
    6: LHorzAlignType := atCenter;
    7: LVertAlignType := atCenter;
    8: LHorzAlignType := atCenterInWindow;
    9: LVertAlignType := atCenterInWindow;
  end;
  diseniador.SelectedControls.Align(LHorzAlignType, LVertAlignType);
end;

procedure TfmEntornoDesarrollo.Button1Click(Sender: TObject);
  
  function ComponentToString(Component: TComponent): string;
  var
    BinStream:TMemoryStream;
    StrStream: TStringStream;
    s: string;
  begin
    BinStream := TMemoryStream.Create;
    try
      StrStream := TStringStream.Create(s);
      try
        BinStream.WriteComponent(Component);
        BinStream.Seek(0, soFromBeginning);
        ObjectBinaryToText(BinStream, StrStream);
        StrStream.Seek(0, soFromBeginning);
        Result:= StrStream.DataString;
      finally
        StrStream.Free;
      end;
    finally
      BinStream.Free
    end;
  end;
  
begin
  showmessage(ComponentToString(diseniador.DesignControl));
end;

procedure TfmEntornoDesarrollo.CerrarProyecto;
begin
  fmEditorCodigo.Hide;
  fmEditorPropiedades.Hide;
  diseniador.Active := false;
  diseniador.DesignControl := nil;
  diseniador.DesignPanel := nil;
  FreeAndNil(formulario);
  entorno.cerrarProyecto;
end;

procedure TfmEntornoDesarrollo.CrearProyecto(var Panel: TARPIPanel);
begin
      //Muestro el editor de propiedades
  if fmEditorPropiedades.Tag = 0 then  //Sólo la primera vez lo ubico
  begin
    fmEditorPropiedades.Left:= 0;
    fmEditorPropiedades.Top := Height+2;
    fmEditorPropiedades.Tag := 1;
  end;
  fmEditorPropiedades.Show;

      //Muestro el editor del Código Fuente
  if fmEditorCodigo.Tag = 0 then //Sólo la primera vez lo ubico
  begin
    fmEditorCodigo.Top := Height+2;
    fmEditorCodigo.Left := fmEditorPropiedades.Width + fmEditorPropiedades.Left+2;
    fmEditorCodigo.Tag := 1;
  end;
  fmEditorCodigo.Show;

  //Creo el editor del Formulario
  formulario := TfmShrinkPanel.Create(Self);
  formulario.Top := Height+2;
  formulario.Left := fmEditorPropiedades.Width+fmEditorPropiedades.Left+2;
  formulario.Show;

  Panel := TARPIPanel.Create(formulario);
  Panel.Parent := formulario;
  Panel.Align := alClient;
  Panel.BevelOuter := bvNone;

  diseniador.Active :=false;
  diseniador.DesignPanel := formulario.panelDisenio;
  diseniador.DesignControl := panel;
  diseniador.Active :=true;

  panel.OnResize:= onPanelResize;
  formulario.panelDisenio.OnResize := onFormularioResize;
  formulario.mostrarIdiomas(entorno.mostrarIdiomasProyecto);
end;

procedure TfmEntornoDesarrollo.diseniadorControlInserted(Sender: TObject);
begin
  pnlComponentes.SetMainButton;
end;

procedure TfmEntornoDesarrollo.diseniadorControlInserting(Sender: TObject; var
        AControlClass: TControlClass);
begin
  //TARPILabel
  if pnlComponentes.Buttons[0].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[0].Hint));
    NombreComponente:=entorno.insertarComponente('label', '0','0');
  end
  //TARPIEdit
  else if pnlComponentes.Buttons[1].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[1].Hint));
    NombreComponente:=entorno.insertarComponente('edit', '0','0');
  end
  //TARPICheckBox
  else if pnlComponentes.Buttons[2].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[2].Hint));
    NombreComponente:=entorno.insertarComponente('checkbox', '0','0');
  end
  //TARPIComboBox
  else if pnlComponentes.Buttons[3].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[3].Hint));
    NombreComponente:=entorno.insertarComponente('combobox', '0','0');
  end
  //TARPIListBox
  else if pnlComponentes.Buttons[4].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[4].Hint));
    NombreComponente:=entorno.insertarComponente('listbox', '0','0');
  end
  //TARPISlider
  {  else if pnlComponentes.Buttons[5].Down then
    begin
      AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[5].Hint));
      NombreComponente:=entorno.insertarComponente('edit', '0','0');
    end
  //TARPIGrilla
    else if pnlComponentes.Buttons[6].Down then
    begin
      AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[6].Hint));
      NombreComponente:=entorno.insertarComponente('listbox', '0','0');
    end}
  //TARPIGroupBox
    else if pnlComponentes.Buttons[5{7}].Down then
    begin
      AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[5{7}].Hint));
      NombreComponente:=entorno.insertarComponente('radiogroup', '0','0');
    end
  //TARPIImagen
  else if pnlComponentes.Buttons[6{8}].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[6{8}].Hint));
    NombreComponente:=entorno.insertarComponente('imagen', '0','0');
  end
  //TARPIMatriz
  else if pnlComponentes.Buttons[7{9}].Down then
  begin
    AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[7{9}].Hint));
    NombreComponente:=entorno.insertarComponente('matriz', '0','0');
  end
  //TARPIValorHistograma
  {  else if pnlComponentes.Buttons[10].Down then
    begin
      AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[10].Hint));
      NombreComponente:=entorno.insertarComponente('listbox', '0','0');
    end
  //TARPIMaxMinHistograma
    else if pnlComponentes.Buttons[11].Down then
    begin
      AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[11].Hint));
      NombreComponente:=entorno.insertarComponente('listbox', '0','0');
    end
  //TARPIEqualizador
    else if pnlComponentes.Buttons[12].Down then
    begin
      AControlClass:=TControlClass(GetClass(pnlComponentes.Buttons[12].Hint));
      NombreComponente:=entorno.insertarComponente('listbox', '0','0');
    end}
end;

procedure TfmEntornoDesarrollo.diseniadorGetUniqueName(Sender: TObject; const 
        ABaseName: String; var AUniqueName: String);
begin
  AUniqueName := NombreComponente;
end;

procedure TfmEntornoDesarrollo.diseniadorKeyDown(Sender: TObject; var Key: Word;
        Shift: TShiftState);
var
  i: Integer;
  LObjects: TList;
begin
  if key = VK_Delete then
  begin
    LObjects := TList.Create;
    try
      diseniador.SelectedControls.GetControls(LObjects);
      for i:= 0 to LObjects.Count -1 do
        entorno.eliminarComponente(TControl(LObjects.Items[i]).Name);
    finally
      LObjects.Free;
    end;
  end;
end;

procedure TfmEntornoDesarrollo.existeFormulario(Sender: TObject);
var
  activo: Boolean;
begin
  activo := Assigned(fmEditorCodigo) and Assigned(formulario);
  aCambiarVista.Enabled := activo;
  aConfProyecto.Enabled := activo;
  aGuardar.Enabled := activo;
  aCompilar.Enabled := activo;
end;

procedure TfmEntornoDesarrollo.FormCreate(Sender: TObject);
var
  i: Integer;
  list, item: TMenuItem;
begin
  inherited;
  TranslateComponent(self);
  Application.Title := Caption;

  //Creo y cargo la paleta de componentes
  lenguetaComponentes.Tabs.Add(_('Estandar'));
  lenguetaComponentes.Tabs.Add(_('Imagen'));
  lenguetaComponentes.TabIndex :=0;
  lenguetaComponentesChange(nil);

  fmEditorPropiedades := TfmEditorPropiedades.Create(Application);
  fmEditorPropiedades.Hide;

  fmEditorCodigo := TfmEditorCodigo.Create(Application);
  fmEditorCodigo.Hide;

  fmMensajes:= TfmMensajes.Create(Application);
  fmMensajes.Hide;

  //Creo el entorno de desarrollo
  entorno := TEntornoDesarrollo.instance;
  UseLanguage(entorno.mostrarIdiomaDesarrollo);
  RetranslateComponent(self);
  fmEditorPropiedades.CambiarIdioma;
  fmMensajes.CambiarIdioma;
  fmEditorCodigo.CambiarIdioma;
end;

procedure TfmEntornoDesarrollo.FormDestroy(Sender: TObject);
begin
  CerrarProyecto;
  FreeAndNil(Entorno);
end;

procedure TfmEntornoDesarrollo.GuardarProyecto(Sender: TObject);
begin
  guardar.Title := _('Guardar Proyecto ARPI');
  guardar.Filter := _('Proyecto ARPI (*.xml)|*.xml|Todos los Archivos (*.*)|*.*');
  if guardar.Execute then
  begin
    entorno.setearCodigoFuente(fmEditorCodigo.codigoFuente);
    entorno.guardarProyecto(guardar.FileName);
  end;
end;

procedure TfmEntornoDesarrollo.lenguetaComponentesChange(Sender: TObject);
  
  const
    sRAControls = 'TARPILabel, TARPIEdit, TARPICheckBox, TARPICombobox, TARPIListbox, '+//, TARPISlider, TARPIGrilla'+
                  'TARPIRadioGroup, TARPIImagen, TARPIMatriz';
      sRAControls2= 'TARPIValorHistograma, TARPIMaxMinHistograma, TARPIEqualizador';
  var
    Comps : string;
    S : string;
    i : integer;
  
begin
  case lenguetaComponentes.TabIndex of
    0 : Comps := sRAControls;
  //    1 : Comps := sRAControls2;
    else Comps := '';
  end;
  pnlComponentes.ButtonCount := StrCharCount(Comps, ',')+1;
  pnlComponentes.FirstVisible := 0;
  i := 0;
  S := SubStr(Comps, i, ',');
  while S <> '' do
  begin
    pnlComponentes.Buttons[i].Hint := S;
    try
      pnlComponentes.Buttons[i].Glyph.LoadFromResourceName(HInstance, UpperCase(S));
    except
    end;
    inc(i);
    S := Trim(SubStr(Comps, i, ','));
  end;
end;

procedure TfmEntornoDesarrollo.NuevoProyecto(Sender: TObject);
begin
  {TODO: Hay que mostrar un formulario con las propiedades del proyecto:
  * Nombre
  * Atributos
  * Idiomas
  * Lenguaje}
  cerrarProyecto;
  with TfmConfigProyecto.Create(self) do
  try
    if Execute(true)=mrOk then
    begin
      CrearProyecto(Panel);
      fmEditorCodigo.codigoFuente := entorno.mostrarCodigoFuente;
    end;
  finally
    Free;
  end;
end;

procedure TfmEntornoDesarrollo.onFormularioResize(Sender: TObject);
begin
  Panel.Width := formulario.panelDisenio.Width;
  Panel.Height := formulario.panelDisenio.Height;
  fmEditorPropiedades.propiedades.Modified;
end;

procedure TfmEntornoDesarrollo.onPanelResize(Sender: TObject);
begin
  formulario.SetBounds(formulario.Left, formulario.Top, formulario.Width - formulario.panelDisenio.Width + panel.Width, formulario.Height - formulario.panelDisenio.Height + panel.Height);
end;

procedure TfmEntornoDesarrollo.setActive(unFormulario: TForm);
begin
  FActive := unFormulario;
end;

initialization
  TP_GlobalIgnoreClassProperty(TFont, 'Name');
end.

