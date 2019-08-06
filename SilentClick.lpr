program SilentClick;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, unitFrmMain
  { you can add units after this }, LazMouseAndKeyInput,ShellApi,windows;

{$R *.res}
const
  MUTEX_NAME = '{044A3063-DEF0-4C22-ADC2-D10A660DC15A}';
var
   mMutex: THandle;

begin
  mMutex := OpenMutex(MUTEX_ALL_ACCESS, False, MUTEX_NAME);
  if mMutex <> 0 then Exit;
  mMutex := CreateMutex(nil, True, MUTEX_NAME);

  Application.Title:='SilentClick';
  Application.Initialize;
  Application.ShowMainForm := False; // Add this line, so mainform will not show at startup
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

