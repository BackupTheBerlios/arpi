unit ufmMatriz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uTipos, ComCtrls, ToolWin, StdCtrls, ExtCtrls, Menus,
  ActnList, ufmConfigMatriz, JvDialogs, ImgList, AppEvnts, uEntornoEjecucion, Clipbrd,
  StdActns, JvExGrids, JvStringGrid, Grids;

type
  TfmMatriz = class (TForm)
    abrirMatriz: TAction;
    ApplicationEvents1: TApplicationEvents;
    copiar: TAction;
    cortar: TAction;
    deshacer: TAction;
    guardarMatriz: TAction;
    ImageList1: TImageList;
    JvOpenDMatriz: TJvOpenDialog;
    JvSaveDialog1: TJvSaveDialog;
    pegar: TAction;
    rehacer: TAction;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolBar4: TToolBar;
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
    procedure abrirMatrizExecute(Sender: TObject);
    procedure ApplicationEvents1Hint(Sender: TObject);
    procedure copiarExecute(Sender: TObject);
    procedure deshacerExecute(Sender: TObject);
    procedure deshacerUpdate(Sender: TObject);
    procedure guardarMatrizComoExecute(Sender: TObject);
    procedure guardarMatrizExecute(Sender: TObject);
    procedure pegarExecute(Sender: TObject);
    procedure pegarUpdate(Sender: TObject);
    procedure rehacerExecute(Sender: TObject);
    procedure rehacerUpdate(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure StringGrid1ExitCell(Sender: TJvStringGrid; AColumn, ARow: Integer;
            const EditText: String);
  private
    entorno: TEntornoEjecucion;
    FArchivoMatriz: string;
    FAyuda: string;
    FColumnaActual: Integer;
    FEstadoMatriz: string;
    FFilaActual: Integer;
    fmConfigMatriz: TfmPropiedadesMatriz;
    IDMatriz: string;
    procedure refrescarMatriz;
    procedure SetArchivoMatriz(const Value: string);
    procedure SetAyuda(const Value: string);
    procedure SetColumnaActual(const Value: Integer);
    procedure SetEstadoMatriz(const Value: string);
    procedure SetFilaActual(const Value: Integer);
    procedure SetTitulo(const Value: string);
  public
    procedure crearAbriendoMatriz(archivo:string);
    function crearNuevaMatriz: Boolean;
    property ArchivoMatriz: string read FArchivoMatriz write SetArchivoMatriz;
    property Ayuda: string read FAyuda write SetAyuda;
    property ColumnaActual: Integer read FColumnaActual write SetColumnaActual;
    property EstadoMatriz: string read FEstadoMatriz write SetEstadoMatriz;
    property FilaActual: Integer read FFilaActual write SetFilaActual;
    property Titulo: string write SetTitulo;
  published
    ActionList1: TActionList;
    configurarPropiedades: TAction;
    ConfigurarPropiedades1: TMenuItem;
    ControlBar1: TControlBar;
    ControlBar2: TControlBar;
    eliminarColumna: TAction;
    EliminarColumna1: TMenuItem;
    eliminarFila: TAction;
    EliminarFila1: TMenuItem;
    Hola1: TMenuItem;
    insertarColumna: TAction;
    insertarFila: TAction;
    InsertarFila1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    Panel1: TPanel;
    popMenuMatriz: TPopupMenu;
    StatusBar1: TStatusBar;
    StringGrid1: TjvStringGrid;
    ToolBar1: TToolBar;
    procedure configurarPropiedadesExecute(Sender: TObject);
    procedure eliminarColumnaExecute(Sender: TObject);
    procedure eliminarFilaExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure insertarColumnaExecute(Sender: TObject);
    procedure insertarFilaExecute(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var 
            CanSelect: Boolean);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer; 
            const Value: String);
  end;
  
var
  fmMatriz: TfmMatriz;
//  fmConfigMatriz : TfmPropiedadesMatriz;

implementation

{$R *.dfm}

{
********************************** TfmMatriz ***********************************
}
procedure TfmMatriz.abrirMatrizExecute(Sender: TObject);
begin
  if JvOpenDMatriz.Execute then
  begin
    //deberia cerrar la matriz?
    IDMatriz := entorno.abrirMatriz(JvOpenDMatriz.FileName);
    ArchivoMatriz := JvOpenDMatriz.FileName;
    Titulo := ArchivoMatriz;
    refrescarMatriz();
  end;
end;

procedure TfmMatriz.ApplicationEvents1Hint(Sender: TObject);
begin
  Ayuda := Application.Hint;
end;

procedure TfmMatriz.configurarPropiedadesExecute(Sender: TObject);
begin
  fmConfigMatriz.Filas := StringGrid1.RowCount;
  fmConfigMatriz.Columnas:= StringGrid1.ColCount;
  fmConfigMatriz.TipoDato := entorno.getTipoDatoMatriz(IDMatriz);// getTipoDato;
  fmConfigMatriz.ValorInicial := entorno.getValorInicialMatriz(IDMatriz);//Matriz.getValorInicial;
  if fmConfigMatriz.execute then
    entorno.reinicializarMatriz (IDMatriz,fmConfigMatriz.Filas, fmConfigMatriz.Columnas,fmConfigMatriz.TipoDato,fmConfigMatriz.ValorInicial);
    //Matriz.reInicializar(fmConfigMatriz.Filas, fmConfigMatriz.Columnas,fmConfigMatriz.TipoDato,fmConfigMatriz.ValorInicial);
  refrescarMatriz();
end;

procedure TfmMatriz.copiarExecute(Sender: TObject);
var
  texto: string;
  GRect: TGridRect;
  i, j: Integer;
begin
  GRect := StringGrid1.Selection;
  texto := '';
  for j := GRect.Top to GRect.Bottom do
  begin
    for i := GRect.Left to GRect.Right do
    begin
      if i = GRect.Right then
        texto := texto + StringGrid1.Cells[i,j]
      else
        texto := texto + StringGrid1.Cells[i,j] + #9;
    end;
    texto := texto + #13#10
  end;
  Clipboard.AsText := texto;
end;

procedure TfmMatriz.crearAbriendoMatriz(archivo:string);
begin
  ArchivoMatriz := archivo;
  Titulo := ArchivoMatriz;
  IDMatriz := entorno.abrirMatriz(ArchivoMatriz);
  refrescarMatriz();
end;

function TfmMatriz.crearNuevaMatriz: Boolean;
begin
  IDMatriz := '';
  fmConfigMatriz.Filas := 5;
  fmConfigMatriz.Columnas:= 5;
  fmConfigMatriz.TipoDato := 'letra';// getTipoDato;
  fmConfigMatriz.ValorInicial := 'a';//Matriz.getValorInicial;
  result := fmConfigMatriz.Execute;
  if result then
  begin
    IDMatriz := entorno.crearMatriz(fmConfigMatriz.Filas, fmConfigMatriz.Columnas,fmConfigMatriz.TipoDato,fmConfigMatriz.ValorInicial);
    refrescarMatriz();
  end
  else
    self.Close;
end;

procedure TfmMatriz.deshacerExecute(Sender: TObject);
begin
  entorno.deshacerMatriz(IDMatriz);
  refrescarMatriz;
end;

procedure TfmMatriz.deshacerUpdate(Sender: TObject);
begin
  deshacer.Enabled := (IDMatriz <> '') and (entorno.tieneDeshacerMatriz(IDMatriz));
end;

procedure TfmMatriz.eliminarColumnaExecute(Sender: TObject);
begin
  entorno.eliminarColumnas(IDMatriz,StringGrid1.Col+1,StringGrid1.Col+1);
  refrescarMatriz();
end;

procedure TfmMatriz.eliminarFilaExecute(Sender: TObject);
begin
  entorno.eliminarFilas(IDMatriz,StringGrid1.Row+1,StringGrid1.Row+1);
  refrescarMatriz();
end;

procedure TfmMatriz.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.Free;
end;

procedure TfmMatriz.FormCreate(Sender: TObject);
begin
  ArchivoMatriz:='';
  IDMatriz := '';
  entorno := TEntornoEjecucion.Instance;
  fmConfigMatriz := TfmPropiedadesMatriz.Create(self);
  //
  {  if ArchivoMatriz = '' then
      IDMatriz:= entorno.crearMatriz(6,6,'letra','c')
    else
      entorno.abrirMatriz(ArchivoMatriz);}
    //refrescarMatriz(entorno.getMatriz(IDMatriz));
  
end;

procedure TfmMatriz.guardarMatrizComoExecute(Sender: TObject);
begin
  if JvSaveDialog1.Execute then
  begin
    entorno.guardarMatriz(IDMatriz,JvSaveDialog1.FileName);
    ArchivoMatriz := JvSaveDialog1.FileName;
    Titulo := ArchivoMatriz;
  end
end;

procedure TfmMatriz.guardarMatrizExecute(Sender: TObject);
begin
  if JvSaveDialog1.Execute then
  begin
    entorno.guardarMatriz(IDMatriz,JvSaveDialog1.FileName);
    ArchivoMatriz := JvSaveDialog1.FileName;
    Titulo := ArchivoMatriz;
  end;
end;

procedure TfmMatriz.insertarColumnaExecute(Sender: TObject);
begin
  entorno.insertarColumnas(IDMatriz,StringGrid1.Col+1,1);
  refrescarMatriz();
end;

procedure TfmMatriz.insertarFilaExecute(Sender: TObject);
begin
  entorno.insertarFilas(IDMatriz,StringGrid1.Row+1,1);
  refrescarMatriz();
end;

procedure TfmMatriz.pegarExecute(Sender: TObject);
var
  GRect: TGridRect;
  I, F, C: Byte;
  texto, cs, resS: string;
begin
  GRect := StringGrid1.Selection;
  I := GRect.Left;
  F := GRect.Top;
  texto := clipboard.AsText;
  F := F-1;
  while pos (#13,texto)>0 do
  begin
    F := F+1;
    C := I-1;
    CS := copy(texto, 1,pos(#13,texto));
    while pos(#9,CS) >0 do
    begin
      C := C+1;
  //      if (C <= StringGrid1.ColCount-1) and (F <= StringGrid1.RowCount-1) then
      if (C <= entorno.cantidadColumnasMatriz(IDMatriz) -1) and (F <= entorno.cantidadFilasMatriz(IDMatriz) - 1) then
      begin
          //StringGrid1.Cells[C,F] := Copy(CS,1,Pos(#9,CS)-1);
        entorno.modificarCeldaMatriz(IDMatriz,F+1,C+1,Copy(CS,1,Pos(#9,CS)-1));
      end;
      resS := copy(CS,1,pos(#9,CS)-1);
      Delete(CS,1,Pos(#9,CS));
    end;
  //    if (C <= StringGrid1.ColCount -1) and (F <= StringGrid1.RowCount -1) then
    if (C < entorno.cantidadColumnasMatriz(IDMatriz) -1) and (F <= entorno.cantidadFilasMatriz(IDMatriz) - 1) then
    begin
      if copy (CS,1,pos(#13,CS)-1) <>'' then
      begin
          //StringGrid1.Cells[C+1,F] := copy (CS,1,pos(#13,CS)-1);
        entorno.modificarCeldaMatriz(IDMatriz,F+1,C+2,copy (CS,1,pos(#13,CS)-1))
      end;
    end;
    Delete(texto,1,Pos(#13,texto));
    if Copy(texto,1,1)=#10 then
      Delete(texto,1,1);
  end;
  refrescarMatriz;
end;

procedure TfmMatriz.pegarUpdate(Sender: TObject);
begin
  pegar.Enabled := Clipboard.HasFormat(CF_TEXT);
end;

procedure TfmMatriz.refrescarMatriz;
var
  i, j: Integer;
  mat: TMString;
begin
  mat := entorno.getMatriz(IDMatriz);
  StringGrid1.ColCount := high(mat[0])+1;
  StringGrid1.RowCount:= high(mat)+1;
  for i := 0 to high(mat) do
    for j := 0 to high(mat[0]) do
      StringGrid1.Cells[j,i] := mat[i,j];
  EstadoMatriz:='Tamaño: '+intToStr(StringGrid1.RowCount)+' x '+intToStr(StringGrid1.ColCount);
end;

procedure TfmMatriz.rehacerExecute(Sender: TObject);
begin
  entorno.rehacerMatriz(IDMatriz);
  refrescarMatriz;
end;

procedure TfmMatriz.rehacerUpdate(Sender: TObject);
begin
  rehacer.Enabled := (IDMatriz <> '') and (entorno.tieneRehacerMatriz(IDMatriz));
end;

procedure TfmMatriz.SetArchivoMatriz(const Value: string);
begin
  FArchivoMatriz := Value;
end;

procedure TfmMatriz.SetAyuda(const Value: string);
begin
  FAyuda := Value;
  StatusBar1.Panels[0].Text := Value;
end;

procedure TfmMatriz.SetColumnaActual(const Value: Integer);
begin
  FColumnaActual := Value;
  StatusBar1.Panels[2].Text:= 'Columnas: ' + intToStr(Value);
end;

procedure TfmMatriz.SetEstadoMatriz(const Value: string);
begin
  FEstadoMatriz := Value;
  StatusBar1.Panels[3].Text := Value;
end;

procedure TfmMatriz.SetFilaActual(const Value: Integer);
begin
  FFilaActual := Value;
  StatusBar1.Panels[1].Text := 'Fila: ' + intToStr(Value);
end;

procedure TfmMatriz.SetTitulo(const Value: string);
begin
  //FTitulo := Value;
  caption := 'Matriz: ' + Value;
end;

procedure TfmMatriz.StringGrid1DblClick(Sender: TObject);
begin
  StringGrid1.Options := StringGrid1.Options + [goEditing];
end;

procedure TfmMatriz.StringGrid1ExitCell(Sender: TJvStringGrid; AColumn, ARow: 
        Integer; const EditText: String);
begin
  //  ShowMessage(StringGrid1.Cells[AColumn,ARow]+' '+EditText);
  if (StringGrid1.Cells[AColumn,ARow] <> '')  and (EditText <> '') then// (StringGrid1.Cells[ACol,ARow] <> EditText) then
  begin
    entorno.modificarCeldaMatriz(IDMatriz, ARow+1, AColumn+1, EditText);
    refrescarMatriz;
  end;
  StringGrid1.Options := StringGrid1.Options - [goEditing];
end;

procedure TfmMatriz.StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; 
        var CanSelect: Boolean);
begin
  FilaActual := ARow;
  ColumnaActual := ACol;
end;

procedure TfmMatriz.StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
        const Value: String);
begin
  {  if (StringGrid1.Cells[ACol,ARow] <> '')  and (value <> '') then// (StringGrid1.Cells[ACol,ARow] <> value) then
    begin
      entorno.modificarCeldaMatriz(IDMatriz,ARow+1, ACol+1, StringGrid1.Cells[ACol,ARow]);
    end;
    StringGrid1.Options := StringGrid1.Options - [goEditing];}
end;



end.

