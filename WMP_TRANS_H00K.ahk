#NoEnv ; (MW:2022) (MW:2022)
#notrayicon
#persistent 
#Singleinstance,	Force
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
SetBatchLines,		-1
SetWinDelay,		-1
onexit,RemoveHooks

hook4g:=  dllcall("SetWinEventHook","Uint",0x0003,"Uint",0x0003,"Ptr",0,"Ptr"
, Proc4g_:= RegisterCallback("on4Gnd",""),"Uint",0,"Uint",0,"Uint",0x0000|0x0002)
return,

on4Gnd(hook4g,event4g,hWnd) { ; initated from taskbar or minimize restore alt tab etc
	static WMPSkin_tCol:= 061119, wmpskinhwndlist:=""
	,WMPSkin_X:= 2934, WMPSkin_Y:= 736
	4gnd_hWnd:= ("ahk_id " . hWnd)
	wingetClass,Class,%			4gnd_hWnd
	switch,Class {
		case,"WMP Skin Host" : winset,transparent,off,ahk_id %hWnd%
			winset,transcolor,%WMPSkin_tCol% 252,ahk_id %hWnd%
	}
}

RemoveHooks:
dllcall("UnhookWinEvent","Ptr",hook4g)
sleep,20
dllcall("GlobalFree","Ptr",hook4g,"Ptr")
hook4g:= ""
return,