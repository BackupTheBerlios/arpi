unit uTipos;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls,
  Forms, Dialogs, Contnrs, ExtCtrls, Jpeg, uIdiomas, uLista,
  uConsts, XMLIntf, XMLDoc, {pqGR32_JPEG,} GraphicEx, GifImage,
  GR32, GR32_Bytemaps, GR32_Image;

type
  RComplejo = Record
    real, imaginario: extended;
  end;

  TMString = Array of Array of string;

  tbitmapbits = array [0..0] of byte;
  Pbitmapbits = ^tbitmapbits;

  RValorImagen = Record
    MDatos: Array of Array of Byte;
    Paleta: Array [0..255] of TRGBQuad;
    Mascara: Array of Array of Byte;
    Height, Width:integer;
  end;
  PValorImagen = ^RValorImagen;
  RSeleccionImagen = Record
  end;

  RCelda= record
    unaColumna: Integer;
    unaFila: Integer;
    unValor: string;
  end;

  TTipo = class (TObject)
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure agregarIdioma(unIdioma:TIdioma); virtual;
    function getDFM: string; virtual; abstract;
    function getNombre: string; virtual;
    function getPointer(unIdioma: TIdioma): Pointer; virtual; abstract;
    function getValor(unIdioma:string): string; virtual; abstract;
    procedure getXML(var XML: IXMLNode); virtual; abstract;
    procedure quitarIdioma(unIdioma: TIdioma); virtual;
    procedure setPointer(puntero: pointer); virtual; abstract;
    procedure setValor(unValor, unIdioma: string); overload; virtual; abstract;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            virtual; abstract;
    procedure setXML(XML:IXMLNode); virtual; abstract;
  end;
  
  RTipoCelda= record
    unaColumna: Integer;
    unaFila: Integer;
    unTipo: TTipo;
  end;

  TTipoContenible = class (TTipo)
  public
    constructor Create; override;
    destructor Destroy; override;
  end;
  
  TLetra = class (TTipoContenible)
  private
    valor: Char;
  public
    constructor Create; override;
    function getDFM: string; override;
    function getPointer(unIdioma: TIdioma): Pointer; override;
    function getValor(unIdioma:string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setPointer(puntero: pointer); override;
    procedure setValor(unValor, unIdioma: string); override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TMatrizSimple = class (TObject)
  private
    listaCeldas: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(unaFila, unaColumna:integer; 
            unTipoContenible:TTipoContenible);
    function cantidadColumnas: Integer;
    function cantidadFilas: Integer;
    procedure eliminarCelda(unaFila, unaColumna:integer);
    procedure eliminarFila(unaFila:integer);
    function getArrayString: TMString;
    function getCelda(unaFila, unaColumna:integer): TTipoContenible;
    function getPointer: Pointer;
    procedure getXML(var XML:IXMLNode);
    procedure insertarFila(unaFila:integer);
    procedure setPointer(puntero: pointer);
    procedure setValor(unaFila, unaColumna:integer; unValor:string);
    procedure setXML(XML:IXMLNode);
  end;
  

  TComando = class (TObject)
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; virtual; abstract;
  end;
  
  TListaComandos = class (TLista)
  public
    procedure agregar(unComando:TComando);
    procedure modificar(unComando:TComando);
    function primero: TComando;
    function siguiente: TComando;
  end;
  

  THistorialComandos = class (TObject)
  private
    indiceHistorial: Integer;
    listaComandos: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(unComando:TComando);
    procedure agregarDeshacer(unComando: TComando);
    procedure agregarRehacer(unComando:TComando);
    function deshacer: TComando;
    function existeDeshacer: Boolean;
    function existeRehacer: Boolean;
    procedure modificar(unComando: TComando);
    function rehacer: TComando;
  end;
  
  TEstructura = class (TTipo)
  private
    nombre: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure abrir(nombreArchivo: string);
    procedure deshacer; virtual; abstract;
    function getIDNombre: string; virtual; abstract;
    function getNombre: string; override;
    procedure guardar(nombreArchivo: string); virtual;
    procedure imprimir; virtual; abstract;
    procedure rehacer; virtual; abstract;
    procedure setNombre(unNombre: string);
  end;
  

  TListaValorImagen = class (TObject)
  private
    indice: Integer;
    lista: array[1..10] of PvalorImagen;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(ValorImagen:RValorImagen);
    function siguiente: RValorImagen;
  end;
  

  THistorialImagen = class (TObject)
  private
    actualHistorial: Integer;
    listahistorial: TListaValorImagen;
  public
    constructor Create;
    destructor Destroy; override;
    procedure agregar(valorImagen:RValorImagen);
    function deshacer(valorImagen:RValorImagen): RValorImagen;
    function rehacer(valorImagen:RValorImagen): RValorImagen;
  end;
  
  TJpegToBmp = class (TComponent)
  private
    FBmp: TBitmap;
    FBmpFile: AnsiString;
    FImage: TImage;
    FJpeg: TJpegImage;
    FJpegFile: AnsiString;
    FStreamBmp: TStream;
    FStreamJpg: TStream;
  protected
    procedure FCopyJpegToBmp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CopyJpegToBmp;
  published
    property BmpFile: AnsiString read FBmpFile write FBmpFile;
    property Image: TImage read FImage write FImage;
    property JpegFile: AnsiString read FJpegFile write FJpegFile;
  end;
  
  TImagen = class (TEstructura)
  private
    historial: THistorialImagen;
    seleccionImagen: RSeleccionImagen;
    valorImagen: RValorImagen;
    function generarBitmap(altura,ancho:integer;bitmapbits:Pbitmapbits; 
            valor:RValorImagen): TBitmap32;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create; override;
    destructor Destroy; override;
    function abrir(nombreArchivo:string): TBitmap32; reintroduce; overload;
    procedure adquirirImagen(imagen:TBitmap32);
    procedure borrarSeleccion;
    procedure deshacer; override;
    function getPointer: Pointer;
    function getSeleccion: TBitmap32;
    function getSeleccionAsObject: TImagen;
    function getValor: TBitmap32;
    procedure getXML(var XML: IXMLNode); override;
    procedure guardar(nombreArchivo: string); override;
    procedure imprimir; override;
    procedure rehacer; override;
    procedure setImagen(unaImagen:TImagen; unaPosicion:TPoint);
    procedure setPointer(puntero: pointer); override;
    procedure setSeleccion(tipo:byte;seleccion:TRect);
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(valor:RValorImagen); overload;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TListaTipos = class (TLista)
  public
    procedure agregar(tipoContenible: TTipoContenible);
    function buscar(unaFila, unaColumna:integer): TTipoContenible;
    procedure insertar(tipoContenible: TTipoContenible; index:integer);
    function primero: TTipoContenible;
    function siguiente: TTipoContenible;
  end;
  
  TCmdMatrizInsertarFila = class (TComando)
  private
    cantidadFilas: Integer;
    filaInicial: Integer;
    lista: array of RTipoCelda;
    tipoDato: string;
    unValor: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filaInicial, cantidadFilas: integer; tipoDato, 
            unValor:string); overload;
    procedure inicializa(unaFila, unaColumna: integer; unTipo:TTipoContenible); 
            overload;
  end;
  
  TCmdMatrizCopiar = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
    filaFinal: Integer;
    filainicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filainicial, columnaInicial, filaFinal, columnaFinal: 
            integer);
  end;
  
  TCmdMatrizCortar = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
    filaFinal: Integer;
    filainicial: Integer;
    valorInicial: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filainicial, columnaInicial, filaFinal, columnaFinal: 
            integer; valorInicial: string);
  end;
  
  TCmdMatrizPegar = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
    filaFinal: Integer;
    filainicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer);
  end;
  
  TCmdMatrizModificar = class (TComando)
  private
    lista: array of RCelda;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(unaFila, unaColumna: integer; unValor:string);
  end;
  
  TCmdMatrizInsertarColumna = class (TComando)
  private
    cantidadColumnas: Integer;
    columnaInicial: Integer;
    lista: array of RTipoCelda;
    tipoDato: string;
    unValor: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(columnaInicial, cantidadColumnas: integer; tipoDato, 
            unValor:string); overload;
    procedure inicializa(unaFila, unaColumna: integer; unTipo:TTipoContenible); 
            overload;
  end;
  
  TCmdMatrizInicializar = class (TComando)
  private
    nroColumnas: Integer;
    nroFilas: Integer;
    tipoDato: string;
    valorInicial: string;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(nroFilas, nroColumnas:integer; tipoDato, 
            valorInicial:string);
  end;
  
  TCmdMatrizEliminarFila = class (TComando)
  private
    filaFinal: Integer;
    filainicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(filainicial, filaFinal: integer);
  end;
  
  TCmdMatrizEliminarColumna = class (TComando)
  private
    columnaFinal: Integer;
    columnaInicial: Integer;
  public
    function ejecutar(unaMatriz: TMatrizSimple): TComando; override;
    procedure inicializa(columnaInicial, columnaFinal: integer);
  end;
  
  TMatriz = class (TEstructura)
  private
    historial: THistorialComandos;
    Matriz: TMatrizSimple;
    tipoDato: string;
    valorInicial: string;
    procedure redimensionar(filas, columnas: integer);
    function tipoEstructura: string;
    class function updateNumero(numero:integer=-1): Word;
  public
    constructor Create; override;
    procedure abrir(nombreArchivo: String);
    function copiarMatriz(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer): TMatrizSimple;
    function cortarMatriz(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer): TMatrizSimple;
    procedure deshacer; override;
    procedure eliminarColumnas(columnaIncial, columnaFinal:integer);
    procedure eliminarFilas(filaIncial, filaFinal:integer);
    function existeDeshacer: Boolean;
    function existeRehacer: Boolean;
    function getArrayString: TMString;
    function getCantidadColumnas: Integer;
    function getCantidadFilas: Integer;
    function getIDNombre: string; override;
    function getPointer(unIdioma: TIdioma): Pointer; override;
    function getTipoDato: string;
    function getValorInicial: string;
    procedure getXML(var XML: IXMLNode); override;
    procedure guardar(nombreArchivo: string); override;
    procedure imprimir; override;
    procedure inicializa(nroFilas, nroColumnas:integer; tipoDato, 
            valorInicial:string);
    procedure insertarColumnas(unaColumna, cantidadColumnas:integer);
    procedure insertarFilas(unaFila, cantidadFilas:integer);
    procedure modificarCelda(unaFila, unaColumna: integer; unValor:string);
    procedure pegarMatriz(filaInicial, columnaInicial, filaFinal, 
            columnaFinal:integer);
    procedure rehacer; override;
    procedure reInicializar(nroFilas, nroColumnas:integer; tipoDato, 
            valorInicial:string);
    procedure setPointer(puntero: pointer); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML: IXMLNode); override;
    procedure _agregar(unTipoContenible:TTipoCOntenible);
    procedure _getValor(unaCelda:integer);
    procedure _setMatrizSimple(matrizSimple: TmatrizSimple);
  end;
  
  TTextoSimple = class (TObject)
  private
    idioma: TIdioma;
    valor: string;
  public
    function getDFM: string;
    function getIdioma: TIdioma;
    function getValor: string;
    procedure getXML(var XML: IXMLNode);
    procedure setIdioma(unIdioma:TIdioma);
    procedure setValor(unValor: string);
    procedure setXML(XML:IXMLNode);
  end;
  
  TListaTextos = class (TLista)
  public
    procedure agregar(unTexto: TTextoSimple);
    function buscar(unIdioma:TIdioma): TTextoSimple;
    function primero: TTextoSimple;
    function siguiente: TTextoSimple;
  end;
  
  TTexto = class (TTipo)
  private
    listaTextos: TListaTextos;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure agregarIdioma(unIdioma:TIdioma); override;
    function getDFM: string; override;
    function getPointer(unIdioma: TIdioma): Pointer; override;
    function getValor(unIdioma:string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure quitarIdioma(unIdioma: TIdioma); override;
    procedure setPointer(puntero: pointer); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
    function siguiente: TListaTextos;
    procedure _agregar(unTexto:string; unIdioma:TIdioma);
  end;
  
  TNumero = class (TTipoContenible)
  private
    valor: Double;
  public
    constructor Create; override;
    function getDFM: string; override;
    function getPointer(unIdioma: TIdioma): Pointer; override;
    function getValor(unIdioma: string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setPointer(puntero: pointer); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TNumeroEntero = class (TNumero)
  public
    function getDFM: string; override;
    function getPointer(unIdioma: TIdioma): Pointer; override;
    function getValor(unIdioma: string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setPointer(puntero: pointer); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  
  TComplejo = class (TTipoContenible)
  private
    valor: RComplejo;
  public
    constructor Create; override;
    function getDFM: string; override;
    function getPointer(unIdioma: TIdioma): Pointer; override;
    function getValor(unIdioma: string): string; override;
    procedure getXML(var XML: IXMLNode); override;
    procedure setPointer(puntero: pointer); override;
    procedure setValor(unValor, unIdioma: string); overload; override;
    procedure setValor(unValor: string; listaIdiomas: TlistaIdiomas); overload; 
            override;
    procedure setXML(XML:IXMLNode); override;
  end;
  

procedure Register;

implementation

uses
  Math, uBuilderTipoDatos, uPortapapeles, Variants;

procedure Register;
begin
  RegisterComponents('VCL', [TJpegToBmp]);
end;

{
************************************ TTipo *************************************
}
constructor TTipo.Create;
begin
end;

destructor TTipo.Destroy;
begin
end;

procedure TTipo.agregarIdioma(unIdioma:TIdioma);
begin
end;

function TTipo.getNombre: string;
begin
  result := 'Tipo';
end;

procedure TTipo.quitarIdioma(unIdioma: TIdioma);
begin
end;

{
******************************* TTipoContenible ********************************
}
constructor TTipoContenible.Create;
begin
end;

destructor TTipoContenible.Destroy;
begin
end;

{
************************************ TLetra ************************************
}
constructor TLetra.Create;
begin
  valor := 'a';
end;

function TLetra.getDFM: string;
begin
  result := valor;
end;

function TLetra.getPointer(unIdioma: TIdioma): Pointer;
begin
  result := PChar(valor);
end;

function TLetra.getValor(unIdioma:string): string;
begin
  result:=valor;
end;

procedure TLetra.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('letra');
  aux.Text := getValor('');
end;

procedure TLetra.setPointer(puntero: pointer);
begin
  valor:= strpas(puntero)[1];
end;

procedure TLetra.setValor(unValor, unIdioma: string);
begin
  valor := unValor[1];
end;

procedure TLetra.setXML(XML:IXMLNode);
begin
  setValor(XML.ChildNodes.Nodes[0].Text,'');
end;

{
******************************** TListaComandos ********************************
}
procedure TListaComandos.agregar(unComando:TComando);
begin
  inherited agregar(unComando);
end;

procedure TListaComandos.modificar(unComando:TComando);
begin
  inherited modificar(unComando);
end;

function TListaComandos.primero: TComando;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result :=TComando(aux)
  else
    result := nil;
end;

function TListaComandos.siguiente: TComando;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result :=TComando(aux)
  else
    result := nil;
end;

{
****************************** THistorialComandos ******************************
}
constructor THistorialComandos.Create;
begin
  //  listaComandos := TListaComandos.Create;
  listaComandos := TObjectList.Create;
  indiceHistorial := -1;
end;

destructor THistorialComandos.Destroy;
begin
  listaComandos.Free;
  //*
  //  comando := listaComandos.primero;
  //  while Assigned(comando) do
  //  begin
  //    FreeAndNil(comando);
  //    comando := listaComandos.siguiente;
  //  end;
  //*
  FreeAndNil(listaComandos);
end;

procedure THistorialComandos.agregar(unComando:TComando);
begin
  if Assigned(unComando) then
  begin
    while listaComandos.Count > indiceHistorial+1 do
    begin
      listaComandos.Delete(indiceHistorial+1);
    end;
    listaComandos.Add(unComando);
    inc (indiceHistorial);
  end;
  //*
  //  comando:= listaComandos.primero;
  //  for i:= 0 to indiceHistorial+1 do
  //    comando:= listaComandos.siguiente;
  //  while Assigned(comando) do
  //  begin
  //    listaComandos.eliminar(comando);
  //    comando:= listaComandos.siguiente;
  //  end;
  //  listaComandos.agregar(unComando);
  //  inc(indiceHistorial);
  //*
end;

procedure THistorialComandos.agregarDeshacer(unComando: TComando);
begin
  listaComandos.Items[indiceHistorial] := unComando;
end;

procedure THistorialComandos.agregarRehacer(unComando:TComando);
begin
  listaComandos.Items[indiceHistorial+1] := unComando;
end;

function THistorialComandos.deshacer: TComando;
begin
  result := TComando(listaComandos.Items[indiceHistorial]);
  //*
  //  comando:= listaComandos.primero;
  //  for i:= 0 to indiceHistorial do
  //    comando := listaComandos.siguiente;
  //  result := comando;
  dec(indiceHistorial);
  //*
end;

function THistorialComandos.existeDeshacer: Boolean;
begin
  result := indiceHistorial >=0;
end;

function THistorialComandos.existeRehacer: Boolean;
begin
  result := indiceHistorial+1 < listaComandos.Count;
end;

procedure THistorialComandos.modificar(unComando: TComando);
begin
  TComando(listaComandos.Items[indiceHistorial]).Free;
  listaComandos.Items[indiceHistorial] := unComando;
  //*  listaComandos.modificar(unComando);
end;

function THistorialComandos.rehacer: TComando;
begin
  result := TComando(listaComandos.Items[indiceHistorial+1]);
  inc (indiceHistorial);
  //*
  //  comando:= listaComandos.primero;
  //  for i:= 0 to indiceHistorial+1 do
  //    comando := listaComandos.siguiente;
  //  result := comando;
  //  inc(indiceHistorial);
  //*
end;

{
********************************* TEstructura **********************************
}
constructor TEstructura.Create;
begin
end;

destructor TEstructura.Destroy;
begin
end;

procedure TEstructura.abrir(nombreArchivo: string);
begin
end;

function TEstructura.getNombre: string;
begin
  result := nombre;
end;

procedure TEstructura.guardar(nombreArchivo: string);
begin
end;

procedure TEstructura.setNombre(unNombre: string);
begin
  nombre:= unNombre;
end;

{
****************************** TListaValorImagen *******************************
}
constructor TListaValorImagen.Create;
begin
end;

destructor TListaValorImagen.Destroy;
begin
end;

procedure TListaValorImagen.agregar(ValorImagen:RValorImagen);
var
  valor: PValorImagen;
begin
  new(Valor);
  inc(indice);
  valor:= @Valorimagen;
  lista[indice]:= Valor;
end;

function TListaValorImagen.siguiente: RValorImagen;
begin
  result:=lista[indice]^;
  dec(indice);
end;

{
******************************* THistorialImagen *******************************
}
constructor THistorialImagen.Create;
begin
  listaHistorial:= TListaValorImagen.Create;
end;

destructor THistorialImagen.Destroy;
begin
end;

procedure THistorialImagen.agregar(valorImagen:RValorImagen);
begin
  listahistorial.agregar(valorImagen);
end;

function THistorialImagen.deshacer(valorImagen:RValorImagen): RValorImagen;
begin
  result:= listahistorial.siguiente;
end;

function THistorialImagen.rehacer(valorImagen:RValorImagen): RValorImagen;
begin
end;

{
******************************** TMatrizSimple *********************************
}
constructor TMatrizSimple.Create;
begin
  listaCeldas:= TObjectList.Create;
end;

destructor TMatrizSimple.Destroy;
var
  i: Integer;
begin
  for i := 0 to listaCeldas.Count-1 do
  begin
    TObjectList(listaCeldas.Items[i]).Clear;
  //      tipo:=TTipoContenible(TObjectList(listaCeldas.Items[0]).Items[0]);
  //      FreeAndNil(tipo);
        //TObjectList(listaCeldas.Items[0]).Delete(0);
  end;
  listaCeldas.Clear;
  //  listaCeldas.Delete(0);
   //nd;
  FreeAndNil(listaCeldas);
  
  //  for i:= listaCeldas.Count-1 downto 0 do
  //  begin
  //    for j:= TObjectList(listaCeldas.Items[i]).Count-1 downto 0 do
  //    begin
  //      tipo:=TTipoContenible(TObjectList(listaCeldas.Items[i]).Items[j]);
  //      FreeAndNil(tipo);
  //      TObjectList(listaCeldas.Items[i]).Delete(j);
  //    end;
  //    listaCeldas.Delete(i);
  //    FreeAndNil(TObjectList((listaCeldas.Items[i].));
  //  end;
  //  FreeAndNil(listaCeldas);
end;

procedure TMatrizSimple.agregar(unaFila, unaColumna:integer; 
        unTipoContenible:TTipoContenible);
begin
  if (listaCeldas.Count >= unaFila) or (TObjectList(listaCeldas.Items[unaFila-1]).Count>=unaColumna) then
    TObjectList(listaCeldas.Items[unaFila-1]).Insert(unaColumna-1, unTipoContenible)
  else
    raise Exception.CreateFmt('No se puede agregar el valor en la celda [%d;%d]',[unaFila, unaColumna])
end;

function TMatrizSimple.cantidadColumnas: Integer;
begin
  result := TObjectList(listaCeldas.Items[0]).Count;
end;

function TMatrizSimple.cantidadFilas: Integer;
begin
  result := listaCeldas.Count;
end;

procedure TMatrizSimple.eliminarCelda(unaFila, unaColumna:integer);
begin
  TObjectList(listaCeldas.Items[unaFila-1]).Extract(TObjectList(listaCeldas.Items[unaFila-1]).Items[unaColumna-1]);
end;

procedure TMatrizSimple.eliminarFila(unaFila:integer);
begin
  //  listaCeldas.Delete(unaFila-1);
  //  listaCeldas.Remove(listaCeldas.Items[unaFila-1]);
  listaCeldas.Extract(listaCeldas.Items[unaFila-1]);
end;

function TMatrizSimple.getArrayString: TMString;
var
  i, j: Integer;
  aux: TMString;
begin
  SetLength(aux,cantidadFilas,cantidadColumnas);
  for i:= 1 to cantidadFilas do
    for j:= 1 to cantidadColumnas do
      aux[i-1,j-1] := getCelda(i,j).getValor('');
  result:=aux;
end;

function TMatrizSimple.getCelda(unaFila, unaColumna:integer): TTipoContenible;
begin
  if (listaCeldas.Count >= unaFila) or (TObjectList(listaCeldas.Items[unaFila-1]).Count >=unaColumna) then
    result := TTipoContenible(TObjectList(listaCeldas.Items[unaFila-1]).Items[unaColumna-1])
  else
    raise Exception.CreateFmt('No se puede devolver el valor de la celda [%d;%d]',[unaFila, unaColumna])
end;

function TMatrizSimple.getPointer: Pointer;
var
  complejos: array of array of RComplejo;
  numeros: array of array of double;
  numerosenteros: array of array of integer;
  letras: array of array of char;
  i, j: Integer;
  valor: string;
begin
  if TObjectList(listaCeldas.Items[i]).Items[j] is TLetra then
  begin
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        letras[i][j]:=TLetra(TObjectList(listaCeldas.Items[i]).Items[j]).getValor('')[1];
    end;
    result := pointer(letras);
  end
  else if TObjectList(listaCeldas.Items[i]).Items[j] is TNumeroEntero then
  begin
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        numerosenteros[i][j]:=strtoint(TNumeroEntero(TObjectList(listaCeldas.Items[i]).Items[j]).getValor(''));
    end;
    result := pointer(numerosenteros);
  end
  else if TObjectList(listaCeldas.Items[i]).Items[j] is TNumero then
  begin
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        numeros[i][j]:=StrToFloat(TNumero(TObjectList(listaCeldas.Items[i]).Items[j]).getValor(''));
    end;
    result := pointer(numeros);
  end
  else if TObjectList(listaCeldas.Items[i]).Items[j] is TComplejo then
  begin
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
      begin
        valor := TComplejo(TObjectList(listaCeldas.Items[i]).Items[j]).getValor('');
        complejos[i][j].real := StrToFloat(Copy(valor, 0, pos('+',valor)));
        complejos[i][j].imaginario := StrToFloat(Copy(valor, pos('+',valor)+1, length(valor)-pos('+',valor)-2));
      end;
    end;
    result := pointer(complejos);
  end
end;

procedure TMatrizSimple.getXML(var XML:IXMLNode);
var
  fila: IXMLNode;
  i, j: Integer;
begin
  for i:= 0 to listaCeldas.Count-1 do
  begin
    fila := XML.AddChild('fila');
    for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
      TTipoContenible(TObjectList(listaCeldas.Items[i]).Items[j]).getXML(fila);
  end;
end;

procedure TMatrizSimple.insertarFila(unaFila:integer);
begin
  if listaCeldas.Count < unaFila then
    listaCeldas.Add(TObjectList.Create)
  else
    listaCeldas.Insert(unaFila-1, TObjectList.Create);
end;

procedure TMatrizSimple.setPointer(puntero: pointer);
var
  complejos: array of array of RComplejo;
  numeros: array of array of double;
  numerosenteros: array of array of integer;
  letras: array of array of char;
  i, j: Integer;
  valor: string;
begin
  if TObjectList(listaCeldas.Items[i]).Items[j] is TLetra then
  begin
    letras := puntero;
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        TLetra(TObjectList(listaCeldas.Items[i]).Items[j]).setValor(letras[i][j],'');
    end;
  end
  else if TObjectList(listaCeldas.Items[i]).Items[j] is TNumeroEntero then
  begin
    numerosenteros:= puntero;
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        TNumeroEntero(TObjectList(listaCeldas.Items[i]).Items[j]).setValor(IntToStr(numerosenteros[i][j]),'');
    end;
  end
  else if TObjectList(listaCeldas.Items[i]).Items[j] is TNumero then
  begin
    numeros:=puntero;
    for i:= 0 to listaCeldas.Count-1 do
    begin
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        TNumero(TObjectList(listaCeldas.Items[i]).Items[j]).setValor(floattostr(numeros[i][j]),'');
    end;
  end
  else if TObjectList(listaCeldas.Items[i]).Items[j] is TComplejo then
  begin
    for i:= 0 to listaCeldas.Count-1 do
    begin
      complejos := puntero;
      for j:= 0 to TObjectList(listaCeldas.Items[i]).Count-1 do
        TComplejo(TObjectList(listaCeldas.Items[i]).Items[j]).setValor(floattostr(complejos[i][j].real)+'+'+ floattostr(complejos[i][j].imaginario)+'i', '');
    end;
  end
end;

procedure TMatrizSimple.setValor(unaFila, unaColumna:integer; unValor:string);
begin
  if (listaCeldas.Count >= unaFila) or (TObjectList(listaCeldas.Items[unaFila-1]).Count >= unaColumna) then
    TTipoContenible(TObjectList(listaCeldas.Items[unaFila-1]).Items[unaColumna-1]).setValor(unValor,'')
  else
    raise Exception.CreateFmt('No se puede cambiar el valor en la celda [%d;%d]',[unaFila, unaColumna])
end;

procedure TMatrizSimple.setXML(XML:IXMLNode);
var
  fila: IXMLNode;
  i, j: Integer;
  tipo: TTipo;
begin
  for i:= 0 to XML.ChildNodes.Count-1 do//Nodes[0].ChildNodes.Count-1 do
  begin
    listaCeldas.Add(TObjectList.Create);
    fila := XML.ChildNodes.Nodes[i];
    for j:= 0 to fila.ChildNodes.Count-1 do //Nodes[0].ChildNodes.Count-1  do
    begin
      tipo:=TBuilderTipoDato.Instance.CreateTipo(fila.ChildNodes.Nodes[j].NodeName);
      tipo.setXML(fila.ChildNodes.Nodes[j]);
      TObjectList(listaCeldas.Items[i]).Add(tipo);
    end;
  end;
end;

{
********************************** TJpegToBmp **********************************
}
constructor TJpegToBmp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FJpeg := TJpegImage.Create;
  FBmp  := TBitmap.Create;
end;

destructor TJpegToBmp.Destroy;
begin
  FJpeg.Free;
  FBmp.Free;
  inherited Destroy;
end;

procedure TJpegToBmp.CopyJpegToBmp;
begin
  FCopyJpegToBmp;
end;

procedure TJpegToBmp.FCopyJpegToBmp;
begin
  if FileExists(FBmpFile) then DeleteFile(FBmpFile);
  FStreamBmp := TFileStream.Create(FBmpFile,fmCreate);
  FStreamJpg := TFileStream.Create(FJpegFile, fmOpenRead);
  
  try
    //FBmp.PixelFormat := pf8bit;
    FJpeg.LoadFromStream(FStreamJpg);
    FBmp.Width := FJpeg.Width;
    FBmp.Height := FJpeg.Height;
    FBmp.Canvas.Draw(0,0,FJpeg);
    FBmp.SaveToStream(FStreamBmp);
  finally
    FStreamJpg.Free;
    FStreamBmp.Free;
  end;
end;

{
*********************************** TImagen ************************************
}
constructor TImagen.Create;
begin
  historial := THistorialImagen.Create;
end;

destructor TImagen.Destroy;
begin
  with valorImagen do // no se si esta bien
  begin
  //     freemem(MDatos,Height*Width);
  //     freemem(Mascara,Height*Width);
  end;
end;

function TImagen.abrir(nombreArchivo:string): TBitmap32;
  
  type
    tbitmapbits = array [0..0] of byte;
    Tcolordelpixel = array [1..3] of byte;
    tpaleta = array [0..255] of TRGBQuad;
  var
    bitmapbits: Pbitmapbits;
    looprow, loopcol, colores: Integer;
    cantentradas: Integer;
    JPG2BMP: TJpegToBmp;
    GraphicClass: TGraphicExGraphicClass;
    Graphic: TGraphic;
    ImagenBM: TBitmap;
    imagen1: Timage;
    bitmap32: TBitmap32;
  
begin
    {DONE: Levanta BMP, PCX(256 greyscale), TIFF(256 greyscale), JPG}
    {DONE: Forzar a leer hasta que se obtengan los bits}
  imagen1:= TImage.Create(application);
  repeat
    GraphicClass := FileFormatList.GraphicFromContent(nombreArchivo);
    if GraphicClass = nil then
    begin // si fall�, manualmente... damn!!
      if (uppercase(ExtractFileExt(nombreArchivo))='.JPG') or  (uppercase(ExtractFileExt(nombreArchivo))='.JPEG') then
      begin
        JPG2BMP:= TJpegToBmp.Create(Application);
        JPG2BMP.JpegFile:= nombreArchivo;
        JPG2BMP.BmpFile:='temporal.bmp';
        JPG2BMP.CopyJpegToBmp;
            // cargar imagen
        ImagenBM:=TBitmap.Create;
        imagen1.Picture.LoadFromFile('temporal.bmp');
  //        imagen1.Picture.LoadFromFile(nombreArchivo);
        ImagenBM:= ReduceColors(imagen1.Picture.Bitmap, rmQuantize,dmFloydSteinberg, 8, imagen1.Picture.Bitmap.Palette);
      //      TheBitmap := LoadImage(0,PChar('temporal.bmp'),IMAGE_BITMAP,0,0,LR_LOADFROMFILE);
        cantentradas := GetDIBColorTable(ImagenBM.Canvas.Handle,0,256,valorImagen.paleta);
        DeleteFile('temporal.bmp')
      end;
      if (uppercase(ExtractFileExt(nombreArchivo)) = '.BMP') then
      begin
        ImagenBM:=TBitmap.Create;
        Imagen1.Picture.LoadFromFile(nombreArchivo);
        if Imagen1.Picture.Bitmap.PixelFormat = pf8bit then
        begin
          ImagenBM.LoadFromFile(nombreArchivo);
          cantentradas := GetDIBColorTable(ImagenBM.Canvas.Handle,0,256,valorImagen.paleta);
        end
        else
          begin
    //          ImagenBM.LoadFromFile(nombreArchivo);
            ImagenBM:= ReduceColors(imagen1.Picture.Bitmap, rmQuantize,dmFloydSteinberg, 8, imagen1.Picture.Bitmap.Palette);
            cantentradas := GetDIBColorTable(ImagenBM.Canvas.Handle,0,256,valorImagen.paleta);
          end;
      end;
      if (uppercase(ExtractFileExt(nombreArchivo))= '.PCX') then
      begin
        Graphic:= TPCXGraphic.Create;
        Graphic.LoadFromFile(nombreArchivo);
        Imagen1.Picture.Graphic := Graphic;
        GetPaletteEntries(Imagen1.Picture.Graphic.Palette,0,256,valorimagen.paleta);
        ImagenBM:=TBitmap.Create;
        ImagenBM.Assign(imagen1.Picture.Bitmap);
      end;
    end
    else
    begin
          // GraphicFromContent always returns TGraphicExGraphicClass
      Graphic := GraphicClass.Create;
      Graphic.LoadFromFile(nombreArchivo);
      Imagen1.Picture.Graphic := Graphic;
      GetPaletteEntries(Imagen1.Picture.Graphic.Palette,0,256,valorimagen.paleta);
      ImagenBM:=TBitmap.Create;
      ImagenBM.Assign(imagen1.Picture.Bitmap);
    end;
  
        // crear las matrices dinamicas de datos y mascara
    with valorImagen do
    begin
            // DATOS
      Height:=ImagenBM.Height;
      Width:=ImagenBM.Width;
      SetLength(Mdatos,ImagenBM.Height);
      for cantentradas:=low(Mdatos) to high(Mdatos) do
        SetLength(Mdatos[cantentradas],ImagenBM.Width);
            //MASCARA
      SetLength(Mascara,ImagenBM.Height);
      for cantentradas:=low(Mascara) to high(Mascara) do
        SetLength(Mascara[cantentradas],ImagenBM.Width); // GENERA UNA MATRIZ LLENA DE CEROS
            // fin crear las matrices dinamicas de datos y mascara
            // reservar espacio en memoria para la matriz  ImagenBM.Handle
      bitmapbits:=AllocMem(ImagenBM.Height*ImagenBM.Width);
      cantentradas:=GetBitmapBits(ImagenBM.Handle,Height*Width,bitmapbits);
  //      cantentradas:=GetBitmapBits(imagen1.Picture.Bitmap.Handle,Height*Width,bitmapbits);
            // fin reservar espacio en memoria para la matriz
            // almacenar matriz de valores
  //      imagen321.Bitmap.LoadFromFile(nombrearchivo);
  //      imagen321.Bitmap.Assign(ImagenBM);
  {      bytemapuni.ReadFrom(imagen321.Bitmap,ctWeightedRGB);
        bytemapRed.ReadFrom(imagen321.Bitmap,ctRed);
        bytemapGreen.ReadFrom(imagen321.Bitmap,ctGreen);
        bytemapBlue.ReadFrom(imagen321.Bitmap,ctBlue);
        deletefile('temporal.bmp');}
      for looprow:=0 to  Height-1 do
        for loopcol:= 0 to Width-1 do
        begin
  {        colordelpixel[1]:= (ColorToRGB(imagen1.Canvas.Pixels[looprow,loopcol]) mod 256);
          colordelpixel[2]:= ((ColorToRGB(imagen1.Canvas.Pixels[looprow,loopcol])and $0000FF00) div 256);
          colordelpixel[3]:= ((ColorToRGB(imagen1.Canvas.Pixels[looprow,loopcol])and $00FF0000) div 65535);}
              // pasarlos a la matriz -yuppi!!!!!!!!!!
  //        valorImagen.mdatos[looprow,loopcol]:= bytemapuni.Value[loopcol,looprow];
        valorImagen.mdatos[looprow,loopcol]:=bitmapbits[looprow*Width+loopcol];
  {        valorimagen.Paleta[bytemapuni.Value[loopcol,looprow]].rgbRed:= bytemapRed.Value[loopcol,looprow];
          valorimagen.Paleta[bytemapuni.Value[loopcol,looprow]].rgbBlue:= bytemapBlue.Value[loopcol,looprow];
          valorimagen.Paleta[bytemapuni.Value[loopcol,looprow]].rgbGreen:= bytemapGreen.Value[loopcol,looprow];}
  //        bitmapbits[looprow*Width+loopcol]:= valorImagen.mdatos[looprow,loopcol];//strtoint(posiciondelbit(colordelpixel,valorimagen.paleta))//
              // fin pasarlos a la matriz -yuppi!!!!!!!!!!
        end;
            // fin almacenar matriz de valores
  //          imagen321.Bitmap.BitmapInfo.bmiHeader.biBitCount:= 8;
  {        for looprow:= 0 to 255 do
          valorImagen.Paleta[looprow]:= imagen321.Bitmap.BitmapInfo.bmiColors[looprow];//,0,length(imagen321.Bitmap.BitmapInfo.bmiColors));}
    end;
  until cantentradas > 0;
  ImagenBM.Free;
  result:=generarBitmap(valorImagen.Height,valorImagen.Width,bitmapbits,valorimagen);
  FreeMem(bitmapbits,valorImagen.Height*valorImagen.Width);
end;

procedure TImagen.adquirirImagen(imagen:TBitmap32);
var
  bitmapbits: Pbitmapbits;
  looprow, loopcol, colores: Integer;
  paleta: array [0..255] of TRGBQuad;
  cantentradas: Integer;
  ImagenBM: TBitmap;
begin
  with valorImagen do
  begin
        // DATOS
    Height:=imagen.Height;
    Width:=imagen.Width;
    imagenBM:= TBitmap.Create;
    ImagenBM.Assign(imagen);
    SetLength(Mdatos,imagen.Height);
    for cantentradas:=low(Mdatos) to high(Mdatos) do
      SetLength(Mdatos[cantentradas],imagen.Width);
        //MASCARA
    SetLength(Mascara,imagen.Height);
    for cantentradas:=low(Mascara) to high(Mascara) do
      SetLength(Mascara[cantentradas],imagen.Width); // GENERA UNA MATRIZ LLENA DE CEROS
        // fin crear las matrices dinamicas de datos y mascara
        // reservar espacio en memoria para la matriz
    getmem(bitmapbits,imagen.Height*imagen.Width);
    GetBitmapBits(ImagenBM.Handle,Height*Width,bitmapbits);
  //    GetBitmapBits(Imagen.Handle,imagen.Height*imagen.Width,bitmapbits);
        // fin reservar espacio en memoria para la matriz
  
        // almacenar matriz de valores
    for looprow:=0 to  Height-1 do
      for loopcol:= 0 to Width-1 do
      begin
          // pasarlos a la matriz -yuppi!!!!!!!!!!
      valorImagen.mdatos[looprow,loopcol]:=bitmapbits[looprow*Width+loopcol]
          // fin pasarlos a la matriz -yuppi!!!!!!!!!!
      end;
        // fin almacenar matriz de valores
  
        // almacenar paleta
    cantentradas := GetDIBColorTable(Imagen.Canvas.Handle,0,256,valorImagen.paleta);
        // fin almacenar paleta
  end;
end;

procedure TImagen.borrarSeleccion;
  
  type
    puntoseleccion = record
        x,y:integer;
    end;
  var
    srchH,srchV, fila, columna:integer;
    IzqArr,DerAbj:puntoseleccion;
    topf,botf:boolean;
  
begin
  topf:=false;
  botf:=false;
    // obtener el area seleccionada
  srchV:=0;
  srchH:=0;
  repeat // busqueda topleft desde arriba
    if (valorimagen.Mascara[srchV,srchH] = 1)  and (not topf) then
    begin
      IzqArr.x:=srchH;
      IzqArr.y:=srchV;
      topf:= true;
    end;
    inc(srchV);
    if ( srchV = valorImagen.Height-1) and (not (srchH =valorImagen.Width-1)) then
    begin
      srchV:=0;
      inc(srchH);
    end;
  until (topf or(( srchV = valorImagen.Height-1) and (srchH =valorImagen.Width-1)));
  // Fin busqueda topleft
  if topf then // si encontro topleft; sino no existe seleccion
  begin // busqueda bottomright desde abajo
    srchV:=valorImagen.Height-1;
    srchH:=valorImagen.Width-1;
    repeat
      if (valorimagen.Mascara[srchV,srchH] = 1)  and (not botf) then
      begin
        DerAbj.x:=srchH;;
        DerAbj.y:=srchV;
        botf:= true;
      end;
      dec(srchV);
      if ( srchV = 0) and (not (srchH =0)) then
      begin
        srchV:=valorImagen.Height-1;
        dec(srchH);
      end;
    until (botf or(( srchV = 0) and (srchH =0)));
  end;
  
      if topf and botf then
      begin
        self.historial.agregar(self.valorImagen);
        for fila:= IzqArr.y+1 to DerAbj.y+1 do
          for columna:=IzqArr.x+1 to DerAbj.x+1 do
            valorImagen.mdatos[fila,columna]:= 0;
      end;
end;

procedure TImagen.deshacer;
var
  valorAux: RValorImagen;
begin
  valorAux:=valorImagen;
  //  inherited deshacer;
  valorImagen:=historial.deshacer(valorAux);
end;

function TImagen.generarBitmap(altura,ancho:integer;bitmapbits:Pbitmapbits; 
        valor:RValorImagen): TBitmap32;
var
  ImagenBM: TBitmap32;
  garbage: Integer;
  x, y: Integer;
  rojo, verde, azul: TColor;
begin
  ImagenBM:=TBitmap32.Create;
  imagenbm.Height := altura;
  ImagenBM.Width:=ancho;
  //  ImagenBM. := pf8bit;
  for x:= 0 to ImagenBM.Width-1 do
    for y:= 0 to imagenbm.Height-1 do
    BEGIN
      rojo:= valor.paleta[valor.mdatos[y,x]].rgbred;
      azul:= valor.paleta[valor.mdatos[y,x]].rgbblue;
      verde:= valor.paleta[valor.mdatos[y,x]].rgbgreen;
  //      imagenbm.SetPixelT(x,y,color32(valor.paleta[valor.mdatos[y,x]].rgbRed,valor.paleta[valor.mdatos[y,x]].rgbGreen,valor.paleta[valor.mdatos[y,x]].rgbblue));
      imagenbm.SetPixelT(x,y,color32((azul SHL 16)OR(verde SHL 8)OR (rojo)));
    END;
  //  garbage:=SetBitmapBits(ImagenBM.Handle,altura*ancho,bitmapbits);
  //  garbage:=SetDIBColorTable(ImagenBM.Canvas.Handle,0,255,valor.paleta);
  result:= ImagenBM;
end;

function TImagen.getPointer: Pointer;
var
  retorno: ^RValorImagen;
begin
  new(retorno);
  retorno.MDatos:=copy(valorImagen.MDatos);
  retorno.Mascara:=copy(valorImagen.Mascara);
  retorno.paleta:=valorImagen.paleta;
  result := retorno;
  {TODO: recordar dispose(estructura) cuando termina el algoritmo!!!}
end;

function TImagen.getSeleccion: TBitmap32;
  
  type
    puntoseleccion = record
        x,y:integer;
    end;
  var
    imagenaux:TBitmap32;
    bitmapbits: Pbitmapbits;
    srchH,srchV, fila, columna:integer;
    IzqArr,DerAbj:puntoseleccion;
    topf,botf:boolean;
    Datos: RValorImagen;
  
begin
  topf:=false;
  botf:=false;
    // obtener el area seleccionada
  srchV:=0;
  srchH:=0;
  repeat // busqueda topleft desde arriba
    if (valorimagen.Mascara[srchV,srchH] = 1)  and (not topf) then
    begin
      IzqArr.x:=srchH;
      IzqArr.y:=srchV;
      topf:= true;
    end;
    inc(srchV);
    if ( srchV = valorImagen.Height-1) and (not (srchH =valorImagen.Width-1)) then
    begin
      srchV:=0;
      inc(srchH);
    end;
  until (topf or(( srchV = valorImagen.Height-1) and (srchH =valorImagen.Width-1)));
  // Fin busqueda topleft
  if topf then // si encontro topleft; sino no existe seleccion
  begin // busqueda bottomright desde abajo
    srchV:=valorImagen.Height-1;
    srchH:=valorImagen.Width-1;
    repeat
      if (valorimagen.Mascara[srchV,srchH] = 1)  and (not botf) then
      begin
        DerAbj.x:=srchH;;
        DerAbj.y:=srchV;
        botf:= true;
      end;
      dec(srchV);
      if ( srchV = 0) and (not (srchH =0)) then
      begin
        srchV:=valorImagen.Height-1;
        dec(srchH);
      end;
    until (botf or(( srchV = 0) and (srchH =0)));
  end;
  
  
      if topf and botf then
      begin
        SetLength(Datos.MDatos,(DerAbj.y-IzqArr.y+1),(DerAbj.x-IzqArr.x+1));
        bitmapbits:= AllocMem((DerAbj.y-IzqArr.y+1)*(DerAbj.x-IzqArr.x+1));
        datos.Paleta:=valorImagen.Paleta;
        for fila:=0 to (DerAbj.y-IzqArr.y) do
          for columna:=0 to (DerAbj.x-IzqArr.x) do
          begin
            // TODO: MDATOS = MDATOS y Compiar Paleta
            datos.MDatos[fila,Columna]:=valorImagen.mdatos[IzqArr.y+fila,IzqArr.x+columna];
            bitmapbits[fila*(DerAbj.x-IzqArr.x)+columna]:=valorImagen.mdatos[IzqArr.y+fila,IzqArr.x+columna];
          end;
        imagenaux:= TBitmap32.Create;
        imagenaux:= (generarBitmap((DerAbj.y-IzqArr.y+1),(DerAbj.x-IzqArr.x+1),bitmapbits,Datos));
        result:= imagenaux;
      end
      else
        result:=nil;
end;

function TImagen.getSeleccionAsObject: TImagen;
  
  type
    puntoseleccion = record
        x,y:integer;
    end;
  var
    imagen: TImagen;
    srchH,srchV, fila, columna:integer;
    IzqArr,DerAbj:puntoseleccion;
    topf,botf:boolean;
  //    Datos: PValorImagen;
  
begin
  topf:=false;
  botf:=false;
    // obtener el area seleccionada
  srchV:=0;
  srchH:=0;
  repeat // busqueda topleft desde arriba
    if (valorimagen.Mascara[srchV,srchH] = 1)  and (not topf) then
    begin
      IzqArr.x:=srchH;
      IzqArr.y:=srchV;
      topf:= true;
    end;
    inc(srchV);
    if ( srchV = valorImagen.Height-1) and (not (srchH =valorImagen.Width-1)) then
    begin
      srchV:=0;
      inc(srchH);
    end;
  until (topf or(( srchV = valorImagen.Height-1) and (srchH =valorImagen.Width-1)));
  // Fin busqueda topleft
  if topf then // si encontro topleft; sino no existe seleccion
  begin // busqueda bottomright desde abajo
    srchV:=valorImagen.Height-1;
    srchH:=valorImagen.Width-1;
    repeat
      if (valorimagen.Mascara[srchV,srchH] = 1)  and (not botf) then
      begin
        DerAbj.x:=srchH;;
        DerAbj.y:=srchV;
        botf:= true;
      end;
      dec(srchV);
      if ( srchV = 0) and (not (srchH =0)) then
      begin
        srchV:=valorImagen.Height-1;
        dec(srchH);
      end;
    until (botf or(( srchV = 0) and (srchH =0)));
  end;
  
  if topf and botf then
  begin
    imagen:= TImagen.Create;
  //    new(Datos);
    imagen.valorImagen.Height:=(DerAbj.y-IzqArr.y+1);
    imagen.valorImagen.Width:=(DerAbj.x-IzqArr.x+1);
    SetLength(imagen.valorImagen.MDatos,(DerAbj.y-IzqArr.y+1),(DerAbj.x-IzqArr.x+1));
    SetLength(imagen.valorImagen.Mascara,(DerAbj.y-IzqArr.y+1),(DerAbj.x-IzqArr.x+1));
    imagen.valorImagen.Paleta:=valorImagen.Paleta;
    for fila:=0 to (DerAbj.y-IzqArr.y) do
      for columna:=0 to (DerAbj.x-IzqArr.x) do
      begin
        // TODO: MDATOS = MDATOS y Compiar Paleta
        imagen.valorImagen.MDatos[fila,Columna]:=valorImagen.mdatos[IzqArr.y+fila,IzqArr.x+columna];
      end;
      result := Imagen;
  end
  else
      result := nil;
end;

function TImagen.getValor: TBitmap32;
var
  bitmapbits: Pbitmapbits;
  i, j: Integer;
begin
      bitmapbits:=AllocMem(valorImagen.Height*valorImagen.Width);
      for i:=0 to  valorImagen.Height-1 do
        for j:= 0 to valorImagen.Width-1 do
        begin
          bitmapbits[i*valorImagen.Width+j]:= valorImagen.mdatos[i,j];
        end;
  result:=generarBitmap(valorImagen.Height,valorImagen.Width,bitmapbits,valorimagen);
end;

procedure TImagen.getXML(var XML: IXMLNode);
begin
end;

procedure TImagen.guardar(nombreArchivo: string);
  
  type
    tbitmapbits = array [0..0] of byte;
  var
    thebitmap: THandle;
    bitmapbits: Pbitmapbits;
    looprow, loopcol, colores:integer;
    varjpg:TJPEGImage;
    ImagenBM:TBitmap32;
    graphic:TGraphic;
    imagen1:TImage32;
  
begin
  imagen1:=TImage32.Create(nil);
  getmem(bitmapbits,valorImagen.Height*valorImagen.Width);
  for looprow:=0 to valorImagen.Height -1 do
    for loopcol:= 0 to valorImagen.Width-1 do
      bitmapbits[looprow*valorImagen.Width+loopcol]:=valorImagen.mdatos[looprow,loopcol];
  ImagenBM:=generarBitmap(valorImagen.Height,valorImagen.Width,bitmapbits,valorImagen);
  imagen1.Bitmap.Assign(ImagenBM);
  if (uppercase(ExtractFileExt(nombreArchivo)) = '.BMP') then
    ImagenBM.SaveToFile(nombreArchivo)
  else
  if (uppercase(ExtractFileExt(nombreArchivo)) = '.JPG') or (uppercase(ExtractFileExt(nombreArchivo)) = '.JPEG') then
  begin //jpg
  //   SaveTo24bitJPEGFile(ImagenBM,nombreArchivo,100,true);
      varjpg:= TJPEGImage.Create;
      varjpg.PixelFormat := jf8bit;
      varjpg.JPEGNeeded;
      varjpg.ProgressiveEncoding:= true;
      varjpg.Assign(ImagenBM);
      varjpg.SaveToFile(nombreArchivo);
  end
  else
    raise Exception.Create('Error Archivo de imagen erroneo!');
end;

procedure TImagen.imprimir;
begin
  inherited imprimir;
end;

procedure TImagen.rehacer;
var
  valorAux: RValorImagen;
begin
  valorAux:=valorImagen;
  inherited rehacer;
  valorImagen:=historial.rehacer(valorAux);
end;

procedure TImagen.setImagen(unaImagen:TImagen; unaPosicion:TPoint);
var
  x, y: Integer;
  limitealto, limiteancho: Integer;
begin
  if (self.valorImagen.Height < unaPosicion.Y+unaImagen.valorImagen.Height-1) then
    limitealto := self.valorImagen.Height
  else
    limitealto := unaPosicion.Y+unaImagen.valorImagen.Height-1;
  if (self.valorImagen.width < unaPosicion.X+unaImagen.valorImagen.width-1) then
    limiteancho := self.valorImagen.Width
  else
    limiteancho := unaPosicion.X+unaImagen.valorImagen.Width-1;
  self.historial.agregar(self.valorImagen);
  for y:= unaPosicion.Y to limitealto do
    for x:= unaPosicion.X to limiteancho do
      valorImagen.MDatos[y,x]:=unaImagen.valorImagen.MDatos[y-unaPosicion.Y,x-unaPosicion.X];
end;

procedure TImagen.setPointer(puntero: pointer);
var
  retorno: ^RValorImagen;
begin
  retorno:= puntero;
  valorImagen.MDatos:=copy(retorno^.MDatos);
  valorImagen.Mascara:=copy(retorno^.Mascara);
  valorImagen.Paleta:=retorno^.Paleta;
end;

procedure TImagen.setSeleccion(tipo:byte;seleccion:TRect);
var
  i, j: Integer;
begin
  case tipo of
    1: // rectangular
      begin
        for i:= 0 to valorimagen.Height-1 do
          for j:= 0 to valorimagen.Width-1  do
            valorimagen.mascara[i,j]:=0;
        for i:= seleccion.Top-1 to seleccion.Bottom-1 do
          for j:= seleccion.Left-1 to seleccion.Right-1 do
            valorimagen.mascara[i,j]:=1;
      end;
    2: // elipse
      begin
      end;
    end;
end;

procedure TImagen.setValor(unValor, unIdioma: string);
begin
end;

procedure TImagen.setValor(valor:RValorImagen);
begin
  valorImagen:=valor;
end;

procedure TImagen.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TImagen.setXML(XML:IXMLNode);
begin
  inherited setXML(XML);
end;

class function TImagen.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;


{
********************************* TListaTipos **********************************
}
procedure TListaTipos.agregar(tipoContenible: TTipoContenible);
begin
end;

function TListaTipos.buscar(unaFila, unaColumna:integer): TTipoContenible;
begin
  {TODO: Implementar TListaTipos.buscar}
end;

procedure TListaTipos.insertar(tipoContenible: TTipoContenible; index:integer);
begin
  inherited insertar(tipoContenible, index);
end;

function TListaTipos.primero: TTipoContenible;
begin
  {TODO: Implementar TListaTipos.primero}
end;

function TListaTipos.siguiente: TTipoContenible;
begin
  {TODO: Implementar TListaTipos.siguiente}
end;

{
**************************** TCmdMatrizInsertarFila ****************************
}
function TCmdMatrizInsertarFila.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizEliminarFila;
  i, j, filaFinal: Integer;
  tipo: TTipoContenible;
  filas, columnas: Integer;
begin
  filas:= unaMatriz.cantidadFilas;
  columnas:= unaMatriz.cantidadColumnas;
  if Length(lista)>0 then
  begin
    filaInicial:=MaxInt;
    filaFinal:=MinInt;
    for i:=low(lista) to high(lista) do
    begin
      if filaInicial>lista[i].unaFila then
        filaInicial:=lista[i].unaFila;
      if filaFinal<lista[i].unaFila then
        filaFinal:=lista[i].unaFila;
    end;
    for i:=filaInicial to filaFinal do
      unaMatriz.insertarFila(i);
    for i:=low(lista) to high(lista) do
      unaMatriz.agregar(lista[i].unaFila, lista[i].unaColumna, TTipoContenible(lista[i].unTipo));
    cantidadFilas := filaFinal - filaInicial + 1;
  end
  else
  begin
    for i:= filaInicial to filaInicial+cantidadFilas-1 do
    begin
      unaMatriz.insertarFila(i);
      for j:= 1 to columnas do
      begin
        tipo := TTipoContenible(TBuilderTipoDato.Instance.CreateTipo(tipoDato));
        tipo.setValor(unValor,'');
        unaMatriz.agregar(i, j, tipo);
      end;
    end;
  end;
  //estaba esto! estaba mal???
  //  cmdDeshacer:= TCmdMatrizEliminarColumna.Create;
  
  cmdDeshacer:= TCmdMatrizEliminarFila.Create;
  cmdDeshacer.inicializa(filaInicial, filaInicial + cantidadFilas -1);
  result := cmdDeshacer;
end;

procedure TCmdMatrizInsertarFila.inicializa(filaInicial, cantidadFilas: integer;
        tipoDato, unValor:string);
begin
  self.filaInicial  := filaInicial;
  self.cantidadFilas := cantidadFilas;
  self.tipoDato := tipoDato;
  self.unValor := unValor;
end;

procedure TCmdMatrizInsertarFila.inicializa(unaFila, unaColumna: integer; 
        unTipo:TTipoContenible);
begin
  SetLength(lista, length(lista)+1);
  lista[length(lista)-1].unaFila := unaFila;
  lista[length(lista)-1].unaColumna := unaColumna;
  lista[length(lista)-1].unTipo := unTipo;
end;

{
******************************* TCmdMatrizCopiar *******************************
}
function TCmdMatrizCopiar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  matrizAux: TMatrizSimple;
  i: Integer;
  j: Integer;
begin
  //  matrizAux := TMatrizSimple.Create;
  //  for i:= filaInicial to filaFinal do
  //  begin
  //    matrizAux.insertarFila(i);
  //    for j:= columnaInicial to columnaFinal do
  //      matrizAux.agregar(i-filaInicial+1, j-columnaInicial+1, unaMatriz.getCelda(i, j));
  //  end;
  //  TPortapapeles.Instance.agregarVector(matrizAux);
end;

procedure TCmdMatrizCopiar.inicializa(filainicial, columnaInicial, filaFinal, 
        columnaFinal: integer);
begin
  self.filainicial := filainicial;
  self.columnaInicial := columnaInicial;
  self.filaFinal := filaFinal;
  self.columnaFinal := columnaFinal;
end;

{
******************************* TCmdMatrizCortar *******************************
}
function TCmdMatrizCortar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  matrizAux: TMatrizSimple;
  i: Integer;
  j: Integer;
  cmdDeshacer: TCmdMatrizModificar;
begin
  //  matrizAux := TMatrizSimple.Create;
  //  cmdDeshacer := TCmdMatrizModificar.Create;
  //  for i:= filaInicial to filaFinal do
  //  begin
  //    matrizAux.insertarFila(i);
  //    for j:= columnaInicial to columnaFinal do
  //    begin
  //      matrizAux.agregar(i-filaInicial+1, j-columnaInicial+1, unaMatriz.getCelda(i, j));
  //      cmdDeshacer.inicializa(i-filaInicial+1,j-columnaInicial+1,unaMatriz.getCelda(i, j).getValor(''));
  //      unaMatriz.setValor(i, j, ValorInicial);
  //    end;
  //  end;
  //  TPortapapeles.Instance.agregarVector(matrizAux);
end;

procedure TCmdMatrizCortar.inicializa(filainicial, columnaInicial, filaFinal, 
        columnaFinal: integer; valorInicial: string);
begin
  self.filainicial := filainicial;
  self.columnaInicial := columnaInicial;
  self.filaFinal := filaFinal;
  self.columnaFinal := columnaFinal;
  self.valorInicial := valorInicial;
end;

{
******************************* TCmdMatrizPegar ********************************
}
function TCmdMatrizPegar.ejecutar(unaMatriz: TMatrizSimple): TComando;
begin
end;

procedure TCmdMatrizPegar.inicializa(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer);
begin
  self.filainicial := filainicial;
  self.columnaInicial := columnaInicial;
  self.filaFinal := filaFinal;
  self.columnaFinal := columnaFinal;
end;

{
***************************** TCmdMatrizModificar ******************************
}
function TCmdMatrizModificar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizModificar;
  valorAnt: TTipoContenible;
  i: Integer;
  hayCambio: Boolean;
  strAnterior: string;
begin
  cmdDeshacer:= TCmdMatrizModificar.Create;
  hayCambio:= false;
  for i := low(lista) to high(lista) do
  begin
    valorAnt := unaMatriz.getCelda(lista[i].unaFila, lista[i].unaColumna);
    strAnterior := valorAnt.getValor('');
    cmdDeshacer.inicializa(lista[i].unaFila, lista[i].unaColumna, valorAnt.getValor(''));
    unaMatriz.setValor(lista[i].unaFila, lista[i].unaColumna, lista[i].unValor);
    hayCambio:= hayCambio or (strAnterior <> unaMatriz.getCelda(lista[i].unaFila, lista[i].unaColumna).getValor(''));
  end;
  if not hayCambio then
    FreeAndNil(cmdDeshacer);
  result := cmdDeshacer;
end;

procedure TCmdMatrizModificar.inicializa(unaFila, unaColumna: integer; 
        unValor:string);
begin
  SetLength(lista, length(lista)+1);
  lista[length(lista)-1].unaFila := unaFila;
  lista[length(lista)-1].unaColumna := unaColumna;
  lista[length(lista)-1].unValor := unValor;
end;

{
************************** TCmdMatrizInsertarColumna ***************************
}
function TCmdMatrizInsertarColumna.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizEliminarColumna;
  i, j, columnaFinal: Integer;
  tipo: TTipoContenible;
begin
  if Length(lista)>0 then
  begin
    columnaInicial:=MaxInt;
    columnaFinal:=MinInt;
    for i:=low(lista) to high(lista) do
    begin
      if columnaInicial>lista[i].unaColumna then
        columnaInicial:=lista[i].unaColumna;
      if columnaFinal<lista[i].unaColumna then
        columnaFinal:=lista[i].unaColumna;
      unaMatriz.agregar(lista[i].unaFila, lista[i].unaColumna, TTipoContenible(lista[i].unTipo));
    end;
    cantidadColumnas:= columnaFinal-columnaInicial +1;
  end
  else
  begin
    for i:= 1  to unaMatriz.cantidadFilas do
      for j:= columnaInicial to columnaInicial+cantidadColumnas-1 do
      begin
        tipo := TTipoContenible(TBuilderTipoDato.Instance.CreateTipo(tipoDato));
        tipo.setValor(unValor,'');
        unaMatriz.agregar(i, j, tipo);
      end;
  end;
  cmdDeshacer:= TCmdMatrizEliminarColumna.Create;
  cmdDeshacer.inicializa(columnaInicial, columnaInicial+cantidadColumnas-1);
  result := cmdDeshacer;
end;

procedure TCmdMatrizInsertarColumna.inicializa(columnaInicial, 
        cantidadColumnas: integer; tipoDato, unValor:string);
begin
  self.columnaInicial := columnaInicial;
  self.cantidadColumnas := cantidadColumnas;
  self.tipoDato := tipoDato;
  self.unValor := unValor;
end;

procedure TCmdMatrizInsertarColumna.inicializa(unaFila, unaColumna: integer; 
        unTipo:TTipoContenible);
begin
  SetLength(lista, length(lista)+1);
  lista[length(lista)-1].unaFila := unaFila;
  lista[length(lista)-1].unaColumna := unaColumna;
  lista[length(lista)-1].unTipo := unTipo;
end;

{
**************************** TCmdMatrizInicializar *****************************
}
function TCmdMatrizInicializar.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  i, j: Integer;
  tipo: TTipoContenible;
begin
  for i:= 1 to nroFilas do
  begin
    unaMatriz.insertarFila(i);
    for j:= 1 to nroColumnas do
    begin
      tipo := TTipoContenible(TBuilderTipoDato.Instance.CreateTipo(tipoDato));
      tipo.setValor(valorInicial,'');
      unaMatriz.agregar(i, j, tipo);
    end;
  end;
end;

procedure TCmdMatrizInicializar.inicializa(nroFilas, nroColumnas:integer; 
        tipoDato, valorInicial:string);
begin
  self.nroColumnas := nroColumnas;
  self.nroFilas := nroFilas;
  self.tipoDato := tipoDato;
  self.valorInicial := valorInicial;
end;

{
**************************** TCmdMatrizEliminarFila ****************************
}
function TCmdMatrizEliminarFila.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizInsertarFila;
  i, j: Integer;
begin
  //  cmdDeshacer:= TCmdMatrizInsertarColumna.Create;
  cmdDeshacer:= TCmdMatrizInsertarFila.Create;
  for i:= filaFinal downto filaInicial do
  begin
    for j:= 1 to unaMatriz.cantidadColumnas do
      cmdDeshacer.inicializa(i, j, unaMatriz.getCelda(i,j));
    unaMatriz.eliminarfila(i);
  end;
  result := cmdDeshacer;
end;

procedure TCmdMatrizEliminarFila.inicializa(filainicial, filaFinal: integer);
begin
  self.filaInicial:= filaInicial;
  self.filaFinal := filaFinal;
end;

{
************************** TCmdMatrizEliminarColumna ***************************
}
function TCmdMatrizEliminarColumna.ejecutar(unaMatriz: TMatrizSimple): TComando;
var
  cmdDeshacer: TCmdMatrizInsertarColumna;
  i, j: Integer;
begin
  cmdDeshacer:= TCmdMatrizInsertarColumna.Create;
  for j:= columnaFinal downto columnaInicial do
  begin
    for i:= 1 to unaMatriz.cantidadFilas do
    begin
      cmdDeshacer.inicializa(i, j, unaMatriz.getCelda(i,j));
      unaMatriz.eliminarCelda(i, j);
    end;
  end;
  result := cmdDeshacer;
end;

procedure TCmdMatrizEliminarColumna.inicializa(columnaInicial, columnaFinal: 
        integer);
begin
  self.columnaInicial:= columnaInicial;
  self.columnaFinal:= columnaFinal
end;


{
*********************************** TMatriz ************************************
}
constructor TMatriz.Create;
begin
  inherited create;
  nombre := 'Matriz' + IntToStr(updateNumero);
  historial:= THistorialComandos.Create;//lo hace el padre
  Matriz:= TMatrizSimple.Create;
end;

procedure TMatriz.abrir(nombreArchivo: String);
var
  XML: IXMLDocument;
  aux: IXMLNode;
begin
  Matriz.Free;
  Matriz := TMatrizSimple.Create;
  XML:= TXMLDocument.Create(nombreArchivo);
  aux:= XML.DocumentElement;
  tipoDato := aux.Attributes['tipoDato'];
  valorInicial := aux.Attributes['valorInicial'];
  if LowerCase(aux.NodeName) = 'matriz' then
    Matriz.setXML(aux)//.ChildNodes.Nodes[0])
  else
    raise Exception.CreateFmt('El archivo %s no tiene la estructura de una Matriz', [nombreArchivo]);
end;

function TMatriz.copiarMatriz(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer): TMatrizSimple;
var
  comando: TCmdMatrizCopiar;
begin
    try
      comando:= TCmdMatrizCopiar.Create;
      comando.inicializa(filaInicial, columnaInicial, filaFinal, columnaFinal);
      comando.ejecutar(matriz);
    finally
      FreeAndNil(comando);
  end
end;

function TMatriz.cortarMatriz(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer): TMatrizSimple;
var
  comando: TCmdMatrizCortar;
  cmdDeshacer: TComando;
begin
  try
    comando:= TCmdMatrizCortar.Create;
    comando.inicializa(filaInicial, columnaInicial, filaFinal, columnaFinal, valorInicial);
    cmdDeshacer := comando.ejecutar(matriz);
    historial.agregar(cmdDeshacer);
  finally
    FreeAndNil(comando);
  end;
end;

procedure TMatriz.deshacer;
var
  comando: TComando;
begin
  //  inherited deshacer;
  comando := historial.deshacer;
  historial.agregarRehacer(comando.ejecutar(Matriz));
end;

procedure TMatriz.eliminarColumnas(columnaIncial, columnaFinal:integer);
var
  comando: TComando;
begin
  if Matriz.cantidadColumnas > columnaFinal-columnaIncial+1 then
  begin
    comando := TCmdMatrizEliminarColumna.Create;
    TCmdMatrizEliminarColumna(comando).inicializa(columnaIncial,columnaFinal);
    historial.agregar(comando.ejecutar(matriz));
    FreeAndNil(comando);
  end
  else
    raise Exception.Create('No es posible eliminar la columna, la matriz debe tener 1 columna como m�nimo');
end;

procedure TMatriz.eliminarFilas(filaIncial, filaFinal:integer);
var
  comando: TComando;
begin
  if Matriz.cantidadFilas > filaFinal-filaIncial+1 then
  begin
    comando := TCmdMatrizEliminarFila.Create;
    TCmdMatrizEliminarFila(comando).inicializa(filaIncial,filaFinal);
    historial.agregar(comando.ejecutar(matriz));
    FreeAndNil(comando);
  end
  else
    raise Exception.Create('No es posible eliminar la fila, la matriz debe tener 1 fila como m�nimo');
end;

function TMatriz.existeDeshacer: Boolean;
begin
  result := historial.existeDeshacer;
end;

function TMatriz.existeRehacer: Boolean;
begin
  result := historial.existeRehacer;
end;

function TMatriz.getArrayString: TMString;
begin
  result := Matriz.getArrayString;
end;

function TMatriz.getCantidadColumnas: Integer;
begin
  result := Matriz.cantidadColumnas;
end;

function TMatriz.getCantidadFilas: Integer;
begin
  result := Matriz.cantidadFilas;
end;

function TMatriz.getIDNombre: string;
begin
  result := 'Matriz' + IntToStr(updateNumero)
end;

function TMatriz.getPointer(unIdioma: TIdioma): Pointer;
begin
  result := Matriz.getPointer;
end;

function TMatriz.getTipoDato: string;
begin
  result := tipoDato;
end;

function TMatriz.getValorInicial: string;
begin
  result := valorInicial;
end;

procedure TMatriz.getXML(var XML: IXMLNode);
begin
  Matriz.getXML(XML);
end;

procedure TMatriz.guardar(nombreArchivo: string);
var
  XML: IXMLDocument;
  aux: IXMLNode;
  tmpFile: TextFile;
begin
  try
    AssignFile(tmpFile,nombreArchivo); //lets create the file before we continue....
                                               //i was unable to create it using the xml component...
    rewrite(tmpFile); //if the file exists empty it's content otherwise just open it in the "write" mode...
  
    //the header/structore of the xml file..
    writeln(tmpFile,'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
    writeln(tmpFile,'<Matriz>');
    writeln(tmpFile,'</Matriz>');
  finally
    CloseFile(tmpFile); //close the file
  end;
  
  XML:= TXMLDocument.Create(nombreArchivo);
  aux:= XML.DocumentElement;
  aux.Attributes['tipoDato']:=tipoDato;
  aux.Attributes['valorInicial'] := valorInicial;
  matriz.getXML(aux);
  XML.SaveToFile(nombreArchivo);
end;

procedure TMatriz.imprimir;
begin
  inherited imprimir;
end;

procedure TMatriz.inicializa(nroFilas, nroColumnas:integer; tipoDato, 
        valorInicial:string);
var
  comando: TCmdMatrizInicializar;
begin
  if (nroFilas >=1) and (nroColumnas >= 1) then
  begin
    self.tipoDato := tipoDato;
    self.valorInicial := valorInicial;
    //
    comando := TCmdMatrizInicializar.Create;
    comando.inicializa(nroFilas, nroColumnas, tipoDato, valorInicial);
    comando.ejecutar(matriz);
    FreeAndNil(comando);
  end
  else
    raise Exception.Create('Error! La matriz debe tener al menos 1 fila y 1 columna.');
end;

procedure TMatriz.insertarColumnas(unaColumna, cantidadColumnas:integer);
var
  comando: TComando;
begin
  comando := TCmdMatrizInsertarColumna.Create;
  TCmdMatrizInsertarColumna(comando).inicializa(unaColumna, cantidadColumnas, tipoDato, valorInicial);
  historial.agregar(comando.ejecutar(matriz));
  FreeAndNil(comando);
end;

procedure TMatriz.insertarFilas(unaFila, cantidadFilas:integer);
var
  comando: TCmdMatrizInsertarFila;
begin
  comando := TCmdMatrizInsertarFila.Create;
  comando.inicializa(unaFila, cantidadFilas, tipoDato, valorInicial);
  historial.agregar(comando.ejecutar(matriz));
  FreeAndNil(comando);
end;

procedure TMatriz.modificarCelda(unaFila, unaColumna: integer; unValor:string);
var
  comando: TCmdMatrizModificar;
begin
  comando := TCmdMatrizModificar.Create;
  comando.inicializa(unaFila, unaColumna, unValor);
  historial.agregar(comando.ejecutar(matriz));
  // FreeAndNil(comando);
   //  Matriz.setValor(unaFila,unaColumna,unValor);
end;

procedure TMatriz.pegarMatriz(filaInicial, columnaInicial, filaFinal, 
        columnaFinal:integer);
begin
end;

procedure TMatriz.redimensionar(filas, columnas: integer);
var
  comando: TComando;
begin
  if Matriz.cantidadFilas < filas then
  begin
    comando := TCmdMatrizInsertarFila.Create;
    TCmdMatrizInsertarFila(comando).inicializa(Matriz.cantidadFilas+1, filas - Matriz.cantidadFilas, tipoDato, valorInicial);
    historial.agregar(comando.ejecutar(matriz));
    FreeAndNil(comando);
  end
  else
  begin
    if Matriz.cantidadFilas > filas then
    begin
      comando := TCmdMatrizEliminarFila.Create;
      TCmdMatrizEliminarFila(comando).inicializa(filas+1,Matriz.cantidadFilas);
      historial.agregar(comando.ejecutar(matriz));
      FreeAndNil(comando);
    end;
  end;
  if Matriz.cantidadColumnas < columnas then
  begin
    comando := TCmdMatrizInsertarColumna.Create;
    TCmdMatrizInsertarColumna(comando).inicializa(Matriz.cantidadColumnas+1, columnas - Matriz.cantidadColumnas, tipoDato, valorInicial);
    historial.agregar(comando.ejecutar(matriz));
    FreeAndNil(comando);
  end
  else
  begin
    if Matriz.cantidadColumnas > columnas then
    begin
      comando := TCmdMatrizEliminarColumna.Create;
      TCmdMatrizEliminarColumna(comando).inicializa(columnas+1,Matriz.cantidadColumnas);
      historial.agregar(comando.ejecutar(matriz));
      FreeAndNil(comando);
    end;
  end;
end;

procedure TMatriz.rehacer;
var
  comando: TComando;
begin
  //  inherited rehacer;
  comando := historial.rehacer;
  historial.agregarDeshacer(comando.ejecutar(Matriz));
end;

procedure TMatriz.reInicializar(nroFilas, nroColumnas:integer; tipoDato, 
        valorInicial:string);
begin
  if (Self.tipoDato = tipoDato) and (self.valorInicial = valorInicial) then
    redimensionar(nroFilas,nroColumnas)
  else
  begin
    Matriz.Free;
    Matriz := TMatrizSimple.Create;
    inicializa(nroFilas,nroColumnas,tipoDato,valorInicial);
  end;
end;

procedure TMatriz.setPointer(puntero: pointer);
begin
  Matriz.setPointer(puntero);
end;

procedure TMatriz.setValor(unValor, unIdioma: string);
begin
end;

procedure TMatriz.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TMatriz.setXML(XML: IXMLNode);
begin
  Matriz.setXML(XML);
end;

function TMatriz.tipoEstructura: string;
begin
  result := 'Matriz';
end;

class function TMatriz.updateNumero(numero:integer=-1): Word;
  
  const FNumero:integer=0;
  
begin
  if numero<0 then
    inc(FNumero)
  else
    if numero=FNumero then
      dec(FNumero);
  result := FNumero;
end;

procedure TMatriz._agregar(unTipoContenible:TTipoCOntenible);
begin
end;

procedure TMatriz._getValor(unaCelda:integer);
begin
end;

procedure TMatriz._setMatrizSimple(matrizSimple: TmatrizSimple);
begin
end;


{
********************************* TTextoSimple *********************************
}
function TTextoSimple.getDFM: string;
begin
  if Assigned(idioma) then
    result := idioma.getCodigo +'='+ valor
  else
    result := valor;
end;

function TTextoSimple.getIdioma: TIdioma;
begin
  result := idioma;
end;

function TTextoSimple.getValor: string;
begin
  result := valor;
end;

procedure TTextoSimple.getXML(var XML: IXMLNode);
var
  textoSimple: IXMLNode;
begin
  textoSimple:=XML.AddChild('textoSimple');
  textoSimple.SetAttributeNS('valor','', valor);
  if Assigned(idioma) then
    textoSimple.SetAttributeNS('idioma','', idioma.getCodigo);
end;

procedure TTextoSimple.setIdioma(unIdioma:TIdioma);
begin
  idioma := unIdioma;
end;

procedure TTextoSimple.setValor(unValor: string);
begin
  valor:=unValor;
end;

procedure TTextoSimple.setXML(XML:IXMLNode);
begin
  valor:=XML.Attributes['valor'];
  if XML.Attributes['idioma'] <> Null then
    idioma:= TControlIdiomas.Instance.buscar(XML.Attributes['idioma']);
end;

{
********************************* TListaTextos *********************************
}
procedure TListaTextos.agregar(unTexto: TTextoSimple);
begin
  inherited agregar(unTexto);
end;

function TListaTextos.buscar(unIdioma:TIdioma): TTextoSimple;
var
  aux: TTextoSimple;
begin
  aux := primero;
  while Assigned(aux) and Assigned(unIdioma) and (aux.getIdioma <> unIdioma) do
    aux := siguiente;
  result:=aux;
end;

function TListaTextos.primero: TTextoSimple;
var
  aux: TObject;
begin
  aux:=inherited primero;
  if Assigned(aux) then
    result :=TTextoSimple(aux)
  else
    result := nil;
end;

function TListaTextos.siguiente: TTextoSimple;
var
  aux: TObject;
begin
  aux:=inherited siguiente;
  if Assigned(aux) then
    result :=TTextoSimple(aux)
  else
    result := nil;
end;

{
************************************ TTexto ************************************
}
constructor TTexto.Create;
begin
  inherited;
  listaTextos := TListaTextos.Create;
end;

destructor TTexto.Destroy;
var
  aux: TTextoSimple;
begin
  aux:=listaTextos.primero;
  while Assigned(aux) do
  begin
    aux.Destroy;
    aux:=listaTextos.siguiente;
  end;
  listaTextos.Destroy;
  inherited;
end;

procedure TTexto.agregarIdioma(unIdioma:TIdioma);
var
  texto: TTextoSimple;
begin
  texto := TTextoSimple.Create;
  texto.setIdioma(unIdioma);
  texto.setValor(ConstInitValue);
  listaTextos.agregar(texto);
end;

function TTexto.getDFM: string;
var
  texto: TTextoSimple;
begin
  texto := listaTextos.primero;
  if assigned(texto) then
  begin
    result := texto.getDFM;
    texto := listaTextos.siguiente;
    while assigned(texto) do
    begin
      result := result + '|' + texto.getDFM;
      texto := listaTextos.siguiente;
    end;
  end;
end;

function TTexto.getPointer(unIdioma: TIdioma): Pointer;
begin
  result := PChar(listaTextos.buscar(unIdioma));
end;

function TTexto.getValor(unIdioma:string): string;
var
  controlIdiomas: TControlIdiomas;
  aux: TTextoSimple;
begin
  controlIdiomas:= TControlIdiomas.Instance;
  aux := listaTextos.buscar(controlIdiomas.buscar(unIdioma));
  if not Assigned(aux) then
    aux := TTextoSimple.Create;
  result := aux.getValor;
end;

procedure TTexto.getXML(var XML: IXMLNode);
var
  texto: IXMLNode;
  textoSimple: TTextoSimple;
begin
  texto := XML.AddChild('texto');
  textoSimple:=listaTextos.primero;
  while assigned(textoSimple) do
  begin
    textoSimple.getXML(texto);
    textoSimple:=listaTextos.siguiente;
  end;
end;

procedure TTexto.quitarIdioma(unIdioma: TIdioma);
var
  idioma: TIdioma;
begin
  listaTextos.eliminar(listaTextos.buscar(unIdioma));
end;

procedure TTexto.setPointer(puntero: pointer);
var
  texto: TTextoSimple;
begin
  texto := listaTextos.primero;
  while assigned(texto) do
  begin
    texto.valor:= strpas(puntero);
    texto := listaTextos.siguiente;
  end;
end;

procedure TTexto.setValor(unValor, unIdioma: string);
var
  idioma: TIdioma;
  controlIdiomas: TControlIdiomas;
  texto: TTextoSimple;
begin
  controlIdiomas:=TcontrolIdiomas.Instance;
  idioma:= controlIdiomas.buscar(unIdioma);
  texto := listaTextos.buscar(idioma);
  if not Assigned(texto) then
  begin
    texto := TTextoSimple.Create;
    texto.setIdioma(idioma);
    listaTextos.agregar(texto);
  end;
  texto.setValor(unValor);
  //  controlIdiomas.ReleaseInstance;
end;

procedure TTexto.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
var
  idioma: TIdioma;
  texto: TTextoSimple;
begin
  idioma:=listaIdiomas.primero;
  while Assigned(idioma) do   {TODO: Controlar que sea v�lido}
  begin
    texto := listaTextos.buscar(idioma);
    if not Assigned(texto) then
    begin
      texto := TTextoSimple.Create;
      texto.setIdioma(idioma);
      listaTextos.agregar(texto);
    end;
    texto.setValor(unValor);
    idioma:=listaIdiomas.siguiente;
  end;
end;

procedure TTexto.setXML(XML:IXMLNode);
var
  textoSimple: TTextoSimple;
  i: Integer;
begin
  textoSimple := nil;
  for i:= 0 to XML.ChildNodes.Count -1 do
  begin
    if XML.ChildNodes.Nodes[i].Attributes['idioma'] <> Null then
      textoSimple:=listaTextos.buscar(TControlIdiomas.Instance.buscar(XML.ChildNodes.Nodes[i].Attributes['idioma']));
    if not Assigned(textoSimple) then
    begin
      textoSimple:=TTextoSimple.Create;
      listaTextos.agregar(textoSimple);
    end;
    textoSimple.setXML(XML.ChildNodes.Nodes[i]);
  end;
end;

function TTexto.siguiente: TListaTextos;
begin
end;

procedure TTexto._agregar(unTexto:string; unIdioma:TIdioma);
begin
end;

{
*********************************** TNumero ************************************
}
constructor TNumero.Create;
begin
  valor := 0;
end;

function TNumero.getDFM: string;
begin
  result := floattostr(valor);
end;

function TNumero.getPointer(unIdioma: TIdioma): Pointer;
begin
  result := addr(valor);
end;

function TNumero.getValor(unIdioma: string): string;
begin
  result := FloatToStr(valor);
end;

procedure TNumero.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('numero');
  aux.Text := getValor('');
end;

procedure TNumero.setPointer(puntero: pointer);
var
  aux: PDouble;
begin
  aux := puntero;
  valor := aux^;
end;

procedure TNumero.setValor(unValor, unIdioma: string);
var
  aux: RComplejo;
  LPart: string;
  LLeftover: string;
  LReal: Double;
  LImaginary: Double;
  LSign: Integer;
  
  const
    SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
    SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
    SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
    SCmplxCouldNotParseReal = 'Could not parse real portion';
    SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
    SCmplxUnexpectedChars = 'Unexpected characters';
    SCmplxErrorSuffix = '%s [%s<?>%s]';
  
  function ParseNumber(const AText: string; out ARest: string; out ANumber:
          Double): Boolean;
  var
    LAt: Integer;
    LFirstPart: string;
  begin
    Result := True;
    Val(AText, ANumber, LAt);
    if LAt <> 0 then
    begin
      ARest := Copy(AText, LAt, MaxInt);
      LFirstPart := Copy(AText, 1, LAt - 1);
      Val(LFirstPart, ANumber, LAt);
      if LAt <> 0 then
        Result := False;
    end;
  end;
  
  function parseWhiteSpace(const AText: string; out ARest: string): Boolean;
  var
    LAt: Integer;
  begin
    LAt := 1;
    if AText <> '' then
    begin
      while AText[LAt] = ' ' do
        Inc(LAt);
      ARest := Copy(AText, LAt, MaxInt);
    end;
    Result := ARest <> '';
  end;
  
  procedure ParseError(const AMessage: string);
  begin
    raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
      Copy(unValor, 1, Length(unValor) - Length(LLeftOver)),
      Copy(unValor, Length(unValor) - Length(LLeftOver) + 1, MaxInt)]);
  end;
  
begin
  {  //cargo la variable auxiliar
    LLeftover := trim(unValor);
  
    //parseo la parte real
    if not ParseNumber(LLeftover, LPart, LReal) then
      ParseError(SCmplxCouldNotParseReal);
  
    ParseWhiteSpace(LPart, LLeftover);
    //Verifico que no queden letras
    if LLeftover='' then
      valor:=LReal
    else
    //si quedan letras hay un error
      ParseError(SCmplxUnexpectedChars);}
  valor:= strtoFloat(unValor);
end;

procedure TNumero.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TNumero.setXML(XML:IXMLNode);
begin
  setValor(XML.ChildNodes.Nodes[0].Text,'');
end;

{
******************************** TNumeroEntero *********************************
}
function TNumeroEntero.getDFM: string;
begin
  result := IntToStr(trunc(valor));
end;

function TNumeroEntero.getPointer(unIdioma: TIdioma): Pointer;
var
  aux: pinteger;
begin
  new(aux);
  aux^:= trunc(valor);
  result := aux;
end;

function TNumeroEntero.getValor(unIdioma: string): string;
begin
  result := IntToStr(trunc(valor));
end;

procedure TNumeroEntero.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('numeroEntero');
  aux.Text := getValor('');
end;

procedure TNumeroEntero.setPointer(puntero: pointer);
begin
  valor := pInteger(puntero)^;
end;

procedure TNumeroEntero.setValor(unValor, unIdioma: string);
  
  {var
    aux: RComplejo;
    LPart: string;
    LLeftover: string;
    LEntero: Integer;
    LImaginary: Double;
    LSign: Integer;
  
    const
      SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
      SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
      SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
      SCmplxCouldNotParseReal = 'Could not parse real portion';
      SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
      SCmplxUnexpectedChars = 'Unexpected characters';
      SCmplxErrorSuffix = '%s [%s<?>%s]';
  
    function ParseNumber(const AText: string; out ARest: string; out ANumber:
            integer): Boolean;
    var
      LAt: Integer;
      LFirstPart: string;
    begin
      Result := True;
      Val(AText, ANumber, LAt);
      if LAt <> 0 then
      begin
        ARest := Copy(AText, LAt, MaxInt);
        LFirstPart := Copy(AText, 1, LAt - 1);
        Val(LFirstPart, ANumber, LAt);
        if LAt <> 0 then
          Result := False;
      end;
    end;
  
    function parseWhiteSpace(const AText: string; out ARest: string): Boolean;
    var
      LAt: Integer;
    begin
      LAt := 1;
      if AText <> '' then
      begin
        while AText[LAt] = ' ' do
          Inc(LAt);
        ARest := Copy(AText, LAt, MaxInt);
      end;
      Result := ARest <> '';
    end;
  
    procedure ParseError(const AMessage: string);
    begin
      raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
        Copy(unValor, 1, Length(unValor) - Length(LLeftOver)),
        Copy(unValor, Length(unValor) - Length(LLeftOver) + 1, MaxInt)]);
    end;
  
  begin
    //cargo la variable auxiliar
    LLeftover := trim(unValor);
  
    //parseo la parte real
    if not ParseNumber(LLeftover, LPart, LEntero) then
      ParseError(SCmplxCouldNotParseReal);
  
    if not ParseWhiteSpace(LPart, LLeftover) then
  
    //Verifico que no queden letras
    if LLeftover='' then
      valor:=LEntero
    else
    //si quedan letras hay un error
      ParseError(SCmplxUnexpectedChars);}
  
begin
  valor := StrToInt(unValor);
end;

procedure TNumeroEntero.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TNumeroEntero.setXML(XML:IXMLNode);
begin
  setValor(XML.ChildNodes.Nodes[0].Text,'');
end;

{
********************************** TComplejo ***********************************
}
constructor TComplejo.Create;
begin
  valor.real := 0;
  valor.imaginario := 0;
end;

function TComplejo.getDFM: string;
var
  aux: string;
begin
  aux:= FloatToStr(valor.real);
  if valor.imaginario >= 0 then
    result:=aux+'+'+FloatToStr(valor.imaginario)+'i'
  else
    result:=aux+FloatToStr(valor.imaginario)+'i';
end;

function TComplejo.getPointer(unIdioma: TIdioma): Pointer;
var
  aux: ^RComplejo;
begin
  new(aux);
  aux^:=valor;
  result := aux;
end;

function TComplejo.getValor(unIdioma: string): string;
var
  aux: string;
begin
  aux:= FloatToStr(valor.real);
  if valor.imaginario >= 0 then
    result:=aux+'+'+FloatToStr(valor.imaginario)+'i'
  else
    result:=aux+FloatToStr(valor.imaginario)+'i';
end;

procedure TComplejo.getXML(var XML: IXMLNode);
var
  aux: IXMLNode;
begin
  aux:=XML.AddChild('complejo');
  aux.Text := getValor('');
end;

procedure TComplejo.setPointer(puntero: pointer);
var
  aux: ^RComplejo;
begin
  aux := puntero;
  valor := aux^;
end;

procedure TComplejo.setValor(unValor, unIdioma: string);
var
  aux: RComplejo;
  LPart: string;
  LLeftover: string;
  LReal: Double;
  LImaginary: Double;
  LSign: Integer;
  
  const
    SCmplxCouldNotParseImaginary = 'Could not parse imaginary portion';
    SCmplxCouldNotParseSymbol = 'Could not parse required ''%s'' symbol';
    SCmplxCouldNotParsePlus = 'Could not parse required ''+'' (or ''-'') symbol';
    SCmplxCouldNotParseReal = 'Could not parse real portion';
    SCmplxUnexpectedEOS = 'Unexpected end of string [%s]';
    SCmplxUnexpectedChars = 'Unexpected characters';
    SCmplxErrorSuffix = '%s [%s<?>%s]';
  
  function ParseNumber(const AText: string; out ARest: string; out ANumber:
          Double): Boolean;
  var
    LAt: Integer;
    LFirstPart: string;
  begin
    Result := True;
    Val(AText, ANumber, LAt);
    if LAt <> 0 then
    begin
      ARest := Copy(AText, LAt, MaxInt);
      LFirstPart := Copy(AText, 1, LAt - 1);
      Val(LFirstPart, ANumber, LAt);
      if LAt <> 0 then
        Result := False;
    end;
  end;
  
  function parseWhiteSpace(const AText: string; out ARest: string): Boolean;
  var
    LAt: Integer;
  begin
    LAt := 1;
    if AText <> '' then
    begin
      while AText[LAt] = ' ' do
        Inc(LAt);
      ARest := Copy(AText, LAt, MaxInt);
    end;
    Result := ARest <> '';
  end;
  
  procedure ParseError(const AMessage: string);
  begin
    raise EConvertError.CreateFmt(SCmplxErrorSuffix, [AMessage,
      Copy(unValor, 1, Length(unValor) - Length(LLeftOver)),
      Copy(unValor, Length(unValor) - Length(LLeftOver) + 1, MaxInt)]);
  end;
  
  procedure ParseErrorEOS;
  begin
    raise EConvertError.CreateFmt(SCmplxUnexpectedEOS, [unValor]);
  end;
  
begin
  // where to start?
  LLeftover := unValor;
  
  // first get the real portion
  if not ParseNumber(LLeftover, LPart, LReal) then
    ParseError(SCmplxCouldNotParseReal);
  
  // is that it?
  if not ParseWhiteSpace(LPart, LLeftover) then
    aux.real:=LReal
  
  // if there is more then parse the complex part
  else
  begin
  
    // look for the concat symbol
    LSign := 1;
    if LLeftover[1] = '-' then
      LSign := -1
    else if LLeftover[1] <> '+' then
      ParseError(SCmplxCouldNotParsePlus);
    LPart := Copy(LLeftover, 2, MaxInt);
  
    // skip any whitespace
    ParseWhiteSpace(LPart, LLeftover);
  
    // imaginary part
    if not ParseNumber(LLeftover, LPart, LImaginary) then
      ParseError(SCmplxCouldNotParseImaginary);
  
    // correct for sign
    LImaginary := LImaginary * LSign;
  
    ParseWhiteSpace(LPart, LLeftover);
  
    // make sure there is symbol!
    if not AnsiSameText(Copy(LLeftOver, 1, 1), 'i') then
      ParseError(Format(SCmplxCouldNotParseSymbol, ['i']));
    LPart := Copy(LLeftover, Length('i') + 1, MaxInt);
  
    // make sure the rest of the string is whitespaces
    ParseWhiteSpace(LPart, LLeftover);
    if LLeftover <> '' then
      ParseError(SCmplxUnexpectedChars);
    aux.real:=LReal;
    aux.imaginario:=LImaginary;
    // make it then
    valor:=aux;
  end;
end;

procedure TComplejo.setValor(unValor: string; listaIdiomas: TlistaIdiomas);
begin
  setValor(unValor,'');
end;

procedure TComplejo.setXML(XML:IXMLNode);
begin
  getValor('');
end;

{ TArreglo }




end.
