unit ufmEditorPropiedades;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvComponent, JvInspector, Grids, ValEdit, JvExControls,
  ELPropInsp, Types, TypInfo;

type

  TStringIdiomaDlgProperty = class (TELClassPropEditor)
  protected
    procedure Edit; override;
    function GetAttrs: TELPropAttrs; override;
  end;
  
  TStringsIdiomaDlgProperty = class (TELClassPropEditor)
  protected
    procedure Edit; override;
    function GetAttrs: TELPropAttrs; override;
  end;
  
  TfmEditorPropiedades = class (TForm)
    propiedades: TELPropertyInspector;
    procedure FormCreate(Sender: TObject);
    procedure propiedadesFilterProp(Sender: TObject; AInstance: TPersistent;
            APropInfo: PPropInfo; var AIncludeProp: Boolean);
    procedure CambiarIdioma;
  end;
  
implementation

{$R *.dfm}

uses
  ufmShrinkPanel, jclStrings, ufmStringIdiomaDlg, ufmStringsIdiomaDlg,
  ufmPrincipal, uComponentesARPI, gnugettext;

{ TStringIdiomaDlgProperty }

{
*************************** TStringIdiomaDlgProperty ***************************
}
procedure TStringIdiomaDlgProperty.Edit;
var
  editor: TfmStringIdiomaDlg;
begin
  editor := TfmStringIdiomaDlg.Create(Application);
  try
    editor.Value := string(GetStrValue(0));
    if editor.Execute then
      SetStrValue(editor.value);
  finally
    editor.Free;
  end;
end;

function TStringIdiomaDlgProperty.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praDialog];
end;

{
***************************** TfmEditorPropiedades *****************************
}
procedure TfmEditorPropiedades.CambiarIdioma;
begin
  RetranslateComponent(self);
end;

procedure TfmEditorPropiedades.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  propiedades.RegisterPropEditor(TypeInfo(TCaption), TARPILabel, 'caption', TStringIdiomaDlgProperty);
  propiedades.RegisterPropEditor(TypeInfo(TCaption), TARPICheckBox, 'caption', TStringIdiomaDlgProperty);
  propiedades.RegisterPropEditor(TypeInfo(TStrings), TARPICombobox, 'items', TStringsIdiomaDlgProperty);
  propiedades.RegisterPropEditor(TypeInfo(TStrings), TARPIListbox, 'items', TStringsIdiomaDlgProperty);
  propiedades.RegisterPropEditor(TypeInfo(TStrings), TARPIRadioGroup, 'items', TStringsIdiomaDlgProperty);
  propiedades.RegisterPropEditor(TypeInfo(TCaption), TARPIRadioGroup, 'caption', TStringIdiomaDlgProperty);
end;

procedure TfmEditorPropiedades.propiedadesFilterProp(Sender: TObject; 
        AInstance: TPersistent; APropInfo: PPropInfo; var AIncludeProp: 
        Boolean);
begin
  AIncludeProp:= (not supports(AInstance.ClassType, IARPIControl)) or //si no es ARPIControl muestra todas las propiedades
                 (supports(AInstance.ClassType, IARPIControl) and
                 ((TControl(AInstance) as IARPIControl).getProperties.IndexOfName(APropInfo.Name)>=0));
end;

{ TStringsIdiomaDlgProperty }

{
************************** TStringsIdiomaDlgProperty ***************************
}
procedure TStringsIdiomaDlgProperty.Edit;
var
  editor: TfmStringsIdiomaDlg;
begin
  editor := TfmStringsIdiomaDlg.Create(Application);
  try
    editor.Value := TStrings(GetOrdValue(0));
    if editor.Execute then
      SetOrdValue(Longint(editor.value));
  finally
    editor.Free;
  end;
end;

function TStringsIdiomaDlgProperty.GetAttrs: TELPropAttrs;
begin
  Result := [praMultiSelect, praDialog];
end;

end.

