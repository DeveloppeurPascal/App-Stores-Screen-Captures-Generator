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
  FMX.TabControl,
  FMX.ListBox,
  FMX.Edit,
  FMX.Objects,
  FMX.Colors,
  FMX.Effects;

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
    OpenDialogProject: TOpenDialog;
    SaveDialogProject: TSaveDialog;
    sbStores: TVertScrollBox;
    tbStores: TToolBar;
    btnStoresSelectAll: TButton;
    btnStoresUnSelectAll: TButton;
    mnuOutilsLanguesDesProjets: TMenuItem;
    sbLanguages: TVertScrollBox;
    tbLanguages: TToolBar;
    btnLanguagesSelectAll: TButton;
    btnLanguagesUnSelectAll: TButton;
    sbBackground: TVertScrollBox;
    lblBackgroundKind: TLabel;
    cbBackgroundKind: TComboBox;
    lBackgroundBitmap: TLayout;
    lBackgroundColor: TLayout;
    lblBackgroundBitmap: TLabel;
    imgBackgroundBitmap: TImageControl;
    gplBackgroundBitmap: TGridPanelLayout;
    btnBackgroundBitmapLoad: TButton;
    btnBackgroundBitmapRemove: TButton;
    lblBackgroundColor: TLabel;
    lBackgroundColorChoice: TLayout;
    edtBackgroundColor: TEdit;
    cqBackgroundColor: TColorQuad;
    cpBackgroundColor: TColorPicker;
    cbBackgroundColor: TColorBox;
    OpenDialogImage: TOpenDialog;
    sbImages: TVertScrollBox;
    tbImages: TToolBar;
    btnAddImage: TButton;
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
    procedure btnStoresSelectAllClick(Sender: TObject);
    procedure btnStoresUnSelectAllClick(Sender: TObject);
    procedure mnuOutilsLanguesDesProjetsClick(Sender: TObject);
    procedure btnLanguagesSelectAllClick(Sender: TObject);
    procedure btnLanguagesUnSelectAllClick(Sender: TObject);
    procedure cbBackgroundKindChange(Sender: TObject);
    procedure btnBackgroundBitmapLoadClick(Sender: TObject);
    procedure btnBackgroundBitmapRemoveClick(Sender: TObject);
    procedure edtBackgroundColorChange(Sender: TObject);
    procedure cqBackgroundColorChange(Sender: TObject);
    procedure btnAddImageClick(Sender: TObject);
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
    procedure ShowLanguageList;
    procedure onStoreChange(Sender: TObject);
    procedure onLanguageChange(Sender: TObject);
    function GetStoreFromDBStores(Const AID: string): TASSCGDBStore;
    procedure ExportBitmap(Const Bitmap: TASSCGBitmap;
      Const Store: TASSCGDBStore; Const Background: TASSCGBackground;
      Const Effect: TASSCGEffect; Const ToFolder: string);
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
  System.Generics.Collections,
  FMX.DialogService,
  u_urlOpen,
  fOptions,
  System.IOUtils,
  Olf.FMX.AboutDialogForm,
  fStoresLanguages,
  uDMStoresLanguages,
  cProjectImage;

procedure TfrmMain.btnAddImageClick(Sender: TObject);
var
  filename: string;
  Bitmap: TASSCGBitmap;
begin
  // TODO : restaurer le précédent chemin utilisé
  if string(OpenDialogImage.filename).isempty then
{$IFDEF DEBUG}
    OpenDialogImage.InitialDir := tpath.GetPicturesPath
{$ELSE}
    OpenDialogImage.InitialDir := tpath.GetDocumentsPath
{$ENDIF}
  else
    OpenDialogImage.InitialDir := tpath.GetDirectoryName
      (OpenDialogImage.filename);

  if OpenDialogImage.Execute then
  begin
    // TODO : sauvegarder le chemin utilisé pour plus tard
    filename := OpenDialogImage.filename;
    if not tfile.Exists(filename) then
      raise exception.Create('File not found.');
    if (not filename.tolower.EndsWith('.jpg')) and
      (not filename.tolower.EndsWith('.png')) then
      raise exception.Create('Wrong file extension. Won''t open it.');
    if not tfile.Exists(filename) then
      raise exception.Create('This image file doesn''t exist !');

    Bitmap := TASSCGBitmap.Create(CurrentProject);
    Bitmap.BitmapLoadFromFile(filename);
    CurrentProject.Bitmaps.add(Bitmap);
    TcadProjectImage.GetNew(self, sbImages, Bitmap, DBStores);
  end;
end;

procedure TfrmMain.btnBackgroundBitmapLoadClick(Sender: TObject);
var
  filename: string;
begin
  // TODO : restaurer le précédent chemin utilisé
  if string(OpenDialogImage.filename).isempty then
{$IFDEF DEBUG}
    OpenDialogImage.InitialDir := tpath.GetPicturesPath
{$ELSE}
    OpenDialogImage.InitialDir := tpath.GetDocumentsPath
{$ENDIF}
  else
    OpenDialogImage.InitialDir := tpath.GetDirectoryName
      (OpenDialogImage.filename);

  if OpenDialogImage.Execute then
  begin
    // TODO : sauvegarder le chemin utilisé pour plus tard
    filename := OpenDialogImage.filename;
    if not tfile.Exists(filename) then
      raise exception.Create('File not found.');
    if (not filename.tolower.EndsWith('.jpg')) and
      (not filename.tolower.EndsWith('.png')) then
      raise exception.Create('Wrong file extension. Won''t open it.');
    if not tfile.Exists(filename) then
      raise exception.Create('This image file doesn''t exist !');

    CurrentProject.Background.BitmapLoadFromFile(filename);
    imgBackgroundBitmap.Bitmap.Assign(CurrentProject.Background.Bitmap);
  end;
end;

procedure TfrmMain.btnBackgroundBitmapRemoveClick(Sender: TObject);
begin
  CurrentProject.Background.BitmapClear;
  imgBackgroundBitmap.Bitmap.setsize(0, 0);
end;

procedure TfrmMain.btnExportClick(Sender: TObject);
var
  RootFolder: string;
  Bitmap: TASSCGBitmap;
  StoreID: string;
  Store: TASSCGDBStore;
  StoreList: TASSCGIDStores;
  Language: string;
  LanguageList: TASSCGLanguages;
begin
  if not assigned(CurrentProject) then
    raise exception.Create('No project to export !');

  RootFolder := tpath.combine(tpath.GetDirectoryName(CurrentProject.filename),
    CurrentProject.filename + 'img');

  // TODO : utiliser des threads si possible
  for Bitmap in CurrentProject.Bitmaps do
    if assigned(Bitmap.Bitmap) and (Bitmap.Bitmap.width > 0) and
      (Bitmap.Bitmap.height > 0) then
    begin
      if Bitmap.ForAllStores then
        StoreList := CurrentProject.Stores
      else
        StoreList := Bitmap.ForStores;
      if Bitmap.ForAllLanguages then
        LanguageList := CurrentProject.Languages
      else
        LanguageList := Bitmap.ForLanguages;
      for StoreID in StoreList do
      begin
        Store := GetStoreFromDBStores(StoreID);
        if assigned(Store) then
          for Language in LanguageList do
            ExportBitmap(Bitmap, Store, CurrentProject.Background,
              CurrentProject.Effect, tpath.combine(RootFolder, Store.FolderName,
              Language));
      end;
    end;

  showmessage('Export terminé.');
end;

procedure TfrmMain.btnLanguagesSelectAllClick(Sender: TObject);
var
  o: tcomponent;
begin
  for o in sbLanguages.content.children do
    if (o is TCheckBox) and not(o as TCheckBox).tagstring.isempty then
      (o as TCheckBox).ischecked := true;
end;

procedure TfrmMain.btnLanguagesUnSelectAllClick(Sender: TObject);
var
  o: tcomponent;
begin
  for o in sbLanguages.content.children do
    if (o is TCheckBox) and not(o as TCheckBox).tagstring.isempty then
      (o as TCheckBox).ischecked := false;
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

procedure TfrmMain.cbBackgroundKindChange(Sender: TObject);
begin
  CurrentProject.Background.Kind :=
    TASSCGFillKind(cbBackgroundKind.Selected.Tag);
  lBackgroundColor.visible := CurrentProject.Background.Kind =
    TASSCGFillKind.solid;
  lBackgroundBitmap.visible := not lBackgroundColor.visible;
end;

procedure TfrmMain.cqBackgroundColorChange(Sender: TObject);
begin
  edtBackgroundColor.Tag := -1;
  try
    edtBackgroundColor.text := InttoHex(cbBackgroundColor.color);
  finally
    edtBackgroundColor.Tag := 0;
  end;
end;

procedure TfrmMain.edtBackgroundColorChange(Sender: TObject);
var
  color: talphacolor;
  i: integer;
  txt: string;
  v: byte;
begin
  txt := edtBackgroundColor.text.tolower;
  while (txt.length < 6) do
    txt := '0' + txt;
  while (txt.length < 8) do
    txt := 'f' + txt;
  color := $FF;
  for i := 2 to txt.length - 1 do
  begin
    case txt.Chars[i] of
      '0' .. '9':
        v := ord(txt.Chars[i]) - ord('0');
      'a' .. 'f':
        v := 10 + ord(txt.Chars[i]) - ord('a');
    else
      raise exception.Create
        ('Please give an hexadecimal value in alpha, red, green, blue format.');
    end;
    color := color * 16 + v;
  end;

  CurrentProject.Background.color := color;

  if not(edtBackgroundColor.Tag = -1) then
    // -1 => modification faite depuis cbBackgroundColor
    cbBackgroundColor.color := color;
end;

procedure TfrmMain.ExportBitmap(const Bitmap: TASSCGBitmap;
  const Store: TASSCGDBStore; const Background: TASSCGBackground;
  Const Effect: TASSCGEffect; const ToFolder: string);
var
  SaveFolder: string;
  rBackground, rCapture: trectangle;
  effGlow: TGlowEffect;
  effShawdow: TShadowEffect;
  orig_width, orig_height: integer;
  Device: TASSCGDBDevice;
  ImgDestSize: TASSCGDBImageSize;
  ImgDestSelected: TList<TASSCGDBImageSize>;
  i: integer;
  Distance, Distance_min: integer;
  IsOrigEnPaysage, IsOrigEnPortrait: boolean;
  bmp: TBitmap;
begin
  if not assigned(Bitmap) then
    raise exception.Create('I need a bitmap !');
  if not assigned(Store) then
    raise exception.Create('I need a store !');
  if not assigned(Background) then
    raise exception.Create('I need a background !');

  if ToFolder.isempty then
    raise exception.Create('No folder to store the image !');

  // récupérer la taille de l'image d'origine
  orig_width := Bitmap.Bitmap.width;
  orig_height := Bitmap.Bitmap.height;
  IsOrigEnPaysage := orig_width > orig_height;
  IsOrigEnPortrait := orig_width < orig_height;

  // parcourrir la liste des devices du magasin
  for Device in Store.devices do
  begin
    SaveFolder := tpath.combine(ToFolder, Device.FolderName);

    if not tdirectory.Exists(SaveFolder) then
      tdirectory.CreateDirectory(SaveFolder);

    // recherche de la taille d'image finale la plus proche de la notre

    ImgDestSelected := TList<TASSCGDBImageSize>.Create;
    try
      // => récupération des images dans le bon sens
      // (paysage, portrait ou les deux si capture carrée)
      for ImgDestSize in Device.ImageSizes do
        if ((ImgDestSize.width > ImgDestSize.height) and IsOrigEnPaysage) or
          ((ImgDestSize.width < ImgDestSize.height) and IsOrigEnPortrait) or
          (IsOrigEnPaysage = IsOrigEnPortrait) then
          ImgDestSelected.add(ImgDestSize);

      // => taille d'image la plus proche pour génération ensuite
      ImgDestSize := nil;
      Distance_min := -maxint;
      for i := 0 to ImgDestSelected.count - 1 do
      begin
        Distance := ImgDestSelected[i].width * ImgDestSelected[i].height -
          orig_width * orig_height;

        if (Distance = 0) or ((Distance > 0) and (Distance < abs(Distance_min)))
          or ((Distance < 0) and (Distance > Distance_min)) then
        begin
          ImgDestSize := ImgDestSelected[i];
          Distance_min := Distance;
        end;
      end;

      if not assigned(ImgDestSize) then
        if (ImgDestSelected.count > 0) then
          ImgDestSize := ImgDestSelected[0]
        else if (Device.ImageSizes.count > 0) then
          ImgDestSize := Device.ImageSizes[0];
    finally
      ImgDestSelected.free;
    end;

    if assigned(ImgDestSize) then
    begin

      // assemblage des composants
      rBackground := trectangle.Create(self);
      try
        rBackground.parent := self;
        rBackground.stroke.Kind := tbrushkind.none;
        rBackground.width := ImgDestSize.width;
        rBackground.height := ImgDestSize.height;
        case Background.Kind of
          TASSCGFillKind.solid:
            begin
              rBackground.fill.Kind := tbrushkind.solid;
              rBackground.fill.color := Background.color;
            end;
          TASSCGFillKind.BitmapTiled:
            begin
              rBackground.fill.Kind := tbrushkind.Bitmap;
              rBackground.fill.Bitmap.WrapMode := twrapmode.Tile;
              rBackground.fill.Bitmap.Bitmap.Assign(Background.Bitmap);
            end;
          TASSCGFillKind.BitmapStretched:
            begin
              rBackground.fill.Kind := tbrushkind.Bitmap;
              rBackground.fill.Bitmap.WrapMode := twrapmode.TileStretch;
              rBackground.fill.Bitmap.Bitmap.Assign(Background.Bitmap);
            end;
          TASSCGFillKind.BitmapCroped:
            begin
              // TODO : manage the "croped" value for background
              rBackground.fill.Kind := tbrushkind.Bitmap;
              rBackground.fill.Bitmap.WrapMode := twrapmode.TileOriginal;
              rBackground.fill.Bitmap.Bitmap.Assign(Background.Bitmap);
            end;
        else
          raise exception.Create('Unknow background kind.');
        end;

        rCapture := trectangle.Create(rBackground);
        rCapture.parent := rBackground;
        rCapture.stroke.Kind := tbrushkind.none;
        i := 0;
        repeat
          rCapture.width := orig_width - i;
          rCapture.height := (orig_height * rCapture.width) / orig_width;
          i := i + 20;
        until (rCapture.width < rBackground.width) and
          (rCapture.height < rBackground.height);
        rCapture.position.x := (rBackground.width - rCapture.width) / 2;
        rCapture.position.y := (rBackground.height - rCapture.height) / 2;
        rCapture.fill.Kind := tbrushkind.Bitmap;
        rCapture.fill.Bitmap.WrapMode := twrapmode.TileStretch;
        rCapture.fill.Bitmap.Bitmap.Assign(Bitmap.Bitmap);

        case Effect of
          TASSCGEffect.none:
            ;
          TASSCGEffect.Glow:
            begin
              effGlow := TGlowEffect.Create(rBackground);
              effGlow.parent := rCapture;
              // TODO : changer les propriétés de l'effet selon les paramètres sur le projet
            end;
          TASSCGEffect.shadow:
            begin
              effShawdow := TShadowEffect.Create(rBackground);
              effShawdow.parent := rCapture;
              // TODO : changer les propriétés de l'effet selon les paramètres sur le projet
            end;
        else
          raise exception.Create('Unknow effect type.');
        end;

        bmp := rBackground.makescreenshot;
        try
          case Device.ImageType of
            TASSCGDBImageType.JPG:
              bmp.SaveToFile(tpath.combine(SaveFolder,
                Bitmap.filename + '.jpg'));
            TASSCGDBImageType.png:
              bmp.SaveToFile(tpath.combine(SaveFolder,
                Bitmap.filename + '.png'));
          else
            raise exception.Create('Unknow file format for this device.');
          end;
        finally
          bmp.free;
        end;
      finally
        rBackground.free;
      end;
    end;
  end;
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
  mnuAideAPropos.parent := mnuSystemMacOS;
  mnuAideAPropos.text := 'A propos de ' + OlfAboutDialog1.Titre;
  mnuOutilsOptions.parent := mnuSystemMacOS;
  mnuOutilsOptions.text := 'Réglages';

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
      (string((o as TLayout).Name).tolower.EndsWith('screen')) then
      (o as TLayout).visible := false;

  // Bascule sur l'écran d'accueil
  GoToHomeScreen;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  CurrentProject.free;
  DBStores.free;
end;

function TfrmMain.GetStoreFromDBStores(Const AID: string): TASSCGDBStore;
var
  Trouve: boolean;
begin
  Trouve := false;
  for result in DBStores do
    if (result.Id = AID) then
    begin
      Trouve := true;
      break;
    end;
  if not Trouve then
    result := nil;
end;

procedure TfrmMain.GoToHomeScreen;
begin
  CurrentDisplay := lHomeScreen;
end;

procedure TfrmMain.GoToProjectScreen;
var
  item: TListBoxItem;
  fk: TASSCGFillKind;
  Bitmap: TASSCGBitmap;
  i: integer;
begin
  if (DBStores.count = 0) then
    raise exception.Create
      ('No stores database. Please wait a minute or reload them from "Tools" options.');

  tcProject.ActiveTab := tiProjectStores;

  // Initialisation de l'onglet "stores"

  ShowStoreList;

  // Initialisation de l'onglet "languages"

  ShowLanguageList;

  // Initialisation de l'onglet "background"

  cbBackgroundKind.Clear;
  for fk := low(TASSCGFillKind) to high(TASSCGFillKind) do
  begin
    item := TListBoxItem.Create(self);
    item.text := fk.ToString;
    item.Tag := fk.Value;
    cbBackgroundKind.AddObject(item);
    if CurrentProject.Background.Kind = fk then
      cbBackgroundKind.ItemIndex := cbBackgroundKind.Items.count - 1;
  end;

  if assigned(CurrentProject.Background.Bitmap) and
    (CurrentProject.Background.Bitmap.width > 0) and
    (CurrentProject.Background.Bitmap.height > 0) then
    imgBackgroundBitmap.Bitmap.Assign(CurrentProject.Background.Bitmap)
  else
    imgBackgroundBitmap.Bitmap.Clear(talphacolors.white);

  edtBackgroundColor.text := InttoHex(CurrentProject.Background.color, 8);

  // Initialisation de l'onglet "bitmaps"

  for i := sbImages.content.ChildrenCount - 1 downto 0 do
    if sbImages.content.children[i] is TcadProjectImage then
      sbImages.content.children[i].free;

  for Bitmap in CurrentProject.Bitmaps do
    TcadProjectImage.GetNew(self, sbImages, Bitmap, DBStores);

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
    raise exception.Create('No opened projet to save.');

  if CurrentProject.filename.isempty then
  begin
    // TODO : restaurer le précédent chemin utilisé
    SaveDialogProject.InitialDir := tpath.GetDocumentsPath;
    SaveDialogProject.filename := '';
    if SaveDialogProject.Execute then
    begin
      // TODO : sauver le chemin utilisé pour le proposer la fois suivante
      filename := SaveDialogProject.filename;
      if tpath.GetExtension(filename).tolower <> '.asscg' then
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
  CurrentProject := TASSCGProject.Create;
  GoToProjectScreen;
end;

procedure TfrmMain.mnuFichierOuvrirClick(Sender: TObject);
var
  filename: string;
begin
  // TODO : restaurer le précédent chemin utilisé
  if string(OpenDialogProject.filename).isempty then
    OpenDialogProject.InitialDir := tpath.GetDocumentsPath
  else
    OpenDialogProject.InitialDir := tpath.GetDirectoryName
      (OpenDialogProject.filename);

  if OpenDialogProject.Execute then
  begin
    // TODO : sauvegarder le chemin utilisé pour plus tard
    filename := OpenDialogProject.filename;
    if not tfile.Exists(filename) then
      raise exception.Create('File not found.');
    if not filename.tolower.EndsWith('.asscg') then
      raise exception.Create('Wrong file extension. Won''t open it.');
    CurrentProject := TASSCGProject.Create(filename);
    GoToProjectScreen;
  end;
end;

procedure TfrmMain.mnuOutilsLanguesDesProjetsClick(Sender: TObject);
var
  frm: TfrmStoresLanguages;
begin
  frm := TfrmStoresLanguages.Create(self);
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
  frm := TfrmOptions.Create(self);
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

procedure TfrmMain.onLanguageChange(Sender: TObject);
var
  folder: string;
begin
  if (Sender is TCheckBox) and not(Sender as TCheckBox).tagstring.isempty then
  begin
    folder := (Sender as TCheckBox).tagstring;
    if (Sender as TCheckBox).ischecked then
    begin
      if not CurrentProject.hasLanguage(folder) then
        CurrentProject.Languages.add(folder);
    end
    else if CurrentProject.hasLanguage(folder) then
      CurrentProject.Languages.Remove(folder);
  end;
end;

procedure TfrmMain.onStoreChange(Sender: TObject);
var
  Id: string;
begin
  if (Sender is TCheckBox) and not(Sender as TCheckBox).tagstring.isempty then
  begin
    Id := (Sender as TCheckBox).tagstring;
    if (Sender as TCheckBox).ischecked then
    begin
      if not CurrentProject.hasStore(Id) then
        CurrentProject.Stores.add(Id);
    end
    else if CurrentProject.hasStore(Id) then
      CurrentProject.Stores.Remove(Id);
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

procedure TfrmMain.ShowLanguageList;
var
  i: integer;
  o: TFMXObject;
  dm: TdmStoresLanguages;
begin
  for i := sbLanguages.content.ChildrenCount - 1 downto 0 do
  begin
    o := sbLanguages.content.children[i];
    if (o is TCheckBox) and ((o as TCheckBox).Tag = 2) then
      o.free;
  end;

  dm := TdmStoresLanguages.Create(self);
  try
    dm.fdStoresLanguages.first;
    while not dm.fdStoresLanguages.eof do
    begin
      with TCheckBox.Create(self) do
      begin
        parent := sbLanguages;
        Align := talignlayout.Top;
        Margins.Left := 5;
        Margins.Top := 5;
        Margins.Right := 5;
        Margins.Bottom := 5;
        text := dm.fdStoresLanguages.fieldbyname('Libelle').AsString;
        tagstring := dm.fdStoresLanguages.fieldbyname('Folder').AsString;
        Tag := 2;
        OnChange := onLanguageChange;
        ischecked := assigned(CurrentProject) and
          CurrentProject.hasLanguage(tagstring);
      end;
      dm.fdStoresLanguages.next;
    end;
  finally
    dm.free;
  end;
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
    if (o is TCheckBox) and ((o as TCheckBox).Tag = 1) then
      o.free;
  end;

  if DBStores.count > 0 then
    for Store in DBStores do
      with TCheckBox.Create(self) do
      begin
        parent := sbStores;
        Align := talignlayout.Top;
        Margins.Left := 5;
        Margins.Top := 5;
        Margins.Right := 5;
        Margins.Bottom := 5;
        text := Store.Name;
        tagstring := Store.Id;
        Tag := 1;
        OnChange := onStoreChange;
        ischecked := assigned(CurrentProject) and
          CurrentProject.hasStore(tagstring);
      end;
end;

procedure TfrmMain.InitDBStore(AForceDownload: boolean);
var
  folder, filename: string;
begin
  DBStores.free;
  DBStores := TASSCGDBStores.Create;

{$IFDEF DEBUG}
  folder := tpath.combine(tpath.GetDocumentsPath, 'OlfSoftware-DEBUG',
    'ASSCG-DEBUG');
{$ELSE}
  folder := tpath.combine(tpath.GetHomePath, 'OlfSoftware', 'ASSCG');
{$ENDIF}
  if not tdirectory.Exists(folder) then
    tdirectory.CreateDirectory(folder);

{$IFDEF DEBUG}
  filename := tpath.combine(folder, 'asscg-debug.asscgstores');
{$ELSE}
  filename := tpath.combine(folder, 'asscg.asscgstores');
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
