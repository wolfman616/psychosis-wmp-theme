a_scriptStartTime:= a_tickCount ; (MW:2022) (MW:2022)
#NoEnv 
menu,tray,icon,% "C:\Icon\24\Gterminal_24_32.ico"
; #IfTimeout,200 ;* DANGER * : Performance impact if set too low. *think about using this*.
; ListLines,Off 
#persistent 
#Singleinstance,	Force
#include C:\Script\AHK\- _ _ LiB\GDI+_All.ahk
DetectHiddenWindows,On
DetectHiddenText,	On
SetTitleMatchMode,	2
SetTitleMatchMode,	Slow
Setworkingdir,% (splitpath(a_AhkPath)).dir
;SetBatchLines,		-1
SetWinDelay,		-1
coordMode,	ToolTip,Screen
coordmode,	Mouse,	Screen
OnMessage(0x3,"wmmove")
OnMessage(0x46,"POSCHANGING")
OnMessage(0x47,"POSCHANGED")
OnMessage(0x201,"wmLBD")
OnMessage(0x202,"wmLBU")
OnMessage(0x404,"AHK_NOTIFYICON")

loop,parse,% "VarZ,MenuZ",`,
	 gosub,% a_loopfield
global eXstyles:= 0x08000008
, TrPos, Ratio_SliderL, durSecs, Current_T, Current_T_Old, Playing
, gui_zpos,gui_pos1,ImgFilePath1,hWNd1, chkd, TranspSld_hWNd, parhWNd
, Rdy2Calc:=true,  AppVol, opt_topmost:= true, topmst, incr_Transp, durSecs, durSecsold, faggots
, Transp_W:= 1920, Transp_H:= 32
 
global TranspSlider_X:= (a_screenwidth -Transp_W), TranspSlider_Y:= (a_screenheight -Transp_H*1.5)
, TranspSlider_L:= Transp_W-20, transpSliderVal ;780
, transpSliderVal:= 0, transpSliderValold,sliderhWNd
, Transpvol_W:= Transp_W*.25 , Transpvol_H:= 32
, TranspVol_L:= Transpvol_W-20, TranspVol_hWNd, Childvol_slider ;780
, TranspVol_X:= (a_screenwidth -Transp_W)+999, TranspVol_Y:= (a_screenheight -Transp_H*3)
, TransBack_Amt:= 40, AppVol, PlyMrk_W, PlyMrk_H,to_theLeft 
, WMPMatt:= "wmp_Matt.ahk ahk_class AutoHotkey"
, Playmark_X:= x, Playmark_Y:= a_screenheight-82
, ImgFilePath1:= "C:\Script\AHK\GDI\images\mj_turq3.png"
, ImgFilePath2:= "C:\Script\AHK\GDI\images\3.PNG"
, ImgFilePath3:= "C:\Script\AHK\GDI\images\topbar2.png"
, DelayPlayinc:= 94
onexit,clean
wm_allow()
Result:= TxCopyData("Transp_init",WMPMatt)
sleep,700 
AppVol-=12

opt_topmOst? topmst:="+alwaysontop" :  topmst:= ""
styles:=Format("{1:#x}",styles:=0x940A0000 -0x80000000 +0x40000000)
gui,Par:New,% "-DPIScale " topmst " +hWNdparhWNd -Caption +e0xa080000 +" styles
gui,Trn:New,+e%eXstyles% +%styles% -DPIScale +toolwindow %topmst% +hWNdTranspSld_hWNd -Caption ;+parentpar
gui,Trn:Add,Slider,Range0-10000 AltSubmit NoTicks w%Transp_W% H%Transp_H% +hWNdsliderhWNd gSlider_Labl vtranspSliderVal -0x10000,% Current_T
;gui,Tcv:New,0x540a0000
gui,Vol:New,+e%eXstyles% -DPIScale +toolwindow %topmst% +hWNdTranspVol_hWNd -Caption  ;+parentpar
gui,Vol:Add,Slider,Range0-1000 AltSubmit NoTicks w%Transpvol_W% H%Transpvol_H% +hWNdChildvol_slider vAppVol -0x10000
gui,Trn:Show,NA Hide x%TranspSlider_X% y%TranspSlider_Y%
gui,Vol:Show,NA Hide x%TranspVol_X% y%TranspVol_Y%
style(TranspSld_hWNd, styles)
style(TranspVol_hWNd, styles)
;gui,Par:show,na  w%Transp_W% h64 x%TranspSlider_X% y%TranspSlider_Y%
; DllCall( "AnimateWindow","Ptr",TranspSld_hWNd,"Int",200,"UInt",0x90000)
trans(TranspSld_hWNd,TransBack_Amt)
trans(TranspVol_hWNd,TransBack_Amt)
;winset transcolor,000000 200,ahk_id %TranspVol_hWNd%
;winset transcolor,000000 200,ahk_id %TranspSld_hWNd%
; create 2nd pic; "the desired image"
 gui_pos1	:= "x" a_screenwidth-398 " y" Playmark_Y
 gui_zpos	:= "+UIBand", gui_noactiv81:= "NoActivate"

TrPos:= wingetpos(TranspSld_hWNd)
,Ratio_SliderL:= 101/TranspSlider_L
,Ratio_volL:= 101/TranspVol_L

Result:= TxCopyData("Transp_init",WMPMatt)
sleep,300

timer("Playmark_Init",-1000)
timer("ani1",-20)
timer("ani3",-21)
timer("ani2",-22)

OnMessage(0x04a,"RX_WM_COPYDATA")
OnMessage(0x20A,"WM_MWheel")
return, ;GUI_SHOWN;
;-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'-~'

WinMove(hWNd="",X="",Y="",W="",H="") {
	return,DllCall("SetWindowPos","uint",hWNd,"uint",0,"int",x,"int",y,"int",w,"int",h,"uint",16389)
}

POSCHANGING(wParam,lParam) {
	return,0
}

POSCHANGED(wParam,lParam) {
	return,0
}
clean:

exitapp
return,

;-= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ -= ¬ 
Playmark_Init:

hWNd1:= 1mgdr4w(ImgFilePath1,1,Playmark_X,Playmark_Y,"br")
winset,eXstyle,+0x08800020,ahk_id %hWNd1%
style(hWNd1,"-0x040a0000"), style(hWNd1,"+0x08000000")
hWNd2:= 1mgdr4w(ImgFilePath2,2,1920,1160,"br")
WinMove(hWNd2,1920,1160) ;TranspSlider_X ,Playmark_Y) 

return,

TranspDrag: ;Rdy2Calc:= True
if(!(s:=getkeystate("lbutton","p"))) {
	settimer,TranspDrag,off
	Rdy2Calc:=true
	settimer,a_mittig8,-2000
	return,
}
mousegetpos,xxx,,mhWNd ;(xxx<(TranspSlider_X+32)? Result:= TxCopyData("x0",WMPMatt), return())
if(!(xxx>TranspSlider_X)){
	to_theLeft:=true	;winmove(hWNd1,TranspSlider_X,Playmark_Y)
	WinMove(hWNd1,TranspSlider_X ,Playmark_Y) 
	settimer,a_mittig8,-1000 
	ssleep(20)
} else {
	transpSliderVal:= (((Tagg:= xxx-TranspSlider_X-32) *Ratio_SliderL)) 
	(!transpSliderValold?	transpSliderValold:= transpSliderVal : (transpSliderValold= transpSliderVal? return() 
	: (Result:= TxCopyData("x" transpSliderVal,WMPMatt),transpSliderValold:= transpSliderVal)))
	try,guicontrol,,% sliderhWNd,% transpSliderVal*100
	WinMove(hWNd1,xxx ,Playmark_Y,"","") ;x=3042; +((transpSliderVal/Ratio_SliderL)+32)
	settimer,a_mittig8,-1000
}
return,

VolDrag:
mousegetpos,xx,,mhWNd

AppVol:= (vagg:= (xx-TranspVol_X)-25) *Ratio_volL
, Result:= TxCopyData("v" AppVol,WMPMatt)
try,guicontrol,,% Childvol_Slider,% AppVol
if(!s:=getkeystate("LButton","P")) {
	Rdy2Calc:= True
	settimer,VolDrag,Off
	return,
} else{
settimer,VolDrag,-10
tt("balllo")
}
return,

wmLBD(wParam="",lParam="",bum="",hWNd="") {
	global TranspVol_hWNd,sliderhWNd,hWNd1,Ratio_volL,TranspSlider_X
	,Ratio_SliderL,transpSliderVal,Rdy2Calc:=true,playing,WMPMatt
	static initd:= False
	hWNd_:= Format("{1:#x}",hWNd)
	if(!Rdy2Calc)
		return,1
	Rdy2Calc:= False
	, Xs:= (lParam &0xffff)-8, Ys:= lParam>> 16
	switch,hWNd_ {
		case,% TranspSld_hWNd,% sliderhWNd: if(playing&&!initd) {
				settimer,Play_Inc,% DelayPlayinc
				settimer,Play_Chk,4000
				settimer,State_Chk,off
				initd:= true 
		} else,if(playing&&initd) {
				initd:= false ;settimer,Play_Chk,delete
				settimer,State_Chk,off
				settimer,Play_Inc,off
				settimer,Play_Inc,% DelayPlayinc
			}
			Result:= TxCopyData("x" transpSliderVal:= (Xs*Ratio_SliderL),WMPMatt)
			guiControl,,% sliderhWNd,% transpSliderVal*100
			;Win_Move(hWNd_1,TranspSlider_X +(transpSliderVal/Ratio_SliderL)+32,Playmark_Y,"","",&0x1)
			settimer,TranspDrag,10
			return,1
		case,% TranspVol_hWNd: Result:= TxCopyData("v" AppVol:= Xs *Ratio_volL,WMPMatt)
		if(AppVol=AppVolRx)
			return,
		settimer,VolDrag,-5
		try,guicontrol,,% Childvol_slider,% AppVol*1000 -12
		Rdy2Calc:=true
		return,1
	}
	Rdy2Calc:=true
	return, ;,1
}

wmLBu(wParam="",lParam="",bum="",hWNd="") {
	; global to_theLeft:=false
	return,
}

WM_MWheel(wParam,lParam) {
	mousegetpos,,,hWNd ;tt(format("{:#x}",wParam))
	if(hWNd=TranspVol_hWNd) {
		shift:= (wParam &0x0004)? true : false
		if(wParam=0x780000||wParam=0x780004||wParam=0x780008) {
			(shift? (AppVol+=10) : (AppVol++))	;wheelup
			Result:= TxCopyData("v" AppVol,WMPMatt)
			try,guicontrol,,% Childvol_slider,% AppVol*10
		} else,if(wParam=0xFF880008||wParam=0xFF880004||wParam=0xFF880000) {
			(shift? (AppVol-=10) : (AppVol--)) ;wheeldown
			Result:= TxCopyData("v" AppVol,WMPMatt)
			try,guicontrol,,% Childvol_slider,% AppVol*10
		}
		tt(AppVol)
		return,
	} else,if(hWNd=TranspSld_hWNd)
		return,
	else,return,
}

RX_WM_COPYDATA(byref wParam,byref lParam) {
	global Current_T,durSecs,sliderhWNd,Playing,transpSliderVal,Ratio_SliderL,hWNd1,AppVol
	static trig
	CopyOfData:= StrGet(NumGet(lParam +2 *a_PtrSize))
	switch,_:= substr(CopyOfData,1,1) {
		case,"d" : 
			durSecs:= LTrim(CopyOfData,"d")
			if(durSecs!=durSecsold) {
				Mins:= floor(mins_:= durSecs /60)
				Secs:= format("{:i}",(mins_-Mins) *60)
				durSecsold := durSecs
			}
			if(Current_T) {
				SVal:= (Current_T *(100 /durSecs))
				if((sval>transpSliderVal+3) || (sval<transpSliderVal-3)) {
					transpSliderVal:=sval
					try,guicontrol,,% sliderhWNd,% sval*100
					settimer,play_inc,% DelayPlayinc
				}
				xt:= TranspSlider_X + (transpSliderVal /Ratio_SliderL)
				WinMove(hWNd1,xt+32,Playmark_Y,PlyMrk_w,PlyMrk_H)
			} else,return,Current_T:= 0.1
			return,
		case,"i" : Current_T:= LTrim(CopyOfData,"i")
			return,
		case,"p" : incr_Transp:= ""
			if(!trig) {
				settimer,Play_Inc,% DelayPlayinc
				Playing:= trig:= True
				return,
			} else {
				settimer,state_chk,off
				Playing:= True
				return,
		}
		case,"s" : Playing:= false, trig:= True
			settimer,play_inc,off
			settimer,play_chk,off
			settimer,state_chk,3200
			return,
		case,"v" : AppVolRx:= LTrim(CopyOfData,"v")
			guicontrol,,% Childvol_slider,% AppVolRx
			return,
	}
	
}

state_chk:
Result:= TxCopyData("c" transpSliderVal:= (Xs *Ratio_SliderL),WMPMatt)
return,

TxCopyData(ByRef StringToSend,ByRef TargetScriptTitle)  { ; WM_COPYDATA.
	VarSetCapacity(CopyDataStruct,3*A_PtrSize,0)
	SizeInBytes:= (StrLen(StringToSend) +1) *(A_IsUnicode? 2:1)
	NumPut(SizeInBytes,CopyDataStruct,A_PtrSize)
	NumPut(&StringToSend,CopyDataStruct,2*A_PtrSize)
	Prev_DetectHiddenWindows:= A_DetectHiddenWindows
	Prev_TitleMatchMode:= A_TitleMatchMode
	DetectHiddenWindows,On
	SetTitleMatchMode,2
	TimeOutTime:= 1400 
	SendMessage,0x4a,0,&CopyDataStruct,,%TargetScriptTitle%,,,,%TimeOutTime%
	DetectHiddenWindows %Prev_DetectHiddenWindows%
	SetTitleMatchMode %Prev_TitleMatchMode%
	return,ErrorLevel
}

play_inc: ;(!faggots? faggots:= 1 : faggots++);
transpSliderVal+= (100/durSecs) *0.1
if(!to_theLeft) {
	xl:= TranspSlider_X +(transpSliderVal /Ratio_SliderL)
	guicontrol,,% sliderhWNd,% transpSliderVal *100 +10
	WinMove(hWNd1,xl+32,Playmark_Y,PlyMrk_W,PlyMrk_H)
	settimer,Play_Inc,% DelayPlayinc
	settimer,Play_Chk,delete
} ;else tt("fucking nigger " to_theLeft)
return,

play_chk: ;tt(Current_T)
Current_T_Old:= Current_T 
try,if((!(chkd:= Current_T*(100/durSecs)))||(!Current_T)) {
	settimer,state_chk,-1
	return,
} ;if(chkd>(transpSliderVal +3) || (chkd<transpSliderVal-3)) {
(!playing? playing:=True)
,Result:= TxCopyData("Transp_Init",WMPMatt)
,chkd:= Current_T:= ""
return,

Slider_Labl:
;tt(transpSliderVal)
return,

vol_Labl:
;Result:= TxCopyData("v" vvol:= Xs *Ratio_volL,WMPMatt)
return,

1mgdr4w(imageFilePath,id_num,xpos="",ypos="",zpos="") {
	global
	pToken:= Gdip_Startup()
	;if(cunt!="")
	;if((pImage2)="") {
	if !pImage2 {
		local gay:=true
		pImage%id_num%:= Gdip_CreateBitmapFromFile(imageFilePath)
	}
	PlyMrk_W:= Gdip_GetImageWidth(pImage%id_num%), PlyMrk_H:= Gdip_GetImageHeight(pImage%id_num%)
	mDC%id_num%:= Gdi_CreateCompatibleDC(0), mBM:= Gdi_CreateDIBSection((mDC%id_num%),PlyMrk_W,PlyMrk_H,32)
	oBM:= Gdi_SelectObject(mDC%id_num%,mBM), pGFX:= Gdip_CreateFromHDC(mDC%id_num%)
	Gdip_DrawImageRectI(pGFX,pImage%id_num%,0,0,PlyMrk_W,PlyMrk_H)
	if( gay) {
	tt("gay")
		(aotop:= (zpos="aot" || zpos="UIBand")? "+AlwaysOnTop" : "")
		gui,Pwn%id_num%:	New,-DPIScale +hWNdhGui%id_num% +alwaysontop
		gui,Pwn%id_num%:	+LastFound -Caption +toolwindow +E0x8080028 
		gui,pic_%id_num%:	New,+alwaysontop -dpiscale +ParentPwn%id_num% %aotop% +ToolWindow +E0x8080028 ;-DPIScale
		gui,pic_%id_num%:	+LastFound -Caption
		if(  xpos="br" || ypos="br"  )
			 gui_pos%id_num%:= ("x" . xpos . " y" . a_screenheight-20)  ; offset to bottom right of display
		else,guipos%id_num%:= ("x" .  xpos . " y" . a_screenheight-20)
		gui,Pwn%id_num%:	Show,% "noactivate " gui_pos%id_num% " w" PlyMrk_W " h" PlyMrk_H
		gui,Pwn%id_num%:	-Caption %aotop%
	}
	DllCall("UpdateLayeredWindow","Uint",hGui%id_num%,"Uint",0,"Uint",0,"int64P",PlyMrk_W|PlyMrk_H<<32
	,"Uint",mDC%id_num%,"int64P",0,"Uint",0,"intP",0xFF<<16|1<<24, "Uint", 2)
	GDI_SelectObject(mDC%id_num%,oBM), Gdi_DeleteObject(mBM)	;if(zpos!="UIBand")
	Gdi_DeleteDC(mDC%id_num%)
	Gdip_DeleteGraphics(pGraphics)		;return,hGui%id_num%
	;Gdip_DisposeImage(pImage%id_num%), 
	Gdip_Shutdown(pToken)	;else,
	return,hGui%id_num%
}
 ; Dynamic Hotkeys. This example should be combined with example #1 before running it.

~^r::
if !ppToken
 ppToken:= Gdip_Startup()  
pBitmapMask:=Gdip_CreateBitmapFromFile("C:\Script\AHK\GDI\images\mtask2.png")
Gdip_BlurBitmap(pBitmap, Blur) ; pImage2:= Gdip_CreateBitmapFromFile("C:\Script\AHK\GDI\images\topbar3.png")
Gdip_SetAlphaChannel(pImage2,pBitmapMask,0,0,1) 
MatrixGreyScale = 0.299|0.299|0.299|0|0|0.587|0.587|0.587|0|0|0.114|0.114|0.114|0|0|0|0|0|1|0|0|0|0|0|1
;pImage2:=Gdip_SetAlphaChannel(pImage2,pBitmapMask,0,0,1); Gdip_Shutdown(ppToken)	;else,
1mgdr4w(ImgFilePath2 ,2,1920,1160,"br")
Gdip_SetImageAttributesColorMatrix(Matrix)
return,

; NumpadAdd::
; Hotkey, If, MouseIsOver("ahk_class Shell_TrayWnd")
; if(doubleup := !doubleup)
    ; Hotkey, WheelUp, DoubleUp
; else,Hotkey, WheelUp, WheelUp
; return,

; DoubleUp:
; Send {Volume_Up 2}
; return,

WMMove(wParam="",lParam="",bum="",hWNd="") {
	return,tt("wm_move `nwparam  - " wParam "`nlParam  - " lParam "`nbum - " bum "`nhwnd - " hWNd)
}

LoWord(Dword,Hex=0) {
	static WORD:= 0xFFFF
	return,(!Hex)? (Dword&WORD) : Format("{1:#x}",(Dword&WORD))
}

HiWord(Dword,Hex=0) {
	static BITS:= 0x10, WORD:= 0xFFFF
	return,(!Hex)? ((Dword>>BITS)&WORD) : Format("{1:#x}",((Dword>>BITS)&WORD))
}

MakeLONG(LOWORD,HIWORD,Hex=0) {
	static BITS:= 0x10, WORD:= 0xFFFF
	return,(!Hex)? ((HIWORD<<BITS)|(LOWORD&WORD)) : Format("{1:#x}"
	,	((HIWORD<<BITS)|(LOWORD&WORD)))
}

ani1:
Win_Animate(parhWNd,"slide hneg",300)
return, ;GUI_SHOWN;

ani2:
Win_Animate(TranspSld_hWNd,"slide hneg",300)
return, ;GUI_SHOWN;

ani3:
Win_Animate(TranspVol_hWNd,"slide hneg",100)
return, ;GUI_SHOWN;

a_mittig8:
;transpSliderValold:= transpSliderVal:=""
xxx:=to_theLeft:=false
return,

eXstyle(hWNd="",eXstyle="") {
	winset,eXstyle,%eXstyle%,ahk_id %hWNd% 
}

style(hWNd="",style="") {
	winset,style,%style%,ahk_id %hWNd%
}

trans(hWNd="",val="") {
	winset,transparent,%val%,ahk_id %hWNd%
}

reload() {
	reload,
	exitapp,
}

menuz:
menu,Tray,NoStandard
menu,Tray,Add,%	 splitpath(a_scriptFullPath).fn,% "do_nothing"
menu,Tray,disable,% splitpath(a_scriptFullPath).fn
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
(ahkexe:= splitpath(a_AhkPath)).fn
,	 (_:= (splitpath(a_scriptFullPath).fn) " Started`n@ " time4mat() "   In:  "
.	_:= (a_tickCount-a_scriptStartTime) " Ms")
sleep,100
_:="", a_scriptStartTime:= time4mat(a_now,"H:m - d\M")
menu,Tray,Tip,% splitpath(a_scriptFullPath).fn "`nRunning, Started @`n" a_scriptStartTime

do_nothing:
return,

MenHandlr(isTarget="") {
	switch,(isTarget=""? a_thismenuitem : isTarget) {
		case,"Open Containing": TT("Opening "   a_scriptdir "..." Open_Containing(a_scriptFullPath),1)
		case,"edit","Open","SUSPEND","pAUSE":
			PostMessage,0x0111,(%a_thismenuitem%),,,% a_ScriptName " - AutoHotkey"
		case,"RELOAD": reload()
		case,"EXIT": exitapp
		default: if(islabel(a_thismenuitem)||isfunc(a_thismenuitem))
			settimer,% a_thismenuitem,-10
	}
	return,
}

AHK_NOTIFYICON(byref wParam="",byref lParam="") {
	switch lParam {
	;	case,0x0206: ; WM_RBUTTONDBLCLK	;	case,0x020B: ; WM_XBUTTONDOWN
	;	case,0x0201: ; WM_LBUTTONDOWN	;	case,0x0202: ; WM_LBUTTONUP
		case,0x0204: 
			return,settimer,menutray,-1 ; WM_RBUTTONdn
		case,0x0203: 
			(_:="",wParam:=""),
			;settimer,ID_VIEW_VARIABLES,-10
			PostMessage,0x0111,%open%,,,% a_ScriptName " - AutoHotkey"
			sleep(80),lParam:=(sleep(11),tt("Loading Var-table...","tray",1)) ; WM_doubleclick  
	}
	return,
}

menutray(){
	global
	Menu,Tray,Show
}

varz:
global	EDIT:=65304, open:=65407, Suspend:=65305, PAUSE:=65306, exit:=6530
global	This_PiD:= DllCall("GetCurrentProcessId")
return,