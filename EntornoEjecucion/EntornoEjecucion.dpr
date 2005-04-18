program EntornoEjecucion;

uses
  Forms,
  uFmPrincipal in 'uFmPrincipal.pas' {fmPrincipal},
  uEntornoEjecucion in '..\modelo\uEntornoEjecucion.pas',
  ufrmimagen in 'ufrmimagen.pas' {frmImagen},
  ufmMatriz in 'ufmMatriz.pas' {fmMatriz},
  ufmConfigMatriz in 'ufmConfigMatriz.pas' {fmPropiedadesMatriz},
  DelphiTwain in '..\Componentes\TWAIN\DelphiTwain.pas',
  Twain in '..\Componentes\TWAIN\Twain.pas',
  DelphiTwainUtils in '..\Componentes\TWAIN\DelphiTwainUtils.pas',
  ufmConfigEntorno in 'ufmConfigEntorno.pas' {frmConfigEntorno},
  ufrmzoomimg in 'ufrmzoomimg.pas' {frmZoomImg},
  ufmListaDePasos in 'ufmListaDePasos.pas' {fmListaDePasos},
  uComponentesARPI in 'uComponentesARPI.pas',
  uCommon in 'uCommon.pas',
  udmEntorno in '..\EntornoDesarrollo\udmEntorno.pas' {dmEntorno: TDataModule};

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TfmPrincipal, fmPrincipal);
  Application.CreateForm(TfmPropiedadesMatriz, fmPropiedadesMatriz);
  Application.CreateForm(TfrmConfigEntorno, frmConfigEntorno);
  Application.CreateForm(TfrmZoomImg, frmZoomImg);
  Application.CreateForm(TdmEntorno, dmEntorno);
  Application.Run;
end.


