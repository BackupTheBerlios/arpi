unit udmEntorno;

interface

uses
  SysUtils, Classes, ImgList, Controls, Menus;

type
  TdmEntorno = class (TDataModule)
    ilIdiomasChicas: TImageList;
    ilIdiomasGrandes: TImageList;
  end;

  TIdiomas= (es, en, de, it, fr, ne{ jap});

var
  dmEntorno: TdmEntorno;

const
  idxIdiomas: array[TIdiomas] of integer = (0, 1, 2, 3, 4, 5{, 6});
  codIdiomas: array[TIdiomas] of string = ('es', 'en', 'de', 'it', 'fr', 'ne'{, 'jap'});
  strIdiomas: array[TIdiomas] of string = ('Español', 'English', 'Deustch', 'Italiano', 'Française', 'Nepali'{, 'Japan'});

  function buscarIdxIdioma(unCodigoStr:string): Integer;
  function buscarCodIdioma(unCodigoStr:string): TIdiomas;
  function buscarStrIdioma(unStrIdioma:string): TIdiomas;
  function getStrIdioma(unCodigoStr:string): string;

implementation
{$R *.dfm}

function buscarIdxIdioma(unCodigoStr:string): Integer;
var
  i: integer;
begin
  result := idxIdiomas[buscarCodIdioma(unCodigoStr)];
end;

function buscarCodIdioma(unCodigoStr:string):TIdiomas;
var
  i: integer;
begin
  result := es;
  i:= 0;
//  while (i <(sizeof(codIdiomas) div 4)) and (codIdiomas[TIdiomas(i)] <> unCodigoStr) do
  while (i <length(codIdiomas)) and (codIdiomas[TIdiomas(i)] <> unCodigoStr) do
    inc(i);
  if i <(sizeof(codIdiomas) div 4) then
    result := TIdiomas(i);
end;

function buscarStrIdioma(unStrIdioma:string):TIdiomas;
var
  i: integer;
begin
  result := es;
  i:= 0;
  while (i <length(strIdiomas)) and (StrIdiomas[TIdiomas(i)] <> unStrIdioma) do
    inc(i);
  if i <length(strIdiomas) then
    result := TIdiomas(i);
end;

function getStrIdioma(unCodigoStr:string): string;
begin
  result := strIdiomas[buscarCodIdioma(unCodigoStr)];
end;

end.
