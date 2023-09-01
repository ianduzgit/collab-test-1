program XServer1;

uses
  Vcl.Forms,
  ServerUnit in 'ServerUnit.pas' {ServerContainer: TDataModule},
  fMainForm in 'fMainForm.pas' {MainForm},
  CocoFoneService in 'CocoFoneService.pas',
  xdmCocoFone in 'xdmCocoFone.pas' {dmCocoFone: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TdmCocoFone, dmCocoFone);
  Application.Run;
end.
