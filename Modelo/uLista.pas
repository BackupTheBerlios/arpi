unit uLista;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Contnrs;

type
  TLista = class (TObject)
  private
    indice: Integer;
    lista: TObjectList;
  protected
    procedure ordenarInt(Compare: TListSortCompare);
  public
    constructor Create; virtual;
    function agregar(unObjeto:TObject): Integer;
    procedure agregarPrimero(unObjeto:TObject);
    function count: Integer;
    procedure deleteAll;
    procedure eliminar(unObjeto:TObject);
    procedure eliminarTodos;
    function existe(unObjeto:TObject): Boolean;
    procedure insertar(unObjeto: TObject; index: integer);
    procedure modificar(unObjeto:TObject);
    procedure mover(actual, nuevo:integer);
    function primero: TObject;
    function siguiente: TObject;
    procedure vaciar;
  end;
  
  TListaClases = class (TObject)
  private
    indice: TStrings;
    lista: TClassList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function agregar(nombreClase:string; unaClase:TClass): Integer;
    function buscar(nombreClase:string): TClass;
    procedure eliminar(nombreClase:string);
    procedure eliminarTodos;
    function existe(unaClase:string): Boolean;
    procedure insertar(nombreClase:string; unaClase:TClass; index: integer);
    procedure mover(actual, nuevo:integer);
  end;
  
procedure Register;

implementation

procedure Register;
begin
end;

{
************************************ TLista ************************************
}
constructor TLista.Create;
begin
  lista := TObjectList.Create;
  indice:=0;
end;

function TLista.agregar(unObjeto:TObject): Integer;
begin
  result:=lista.Add(unObjeto);
end;

procedure TLista.agregarPrimero(unObjeto:TObject);
begin
  lista.Insert(0, unObjeto);
end;

function TLista.count: Integer;
begin
  result := lista.Count;
end;

procedure TLista.deleteAll;
  
  {No llama al destructor de los objetos contenidos en los nodos}
  
begin
  while lista.Count > 0 do
    lista.Extract(lista.First);
end;

procedure TLista.eliminar(unObjeto:TObject);
var
  aux: Integer;
begin
  lista.Extract(unObjeto);
{  aux:=lista.IndexOf(unObjeto);
  if aux>=0 then
    lista.Delete(aux);
    //lista.Items[aux]:=nil;}
end;

procedure TLista.eliminarTodos;
  
  {Eliminar todos LLAMA AL DESTRUCTOR DE LOS ELEMENTOS CONTENIDOS!}
  
begin
  lista.Clear;
  indice := 0;
end;

function TLista.existe(unObjeto:TObject): Boolean;
begin
  result := lista.IndexOf(unObjeto)>0;
end;

procedure TLista.insertar(unObjeto: TObject; index: integer);
begin
  {TODO: Implementar TLista.insertar???? s�lo la usa TListaTipos??? hay forma de cambiar eso???}
end;

procedure TLista.modificar(unObjeto:TObject);
begin
  lista.items[indice]:= unObjeto;
end;

procedure TLista.mover(actual, nuevo:integer);
begin
  lista.Move(actual, nuevo);
end;

procedure TLista.ordenarInt(Compare: TListSortCompare);
begin
  Lista.Sort(Compare);
end;

function TLista.primero: TObject;
begin
  indice:=0;
  if indice<= lista.Count-1 then
     result:=lista.items[indice]
  else
     result:=nil;
end;

function TLista.siguiente: TObject;
begin
  inc(indice);
  if indice<= lista.Count-1 then
     result:=lista.items[indice]
  else
     result:=nil;
end;

procedure TLista.vaciar;
begin
  //  lista := TObjectList.Create;
  eliminarTodos;
end;


{ TListaClasses }

{
********************************* TListaClases *********************************
}
constructor TListaClases.Create;
begin
  indice := TStringList.Create;
  lista := TClassList.Create;
end;

destructor TListaClases.Destroy;
begin
  FreeAndNil(indice);
  FreeAndNil(lista);
  inherited destroy;
end;

function TListaClases.agregar(nombreClase:string; unaClase:TClass): Integer;
begin
  indice.Add(nombreClase);
  result := lista.Add(unaClase);
end;

function TListaClases.buscar(nombreClase:string): TClass;
begin
  result := lista.Items[indice.indexOf(nombreClase)];
end;

procedure TListaClases.eliminar(nombreClase:string);
var
  valor: Integer;
begin
  valor := indice.indexOf(nombreClase);
  indice.Delete(valor);
  lista.Delete(valor);
end;

procedure TListaClases.eliminarTodos;
begin
  indice.ClassType;
  lista.Clear;
end;

function TListaClases.existe(unaClase:string): Boolean;
begin
  result := indice.IndexOf(unaClase)>0;
end;

procedure TListaClases.insertar(nombreClase:string; unaClase:TClass; index: 
        integer);
begin
  indice.Insert(index, nombreClase);
  lista.Insert(index, unaClase);
end;

procedure TListaClases.mover(actual, nuevo:integer);
begin
  indice.Move(actual, nuevo);
  lista.Move(actual, nuevo);
end;

end.
