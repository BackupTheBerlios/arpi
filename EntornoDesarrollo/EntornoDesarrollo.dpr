program EntornoDesarrollo;

uses
  gnugettext in 'gnugettext.pas',
  Forms,
  uFmPrincipal in 'uFmPrincipal.pas' {fmEntornoDesarrollo},
  ufmShrinkPanel in 'ufmShrinkPanel.pas' {fmShrinkPanel},
  ufmEditorPropiedades in 'ufmEditorPropiedades.pas' {fmEditorPropiedades},
  ufmEditorCodigo in 'ufmEditorCodigo.pas' {fmEditorCodigo},
  ufmConfigProyecto in 'ufmConfigProyecto.pas' {fmConfigProyecto},
  ufrmDescripcion in 'ufrmDescripcion.pas' {frmDescripcion: TFrame},
  udmEntorno in 'udmEntorno.pas' {dmEntorno: TDataModule},
  ufmConfigEntorno in 'ufmConfigEntorno.pas' {fmConfigEntorno},
  ufrmCompilador in 'ufrmCompilador.pas' {frmCompilador: TFrame},
  ufmMensajes in 'ufmMensajes.pas' {fmMensajes},
  uComponentesARPI in 'uComponentesARPI.pas',
  uCommon in '..\EntornoEjecucion\uCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TdmEntorno, dmEntorno);
  Application.CreateForm(TfmEntornoDesarrollo, fmEntornoDesarrollo);
  Application.CreateForm(TfmConfigProyecto, fmConfigProyecto);
  Application.Run;
end.

