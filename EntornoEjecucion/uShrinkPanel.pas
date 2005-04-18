unit uShrinkPanel;

interface
uses
  Windows, Messages, Classes, Graphics, Controls, Forms,  ExtCtrls,
  JvComponent, JvButton, JvMenus, Buttons, JvSpeedButton, JvBitBtn,
  ComCtrls, JvExControls;

const
  WM_DESTRUYEME = WM_USER + $0001;

type

  TDockForm = class (TCustomDockForm)
  protected
    procedure DoAddDockClient(Client: TControl; const ARect: TRect); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNotifyCambioIdioma = procedure(Sender: TObject; unIdioma: string) of object;

  TShrinkPanel = class (TPanel)
  private
    FCaption:TStrings;
    btnCerrar: TSpeedButton;
    btnEjecutar: TjvBitBtn;
    btnExpandir: TSpeedButton;
    btnGuardar: TjvBitBtn;
    btnIdiomas: TjvBitBtn;
    FBottomPanel: TPanel;
    FonEjecutar: TNotifyEvent;
    FonGuardar: TNotifyEvent;
    FPrevPanel: Integer;
    FTitlePanel: TPanel;
    panelDisenio: TPanel;
    TabControl: TTabControl;
    function GetCaption: string;
    procedure SetCaption(const Value: string);
    procedure Setformulario(const Value: wideString);
    procedure SetonEjecutar(const Value: TNotifyEvent);
    procedure setOnGuardar(const Value: TNotifyEvent);
    procedure StartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure WMDestruyeme(var Msg: TMessage); message WM_DESTRUYEME;
  protected
    procedure Cerrar(Sender: TObject);
    procedure Ejecutar(Sender: TObject);
    procedure Expandir(Sender: TObject);
    procedure GuardarPaso(Sender: TObject);
    procedure idiomSelec(Sender: TObject);
    procedure cambioDeIdioma(Sender: TObject);
  public
    constructor Create(AComponent: TComponent); override;
    destructor Destroy; override;
    procedure FinEjecutar;
    procedure Loaded; override;
    procedure mostrarIdiomas(unaListaIdiomas: TStringlist);
  published
    property Caption: string read GetCaption write SetCaption;
    property formulario: wideString write Setformulario;
    property onEjecutar: TNotifyEvent read FonEjecutar write SetonEjecutar;
    property onGuardarPaso: TNotifyEvent read FonGuardar write setOnGuardar;
  end;

implementation

{$R ..\recursos\shrinkPanel\shrinkPanel.res}

uses TypInfo, SysUtils, Types, udmEntorno, Menus, uComponentesARPI;

{ TShrinkPanel }

{
********************************* TShrinkPanel *********************************
}
constructor TShrinkPanel.Create(AComponent: TComponent);
begin
  inherited;

  Parent:= TWinControl(AComponent);
  Width:= 300;
  Height:= 300;

  FTitlePanel:= TPanel.Create(self);
  FTitlePanel.Parent := Self;
  FTitlePanel.Name := 'TitlePanel';
  FTitlePanel.Caption := '';
  FTitlePanel.Height := 18;
  FTitlePanel.Align := alTop;
  FTitlePanel.BevelInner := bvRaised;
  FTitlePanel.BevelOuter := bvLowered;
  FTitlePanel.DragKind := dkDock;
  FTitlePanel.DragMode := dmAutomatic;
  FTitlePanel.FloatingDockSiteClass := TDockForm;
  FTitlePanel.OnStartDock := StartDock;

  btnExpandir:= TSpeedButton.Create(FTitlePanel);
  btnExpandir.Parent := FTitlePanel;
  btnExpandir.Name := 'btnExpandir';
  btnExpandir.Anchors := [akTop, akRight];
  btnExpandir.Width := 18;
  btnExpandir.Height := 18;
  btnExpandir.Left := FTitlePanel.Width - btnExpandir.Width * 2;
  btnExpandir.Top := 0;
  btnExpandir.Flat := True;
  btnExpandir.Spacing := 0;
  btnExpandir.Glyph.LoadFromResourceName(HInstance, 'UP');
  btnExpandir.OnClick := Expandir;
  
  btnCerrar:= TSpeedButton.Create(FTitlePanel);
  btnCerrar.Parent := FTitlePanel;
  btnCerrar.Name := 'btnCerrar';
  btnCerrar.Anchors := [akTop, akRight];
  btnCerrar.Width := 18;
  btnCerrar.Height := 18;
  btnCerrar.Left := FTitlePanel.Width - btnCerrar.Width;
  btnCerrar.Top := 0;
  btnCerrar.Flat := True;
  btnCerrar.Spacing := 0;
  btnCerrar.Glyph.LoadFromResourceName(HInstance, 'CERRAR');
  btnCerrar.OnClick := Cerrar;
  
  FBottomPanel:= TPanel.Create(self);
  FBottomPanel.Parent := Self;
  FBottomPanel.Name := 'BottomPanel';
  FBottomPanel.Caption := '';
  FBottomPanel.Height := 24;
  FBottomPanel.BevelOuter := bvNone;
  FBottomPanel.Align := alBottom;
  
  //  btnGuardar:= TSpeedButton.Create(FBottomPanel);
  btnGuardar:= TjvBitBtn.Create(FBottomPanel);
  btnGuardar.Parent := FBottomPanel;
  btnGuardar.Name := 'btnGuardar';
  btnGuardar.Left := 0;
  btnGuardar.Top := 0;
  btnGuardar.Width := 65;
  btnGuardar.Height := 22;
  btnGuardar.Caption := 'Guardar';
  //  btnGuardar.Flat := True;
    //  btnGuardar.Glyph.LoadFromResourceName();
  btnGuardar.OnClick := GuardarPaso;
  btnGuardar.Enabled := False;
  
  //  btnEjecutar:= TSpeedButton.Create(FBottomPanel);
  btnEjecutar:= TjvBitBtn.Create(FBottomPanel);
  btnEjecutar.Parent := FBottomPanel;
  btnEjecutar.Name := 'btnEjecutar';
  btnEjecutar.Caption := 'Ejecutar';
  btnEjecutar.Left := btnGuardar.Width + 1;
  btnEjecutar.Top := 0;
  btnEjecutar.Width := 65;
  btnEjecutar.Height := 22;
  //  btnEjecutar.Flat := True;
    //  btnExpandir.Glyph.LoadFromResourceName();
  btnEjecutar.OnClick := Ejecutar;
  btnEjecutar.Enabled := False;
  
  //  btnIdiomas:= TSpeedButton.Create(FBottomPanel);
  btnIdiomas:= TjvBitBtn.Create(FBottomPanel);
  btnIdiomas.Parent := FBottomPanel;
  btnIdiomas.Name := 'btnIdiomas';
  btnIdiomas.Caption := '';
  btnIdiomas.Anchors := [akTop, akRight];
  btnIdiomas.Top := 0;
  btnIdiomas.Width := 33;
  btnIdiomas.Left := FBottomPanel.Width - btnIdiomas.Width;
    //  btnIdiomas.Glyph.LoadFromResourceName();
  

  TabControl:= TTabControl.Create(Self);
  TabControl.Parent := Self;
  TabControl.Name := 'TabControl';
  TabControl.Left := 0;
  TabControl.Top := FTitlePanel.Height + 2;
  TabControl.Align := alClient;
  TabControl.Style := tsFlatButtons;
  TabControl.TabOrder := 1;
  TabControl.Tabs.CommaText := 'Básico, Avanzado';
  
  panelDisenio:= TPanel.Create(TabControl);
  panelDisenio.Parent := TabControl;
  panelDisenio.Name := 'panelDisenio';
  panelDisenio.Caption := '';
  panelDisenio.BorderStyle := bsNone;
  panelDisenio.Top := 0;
  panelDisenio.Left := 0;
  panelDisenio.BevelInner := bvNone;
  panelDisenio.BevelOuter := bvNone;

  FloatingDockSiteClass := TDockForm;
end;

destructor TShrinkPanel.Destroy;
begin
  FreeAndNil(btnExpandir);
  FreeAndNil(btnCerrar);
  FreeAndNil(btnIdiomas);
  FreeAndNil(btnGuardar);
  FreeAndNil(btnEjecutar);
  FreeAndNil(FTitlePanel);
  FreeAndNil(FBottomPanel);
  FreeAndNil(TabControl);
  inherited Destroy;
end;

procedure TShrinkPanel.Cerrar(Sender: TObject);
var
  i: Integer;
  ShrinkPanel: TShrinkPanel;
begin
  if not Floating then
    for i := 0 to Parent.ControlCount - 1 do
      if (Parent.Controls[i]<>self) and (Parent.Controls[i] is TShrinkPanel) and TShrinkPanel(Parent.Controls[i]).Visible then
      begin
        ShrinkPanel := TShrinkPanel(Parent.Controls[i]);
        if (ShrinkPanel.Left = Left) and (ShrinkPanel.Top >= Top)then
          ShrinkPanel.Top := ShrinkPanel.Top - Height;
      end;
  PostMessage(Handle, WM_DESTRUYEME, 0, 0);
end;

procedure TShrinkPanel.Ejecutar(Sender: TObject);
begin
  btnEjecutar.Enabled := false;
  if Assigned(FonEjecutar) then
    FonEjecutar(self);
end;

procedure TShrinkPanel.Expandir(Sender: TObject);
var
  i: Integer;
  ShrinkPanel: TShrinkPanel;
  LVert, LOldHeight: Integer;
begin
  if not Floating then
  begin
    LOldHeight := Height;
    if Height = FTitlePanel.Height+2 then
    begin
    //Expand
      LVert := Height - FPrevPanel;
      Height := FPrevPanel;
      TabControl.Visible := True;
      FBottomPanel.Visible := True;
      btnExpandir.Glyph.Handle := LoadBitmap(HInstance, 'UP');
    end
    else
    begin
    //Schrink
      FPrevPanel := Height;
      LVert := Height - FTitlePanel.Height - 2 ;
      TabControl.Visible := False;
      FBottomPanel.Visible := False;
      Height := FTitlePanel.Height+2;
      btnExpandir.Glyph.Handle := LoadBitmap(HInstance, 'DOWN');
    end;
    //Move down all DynPanels that have the same Left and Width
    for i := 0 to Parent.ControlCount - 1 do begin
      if Parent.Controls[i] is TShrinkPanel then begin
        ShrinkPanel := TShrinkPanel(Parent.Controls[i]);
        if ShrinkPanel <> Self then begin
          if (ShrinkPanel.Top >= Top + LOldHeight) and(ShrinkPanel.Left = Left) then begin
            ShrinkPanel.Top := ShrinkPanel.Top - LVert ;
          end;
        end;
      end;
    end;
  end;
  Invalidate;
end;

procedure TShrinkPanel.FinEjecutar;
var
  i: Integer;
begin
  for i:= 0 to panelDisenio.ComponentCount -1 do
    if (panelDisenio.Components[i] is TControl) then
      TControl(panelDisenio.Components[i]).Repaint;
  btnEjecutar.Enabled := True;
end;

function TShrinkPanel.GetCaption: string;
begin
  result := FTitlePanel.Caption;
end;

procedure TShrinkPanel.GuardarPaso(Sender: TObject);
begin
  if Assigned(FonGuardar) then
    FonGuardar(self);
end;

procedure TShrinkPanel.idiomSelec(Sender: TObject);
begin
  //  btnIdiomas.Glyph := TMenuItem(Sender).Bitmap;
end;

procedure TShrinkPanel.mostrarIdiomas(unaListaIdiomas: TStringlist);
var
  list : TPopupMenu;
  item : TMenuItem;
  i, j:integer;
begin
  list := TPopupMenu.Create(nil);
  list.Images := dmEntorno.ilIdiomasChicas;
  for i := 0 to unaListaIdiomas.Count -1 do
  begin
    item := TMenuItem.Create(list.Items);
    item.OnClick := cambioDeIdioma;
    item.Caption := getStrIdioma(unaListaIdiomas.Strings[i]);
    item.Hint := unaListaIdiomas.Strings[i];
    item.ImageIndex := buscarIdxIdioma(unaListaIdiomas.Strings[i]);
    list.Items.Add(item);
    if i = 0 then
      cambioDeIdioma(item); //Cambio el idioma al idioma por defecto
  end;
  btnIdiomas.DropDownMenu :=list;
end;

procedure TShrinkPanel.SetCaption(const Value: string);
begin
{  if not Assigned(FCaption) then
  begin
    FCaption := TStringList.Create;
    FCaption.Clear;
  end;
  FCaption.Delimiter := '|';
  FCaption.DelimitedText := Value;}
  FTitlePanel.Caption := Value;
end;

procedure TShrinkPanel.Setformulario(const Value: wideString);
  
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
  
begin
  while panelDisenio.ComponentCount > 0 do
    panelDisenio.Components[0].Free;
  StringToComponent(Value, panelDisenio);
  SetBounds(Left, Top, Width - TabControl.Width + panelDisenio.Width, Height - TabControl.Height + panelDisenio.Height);
end;

procedure TShrinkPanel.SetonEjecutar(const Value: TNotifyEvent);
begin
  FonEjecutar := Value;
  btnEjecutar.Enabled := Assigned(Value);
end;

procedure TShrinkPanel.setOnGuardar(const Value: TNotifyEvent);
begin
  FonGuardar := Value;
  btnGuardar.Enabled := Assigned(Value);
end;

procedure TShrinkPanel.StartDock(Sender: TObject; var DragObject: 
        TDragDockObject);
var
  aux: TRect;
begin
  DragObject:= TDragDockObject.Create(Self);
  if not Floating then
  begin
    aux.TopLeft := ClientToScreen(parent.BoundsRect.TopLeft);
    aux.Top := aux.Top - 20;
    aux.Left := aux.Left - 25;
    aux.Right := aux.Left + Width;
    aux.Bottom := aux.Top + Height;
    ManualFloat(aux);
  end;
  //    DoRemoveDockClient(self);
  //  startDock(sender, dragobject);
  //  Self.Dock(nil, BoundsRect);
end;

procedure TShrinkPanel.WMDestruyeme(var Msg: TMessage);
begin
  Destroy;
end;

{ TDockForm }

{
********************************** TDockForm ***********************************
}
constructor TDockForm.Create(AOwner: TComponent);
begin
  inherited;
  BorderStyle := bsToolWindow;
  BorderIcons := [];
end;

procedure TDockForm.DoAddDockClient(Client: TControl; const ARect: TRect);
begin
  inherited DoAddDockClient(Client, ARect);
  Caption := '';
end;

procedure TShrinkPanel.Loaded;
begin
  inherited Loaded;
  TabControl.TabStop := false; {TODO: Controlar que se puede hacer}
end;

procedure TShrinkPanel.cambioDeIdioma(Sender: TObject);
var
  i:integer;
begin
{  if Assigned(FCaption) then
    FTitlePanel.Caption := FCaption.Values[(Sender as TMenuItem).Hint];}

  btnIdiomas.Glyph:= nil;
  dmEntorno.ilIdiomasChicas.GetBitmap((Sender as TMenuItem).ImageIndex, btnIdiomas.Glyph);

  for i := 0 to TabControl.Components[0].ComponentCount - 1 do
    if supports(TabControl.Components[0].Components[i], IARPIControl) then
      (TabControl.Components[0].Components[i] as IARPIControl).setIdioma((Sender as TMenuItem).Hint);
end;

end.
