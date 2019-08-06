program SilentClick;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unitFrmMain
  { you can add units after this }, LazMouseAndKeyInput;

{$R *.res}

begin
    Application.Title:='SilentClick';
  Application.Initialize;
  Application.ShowMainForm := False; // Add this line, so mainform will not show at startup
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

