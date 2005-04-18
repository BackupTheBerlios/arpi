unit uEntornoDesarrollo;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, uIdiomas, uLenguajes, uPortapapeles, uProyecto,
  XMLIntf, XMLDoc, uConsts;

type
  TEntornoDesarrollo = class (TObject)
  private
    controlIdioma: TControlIdiomas;
    directorioTrabajo: string;
    IdiomaActual: TIdioma;
    listaCompiladores: TListaCompiladores;
    listaIdiomas: TListaIdiomas;
    listaLenguajes: TListaLenguajes;
    portapapeles: Tportapapeles;
    proyecto: TProyecto;
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TEntornoDesarrollo;
    procedure setIdioma(unIdioma:TIdioma);
  public
    constructor Create;
    destructor Destroy; override;
    procedure abrirProyecto(nombreProyecto:string);
    procedure agregarCompilador(nombreCompilador, unaUbicacion, unLenguaje, 
            unaLineaComandos:string);
    procedure agregarIdiomaProyecto(unIdioma:string);
    procedure alinearComponentes(listaComponentes:TStrings; AVertical, 
            AHorizontal:string);
    procedure cambiarIdiomaDesarrollo(unIdioma:string);
    procedure cerrarProyecto;
    function compilarProyecto(unCompilador:string): string;
    procedure configurarDirectorioTrabajoDesarrollo(unaUbicacion: string);
    procedure editarCompilador(unCompilador, nombreCompilador, unaUbicacion, 
            unLenguaje, unaLineaComandos: string);
    procedure eliminarCompilador(unCompilador:string);
    procedure eliminarComponente(unComponente:string);
    procedure establecerIdiomaPredeterminadoProyecto(unIdioma: string);
    function getAtributo(unAtributo, unIdioma:string): string;
    function getDirectorioTrabajo: string;
    function getPropiedad(unaPropiedad, unIdioma:string): string; overload;
    function getPropiedad(unComponente, unaPropiedad, unIdioma:string): string; 
            overload;
    procedure guardarProyecto(nombreProyecto:string);
    procedure imprimirProyecto;
    function insertarComponente(tipoComponente:string; arriba:string; 
            izquierda:string): string;
    class function Instance: TEntornoDesarrollo;
    procedure modificarValorAtributo(unAtributo, unValor, unIdioma:string);
    function mostrarCodigoFuente: AnsiString;
    function mostrarCompiladores: TStrings;
    function mostrarFormulario: AnsiString;
    function mostrarIdiomaDesarrollo: string;
    function mostrarIdiomaPredeterminadoProyecto: string;
    function mostrarIdiomas: TStrings;
    function mostrarIdiomasProyecto: TStringList;
    function mostrarLenguajeCompilador(unCompilador:string): string;
    function mostrarLenguajes: TStrings;
    function mostrarLineaComandosCompilador(unCompilador:string): string;
    procedure nuevoProyecto(unLenguaje:string);
    procedure quitarIdiomaProyecto(unIdioma:string);
    class procedure ReleaseInstance;
    procedure setearCodigoFuente(unTexto:AnsiString);
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload;
    procedure setearPropiedad(unComponente, unaPropiedad, nuevoValor, 
            unIdioma:string); overload;
    procedure _deshacerEdicion;
    procedure _pegarTexto;
    procedure _rehacerEdicion;
  end;
  

procedure Register;

implementation

uses Variants, JclSysInfo, Math;

procedure Register;
begin
end;

{
****************************** TEntornoDesarrollo ******************************
}
constructor TEntornoDesarrollo.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only', 
          [ClassName]);
end;

constructor TEntornoDesarrollo.CreateInstance;
var
  idioma: TIdioma;
  lenguaje: TLenguaje;
  compilador: TCompilador;
  XMLDoc: IXMLDocument;
  config, lista: IXMLNode;
  i: Integer;
begin
  inherited Create;
  controlIdioma:= TControlIdiomas.Instance;
  listaCompiladores:= TListaCompiladores.Create;
  listaIdiomas:= TListaIdiomas.Create;
  listaLenguajes:= TListaLenguajes.Create;
    //  portapapeles:= Tportapapeles.Instance;
      { TODO :
      Determinar si el entorno muere porque no encuentra la
      configuraci�n o establece un alternativo }
        {Leer las variables guardadas}
        {Abro el archivo de config}
  if FileExists(ExtractFilePath(Application.ExeName)+ARCHIVOCONFIG) then
  try
    XMLDoc:= TXMLDocument.Create(ExtractFilePath(Application.ExeName)+ARCHIVOCONFIG);
        {Busco la secci�n Desarrollo}
      //config:= XMLDoc.DocumentElement.ChildNodes.FindNode('Desarrollo');
    config:= XMLDoc.DocumentElement;
  
      // listaDeIdiomas soportado por el Entorno
    lista := config.ChildNodes.FindNode('ListaIdiomas');
      if Assigned(lista) then
      for i:= 0 to lista.ChildNodes.Count -1 do
      begin
        idioma := controlIdioma.buscar(lista.ChildNodes.Nodes[i].Text);
        listaIdiomas.agregar(idioma);
      end;
  
    // IdiomaActual si no est� definido, espa�ol
    IdiomaActual := controlIdioma.buscar(VarToStrDef(config.Attributes['IdiomaActual'], 'es'));
  
  {TODO: Determinar si los lenguajes se almacenan en la config o no (ver guardar)}
  {    // listaDeLenguaje soportado por el Entorno
      lista := config.ChildNodes.FindNode('ListaLenguajes');
      if Assigned(lista) then
        for i:= 0 to lista.ChildNodes.Count -1 do
        begin
          lenguaje := TControlLenguajes.instance.buscar(lista.ChildNodes.Nodes[i].Text);
          listaLenguajes.agregar(lenguaje);
        end;}
  
      // listaDeCompiladores soportado por el Entorno
    lista := config.ChildNodes.FindNode('ListaCompiladores');
    if Assigned(lista) then
      for i:= 0 to lista.ChildNodes.Count -1 do
      begin
        compilador := TCompilador.Create;
        compilador.setXML(lista.ChildNodes.Nodes[i]);
        listaCompiladores.agregar(compilador);
      end;
  
      // directorioTrabajo
    directorioTrabajo := VarToStrDef(config.Attributes['directorioTrabajo'], GetWindowsTempFolder);
  except
    begin
        //Carga una configuraci�n alternativa!
      idioma := controlIdioma.buscar('esp');
      listaIdiomas.agregar(idioma);
      IdiomaActual := idioma;
      directorioTrabajo := ExtractFilePath(Application.ExeName);
      raise Exception.CreateFmt('El archivo %s no tiene la estructura esperada.',[ARCHIVOCONFIG]);
    end;
  end
  else
  begin
        //Carga una configuraci�n alternativa!
    idioma := controlIdioma.buscar('esp');
    listaIdiomas.agregar(idioma);
    IdiomaActual := idioma;
    directorioTrabajo := ExtractFilePath(Application.ExeName);
  end;
end;

destructor TEntornoDesarrollo.Destroy;
var
  XMLDoc: IXMLDocument;
  config, lista, nodo: IXMLNode;
  idioma: TIdioma;
  lenguaje: TLenguaje;
  compilador: TCompilador;
begin
  {Leer las variables guardadas}
  {Abro el archivo de config}
  XMLDoc:=NewXMLDocument;
    {Creo la secci�n Desarrollo}
  config:= XMLDoc.AddChild('Desarrollo');
  if not Assigned(config) then
    config:= XMLDoc.DocumentElement.AddChild('Desarrollo');
  
    // listaDeIdiomas soportado por el Entorno
  lista := config.ChildNodes.FindNode('ListaIdiomas');
  if not Assigned(lista) then
    lista := config.AddChild('ListaIdiomas')
  else
    lista.ChildNodes.Clear;
  idioma := listaIdiomas.primero;
  while assigned(idioma) do
  begin
    nodo := lista.AddChild('idioma');
    nodo.Text := idioma.getCodigo;
    idioma := listaIdiomas.siguiente;
  end;
  
    // IdiomaActual
  if Assigned(IdiomaActual) then
    config.Attributes['IdiomaActual'] := IdiomaActual.getCodigo;
  
  {TODO: Determinar si los lenguajes se almacenan en la config o no (ver leer)}
  {  // listaDeLenguaje soportado por el Entorno
    lista := config.ChildNodes.FindNode('ListaLenguajes');
    if not Assigned(lista) then
      lista := config.AddChild('ListaLenguajes')
    else
      lista.ChildNodes.Clear;
  
    lenguaje := listaLenguajes.primero;
    while assigned(lenguaje) do
    begin
      nodo := lista.AddChild('lenguaje');
      nodo.Text := lenguaje.getNombre;
      lenguaje := listaLenguajes.siguiente;
    end;}
  
    // listaDeCompiladores soportado por el Entorno
  lista := config.ChildNodes.FindNode('ListaCompiladores');
  if not Assigned(lista) then
    lista := config.AddChild('ListaCompiladores')
  else
    lista.ChildNodes.Clear;
  
  compilador := listaCompiladores.primero;
  while assigned(compilador) do
  begin
    compilador.getXML(lista);
    compilador := listaCompiladores.siguiente;
  end;
  
    // directorioTrabajo
  config.Attributes['directorioTrabajo'] := directorioTrabajo;
  
  XMLDoc.SaveToFile(ExtractFilePath(Application.ExeName)+ARCHIVOCONFIG);
  
    {Destruyo todos los objetos}
  controlIdioma.ReleaseInstance;
  FreeAndNil(listaCompiladores);
  FreeAndNil(listaIdiomas);
  FreeAndNil(listaLenguajes);
  FreeAndNil(portapapeles);
  inherited;
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
end;

procedure TEntornoDesarrollo.abrirProyecto(nombreProyecto:string);
begin
  try
    proyecto:=TProyecto.Create();
    proyecto.abrir(nombreProyecto);
  except
    FreeAndNil(proyecto);
    raise;
  end;
end;

class function TEntornoDesarrollo.AccessInstance(Request: Integer): 
        TEntornoDesarrollo;
  
  const FInstance: TEntornoDesarrollo = nil;
  
begin
  case Request of
    0 : ;
    1 : if not Assigned(FInstance) then FInstance := CreateInstance;
    2 : FInstance := nil;
  else
    raise Exception.CreateFmt('Illegal request %d in AccessInstance', 
            [Request]);
  end;
  Result := FInstance;
end;

procedure TEntornoDesarrollo.agregarCompilador(nombreCompilador, unaUbicacion, 
        unLenguaje, unaLineaComandos:string);
var
  compilador: TCompilador;
  controlLenguajes: TControlLenguajes;
  lenguaje: TLenguaje;
begin
  compilador:=TCompilador.Create();
  compilador.setNombre(nombreCompilador);
  compilador.setUbicacion(unaUbicacion);
  compilador.SetLineaComandos(unaLineaComandos);
  controlLenguajes:=TControlLenguajes.Instance;
  lenguaje :=controlLenguajes.buscar(unLenguaje);
  if Assigned(lenguaje) then
    compilador.SetLenguaje(lenguaje);
  listaCompiladores.agregar(compilador);
end;

procedure TEntornoDesarrollo.agregarIdiomaProyecto(unIdioma:string);
begin
  proyecto.agregarIdioma(unIdioma);
end;

procedure TEntornoDesarrollo.alinearComponentes(listaComponentes:TStrings; 
        AVertical, AHorizontal:string);
begin
  proyecto.alinearComponentes(listaComponentes, AVertical, AHorizontal);
end;

procedure TEntornoDesarrollo.cambiarIdiomaDesarrollo(unIdioma:string);
var
  idioma: TIdioma;
begin
  idioma:=controlIdioma.buscar(unIdioma);
    {TODO: Anular cuando se haya traducido el entorno}
  //  if listaIdiomas.existe(idioma) then
    setIdioma(idioma)
  //  else
  //    raise Exception.CreateFmt('El idioma %s no est� configurado en el proyecto actual', [unIdioma]);
end;

procedure TEntornoDesarrollo.cerrarProyecto;
begin
  FreeAndNil(proyecto);
end;

function TEntornoDesarrollo.compilarProyecto(unCompilador:string): string;
var
  compilador: TCompilador;
  nombre: string;
begin
  compilador := listaCompiladores.buscar(unCompilador);
  nombre := proyecto.generarCodigoFuente(compilador, directorioTrabajo);
  result := compilador.compilarProyecto(nombre);
end;

procedure TEntornoDesarrollo.configurarDirectorioTrabajoDesarrollo(
        unaUbicacion: string);
begin
  if DirectoryExists(unaUbicacion) then
      directorioTrabajo := unaUbicacion
  else
    raise Exception.Create('Error: El directorio de trabajo no existe.');
end;

procedure TEntornoDesarrollo.editarCompilador(unCompilador, nombreCompilador, 
        unaUbicacion, unLenguaje, unaLineaComandos: string);
var
  compilador: TCompilador;
  controlLenguajes: TControlLenguajes;
begin
  compilador:=listaCompiladores.buscar(unCompilador);
  compilador.setNombre(nombreCompilador);
  compilador.setUbicacion(unaUbicacion);
  compilador.SetLineaComandos(unaLineaComandos);
  controlLenguajes:=TControlLenguajes.Instance;
  compilador.SetLenguaje(controlLenguajes.buscar(unLenguaje));
  controlLenguajes.ReleaseInstance;
end;

procedure TEntornoDesarrollo.eliminarCompilador(unCompilador:string);
var
  compilador: TCompilador;
begin
  compilador := listaCompiladores.buscar(unCompilador);
  listaCompiladores.eliminar(compilador)
end;

procedure TEntornoDesarrollo.eliminarComponente(unComponente:string);
begin
  proyecto.eliminarComponente(unComponente);
end;

procedure TEntornoDesarrollo.establecerIdiomaPredeterminadoProyecto(unIdioma: 
        string);
begin
  proyecto.setIdiomaPredeterminado(unIdioma);
end;

function TEntornoDesarrollo.getAtributo(unAtributo, unIdioma:string): string;
begin
  result := proyecto.getAtributo(unAtributo, unIdioma);
end;

function TEntornoDesarrollo.getDirectorioTrabajo: string;
begin
  result := directorioTrabajo;
end;

function TEntornoDesarrollo.getPropiedad(unaPropiedad, unIdioma:string): string;
begin
  result := proyecto.getPropiedad(unaPropiedad, unIdioma);
end;

function TEntornoDesarrollo.getPropiedad(unComponente, unaPropiedad, 
        unIdioma:string): string;
begin
  result := proyecto.getPropiedad(unComponente, unaPropiedad, unIdioma);
end;

procedure TEntornoDesarrollo.guardarProyecto(nombreProyecto:string);
begin
  proyecto.guardar(nombreProyecto);
end;

procedure TEntornoDesarrollo.imprimirProyecto;
begin
  proyecto.imprimir;
end;

function TEntornoDesarrollo.insertarComponente(tipoComponente:string; 
        arriba:string; izquierda:string): string;
begin
  result := proyecto.insertarComponente(tipoComponente, arriba, izquierda);
end;

class function TEntornoDesarrollo.Instance: TEntornoDesarrollo;
begin
  Result := AccessInstance(1);
end;

procedure TEntornoDesarrollo.modificarValorAtributo(unAtributo, unValor, 
        unIdioma:string);
begin
  proyecto.modificarValorAtributo(unAtributo, unValor, unIdioma);
end;

function TEntornoDesarrollo.mostrarCodigoFuente: AnsiString;
begin
  result := proyecto.mostrarCodigoFuente;
end;

function TEntornoDesarrollo.mostrarCompiladores: TStrings;
var
  compilador: TCompilador;
begin
  result := TStringList.Create;
  compilador := listaCompiladores.primero;
  while Assigned(compilador) do
  begin
    result.Add(compilador.getNombre);
    compilador := listaCompiladores.siguiente;
  end;
end;

function TEntornoDesarrollo.mostrarFormulario: AnsiString;
begin
  result := proyecto.mostrarFormulario;
end;

function TEntornoDesarrollo.mostrarIdiomaDesarrollo: string;
begin
  if Assigned(IdiomaActual) then
    result := IdiomaActual.getCodigo
  else
    result :='';
end;

function TEntornoDesarrollo.mostrarIdiomaPredeterminadoProyecto: string;
begin
  result := proyecto.mostrarIdiomaPredeterminado;
end;

function TEntornoDesarrollo.mostrarIdiomas: TStrings;
var
  idioma: TIdioma;
begin
  result := nil;
  idioma:= listaIdiomas.primero;
  while assigned(Idioma) do
  begin
    if not assigned(result) then
      result := TStringList.Create;
    result.Add(idioma.getCodigo);
    idioma:= listaIdiomas.siguiente;
  end;
end;

function TEntornoDesarrollo.mostrarIdiomasProyecto: TStringList;
begin
  result := proyecto.mostrarIdiomas;
end;

function TEntornoDesarrollo.mostrarLenguajeCompilador(unCompilador:string): 
        string;
var
  compilador: TCompilador;
begin
  compilador:=listaCompiladores.buscar(unCompilador);
  If Assigned(compilador) then
    result := compilador.getLenguaje.getNombre
  else
    result := '';
end;

function TEntornoDesarrollo.mostrarLenguajes: TStrings;
begin
  result := TControlLenguajes.Instance.mostrarLenguajes;
end;

function TEntornoDesarrollo.mostrarLineaComandosCompilador(
        unCompilador:string): string;
var
  compilador: TCompilador;
begin
  compilador := listaCompiladores.buscar(unCompilador);
  If Assigned(compilador) then
    result := compilador.getLineaComandos
  else
    result := '';
end;

procedure TEntornoDesarrollo.nuevoProyecto(unLenguaje:string);
begin
  proyecto := TProyecto.Create;
  proyecto.setLenguaje(unLenguaje);
end;

procedure TEntornoDesarrollo.quitarIdiomaProyecto(unIdioma:string);
begin
  proyecto.quitarIdioma(unIdioma);
end;

class procedure TEntornoDesarrollo.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

procedure TEntornoDesarrollo.setearCodigoFuente(unTexto:AnsiString);
begin
  proyecto.setearCodigoFuente(unTexto);
end;

procedure TEntornoDesarrollo.setearPropiedad(unaPropiedad, nuevoValor, 
        unIdioma:string);
begin
  proyecto.setearPropiedad(unaPropiedad, nuevoValor, unIdioma);
end;

procedure TEntornoDesarrollo.setearPropiedad(unComponente, unaPropiedad, 
        nuevoValor, unIdioma:string);
begin
  proyecto.setearPropiedad(unComponente, unaPropiedad, nuevoValor, unIdioma);
end;

procedure TEntornoDesarrollo.setIdioma(unIdioma:TIdioma);
begin
  idiomaActual := unIdioma;
end;

procedure TEntornoDesarrollo._deshacerEdicion;
begin
end;

procedure TEntornoDesarrollo._pegarTexto;
begin
end;

procedure TEntornoDesarrollo._rehacerEdicion;
begin
end;

end.
