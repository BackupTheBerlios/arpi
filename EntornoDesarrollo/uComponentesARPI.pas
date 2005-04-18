unit uComponentesARPI;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, ExtCtrls, ComCtrls, Contnrs;

type
  TTipoContenible = (Numero, NumeroEntero, Complejo, Letra, Texto);

  IARPIControl = interface (IInterface)
    ['{E00EFEA3-F3E8-4801-9D3B-FECB01C9FC5E}']
    function getProperties: TStringList;
    procedure setIdioma(unIdioma:string);
  end;
  
  IARPIComponente = interface (IARPIControl)
    ['{2D9975AF-5351-46AA-AB14-9C4081690A1E}']
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TArpiPanel = class (TPanel, IARPIControl)
  private
    FXGrid: Integer;
    FYGrid: Integer;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure setIdioma(unIdioma:string);
  published
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
    property XGrid: Integer read FXGrid write FXGrid;
    property YGrid: Integer read FYGrid write FYGrid;
  end;

  TARPILabel = class (TLabel, IARPIControl, IARPIComponente)
  private
    FCaption: TStringList;
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetText: TCaption;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetText(const Value: TCaption);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    procedure SetName(const Value: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure setIdioma(unIdioma:string);
  published
    property Caption: TCaption read GetText write SetText;
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TARPIEdit = class (TEdit, IARPIControl, IARPIComponente)
  private
    procedure ChangeValue(sender:TObject);
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTipo: TTipoContenible;
    function GetTop: Integer;
    function GetValor: TCaption;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTipo(const Value: TTipoContenible);
    procedure SetTop(const Value: Integer);
    procedure SetValor(const Value: TCaption);
    procedure SetWidth(const Value: Integer);
  protected
    procedure setName(const Value: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure setBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure setIdioma(unIdioma:string);
  published
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read GetLeft write SetLeft;
    property Text: TCaption read GetValor write SetValor;
    property Tipo: TTipoContenible read GetTipo write SetTipo;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TARPICheckBox = class (TCheckBox, IARPIControl, IARPIComponente)
  private
    FCaption: TStringList;
    function GetCaption: TCaption;
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function getValor: Boolean;
    function GetWidth: Integer;
    procedure SetCaption(const Value: TCaption);
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure setValor(const Value: Boolean);
    procedure SetWidth(const Value: Integer);
  protected
    procedure SetName(const Value: TComponentName); override;
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure setIdioma(unIdioma:string);
  published
    property Caption: TCaption read GetCaption write SetCaption;
    property Checked: Boolean read getValor write setValor;
    property Height: Integer read GetHeight write SetHeight;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TARPIComboBox = class (TComboBox, IARPIControl, IARPIComponente)
  private
    FItems: TStringList;
    function GetHeight: Integer;
    function GetItems: TStrings;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    function getValor: Integer; virtual;
    procedure SetItems(const Value: TStrings); override;
    procedure setName(const Value: TComponentName); override;
    procedure setValor(const Value: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure setBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure setIdioma(unIdioma:string);
  published
    property Height: Integer read GetHeight write SetHeight;
    property ItemIndex: Integer read getValor write setValor;
    property Items: TStrings read GetItems write SetItems;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TARPIListBox = class (TListBox, IARPIControl, IARPIComponente)
  private
    FItems : TStringList;
    function GetHeight: Integer;
    function GetItems: TStrings;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    function getValor: Integer; virtual;
    procedure setName(const Value: TComponentName); override;
    procedure setValor(const Value: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure setBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure setIdioma(unIdioma:string);
  published
    property Height: Integer read GetHeight write SetHeight;
    property ItemIndex: Integer read getValor write setValor;
    property Items: TStrings read GetItems write SetItems;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TARPIRadioGroup = class (TRadioGroup, IARPIControl, IARPIComponente)
  private
    FCaption : TStringList;
    FItems : TStringList;
    function GetHeight: Integer;
    function GetItems: TStrings;
    function GetLeft: Integer;
    function GetText: TCaption;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetLeft(const Value: Integer);
    procedure SetText(const Value: TCaption);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
  protected
    function getValor: Integer; virtual;
    procedure setName(const Value: TComponentName); override;
    procedure setValor(const Value: Integer); virtual;
    procedure setIdioma(unIdioma:string);
  public
    constructor Create(AOwner: TComponent); override;
    function getProperties: TStringList;
    procedure setBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
  published
    property Caption: TCaption read GetText write SetText;
    property Height: Integer read GetHeight write SetHeight;
    property ItemIndex: Integer read getValor write setValor;
    property Items: TStrings read GetItems write SetItems;
    property Left: Integer read GetLeft write SetLeft;
    property Top: Integer read GetTop write SetTop;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TARPIImagen = class (TARPIComboBox, IARPIControl, IARPIComponente)
  private
    function GetItems: TStrings;
  protected
    function getValor: Integer; override;
    procedure setValor(const Value: Integer); override;
  public
    function getProperties: TStringList;
  published
    property Items: TStrings read GetItems;
  end;

  TARPIMatriz = class (TARPIComboBox, IARPIControl, IARPIComponente)
  private
    function GetItems: TStrings;
  protected
    function getValor: Integer; override;
    procedure setValor(const Value: Integer); override;
  public
    function getProperties: TStringList;
  published
    property Items: TStrings read GetItems;
  end;

implementation

uses
  uEntornoDesarrollo, JclStrings;

const
  strTipoContenible : array[TTipoContenible] of string = ('numero', 'numeroEntero', 'complejo', 'letra', 'texto');

{ TARPILabel }

{
********************************** TARPILabel **********************************
}
constructor TARPILabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AutoSize := false;
end;

function TARPILabel.GetHeight: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'height',''))
  else
    result:= inherited height;
end;

function TARPILabel.GetLeft: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'left',''))
  else
    result:= inherited left;
end;

function TARPILabel.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
  result.Values['Caption']:='Caption';
end;

function TARPILabel.GetText: TCaption;
var
  i: Integer;
  aux: TStrings;
begin
  result := '';
  aux:=TEntornoDesarrollo.instance.mostrarIdiomasProyecto;
  for i:= 0 to aux.Count -1 do
  begin
    if i>0 then result := result + '|';
    if name<>'' then
      result := result + aux.strings[i]+'=' + TEntornoDesarrollo.instance.getPropiedad(name, 'caption', aux.strings[i]);
  end;
end;

function TARPILabel.GetTop: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'top',''))
  else
    result:= inherited top;
end;

function TARPILabel.GetWidth: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'width',''))
  else
    result:= inherited width;
end;

procedure TARPILabel.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited setBounds(ALeft, ATop, AWidth, AHeight);
  if Left <> ALeft then Left := ALeft;
  if Top <>  ATop then Top :=  ATop;
  if Width <> AWidth then Width := AWidth;
  if Height <> AHeight then Height := AHeight;
end;

procedure TARPILabel.SetHeight(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'height',inttostr(Value),'');
  inherited height := value;
end;

procedure TARPILabel.setIdioma(unIdioma: string);
begin
  inherited Caption := FCaption.Values[unIdioma];
end;

procedure TARPILabel.SetLeft(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'left',inttostr(Value),'');
  inherited left := value;
end;

procedure TARPILabel.SetName(const Value: TComponentName);
begin
  if name = '' then
  begin
    TEntornoDesarrollo.instance.setearPropiedad(Value, 'name', Value, '');
    inherited setName(Value);
  end
  else
  begin
    TEntornoDesarrollo.instance.setearPropiedad(name, 'name', Value, '');
    inherited setName(Value);
  end;
  setText(getText);
end;

procedure TARPILabel.SetText(const Value: TCaption);
var
  i: Integer;
begin
  if not assigned(FCaption) then
    FCaption := TStringList.Create;
  FCaption.Clear;
  StrToStrings(value,'|',FCaption);
  for i := 0 to FCaption.Count - 1 do
    if name<>'' then
      TEntornoDesarrollo.instance.setearPropiedad(name, 'caption' , FCaption.ValueFromIndex[i], FCaption.Names[i]);
  setIdioma('es');
end;

procedure TARPILabel.SetTop(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'top',inttostr(Value),'');
  inherited top := value;
end;

procedure TARPILabel.SetWidth(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'width',inttostr(Value),'');
  inherited width := value;
end;

{ TARPIEdit }

{
********************************** TARPIEdit ***********************************
}
constructor TARPIEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TARPIEdit.ChangeValue(sender:TObject);
begin
  if Modified then
    try
      setValor(Caption)
    except
      getValor;
    end;
end;

function TARPIEdit.GetHeight: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'height',''))
  else
    result:= inherited height;
end;

function TARPIEdit.GetLeft: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'left',''))
  else
    result:= inherited left;
end;

function TARPIEdit.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
  result.Values['Tipo']:='Tipo';
  result.Values['Text']:='Valor';
end;

function TARPIEdit.GetTipo: TTipoContenible;
var
  aux: string;
begin
  aux := TEntornoDesarrollo.instance.getPropiedad(name, 'tipo', '');
  if lowercase(aux) ='numero' then
    result := Numero
  else if lowercase(aux) ='numeroentero' then
    result := NumeroEntero
  else if lowercase(aux) ='complejo' then
    result := Complejo
  else if lowercase(aux) ='letra' then
    result := Letra;
end;

function TARPIEdit.GetTop: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'top',''))
  else
    result:= inherited top;
end;

function TARPIEdit.GetValor: TCaption;
begin
  if name<>'' then
    inherited caption := TEntornoDesarrollo.instance.getPropiedad(name, name, '');
  result := inherited caption;
end;

function TARPIEdit.GetWidth: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'width',''))
  else
    result:= inherited width;
end;

procedure TARPIEdit.setBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited setBounds(ALeft, ATop, AWidth, AHeight);
  if Left <> ALeft then Left := ALeft;
  if Top <>  ATop then Top :=  ATop;
  if Width <> AWidth then Width := AWidth;
  if Height <> AHeight then Height := AHeight;
end;

procedure TARPIEdit.SetHeight(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'height',inttostr(Value),'');
  inherited height := value;
end;

procedure TARPIEdit.SetLeft(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'left',inttostr(Value),'');
  inherited left:= value;
end;

procedure TARPIEdit.setName(const Value: TComponentName);
begin
  if name = '' then
  begin
    TEntornoDesarrollo.instance.setearPropiedad(Value, 'name', Value, '');
    inherited setName(Value);
  end
  else
  begin
    TEntornoDesarrollo.instance.setearPropiedad(name, 'name', Value, '');
    inherited setName(Value);
  end;
end;

procedure TARPIEdit.SetTipo(const Value: TTipoContenible);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, 'tipo', strTipoContenible[Value], '');
end;

procedure TARPIEdit.SetTop(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'top',inttostr(Value),'');
  inherited Top := Value;
end;

procedure TARPIEdit.SetValor(const Value: TCaption);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, name, Value,'');
  inherited caption := value;
end;

procedure TARPIEdit.SetWidth(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'width',inttostr(Value),'');
  inherited Width := Value;
end;

{ TARPIComboBox }

{
******************************** TARPIComboBox *********************************
}
constructor TARPIComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TARPIComboBox.GetHeight: Integer;
begin
  result := inherited height;
end;

function TARPIComboBox.GetItems: TStrings;
var
  i: Integer;
  aux: TStrings;
begin
  result := TStringList.Create;
  aux:=TEntornoDesarrollo.instance.mostrarIdiomasProyecto;
  for i:= 0 to aux.Count -1 do
    if name<>'' then
      result.Values[aux.strings[i]] := TEntornoDesarrollo.instance.getPropiedad(name, 'items', aux.strings[i]);
  inherited Items.CommaText := result.ValueFromIndex[0]; {TODO: cambiar el primer idioma por el predeterminado}
end;

function TARPIComboBox.GetLeft: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'left',''))
  else
    result:= inherited left;
end;

function TARPIComboBox.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
  result.Values['Items']:='Items';
  result.Values['ItemIndex']:='Items';
end;

function TARPIComboBox.GetTop: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'top',''))
  else
    result:= inherited top;
end;

function TARPIComboBox.getValor: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name, name, ''))
  else
    result:= inherited ItemIndex;
end;

function TARPIComboBox.GetWidth: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'width',''))
  else
    result:= inherited width;
end;

procedure TARPIComboBox.setBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited setBounds(ALeft, ATop, AWidth, AHeight);
  if Left <> ALeft then Left := ALeft;
  if Top <> ATop then Top := ATop;
  if Width <> AWidth then Width := AWidth;
  if Height <> AHeight then Height := AHeight;
end;

procedure TARPIComboBox.SetHeight(const Value: Integer);
begin
end;

procedure TARPIComboBox.setIdioma(unIdioma: string);
begin
  inherited Items.Commatext := FItems.Values[unIdioma];
end;

procedure TARPIComboBox.SetItems(const Value: TStrings);
var
  i: Integer;
begin
  if not assigned(FItems) then
    FItems := TStringList.Create;
  FItems.Clear;
  FItems.AddStrings(Value);
  for i := 0 to value.Count - 1 do
    if name<>'' then
      TEntornoDesarrollo.instance.setearPropiedad(name, 'items' ,value.ValueFromIndex[i], value.Names[i]);
end;

procedure TARPIComboBox.SetLeft(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'left',inttostr(Value),'');
  inherited left := Value;
end;

procedure TARPIComboBox.setName(const Value: TComponentName);
begin
  if name = '' then
  begin
    TEntornoDesarrollo.instance.setearPropiedad(Value, 'name', Value, '');
    inherited setName(Value);
  end
  else
  begin
    TEntornoDesarrollo.instance.setearPropiedad(name, 'name', Value, '');
    inherited setName(Value);
  end;
end;

procedure TARPIComboBox.SetTop(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, 'top', inttostr(Value),'');
  inherited Top := Value;
end;

procedure TARPIComboBox.setValor(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, name, inttostr(Value),'');
  inherited ItemIndex := Value;
end;

procedure TARPIComboBox.SetWidth(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'width',inttostr(Value),'');
  inherited Width := Value;
end;

{ TARPIImagen }

{
********************************* TARPIImagen **********************************
}
function TARPIImagen.GetItems: TStrings;
begin
  {TODO: llamar al método que pida el Items de imágenes en Estructura!}
end;

function TARPIImagen.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
end;

function TARPIImagen.getValor: Integer;
begin
  result := getItemIndex ;
end;

procedure TARPIImagen.setValor(const Value: Integer);
begin
  setItemIndex(Value);
end;


{ TARPIMatriz }

{
********************************* TARPIMatriz **********************************
}
function TARPIMatriz.GetItems: TStrings;
begin
  {TODO: llamar al método que pida el Items de matrices en Estructura!}
end;

function TARPIMatriz.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
end;

function TARPIMatriz.getValor: Integer;
begin
  result:= getItemIndex;
end;

procedure TARPIMatriz.setValor(const Value: Integer);
begin
  setItemIndex(Value);
end;

{ TARPIListBox }

{
********************************* TARPIListBox *********************************
}
constructor TARPIListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TARPIListBox.GetHeight: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'height',''))
  else
    result:= inherited height;
end;

function TARPIListBox.GetItems: TStrings;
var
  i: Integer;
  aux: TStrings;
begin
  result := TStringList.Create;
  aux:=TEntornoDesarrollo.instance.mostrarIdiomasProyecto;
  for i:= 0 to aux.Count -1 do
    if name<>'' then
      result.Values[aux.strings[i]] := TEntornoDesarrollo.instance.getPropiedad(name, 'items', aux.strings[i])
    else
      result.Values[aux.strings[i]] := inherited Items.Commatext;
  inherited Items.CommaText := result.ValueFromIndex[0]; {TODO: cambiar el primer idioma por el predeterminado}
end;

function TARPIListBox.GetLeft: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'left',''))
  else
    result:= inherited left;
end;

function TARPIListBox.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
  result.Values['Items']:='Items';
  result.Values['ItemIndex']:='Items';
end;

function TARPIListBox.GetTop: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'top',''))
  else
    result:= inherited top;
end;

function TARPIListBox.getValor: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name, name, ''))
  else
    result:= inherited ItemIndex;
end;

function TARPIListBox.GetWidth: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'width',''))
  else
    result:= inherited width;
end;

procedure TARPIListBox.setBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited setBounds(ALeft, ATop, AWidth, AHeight);
  if Left <> ALeft then Left := ALeft;
  if Top <>  ATop then Top :=  ATop;
  if Width <> AWidth then Width := AWidth;
  if Height <> AHeight then Height := AHeight;
end;

procedure TARPIListBox.SetHeight(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'height',inttostr(Value),'');
  inherited height := Value;
end;

procedure TARPIListBox.setIdioma(unIdioma: string);
begin
  inherited Items.Commatext := FItems.Values[unIdioma];
end;

procedure TARPIListBox.SetItems(const Value: TStrings);
var
  i: Integer;
begin
  if not assigned(FItems) then
    FItems := TStringList.Create;
  FItems.Clear;
  FItems.AddStrings(Value);
  for i := 0 to value.Count - 1 do
    if name<>'' then
      TEntornoDesarrollo.instance.setearPropiedad(name, 'items', value.ValueFromIndex[i], value.Names[i]);
end;

procedure TARPIListBox.SetLeft(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'left',inttostr(Value),'');
  inherited left := Value;
end;

procedure TARPIListBox.setName(const Value: TComponentName);
begin
  if name = '' then
  begin
    TEntornoDesarrollo.instance.setearPropiedad(Value, 'name', Value, '');
    inherited setName(Value);
  end
  else
  begin
    TEntornoDesarrollo.instance.setearPropiedad(name, 'name', Value, '');
    inherited setName(Value);
  end;
end;

procedure TARPIListBox.SetTop(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, 'top', inttostr(Value),'');
  inherited Top := Value;
end;

procedure TARPIListBox.setValor(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, name, inttostr(Value),'');
  inherited ItemIndex := Value;
end;

procedure TARPIListBox.SetWidth(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'width',inttostr(Value),'');
  inherited Width := Value;
end;

{
******************************* TARPIRadioGroup ********************************
}
constructor TARPIRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TARPIRadioGroup.GetHeight: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'height',''))
  else
    result:= inherited height;
end;

function TARPIRadioGroup.GetItems: TStrings;
var
  i: Integer;
  aux: TStrings;
begin
  result := TStringList.Create;
  aux:=TEntornoDesarrollo.instance.mostrarIdiomasProyecto;
  for i:= 0 to aux.Count -1 do
    if name<>'' then
      result.Values[aux.strings[i]] := TEntornoDesarrollo.instance.getPropiedad(name, 'items', aux.strings[i])
    else
      result.Values[aux.strings[i]] := inherited Items.Commatext;
  inherited Items.CommaText := result.ValueFromIndex[0]; {TODO: cambiar el primer idioma por el predeterminado}
end;

function TARPIRadioGroup.GetLeft: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'left',''))
  else
    result:= inherited left;
end;

function TARPIRadioGroup.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Caption']:='Etiqueta';
  result.Values['Height']:='Alto';
  result.Values['Items']:='Items';
  result.Values['ItemIndex']:='Items';
end;

function TARPIRadioGroup.GetText: TCaption;
var
  i: Integer;
  aux: TStrings;
begin
  result := '';
  aux:=TEntornoDesarrollo.instance.mostrarIdiomasProyecto;
  for i:= 0 to aux.Count -1 do
  begin
    if i>0 then result := result + '|';
    if name<>'' then
      result := result + aux.strings[i]+'=' + TEntornoDesarrollo.instance.getPropiedad(name, 'caption', aux.strings[i]);
  end;
end;

function TARPIRadioGroup.GetTop: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'top',''))
  else
    result:= inherited top;
end;

function TARPIRadioGroup.getValor: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name, name, ''))
  else
    result:= inherited ItemIndex;
end;

function TARPIRadioGroup.GetWidth: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'width',''))
  else
    result:= inherited width;
end;

procedure TARPIRadioGroup.setBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited setBounds(ALeft, ATop, AWidth, AHeight);
  if Left <> ALeft then Left := ALeft;
  if Top <>  ATop then Top :=  ATop;
  if Width <> AWidth then Width := AWidth;
  if Height <> AHeight then Height := AHeight;
end;

procedure TARPIRadioGroup.SetHeight(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'height',inttostr(Value),'');
  inherited height := Value;
end;

procedure TARPIRadioGroup.setIdioma(unIdioma: string);
begin
  inherited Caption := FCaption.Values[unIdioma];
  inherited Items.Commatext := FItems.Values[unIdioma];
end;

procedure TARPIRadioGroup.SetItems(const Value: TStrings);
var
  i: Integer;
begin
  if not assigned(FItems) then
    FItems := TStringList.Create;
  FItems.Clear;
  FItems.AddStrings(Value);
  for i := 0 to value.Count - 1 do
    if name<>'' then
      TEntornoDesarrollo.instance.setearPropiedad(name, 'items', value.ValueFromIndex[i], value.Names[i]);
end;

procedure TARPIRadioGroup.SetLeft(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'left',inttostr(Value),'');
  inherited left := Value;
end;

procedure TARPIRadioGroup.setName(const Value: TComponentName);
begin
  if name = '' then
  begin
    TEntornoDesarrollo.instance.setearPropiedad(Value, 'name', Value, '');
    inherited setName(Value);
  end
  else
  begin
    TEntornoDesarrollo.instance.setearPropiedad(name, 'name', Value, '');
    inherited setName(Value);
  end;
end;

procedure TARPIRadioGroup.SetText(const Value: TCaption);
var
  i: Integer;
begin
  if assigned(FCaption) then
    FCaption := TStringList.Create;
  FCaption.Clear;
  StrToStrings(value,'|', FCaption);
  for i := 0 to FCaption.Count - 1 do
    if name<>'' then
      TEntornoDesarrollo.instance.setearPropiedad(name, 'caption', FCaption.ValueFromIndex[i], FCaption.Names[i]);
end;

procedure TARPIRadioGroup.SetTop(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, 'top', inttostr(Value),'');
  inherited Top := Value;
end;

procedure TARPIRadioGroup.setValor(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name, name, inttostr(Value),'');
  inherited ItemIndex := Value;
end;

procedure TARPIRadioGroup.SetWidth(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'width',inttostr(Value),'');
  inherited Width := Value;
end;

{ TARPICheckBox }

{
******************************** TARPICheckBox *********************************
}
constructor TARPICheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TARPICheckBox.GetCaption: TCaption;
var
  i: Integer;
  aux: TStrings;
begin
  result := '';
  aux:=TEntornoDesarrollo.instance.mostrarIdiomasProyecto;
  for i:= 0 to aux.Count -1 do
  begin
    if i>0 then result := result + '|';
    if name<>'' then
      result := result + aux.strings[i]+'=' + TEntornoDesarrollo.instance.getPropiedad(name, 'caption', aux.strings[i]);
  end;
end;

function TARPICheckBox.GetHeight: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'height',''))
  else
    result:= inherited height;
end;

function TARPICheckBox.GetLeft: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'left',''))
  else
    result:= inherited left;
end;

function TARPICheckBox.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Left']:='Izquierda';
  result.Values['Top']:='Arriba';
  result.Values['Width']:='Ancho';
  result.Values['Height']:='Alto';
  result.Values['Checked']:='Caption';
  result.Values['Caption']:='Caption';
  result.Values['Valor']:='Valor';
end;

function TARPICheckBox.GetTop: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'top',''))
  else
    result:= inherited top;
end;

function TARPICheckBox.getValor: Boolean;
begin
  if name<>'' then
    inherited checked := TEntornoDesarrollo.instance.getPropiedad(name, name, '') = '1';
  result := inherited checked;
end;

function TARPICheckBox.GetWidth: Integer;
begin
  if name<>'' then
    result := strtoint(TEntornoDesarrollo.instance.getPropiedad(name,'width',''))
  else
    result:= inherited width;
end;

procedure TARPICheckBox.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited setBounds(ALeft, ATop, AWidth, AHeight);
  if Left <> ALeft then Left := ALeft;
  if Top <>  ATop then Top :=  ATop;
  if Width <> AWidth then Width := AWidth;
  if Height <> AHeight then Height := AHeight;
end;

procedure TARPICheckBox.SetCaption(const Value: TCaption);
var
  i: Integer;
begin
  if not assigned(FCaption) then
    FCaption := TStringList.Create;
  FCaption.Clear;
  StrToStrings(value,'|', FCaption);
  for i := 0 to FCaption.Count - 1 do
    if name<>'' then
      TEntornoDesarrollo.instance.setearPropiedad(name, 'caption' , FCaption.ValueFromIndex[i], FCaption.Names[i]);
end;

procedure TARPICheckBox.SetHeight(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'height',inttostr(Value),'');
  inherited Height := Value;
end;

procedure TARPICheckBox.setIdioma(unIdioma: string);
begin
  inherited Caption := FCaption.Values[unIdioma];
end;

procedure TARPICheckBox.SetLeft(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'left',inttostr(Value),'');
  inherited Left := Value;
end;

procedure TARPICheckBox.SetName(const Value: TComponentName);
begin
  if name = '' then
  begin
    TEntornoDesarrollo.instance.setearPropiedad(Value, 'name', Value, '');
    inherited setName(Value);
  end
  else
  begin
    TEntornoDesarrollo.instance.setearPropiedad(name, 'name', Value, '');
    inherited setName(Value);
  end;
end;

procedure TARPICheckBox.SetTop(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'top',inttostr(Value),'');
  inherited Top := Value;
end;

procedure TARPICheckBox.setValor(const Value: Boolean);
begin
  if name<>'' then
    if value then
      TEntornoDesarrollo.instance.setearPropiedad(name, name, '1', '')
    else
      TEntornoDesarrollo.instance.setearPropiedad(name, name, '0', '');
  inherited checked := value;
end;

procedure TARPICheckBox.SetWidth(const Value: Integer);
begin
  if name<>'' then
    TEntornoDesarrollo.instance.setearPropiedad(name,'width',inttostr(Value),'');
  inherited Width := Value;
end;

{ TArpiPanel }

{
********************************** TArpiPanel **********************************
}
constructor TArpiPanel.Create(AOwner: TComponent);
begin
  inherited;
  FXGrid := 8;
  FYGrid := 8;
end;

function TArpiPanel.GetHeight: Integer;
begin
  result := strtoint(TEntornoDesarrollo.instance.getPropiedad('height',''));
  inherited height := result;
end;

function TArpiPanel.getProperties: TStringList;
begin
  {TODO: asignar el nombre en base al idioma!!!!}
  result := TStringList.Create;
  result.Values['Name']:=name;
  result.Values['Width']:='Izquierda';
  result.Values['Height']:='Arriba';
end;

function TArpiPanel.GetWidth: Integer;
begin
  result := strtoint(TEntornoDesarrollo.instance.getPropiedad('width',''));
  inherited width := result;
end;

procedure TArpiPanel.Paint;
var
  i, j, w, h: Integer;
begin
  inherited;
  i:=0;
  w:=width;
  h:=height;
  while i<w do
  begin
    j:=0;
    while j<h do
    begin
      canvas.Pixels[i,j]:=clBlack;
      j:=j+FYGrid;
    end;
    i:=i+FXGrid;
  end;
end;

procedure TArpiPanel.SetHeight(const Value: Integer);
begin
  TEntornoDesarrollo.instance.setearPropiedad('height',inttostr(Value),'');
  inherited height := value;
end;

procedure TArpiPanel.setIdioma(unIdioma: string);
begin
//
end;

procedure TArpiPanel.SetWidth(const Value: Integer);
begin
  TEntornoDesarrollo.instance.setearPropiedad('width',inttostr(Value),'');
  inherited Width := value;
end;

procedure TARPIEdit.setIdioma(unIdioma: string);
begin
//
end;

initialization
  RegisterClasses([TARPIEdit, TARPIComboBox, TARPILabel, TARPICheckBox, TARPIListBox, TARPIImagen, TARPIMatriz, TARPIRadioGroup]);
end.
