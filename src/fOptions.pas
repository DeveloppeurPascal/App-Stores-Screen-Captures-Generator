(* C2PP
  ***************************************************************************

  App Stores Screen Captures Generator

  Copyright 2024-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://appstoresscreencapturesgenerator.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/App-Stores-Screen-Captures-Generator

  ***************************************************************************
  File last update : 2025-10-16T10:42:30.918+02:00
  Signature : d1bc1bb4490e5fa0486eada011d9863ce5c938ee
  ***************************************************************************
*)

unit fOptions;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.ListBox;

type
  TfrmOptions = class(TForm)
    lFooter: TLayout;
    btnOk: TButton;
    btnCancel: TButton;
    VertScrollBox1: TVertScrollBox;
    gpAppTheme: TGroupBox;
    rbLightStyle: TRadioButton;
    rbAutomaticStyle: TRadioButton;
    rbDarkStyle: TRadioButton;
    lblLanguage: TLabel;
    cbLanguage: TComboBox;
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

uses
  uConfig,
  Olf.RTL.Params;

procedure TfrmOptions.btnOkClick(Sender: TObject);
begin
  if rbLightStyle.IsChecked then
    tconfig.AppStyle := TAppTheme.light
  else if rbDarkStyle.IsChecked then
    tconfig.AppStyle := TAppTheme.dark
  else if rbAutomaticStyle.IsChecked then
    tconfig.AppStyle := TAppTheme.auto;

  case cbLanguage.ItemIndex of
    // TODO : à rendre indépendant des index de la liste
    0:
      tconfig.AppLangue := TAppLangue.Anglais;
    1:
      tconfig.AppLangue := TAppLangue.Francais;
    2:
      tconfig.AppLangue := TAppLangue.Inconnu;
  end;

  tparams.save;
end;

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  case tconfig.AppStyle of
    TAppTheme.auto:
      rbAutomaticStyle.IsChecked := true;
    TAppTheme.light:
      rbLightStyle.IsChecked := true;
    TAppTheme.dark:
      rbDarkStyle.IsChecked := true;
  end;

  case tconfig.AppLangue of // TODO : à rendre indépendant des index de la liste
    TAppLangue.Anglais:
      cbLanguage.ItemIndex := 0;
    TAppLangue.Francais:
      cbLanguage.ItemIndex := 1;
    TAppLangue.Inconnu:
      cbLanguage.ItemIndex := 2;
  end;
end;

end.
