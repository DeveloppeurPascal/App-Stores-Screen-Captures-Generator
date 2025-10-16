(* C2PP
  ***************************************************************************

  App Stores Screen Captures Generator

  Copyright 2024-2025 Patrick PREMARTIN under AGPL 3.0 license.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
  DEALINGS IN THE SOFTWARE.

  ***************************************************************************

  Author(s) :
  Patrick PREMARTIN

  Site :
  https://appstoresscreencapturesgenerator.olfsoftware.fr

  Project site :
  https://github.com/DeveloppeurPascal/App-Stores-Screen-Captures-Generator

  ***************************************************************************
  File last update : 2025-10-16T10:42:30.918+02:00
  Signature : 8bb8bde56c724d86c9d96e5087c04b7035464c51
  ***************************************************************************
*)

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
  result := TAppTheme(TParams.getValue(CConfigAppTheme, ord(TAppTheme.auto)));
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
    'ASSCG-debug');
{$ELSE}
  path := tpath.combine(tpath.GetHomePath, 'OlfSoftware', 'ASSCG');
{$ENDIF}
  TParams.setFolderName(path);
end;

initialization

LoadParams;

finalization

end.
