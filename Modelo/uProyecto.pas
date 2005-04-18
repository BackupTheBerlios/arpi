unit uProyecto;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, XMLIntf, uTipos, uIdiomas, uLista, uLenguajes, uComponentes,
  uConsts;

type
  TAtributo = class (TObject)
  private
    nombre: string;
    valor: TTexto;
  public
    constructor Create;
    destructor Destroy; override;
    function getNombre: string;
    function getValor(unIdioma:string): string;
    procedure getXML(var XML:IXMLNode);
    procedure setNombre(unValor:string);
    procedure setValor(unValor, unIdioma:string); overload;
    procedure setValor(unValor: String; unaListaIdiomas:TListaIdiomas); 
            overload;
    procedure setXML(XML:IXMLNode);
  end;
  
  TListaAtributos = class (TLista)
  public
    procedure agregar(unAtributo: TAtributo); reintroduce; overload;
    function buscar(unAtributo:string): TAtributo;
    function primero: TAtributo;
    function siguiente: TAtributo;
  end;
  
  TAlineacion = class (TObject)
  public
    procedure alinear(listaComponentes:TListaComponentes); virtual; abstract;
  end;
  
  TClaseAlineacion = class of TAlineacion;

  TListaClaseAlineacion = class (TListaClases)
  public
    function agregar(nombreClase:string; unaClase:TClaseAlineacion): Integer;
    function buscar(nombreClase:string): TClaseAlineacion;
    function existe(unaClase:string): Boolean;
    procedure insertar(nombreClase:string; unaClase:TClaseAlineacion; index: 
            integer);
  end;
  
  TAlineacionSinCambios = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionIzquierda = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionIgualarEspaciadoV = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionIgualarEspaciadoH = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionDerecha = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionCentroV = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionCentroH = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionCentradoVFormulario = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionCentradoHFormulario = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionArriba = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TAlineacionAbajo = class (TAlineacion)
  public
    procedure alinear(listaComponentes:TListaComponentes); override;
  end;
  
  TPaletaComponentes = class (TObject)
  private
    listaComponentes: TListaClasesComponentes;
  protected
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TPaletaComponentes;
  public
    constructor Create;
    destructor Destroy; override;
    function getComponente(tipoComponente:string; listaIdiomas:TListaIdiomas): 
            TComponente;
    class function Instance: TPaletaComponentes;
    class procedure ReleaseInstance;
  end;
  
  TControlAlineacion = class (TObject)
  protected
    lista: TListaClaseAlineacion;
    constructor CreateInstance;
    class function AccessInstance(Request: Integer): TControlAlineacion;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregarAlineacion(nombre:string; clase:TClaseAlineacion);
    procedure alinear(listaComponentes:TListaComponentes; alineacion:string);
    class function Instance: TControlAlineacion;
    class procedure ReleaseInstance;
  end;
  
  TEditorCodigo = class (TObject)
  private
    codigoFuente: AnsiString;
  public
    constructor Create;
    destructor Destroy; override;
    procedure imprimirProyecto;
    function mostrarCodigoFuente: AnsiString;
    procedure setearCodigoFuente(unTexto:AnsiString);
    procedure _deshacerEdicion;
    procedure _rehacerEdicion;
  end;
  
  TFormularioInterfaz = class (TObject)
  private
    alto: TPropiedad;
    ancho: TPropiedad;
    listaComponentes: TListaComponentes;
    listaParametros: TListaParametros;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregarIdioma(idioma:TIdioma);
    procedure alinearComponentes(listaComponentes:TStrings; AVertical, 
            AHorizontal:string);
    procedure eliminarComponente(unComponente:string);
    function getDefinicionParametrosDefinicion(unCompilador:TCompilador): 
            string;
    function getDefinicionParametrosEntrada(unCompilador:TCompilador): string;
    function getDefinicionParametrosSalida(unCompilador:TCompilador): string;
    function getFormularioDFM: AnsiString;
    procedure getFormularioXML(var XML: IXMLNode);
    function getListaParametros: TListaParametros;
    function getPropiedad(unaPropiedad, unIdioma:string): string; overload;
    function getPropiedad(unComponente, unaPropiedad, unIdioma:string): string; 
            overload;
    procedure ingresarValor(unComponente, unValor, unIdioma:string);
    function insertarComponente(tipoComponente, arriba, izquierda:string; 
            listaIdiomas:TListaIdiomas): string;
    procedure mostrar(unIdioma: TIdioma);
    procedure quitarIdioma(idioma:TIdioma);
    procedure quitarVinculacion(unComponente:string);
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload;
    procedure setearPropiedad(unComponente, unaPropiedad, nuevoValor, 
            unIdioma:string); overload;
    function setFormulario(XML: IXMLNode; listaIdiomas: TListaIdiomas): 
            AnsiString;
    procedure setListaResultados(listaResultados: TListaParametros);
  end;
  
  TProyecto = class (TObject)
  private
    controlIdiomas: TControlIdiomas;
    editorCodigo: TEditorCodigo;
    formularioInterfaz: TFormularioInterfaz;
    idiomaActual: TIdioma;
    idiomaPredeterminado: TIdioma;
    lenguaje: TLenguaje;
    listaAtributos: TListaAtributos;
    listaIdiomas: TListaIdiomas;
    nombreArchivo: string;
    nombreProyecto: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure abrir(nombreArchivo:string);
    procedure agregarIdioma(unIdioma:string);
    procedure alinearComponentes(listaComponentes:Tstrings; AVertical, 
            AHorizontal:string);
    procedure deshacerEdicion;
    procedure eliminarComponente(unComponente:string);
    function generarCodigoFuente(unCompilador: TCompilador; 
            unDirectorio:string): string;
    function getAtributo(unAtributo, unIdioma:string): string;
    function getPropiedad(unaPropiedad, unIdioma:string): string; overload;
    function getPropiedad(unComponente, unaPropiedad, unIdioma:string): string; 
            overload;
    procedure guardar(nombreArchivo:string);
    procedure imprimir;
    function insertarComponente(tipoComponente:string; arriba:string; 
            izquierda:string): string;
    procedure modificarValorAtributo(unAtributo, unValor, unIdioma:string);
    function mostrarCodigoFuente: AnsiString;
    function mostrarFormulario: AnsiString;
    function mostrarIdiomaPredeterminado: string;
    function mostrarIdiomas: TStringList;
    procedure quitarIdioma(unIdioma: string);
    procedure rehacerEdicion;
    procedure setearCodigoFuente(unTexto:AnsiString);
    procedure setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string); 
            overload;
    procedure setearPropiedad(unComponente, unaPropiedad, nuevoValor, 
            unIdioma:string); overload;
    procedure setIdioma(unIdioma:string);
    procedure setIdiomaPredeterminado(unIdioma:string);
    procedure setLenguaje(unLenguaje:string);
  end;
  

procedure Register;

implementation

uses XMLDoc, xmldom, Variants;

procedure Register;
begin
end;

procedure RegistrarAlineacion(nombre:string; clase: TClaseAlineacion);
begin
  TControlAlineacion.Instance.AgregarAlineacion(nombre, clase);
end;

{
********************************** TAtributo ***********************************
}
constructor TAtributo.Create;
begin
  valor := TTexto.Create
end;

destructor TAtributo.Destroy;
begin
  FreeandNil(valor);
end;

function TAtributo.getNombre: string;
begin
  result := nombre;
end;

function TAtributo.getValor(unIdioma:string): string;
begin
  result := valor.getValor(unIdioma);
end;

procedure TAtributo.getXML(var XML:IXMLNode);
var
  atributo: IXMLNode;
begin
  atributo:=XML.AddChild('atributo');
  atributo.Attributes['nombre']:=nombre;
  valor.getXML(atributo);
end;

procedure TAtributo.setNombre(unValor:string);
begin
  nombre := unValor;
end;

procedure TAtributo.setValor(unValor, unIdioma:string);
begin
  valor.setValor(unValor, unIdioma);
end;

procedure TAtributo.setValor(unValor: String; unaListaIdiomas:TListaIdiomas);
begin
  valor.setValor(unValor, unaListaIdiomas);
end;

procedure TAtributo.setXML(XML:IXMLNode);
begin
  nombre:= XML.GetAttributeNS('nombre','');
  valor.setXML(XML.ChildNodes.First);
end;

{
******************************* TListaAtributos ********************************
}
procedure TListaAtributos.agregar(unAtributo: TAtributo);
begin
  inherited agregar(unAtributo);
end;

function TListaAtributos.buscar(unAtributo:string): TAtributo;
var
  aux: TAtributo;
begin
  aux := primero;
  while Assigned(aux) and (aux.getNombre <> unAtributo) do
    aux := siguiente;
  result:=aux;
end;

function TListaAtributos.primero: TAtributo;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result :=TAtributo(aux)
  else
    result := nil;
end;

function TListaAtributos.siguiente: TAtributo;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result := TAtributo(aux)
  else
    result := nil;
end;

{
**************************** TAlineacionSinCambios *****************************
}
procedure TAlineacionSinCambios.alinear(listaComponentes:TListaComponentes);
begin
  //
end;

{
***************************** TAlineacionIzquierda *****************************
}
procedure TAlineacionIzquierda.alinear(listaComponentes:TListaComponentes);
var
  componente: TComponente;
  izquierda: string;
begin
  //Se presupone que al menos hay un componente seleccionado
  componente:= listaComponentes.primero;
  izquierda := componente.getPropiedad(IDIZQUIERDA, '');
  componente:= listaComponentes.siguiente;
  while Assigned(componente) do
  begin
    componente.setearPropiedad(IDIZQUIERDA, izquierda, '');
    componente:= listaComponentes.siguiente;
  end;
end;

{
************************* TAlineacionIgualarEspaciadoV *************************
}
procedure TAlineacionIgualarEspaciadoV.alinear(
        listaComponentes:TListaComponentes);
var
  componente: TComponente;
  suma, min, max, cant, dif: Integer;
begin
  {
  si es "igualar espaciado", para cada componente de la listaComponentes se sum�
  componente.alto, luego se rest� esa suma a selecci�n.alto, se dividi� por la
  selecci�n.cantidad -1 y por �ltimo, para cada componente ordenado en forma
  creciente por componente.arriba y a partir del segundo, se asign� a
  componente.arriba el valor de anterior.arriba + anterior.alto + el resultado de
  la divisi�n. (modificaci�n de atributo)
  }
  suma:= 0;
  cant:= 0;
  min := MaxInt;
  max := MinInt;
  componente:= listaComponentes.primero;
  while Assigned(componente) do
  begin
    inc(cant);
    suma:= suma + StrToInt(componente.getPropiedad(IDALTO, ''));
    if min < StrToInt(componente.getPropiedad(IDARRIBA, '')) then
      min := StrToInt(componente.getPropiedad(IDARRIBA, ''));
    if max > StrToInt(componente.getPropiedad(IDARRIBA, '')) + StrToInt(componente.getPropiedad(IDALTO, '')) then
      max := StrToInt(componente.getPropiedad(IDARRIBA, '')) + StrToInt(componente.getPropiedad(IDALTO, ''));
    componente:= listaComponentes.siguiente;
  end;
  
  listaComponentes.ordenar;
  
  if cant>2 then
  begin
    dif := (max-min-suma) div (cant-1);
  
    componente:= listaComponentes.primero;
    suma:=StrToInt(componente.getPropiedad(IDARRIBA, ''));
    repeat
      componente.setearPropiedad(IDARRIBA, inttostr(suma),'');
      suma:= suma + StrToInt(componente.getPropiedad(IDALTO, '')) + dif;
      componente:= listaComponentes.siguiente;
    until not Assigned(componente);
  end;
end;

{
************************* TAlineacionIgualarEspaciadoH *************************
}
procedure TAlineacionIgualarEspaciadoH.alinear(
        listaComponentes:TListaComponentes);
var
  componente: TComponente;
  suma, min, max, cant, dif: Integer;
begin
  {
  si es "igualar espaciado", para cada componente de la listaComponentes se sum�
  componente.alto, luego se rest� esa suma a selecci�n.alto, se dividi� por la
  selecci�n.cantidad -1 y por �ltimo, para cada componente ordenado en forma
  creciente por componente.arriba y a partir del segundo, se asign� a
  componente.arriba el valor de anterior.arriba + anterior.alto + el resultado de
  la divisi�n. (modificaci�n de atributo)
  }
  suma:= 0;
  cant:= 0;
  min := MaxInt;
  max := MinInt;
  componente:= listaComponentes.primero;
  while Assigned(componente) do
  begin
    inc(cant);
    suma:= suma + StrToInt(componente.getPropiedad(IDANCHO, ''));
    if min < StrToInt(componente.getPropiedad(IDIZQUIERDA, '')) then
      min := StrToInt(componente.getPropiedad(IDIZQUIERDA, ''));
    if max > StrToInt(componente.getPropiedad(IDIZQUIERDA, '')) + StrToInt(componente.getPropiedad(IDANCHO, '')) then
      max := StrToInt(componente.getPropiedad(IDIZQUIERDA, '')) + StrToInt(componente.getPropiedad(IDANCHO, ''));
    componente:= listaComponentes.siguiente;
  end;
  
  listaComponentes.ordenar;
  
  if cant>2 then
  begin
    dif := (max-min-suma) div (cant-1);
  
    componente:= listaComponentes.primero;
    suma:=StrToInt(componente.getPropiedad(IDIZQUIERDA, ''));
    repeat
      componente.setearPropiedad(IDIZQUIERDA, inttostr(suma),'');
      suma:= suma + StrToInt(componente.getPropiedad(IDANCHO, '')) + dif;
      componente:= listaComponentes.siguiente;
    until not Assigned(componente);
  end;
end;

{
****************************** TAlineacionDerecha ******************************
}
procedure TAlineacionDerecha.alinear(listaComponentes:TListaComponentes);
var
  componente: TComponente;
  derecha: Integer;
begin
  {
  "	si es "derecha", para cada componente de la listaComponentes se asign� a
  componente.izquierda el valor de primero.izquierda + primero.izquierda -
  componente.izquierda. (modificaci�n de atributo)
  }
    //Se presupone que al menos hay un componente seleccionado
  componente:= listaComponentes.primero;
  derecha := strtoInt(componente.getPropiedad(IDIZQUIERDA, ''))+strtoInt(componente.getPropiedad(IDANCHO, ''));
  componente:= listaComponentes.siguiente;
  while Assigned(componente) do
  begin
    componente.setearPropiedad(IDIZQUIERDA, IntToStr(derecha-strtoInt(componente.getPropiedad(IDANCHO, ''))), '');
    componente:= listaComponentes.siguiente;
  end;
end;

{
****************************** TAlineacionCentroV ******************************
}
procedure TAlineacionCentroV.alinear(listaComponentes:TListaComponentes);
var
  componente: TComponente;
  medio: Integer;
begin
  //Se presupone que al menos hay un componente seleccionado
  {"si es "centro", para cada componente de la listaComponentes se asign� a
  componente.arriba el valor de primero.arriba+primero.alto/2-componente.alto/2}
  componente:= listaComponentes.primero;
  medio := strtoInt(componente.getPropiedad(IDARRIBA, '')) +
            strtoInt(componente.getPropiedad(IDALTO, '')) div 2;
  componente:= listaComponentes.siguiente;
  while Assigned(componente) do
  begin
    componente.setearPropiedad(IDARRIBA, IntToStr(medio - StrToInt(componente.getPropiedad(IDALTO, ''))), '');
    componente:= listaComponentes.siguiente;
  end;
end;

{
****************************** TAlineacionCentroH ******************************
}
procedure TAlineacionCentroH.alinear(listaComponentes:TListaComponentes);
var
  componente: TComponente;
  medio: Integer;
begin
  //Se presupone que al menos hay un componente seleccionado
  {"si es "centro", para cada componente de la listaComponentes se asign� a
  componente.izq el valor de primero.izq+primero.ancho/2-componente.ancho/2}
  componente:= listaComponentes.primero;
  medio := strtoInt(componente.getPropiedad(IDIZQUIERDA, '')) +
            strtoInt(componente.getPropiedad(IDANCHO, '')) div 2;
  componente:= listaComponentes.siguiente;
  while Assigned(componente) do
  begin
    componente.setearPropiedad(IDIZQUIERDA, IntToStr(medio - StrToInt(componente.getPropiedad(IDANCHO, ''))), '');
    componente:= listaComponentes.siguiente;
  end;
end;

{
************************ TAlineacionCentradoVFormulario ************************
}
procedure TAlineacionCentradoVFormulario.alinear(
        listaComponentes:TListaComponentes);
begin
  { TODO :  }
end;

{
************************ TAlineacionCentradoHFormulario ************************
}
procedure TAlineacionCentradoHFormulario.alinear(
        listaComponentes:TListaComponentes);
begin
  { TODO :  }
end;

{
****************************** TAlineacionArriba *******************************
}
procedure TAlineacionArriba.alinear(listaComponentes:TListaComponentes);
var
  componente: TComponente;
  arriba: string;
begin
  //Se presupone que al menos hay un componente seleccionado
  componente:= listaComponentes.primero;
  arriba := componente.getPropiedad(IDARRIBA, '');
  componente:= listaComponentes.siguiente;
  while Assigned(componente) do
  begin
    componente.setearPropiedad(IDARRIBA, arriba, '');
    componente:= listaComponentes.siguiente;
  end;
end;

{
******************************* TAlineacionAbajo *******************************
}
procedure TAlineacionAbajo.alinear(listaComponentes:TListaComponentes);
var
  componente: TComponente;
  abajo: Integer;
begin
  {
  "	si es "abajo", para cada componente de la listaComponentes se asign� a
  componente.arriba el valor de primero.arriba + primero.alto -
  componente.alto. (modificaci�n de atributo)
  }
    //Se presupone que al menos hay un componente seleccionado
  componente:= listaComponentes.primero;
  abajo := strtoInt(componente.getPropiedad(IDARRIBA, ''))+strtoInt(componente.getPropiedad(IDALTO, ''));
  componente:= listaComponentes.siguiente;
  while Assigned(componente) do
  begin
    componente.setearPropiedad(IDARRIBA, IntToStr(abajo-strtoInt(componente.getPropiedad(IDALTO, ''))), '');
    componente:= listaComponentes.siguiente;
  end;
end;

{
****************************** TPaletaComponentes ******************************
}
constructor TPaletaComponentes.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only', 
          [ClassName]);
end;

constructor TPaletaComponentes.CreateInstance;
begin
  inherited Create;
  listaComponentes:= TListaClasesComponentes.Create;
end;

destructor TPaletaComponentes.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  FreeAndNil(listaComponentes);
  inherited Destroy;
end;

class function TPaletaComponentes.AccessInstance(Request: Integer): 
        TPaletaComponentes;
  
  const FInstance: TPaletaComponentes = nil;
  
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

function TPaletaComponentes.getComponente(tipoComponente:string; 
        listaIdiomas:TListaIdiomas): TComponente;
begin
  if lowercase(tipoComponente)='checkbox' then
    result:=TCompCheckBox.Create(listaIdiomas)
  else if lowercase(tipoComponente)='combobox' then
    result:=TCompComboBox.Create(listaIdiomas)
  else if lowercase(tipoComponente)='edit' then
    result:=TCompEdit.Create(listaIdiomas)
  else if lowercase(tipoComponente)='grilla' then
    result:=TCompGrilla.Create(listaIdiomas)
  else if lowercase(tipoComponente)='histograma' then
    result:=TCompHistograma.Create(listaIdiomas)
  else if lowercase(tipoComponente)='imagen' then
    result:=TCompImagen.Create(listaIdiomas)
  else if lowercase(tipoComponente)='matriz' then
    result:=TCompMatriz.Create(listaIdiomas)
  else if lowercase(tipoComponente)='valorhistograma' then
    result:=TCompValorHistograma.Create(listaIdiomas)
  else if lowercase(tipoComponente)='minmaxHistrograma' then
    result:=TCompMinMaxHistograma.Create(listaIdiomas)
  else if lowercase(tipoComponente)='radiogroup' then
    result:=TCompRadioGroup.Create(listaIdiomas)
  else if lowercase(tipoComponente)='label' then
    result:=TCompLabel.Create(listaIdiomas)
  else if lowercase(tipoComponente)='listbox' then
    result:=TCompListBox.Create(listaIdiomas)
  else if lowercase(tipoComponente)='slider' then
    result:=TCompSlider.Create(listaIdiomas)
  else
    raise Exception.CreateFmt('No se puede crear el componente %s',[tipoComponente]);
end;

class function TPaletaComponentes.Instance: TPaletaComponentes;
begin
  Result := AccessInstance(1);
end;

class procedure TPaletaComponentes.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

{
****************************** TControlAlineacion ******************************
}
constructor TControlAlineacion.Create;
begin
  inherited Create;
  raise Exception.CreateFmt('Access class %s through Instance only', 
          [ClassName]);
end;

constructor TControlAlineacion.CreateInstance;
begin
  inherited Create;
  lista := TListaClaseAlineacion.Create;
end;

destructor TControlAlineacion.Destroy;
begin
  if AccessInstance(0) = Self then AccessInstance(2);
  inherited Destroy;
  FreeAndNil(lista);
end;

class function TControlAlineacion.AccessInstance(Request: Integer): 
        TControlAlineacion;
  
  const FInstance: TControlAlineacion = nil;
  
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

procedure TControlAlineacion.agregarAlineacion(nombre:string; 
        clase:TClaseAlineacion);
begin
  if not lista.existe(lowercase(nombre)) then
    lista.agregar(lowercase(nombre), clase)
  else
    raise Exception.CreateFmt('La alineaci�n %s ya se encuentra en la lista del controlAlineaci�n',[nombre]);
end;

procedure TControlAlineacion.alinear(listaComponentes:TListaComponentes; 
        alineacion:string);
var
  cmdAlinear: TAlineacion;
  i: Integer;
  aux: TObject;
begin
  if lista.existe(alineacion) then
  begin
    cmdAlinear := TAlineacion(lista.buscar(alineacion).Create);
    cmdAlinear.alinear(listaComponentes);
    cmdAlinear.Destroy;
  end
  else
    raise Exception.CreateFmt('El tipo de alineaci�n %s no es un tipo definido o v�lido',[alineacion]);
end;

class function TControlAlineacion.Instance: TControlAlineacion;
begin
  Result := AccessInstance(1);
end;

class procedure TControlAlineacion.ReleaseInstance;
begin
  AccessInstance(0).Free;
end;

{
******************************** TEditorCodigo *********************************
}
constructor TEditorCodigo.Create;
begin
  {TODO: Creo el EditorCodigoFuente?}
end;

destructor TEditorCodigo.Destroy;
begin
  {TODO: Se destruye el EditorCodigoFuente?}
end;

procedure TEditorCodigo.imprimirProyecto;
begin
  {TODO: Imprimir Poryecto}
end;

function TEditorCodigo.mostrarCodigoFuente: AnsiString;
begin
  result := codigoFuente;
end;

procedure TEditorCodigo.setearCodigoFuente(unTexto:AnsiString);
begin
  codigoFuente := unTexto;
end;

procedure TEditorCodigo._deshacerEdicion;
begin
end;

procedure TEditorCodigo._rehacerEdicion;
begin
end;

{
***************************** TFormularioInterfaz ******************************
}
constructor TFormularioInterfaz.Create;
begin
  alto:= TPropiedad.Create('numeroEntero');
  alto.setNombre('height');
  alto.setValor('200','');
  ancho:= TPropiedad.Create('numeroEntero');
  ancho.setNombre('width');
  ancho.setValor('200','');
  listaComponentes:=TlistaComponentes.Create;
  listaParametros:=TListaParametros.Create;
end;

destructor TFormularioInterfaz.Destroy;
var
  componente: TComponente;
begin
  //Destruyo los componentes
  componente :=listaComponentes.primero;
  while assigned(componente) do
  begin
        componente.Destroy;
        componente :=listaComponentes.siguiente;
  end;
  listaComponentes.Destroy;
end;

procedure TFormularioInterfaz.agregarIdioma(idioma:TIdioma);
var
  componente: TComponente;
begin
  componente := listaComponentes.primero;
  while Assigned(componente) do
  begin
       componente.agregarIdioma(idioma);
       componente := listaComponentes.siguiente;
  end;
end;

procedure TFormularioInterfaz.alinearComponentes(listaComponentes:TStrings; 
        AVertical, AHorizontal:string);
var
  i: Integer;
  componente: TComponente;
  controlAlineacion: TControlAlineacion;
  listaAuxiliar: TListaComponentes;
begin
  listaAuxiliar:=TListaComponentes.Create();
  for i:= 0 to listaComponentes.count -1 do
  begin
      componente:=self.listaComponentes.Buscar(listaComponentes[i]);
      if assigned(componente) then
         listaAuxiliar.agregar(componente);
  end;
  controlAlineacion:=TControlAlineacion.Instance;
  controlAlineacion.alinear(listaAuxiliar, AVertical);
  controlAlineacion.alinear(listaAuxiliar, AHorizontal);
  self.listaComponentes.ordenar; //Alineo los componentes
end;

procedure TFormularioInterfaz.eliminarComponente(unComponente:string);
var
  componente: TComponente;
begin
  componente:=listaComponentes.buscar(unComponente);
  listaComponentes.eliminar(componente);
  //  FreeAndNil(componente);
end;

function TFormularioInterfaz.getDefinicionParametrosDefinicion(
        unCompilador:TCompilador): string;
var
  componente: TComponente;
  parametro: TParametro;
begin
  componente := listaComponentes.primero;
  result:='';
  while assigned(componente) do
  begin
    parametro:= componente.getParametro;
    if assigned(parametro) then
      result:=result+unCompilador.parseParametroDefinicion(parametro.getTipo, parametro.getNombre, componente.getParametro(''));
    componente := listaComponentes.siguiente;
  end;
end;

function TFormularioInterfaz.getDefinicionParametrosEntrada(
        unCompilador:TCompilador): string;
var
  componente: TComponente;
  parametro: TParametro;
begin
  componente := listaComponentes.primero;
  result:='';
  while assigned(componente) do
  begin
    parametro:= componente.getParametro;
    if assigned(parametro) then
      result:=result+unCompilador.parseParametroEntrada(parametro.getTipo, Parametro.getNombre, componente.getParametro(''));
    componente := listaComponentes.siguiente;
  end;
end;

function TFormularioInterfaz.getDefinicionParametrosSalida(
        unCompilador:TCompilador): string;
var
  componente: TComponente;
  parametro: TParametro;
begin
  componente := listaComponentes.primero;
  result:='';
  while assigned(componente) do
  begin
    parametro:= componente.getParametro;
    if assigned(parametro) then
      result:=result+unCompilador.parseParametroSalida(parametro.getTipo, Parametro.getNombre, componente.getParametro(''));
    componente := listaComponentes.siguiente;
  end;
end;

function TFormularioInterfaz.getFormularioDFM: AnsiString;
var
  aux: AnsiString;
  componente: TComponente;
begin
  result := 'object ArpiPanel:TArpiPanel ' + ancho.getNombre + ' = ' + ancho.getValor('') + ' ' + alto.getNombre +' = ' + alto.getValor('');
  componente := listaComponentes.primero;
  while assigned(componente) do
  begin
    result := result + ' ' + componente.getDFM;
    componente := listaComponentes.siguiente;
  end;
  result := result + ' end';
end;

procedure TFormularioInterfaz.getFormularioXML(var XML: IXMLNode);
var
  componente: TComponente;
  formulario: IXMLNode;
begin
  formulario:= XML.AddChild('formularioInterfaz');
  ancho.getXML(formulario);
  alto.getXML(formulario);
  componente := listaComponentes.primero;
  while assigned(componente) do
  begin
    componente.getXML(formulario);
    componente := listaComponentes.siguiente;
  end;
end;

function TFormularioInterfaz.getListaParametros: TListaParametros;
var
  componente: TComponente;
  ListaParametrosAux: TListaParametros;
  aux: TParametro;
begin
  ListaParametrosAux:=TListaParametros.Create;
  componente := listaComponentes.primero;
  while Assigned(componente) do
  begin
    aux := componente.getParametro;
    if assigned(aux) then
      ListaParametrosAux.agregar(aux);
    componente := listaComponentes.siguiente;
  end;
  result:= ListaParametrosAux;
end;

function TFormularioInterfaz.getPropiedad(unaPropiedad, unIdioma:string): 
        string;
begin
  if lowercase(unaPropiedad) = 'height' then
    result := alto.getValor(unIdioma)
  else if lowercase(unaPropiedad) = 'width' then
    result := ancho.getValor(unIdioma)
  else
    raise Exception.CreateFmt('La propiedad %s no es parte del Formulario', [unaPropiedad]);
end;

function TFormularioInterfaz.getPropiedad(unComponente, unaPropiedad, 
        unIdioma:string): string;
var
  componente: TComponente;
begin
  componente:= listaComponentes.buscar(unComponente);
  if Assigned(componente) then
    result := componente.getPropiedad(unaPropiedad, unIdioma)
  else
    raise Exception.CreateFmt('El componente %s no se encuentra en el formulario', [unComponente]);
end;

procedure TFormularioInterfaz.ingresarValor(unComponente, unValor, 
        unIdioma:string);
var
  componente: TComponente;
begin
  componente := listaComponentes.buscar(unComponente);
  if Assigned(componente) then
    componente.setearParametro(unValor, unIdioma)
  else
    raise Exception.CreateFmt('El componente %s no se encuentra en el formulario', [unComponente]);
end;

function TFormularioInterfaz.insertarComponente(tipoComponente, arriba, 
        izquierda:string; listaIdiomas:TListaIdiomas): string;
var
  unComponente: TComponente;
  paletaComponentes: TPaletaComponentes;
begin
  paletaComponentes:=TpaletaComponentes.Instance;
  unComponente:=paletaComponentes.getComponente(tipoComponente, listaIdiomas);
  unComponente.setearPropiedad(IDARRIBA, arriba, listaIdiomas);
  unComponente.setearPropiedad(IDIZQUIERDA, izquierda, listaIdiomas);
  listaComponentes.agregar(unComponente);
  listaComponentes.ordenar; //Alineo los componentes
  result := unComponente.getNombre;
end;

procedure TFormularioInterfaz.mostrar(unIdioma: TIdioma);
var
  componente: TComponente;
begin
  {TODO: esto funciona as�?????}
  componente := listaComponentes.primero;
  while Assigned(Componente) do
  begin
    componente.mostrar(unIdioma);
    componente := listaComponentes.siguiente;
  end;
end;

procedure TFormularioInterfaz.quitarIdioma(idioma:TIdioma);
var
  componente: TComponente;
begin
  componente := listaComponentes.primero;
  while Assigned(componente) do
  begin
     componente.quitarIdioma(idioma);
     componente := listaComponentes.siguiente;
  end;
end;

procedure TFormularioInterfaz.quitarVinculacion(unComponente:string);
var
  componente: TComponente;
begin
  componente := listaComponentes.buscar(unComponente);
  if Assigned(componente) then
    componente.quitarVinculacion
  else
    raise Exception.CreateFmt('El componente %s no se encuentra en el formulario', [unComponente]);
end;

procedure TFormularioInterfaz.setearPropiedad(unaPropiedad, nuevoValor, 
        unIdioma:string);
begin
  if lowercase(unaPropiedad) = 'height' then
    alto.setValor(nuevoValor, unIdioma)
  else if lowercase(unaPropiedad) = 'width' then
    ancho.setValor(nuevoValor, unIdioma)
  else
    raise Exception.CreateFmt('La propiedad %s no es parte del Formulario', [unaPropiedad]);
end;

procedure TFormularioInterfaz.setearPropiedad(unComponente, unaPropiedad, 
        nuevoValor, unIdioma:string);
var
  componente: TComponente;
begin
  componente:= listaComponentes.buscar(unComponente);
  if Assigned(componente) then
  begin
    componente.setearPropiedad(unaPropiedad, nuevoValor, unIdioma);
    listaComponentes.ordenar; //Alineo los componentes
  end
  else
    raise Exception.CreateFmt('El componente %s no se encuentra en el formulario', [unComponente]);
end;

function TFormularioInterfaz.setFormulario(XML: IXMLNode; listaIdiomas: 
        TListaIdiomas): AnsiString;
var
  componente: TComponente;
  i, j: Integer;
begin
  ancho.setXML(XML.ChildNodes.Nodes[0]);
  alto.setXML(XML.ChildNodes.Nodes[1]);
  for i:= 2 to XML.ChildNodes.Count-1 do
  begin
    componente:= TPaletaComponentes.CreateInstance.getComponente(XML.ChildNodes.Nodes[i].Attributes['tipo'],listaIdiomas);
    componente.setXML(XML.ChildNodes.Nodes[i]);
    listaComponentes.agregar(componente);
  end;
end;

procedure TFormularioInterfaz.setListaResultados(listaResultados: 
        TListaParametros);
var
  parametro: TParametro;
  componente: TComponente;
begin
  parametro:=listaResultados.primero;
  while Assigned(parametro) do
  begin
    componente := listaComponentes.buscar(parametro.getNombre);
    if Assigned(Componente) then
      componente.setearParametro(parametro.getValor(''),'')
    else
      {TODO: genero una exception}
    ;
    parametro:=listaResultados.siguiente;
  end;
end;

{
********************************** TProyecto ***********************************
}
constructor TProyecto.Create;
begin
  editorCodigo:= TeditorCodigo.Create;
  formularioInterfaz:= TformularioInterfaz.Create;
  controlIdiomas:=TControlIdiomas.Instance;
  listaIdiomas:= TListaIdiomas.Create;
  listaAtributos:= TlistaAtributos.Create;
end;

destructor TProyecto.Destroy;
var
  atributo: TAtributo;
begin
  atributo := listaAtributos.primero;
  while assigned(atributo) do
  begin
        atributo.Destroy;
        atributo := listaAtributos.siguiente;
  end;
  listaAtributos.Destroy;
  listaIdiomas.vaciar;
  lenguaje := nil;
  editorCodigo.Destroy;
  formularioInterfaz.Destroy;
  inherited Destroy;
end;

procedure TProyecto.abrir(nombreArchivo:string);
var
  XMLDoc: IXMLDocument;
  XMLProyecto, aux: IXMLNode;
  atributo: TAtributo;
  idioma: TIdioma;
  i, j: Integer;
begin
  if FileExists(nombreArchivo) then
  begin
    //Sistema de lectura del archivo XML usando el DOM parser del MSXML
    XMLDoc := TXMLDocument.Create(nombreArchivo);
    XMLProyecto := XMLDoc.DocumentElement;
    self.nombreArchivo:=nombreArchivo;
    //Nombre
    nombreProyecto := VarToStrDef(XMLProyecto.Attributes['nombre'],'');
  
    //Lenguaje
    lenguaje := TControlLenguajes.Instance.buscar(VarToStrDef(XMLProyecto.Attributes['lenguaje'],''));
  
    //Lista de Idiomas
    if not Assigned(controlIdiomas) then
      controlIdiomas := TControlIdiomas.Instance;
    for i:= 0 to XMLProyecto.ChildNodes.FindNode('listaIdiomas').ChildNodes.Count-1 do
    begin
      idioma := controlIdiomas.buscar(XMLProyecto.ChildNodes.FindNode('listaIdiomas').ChildNodes.Nodes[i].ChildNodes.Nodes[0].text);
      listaIdiomas.agregar(idioma);
    end;
  
    //Idioma Predeterminado
    idiomaPredeterminado:= listaIdiomas.buscar(XMLProyecto.ChildNodes.FindNode('idiomaPredeterminado').text);
  
    //Atributos
    aux:=XMLProyecto.ChildNodes.FindNode('atributos');
    for i:= 0 to aux.ChildNodes.Count-1 do
    begin
      atributo:=TAtributo.Create;
      atributo.setXML(aux.ChildNodes.Nodes[i]);
      listaAtributos.agregar(atributo);
    end;
  
    //C�digo Fuente
    editorCodigo.setearCodigoFuente(XMLProyecto.ChildNodes.FindNode('codigoFuente').Text);
  
    //Formulario Interfaz
    formularioInterfaz.setFormulario(XMLProyecto.ChildNodes.FindNode('formularioInterfaz'), listaIdiomas);
  end
  else
    raise Exception.CreateFmt('El archivo %s no existe',[nombreArchivo]);
end;

procedure TProyecto.agregarIdioma(unIdioma:string);
var
  idioma: TIdioma;
begin
  idioma:=listaIdiomas.buscar(unIdioma);
  if not Assigned(idioma) then
  begin
    idioma:=controlIdiomas.buscar(unIdioma);
    listaIdiomas.agregar(idioma);
    formularioInterfaz.agregarIdioma(idioma);
    if not Assigned(idiomaActual) then
      idiomaActual := idioma;
    if not Assigned(idiomaPredeterminado) then
      idiomaPredeterminado := idioma;
  end;
end;

procedure TProyecto.alinearComponentes(listaComponentes:Tstrings; AVertical, 
        AHorizontal:string);
begin
  formularioInterfaz.alinearComponentes(listaComponentes, AVertical, AHorizontal);
end;

procedure TProyecto.deshacerEdicion;
begin
  {TODO: deshacerEdicion???}
end;

procedure TProyecto.eliminarComponente(unComponente:string);
begin
  formularioInterfaz.eliminarComponente(unComponente);
end;

function TProyecto.generarCodigoFuente(unCompilador: TCompilador; 
        unDirectorio:string): string;
  
    function CortarEn255(original:string): widestring;
    var
      i:integer;
    begin
      result := StringReplace(original, #39, #39#39,[rfReplaceAll]);
      i := 255;
      while i < length(result) do
      begin
        Insert('''+'+#13#10+'''', result, i);
        i := i + 255;
      end;
    end;
  var
    archivo: TextFile;
    FileHandle: integer;
    codigoFuente: string;
    XML: IXMLDocument;
    lista, nodo: IXMLNode;
    atributo: TAtributo;
    idioma: TIdioma;
  
begin
  if LastDelimiter('\', unDirectorio) = Length(unDirectorio) then
    result := unDirectorio + ExtractFileName(nombreArchivo)
  else
    result := unDirectorio + '\' + ExtractFileName(nombreArchivo);
  result := ChangeFileExt(result, lenguaje.getExtension);
  codigoFuente := editorCodigo.mostrarCodigoFuente;
  
    //Cambiar los comentarios del template
    //{NOMBREARCHIVO}
  codigoFuente := StringReplace(codigoFuente,'{NOMBREARCHIVO}', ChangeFileExt(ExtractFileName(result),''),[]);
    //{PROCESARDEFINICION}
  codigoFuente := StringReplace(codigoFuente,'{PROCESARDEFINICION}', formularioInterfaz.getDefinicionParametrosDefinicion(unCompilador), []);
    //{PROCESARIN}
  codigoFuente := StringReplace(codigoFuente,'{PROCESARIN}', formularioInterfaz.getDefinicionParametrosEntrada(unCompilador), []);
    //{PROCESAROUT}
  codigoFuente := StringReplace(codigoFuente,'{PROCESAROUT}', formularioInterfaz.getDefinicionParametrosSalida(unCompilador), []);
    //{NOMBRE}
  codigoFuente := StringReplace(codigoFuente,'{NOMBRE}', ''''+nombreProyecto+'''',[]);
  
    //{DESCRIPCION}
  XML:=NewXMLDocument;
  XML.Encoding := 'UTF-8';
  lista:= XML.AddChild('atributos');
  atributo:=listaAtributos.primero;
  while Assigned(atributo) do
  begin
    atributo.getXML(lista);
    atributo:=listaAtributos.siguiente;
  end;
  codigoFuente := StringReplace(codigoFuente,'{DESCRIPCION}', ''''+CortarEn255(StringReplace(XML.XML.Text, #13#10,'',[rfReplaceAll, rfIgnoreCase]))+'''',[]);
  
    //{IDIOMAS}
  XML:=NewXMLDocument;
  XML.Encoding := 'UTF-8';
  lista:= XML.AddChild('listaIdiomas');
  idioma:=listaIdiomas.primero;
  while Assigned(idioma) do
  begin
    nodo:=lista.AddChild('idioma');
    nodo.text:=idioma.getCodigo;
    idioma:=listaIdiomas.siguiente;
  end;
  codigoFuente := StringReplace(codigoFuente,'{IDIOMAS}', ''''+CortarEn255(StringReplace(XML.XML.Text, #13#10,'',[rfReplaceAll, rfIgnoreCase]))+'''',[]);
  
    //{FORMULARIODFM}
  XML:=NewXMLDocument;
  XML.Encoding := 'UTF-8';
  lista:=XML.Node;//.AddChild('root');
  //  lista := XML.DocumentElement;
  formularioInterfaz.getFormularioXML(lista);
  codigoFuente := StringReplace(codigoFuente,'{FORMULARIODFM}', ''''+CortarEn255(StringReplace(XML.XML.Text, #13#10,'',[rfReplaceAll, rfIgnoreCase]))+'''',[]);
  //  FreeAndNil(XML);
  
  Assignfile(archivo, result);
  Rewrite(archivo);
  Writeln(archivo, codigoFuente);
  Flush(archivo);
  Close(archivo);
  
    //FileHandle := FileCreate(result);
    //FileWrite(FileHandle, codigoFuente, length(codigoFuente));
    //FileClose(FileHandle);
end;

function TProyecto.getAtributo(unAtributo, unIdioma:string): string;
var
  atributo: TAtributo;
begin
  if LowerCase(unAtributo) = 'nombre' then
    result := nombreproyecto
  else
  begin
    atributo:=listaAtributos.buscar(unAtributo);
    if Assigned(atributo) then
      result := atributo.getValor(unIdioma)
    else
      result := '';
  end;
end;

function TProyecto.getPropiedad(unaPropiedad, unIdioma:string): string;
begin
  result := formularioInterfaz.getPropiedad(unaPropiedad, unIdioma);
end;

function TProyecto.getPropiedad(unComponente, unaPropiedad, unIdioma:string): 
        string;
begin
  result := formularioInterfaz.getPropiedad(unComponente, unaPropiedad, unIdioma);
end;

procedure TProyecto.guardar(nombreArchivo:string);
var
  XML: IXMLDocument;
  proyecto, lista, nodo: IXMLNode;
  atributo: TAtributo;
  idioma: TIdioma;
  tmpFile: TextFile;
begin
  self.nombreArchivo := nombreArchivo;
  
  XML:=NewXMLDocument;
  proyecto := XML.AddChild('proyecto');
  proyecto.Attributes['nombre']:=nombreProyecto;
  proyecto.Attributes['lenguaje']:=lenguaje.getNombre;
  
  //ListaIdiomas
  lista:= proyecto.AddChild('listaIdiomas');
  idioma:=listaIdiomas.primero;
  while Assigned(idioma) do
  begin
    nodo:=lista.AddChild('idioma');
    nodo.text:=idioma.getCodigo;
    idioma:=listaIdiomas.siguiente;
  end;
  
  //IdiomaPredeterminado
  nodo:= proyecto.AddChild('idiomaPredeterminado');
  nodo.text:=idiomaPredeterminado.getCodigo;
  
  //Atributos
  lista:= proyecto.AddChild('atributos');
  atributo:=listaAtributos.primero;
  while Assigned(atributo) do
  begin
    atributo.getXML(lista);
    atributo:=listaAtributos.siguiente;
  end;
  
  //Formulario Interfaz
  formularioInterfaz.getFormularioXML(proyecto);
  
  //Codigo Fuente
  nodo:= proyecto.AddChild('codigoFuente');
  nodo.Text := editorCodigo.mostrarCodigoFuente;
  
  //Guardo
  XML.SaveToFile(nombreArchivo);
end;

procedure TProyecto.imprimir;
begin
  {TODO: imprimir proyecto deber�a ser imprimir!!!!}
  editorCodigo.imprimirProyecto;
end;

function TProyecto.insertarComponente(tipoComponente:string; arriba:string; 
        izquierda:string): string;
begin
  result := formularioInterfaz.insertarComponente(tipoComponente, arriba, izquierda, listaIdiomas);
end;

procedure TProyecto.modificarValorAtributo(unAtributo, unValor, 
        unIdioma:string);
var
  atributo: TAtributo;
begin
  if LowerCase(unAtributo) = 'nombre' then
    nombreproyecto := unValor
  else
  begin
    atributo:=listaAtributos.buscar(unAtributo);
    if not Assigned(atributo) then
    begin
      atributo := TAtributo.Create;
      atributo.setNombre(unAtributo);
      listaAtributos.agregar(atributo);
    end;
    if unIdioma = '' then
      atributo.setValor(unValor, listaIdiomas)
    else
      atributo.setValor(unValor, unIdioma);
  end;
end;

function TProyecto.mostrarCodigoFuente: AnsiString;
begin
  result := editorCodigo.mostrarCodigoFuente;
end;

function TProyecto.mostrarFormulario: AnsiString;
begin
  result := formularioInterfaz.getFormularioDFM;
end;

function TProyecto.mostrarIdiomaPredeterminado: string;
begin
  result:= idiomaPredeterminado.getCodigo;
end;

function TProyecto.mostrarIdiomas: TStringList;
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

procedure TProyecto.quitarIdioma(unIdioma: string);
var
  idioma: Tidioma;
begin
  idioma := controlIdiomas.buscar(unIdioma);
  if Assigned(idioma) then
  begin
    listaIdiomas.eliminar(idioma);
    formularioInterfaz.quitarIdioma(idioma);
  end;
end;

procedure TProyecto.rehacerEdicion;
begin
  {TODO: rehacerEdicion???}
end;

procedure TProyecto.setearCodigoFuente(unTexto:AnsiString);
begin
  editorCodigo.setearCodigoFuente(unTexto);
end;

procedure TProyecto.setearPropiedad(unaPropiedad, nuevoValor, unIdioma:string);
begin
  formularioInterfaz.setearPropiedad(unaPropiedad, nuevoValor, unIdioma)
end;

procedure TProyecto.setearPropiedad(unComponente, unaPropiedad, nuevoValor, 
        unIdioma:string);
begin
  formularioInterfaz.setearPropiedad(unComponente, unaPropiedad, nuevoValor, unIdioma)
end;

procedure TProyecto.setIdioma(unIdioma:string);
begin
  idiomaActual := listaIdiomas.buscar(unIdioma);
end;

procedure TProyecto.setIdiomaPredeterminado(unIdioma:string);
var
  idioma: TIdioma;
begin
  idioma := listaIdiomas.buscar(unIdioma);
  if Assigned(idioma) then
     idiomaPredeterminado:=idioma
  else
    raise Exception.CreateFmt('No se puede establecer el idioma %s como idioma por defecto porque no est� en la lista de idiomas del proyecto',[unIdioma]);
end;

procedure TProyecto.setLenguaje(unLenguaje:string);
var
  controlLenguajes: TControlLenguajes;
  plantilla: string;
begin
  controlLenguajes := TControlLenguajes.Instance;
  lenguaje := controlLenguajes.buscar(unLenguaje);
  plantilla := lenguaje.getPlantilla;
  editorCodigo.setearCodigoFuente(plantilla);
end;

{ TListaClaseAlineacion }

{
**************************** TListaClaseAlineacion *****************************
}
function TListaClaseAlineacion.agregar(nombreClase:string; 
        unaClase:TClaseAlineacion): Integer;
begin
  inherited agregar(nombreClase, unaClase);
end;

function TListaClaseAlineacion.buscar(nombreClase:string): TClaseAlineacion;
var
  aux: TClass;
begin
  aux:= inherited buscar(nombreClase);
  if assigned(aux) then
    result := TClaseAlineacion(aux)
  else
    result := nil;
end;

function TListaClaseAlineacion.existe(unaClase:string): Boolean;
begin
  result := inherited existe(unaClase);
end;

procedure TListaClaseAlineacion.insertar(nombreClase:string; 
        unaClase:TClaseAlineacion; index: integer);
begin
  inherited insertar(nombreClase, unaClase, index);
end;

initialization
  RegistrarAlineacion('arriba', TAlineacionArriba);
  RegistrarAlineacion('abajo', TAlineacionAbajo);
  RegistrarAlineacion('centroVertical', TAlineacionCentroV);
  RegistrarAlineacion('igualarEspaciadoVertical', TAlineacionIgualarEspaciadoV);
  RegistrarAlineacion('centroFormularioVertical', TAlineacionCentradoVFormulario);
  RegistrarAlineacion('izquierda', TAlineacionIzquierda);
  RegistrarAlineacion('derecha', TAlineacionDerecha);
  RegistrarAlineacion('centroHorizontal', TAlineacionCentroH);
  RegistrarAlineacion('igualarEspaciadoHorizontal', TAlineacionIgualarEspaciadoH);
  RegistrarAlineacion('centroFormularioHorizontal', TAlineacionCentradoHFormulario);
  RegistrarAlineacion('sinCambios', TAlineacionSinCambios);
end.
