unit uFmPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, JvLabel,
  Menus, ToolWin, ImgList, uShrinkPanel, uEntornoEjecucion,
  ExtDlgs, DelphiTwain, JvExControls, JvComponent, JvXPCore, JvXPButtons,
  JvXPBar, JvNavigationPane, ActnList, JvDialogs, ufmMatriz, StdActns, ufmListaDePasos,
  JvExComCtrls, JvComCtrls, JvListView, DynToolBar, Buttons, JvSpeedButton;

type
  Tfmprincipal = class (TForm)
    AbrirDlg: TJvOpenDialog;
    abrirImagen: TAction;
    AbrirImgen1: TMenuItem;
    AbrirListadePasos1: TMenuItem;
    AbrirListadeReferencias1: TMenuItem;
    abrirMatriz: TAction;
    AbrirMatriz1: TMenuItem;
    AcercaDe1: TMenuItem;
    ActionList1: TActionList;
    adquirirImagen: TAction;
    AgregarCategora1: TMenuItem;
    AgregarCategora2: TMenuItem;
    agregarCategoria: TAction;
    agregarSubcategoria: TAction;
    arbolCategorias: TJvTreeView;
    Archivo1: TMenuItem;
    Ayuda1: TMenuItem;
    Ayuda2: TMenuItem;
    BarradeAlgoritmos1: TMenuItem;
    BarradeHerramientas1: TMenuItem;
    BarradeImgenes1: TMenuItem;
    BarradeMatriz1: TMenuItem;
    Bevel1: TBevel;
    Cascada1: TMenuItem;
    cerrarImagen: TAction;
    CerrarImgen1: TMenuItem;
    CerrarListadePasos1: TMenuItem;
    CerrarListadeReferecias1: TMenuItem;
    CerrarMatriz1: TMenuItem;
    cerrarTodasLasImagenes: TAction;
    Como1: TMenuItem;
    ConfiguracindelEntorno1: TMenuItem;
    CoolBar1: TCoolBar;
    CopiarCeldas2: TMenuItem;
    CopiarSeleccin1: TMenuItem;
    CortarCeldas2: TMenuItem;
    CortarSeleccin1: TMenuItem;
    crearMatriz: TAction;
    DeshacerModificacin1: TMenuItem;
    DeshacerModificacin3: TMenuItem;
    DynToolBar1: TDynToolBar;
    EliminarCategora1: TMenuItem;
    eliminarCategoria: TAction;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GuardarComoImagen1: TMenuItem;
    guardarImagen: TAction;
    guardarImagenComo: TAction;
    GuardarImggen1: TMenuItem;
    GuardarListadePasos1: TMenuItem;
    GuardarListadePasosComo1: TMenuItem;
    GuardarListadeReferenciasComo1: TMenuItem;
    GuardarMatriz1: TMenuItem;
    GuardarMatrizComo1: TMenuItem;
    GusradarListadeReferencias1: TMenuItem;
    ImageList1: TImageList;
    ImagenesCategorias: TImageList;
    imagenesEntorno: TImageList;
    Imgen1: TMenuItem;
    ImportarImagen1: TMenuItem;
    ImportarListadePasos1: TMenuItem;
    ImportarListadeReferencias1: TMenuItem;
    imprimirImagen: TAction;
    ImprimirImagen1: TMenuItem;
    ImprimirMatriz1: TMenuItem;
    JvAngleLabel1: TJvLabel;
    JvOpenDMatriz: TJvOpenDialog;
    listaAlgoritmos: TListView;
    ListadePasos1: TMenuItem;
    MainMenu1: TMainMenu;
    MinimizeAll1: TMenuItem;
    MosaicoHorizontal1: TMenuItem;
    MosaicoVertical1: TMenuItem;
    N1: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    NuevaListadePasos1: TMenuItem;
    NuevaListadeReferencias1: TMenuItem;
    nuevaListaPasos: TAction;
    NuevaMatriz1: TMenuItem;
    OpcionesdeIdioma1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    Panel1: TPanel;
    PegarCeldas2: TMenuItem;
    PegarComoImagenNueva1: TMenuItem;
    PegarSeleccin1: TMenuItem;
    PopupCategorias: TPopupMenu;
    quitarAlgoritmo: TAction;
    QuitarAlgoritmo1: TMenuItem;
    RehacerModificacin1: TMenuItem;
    RehacerModificacin3: TMenuItem;
    renombrarCategoria: TAction;
    RenombrarCategoria1: TMenuItem;
    Salir: TAction;
    Salir1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    StatusBar1: TStatusBar;
    ToolBar1: TToolBar;
    ToolBar3: TToolBar;
    ToolButton1: TToolButton;
    ToolButton12: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    Ventanas1: TMenuItem;
    Ver1: TMenuItem;
    WindowCascade1: TWindowCascade;
    WindowMinimizeAll1: TWindowMinimizeAll;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowTileVertical1: TWindowTileVertical;
    procedure abrirImagenExecute(Sender: TObject);
    procedure abrirMatrizExecute(Sender: TObject);
    procedure ActualizarAlgoritmo(algoritmo: string);
    procedure adquirirImagenExecute(Sender: TObject);
    procedure agregarCategoriaExecute(Sender: TObject);
    procedure agregarCategoriaUpdate(Sender: TObject);
    procedure agregarSubcategoriaExecute(Sender: TObject);
    procedure agregarSubcategoriaUpdate(Sender: TObject);
    procedure arbolCategoriasDblClick(Sender: TObject);
    procedure arbolCategoriasDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure arbolCategoriasDragOver(Sender, Source: TObject; X, Y: Integer; 
            State: TDragState; var Accept: Boolean);
    procedure arbolCategoriasGetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure CerrarVentana(Sender: TObject);
    procedure ConfiguracindelEntorno1Click(Sender: TObject);
    procedure crearMatrizExecute(Sender: TObject);
    procedure DelphiTwain1TwainAcquire(Sender: TObject; const Index: Integer; 
            Image: TBitmap; var Cancel: Boolean);
    procedure DynToolBar2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: 
            Integer);
    procedure eliminarCategoriaExecute(Sender: TObject);
    procedure eliminarCategoriaUpdate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer; State: 
            TDragState; var Accept: Boolean);
    procedure guardarImagenComoExecute(Sender: TObject);
    procedure guardarImagenExecute(Sender: TObject);
    procedure ImportarImagen1Click(Sender: TObject);
    procedure JvAngleLabel1DblClick(Sender: TObject);
    procedure nuevaListaPasosExecute(Sender: TObject);
    procedure Panel1Enter(Sender: TObject);
    procedure Panel1Exit(Sender: TObject);
    procedure quitarAlgoritmoExecute(Sender: TObject);
    procedure quitarAlgoritmoUpdate(Sender: TObject);
    procedure renombrarCategoriaExecute(Sender: TObject);
    procedure renombrarCategoriaUpdate(Sender: TObject);
    procedure SalirExecute(Sender: TObject);
    procedure ToolButton3Click(Sender: TObject);
    procedure ToolButton4Click(Sender: TObject);
    procedure verDATA1Click(Sender: TObject);
    procedure WindowCascade1Execute(Sender: TObject);
    procedure WindowMinimizeAll1Execute(Sender: TObject);
    procedure WindowTileHorizontal1Execute(Sender: TObject);
    procedure WindowTileVertical1Execute(Sender: TObject);
  private
    fmListaDePasos: TFMListaDePasos;
    Ftimer: TTimer;
    listaAlgoritmosAbiertos: TStringList;
    procedure CerrarVentanaPaso(Sender: TObject; var Action: TCloseAction);
    procedure EjecutarAlgoritmo(Sender: TObject);
    procedure GuardarPaso(Sender: TObject);
    procedure mostrarListaPasos;
  end;
  
var
  fmPrincipal: TfmPrincipal;
  entorno : TEntornoEjecucion;
  imagen:string;

implementation
uses StrUtils, ufrmimagen, ufmConfigEntorno, GR32;

{$R *.dfm}

{
********************************* Tfmprincipal *********************************
}
procedure Tfmprincipal.abrirImagenExecute(Sender: TObject);
var
  formulario: TfrmImagen;
begin
  if OpenPictureDialog1.Execute then
  begin
    imagen :=OpenPictureDialog1.FileName;
    //    ListView1.Items.Add(imagen);
    formulario:= TfrmImagen.Create(Self);
    formulario.image1.Bitmap:=Entorno.abrirImagen(imagen);
  //    formulario.Constraints.MaxHeight:= formulario.image1.Bitmap.Height+formulario.CBImagen.Height+35+formulario.StBarImg.Height;
  //    formulario.Constraints.MaxWidth:= formulario.image1.Bitmap.Width+9;
    formulario.Image1.Width := formulario.image1.Bitmap.Width+20;
    formulario.Image1.Height := formulario.image1.Bitmap.Height+20;
    formulario.Height:=formulario.image1.Bitmap.Height+formulario.CBImagen.Height+35+formulario.StBarImg.Height;
    formulario.Width:=formulario.image1.Bitmap.Width+9;
    formulario.Show;
    formulario.Caption:=ExtractFileName(imagen);//' Irá Nombre interno';
    formulario.StBarImg.SimpleText:=ExtractFileName(imagen);
  end;
end;

procedure Tfmprincipal.abrirMatrizExecute(Sender: TObject);
var
  formulario: TfmMatriz;
begin
  if JvOpenDMatriz.Execute then
  begin
    formulario := TfmMatriz.Create(fmprincipal);
      //formulario.ArchivoMatriz := JvOpenDMatriz.FileName;
    formulario.crearAbriendoMatriz(JvOpenDMatriz.FileName)//abrirMatrizExecute(self);
  end;
  //AbrirDlg.InitialDir := ExtractFilePath(Application.ExeName);
  //AbrirDlg.Filter:='Matriz (*.mat)| *.mat';
  //if AbrirDlg.Execute then
  //  entorno.abrirMatriz(AbrirDlg.FileName);
end;

procedure Tfmprincipal.ActualizarAlgoritmo(algoritmo: string);
var
  sk: TShrinkPanel;
  index: Integer;
begin
  index:=listaAlgoritmosAbiertos.IndexOf(algoritmo);
  sk := TShrinkPanel(listaAlgoritmosAbiertos.Objects[index]);
  sk.FinEjecutar;
end;

procedure Tfmprincipal.adquirirImagenExecute(Sender: TObject);
var
  DelphiTwain1: TDelphiTwain;
  SourceIndex: Integer;
  Source: TTwainSource;
begin
  //Make sure that the library and Source Manager
  //are loaded
  DelphiTwain1:=TDelphiTwain.Create(nil);
  DelphiTwain1.LibraryLoaded := TRUE;
  DelphiTwain1.TransferMode:= ttmNative;
  
  DelphiTwain1.OnTwainAcquire := DelphiTwain1TwainAcquire;
  DelphiTwain1.SourceManagerLoaded := TRUE;
  //SelectSource method displays a common Twain dialog
  //to allow the user to select one of the avaliable
  //sources and returns it's index or -1 if either
  //the user pressed Cancel or if there were no sources
  SourceIndex := DelphiTwain1.SelectSource();
  if (SourceIndex <> -1) then
  begin
     //Now that we know the index of the source, we'll
     //get the object for this source
     Source := DelphiTwain1.Source[SourceIndex];
     //Load source and acquire image
     Source.Loaded := TRUE;
     Source.Enabled := TRUE;
  end //if (SourceIndex <> -1)
end;

procedure Tfmprincipal.agregarCategoriaExecute(Sender: TObject);
var
  nodo: TTreeNode;
begin
  nodo := arbolCategorias.Items.Add(arbolCategorias.Selected,'Nueva Categoría');
  nodo.Data := nil;
  //arbolCategorias.Items.Add(arbolCategorias.Selected,'Nueva Categoría')
end;

procedure Tfmprincipal.agregarCategoriaUpdate(Sender: TObject);
begin
  //  agregarCategoria.Enabled := Assigned(arbolCategorias.Selected) and (arbolCategorias.Selected.Data=nil);
  agregarCategoria.Enabled := true;
end;

procedure Tfmprincipal.agregarSubcategoriaExecute(Sender: TObject);
var
  nodo: TTreeNode;
begin
  nodo := arbolCategorias.Items.AddChild(arbolCategorias.Selected,'Nueva Categoría');
  nodo.Data := nil; //pone nil xq es categoria
end;

procedure Tfmprincipal.agregarSubcategoriaUpdate(Sender: TObject);
begin
  agregarSubcategoria.Enabled := Assigned(arbolCategorias.Selected) and (arbolCategorias.Selected.Data = nil);//Assigned(arbolCategorias.Selected.Data);
end;

procedure Tfmprincipal.arbolCategoriasDblClick(Sender: TObject);
var
  sk: TShrinkPanel;
  nombreAlgoritmo: string;
  captionAlgoritmo: string;
begin
  if (Sender is TTreeview) or (Sender is TListView) then
  begin
    nombreAlgoritmo := '';
  
    if (Sender is TListView) then
    begin
      if assigned((Sender as TListView).ItemFocused) and Assigned((Sender as TListView).ItemFocused.Data) then
      begin
        nombreAlgoritmo := string((Sender as TListView).ItemFocused.Data^);
        captionAlgoritmo := TListView(Sender).ItemFocused.Caption;
      end
    end
    else
      if Assigned((Sender as TTreeView).Selected) and Assigned((Sender as TTreeView).Selected.Data) then
      begin
        nombreAlgoritmo := string((Sender as TTreeView).Selected.Data^);
        captionAlgoritmo := TTreeView(Sender).Selected.Text;
      end;
    if nombreAlgoritmo <> '' then
    begin
      try
        sk := TShrinkPanel.Create(Self);
        with sk do
        begin
          Name := entorno.abrirAlgoritmo(nombreAlgoritmo);
          formulario := entorno.mostrarFormularioAlgoritmo(Name);
          Caption := captionAlgoritmo;//entorno.getDescAlgoritmo(Name);//'esp='+captionAlgoritmo+'|eng='+captionAlgoritmo;
          mostrarIdiomas(entorno.getListaIdiomasAlgoritmo(Name));
          onGuardarPaso := GuardarPaso;
          onEjecutar := EjecutarAlgoritmo;
          DragKind := dkDock;
          DragMode := dmAutomatic;
          Loaded;
          ManualFloat(BoundsRect);
          listaAlgoritmosAbiertos.AddObject(Name, sk);
        end;
      except
        sk.Free;
      end;
    end;
  end;
end;

procedure Tfmprincipal.arbolCategoriasDragDrop(Sender, Source: TObject; X, Y: 
        Integer);
var
  nodo: TTreeNode;
  aux: ^string;
begin
  if (Sender is TTreeView) and (Source is TTreeView) then
    if (Source as TTreeView).GetNodeAt(x,y).Data = nil then //es categoria
      (Sender as TTreeView).Selected.MoveTo((Source as TTreeView).GetNodeAt(x,y),naAddChild)
    else //es otro algoritmo, poner como hermano
      (Sender as TTreeView).Selected.MoveTo((Source as TTreeView).GetNodeAt(x,y),naAdd);
  if (Source is TListView) then
  begin
    if (Sender as TTreeView).GetNodeAt(x,y).Data = nil then
      nodo := (sender as TTreeView).Items.AddChild((Sender as TTreeView).GetNodeAt(x,y),(Source as TListView).Selected.Caption)
    else {poner en el padre}
      nodo := (sender as TTreeView).Items.AddChild((Sender as TTreeView).GetNodeAt(x,y).Parent,(Source as TListView).Selected.Caption);
    new (aux);
    aux^ := string((source as TListView).Selected.data^);
    nodo.data := aux
  {    nodo := (sender as TTreeView).Items.AddChild((Sender as TTreeView).GetNodeAt(x,y),(Source as TListView).Selected.Caption);
    new (aux);
    aux^ := string((source as TListView).Selected.data^);
    nodo.data := aux;}
  end;
  Panel1.Refresh;
end;

procedure Tfmprincipal.arbolCategoriasDragOver(Sender, Source: TObject; X, Y: 
        Integer; State: TDragState; var Accept: Boolean);
var
  nodo: TTreeNode;
begin
  nodo := TTreeView(Sender).GetNodeAt(X,Y);
  Accept := false;
  if ((Source is TListView) and (Sender is TTreeView) and (nodo <> nil))
  OR ((Source is TTreeView) and (Sender is TTreeView) and not (Sender as TTreeView).GetNodeAt(x,y).HasAsParent((Source as TTreeView).Selected)) then
    //Accept := nodo.Data = nil; {Estaba este}
    Accept := true;
end;

procedure Tfmprincipal.arbolCategoriasGetImageIndex(Sender: TObject; Node: 
        TTreeNode);
begin
  if Node.Data <> nil then
    node.ImageIndex := 0   //algoritmo
  else
    if Node.Expanded then
      Node.ImageIndex := 1 //categoria abierta
    else
      Node.ImageIndex := 2; //categoria cerrada
  if Node.Selected then
    Node.SelectedIndex := Node.ImageIndex;
end;

procedure Tfmprincipal.CerrarVentana(Sender: TObject);
begin
  if sender is TTimer then
  begin
    if TControl(Sender).Name = 'Timer1' then
      JvAngleLabel1DblClick(Sender);
    TTimer(Sender).Enabled := False;
  end;
  
end;

procedure Tfmprincipal.CerrarVentanaPaso(Sender: TObject; var Action: 
        TCloseAction);
begin
  Action := caFree;
  fmListaDePasos := nil;
end;

procedure Tfmprincipal.ConfiguracindelEntorno1Click(Sender: TObject);
begin
  
  //  frmConfigEntorno.execute;
  if frmConfigEntorno.execute then
  begin
    entorno.getListaAlgoritmos(listaAlgoritmos.Items);
    arbolCategorias.Items.Clear;
    entorno.getArbol(arbolCategorias.Items);
  end;
end;

procedure Tfmprincipal.crearMatrizExecute(Sender: TObject);
var
  formulario: TfmMatriz;
begin
  formulario:= TfmMatriz.Create(fmprincipal);
  if formulario.CrearNuevaMatriz then
    formulario.Titulo := 'Sin Título';
  //  formulario:= TfmMatriz.CrearMatriz(Form1);
  //  formulario.Show;
end;

procedure Tfmprincipal.DelphiTwain1TwainAcquire(Sender: TObject; const Index: 
        Integer; Image: TBitmap; var Cancel: Boolean);
var
  formulario: TfrmImagen;
  imagen32: Tbitmap32;
begin
  formulario:= TfrmImagen.Create(Self);
  formulario.image1.Bitmap.Assign(Image);
  imagen32:= TBitmap32.Create;
  imagen32.Assign(image);
  formulario.Nombre:= entorno.adquirirImagen(imagen32);
  formulario.Height:=formulario.image1.Bitmap.Height+formulario.CBImagen.Height+35+formulario.StBarImg.Height;
  formulario.Width:=formulario.image1.Bitmap.Width+9;
  formulario.Constraints.MaxHeight:= formulario.image1.Bitmap.Height+formulario.CBImagen.Height+35+formulario.StBarImg.Height;
  formulario.Constraints.MaxWidth:= formulario.image1.Bitmap.Width+9;
  formulario.Show;
  formulario.Caption:=' Irá Nombre interno';
  formulario.StBarImg.SimpleText:=ExtractFileName(imagen);
  Cancel := TRUE;
end;

procedure Tfmprincipal.DynToolBar2MouseMove(Sender: TObject; Shift: TShiftState;
        X, Y: Integer);
begin
  StatusBar1.Panels.Items[0].Text := ControlAtPos(Point(x,y),true, true).ClassName;
end;

procedure Tfmprincipal.EjecutarAlgoritmo(Sender: TObject);
begin
  if Sender is TControl then
    entorno.ejecutarAlgoritmo((Sender as TControl).name);
end;

procedure Tfmprincipal.eliminarCategoriaExecute(Sender: TObject);
begin
  arbolCategorias.Items.Delete(arbolCategorias.Selected);
end;

procedure Tfmprincipal.eliminarCategoriaUpdate(Sender: TObject);
begin
  eliminarCategoria.Enabled := Assigned(arbolCategorias.Selected) and (arbolCategorias.Selected.Data=nil);//Assigned(arbolCategorias.Selected.Data);
end;

procedure Tfmprincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SalirExecute(Sender);
end;

procedure Tfmprincipal.FormCreate(Sender: TObject);
begin
  entorno:=TEntornoEjecucion.Instance;
  entorno.getListaAlgoritmos(listaAlgoritmos.Items);
  entorno.getArbol(arbolCategorias.Items);
  entorno.onRefresh := ActualizarAlgoritmo;
  listaAlgoritmosAbiertos := TStringList.Create;
end;

procedure Tfmprincipal.FormDragOver(Sender, Source: TObject; X, Y: Integer; 
        State: TDragState; var Accept: Boolean);
var
  nodo: TTreeNode;
begin
  nodo := TTreeView(Sender).GetNodeAt(X,Y);
  Accept := (Sender is TTreeView) and (Source is TTreeView) and Assigned(nodo) and not Assigned(nodo.Data);
end;

procedure Tfmprincipal.guardarImagenComoExecute(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
    entorno.guardarImagen(imagen, SavePictureDialog1.FileName);
end;

procedure Tfmprincipal.guardarImagenExecute(Sender: TObject);
begin
  entorno.guardarImagen(imagen, imagen);
end;

procedure Tfmprincipal.GuardarPaso(Sender: TObject);
var
  unComentario: string;
begin
  if InputQuery('Almacenar Paso - Ingresar Comentario', 'Ingrese el comentario para el paso a almacenar', unComentario) then
  begin
    entorno.almacenarPaso((Sender as TControl).name, unComentario);
    mostrarListaPasos;
    fmListaDePasos.refrescarListaPasos;
  end;
end;

procedure Tfmprincipal.ImportarImagen1Click(Sender: TObject);
var
  DelphiTwain1: TDelphiTwain;
  SourceIndex: Integer;
  Source: TTwainSource;
begin
  //Make sure that the library and Source Manager
  //are loaded
  DelphiTwain1:=TDelphiTwain.Create(nil);
  DelphiTwain1.LibraryLoaded := TRUE;
  DelphiTwain1.TransferMode:= ttmNative;
  
  DelphiTwain1.OnTwainAcquire := fmprincipal.DelphiTwain1TwainAcquire;
  DelphiTwain1.SourceManagerLoaded := TRUE;
  //SelectSource method displays a common Twain dialog
  //to allow the user to select one of the avaliable
  //sources and returns it's index or -1 if either
  //the user pressed Cancel or if there were no sources
  SourceIndex := DelphiTwain1.SelectSource();
  if (SourceIndex <> -1) then
  begin
     //Now that we know the index of the source, we'll
     //get the object for this source
     Source := DelphiTwain1.Source[SourceIndex];
     //Load source and acquire image
     Source.Loaded := TRUE;
     Source.Enabled := TRUE;
  end //if (SourceIndex <> -1)
end;

procedure Tfmprincipal.JvAngleLabel1DblClick(Sender: TObject);
begin
  Panel1.AutoSize := not Panel1.AutoSize;
  ScrollBox1.Visible := not ScrollBox1.Visible;
  Panel1.Width := 160;
  Splitter2.Visible := not Splitter2.Visible;
end;

procedure Tfmprincipal.mostrarListaPasos;
begin
  if not Assigned (fmListaDePasos) then
  begin
    fmListaDePasos := TFmListaDePasos.Create(self);
    fmListaDePasos.OnClose := CerrarVentanaPaso;
  end;
  fmListaDePasos.Show;
end;

procedure Tfmprincipal.nuevaListaPasosExecute(Sender: TObject);
begin
  entorno.nuevaListaPasos;
  mostrarListaPasos;
end;

procedure Tfmprincipal.Panel1Enter(Sender: TObject);
var
  aux: TComponent;
begin
  aux:=TControl(Sender).FindComponent('Timer');
  if assigned(aux) then
    TTimer(aux).Enabled := False;
end;

procedure Tfmprincipal.Panel1Exit(Sender: TObject);
begin
  FTimer:=TTimer(TControl(Sender).FindComponent('Timer'));
  if not Assigned(FTimer) then
    FTimer:=TTimer.Create(self);
  With Ftimer do
  begin
    Interval := 100;
    OnTimer := CerrarVentana;
    Enabled := true;
  end;
end;

procedure Tfmprincipal.quitarAlgoritmoExecute(Sender: TObject);
begin
  arbolCategorias.Items.Delete(arbolCategorias.Selected);
end;

procedure Tfmprincipal.quitarAlgoritmoUpdate(Sender: TObject);
begin
  quitarAlgoritmo.Enabled := Assigned(arbolCategorias.Selected) and Assigned(arbolCategorias.Selected.Data);
end;

procedure Tfmprincipal.renombrarCategoriaExecute(Sender: TObject);
begin
  //if (Sender is TTreeView) then
  arbolCategorias.Selected.EditText;
end;

procedure Tfmprincipal.renombrarCategoriaUpdate(Sender: TObject);
begin
  //  renombrarCategoria.Enabled := Assigned(arbolCategorias.Selected) and Assigned(arbolCategorias.Selected.Data);
  renombrarCategoria.Enabled := Assigned(arbolCategorias.Selected) and (arbolCategorias.Selected.Data = nil);
end;

procedure Tfmprincipal.SalirExecute(Sender: TObject);
begin
  //actualizar la lista de categorias
  try
    entorno.actualizarListaCategorias(arbolCategorias.Items);
  except
    Showmessage('No se ha podido almacenar correctamente el arbol de categorías');
  end;
  //liberar entorno
  try
    entorno.Free;
  except
    Showmessage('No se ha podido cerrar correctamente el entorno');
  end;
end;

procedure Tfmprincipal.ToolButton3Click(Sender: TObject);
begin
  entorno.guardarImagen(imagen, imagen);
end;

procedure Tfmprincipal.ToolButton4Click(Sender: TObject);
begin
  if SavePictureDialog1.Execute then
  entorno.guardarImagen(imagen, SavePictureDialog1.FileName);
end;

procedure Tfmprincipal.verDATA1Click(Sender: TObject);
begin
  Showmessage(strPas(arbolCategorias.Selected.data))
end;

procedure Tfmprincipal.WindowCascade1Execute(Sender: TObject);
begin
  Cascade;
end;

procedure Tfmprincipal.WindowMinimizeAll1Execute(Sender: TObject);
var
  min: TWindowMinimizeAll;
begin
  min := TWindowMinimizeAll.Create(self);
  min.Execute;
end;

procedure Tfmprincipal.WindowTileHorizontal1Execute(Sender: TObject);
begin
  TileMode := tbHorizontal;
  Tile;
end;

procedure Tfmprincipal.WindowTileVertical1Execute(Sender: TObject);
begin
  TileMode := tbVertical;
  Tile;
end;

end.




