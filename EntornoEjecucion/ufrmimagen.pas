unit ufrmimagen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ImgList, ComCtrls, ToolWin, StdCtrls, Buttons,
  GR32_Image, Types,GR32, GR32_RangeBars, GR32_Filters, GR32_Transforms ,
  GR32_Layers, Menus, utipos;

type
  RSeleccion = record
    xi,yi,xf,yf:integer;
  end;
  TfrmImagen = class (TForm)
    btDeshacer: TToolButton;
    btRehacer: TToolButton;
    CBImagen: TControlBar;
    Circular1: TMenuItem;
    Cuadrada1: TMenuItem;
    DDMZoom: TPopupMenu;
    Image1: TImgView32;
    Imagenes: TImageList;
    N1: TMenuItem;
    N111: TMenuItem;
    N121: TMenuItem;
    N211: TMenuItem;
    Otro1: TMenuItem;
    Panel1: TPanel;
    popSelect: TPopupMenu;
    separador1: TToolButton;
    StBarImg: TStatusBar;
    TBNoSelec: TToolButton;
    TBSelecCirc: TToolButton;
    TBSelecRect: TToolButton;
    TBZoom: TToolButton;
    ToolBar1: TToolBar;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    procedure btDeshacerClick(Sender: TObject);
    procedure Circular1Click(Sender: TObject);
    procedure Cuadrada1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: 
            TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: 
            Integer; Layer: TCustomLayer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton; Shift: 
            TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure mnFlattenClick(Sender: TObject);
    procedure N111Click(Sender: TObject);
    procedure N121Click(Sender: TObject);
    procedure N211Click(Sender: TObject);
    procedure Otro1Click(Sender: TObject);
    procedure popSelectPopup(Sender: TObject);
    procedure TBNoSelecClick(Sender: TObject);
    procedure TBSelecCircClick(Sender: TObject);
    procedure TBSelecRectClick(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
  private
    FSelection: TPositionedLayer;
    imagenmdi: string;
    function GetNombre: string;
    procedure SetNombre(nombre: string);
    procedure SetSelection(Value: TPositionedLayer);
  protected
    RBLayer: TRubberbandLayer;
    procedure LayerMouseDown(Sender: TObject; Buttons: TMouseButton; Shift: 
            TShiftState; X, Y: Integer);
    procedure RBResizing(Sender: TObject; const OldLocation: TFloatRect; var 
            NewLocation: TFloatRect; DragState: TDragState; Shift: TShiftState);
  published
    property Nombre: string read GetNombre write SetNombre;
    property Selection: TPositionedLayer read FSelection write SetSelection;
  end;
  
var
  frmImagen: TfrmImagen;
  Seleccion: RSeleccion;
  SeleccionStart: Boolean;
  Tseleccion: byte; // 0 = noSelect 1= cuadrada, 2= Circular
implementation
uses uFmPrincipal, ufrmzoomimg, Clipbrd, Math, GR32_LowLevel, Printers;
{$R *.dfm}

{
********************************** TfrmImagen **********************************
}
procedure TfrmImagen.btDeshacerClick(Sender: TObject);
begin
  entorno.deshacerImagen(imagenmdi);
  image1.Bitmap:=entorno.getImagen(imagenmdi).getValor;
end;

procedure TfrmImagen.Circular1Click(Sender: TObject);
begin
  Tseleccion:=2;
  TBSelecRect.Down:= true;
  TBSelecRect.ImageIndex:=1;
end;

procedure TfrmImagen.Cuadrada1Click(Sender: TObject);
begin
  Tseleccion:=1;
  TBSelecRect.Down:= true;
  TBSelecRect.ImageIndex:=0;
end;

procedure TfrmImagen.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  entorno.quitarImagen(imagenmdi);
  self.Free;
end;

procedure TfrmImagen.FormCreate(Sender: TObject);
begin
  imagenmdi:=imagen;
  SeleccionStart:=False;
end;

procedure TfrmImagen.FormResize(Sender: TObject);
begin
  if self.Width < Image1.Width then
    self.VertScrollBar.Tracking:= true;
end;

function TfrmImagen.GetNombre: string;
begin
  result:= imagenmdi;
end;

procedure TfrmImagen.Image1MouseDown(Sender: TObject; Button: TMouseButton; 
        Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  presionada: Char;
  imaux: TBitmap;
  imaux32: Tbitmap32;
  imagenauxiliar: Timagen;
begin
  if Button = mbLeft then
  begin
    SeleccionStart:=True;
        //  IF presionada <> chr(15) then
        //    self.Refresh;
    seleccion.xi:= X;
    seleccion.yi:= Y;
  end
  else if (Button = mbRight) {and (previsual.Dragging) }then
  begin
      {image1.Bitmap.SaveToFile('qcorno.bmp');
      imaux:= TBitmap.Create;
      imaux32 := TBitmap32.Create;
      imaux.LoadFromFile('qcorno.bmp');
      imaux32.Assign(imaux);
      imagenauxiliar:= TImagen.Create;
      imagenauxiliar.adquirirImagen(imaux32);
      imagenauxiliar.guardar('imagenauxiliar.bmp');
      TImagen(entorno.getImagen(imagenmdi)).setImagen(imagenauxiliar,point(0,0));
      imagenauxiliar.Free;
      //adquirirImagen(imaux32);}
    {    Previsual.EndDrag(true);}
  //    tbitmaplayer(self.Selection).Bitmap
    entorno.pegarImagen(imagenmdi,Point(Self.Selection.Location.TopLeft));
    mnFlattenClick(sender);
    image1.Bitmap.Clear;
    Image1.Bitmap:= entorno.getImagen(imagenmdi).getValor;
  end;
end;

procedure TfrmImagen.Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: 
        Integer; Layer: TCustomLayer);
var
  rectangulo: Trect;
begin
  if SeleccionStart then
    begin
    Image1.Invalidate;
    seleccion.xf:= X;
    seleccion.yf:= Y;
    with seleccion do
    begin
      if xi < xf then
      begin
        rectangulo.Left := xi;
        rectangulo.Right := xf;
      end
      else
      begin
        rectangulo.Left := xf;
        rectangulo.Right := xi;
      end;
      if yi < yf then
      begin
        rectangulo.Top := yi;
        rectangulo.Bottom := yf;
      end
      else
      begin
        rectangulo.Top := yf;
        rectangulo.Bottom := yi;
      end;
    end;
    case Tseleccion of
      1:  with image1.Canvas do
          begin
            Pen.Style := psSolid;
            Pen.Color:= clBlack;
            Pen.Width:=2;
            Polyline([rectangulo.TopLeft,Point(rectangulo.right,rectangulo.Top),
            rectangulo.bottomright, Point(rectangulo.Left,rectangulo.Bottom),rectangulo.TopLeft]);
          end;
      2:  with image1.Canvas do
          begin
            Pen.Style := psSolid;
            Pen.Color:= clBlack;
            Pen.Width:=2;
            arc(rectangulo.left,rectangulo.top,rectangulo.right,rectangulo.bottom,rectangulo.left,rectangulo.top,
            rectangulo.left,rectangulo.top);
          end;
      0:  ;
      else
      end;
  end;
end;

procedure TfrmImagen.Image1MouseUp(Sender: TObject; Button: TMouseButton; 
        Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  rectangulo: Trect;
begin
  if button = mbleft then
  begin
    SeleccionStart:=false;
    seleccion.xf:= X;
    seleccion.yf:= Y;
    with seleccion do
    begin
      if xi < xf then
      begin
        rectangulo.Left := xi;
        rectangulo.Right := xf;
      end
      else
      begin
        rectangulo.Left := xf;
        rectangulo.Right := xi;
      end;
      if yi < yf then
      begin
        rectangulo.Top := yi;
        rectangulo.Bottom := yf;
      end
      else
      begin
        rectangulo.Top := yf;
        rectangulo.Bottom := yi;
      end;
    end;
    case Tseleccion of
      1:  with image1.Canvas do
          begin
            Pen.Style := psDot;
            Pen.Color:= clWhite;
            Pen.Width:=1;
            Brush.Color:=clNone;
            Polyline([rectangulo.TopLeft,Point(rectangulo.right,rectangulo.Top),
            rectangulo.bottomright, Point(rectangulo.Left,rectangulo.Bottom),rectangulo.TopLeft]);
            Timagen(entorno.getImagen(imagenmdi)).setSeleccion(Tseleccion,rectangulo);
          end;
      2:  with image1.Canvas do
          begin
            Pen.Style := psDot;
            Pen.Color:= clWhite;
            Pen.Width:=1;
            Brush.Color:=clNone;
            arc(rectangulo.left,rectangulo.top,rectangulo.right,rectangulo.bottom,rectangulo.left,rectangulo.top,
            rectangulo.left,rectangulo.top);
          end;
      0:  ;
      else
      end;
    end;
end;

procedure TfrmImagen.LayerMouseDown(Sender: TObject; Buttons: TMouseButton; 
        Shift: TShiftState; X, Y: Integer);
begin
  if Sender <> nil then Selection := TPositionedLayer(Sender);
end;

procedure TfrmImagen.mnFlattenClick(Sender: TObject);
var
  B: TBitmap32;
  W, H: Integer;
begin
  { deselect everything }
  Selection := nil;
  W := Image1.Bitmap.Width;
  H := Image1.Bitmap.Height;
  
  { Create a new bitmap to store a flattened image }
  B := TBitmap32.Create;
  try
    B.SetSize(W, H);
    Image1.PaintTo(B, Rect(0, 0, W, H));
  
    { destroy all the layers of the original image... }
    Image1.Layers.Clear;
    RBLayer := nil; // note that RBLayer reference is destroyed here as well.
                    // The rubber band will be recreated during the next
                    // SetSelection call. Alternatively, you can delete
                    // all the layers except the rubber band.
  
    { ...and overwrite it with the flattened one }
    Image1.Bitmap := B;
  finally
    B.Free;
  end;
end;

procedure TfrmImagen.N111Click(Sender: TObject);
begin
  image1.Scale:= 1;
  image1.Height:= image1.Bitmap.Height;
  image1.Width:= image1.Bitmap.Width;
end;

procedure TfrmImagen.N121Click(Sender: TObject);
begin
  image1.Scale:= 1/2;
  image1.Height:= image1.Bitmap.Height div 2;
  image1.Width:= image1.Bitmap.Width div 2;
end;

procedure TfrmImagen.N211Click(Sender: TObject);
begin
  image1.Scale:= 2;
  image1.Height:= image1.Bitmap.Height*2;
  image1.Width:= image1.Bitmap.Width*2;
end;

procedure TfrmImagen.Otro1Click(Sender: TObject);
begin
  frmZoomImg.Top:= mouse.CursorPos.Y;
  frmZoomImg.Left:= mouse.CursorPos.X;
  frmZoomImg.showmodal;
  image1.Scale:= frmzoomimg.VEditZoom.Value / 100;
  image1.Height:= trunc(image1.Bitmap.Height * (frmzoomimg.VEditZoom.Value /100)) ;
  image1.Width:= trunc(image1.Bitmap.Width * (frmzoomimg.VEditZoom.Value /100)) ;
end;

procedure TfrmImagen.popSelectPopup(Sender: TObject);
begin
  TBNoSelec.Down:= False;
end;

procedure TfrmImagen.RBResizing(Sender: TObject; const OldLocation: TFloatRect; 
        var NewLocation: TFloatRect; DragState: TDragState; Shift: TShiftState);
var
  w, h, cx, cy: Single;
  nw, nh: Single;
begin
  if DragState = dsMove then Exit; // we are interested only in scale operations
  if Shift = [] then Exit; // special processing is not required
  
  if ssCtrl in Shift then
  begin
    { make changes symmetrical }
  
    with OldLocation do
    begin
      cx := (Left + Right) / 2;
      cy := (Top + Bottom) / 2;
      w := Right - Left;
      h := Bottom - Top;
    end;
  
    with NewLocation do
    begin
      nw := w / 2;
      nh := h / 2;
      case DragState of
        dsSizeL: nw := cx - Left;
        dsSizeT: nh := cy - Top;
        dsSizeR: nw := Right - cx;
        dsSizeB: nh := Bottom - cy;
        dsSizeTL: begin nw := cx - Left; nh := cy - Top; end;
        dsSizeTR: begin nw := Right - cx; nh := cy - Top; end;
        dsSizeBL: begin nw := cx - Left; nh := Bottom - cy; end;
        dsSizeBR: begin nw := Right - cx; nh := Bottom - cy; end;
      end;
      if nw < 2 then nw := 2;
      if nh < 2 then nh := 2;
  
      Left := cx - nw;
      Right := cx + nw;
      Top := cy - nh;
      Bottom := cy + nh;
    end;
  end;
end;

procedure TfrmImagen.SetNombre(nombre: string);
begin
  imagenmdi:= nombre;
end;

procedure TfrmImagen.SetSelection(Value: TPositionedLayer);
begin
  if Value <> FSelection then
  begin
    if RBLayer <> nil then
    begin
      RBLayer.ChildLayer := nil;
      RBLayer.LayerOptions := LOB_NO_UPDATE;
      Image1.Invalidate;
    end;
  
    FSelection := Value;
  
    if Value <> nil then
    begin
      if RBLayer = nil then
      begin
        RBLayer := TRubberBandLayer.Create(Image1.Layers);
        RBLayer.MinHeight := 1;
        RBLayer.MinWidth := 1;
      end
      else RBLayer.BringToFront;
      RBLayer.ChildLayer := Value;
      RBLayer.LayerOptions := LOB_VISIBLE or LOB_MOUSE_EVENTS or LOB_NO_UPDATE;
      RBLayer.OnResizing := RBResizing;
  
      if Value is TBitmapLayer then
        with TBitmapLayer(Value) do
        begin
  //          pnlBitmapLayer.Visible := True;
  //          LayerOpacity.Position := Bitmap.MasterAlpha;
  //          LayerInterpolate.Checked := Bitmap.StretchFilter = sfLinear;
        end
      else if Value.Tag = 2 then
      begin
          // tag = 2 for magnifiers
  //        pnlMagn.Visible := True;
      end;
    end;
  end;
  
  
end;

procedure TfrmImagen.TBNoSelecClick(Sender: TObject);
begin
  Tseleccion:= 0;
  TBSelecRect.Down:= False;
end;

procedure TfrmImagen.TBSelecCircClick(Sender: TObject);
begin
  btDeshacer.Enabled:= entorno.cortarImagen(imagenmdi);
  image1.Bitmap:=entorno.getImagen(imagenmdi).getValor;
  
end;

procedure TfrmImagen.TBSelecRectClick(Sender: TObject);
begin
  TBSelecRect.Down:=true;
  TBSelecRect.ImageIndex:=0;
end;

procedure TfrmImagen.ToolButton4Click(Sender: TObject);
begin
  entorno.copiarImagen(imagenmdi);
end;

procedure TfrmImagen.ToolButton5Click(Sender: TObject);
var
  bitaux: TBitmap;
  B: TBitmapLayer;
  P: TPoint;
  W, H: Single;
begin
  {  bitaux:= TBitmap.Create;
    bitaux.LoadFromClipboardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
    previsual.Bitmap.Assign(bitaux);
    previsual.Top:= 100;
    previsual.Width:= previsual.Bitmap.Width;
    previsual.Height:= previsual.Bitmap.Height;
    previsual.Visible:=true;}
  //  image1.Layers.
  Tseleccion := 0;
  B := TBitmapLayer.Create(Image1.Layers);
  bitaux:= TBitmap.Create;
  bitaux.LoadFromClipboardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
  with B do
    try
      Bitmap.Assign(bitaux);
      Bitmap.DrawMode := dmBlend;
      with Image1.GetViewportRect do
        P := Image1.ControlToBitmap(Point((Right + Left) div 2, (Top + Bottom) div 2));
  
      W := Bitmap.Width / 2;
      H := Bitmap.Height / 2;
  
        with Image1.Bitmap do
          Location := FloatRect(P.X - W, P.Y - H, P.X + W, P.Y + H);
  
        Scaled := False;
        OnMouseDown := LayerMouseDown;
      except
        Free;
        raise;
      end;
      Selection := B;
end;



end.

