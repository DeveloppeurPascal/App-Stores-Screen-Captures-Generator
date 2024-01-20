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
