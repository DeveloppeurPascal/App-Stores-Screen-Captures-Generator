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
  uProjectASSCG in 'uProjectASSCG.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmAppIcon, dmAppIcon);
  Application.Run;
end.
