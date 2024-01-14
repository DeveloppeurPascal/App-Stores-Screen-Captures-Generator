unit uProjectASSCG;

interface

{
  Fichier projet

  Liste de captures d'�crans (ou images) pour un type d'appareil/OS + par langue

  Options du projet :
  - type de fond : uni + couleur ou image + Tile ou image + Stretch
  - effet : rien, shadow, glow
  - liste des magasins / plateformes
  - liste des langues du projet

}
uses
  // TODO : conditionner l'unit� FMX/VCL.Graphics en fonction du framework
  FMX.graphics,
  System.UITypes,
  System.Classes,
  System.Generics.Collections;

type
{$SCOPEDENUMS ON}
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
    procedure SetBackground(const Value: TASSCGBackground);
    procedure SetBitmaps(const Value: TASSCGBitmapList);
    procedure SetEffect(const Value: TASSCGEffect);
    procedure SetLanguages(const Value: TASSCGLanguageList);
    procedure SetHasChanged(const Value: boolean);
  protected
  public
    property Bitmaps: TASSCGBitmapList read FBitmaps write SetBitmaps;
    property Languages: TASSCGLanguageList read FLanguages write SetLanguages;
    property Background: TASSCGBackground read FBackground write SetBackground;
    property Effect: TASSCGEffect read FEffect write SetEffect;
    // TODO : add stores/targets list
    property HasChanged: boolean read FHasChanged write SetHasChanged;
    procedure LoadFromStream(AStream: TStream);
    procedure LoadFromFile(AFileName: string);
    procedure SaveToStream(AStream: TStream);
    procedure SaveToFile(AFileName: string);
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TASSCGBitmap }

constructor TASSCGBitmap.Create;
begin
  inherited;
  // TODO : � compl�ter
end;

destructor TASSCGBitmap.Destroy;
begin
  // TODO : � compl�ter
  inherited;
end;

procedure TASSCGBitmap.LoadFromStream(AStream: TStream);
begin
  // TODO : � compl�ter
end;

procedure TASSCGBitmap.SaveToStream(AStream: TStream);
begin
  // TODO : � compl�ter
end;

procedure TASSCGBitmap.SetBitmap(const Value: TBitmap);
begin
  FBitmap := Value;
end;

{ TASSCGBitmapList }

procedure TASSCGBitmapList.LoadFromStream(AStream: TStream);
begin
  // TODO : � compl�ter
end;

procedure TASSCGBitmapList.SaveToStream(AStream: TStream);
begin
  // TODO : � compl�ter
end;

{ TASSCGLanguage }

constructor TASSCGLanguage.Create;
begin
  inherited; // TODO : � compl�ter

end;

procedure TASSCGLanguage.LoadFromStream(AStream: TStream);
begin
  // TODO : � compl�ter

end;

procedure TASSCGLanguage.SaveToStream(AStream: TStream);
begin
  // TODO : � compl�ter

end;

procedure TASSCGLanguage.SetText(const Value: string);
begin
  FText := Value;
end;

{ TASSCGLanguageList }

procedure TASSCGLanguageList.LoadFromStream(AStream: TStream);
begin
  // TODO : � compl�ter

end;

procedure TASSCGLanguageList.SaveToStream(AStream: TStream);
begin
  // TODO : � compl�ter

end;

{ TASSCGBackground }

constructor TASSCGBackground.Create;
begin
  inherited;
  // TODO : � compl�ter

end;

destructor TASSCGBackground.Destroy;
begin
  // TODO : � compl�ter

  inherited;
end;

procedure TASSCGBackground.LoadFromStream(AStream: TStream);
begin
  // TODO : � compl�ter

end;

procedure TASSCGBackground.SaveToStream(AStream: TStream);
begin
  // TODO : � compl�ter

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

constructor TASSCGProject.Create;
begin
  inherited;
  // TODO : � compl�ter

end;

destructor TASSCGProject.Destroy;
begin
  // TODO : � compl�ter

  inherited;
end;

procedure TASSCGProject.LoadFromFile(AFileName: string);
begin
  // TODO : � compl�ter

end;

procedure TASSCGProject.LoadFromStream(AStream: TStream);
begin
  // TODO : � compl�ter
  HasChanged := false;
end;

procedure TASSCGProject.SaveToFile(AFileName: string);
begin
  // TODO : � compl�ter
end;

procedure TASSCGProject.SaveToStream(AStream: TStream);
begin
  // TODO : � compl�ter
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

procedure TASSCGProject.SetHasChanged(const Value: boolean);
begin
  FHasChanged := Value;
  // TODO : � prendre en charge dans tous les �l�ments du projet
end;

procedure TASSCGProject.SetLanguages(const Value: TASSCGLanguageList);
begin
  FLanguages := Value;
end;

end.
