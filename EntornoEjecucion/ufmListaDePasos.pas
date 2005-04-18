unit ufmListaDePasos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvListBox, JvPlaylist, JvLookOut,
  JvOutlookBar, JvExControls, JvComponent, JvTextListBox, JvgListBox,
  Grids, JvExGrids, JvStringGrid, uEntornoEjecucion, ActnList, Menus,
  ComCtrls, ToolWin, ExtCtrls, ImgList, JvDialogs;

type
  TfmListaDePasos = class (TForm)
    abrirListadePasos: TAction;
    ActionList1: TActionList;
    agregarAListaDePasos: TAction;
    ControlBar1: TControlBar;
    duplicarPaso: TAction;
    DuplicarPaso1: TMenuItem;
    EditarDescripcin1: TMenuItem;
    editarDescripcion: TAction;
    eliminarPaso: TAction;
    EliminarPaso1: TMenuItem;
    guardarListaDePasos: TAction;
    ImageList1: TImageList;
    JvOpenDialog1: TJvOpenDialog;
    JvSaveDialog1: TJvSaveDialog;
    JvStringGrid1: TJvStringGrid;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure abrirListadePasosExecute(Sender: TObject);
    procedure agregarAListaDePasosExecute(Sender: TObject);
    procedure duplicarPasoExecute(Sender: TObject);
    procedure duplicarPasoUpdate(Sender: TObject);
    procedure editarDescripcionExecute(Sender: TObject);
    procedure eliminarPasoExecute(Sender: TObject);
    procedure eliminarPasoUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure guardarListaDePasosExecute(Sender: TObject);
    procedure guardarListaDePasosUpdate(Sender: TObject);
    procedure JvStringGrid1DblClick(Sender: TObject);
    procedure JvStringGrid1DragOver(Sender, Source: TObject; X, Y: Integer; 
            State: TDragState; var Accept: Boolean);
    procedure JvStringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: 
            TRect; State: TGridDrawState);
    procedure JvStringGrid1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure JvStringGrid1GetEditText(Sender: TObject; ACol, ARow: Integer; 
            var Value: String);
  private
    entorno: TEntornoEjecucion;
    FArchivoListaPasos: string;
    procedure GuardarPaso(Sender: TObject);
    procedure SetArchivoListaPasos(const Value: string);
  public
    procedure refrescarListaPasos;
    property ArchivoListaPasos: string read FArchivoListaPasos write 
            SetArchivoListaPasos;
  end;
  
var
  fmListaDePasos: TfmListaDePasos;

implementation

uses uShrinkPanel;

{$R *.dfm}
type
  TString = class (TObject)
  private
    Fvalor: string;
  public
    constructor create(unvalor:string); overload;
  published
    property valor: string read Fvalor write Fvalor;
  end;
  
{
******************************* TfmListaDePasos ********************************
}
procedure TfmListaDePasos.abrirListadePasosExecute(Sender: TObject);
begin
  if JvOpenDialog1.Execute then
  begin
    entorno.abrirListaPasos(JvOpenDialog1.FileName);
    ArchivoListaPasos := JvOpenDialog1.FileName;
    refrescarListaPasos;
  end;
end;

procedure TfmListaDePasos.agregarAListaDePasosExecute(Sender: TObject);
begin
  if JvOpenDialog1.Execute then
  begin
    entorno.agregarListaPasos(JvOpenDialog1.FileName);
    ArchivoListaPasos := JvOpenDialog1.FileName;
    refrescarListaPasos;
  end;
end;

procedure TfmListaDePasos.duplicarPasoExecute(Sender: TObject);
begin
  entorno.duplicarPasoPosicion(JvStringGrid1.Selection.Top);
  refrescarListaPasos;
end;

procedure TfmListaDePasos.duplicarPasoUpdate(Sender: TObject);
begin
  duplicarPaso.Enabled := JvStringGrid1.Enabled;
end;

procedure TfmListaDePasos.editarDescripcionExecute(Sender: TObject);
var
  unComentario: string;
begin
  unComentario := entorno.getComentarioPasoPosicion(JvStringGrid1.Selection.Top);
  if InputQuery('Editar Comentario', 'Ingrese el comentario', unComentario) then
  begin
    entorno.setComentarioPasoPosicion(JvStringGrid1.Selection.Top,unComentario);
    refrescarListaPasos;
  end;
end;

procedure TfmListaDePasos.eliminarPasoExecute(Sender: TObject);
begin
  entorno.eliminarPasoPosicion(JvStringGrid1.Selection.Top);
  refrescarListaPasos;
end;

procedure TfmListaDePasos.eliminarPasoUpdate(Sender: TObject);
begin
  eliminarPaso.Enabled := JvStringGrid1.Enabled;
end;

procedure TfmListaDePasos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  self.free;
end;

procedure TfmListaDePasos.FormCreate(Sender: TObject);
begin
  entorno := TEntornoEjecucion.Instance;
  JvStringGrid1.ColWidths[0] := JvStringGrid1.Width - 4;
end;

procedure TfmListaDePasos.FormResize(Sender: TObject);
begin
  JvStringGrid1.DefaultColWidth :=JvStringGrid1.Width - 4;
end;

procedure TfmListaDePasos.guardarListaDePasosExecute(Sender: TObject);
begin
  if JvSaveDialog1.Execute then
  begin
    entorno.guardarListaPasos(JvSaveDialog1.FileName);
    ArchivoListaPasos := JvSaveDialog1.FileName;
  end;
end;

procedure TfmListaDePasos.guardarListaDePasosUpdate(Sender: TObject);
begin
  guardarListaDePasos.Enabled := JvStringGrid1.Enabled;
end;

procedure TfmListaDePasos.GuardarPaso(Sender: TObject);
begin
  entorno.actualizarPaso((Sender as TControl).name, (Sender as TControl).Hint);
end;

procedure TfmListaDePasos.JvStringGrid1DblClick(Sender: TObject);
var
  sk: TShrinkPanel;
  nombreAlgoritmo: string;
  captionAlgoritmo: string;
begin
  nombreAlgoritmo := TString(JvStringGrid1.Rows[JvStringGrid1.Row].Objects[0]).valor;
  captionAlgoritmo := copy(JvStringGrid1.Cells[0,JvStringGrid1.Row], pos('|', JvStringGrid1.Cells[0,JvStringGrid1.Row]) + 1, MaxInt);
  if nombreAlgoritmo <> '' then
  begin
    try
      sk := TShrinkPanel.Create(Self);
      with sk do
      begin
        Hint := nombreAlgoritmo;
        Name := entorno.abrirPaso(Hint);
        formulario := entorno.mostrarFormularioAlgoritmo(Name);
        onGuardarPaso := GuardarPaso;
        Caption := captionAlgoritmo;
        DragKind := dkDock;
        DragMode := dmAutomatic;
        ManualFloat(BoundsRect);
      end;
    except
      Freeandnil(sk);
      raise;
    end;
  end;
end;

procedure TfmListaDePasos.JvStringGrid1DragOver(Sender, Source: TObject; X, Y: 
        Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Sender is TJvStringGrid;
end;

procedure TfmListaDePasos.JvStringGrid1DrawCell(Sender: TObject; ACol, ARow: 
        Integer; Rect: TRect; State: TGridDrawState);
var
  Sentence, CurWord: string;
  SpacePos, CurX, CurY: Integer;
  EndOfSentence: Boolean;
  LineBreak: Boolean;
begin
  with JvStringGrid1 do begin
    { Initialize the font to be the control's font }
    Canvas.Font := Font;
  
    with Canvas do begin
      {If this is a fixed cell, then use the fixed color}
      if gdFixed in State then begin
         Pen.Color   := FixedColor;
         Brush.Color := FixedColor;
      end
      {else use the normal color}
      else
        if (ACol >= Selection.Left) and (ACol <= Selection.Right) and
        (ARow >= Selection.Top) and (ARow <= Selection.Bottom)then
        begin
          Pen.Color   := clHighlight;
          Brush.Color := clHighlight;
          Canvas.Font.Color := clHighlightText;
        end
        else
        begin
          Pen.Color   := Color;
          Brush.Color := Color;
        end;
  
      {Prepaint cell in cell color}
      Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
   end;
  
   { Start the drawing in the upper left corner of the cell }
   CurX := Rect.Left;
   CurY := Rect.Top;
  
   { Here we get the contents of the cell }
   Sentence := Cells[ACol, ARow];
  
   { for each word in the cell }
   EndOfSentence := FALSE;
   while (not EndOfSentence) do begin
      { to get the next word, we search for a space }
      SpacePos := Pos(' ', Sentence);
      LineBreak := ((Pos('|', Sentence) < SpacePos) and (Pos('|', Sentence)>0)) or ((Pos('|', Sentence)>0) and (SpacePos = 0));
      if LineBreak then
        SpacePos := Pos('|', Sentence);
      if SpacePos > 0 then begin
         { get the current word plus the space }
         if LineBreak then
         begin
           CurWord := Copy(Sentence, 0, SpacePos - 1);
           { get the rest of the sentence }
           Sentence := Copy(Sentence, SpacePos +1, Length(Sentence) - SpacePos);
         end
         else
         begin
           CurWord := Copy(Sentence, 0, SpacePos);
           { get the rest of the sentence }
           Sentence := Copy(Sentence, SpacePos + 1, Length(Sentence) - SpacePos);
         end;
      end
      else begin
         { this is the last word in the sentence }
         EndOfSentence := TRUE;
         CurWord := Sentence;
      end;
  
      with Canvas do begin
         { if the text goes outside the boundary of the cell }
         if (TextWidth(CurWord) + CurX) > Rect.Right then begin
            { wrap to the next line }
            CurY := CurY + TextHeight('W');
            CurX := Rect.Left;
         end;
         { write out the word }
         TextOut(CurX, CurY, CurWord);
         { increment the x position of the cursor }
         if LineBreak then
         begin
            { wrap to the next line }
            CurY := CurY + TextHeight('W');
            CurX := Rect.Left;
         end else
           CurX := CurX + TextWidth(CurWord);
      end;
   end;
      if JvStringGrid1.RowHeights[ARow] < CurY - Rect.Top + JvStringGrid1.Canvas.TextHeight('W')+2 then
        JvStringGrid1.RowHeights[ARow]:= CurY - Rect.Top + JvStringGrid1.Canvas.TextHeight('W')+2;
  end;
end;

procedure TfmListaDePasos.JvStringGrid1EndDrag(Sender, Target: TObject; X, Y: 
        Integer);
begin
  //  (sender as TJvStringGrid).Selection.Top
end;

procedure TfmListaDePasos.JvStringGrid1GetEditText(Sender: TObject; ACol, ARow: 
        Integer; var Value: String);
begin
  if (Acol=0) and (Arow=0) then
    value := 'W';
end;

procedure TfmListaDePasos.refrescarListaPasos;
var
  lista: TStringList;
  i: Integer;
begin
  lista := entorno.getDescListaPasos;
  JvStringGrid1.Clear;
  JvStringGrid1.Enabled := lista.Count >=1;
  JvStringGrid1.RowCount := lista.Count;
  for i := 0 to lista.Count-1 do
    JvStringGrid1.Rows[i].AddObject(copy(lista.strings[i], pos('|',lista.strings[i])+1, maxint), TString.Create(copy(lista.strings[i], 0, pos('|',lista.strings[i])-1)));
end;

procedure TfmListaDePasos.SetArchivoListaPasos(const Value: string);
begin
  FArchivoListaPasos := Value;
end;

{ TString }

{
*********************************** TString ************************************
}
constructor TString.create(unvalor:string);
begin
  valor:= unvalor;
end;

end.

