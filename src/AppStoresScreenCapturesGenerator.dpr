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
  Signature : 26b3dac672ebef229de07329b72991d187eaa632
  ***************************************************************************
*)

program AppStoresScreenCapturesGenerator;

uses
  System.StartUpCopy,
  FMX.Forms,
  fMain in 'fMain.pas' {frmMain},
  uDMAppIcon in 'uDMAppIcon.pas' {dmAppIcon: TDataModule},
  u_urlOpen in '..\lib-externes\librairies\u_urlOpen.pas',
  Olf.FMX.AboutDialog in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialog.pas',
  Olf.FMX.AboutDialogForm in '..\lib-externes\AboutDialog-Delphi-Component\sources\Olf.FMX.AboutDialogForm.pas' {OlfAboutDialogForm},
  fOptions in 'fOptions.pas' {frmOptions},
  Olf.RTL.Params in '..\lib-externes\librairies\Olf.RTL.Params.pas',
  uConfig in 'uConfig.pas',
  uProjectASSCG in 'uProjectASSCG.pas',
  Olf.FMX.Streams in '..\lib-externes\librairies\Olf.FMX.Streams.pas',
  Olf.RTL.Language in '..\lib-externes\librairies\Olf.RTL.Language.pas',
  Olf.RTL.Streams in '..\lib-externes\librairies\Olf.RTL.Streams.pas',
  Olf.RTL.SystemAppearance in '..\lib-externes\librairies\Olf.RTL.SystemAppearance.pas',
  uProjectASSCGStores in '..\lib-externes\ASSCG-Data-Admin\src\uProjectASSCGStores.pas',
  u_download in '..\lib-externes\librairies\u_download.pas',
  uDMStoresLanguages in 'uDMStoresLanguages.pas' {dmStoresLanguages: TDataModule},
  fStoresLanguages in 'fStoresLanguages.pas' {frmStoresLanguages},
  cProjectImage in 'cProjectImage.pas' {cadProjectImage: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmAppIcon, dmAppIcon);
  Application.Run;
end.
