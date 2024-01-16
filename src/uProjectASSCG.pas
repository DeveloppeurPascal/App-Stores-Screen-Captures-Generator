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
  private
    FBitmap: TBitmap;
    procedure SetBitmap(const Value: TBitmap);
  protected
  public
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    constructor Create;
    destructor Destroy; override;
  end;

  TASSCGBitmapList = class(TObjectList<TASSCGBitmap>)
  private
  protected
  public
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TASSCGLanguage = class
  private
    FText: string;
    procedure SetText(const Value: string);
  protected
  public
    property Text: string read FText write SetText;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    constructor Create;
  end;

  TASSCGLanguageList = class(TObjectList<TASSCGLanguage>)
  private
  protected
  public
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
  end;

  TASSCGFillKind = (Solid, BitmapTiled, BitmapStretched);

  TASSCGBackground = class
  private
    FColor: TAlphacolor;
    FBitmap: TBitmap;
    FKind: TASSCGFillKind;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetColor(const Value: TAlphacolor);
    procedure SetKind(const Value: TASSCGFillKind);
  protected
  public
    property Kind: TASSCGFillKind read FKind write SetKind;
    property Color: TAlphacolor read FColor write SetColor;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    procedure LoadFromStream(AStream: TStream);
    procedure SaveToStream(AStream: TStream);
    constructor Create;
    destructor Destroy; override;
  end;

  TASSCGEffect = (None, Shadow, Glow);

  TASSCGProject = class
  private
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
    procedure SaveToFile(AFileName: string);
    constructor Create(AFromFileName: string = '');
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ TASSCGBitmap }

constructor TASSCGBitmap.Create;
begin
  inherited;
  // TODO : à compléter
end;

destructor TASSCGBitmap.Destroy;
begin
  // TODO : à compléter
  inherited;
end;

procedure TASSCGBitmap.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter
end;

procedure TASSCGBitmap.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter
end;

procedure TASSCGBitmap.SetBitmap(const Value: TBitmap);
begin
  FBitmap := Value;
end;

{ TASSCGBitmapList }

procedure TASSCGBitmapList.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter
end;

procedure TASSCGBitmapList.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter
end;

{ TASSCGLanguage }

constructor TASSCGLanguage.Create;
begin
  inherited; // TODO : à compléter

end;

procedure TASSCGLanguage.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter

end;

procedure TASSCGLanguage.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter

end;

procedure TASSCGLanguage.SetText(const Value: string);
begin
  FText := Value;
end;

{ TASSCGLanguageList }

procedure TASSCGLanguageList.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter

end;

procedure TASSCGLanguageList.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter

end;

{ TASSCGBackground }

constructor TASSCGBackground.Create;
begin
  inherited;
  // TODO : à compléter

end;

destructor TASSCGBackground.Destroy;
begin
  // TODO : à compléter

  inherited;
end;

procedure TASSCGBackground.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter

end;

procedure TASSCGBackground.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter

end;

procedure TASSCGBackground.SetBitmap(const Value: TBitmap);
begin
  FBitmap := Value;
end;

procedure TASSCGBackground.SetColor(const Value: TAlphacolor);
begin
  FColor := Value;
end;

procedure TASSCGBackground.SetKind(const Value: TASSCGFillKind);
begin
  FKind := Value;
end;

{ TASSCGProject }

constructor TASSCGProject.Create(AFromFileName: string);
begin
  inherited Create;

  FBitmaps := TASSCGBitmapList.Create;
  FBackground := TASSCGBackground.Create;
  FEffect := TASSCGEffect.None;
  FLanguages := TASSCGLanguageList.Create;
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
begin
  // TODO : à compléter

end;

procedure TASSCGProject.LoadFromStream(AStream: TStream);
begin
  // TODO : à compléter
  HasChanged := false;
end;

procedure TASSCGProject.SaveToFile(AFileName: string);
begin
  // TODO : à compléter
end;

procedure TASSCGProject.SaveToStream(AStream: TStream);
begin
  // TODO : à compléter
  HasChanged := false;
end;

procedure TASSCGProject.SetBackground(const Value: TASSCGBackground);
begin
  FBackground := Value;
end;

procedure TASSCGProject.SetBitmaps(const Value: TASSCGBitmapList);
begin
  FBitmaps := Value;
end;

procedure TASSCGProject.SetEffect(const Value: TASSCGEffect);
begin
  FEffect := Value;
end;

procedure TASSCGProject.SetFilename(const Value: string);
begin
  FFileName := Value;

  TMessageManager.DefaultManager.SendMessage(self,
    TASSCGProjectNameHasChangedMessage.Create(self), true);
end;

procedure TASSCGProject.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
  // TODO : à prendre en charge dans tous les éléments du projet

  TMessageManager.DefaultManager.SendMessage(self,
    TASSCGProjectHasChangedMessage.Create(self), true);
end;

procedure TASSCGProject.SetLanguages(const Value: TASSCGLanguageList);
begin
  FLanguages := Value;
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
