unit fMain;

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
  uDMAppIcon,
  Olf.FMX.AboutDialog,
  FMX.Menus,
  uProjectASSCG;

type
  TfrmMain = class(TForm)
    MainMenu1: TMainMenu;
    OlfAboutDialog1: TOlfAboutDialog;
    mnuSystemMacOS: TMenuItem;
    mnuFichier: TMenuItem;
    mnuFichierOuvrir: TMenuItem;
    mnuFichierNouveau: TMenuItem;
    mnuFichierEnregistrer: TMenuItem;
    mnuFichierFermer: TMenuItem;
    mnuFichierQuitter: TMenuItem;
    mnuOutils: TMenuItem;
    mnuOutilsOptions: TMenuItem;
    mnuAide: TMenuItem;
    mnuAideAPropos: TMenuItem;
    procedure OlfAboutDialog1URLClick(const AURL: string);
    procedure FormCreate(Sender: TObject);
    procedure mnuFichierQuitterClick(Sender: TObject);
    procedure mnuAideAProposClick(Sender: TObject);
    procedure mnuFichierEnregistrerClick(Sender: TObject);
    procedure mnuFichierFermerClick(Sender: TObject);
    procedure mnuFichierNouveauClick(Sender: TObject);
    procedure mnuFichierOuvrirClick(Sender: TObject);
    procedure mnuOutilsOptionsClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FCurrentProject: TASSCGProject;
    procedure SetCurrentProject(const Value: TASSCGProject);
    { Déclarations privées }
  public
    { Déclarations publiques }
    property CurrentProject: TASSCGProject read FCurrentProject
      write SetCurrentProject;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  u_urlOpen,
  fOptions,
  Olf.FMX.AboutDialogForm;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Titre de la fenêtre principale
  caption := OlfAboutDialog1.Titre + ' v' + OlfAboutDialog1.VersionNumero;
{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ENDIF}
  // Menu de la fenêtre principale
{$IFDEF MACOS}
  mnuFichierQuitter.visible := false;
  mnuAide.visible := false;
  mnuAideAPropos.Parent := mnuSystemMacOS;
  mnuAideAPropos.Text := 'A propos de ' + OlfAboutDialog1.Titre;
  mnuOutils.visible := false;
  mnuOutilsOptions.Parent := mnuSystemMacOS;
  mnuOutilsOptions.Text := 'Réglages';
{$ELSE}
  mnuSystemMacOS.visible := false;
{$ENDIF}
  // Initialisation des données du programme
  FCurrentProject := nil;
  CurrentProject := nil;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CurrentProject.free;
end;

procedure TfrmMain.mnuAideAProposClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.mnuFichierEnregistrerClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMain.mnuFichierFermerClick(Sender: TObject);
begin
  // TODO : à compléter
end;

procedure TfrmMain.mnuFichierNouveauClick(Sender: TObject);
begin
  // TODO : à compléter
  CurrentProject := nil;
  // créer un nouveau projet
end;

procedure TfrmMain.mnuFichierOuvrirClick(Sender: TObject);
begin
  // TODO : à compléter
  CurrentProject := nil;
  // ouvrir un nouveau projet
end;

procedure TfrmMain.mnuOutilsOptionsClick(Sender: TObject);
var
  frm: TfrmOptions;
begin
  frm := TfrmOptions.create(self);
  try
    frm.showmodal;
  finally
    frm.free;
  end;
end;

procedure TfrmMain.mnuFichierQuitterClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.SetCurrentProject(const Value: TASSCGProject);
begin
  if (not assigned(Value)) and assigned(FCurrentProject) then
  begin
    if CurrentProject.HasChanged then
    begin
      // demander si on veut enregistrer
    end;
    FCurrentProject.free;
  end;
  FCurrentProject := Value;
  mnuFichierEnregistrer.Enabled := assigned(FCurrentProject);
  mnuFichierFermer.Enabled := assigned(FCurrentProject);
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
