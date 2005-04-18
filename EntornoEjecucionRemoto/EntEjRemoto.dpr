program EntEjRemoto;

uses
  Forms,
  uFrmPrincipalEER in 'uFrmPrincipalEER.pas' {FrmPrincipalEER},
  uAlgoritmo in '..\Modelo\uAlgoritmo.PAS',
  uReceptor in '..\Modelo\uReceptor.PAS',
  ARPIFTPServer in '..\FTP\ARPIFTPSERVER.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFrmPrincipalEER, FrmPrincipalEER);
  Application.Run;
end.
