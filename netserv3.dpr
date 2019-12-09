program netserv3;

uses
  System.StartUpCopy,
  FMX.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Net.Socket in 'net\Net.Socket.pas',
  Lib.HTTPConsts in 'net\Lib.HTTPConsts.pas',
  Lib.HTTPContent in 'net\Lib.HTTPContent.pas',
  Lib.HTTPHeaders in 'net\Lib.HTTPHeaders.pas',
  Lib.HTTPUtils in 'net\Lib.HTTPUtils.pas',
  Net.HTTPSocket in 'net\Net.HTTPSocket.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
