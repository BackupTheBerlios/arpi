unit ufrmzoomimg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvEdit, JvValidateEdit, JvExControls,
  JvComponent, JvxSlider;

type
  TfrmZoomImg = class (TForm)
    BtnOK: TButton;
    VEditZoom: TJvValidateEdit;
    ZoomSlide: TJvxSlider;
    procedure BtnOKClick(Sender: TObject);
    procedure ZoomSlideChange(Sender: TObject);
  end;
  
var
  frmZoomImg: TfrmZoomImg;

implementation

{$R *.dfm}

{
********************************* TfrmZoomImg **********************************
}
procedure TfrmZoomImg.BtnOKClick(Sender: TObject);
begin
  self.close;
end;

procedure TfrmZoomImg.ZoomSlideChange(Sender: TObject);
begin
  VEditZoom.Value:= ZoomSlide.Value;
end;

end.
