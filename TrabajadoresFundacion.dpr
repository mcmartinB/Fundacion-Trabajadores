program TrabajadoresFundacion;

uses
  Forms,
  UMain in 'UMain.pas' {FMain},
  UUtils in 'UUtils.pas',
  UDMDestino in 'UDMDestino.pas' {DMDestino: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMain, FMain);
  Application.Run;
end.
