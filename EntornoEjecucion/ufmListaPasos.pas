unit ufmListaPasos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JvOutlookBar, ExtCtrls, JvExExtCtrls, JvComponent, JvItemsPanel,
  JvExControls, JvLookOut, StdCtrls;

type
  TFmListaPasos = class(TForm)
    JvLookOut1: TJvLookOut;
    JvItemsPanel1: TJvItemsPanel;
    JvOutlookBar1: TJvOutlookBar;
    LookOutPage1: TJvLookOutPage;
    LookOutPage2: TJvLookOutPage;
    LookOutButton1: TJvLookOutButton;
    JvExpress1: TJvExpress;
    ExpressButton1: TJvExpressButton;
    ExpressButton2: TJvExpressButton;
    LookOutPage3: TJvLookOutPage;
    Label1: TLabel;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FmListaPasos: TFmListaPasos;

implementation

{$R *.dfm}

end.
