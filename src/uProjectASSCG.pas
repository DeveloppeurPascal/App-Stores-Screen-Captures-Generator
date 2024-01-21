unit uProjectASSCG;

interface

{
  Fichier projet

  Liste de captures d'écrans (ou images) pour un type d'appareil/OS + par langue

  Options du projet :
  - type de fond : uni + couleur ou image + Tile ou image + Stretch
  - effet : rien, shadow, glow
  - liste des magasins / plateformes
  - liste des langues du projet

}
uses
  // TODO : conditionner l'unité FMX/VCL.Graphics en fonction du framework
  FMX.graphics,
  System.Messaging,
  System.UITypes,
  System.Classes,
  System.Generics.Collections;

{$SCOPEDENUMS ON}

type
  TASSCGProject = class;
  TASSCGLanguages = class;
  TASSCGIDStores = class;

  TASSCGProjectHasChangedMessage = class(TMessage)
  private
    FProject: TASSCGProject;
  public
    property Project: TASSCGProject read FProject;
    constructor Create(AProject: TASSCGProject);
  end;

  TASSCGProjectNameHasChangedMessage = class(TMessage)
  private
    FProject: TASSCGProject;
  public
    property Project: TASSCGProject read FProject;
    constructor Create(AProject: TASSCGProject);
  end;

  TASSCGBitmap = class
  private const
    CVersion = 3;
    // don't forget to increase CProjectVersion if you change CVersion

  var
    FBitmap: TBitmap;
    FProject: TASSCGProject;
    FForAllStores: boolean;
    FForAllLanguages: boolean;
    FForStores: TASSCGIDStores;
    FForLanguages: TASSCGLanguages;
    FFileName: string;
    function GetFileName: string;
    procedure SetFileName(const Value: string);
    procedure SetForAllLanguages(const Value: boolean);
    procedure SetForAllStores(const Value: boolean);
    procedure SetForLanguages(const Value: TASSCGLanguages);
    procedure SetForStores(const Value: TASSCGIDStores);
    procedure SetBitmap(const Value: TBitmap);
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Project: TASSCGProject read FProject write SetProject;
    property ForAllLanguages: boolean read FForAllLanguages
      write SetForAllLanguages;
    property ForLanguages: TASSCGLanguages read FForLanguages
      write SetForLanguages;
    property ForAllStores: boolean read FForAllStores write SetForAllStores;
    property ForStores: TASSCGIDStores read FForStores write SetForStores;
    property FileName: string read GetFileName write SetFileName;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    destructor Destroy; override;
    procedure BitmapLoadFromFile(AFilename: string);
    procedure BitmapClear;
    function hasStore(const AID: string): boolean;
    function hasLanguage(const ALanguage: string): boolean;
  end;

  TASSCGBitmapList = class(TObjectList<TASSCGBitmap>)
  private const
    CVersion = 1;
    // don't forget to increase CProjectVersion if you change CVersion

  var
    FProject: TASSCGProject;
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    function Add(const Value: TASSCGBitmap): NativeInt;
    procedure Insert(Index: NativeInt; const Value: TASSCGBitmap);
    function Remove(const Value: TASSCGBitmap): NativeInt;
    procedure Delete(Index: NativeInt);
  end;

  TASSCGLanguages = class(TList<string>)
  private const
    CVersion = 2;
    // don't forget to increase CProjectVersion if you change CVersion

  var
    FProject: TASSCGProject;
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    function Add(const Value: string): NativeInt;
    procedure Insert(Index: NativeInt; const Value: string);
    function Remove(const Value: string): NativeInt;
    procedure Delete(Index: NativeInt);
  end;

  TASSCGFillKind = (Solid, BitmapTiled, BitmapStretched, BitmapCroped);

  TASSCGFillKindHelper = record helper for TASSCGFillKind
    function ToString: string;
    function Value: integer;
  end;

  TASSCGBackground = class
  private const
    CVersion = 1;
    // don't forget to increase CProjectVersion if you change CVersion

  var
    FColor: TAlphacolor;
    FBitmap: TBitmap;
    FKind: TASSCGFillKind;
    FProject: TASSCGProject;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetColor(const Value: TAlphacolor);
    procedure SetKind(const Value: TASSCGFillKind);
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Kind: TASSCGFillKind read FKind write SetKind;
    property Color: TAlphacolor read FColor write SetColor;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    procedure BitmapLoadFromFile(AFilename: string);
    procedure BitmapClear;
    destructor Destroy; override;
  end;

  TASSCGEffect = (None, Shadow, Glow);

  TASSCGIDStores = class(TList<string>)
  private const
    CVersion = 1;
    // don't forget to increase CProjectVersion if you change CVersion

  var
    FProject: TASSCGProject;
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    function Add(const Value: string): NativeInt;
    procedure Insert(Index: NativeInt; const Value: string);
    function Remove(const Value: string): NativeInt;
    procedure Delete(Index: NativeInt);
  end;

  TASSCGProject = class
  private const
    CProjectVersion = 3;

  var
    FBitmaps: TASSCGBitmapList;
    FBackground: TASSCGBackground;
    FEffect: TASSCGEffect;
    FLanguages: TASSCGLanguages;
    FHasChanged: boolean;
    FFileName: string;
    FStores: TASSCGIDStores;
    procedure SetStores(const Value: TASSCGIDStores);
    procedure SetBackground(const Value: TASSCGBackground);
    procedure SetBitmaps(const Value: TASSCGBitmapList);
    procedure SetEffect(const Value: TASSCGEffect);
    procedure SetLanguages(const Value: TASSCGLanguages);
    procedure SetHasChanged(const Value: boolean);
    function GetProjectName: string;
    procedure SetFileName(const Value: string);
  protected
  public
    property Bitmaps: TASSCGBitmapList read FBitmaps write SetBitmaps;
    property Languages: TASSCGLanguages read FLanguages write SetLanguages;
    property Background: TASSCGBackground read FBackground write SetBackground;
    property Effect: TASSCGEffect read FEffect write SetEffect;
    property Stores: TASSCGIDStores read FStores write SetStores;
    property HasChanged: boolean read FHasChanged write SetHasChanged;
    property Name: string read GetProjectName;
    property FileName: string read FFileName write SetFileName;
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(AFilename: string);
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(AFilename: string = '');
    constructor Create(AFromFileName: string = '');
    destructor Destroy; override;
    function hasStore(const AID: string): boolean;
    function hasLanguage(const ALanguage: string): boolean;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  Olf.FMX.Streams,
  Olf.RTL.Streams;

{ TASSCGBitmap }

procedure TASSCGBitmap.BitmapClear;
begin
  freeandnil(Bitmap);

  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.BitmapLoadFromFile(AFilename: string);
begin
  if not assigned(Bitmap) then
    Bitmap := TBitmap.Create;
  Bitmap.LoadFromFile(AFilename);

  if assigned(FProject) then
    FProject.HasChanged := true;
end;

constructor TASSCGBitmap.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FBitmap := nil;
  FProject := AProject;
  FForAllStores := true;
  FForAllLanguages := true;
  FForStores := TASSCGIDStores.Create(AProject);
  FForLanguages := TASSCGLanguages.Create(AProject);
  FFileName := '';
end;

destructor TASSCGBitmap.Destroy;
begin
  FBitmap.free;
  FForStores.free;
  FForLanguages.free;
  inherited;
end;

function TASSCGBitmap.GetFileName: string;
var
  i, n: byte;
begin
  if FFileName.isempty then
  begin
    FFileName := 'ScreenCapture_';
    for i := 1 to 10 do
    begin
      n := random(62);
      case n of
        0 .. 9:
          FFileName := FFileName + chr(ord('0') + n);
        10 .. 35:
          FFileName := FFileName + chr(ord('a') + n - 10);
        36 .. 61:
          FFileName := FFileName + chr(ord('A') + n - 36);
      end;
    end;
  end;
  result := FFileName;
end;

function TASSCGBitmap.hasLanguage(const ALanguage: string): boolean;
begin
  result := (ForLanguages.IndexOf(ALanguage) >= 0);
end;

function TASSCGBitmap.hasStore(const AID: string): boolean;
begin
  result := (ForStores.IndexOf(AID) >= 0);
end;

procedure TASSCGBitmap.LoadFromStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update the program.');

  FBitmap.free;
  try
    FBitmap := LoadBitmapFromStream(AStream);
  except
    raise exception.Create('Wrong file format !');
  end;

  if (Version >= 2) then
  begin
    if (AStream.readdata(FForAllStores) <> sizeof(FForAllStores)) then
      raise exception.Create('Wrong file format !');

    if (AStream.readdata(FForAllLanguages) <> sizeof(FForAllLanguages)) then
      raise exception.Create('Wrong file format !');

    FForStores.LoadFromStream(AStream);

    FForLanguages.LoadFromStream(AStream);
  end;

  if (Version >= 3) then
  begin
    FFileName := loadstringfromstream(AStream);
  end;
end;

procedure TASSCGBitmap.SaveToStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  SaveBitmapToStream(FBitmap, AStream);

  if (AStream.writedata(FForAllStores) <> sizeof(FForAllStores)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  if (AStream.writedata(FForAllLanguages) <> sizeof(FForAllLanguages)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  FForStores.SaveToStream(AStream);

  FForLanguages.SaveToStream(AStream);

  savestringtostream(FFileName, AStream);
end;

procedure TASSCGBitmap.SetBitmap(const Value: TBitmap);
begin
  if FBitmap = Value then
    exit;

  FBitmap := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.SetFileName(const Value: string);
begin
  if FFileName = Value then
    exit;

  FFileName := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.SetForAllLanguages(const Value: boolean);
begin
  if FForAllLanguages = Value then
    exit;

  FForAllLanguages := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.SetForAllStores(const Value: boolean);
begin
  if FForAllStores = Value then
    exit;

  FForAllStores := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.SetForLanguages(const Value: TASSCGLanguages);
begin
  if FForLanguages = Value then
    exit;

  FForLanguages := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.SetForStores(const Value: TASSCGIDStores);
begin
  if FForStores = Value then
    exit;

  FForStores := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBitmap.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGBitmapList }

function TASSCGBitmapList.Add(const Value: TASSCGBitmap): NativeInt;
begin
  result := inherited;
  FProject.HasChanged := true;
end;

constructor TASSCGBitmapList.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
end;

procedure TASSCGBitmapList.Delete(Index: NativeInt);
begin
  inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGBitmapList.Insert(Index: NativeInt; const Value: TASSCGBitmap);
begin
  inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGBitmapList.LoadFromStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
  bmp: TASSCGBitmap;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update the program.');

  if (AStream.readdata(Nb) <> sizeof(Nb)) then
    raise exception.Create('Wrong file format !');

  clear;
  for i := 1 to Nb do
  begin
    bmp := TASSCGBitmap.Create(FProject);
    bmp.LoadFromStream(AStream);
    Add(bmp);
  end;
end;

function TASSCGBitmapList.Remove(const Value: TASSCGBitmap): NativeInt;
begin
  result := inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGBitmapList.SaveToStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  Nb := count;
  if (AStream.writedata(Nb) <> sizeof(Nb)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  for i := 0 to Nb - 1 do
    self[i].SaveToStream(AStream);
end;

procedure TASSCGBitmapList.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGLanguages }

function TASSCGLanguages.Add(const Value: string): NativeInt;
begin
  result := inherited;
  FProject.HasChanged := true;
end;

constructor TASSCGLanguages.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
end;

procedure TASSCGLanguages.Delete(Index: NativeInt);
begin
  inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGLanguages.Insert(Index: NativeInt; const Value: string);
begin
  inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGLanguages.LoadFromStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update th program.');

  if (AStream.readdata(Nb) <> sizeof(Nb)) then
    raise exception.Create('Wrong file format !');

  clear;
  for i := 1 to Nb do
    Add(loadstringfromstream(AStream, TEncoding.UTF8));
end;

function TASSCGLanguages.Remove(const Value: string): NativeInt;
begin
  result := inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGLanguages.SaveToStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  Nb := count;
  if (AStream.writedata(Nb) <> sizeof(Nb)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  for i := 0 to Nb - 1 do
    savestringtostream(self[i], AStream, TEncoding.UTF8);
end;

procedure TASSCGLanguages.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGBackground }

procedure TASSCGBackground.BitmapClear;
begin
  freeandnil(Bitmap);

  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBackground.BitmapLoadFromFile(AFilename: string);
begin
  if not assigned(Bitmap) then
    Bitmap := TBitmap.Create;
  Bitmap.LoadFromFile(AFilename);

  if assigned(FProject) then
    FProject.HasChanged := true;
end;

constructor TASSCGBackground.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FColor := TAlphaColors.White;
  FBitmap := nil;
  FKind := TASSCGFillKind.Solid;
  FProject := AProject;
end;

destructor TASSCGBackground.Destroy;
begin
  FBitmap.free;
  inherited;
end;

procedure TASSCGBackground.LoadFromStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update the program.');

  if (AStream.read(FColor, sizeof(FColor)) <> sizeof(FColor)) then
    raise exception.Create('Wrong file format !');

  FBitmap.free;
  try
    FBitmap := LoadBitmapFromStream(AStream);
  except
    raise exception.Create('Wrong file format !');
  end;

  if (AStream.read(FKind, sizeof(FKind)) <> sizeof(FKind)) then
    raise exception.Create('Wrong file format !');
end;

procedure TASSCGBackground.SaveToStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  if (AStream.writedata(FColor) <> sizeof(FColor)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  SaveBitmapToStream(FBitmap, AStream);

  if (AStream.writedata(FKind) <> sizeof(FKind)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');
end;

procedure TASSCGBackground.SetBitmap(const Value: TBitmap);
begin
  if FBitmap = Value then
    exit;

  FBitmap := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBackground.SetColor(const Value: TAlphacolor);
begin
  if FColor = Value then
    exit;

  FColor := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBackground.SetKind(const Value: TASSCGFillKind);
begin
  if FKind = Value then
    exit;

  FKind := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGBackground.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGProject }

constructor TASSCGProject.Create(AFromFileName: string);
begin
  inherited Create;

  FBitmaps := TASSCGBitmapList.Create(self);
  FBackground := TASSCGBackground.Create(self);
  FEffect := TASSCGEffect.Shadow;
  FLanguages := TASSCGLanguages.Create(self);
  FHasChanged := false;
  FStores := TASSCGIDStores.Create(self);

  if not AFromFileName.isempty then
    LoadFromFile(AFromFileName)
  else
    FileName := '';
end;

destructor TASSCGProject.Destroy;
begin
  FBitmaps.free;
  FBackground.free;
  FLanguages.free;
  FStores.free;

  inherited;
end;

function TASSCGProject.GetProjectName: string;
begin
  if FFileName.isempty then
    result := 'Untitled'
  else
    result := tpath.GetFileNameWithoutExtension(FFileName);
end;

function TASSCGProject.hasLanguage(const ALanguage: string): boolean;
begin
  result := (Languages.IndexOf(ALanguage) >= 0);
end;

function TASSCGProject.hasStore(const AID: string): boolean;
begin
  result := (Stores.IndexOf(AID) >= 0);
end;

procedure TASSCGProject.LoadFromFile(AFilename: string);
var
  fs: TFileStream;
begin
  if AFilename.isempty or (not tfile.Exists(AFilename)) then
    raise exception.Create('File doesn''t exist !');
  try
    fs := TFileStream.Create(AFilename, fmOpenRead);
    try
      LoadFromStream(fs);
      FileName := AFilename;
      HasChanged := false;
    finally
      fs.free;
    end;
  except
{$IFDEF DEBUG}
    on e: exception do
      raise exception.Create('Can''t load this file.' + slinebreak + e.message);
{$ELSE}
    raise exception.Create('Can''t load this file.');
{$ENDIF}
  end;
end;

procedure TASSCGProject.LoadFromStream(AStream: TStream);
var
  Version: byte;
  Header: array [1 .. 6] of byte; // 'ASSCG'+#0
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.read(Header, sizeof(Header)) <> sizeof(Header)) or
    (Header[1] <> ord('A')) or (Header[2] <> ord('S')) or (Header[3] <> ord('S')
    ) or (Header[4] <> ord('C')) or (Header[5] <> ord('G')) or (Header[6] <> 0)
  then
    raise exception.Create('Wrong file format !');

  if (AStream.readdata(Version) <> sizeof(Version)) or
    (Version > CProjectVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update the program.');

  FBitmaps.LoadFromStream(AStream);

  FBackground.LoadFromStream(AStream);

  if (AStream.read(FEffect, sizeof(FEffect)) <> sizeof(FEffect)) then
    raise exception.Create('Wrong file format !');

  FLanguages.LoadFromStream(AStream);

  if (Version >= 2) then
    FStores.LoadFromStream(AStream);

  HasChanged := false;
end;

procedure TASSCGProject.SaveToFile(AFilename: string);
var
  fs: TFileStream;
  fn: string;
begin
  if AFilename.isempty then
    fn := FFileName
  else
    fn := AFilename;

  if fn.isempty then
    raise exception.Create('Can''t save the project without a filename !');

  try
    fs := TFileStream.Create(fn, fmCreate);
    try
      SaveToStream(fs);
      if (AFilename <> FFileName) then
        FileName := fn;
      HasChanged := false;
    finally
      fs.free;
    end;
  except
{$IFDEF DEBUG}
    on e: exception do
      raise exception.Create('Can''t save this file.' + slinebreak + e.message);
{$ELSE}
    raise exception.Create('Can''t save this file.');
{$ENDIF}
  end;
end;

procedure TASSCGProject.SaveToStream(AStream: TStream);
var
  Version: byte;
  Header: array [1 .. 6] of byte; // 'ASSCG'+#0
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Header[1] := ord('A');
  Header[2] := ord('S');
  Header[3] := ord('S');
  Header[4] := ord('C');
  Header[5] := ord('G');
  Header[6] := 0;
  if (AStream.writedata(Header) <> sizeof(Header)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  Version := CProjectVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  FBitmaps.SaveToStream(AStream);

  FBackground.SaveToStream(AStream);

  if (AStream.writedata(FEffect) <> sizeof(FEffect)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  FLanguages.SaveToStream(AStream);

  FStores.SaveToStream(AStream);

  HasChanged := false;
end;

procedure TASSCGProject.SetBackground(const Value: TASSCGBackground);
begin
  if FBackground = Value then
    exit;

  FBackground := Value;
  HasChanged := true;
end;

procedure TASSCGProject.SetBitmaps(const Value: TASSCGBitmapList);
begin
  if FBitmaps = Value then
    exit;

  FBitmaps := Value;
  HasChanged := true;
end;

procedure TASSCGProject.SetEffect(const Value: TASSCGEffect);
begin
  if FEffect = Value then
    exit;

  FEffect := Value;
  HasChanged := true;
end;

procedure TASSCGProject.SetFileName(const Value: string);
begin
  FFileName := Value;

  TMessageManager.DefaultManager.SendMessage(self,
    TASSCGProjectNameHasChangedMessage.Create(self), true);
end;

procedure TASSCGProject.SetHasChanged(const Value: boolean);
begin
  if FHasChanged = Value then
    exit;

  FHasChanged := Value;

  TMessageManager.DefaultManager.SendMessage(self,
    TASSCGProjectHasChangedMessage.Create(self), true);
end;

procedure TASSCGProject.SetLanguages(const Value: TASSCGLanguages);
begin
  if FLanguages = Value then
    exit;

  FLanguages := Value;
  HasChanged := true;
end;

procedure TASSCGProject.SetStores(const Value: TASSCGIDStores);
begin
  if FStores = Value then
    exit;

  FStores := Value;
  HasChanged := true;
end;

{ TASSCGProjectHasChanged }

constructor TASSCGProjectHasChangedMessage.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
end;

{ TASSCGProjectNameHasChangedMessage }

constructor TASSCGProjectNameHasChangedMessage.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
end;

{ TASSCGIDStores }

function TASSCGIDStores.Add(const Value: string): NativeInt;
begin
  result := inherited;
  FProject.HasChanged := true;
end;

constructor TASSCGIDStores.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
end;

procedure TASSCGIDStores.Delete(Index: NativeInt);
begin
  inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGIDStores.Insert(Index: NativeInt; const Value: string);
begin
  inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGIDStores.LoadFromStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update the program.');

  if (AStream.readdata(Nb) <> sizeof(Nb)) then
    raise exception.Create('Wrong file format !');

  clear;
  for i := 1 to Nb do
    Add(loadstringfromstream(AStream, TEncoding.UTF8));
end;

function TASSCGIDStores.Remove(const Value: string): NativeInt;
begin
  result := inherited;
  FProject.HasChanged := true;
end;

procedure TASSCGIDStores.SaveToStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  Nb := count;
  if (AStream.writedata(Nb) <> sizeof(Nb)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  for i := 0 to Nb - 1 do
    savestringtostream(self[i], AStream, TEncoding.UTF8);
end;

procedure TASSCGIDStores.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGFillKindHelper }

function TASSCGFillKindHelper.ToString: string;
begin
  case self of
    TASSCGFillKind.Solid:
      result := 'couleur';
    TASSCGFillKind.BitmapTiled:
      result := 'mosaïque';
    TASSCGFillKind.BitmapStretched:
      result := 'étiré';
    TASSCGFillKind.BitmapCroped:
      result := 'coupé';
  else
    raise exception.Create('No label for this fill kind.');
  end;
end;

function TASSCGFillKindHelper.Value: integer;
begin
  result := ord(self);
end;

end.
