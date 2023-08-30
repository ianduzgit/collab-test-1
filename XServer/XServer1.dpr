program XServer1;

uses
  Vcl.Forms,
  ServerUnit in 'ServerUnit.pas' {ServerContainer: TDataModule},
  fMainForm in 'fMainForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TServerContainer, ServerContainer);
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
