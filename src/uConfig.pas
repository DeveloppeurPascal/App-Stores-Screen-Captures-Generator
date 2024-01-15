unit uConfig;

interface

type
{$SCOPEDENUMS ON}
  TAppTheme = (auto, light, dark);
  TAppLangue = (Inconnu, Francais, Anglais);

  TConfig = class
  private
    class procedure SetAppTheme(const Value: TAppTheme); static;
    class function GetAppTheme: TAppTheme; static;
    class procedure SetAppLangue(const Value: TAppLangue); static;
    class function GetAppLangue: TAppLangue; static;
  protected
  public
    class property AppStyle: TAppTheme read GetAppTheme write SetAppTheme;
    class property AppLangue: TAppLangue read GetAppLangue write SetAppLangue;
  end;

implementation

uses
  System.IOUtils,
  Olf.RTL.Params,
  Olf.RTL.Language;

const
  CConfigAppTheme = 'AppTheme';
  CConfigAppLangue = 'AppLangue';

  { TConfig }

class function TConfig.GetAppLangue: TAppLangue;
var
  lng: string;
  DefaultLanguage: TAppLangue;
begin
  lng := GetCurrentLanguageISOCode;
  if lng = 'fr' then
    DefaultLanguage := TAppLangue.Francais
  else if lng = 'en' then
    DefaultLanguage := TAppLangue.Anglais
  else
    DefaultLanguage := TAppLangue.Inconnu;
  // TODO : ajouter les langues prises en charge par les traductions du logiciel
  result := TAppLangue(TParams.getValue(CConfigAppLangue,
    ord(DefaultLanguage)));
  // TODO : déclencher la traduction des écrans
end;

class function TConfig.GetAppTheme: TAppTheme;
begin
  result := TAppTheme(TParams.getValue(CConfigAppTheme, 0));
  // TODO : déclencher le changement éventuel de thème
end;

class procedure TConfig.SetAppLangue(const Value: TAppLangue);
begin
  TParams.setValue(CConfigAppLangue, ord(Value));
end;

class procedure TConfig.SetAppTheme(const Value: TAppTheme);
begin
  TParams.setValue(CConfigAppTheme, ord(Value));
end;

procedure LoadParams;
var
  path: string;
begin
{$IFDEF DEBUG}
  path := tpath.combine(tpath.GetDocumentsPath, 'OlfSoftware-debug',
    tpath.GetFileNameWithoutExtension(tpath.GetAppPath) + '-debug');
{$ELSE}
  path := tpath.combine(tpath.GetHomePath, 'OlfSoftware',
    tpath.GetFileNameWithoutExtension(tpath.GetAppPath));
{$ENDIF}
  TParams.setFolderName(path);
end;

initialization

LoadParams;

finalization

end.
