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
  uProjectASSCGStores,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  FMX.Layouts,
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
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    sbStores: TVertScrollBox;
    tbStores: TToolBar;
    btnStoresSelectAll: TButton;
    btnStoresUnSelectAll: TButton;
    mnuOutilsLanguesDesProjets: TMenuItem;
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
    procedure onStoreChange(Sender: TObject);
    procedure btnStoresSelectAllClick(Sender: TObject);
    procedure btnStoresUnSelectAllClick(Sender: TObject);
    procedure mnuOutilsLanguesDesProjetsClick(Sender: TObject);
  private
    FCurrentProject: TASSCGProject;
    FDBStores: TASSCGDBStores;
    FCurrentDisplay: TLayout;
    procedure SetCurrentProject(const Value: TASSCGProject);
    procedure SetDBStores(const Value: TASSCGDBStores);
    procedure SetCurrentDisplay(const Value: TLayout);
    { Déclarations privées }
  protected
    procedure InitFormTitle(AProject: TASSCGProject = nil);
    procedure InitProjectMenusOptions;
    procedure InitDBStore(AForceDownload: boolean = false);
    procedure GoToHomeScreen;
    procedure GoToProjectScreen;
    procedure ShowStoreList;
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
  FMX.DialogService,
  u_urlOpen,
  fOptions,
  System.IOUtils,
  Olf.FMX.AboutDialogForm, fStoresLanguages;

procedure TfrmMain.btnExportClick(Sender: TObject);
begin
  // TODO : à compléter
  showmessage('à faire');
end;

procedure TfrmMain.btnStoresSelectAllClick(Sender: TObject);
var
  o: tcomponent;
begin
  for o in sbStores.content.children do
    if (o is TCheckBox) and not(o as TCheckBox).tagstring.isempty then
      (o as TCheckBox).ischecked := true;
end;

procedure TfrmMain.btnStoresUnSelectAllClick(Sender: TObject);
var
  o: tcomponent;
begin
  for o in sbStores.content.children do
    if (o is TCheckBox) and not(o as TCheckBox).tagstring.isempty then
      (o as TCheckBox).ischecked := false;
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
  for o in children do
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
var
  o: tcomponent;
  cb: TCheckBox;
begin
  if (DBStores.Count = 0) then
    raise exception.create
      ('No stores database. Please wait a minute or reload them from "Tools" options.');

  tcProject.ActiveTab := tiProjectStores;

  // Initialisation de l'onglet "stores"

  for o in sbStores.content.children do
    if (o is TCheckBox) then
    begin
      cb := o as TCheckBox;
      if (not cb.tagstring.isempty) then
        cb.ischecked := CurrentProject.hasStore(cb.tagstring);
    end;

  // Initialisation de l'onglet "languages"

  // TODO : à compléter

  // Initialisation de l'onglet "background"

  // TODO : à compléter

  // Initialisation de l'onglet "bitmaps"

  // TODO : à compléter

  CurrentDisplay := lProjectScreen;
end;

procedure TfrmMain.mnuAideAProposClick(Sender: TObject);
begin
  OlfAboutDialog1.Execute;
end;

procedure TfrmMain.mnuFichierEnregistrerClick(Sender: TObject);
var
  filename: string;
begin
  if not assigned(CurrentProject) then
    raise exception.create('No opened projet to save.');

  if CurrentProject.filename.isempty then
  begin
    // TODO : restaurer le précédent chemin utilisé
    SaveDialog1.InitialDir := tpath.GetDocumentsPath;
    SaveDialog1.filename := '';
    if SaveDialog1.Execute then
    begin
      // TODO : sauver le chemin utilisé pour le proposer la fois suivante
      filename := SaveDialog1.filename;
      if tpath.GetExtension(filename).ToLower <> '.asscg' then
        filename := tpath.GetFileNameWithoutExtension(filename) + '.asscg';

      CurrentProject.SaveToFile(filename);
    end;
  end
  else
    CurrentProject.SaveToFile;
end;

procedure TfrmMain.mnuFichierFermerClick(Sender: TObject);
begin
  CurrentProject := nil;

  GoToHomeScreen;
end;

procedure TfrmMain.mnuFichierNouveauClick(Sender: TObject);
begin
  CurrentProject := TASSCGProject.create;
  GoToProjectScreen;
end;

procedure TfrmMain.mnuFichierOuvrirClick(Sender: TObject);
var
  filename: string;
begin
  // TODO : restaurer le précédent chemin utilisé
  if string(OpenDialog1.filename).isempty then
    OpenDialog1.InitialDir := tpath.GetDocumentsPath
  else
    OpenDialog1.InitialDir := tpath.GetDirectoryName(OpenDialog1.filename);

  if OpenDialog1.Execute then
  begin
    // TODO : sauvegarder le chemin utilisé pour plus tard
    filename := OpenDialog1.filename;
    if not tfile.Exists(filename) then
      raise exception.create('File not found.');
    if not filename.ToLower.EndsWith('.asscg') then
      raise exception.create('Wrong file extension. Won''t open it.');
    CurrentProject := TASSCGProject.create(filename);
    GoToProjectScreen;
  end;
end;

procedure TfrmMain.mnuOutilsLanguesDesProjetsClick(Sender: TObject);
var
  frm: TfrmStoresLanguages;
begin
  frm := TfrmStoresLanguages.create(self);
  try
    frm.showmodal;
  finally
    frm.free;
  end;
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

procedure TfrmMain.onStoreChange(Sender: TObject);
var
  id: string;
begin
  if (Sender is TCheckBox) and not(Sender as TCheckBox).tagstring.isempty then
  begin
    id := (Sender as TCheckBox).tagstring;
    if (Sender as TCheckBox).ischecked then
    begin
      if not CurrentProject.hasStore(id) then
        CurrentProject.stores.Add(id);
    end
    else if CurrentProject.hasStore(id) then
      CurrentProject.stores.Remove(id);
  end;
end;

procedure TfrmMain.SetCurrentDisplay(const Value: TLayout);
begin
  if assigned(FCurrentDisplay) then
    FCurrentDisplay.visible := false;

  FCurrentDisplay := Value;

  if assigned(FCurrentDisplay) then
    FCurrentDisplay.visible := true;

  InitFormTitle;
end;

procedure TfrmMain.SetCurrentProject(const Value: TASSCGProject);
begin
  if assigned(FCurrentProject) and (FCurrentProject <> Value) then
  begin
    if FCurrentProject.HasChanged then
      tdialogservice.MessageDialog
        ('Voulez-vous enregistrer ce projet avant de le fermer ?',
        tmsgdlgtype.mtConfirmation, [tmsgdlgbtn.mbYes, tmsgdlgbtn.mbNo],
        tmsgdlgbtn.mbYes, 0,
        procedure(const AModalResult: TModalResult)
        begin
          if AModalResult = mrYes then
            mnuFichierEnregistrerClick(nil);
        end);
    FCurrentProject.free;
  end;

  FCurrentProject := Value;
  InitProjectMenusOptions;
end;

procedure TfrmMain.SetDBStores(const Value: TASSCGDBStores);
begin
  FDBStores := Value;
end;

procedure TfrmMain.ShowStoreList;
var
  Store: TASSCGDBStore;
  i: integer;
  o: TFMXObject;
begin
  for i := sbStores.content.ChildrenCount - 1 downto 0 do
  begin
    o := sbStores.content.children[i];
    if (o is TCheckBox) and ((o as TCheckBox).tag = 1) then
      o.free;
  end;

  if DBStores.Count > 0 then
    for Store in DBStores do
      with TCheckBox.create(self) do
      begin
        Parent := sbStores;
        Align := talignlayout.Top;
        Margins.Left := 5;
        Margins.Top := 5;
        Margins.Right := 5;
        Margins.Bottom := 5;
        Text := Store.Name;
        OnChange := onStoreChange;
        tagstring := Store.id;
      end;
end;

procedure TfrmMain.InitDBStore(AForceDownload: boolean);
var
  Folder, filename: string;
begin
  DBStores.free;
  DBStores := TASSCGDBStores.create;

{$IFDEF DEBUG}
  Folder := tpath.combine(tpath.GetDocumentsPath, 'OlfSoftware-DEBUG',
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
  begin
    DBStores.LoadFromFile(filename);
    ShowStoreList;
  end
  else
    DBStores.LoadFromURL(CASSCGDBURL,
      procedure
      begin
        DBStores.SaveToFile(filename);
        ShowStoreList;
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
tdialogservice.PreferredMode := tdialogservice.TPreferredMode.Sync;

end.
