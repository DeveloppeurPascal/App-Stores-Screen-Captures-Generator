unit uDMAppIcon;

interface

uses
  System.SysUtils, System.Classes, System.ImageList, FMX.ImgList;

type
  TdmAppIcon = class(TDataModule)
    imgAppIcon: TImageList;
  private
    { D�clarations priv�es }
  public
    { D�clarations publiques }
  end;

var
  dmAppIcon: TdmAppIcon;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
