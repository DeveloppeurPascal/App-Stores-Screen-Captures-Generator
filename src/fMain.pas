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
    procedure InitFormTitle(AProject: TASSCGProject = nil);
    procedure InitProjectMenusOptions;
    { Déclarations privées }
  protected
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
  System.Messaging,
  u_urlOpen,
  fOptions,
  Olf.FMX.AboutDialogForm;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitFormTitle;

  // Menu de la fenêtre principale
{$IFDEF MACOS}
  mnuFichierQuitter.visible := false;
  mnuAide.visible := false;
  mnuAideAPropos.Parent := mnuSystemMacOS;
  mnuAideAPropos.Text := 'A propos de ' + OlfAboutDialog1.Titre;
  mnuOutils.visible := false;
  mnuOutilsOptions.Parent := mnuSystemMacOS;
  mnuOutilsOptions.Text := 'Réglages';

  mnuFichierNouveau.ShortCut := scCommand + ord('N');
  mnuFichierOuvrir.ShortCut := scCommand + ord('O');
  mnuFichierEnregistrer.ShortCut := scCommand + ord('S');
  mnuFichierFermer.ShortCut := 0;
  // scCommand + ord('W'); // TODO : déclenche la fermeture du programme
  mnuFichierQuitter.ShortCut := scCommand + ord('Q');
{$ELSE}
  mnuSystemMacOS.visible := false;

  mnuFichierNouveau.ShortCut := scCtrl + ord('N');
  mnuFichierOuvrir.ShortCut := scCtrl + ord('O');
  mnuFichierEnregistrer.ShortCut := scCtrl + ord('S');
  mnuFichierFermer.ShortCut := scCtrl + ord('W');
  mnuFichierQuitter.ShortCut := scalt + vkf4;
{$ENDIF}
  // Initialisation des données du projet
  FCurrentProject := nil;
  InitProjectMenusOptions;
  TMessageManager.DefaultManager.SubscribeToMessage
    (TASSCGProjectHasChangedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      msg: TASSCGProjectHasChangedMessage;
    begin
      if M is TASSCGProjectHasChangedMessage then
      begin
        msg := M as TASSCGProjectHasChangedMessage;
        InitFormTitle(msg.Project);
      end;
    end);
  TMessageManager.DefaultManager.SubscribeToMessage
    (TASSCGProjectNameHasChangedMessage,
    procedure(const Sender: TObject; const M: TMessage)
    var
      msg: TASSCGProjectNameHasChangedMessage;
    begin
      if M is TASSCGProjectNameHasChangedMessage then
      begin
        msg := M as TASSCGProjectNameHasChangedMessage;
        InitFormTitle(msg.Project);
      end;
    end);
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
  CurrentProject := nil;

  InitFormTitle;
end;

procedure TfrmMain.mnuFichierNouveauClick(Sender: TObject);
begin
  CurrentProject := TASSCGProject.create;

  // TODO : à compléter
end;

procedure TfrmMain.mnuFichierOuvrirClick(Sender: TObject);
var
  filename: string;
begin
  // choisir un fichier existant
  // associer le fichier existant au projet
  CurrentProject := TASSCGProject.create(filename);
  // TODO : à compléter
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
  if assigned(FCurrentProject) and (FCurrentProject <> Value) then
  begin
    if FCurrentProject.HasChanged then
    begin
      // demander si on veut enregistrer
    end;
    FCurrentProject.free;
  end;

  FCurrentProject := Value;
  InitProjectMenusOptions;
end;

procedure TfrmMain.InitFormTitle(AProject: TASSCGProject);
var
  prj: TASSCGProject;
begin
  if assigned(AProject) then
    prj := AProject
  else
    prj := CurrentProject;

  if assigned(prj) then
    if prj.HasChanged then
      caption := prj.name + '* - '
    else
      caption := prj.name + ' - '
  else
    caption := '';

  caption := caption + OlfAboutDialog1.Titre + ' v' +
    OlfAboutDialog1.VersionNumero;

{$IFDEF DEBUG}
  caption := '[DEBUG] ' + caption;
{$ENDIF}
end;

procedure TfrmMain.InitProjectMenusOptions;
begin
  mnuFichierEnregistrer.Enabled := assigned(FCurrentProject);
  mnuFichierFermer.Enabled := assigned(FCurrentProject);
end;

initialization

{$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := true;
{$ENDIF}

end.
