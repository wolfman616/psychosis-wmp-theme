#NoEnv ; (MW:2022) (MW:2022) unfinished WMP theme: mouse-desktop interaction scheme
#NoTrayicon
SetBatchLines,	-1
#Persistent
#Singleinstance,Force
a_scriptStartTime:= a_tickCount 
Setworkingdir,% (splitpath(A_AhkPath)).dir
; #IfTimeout,200 ;* DANGER * : Performance impact if set too low. *think about using this*.
; ListLines,Off 
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,2
SetTitleMatchMode,Slow
SetWinDelay,		-1
coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen
loop,parse,% "VarZ,MenuZ",`,
	 gosub,% a_loopfield
menu,tray,icon,% "HICON: " b64_2_hicon(tray64)
menu,tray,icon

OnMessage(0x200,"mouseh")
OnMessage(0x404,"AHK_NOTIFYICON")

gosub,layers_init

return,

mouseh(wparam,lparam,mdg,hwnd) {
	static global globalinit
	tooltip po
	switch,hwnd {
		case,hwnd1,hwnd2,hwnd3:
			if(!globalinit) {
				winset,exstyle,-0x20,ahk_class WMP Skin Host
				loop,3 {
					winset,alwaysontop,off,% "ahk_class WMP " hwnd%a_index%
				}
				loop,4 {
					index2:= a_index +3
					winset,alwaysontop,on,% "ahk_class WMP " hwnd%index2%
				}
			} settimer,resetstylecheck,1000

		case,hwnd4,hwnd5,hwnd6,hwnd7:
			
			
			
	}
}

layers_init:
gosub,layersONTARGET_init
gosub,layersOFFTARGET_init
return,

layersONTARGET_init:
gui,1:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd1
gui,1:show, w308 h80 x3093 y966
uiband_set(hwnd1)
gui,2:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd2
gui,2:show, x3116 y1100 w259 h45
uiband_set(hwnd2)
gui,3:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd3
gui,3:show,x3644 y1156 w110 h28 
uiband_set(hwnd3)
VarSetCapacity(rect0,16,0xff)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd1,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd2,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd3,"uint",&rect0)
return,

layersOFFTARGET_init:
gui,4:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd4
gui,4:show,x3025 y900 w50 h200
uiband_set(hwnd4)
gui,5:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd5
gui,5:show,x3088 y902 w359 h45
uiband_set(hwnd5)
gui,6:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd6
gui,6:show,x3550 y969 w120 h132
uiband_set(hwnd6)
gui,7:new,dpiscale +toolwindow -caption +e0x8 +hwndhwnd7
gui,7:show,x3506 y1104 w90 h90
uiband_set(hwnd7)
VarSetCapacity(rect0,16,0xff)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd4,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd5,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd6,"uint",&rect0)
DllCall("dwmapi\DwmExtendFrameIntoClientArea","uint",hwnd7,"uint",&rect0)
return,

ResetStyleCheck:
mousegetpos,,,mwnd,mctl,2 
wingetclass,mclass,ahk_id %mwnd%
if((MClass != "WMP Skin Host") && (MClass != "AutoHotkeyGUI")) {
	try,winset,exstyle,+0x20, ahk_class WMP Skin Host
	loop,3 {
		index2:= a_index +3
		winset,alwaysontop,off,% "ahk_class WMP " hwnd%a_index%
	}
	loop,4 {
		index2:= a_index +3
		winset,alwaysontop,on,% "ahk_class WMP " hwnd%index2%
	}
	globalinit:= false
	settimer,resetstylecheck,off
} return,


menutray(){
	global
	Menu,Tray,Show
}

menuz:
menu,Tray,NoStandard
menu,Tray,Add,%	 splitpath(A_scriptFullPath).fn,% "do_nothing"
menu,Tray,disable,% splitpath(A_scriptFullPath).fn
menu,Tray,Add ,% "Open",%	"MenHandlr"
menu,Tray,Icon,% "Open",%	"C:\Icon\24\Gterminal_24_32.ico"
menu,Tray,Add ,% "Open Containing",%	"MenHandlr"
menu,Tray,Icon,% "Open Containing",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Edit",%	"MenHandlr"
menu,Tray,Icon,% "Edit",%	"C:\Icon\24\explorer24.ico"
menu,Tray,Add ,% "Reload",%	"MenHandlr"
menu,Tray,Icon,% "Reload",%	"C:\Icon\24\eaa.bmp"
menu,Tray,Add,%	 "Suspend",%	"MenHandlr"
menu,Tray,Icon,% "Suspend",%	"C:\Icon\24\head_fk_a_24_c1.ico"
menu,Tray,Add,%	 "Pause",%		"MenHandlr"
menu,Tray,Icon,% "Pause",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
menu,Tray,Add ,% "Exit",%		"MenHandlr"
menu,Tray,Icon,% "Exit",%		"C:\Icon\24\head_fk_a_24_c2b.ico"
;msgb0x((ahkexe:= splitpath(A_AhkPath)).fn
;,	 (_:= (splitpath(A_scriptFullPath).fn) " Started`n@ " time4mat() "   In:  "
;.	_:= (a_tickCount-a_scriptStartTime) " Ms"),3) ;sleep,100 ;_:=""

a_scriptStartTime:= time4mat(a_now,"H:m - d\M")
menu,Tray,Tip,% splitpath(A_scriptFullPath).fn "`nRunning, Started @`n" a_scriptStartTime
do_nothing:
return,

MenHandlr(isTarget="") {
	listlines,off
	switch,(isTarget=""? a_thismenuitem : isTarget) {
		case,"Open Containing": TT("Opening "   a_scriptdir "..." Open_Containing(A_scriptFullPath),1)
		case,"edit","Open","SUSPEND","pAUSE":
			PostMessage,0x0111,(%a_thismenuitem%),,,% A_ScriptName " - AutoHotkey"
		case,"RELOAD": reload()
		case,"EXIT": exitapp
		default: islabel(a_thismenuitem)? timer(a_thismenuitem,-10) : ()
	}	return,1
}

AHK_NOTIFYICON(byref wParam="", byref lParam="") {
	listlines,off
	switch,lParam {
	;	case,0x0206: ; WM_RBUTTONDBLCLK	;	case 0x020B: ; WM_XBUTTONDOWN
	;	case,0x0201: ; WM_LBUTTONDOWN	;	case 0x0202: ; WM_LBUTTONUP
		case,0x0204: 
			return,timer("menutray",-1) ; WM_RBUTTONdn
		case,0x0203: 
			(_:="",wParam:=""),
			PostMessage,0x0111,%open%,,,% A_ScriptName " - AutoHotkey"
			sleep(80),lParam:=(sleep(11),tt("Loading...","tray",1)) ; WM_doubleclick  
	}	return,
}

reload() {
	reload,
	exitapp,
}

Varz:
global	EDIT:=65304, open:=65407, Suspend:=65305, PAUSE:=65306, exit:=6530, globalinit
,	This_PiD:= DllCall("GetCurrentProcessId")
tray64:="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"
return,