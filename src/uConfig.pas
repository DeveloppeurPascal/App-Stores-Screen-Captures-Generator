unit uConfig;

interface

type
{$SCOPEDENUMS ON}
  TAppTheme = (auto, light, dark);

  TConfig = class
  private
    class procedure SetAppTheme(const Value: TAppTheme); static;
    class function GetAppTheme: TAppTheme; static;
  protected
  public
    class property AppStyle: TAppTheme read GetAppTheme write SetAppTheme;
  end;

implementation

uses
  System.IOUtils,
  Olf.RTL.Params;

const
  CConfigAppTheme = 'Apptheme';

  { TConfig }

class function TConfig.GetAppTheme: TAppTheme;
begin
  result := TAppTheme(TParams.getValue(CConfigAppTheme, 0));
  // TODO : appliquer le thème d'affichage sélectionné au projet
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
