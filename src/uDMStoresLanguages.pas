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
  File last update : 2025-10-16T10:42:30.925+02:00
  Signature : 62d240ff4acf9e78830b06a36d0a4c517ea1d1ad
  ***************************************************************************
*)

unit uDMStoresLanguages;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Intf,
  Data.DB,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Stan.StorageBin;

type
  TdmStoresLanguages = class(TDataModule)
    fdStoresLanguages: TFDMemTable;
    fdStoresLanguagesLibelle: TStringField;
    fdStoresLanguagesFolder: TStringField;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Déclarations privées }
  protected
    function GetDBFileName: string;
  public
    { Déclarations publiques }
    procedure SaveDB;
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

uses
  System.IOUtils,
  Olf.RTL.Params;

{$R *.dfm}
{ TdmStoresLanguages }

procedure TdmStoresLanguages.DataModuleCreate(Sender: TObject);
var
  filename: string;
begin
  filename := GetDBFileName;
  if tfile.exists(filename) then
  begin
    fdStoresLanguages.LoadFromFile(filename, TFDStorageFormat.sfBinary);
    fdStoresLanguages.Open;
  end
  else
  begin
    fdStoresLanguages.Open;
    fdStoresLanguages.EmptyDataSet;
  end;

end;

function TdmStoresLanguages.GetDBFileName: string;
begin
{$IFDEF DEBUG}
  result := tpath.combine(tpath.GetDirectoryName(TParams.getFilePath),
    'sl-debug.db');
{$ELSE}
  result := tpath.combine(tpath.GetDirectoryName(TParams.getFilePath), 'sl.db');
{$ENDIF}
end;

procedure TdmStoresLanguages.SaveDB;
begin
  fdStoresLanguages.savetofile(GetDBFileName, TFDStorageFormat.sfBinary);
end;

end.
