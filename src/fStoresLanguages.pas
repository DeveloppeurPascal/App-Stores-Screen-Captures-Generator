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
  Signature : 0d83ac34a3462b6cf775eb05d095252fb9e638fb
  ***************************************************************************
*)

unit fStoresLanguages;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  uDMStoresLanguages,
  System.Rtti,
  FMX.Grid.Style,
  Data.Bind.Controls,
  Data.Bind.EngExt,
  FMX.Bind.DBEngExt,
  FMX.Bind.Grid,
  System.Bindings.Outputs,
  FMX.Bind.Editors,
  Data.Bind.Components,
  Data.Bind.Grid,
  Data.Bind.DBScope,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Bind.Navigator,
  FMX.Controls.Presentation,
  FMX.ScrollBox,
  FMX.Grid;

type
  TfrmStoresLanguages = class(TForm)
    StringGrid1: TStringGrid;
    BindNavigator1: TBindNavigator;
    ToolBar1: TToolBar;
    btnSave: TButton;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Déclarations privées }
  protected
    dm: TdmStoresLanguages;
  public
    { Déclarations publiques }
  end;

implementation

{$R *.fmx}

procedure TfrmStoresLanguages.btnCancelClick(Sender: TObject);
begin
  close;
end;

procedure TfrmStoresLanguages.btnSaveClick(Sender: TObject);
begin
  dm.SaveDB;
  close;
end;

procedure TfrmStoresLanguages.FormCreate(Sender: TObject);
begin
  dm := TdmStoresLanguages.create(self);
  BindSourceDB1.DataSet := dm.fdStoresLanguages;
end;

procedure TfrmStoresLanguages.FormDestroy(Sender: TObject);
begin
  dm.free;
end;

end.
