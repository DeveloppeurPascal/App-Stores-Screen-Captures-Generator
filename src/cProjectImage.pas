unit cProjectImage;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation,
  uProjectASSCG,
  uProjectASSCGStores;

type
  TcadProjectImage = class(TFrame)
    GridPanelLayout1: TGridPanelLayout;
    imgBitmap: TImageControl;
    sbStores: TVertScrollBox;
    btnDelete: TButton;
    cbAllStores: TCheckBox;
    lStores: TLayout;
    lLanguages: TLayout;
    sbLanguages: TVertScrollBox;
    cbAllLanguages: TCheckBox;
    btnRefreshLanguages: TButton;
    btnRefreshStores: TButton;
    procedure btnDeleteClick(Sender: TObject);
    procedure cbAllStoresChange(Sender: TObject);
    procedure cbAllLanguagesChange(Sender: TObject);
    procedure btnRefreshStoresClick(Sender: TObject);
    procedure btnRefreshLanguagesClick(Sender: TObject);
  private
    FBitmap: TASSCGBitmap;
    FDBStores: TASSCGDBStores;
    procedure SetBitmap(const Value: TASSCGBitmap);
    procedure SetDBStores(const Value: TASSCGDBStores);
    { Déclarations privées }
  protected
    procedure RefreshStoresList;
    procedure RefreshLanguagesList;
    procedure onStoreChange(Sender: TObject);
    procedure onLanguageChange(Sender: TObject);
  public
    { Déclarations publiques }
    property ASSCGBitmap: TASSCGBitmap read FBitmap write SetBitmap;
    property DBStores: TASSCGDBStores read FDBStores write SetDBStores;
    class procedure GetNew(AOwner: TComponent; AParent: TFMXObject;
      ABitmap: TASSCGBitmap; ADBStores: TASSCGDBStores);
    constructor Create(AOwner: TComponent); override;
  end;

implementation

{$R *.fmx}

uses
  FMX.DialogService,
  uDMStoresLanguages;

{ TcadProjectImage }

procedure TcadProjectImage.btnDeleteClick(Sender: TObject);
begin
  tdialogservice.MessageDialog('Voulez-vous retirer cette image du projet ?' +
    slinebreak + '(opération irréversible)', tmsgdlgtype.mtConfirmation,
    [tmsgdlgbtn.mbYes, tmsgdlgbtn.mbNo], tmsgdlgbtn.mbYes, 0,
    procedure(const AModalResult: TModalResult)
    begin
      if AModalResult = mrYes then
      begin
        enabled := false;
        ASSCGBitmap.project.Bitmaps.Remove(ASSCGBitmap);
        tthread.forcequeue(nil,
          procedure
          begin
            self.free;
          end);
      end;
    end);
end;

procedure TcadProjectImage.btnRefreshLanguagesClick(Sender: TObject);
begin
  RefreshLanguagesList;
end;

procedure TcadProjectImage.btnRefreshStoresClick(Sender: TObject);
begin
  RefreshStoresList;
end;

procedure TcadProjectImage.cbAllLanguagesChange(Sender: TObject);
begin
  ASSCGBitmap.ForAllLanguages := cbAllLanguages.IsChecked;
end;

procedure TcadProjectImage.cbAllStoresChange(Sender: TObject);
begin
  ASSCGBitmap.ForAllStores := cbAllStores.IsChecked;
end;

constructor TcadProjectImage.Create(AOwner: TComponent);
begin
  inherited;
  name := '';
end;

class procedure TcadProjectImage.GetNew(AOwner: TComponent; AParent: TFMXObject;
ABitmap: TASSCGBitmap; ADBStores: TASSCGDBStores);
begin
  with TcadProjectImage.Create(AOwner) do
  begin
    ASSCGBitmap := ABitmap;
    DBStores := ADBStores;
    parent := AParent;
    align := talignlayout.top;

    // init picture
    if assigned(ABitmap.Bitmap) and (ABitmap.Bitmap.width > 0) and
      (ABitmap.Bitmap.Height > 0) then
      imgBitmap.Bitmap.assign(ABitmap.Bitmap);

    // init stores
    cbAllStores.IsChecked := ASSCGBitmap.ForAllStores;
    RefreshStoresList;

    // init languages
    cbAllLanguages.IsChecked := ASSCGBitmap.ForAllLanguages;
    RefreshLanguagesList;
  end;
end;

procedure TcadProjectImage.onLanguageChange(Sender: TObject);
var
  folder: string;
begin
  if (Sender is TCheckBox) and not(Sender as TCheckBox).tagstring.isempty then
  begin
    folder := (Sender as TCheckBox).tagstring;
    if (Sender as TCheckBox).IsChecked then
    begin
      if not ASSCGBitmap.hasLanguage(folder) then
        ASSCGBitmap.ForLanguages.add(folder);
    end
    else if ASSCGBitmap.hasLanguage(folder) then
      ASSCGBitmap.ForLanguages.Remove(folder);
  end;
end;

procedure TcadProjectImage.onStoreChange(Sender: TObject);
var
  id: string;
begin
  if (Sender is TCheckBox) and not(Sender as TCheckBox).tagstring.isempty then
  begin
    id := (Sender as TCheckBox).tagstring;
    if (Sender as TCheckBox).IsChecked then
    begin
      if not ASSCGBitmap.hasStore(id) then
        ASSCGBitmap.ForStores.add(id);
    end
    else if ASSCGBitmap.hasStore(id) then
      ASSCGBitmap.ForStores.Remove(id);
  end;
end;

procedure TcadProjectImage.RefreshLanguagesList;
var
  i: integer;
  o: TFMXObject;
  dm: TdmStoresLanguages;
  folder: string;
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
      folder := dm.fdStoresLanguages.fieldbyname('Folder').AsString;
      if ASSCGBitmap.project.hasLanguage(folder) then
        with TCheckBox.Create(self) do
        begin
          parent := sbLanguages;
          align := talignlayout.top;
          Margins.Left := 5;
          Margins.top := 5;
          Margins.Right := 5;
          Margins.Bottom := 5;
          text := dm.fdStoresLanguages.fieldbyname('Libelle').AsString;
          tagstring := folder;
          Tag := 2;
          OnChange := onLanguageChange;
          IsChecked := ASSCGBitmap.hasLanguage(tagstring);
        end;
      dm.fdStoresLanguages.next;
    end;
  finally
    dm.free;
  end;
end;

procedure TcadProjectImage.RefreshStoresList;
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

  if DBStores.Count > 0 then
    for Store in DBStores do
      if ASSCGBitmap.project.hasStore(Store.id) then
        with TCheckBox.Create(self) do
        begin
          parent := sbStores;
          align := talignlayout.top;
          Margins.Left := 5;
          Margins.top := 5;
          Margins.Right := 5;
          Margins.Bottom := 5;
          text := Store.Name;
          tagstring := Store.id;
          Tag := 1;
          OnChange := onStoreChange;
          IsChecked := ASSCGBitmap.hasStore(tagstring);
        end;
end;

procedure TcadProjectImage.SetBitmap(const Value: TASSCGBitmap);
begin
  FBitmap := Value;

  // TODO : initialiser l'écran depuis le bitmap
end;

procedure TcadProjectImage.SetDBStores(const Value: TASSCGDBStores);
begin
  FDBStores := Value;
end;

end.
