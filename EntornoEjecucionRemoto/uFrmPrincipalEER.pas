unit uFrmPrincipalEER;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvTrayIcon, StdCtrls, JvExStdCtrls, JvWinampLabel,
  Menus, JvExControls, JvLED, ExtCtrls,JclSysInfo,JvExExtCtrls, JvPanel,
  ImgList, JvRichEdit, ARPIFTPServer,IdComponent, IdTCPServer,IdFTPList,
  IdBaseComponent, JclFileUtils,IdFTPServer, UEntornoEjecucion, IdUserAccounts;

type
  TFrmPrincipalEER = class (TForm)
    Button1: TButton;
    Desactivar1: TMenuItem;
    IdFTPServer1: TIdFTPServer;
    IdUserManager1: TIdUserManager;
    ImageList1: TImageList;
    imcerrar: TImage;
    imicono: TImage;
    immin: TImage;
    JvLED1: TJvLED;
    JvPanel1: TJvPanel;
    JvPanel2: TJvPanel;
    JvRichEdit1: TJvRichEdit;
    JvTrayIcon1: TJvTrayIcon;
    Label1: TLabel;
    N1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Restaurar1: TMenuItem;
    Salir1: TMenuItem;
    Timer1: TTimer;
    procedure ARPIFTPServer1ListDirectory(ASender: TARPIFTPServerThread; const 
            APath: String; ADirectoryListing: TIdFTPListItems);
    procedure Button1Click(Sender: TObject);
    procedure Desactivar1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdFTPServer1Execute(AThread: TIdPeerThread);
    procedure imcerrarClick(Sender: TObject);
    procedure imminClick(Sender: TObject);
    procedure Restaurar1Click(Sender: TObject);
    procedure Salir1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  end;
  
procedure Executeftp (AThread: TIdPeerThread);

var
  FrmPrincipalEER: TFrmPrincipalEER;
  paso:byte;
  receptor:TARPIFTPServer;
  entorno: TEntornoEjecucion;
implementation

uses VarUtils;

{$R *.dfm}

{
******************************* TFrmPrincipalEER *******************************
}
procedure TFrmPrincipalEER.ARPIFTPServer1ListDirectory(ASender: 
        TARPIFTPServerThread; const APath: String; ADirectoryListing: 
        TIdFTPListItems);
var
  directorio: TStringList;
  fk: TIdFTPListItem;
  sr: TSearchRec;
begin
  directorio:= TStringList.Create;
  ADirectoryListing.DirectoryName:='C:\';
  //  fk:=ADirectoryListing.Add;
  //  fk.DisplayName:='caca';
  //  fk.FileName:='caca';
  //  ADirectoryListing.Items.
  if FindFirst(apath+'*.*',faAnyFile,sr) = 0 then
    repeat
      fk:=ADirectoryListing.Add;
      fk.DisplayName:=sr.Name;
      fk.FileName:=sr.Name;
      fk.Size:=sr.Size;
    until FindNext(sr) <> 0;
  //    ADirectoryListing.LoadList(directorio);
  //  APath:= 'C:\';
  
end;

procedure TFrmPrincipalEER.Button1Click(Sender: TObject);
begin
  if entorno.getEstado = 1 then
    entorno.setestado(0)
  else
    entorno.setestado(1);
end;

procedure TFrmPrincipalEER.Desactivar1Click(Sender: TObject);
begin
  if Desactivar1.Caption = 'R&eactivar' then
  begin
    JvTrayIcon1.IconIndex:= 0 ;
    JvLED1.Status:= True;
    Desactivar1.Caption:= 'Desactivar';
  end
  else
  begin
    JvTrayIcon1.IconIndex:= 1 ;
    JvLED1.Status:= false;
    Desactivar1.Caption:= 'Reactivar';
  end;
end;

procedure TFrmPrincipalEER.FormCreate(Sender: TObject);
var
  lineas: TStringList;
begin
  entorno:=TEntornoEjecucion.Instance;
  receptor:=TARPIFTPServer.Create(self);
  with receptor do
  begin
    Active:= true;
    AllowAnonymousLogin:=true;
    AnonymousPassStrictCheck:=false;
    OnListDirectory:=ARPIFTPServer1ListDirectory;
    CommandHandlersEnabled:=true;
    DefaultPort:= 21;
    DefaultDataPort:=20;
    MaxConnections := 0;
    SystemType:= 'WIN32';
    Greeting.NumericCode:=220;
    lineas:=TStringList.Create;
    lineas.Add('hola');
    EmulateSystem:= ARPIftpserver.ftpsDOS;
    Greeting.Text:=lineas;
    UserAccounts:=IdUserManager1;
  end;
end;

procedure TFrmPrincipalEER.FormShow(Sender: TObject);
begin
  // Es prototipo vacio
  Label1.Caption:='';
  JvLED1.ColorOn:=clYellow;
  JvLED1.Active:= true;
  timer1.Enabled:= true;
  JvTrayIcon1.IconIndex:= 1;
  with JvRichEdit1.Font do
  begin
    Name:= 'Arial';
    Height:= 14;
    Style:= [fsBold];
    Color:= clBlue;
  end;
  JvRichEdit1.Lines.Add('Inicializando el Satelite...');
  paso:=1;
end;

procedure TFrmPrincipalEER.IdFTPServer1Execute(AThread: TIdPeerThread);
var
  i: Integer;
begin
  with AThread.Connection do begin
    WriteLn('Hello. DB Server ready.');
    i := StrToIntDef(ReadLn, 0);
    // Sleep is substituted for a long DB or other call
    Sleep(5000);
    WriteLn(IntToStr(i * 7));
    Disconnect;
  end;
  
end;

procedure TFrmPrincipalEER.imcerrarClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmPrincipalEER.imminClick(Sender: TObject);
begin
  JvTrayIcon1.HideApplication;
end;

procedure TFrmPrincipalEER.Restaurar1Click(Sender: TObject);
begin
  JvTrayIcon1.ShowApplication;
end;

procedure TFrmPrincipalEER.Salir1Click(Sender: TObject);
begin
  application.Terminate;
end;

procedure TFrmPrincipalEER.Timer1Timer(Sender: TObject);
var
  fuente: TFont;
begin
  fuente:=TFont.Create;
  //Es prototipo vacio
  if paso = 1 then
  begin
    timer1.Interval:=2500;
    JvTrayIcon1.IconIndex:= 0;
    inc(paso);
    JvRichEdit1.Lines.Delete(JvRichEdit1.Lines.Count-1);
    with fuente do
    begin
      Name := 'Arial';
      Height:= 14;
      Style:= [fsBold];
      Color:= clGrayText;
    end;
    JvRichEdit1.AddFormatText('SATELITE INICIALIZADO'+chr(13),fuente);
    with fuente do
    begin
      Name := 'Arial';
      Height:= 14;
      Style:= [fsBold];
      Color:= clBlue;
    end;
    JvRichEdit1.AddFormatText('Obteniendo IP...'+chr(13),fuente);
  end
  else if paso = 2 then
       begin
          inc(paso);
          Label1.Caption:='Satelite en IP: '+GetIPAddress(GetLocalComputerName);
          JvRichEdit1.Lines.Delete(JvRichEdit1.Lines.Count-1);
          with fuente do
          begin
            Name := 'Arial';
            Height:= 14;
            Style:= [fsBold];
            Color:= clGrayText;
          end;
          JvRichEdit1.AddFormatText('IP Obtenida'+chr(13),fuente);
          with fuente do
          begin
            Name := 'Arial';
            Height:= 14;
            Style:= [fsBold];
            Color:= clBlue;
          end;
          JvRichEdit1.AddFormatText('Iniciando el Entorno...'+chr(13),fuente);
       end
       else
       if paso = 3 then
       begin
          JvRichEdit1.Lines.Delete(JvRichEdit1.Lines.Count-1);
          with fuente do
          begin
            Name := 'Arial';
            Height:= 14;
            Style:= [fsBold];
            Color:= clNavy;
          end;
          JvRichEdit1.AddFormatText('Satelite ACTIVO',fuente);
          JvRichEdit1.Lines.Add('');
          JvLED1.Active:= false;
          JvLED1.ColorOn:=clLime;
          JvLED1.Status:= true;
          timer1.Enabled:=False;
       end;
end;

procedure Executeftp (AThread: TIdPeerThread);
var
  i: integer;
begin
  with AThread.Connection do begin
    WriteLn('Hello. DB Server ready.');
    i := StrToIntDef(ReadLn, 0);
    // Sleep is substituted for a long DB or other call
    Sleep(5000);
    WriteLn(IntToStr(i * 7));
    Disconnect;
  end;

end;

end.
