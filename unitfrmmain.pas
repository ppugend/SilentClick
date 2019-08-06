unit unitFrmMain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, Menus, windows, ShellApi, Messages;


const
  WM_ICONTRAY = WM_USER + 1;
type
  MY_NOTIFYICONDATAA = record
      cbSize: DWORD;
      Wnd: HWND;
      uID: UINT;
      uFlags: UINT;
      uCallbackMessage: UINT;
      hIcon: HICON;
      szTip: array [0..63] of Char;
 end;

type

  { TfrmMain }

  TWMHotKey = packed record
    Msg: Cardinal;
    HotKey: Longint;
    Unused: Longint;
    Result: Longint;
  end;

  TfrmMain = class(TForm)
      btnPress: TButton;
      btnClose: TButton;
      pmTrayItemExit: TMenuItem;
      pmTray: TPopupMenu;
    procedure btnCloseClick(Sender: TObject);
    procedure btnPressClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure pmTrayItemExitClick(Sender: TObject);
  private
    TrayIconData: MY_NOTIFYICONDATAA;
    hkId :integer;
    procedure WMHotkey(var Msg: TWMHotkey); message WM_HOTKEY;
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
  public
    procedure ClickLeftButton(Data: PtrInt);
  end;

var
  frmMain: TfrmMain;

implementation

{$R unitFrmMain.lfm}

uses
  MouseAndKeyInput, LCLType;


const
     btnText = 'Press this button! shortcut is ctrl+F1';
var
   clickCount :integer;
{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
const
     MOD_ALT = 1;
     MOD_CONTROL = 2;
     MOD_SHIFT = 3;
     MOD_WIN = 4;
begin
      with TrayIconData do
      begin
        cbSize := SizeOf(TrayIconData);
        uID := 0;
        uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
        uCallbackMessage := WM_ICONTRAY;
        hIcon := Application.Icon.Handle;
        StrPCopy(szTip, Application.Title);
      end;

      TrayIconData.Wnd := Handle;
      Windows.Shell_NotifyIcon(NIM_ADD, @TrayIconData);


     hkId:=GlobalAddAtom('SilentClickHotkey');
     //registerHotkeyResult := RegisterHotKey(Handle,hkId,MOD_CONTROL,$41);
     RegisterHotKey(Handle,hkId,MOD_CONTROL,VK_F1);

     clickCount:=0;
     btnPress.Caption:=btnText;
end;

procedure TfrmMain.btnPressClick(Sender: TObject);
begin
     inc(clickCount);
     btnPress.Caption:=btnText + ' ' + IntToStr(clickCount);
end;


procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
     CanClose:=false;
     hide;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Hide;
end;

procedure TfrmMain.WMHotkey(var Msg: TWMHotkey);
begin
     //if Msg.HotKey = hkId then
     if Msg.Unused = hkId then
     begin
       Application.QueueAsyncCall(@ClickLeftButton, 0);
     end;
end;

procedure TfrmMain.TrayMessage(var Msg: TMessage);
begin
  case Msg.lParam of
      WM_LBUTTONDOWN:
      begin
        Show;
      end;
      WM_RBUTTONDOWN:
      begin
        pmTray.PopUp(Mouse.CursorPos.x,Mouse.CursorPos.y);
      end;
    end;
end;


procedure TfrmMain.FormDestroy(Sender: TObject);
begin
    Windows.Shell_NotifyIcon(NIM_DELETE, @TrayIconData);

    UnregisterHotKey(Handle,hkId);
    GlobalDeleteAtom(hkId);
end;

procedure TfrmMain.pmTrayItemExitClick(Sender: TObject);
begin
    Application.Terminate;
end;


procedure TfrmMain.ClickLeftButton(Data: PtrInt);
begin
  MouseInput.Click(mbLeft, []);
end;



end.

