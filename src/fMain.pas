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
  uProjectASSCG,
  uProjectASSCGStores, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts,
  FMX.TabControl;

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
    lBoutonsMenu: TLayout;
    btnNouveau: TButton;
    btnOuvrir: TButton;
    lHomeScreen: TLayout;
    lProjectScreen: TLayout;
    tcProject: TTabControl;
    tiProjectStores: TTabItem;
    tiProjectImages: TTabItem;
    tbFooter: TToolBar;
    btnSave: TButton;
    btnClose: TButton;
    btnExport: TButton;
    tiProjectLanguages: TTabItem;
    tiBackground: TTabItem;
    mnuOutilsReloadDBStores: TMenuItem;
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
    procedure btnExportClick(Sender: TObject);
    procedure mnuOutilsReloadDBStoresClick(Sender: TObject);
  private
    FCurrentProject: TASSCGProject;
    FDBStores: TASSCGDBStores;
    FCurrentDisplay: TLayout;
    procedure SetCurrentProject(const Value: TASSCGProject);
    procedure InitFormTitle(AProject: TASSCGProject = nil);
    procedure InitProjectMenusOptions;
    procedure SetDBStores(const Value: TASSCGDBStores);
    procedure InitDBStore(AForceDownload: boolean = false);
    procedure SetCurrentDisplay(const Value: TLayout);
    { Déclarations privées }
  protected
    procedure GoToHomeScreen;
    procedure GoToProjectScreen;
  public
    { Déclarations publiques }
    property CurrentProject: TASSCGProject read FCurrentProject
      write SetCurrentProject;
    property DBStores: TASSCGDBStores read FDBStores write SetDBStores;
    property CurrentDisplay: TLayout read FCurrentDisplay
      write SetCurrentDisplay;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  System.Messaging,
  u_urlOpen,
  fOptions,
  System.IOUtils,
  Olf.FMX.AboutDialogForm;

procedure TfrmMain.btnExportClick(Sender: TObject);
begin
  // TODO : à compléter
  showmessage('à faire');
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
  o: TFMXObject;
begin
  InitFormTitle;
  InitDBStore;

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

  FCurrentDisplay := nil;
  // Masque les TLayout servant d'écrans
  for o in Children do
    if (o is TLayout) and
      (string((o as TLayout).Name).ToLower.EndsWith('screen')) then
      (o as TLayout).visible := false;
  // Bascule sur l'écran d'accueil
  GoToHomeScreen;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CurrentProject.free;
  DBStores.free;
end;

procedure TfrmMain.GoToHomeScreen;
begin
  CurrentDisplay := lHomeScreen;
end;

procedure TfrmMain.GoToProjectScreen;
begin
  if (DBStores.Count = 0) then
    raise exception.create
      ('No stores database. Please wait a minute or reload them from "Tools" options.');

  tcProject.ActiveTab := tiProjectStores;
  // TODO : à compléter
  CurrentDisplay := lProjectScreen;
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

procedure TfrmMain.mnuOutilsReloadDBStoresClick(Sender: TObject);
begin
  InitDBStore(true);
end;

procedure TfrmMain.mnuFichierQuitterClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain.OlfAboutDialog1URLClick(const AURL: string);
begin
  url_Open_In_Browser(AURL);
end;

procedure TfrmMain.SetCurrentDisplay(const Value: TLayout);
begin
  if assigned(FCurrentDisplay) then
    FCurrentDisplay.visible := false;

  FCurrentDisplay := Value;

  if assigned(FCurrentDisplay) then
    FCurrentDisplay.visible := true;
end;

procedure TfrmMain.SetCurrentProject(const Value: TASSCGProject);
begin
  if assigned(FCurrentProject) and (FCurrentProject <> Value) then
  begin
    if FCurrentProject.HasChanged then
    begin
      // TODO : demander si on veut enregistrer
    end;
    FCurrentProject.free;
  end;

  FCurrentProject := Value;
  InitProjectMenusOptions;
end;

procedure TfrmMain.SetDBStores(const Value: TASSCGDBStores);
begin
  FDBStores := Value;
end;

procedure TfrmMain.InitDBStore(AForceDownload: boolean);
var
  Folder, filename: string;
begin
  DBStores.free;
  DBStores := TASSCGDBStores.create;

{$IFDEF DEBUG}
  Folder := tpath.combine(tpath.getdocumentspath, 'OlfSoftware-DEBUG',
    'ASSCG-DEBUG');
{$ELSE}
  Folder := tpath.combine(tpath.GetHomePath, 'OlfSoftware', 'ASSCG');
{$ENDIF}
  if not TDirectory.Exists(Folder) then
    TDirectory.CreateDirectory(Folder);

{$IFDEF DEBUG}
  filename := tpath.combine(Folder, 'asscg-debug.asscgstores');
{$ELSE}
  filename := tpath.combine(Folder, 'asscg.asscgstores');
{$ENDIF}
  if tfile.Exists(filename) and (not AForceDownload) then
    DBStores.LoadFromFile(filename)
  else
    DBStores.LoadFromURL(CASSCGDBURL,
      procedure
      begin
        DBStores.SaveToFile(filename);
        showmessage('La base des magasins d''application a été mise à jour.');
      end,
      procedure
      begin
        showmessage('Erreur de téléchargement de la base des magasins.');
      end);
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
      caption := prj.Name + '* - '
    else
      caption := prj.Name + ' - '
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
