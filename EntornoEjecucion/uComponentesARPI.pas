unit uComponentesARPI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, Contnrs, dialogs, JvListBox;

type
  TTipoContenible = (Numero, NumeroEntero, Complejo, Letra, Texto);

  IARPIControl = interface (IInterface)
    ['{E3225471-6E43-4B86-84C5-F501A5872CFD}']
    procedure setIdioma(unIdioma:string);
  end;


  TArpiPanel = class (TPanel)
  end;

  TARPILabel = class (TLabel, IARPIControl)
  private
    FCaption:TStrings;
  public
    destructor Destroy; override;
    procedure Loaded; override;
    procedure setIdioma(unIdioma:string);
  end;

  TARPIEdit = class (TEdit, IARPIControl)
  private
    FTipo: TTipoContenible;
    procedure FonChange(Sender: TObject);
  published
    property Tipo: TTipoContenible read FTipo write FTipo;
    procedure Loaded; override;
    procedure Repaint; override;
    procedure setIdioma(unIdioma:string);
  end;

  TARPICheckBox = class (TCheckBox, IARPIControl)
    FCaption:TStrings;
    procedure FonChange(Senter: TObject);
  public
    destructor Destroy; override;
    procedure Loaded; override;
    procedure setIdioma(unIdioma:string);
  end;

  TARPIComboBox = class (TComboBox, IARPIControl)
  private
    FItems : TStrings;
    procedure FonChange(Sender: TObject); virtual;
  public
    destructor Destroy; override;
    procedure Loaded; override;
    procedure setIdioma(unIdioma:string);
  end;

  TARPIListBox = class (TJvListBox, IARPIControl)
  private
    FItems : TStrings;
  public
    destructor Destroy; override;
    procedure Loaded; override;
    procedure FonChange(Sender: TObject);
    procedure setIdioma(unIdioma:string);
  published
    property Items;
    property ItemIndex;
  end;

  TARPIRadioGroup = class (TRadioGroup, IARPIControl)
  private
    FCaption:TStrings;
    FItems : TStrings;
    procedure FonChange(Sender: TObject);
  public
    destructor Destroy; override;
    procedure Loaded; override;
    procedure setIdioma(unIdioma:string);
  end;

  TARPIImagen = class (TARPIComboBox)
  private
    procedure FonChange(Senter: TObject); override;
  public
    procedure DropDown(Sender: TObject);
    procedure Loaded; override;
  end;

  TARPIMatriz = class (TARPIComboBox)
  private
    procedure FonChange(Senter: TObject); override;
  public
    procedure DropDown(Sender: TObject);
    procedure Loaded; override;
  end;

implementation

uses
  uEntornoEjecucion, JclStrings;

{ TARPILabel }

destructor TARPILabel.Destroy;
begin
  FCaption.Free;
  inherited;
end;

procedure TARPILabel.Loaded;
begin

  if not Assigned(FCaption) then
  begin
    FCaption := TStringList.Create;
    FCaption.Clear;
  end;
  FCaption.Delimiter := '|';
  FCaption.DelimitedText := Caption;

  inherited;
end;

procedure TARPILabel.setIdioma(unIdioma: string);
begin
  Caption := FCaption.Values[unIdioma];
end;

{ TARPIListBox}

destructor TARPIListBox.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TARPIListBox.FonChange(Sender: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(parent.Parent.parent.name, name, inttostr(itemindex));
end;

procedure TARPIListBox.Loaded;
begin
  if not Assigned(FItems) then
  begin
    FItems := TStringList.Create;
    FItems.Clear;
  end;

  FItems.AddStrings(Items);
  inherited;
  onChange := FonChange;
end;

procedure TARPIListBox.setIdioma(unIdioma: string);
begin
  Items.CommaText := FItems.Values[unIdioma];
end;

{ TARPIComboBox}

destructor TARPIComboBox.Destroy;
begin
  FItems.Free;
  inherited;
end;

procedure TARPIComboBox.FonChange(Sender: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(Parent.Parent.Parent.name, name, inttostr(itemindex));
end;

procedure TARPIComboBox.Loaded;
begin

  if not Assigned(FItems) then
  begin
    FItems := TStringList.Create;
    FItems.Clear;
  end;

  FItems.AddStrings(Items);

  inherited;
  onChange := FonChange;
end;

procedure TARPIComboBox.setIdioma(unIdioma: string);
begin
  Items.CommaText := FItems.Values[unIdioma];
end;

{ TARPIRadioGroup }

destructor TARPIRadioGroup.Destroy;
begin
  FItems.Free;
  FCaption.Free;
  inherited;
end;

procedure TARPIRadioGroup.FonChange(Sender: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(Parent.Parent.Parent.name, name, inttostr(itemindex));
end;

procedure TARPIRadioGroup.Loaded;
begin
  if not Assigned(FItems) then
  begin
    FItems := TStringList.Create;
    FCaption := TStringList.Create;
    FItems.Clear;
    FCaption.Clear;
  end;

  FItems.AddStrings(Items);
  FCaption.Add(Caption);

  inherited;
  onClick := FonChange;
end;

procedure TARPIRadioGroup.setIdioma(unIdioma: string);
begin
  Items.CommaText := FItems.Values[unIdioma];
  Caption := FCaption.Values[unIdioma];
end;

{ TARPICheckBox }

destructor TARPICheckBox.Destroy;
begin
  FCaption.Free;
  inherited;
end;

procedure TARPICheckBox.FonChange(Senter: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(Parent.Parent.Parent.name, name, BoolToStr(Checked));
end;

procedure TARPICheckBox.Loaded;
begin
  if not Assigned(FCaption) then
  begin
    FCaption := TStringList.Create;
    FCaption.Clear;
  end;

  FCaption.Add(Caption);

  inherited;
  OnClick := FonChange;
end;

procedure TARPICheckBox.setIdioma(unIdioma: string);
begin
  Caption := FCaption.Values[unIdioma];
end;

{ TARPIImagen }

procedure TARPIImagen.DropDown(Sender: TObject);
begin
  //buscar del sistema las cosas que faltan
  Items := TEntornoEjecucion.Instance.getListaImagenes;
end;

procedure TARPIImagen.FonChange(Senter: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(Parent.Parent.Parent.name, name, Items.strings[itemindex]);
end;

procedure TARPIImagen.Loaded;
begin
  inherited;
  Text := '';
  onDropDown := DropDown;
end;

{ TARPIMatriz }

procedure TARPIMatriz.DropDown(Sender: TObject);
begin
  //buscar del sistema las cosas que faltan
  Items := TEntornoEjecucion.Instance.getListaMatrices;
end;

procedure TARPIMatriz.FonChange(Senter: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(Parent.Parent.Parent.name, name, Items.strings[itemindex]);
end;

procedure TARPIMatriz.Loaded;
begin
  inherited;
  Text := '';
  onDropDown := DropDown;
end;

{ TARPIEdit }

procedure TARPIEdit.FonChange(Sender: TObject);
begin
  TEntornoEjecucion.Instance.ingresarValor(Parent.Parent.Parent.name, name, Text);
end;

procedure TARPIEdit.Loaded;
begin
  inherited;
  OnExit := FonChange;
end;

procedure TARPIEdit.Repaint;
begin
  inherited;
  Text := TEntornoEjecucion.Instance.getValorParametro(Parent.Parent.Parent.name, name, '');
end;

procedure TARPIEdit.setIdioma(unIdioma: string);
begin
//
end;

initialization
  RegisterClasses([TARPIEdit, TARPIComboBox, TARPILabel, TARPICheckBox, TARPIListBox, TARPIImagen, TARPIMatriz, TARPIRadioGroup]);
end.
