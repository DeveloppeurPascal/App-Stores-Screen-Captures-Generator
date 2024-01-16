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
    CVersion = 1;

  var
    FBitmap: TBitmap;
    FProject: TASSCGProject;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    destructor Destroy; override;
  end;

  TASSCGBitmapList = class(TObjectList<TASSCGBitmap>)
  private const
    CVersion = 1;

  var
    FProject: TASSCGProject;
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TASSCGLanguage = class
  private const
    CVersion = 1;

  var
    FText: string;
    FProject: TASSCGProject;
    procedure SetText(const Value: string);
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Text: string read FText write SetText;
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TASSCGLanguageList = class(TObjectList<TASSCGLanguage>)
  private const
    CVersion = 1;

  var
    FProject: TASSCGProject;
    procedure SetProject(const Value: TASSCGProject);
  protected
  public
    property Project: TASSCGProject read FProject write SetProject;
    constructor Create(AProject: TASSCGProject);
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TASSCGFillKind = (Solid, BitmapTiled, BitmapStretched);

  TASSCGBackground = class
  private const
    CVersion = 1;

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
    destructor Destroy; override;
  end;

  TASSCGEffect = (None, Shadow, Glow);

  TASSCGProject = class
  private const
    CVersion = 1;

  var
    FBitmaps: TASSCGBitmapList;
    FBackground: TASSCGBackground;
    FEffect: TASSCGEffect;
    FLanguages: TASSCGLanguageList;
    FHasChanged: boolean;
    FFileName: string;
    procedure SetBackground(const Value: TASSCGBackground);
    procedure SetBitmaps(const Value: TASSCGBitmapList);
    procedure SetEffect(const Value: TASSCGEffect);
    procedure SetLanguages(const Value: TASSCGLanguageList);
    procedure SetHasChanged(const Value: boolean);
    function GetProjectName: string;
    procedure SetFilename(const Value: string);
  protected
  public
    property Bitmaps: TASSCGBitmapList read FBitmaps write SetBitmaps;
    property Languages: TASSCGLanguageList read FLanguages write SetLanguages;
    property Background: TASSCGBackground read FBackground write SetBackground;
    property Effect: TASSCGEffect read FEffect write SetEffect;
    // TODO : add stores/targets list
    property HasChanged: boolean read FHasChanged write SetHasChanged;
    property Name: string read GetProjectName;
    property Filename: string read FFileName write SetFilename;
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(AFileName: string);
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(AFileName: string = '');
    constructor Create(AFromFileName: string = '');
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils, Olf.FMX.Streams, Olf.RTL.Streams;

{ TASSCGBitmap }

constructor TASSCGBitmap.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FBitmap := nil;
  FProject := AProject;
end;

destructor TASSCGBitmap.Destroy;
begin
  FBitmap.free;
  inherited;
end;

procedure TASSCGBitmap.LoadFromStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update this program.');

  FBitmap.free;
  try
    FBitmap := LoadBitmapFromStream(AStream);
  except
    raise exception.Create('Wrong file format !');
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
end;

procedure TASSCGBitmap.SetBitmap(const Value: TBitmap);
begin
  if FBitmap = Value then
    exit;

  FBitmap := Value;
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

constructor TASSCGBitmapList.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
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
      ('Can''t load this project file. Please update this program.');

  if (AStream.readdata(Nb) <> sizeof(Nb)) then
    raise exception.Create('Wrong file format !');

  clear;
  for i := 1 to Nb do
  begin
    bmp := TASSCGBitmap.Create(FProject);
    bmp.LoadFromStream(AStream);
    add(bmp);
  end;
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

{ TASSCGLanguage }

constructor TASSCGLanguage.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FText := '';
  FProject := AProject;
end;

procedure TASSCGLanguage.LoadFromStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update this program.');

  try
    FText := LoadStringFromStream(AStream);
  except
    raise exception.Create('Wrong file format !');
  end;
end;

procedure TASSCGLanguage.SaveToStream(AStream: TStream);
var
  Version: byte;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  SaveStringToStream(FText, AStream);
end;

procedure TASSCGLanguage.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

procedure TASSCGLanguage.SetText(const Value: string);
begin
  if FText = Value then
    exit;

  FText := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGLanguageList }

constructor TASSCGLanguageList.Create(AProject: TASSCGProject);
begin
  inherited Create;
  FProject := AProject;
end;

procedure TASSCGLanguageList.LoadFromStream(AStream: TStream);
var
  Version: byte;
  i, Nb: int64;
  ln: TASSCGLanguage;
begin
  if not assigned(AStream) then
    raise exception.Create('Need a stream instance to load from.');

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update this program.');

  if (AStream.readdata(Nb) <> sizeof(Nb)) then
    raise exception.Create('Wrong file format !');

  clear;
  for i := 1 to Nb do
  begin
    ln := TASSCGLanguage.Create(FProject);
    ln.LoadFromStream(AStream);
    add(ln);
  end;
end;

procedure TASSCGLanguageList.SaveToStream(AStream: TStream);
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

procedure TASSCGLanguageList.SetProject(const Value: TASSCGProject);
begin
  if FProject = Value then
    exit;

  FProject := Value;
  if assigned(FProject) then
    FProject.HasChanged := true;
end;

{ TASSCGBackground }

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
      ('Can''t load this project file. Please update this program.');

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
  FEffect := TASSCGEffect.None;
  FLanguages := TASSCGLanguageList.Create(self);
  FHasChanged := false;

  if not AFromFileName.IsEmpty then
    LoadFromFile(AFromFileName)
  else
    Filename := '';
end;

destructor TASSCGProject.Destroy;
begin
  FBitmaps.free;
  FBackground.free;
  FLanguages.free;

  inherited;
end;

function TASSCGProject.GetProjectName: string;
begin
  if FFileName.IsEmpty then
    result := 'Untitled'
  else
    result := tpath.GetFileNameWithoutExtension(FFileName);
end;

procedure TASSCGProject.LoadFromFile(AFileName: string);
var
  fs: TFileStream;
begin
  if AFileName.IsEmpty or (not tfile.Exists(AFileName)) then
    raise exception.Create('File doesn''t exist !');
  try
    fs := TFileStream.Create(AFileName, fmOpenRead);
    try
      LoadFromStream(fs);
      Filename := AFileName;
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

  if (AStream.readdata(Version) <> sizeof(Version)) or (Version > CVersion) then
    raise exception.Create
      ('Can''t load this project file. Please update this program.');

  FBitmaps.LoadFromStream(AStream);

  FBackground.LoadFromStream(AStream);

  if (AStream.read(FEffect, sizeof(FEffect)) <> sizeof(FEffect)) then
    raise exception.Create('Wrong file format !');

  FLanguages.LoadFromStream(AStream);

  HasChanged := false;
end;

procedure TASSCGProject.SaveToFile(AFileName: string);
var
  fs: TFileStream;
  fn: string;
begin
  if AFileName.IsEmpty then
    fn := FFileName
  else
    fn := AFileName;

  if fn.IsEmpty then
    raise exception.Create('Can''t save the project without a filename !');

  try
    fs := TFileStream.Create(fn, fmOpenwrite);
    try
      SaveToStream(fs);
      if (AFileName <> FFileName) then
        Filename := fn;
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

  Version := CVersion;
  if (AStream.writedata(Version) <> sizeof(Version)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  FBitmaps.SaveToStream(AStream);

  FBackground.SaveToStream(AStream);

  if (AStream.writedata(FEffect) <> sizeof(FEffect)) then
    raise exception.Create
      ('Can''t save this project file. No enough space on the disk.');

  FLanguages.SaveToStream(AStream);

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

procedure TASSCGProject.SetFilename(const Value: string);
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

procedure TASSCGProject.SetLanguages(const Value: TASSCGLanguageList);
begin
  if FLanguages = Value then
    exit;

  FLanguages := Value;
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

end.
