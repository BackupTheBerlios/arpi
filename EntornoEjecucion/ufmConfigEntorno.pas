unit ufmConfigEntorno;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, uEntornoEjecucion, JvBaseDlg,
  JvSelectDirectory, JvComponent, JvBrowseFolder, Mask, JvExMask,
  JvToolEdit;

type
  TfrmConfigEntorno = class (TForm)
    Button1: TButton;
    Button2: TButton;
    JvBDialog: TJvBrowseForFolderDialog;
    Label1: TLabel;
    Label2: TLabel;
    leDirAlg: TJvDirectoryEdit;
    leDirTrabajo: TJvDirectoryEdit;
  public
    function execute: Boolean;
  end;
  
var
  frmConfigEntorno: TfrmConfigEntorno;

implementation

{$R *.dfm}

{ TForm4 }


{
****************************** TfrmConfigEntorno *******************************
}
function TfrmConfigEntorno.execute: Boolean;
var
  entorno: TEntornoEjecucion;
begin
  entorno := TEntornoEjecucion.Instance;
  leDirAlg.Text := entorno.getDirectorioAlgoritmos;
  leDirTrabajo.Text := entorno.getDirectorioTrabajo;
  result := false;
  if Self.ShowModal = mrOk then
  begin
    entorno.configurarDirectorioTrabajoEjecucion(leDirTrabajo.Text);
    entorno.configurarDirectorioAlgoritmos(leDirAlg.Text);
    result := true;
  end;
  close;
end;

end.

