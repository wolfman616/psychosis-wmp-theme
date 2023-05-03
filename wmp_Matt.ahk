#NoEnv
#Persistent

#singleinstance 	Force
CoordMode,	Window, Screen
detecthiddenwindows,On
detecthiddentext,	On
settitlematchmode,	2
settitlematchmode,	Slow
SetWorkingDir,		%A_ScriptDir%
;#inputlevel 1
sendMode,Input
SetBatchLines,-1

; Extract and trim with vocal / instrumental AI Requires FFMPEG / AnaCONDA / Python / Spleeter 

#include C:\Script\AHK\Z_MIDI_IN_OUT\extractorgui.ahk
;	#include C:\Program Files\AHK\LiB\VolWMPObjume.ahk
#include C:\Program Files\Autohotkey\LiB\RemoteWMP.ahk
; player.controls.currentPositionTimecode use me https://docs.microsoft.com/en-us/windows/win32/wmp/controls-currentpositiontimecode

init:
global SongOld, SongNew, File2Del, MissingWMPs:=0, Mainvol
, InstantPl, iCoDll, r:=[]
gosub,Varz
global hwnd_,gWnd,CHnd,Colors,GuiArray,NmPad_BList,wmp,wmp,GoDie,Vol_WMP_obj,Vol_WMP
NmPad_BList:= "ahk_exe wmplayer.exe,ahk_exe firefox.exe"

gosub,MenuTray_init

GroupAdd,Explora,ahk_Class CabinetWClass
GroupAdd,Explora,ahk_Class WorkerW

;Anicons:= AniParse_()
OnExit("cleanup")
loop,2
	wm_allow()

OnMessage(0x04a,"Receive_WM_COPYDATA") ; 0x4a is WM_COPYDATA
OnMessage(0x404,"AHK_NOTIFYICON")

main:
gui,Slav3:New ; dummy gui to reg WM_
gui,Slav3:+LastFound +hwnd_Hw1nd ; +ToolWindow Hwnd:= WinExist() also works
gui,Slav3:Show,na hide ,% "wNp_matt_wmp"

;gosub,NmPad_Togl_i ; numpd bypass add shit to string above;hotkey, +<^>!Space,	PauseToggle, on;hotkey, <^>!Space,	PauseToggle, on
regWrite,REG_DWORD,% hkcuWMPprefs:= "HKEY_CURRENT_USER\Software\Microsoft\MediaPlayer\Preferences",% "1",% "1"
if(!fileexist(c0nda))
	AnaCONDA:= False
process,exist,ahk_exe WMPlayer.exe
if(Errorlevel) {
	winwait,ahk_exe WMPlayer.exe
	return, ;else { ; run,% "C:\Proahk_exe WMPlayer.exegram Files\Windows Media Player\WMPlayer.exe" ;
} run,% "WMP_colour_controls_test.ahk"
hndL:= GetHandle()
winget,PiDWmP,PiD,ahk_exe WMPlayer.exe
Vol_WMP:= (Vol_WMP_obj:= New AppVolume(PiDWmP)).GetVolume()
; VA_ISimpleAudioVolume_GetMasterVolume("{87CE5498-68D6-44E5-9215-6DA47EF883D8}",fLevel)
; VA_ISimpleAudioVolume_SetMasterVolume("{87CE5498-68D6-44E5-9215-6DA47EF883D8}",fLevel,GuidEventContext="")
; VolMaster:= (volMasterObj:= New AppVolume()).GetVolume()
Soundget,VolMaster
tt("Master: " VolMaster "`nWMP: " Vol_WMP,"tray",3)
 WMP:= New RemoteWMP
 Media:= WMP.player.currentMedia
,SongNew:= Media.sourceURL
,Controls:= WMP.player.Controls
,id3Art:= iD3_Artist(SongNew)
,id3Ttl:= iD3_Track(SongNew)
if((id3Art="0")||(id3Art="0")) {
	SplitPath,SongNew,tOutFileName,tOutDir
	id3Art:= tOutDir . "\"
	,id3Ttl:= tOutFileName ; goto,PlayPstateUpdateInterval
} else,newiD3full:= iD3_StringGet(SongNew)
SplitPath,SongNew,,OutDir,OutExtension,OutNameNoExt,OutDrive
(!newiD3full? newiD3full:= OutNameNoExt)
settimer,PlayPstateUpdateInterval,% PlayPstateUpdateInterval:= (((PlayState:= WMP.player.PlayState)=3)? 2500:4700)
return,

Skinhandle() {
	controlget,CListWnd,hWnd,,ATL:SysListView321,Ahk_Class WMP Skin Host
	return,CListWnd
}

if(PlayState=3) { ; Playing=3
	trigger_PL:= True, trigger_pa:= False 
	Pstate(On)
	trayTip,% "Playing",% id3Art " - " id3Ttl,3,33
	menu,tray,Tip,% "WMPlayer - Playing`n" newiD3full
	(TranspGui?	Send_WMCOPYDATA("p" . current ,"wmp_transp.ahk ahk_class AutoHotkey"))
} else {
	trigger_PL:= False
	Pstate(Off)
	menu,tray,Tip,% "WMPlayer - Paused`n" newiD3full
	trayTip,% ("WMP Paused"),% (id3Art " - " id3Ttl),3,33
}
loop,5
	sleep,50
return,

Check_YASKIN:
_:=winexist("Ahk_Class WMP Skin Host")
DllCall("SetWindowBand","ptr",_,"ptr",0,"uint",18,"uint")
if(!CListWnd) {
	controlget,CListWnd,hWnd,,ATL:SysListView321,Ahk_Class WMP Skin Host
	timer("Check_YASKIN",!CListWnd?-128000:"off")
} if(CListWnd)
	winget,style,style,ahk_id %CListWnd%
if(style&0x300000) 
	winset,style,-0x300000,ahk_id %CListWnd%
else,if(style&0x200000)
	winset,style,-0x200000,ahk_id %CListWnd%
else,if(style&0x100000)
	winset,style,-0x100000,ahk_id %CListWnd%
settimer,Check_YASKIN,-64000
return,

cleanup() {
	loop, parse,% "WMP,WMP2,wmp",`,
	{
		(%a_loopfield%):= Delete RemoteWMP
		ObjRelease(%a_loopfield%)
	}
	Vol_WMP_obj:= Delete AppVolume 
	ObjRelease(%Vol_WMP_obj%) 
	Vol_WMP_obj:=""
	;exitapp,
}

Cutcurrent: ;cur_:= "anicur_drip" ; settimer,anicur_,-20,-2147483648;
Path2File=% WMP.player.currentMedia.sourceURL
if(InvokeVerb(Path2File,"Cut")) { 
	process,Exist
	hwnd:= WinExist("ahk_class tooltips_class32 ahk_pid " Errorlevel)
}
Menu,tray,Icon, % "copy.ico"
Monster_Clip:= clipboard
settimer,Clip_Commander,-1000
return,

playy:
WMP.player.Controls.play()
return,

PauseToggle:
WMP.togglePause()
return,

JumpPrev: ; cur_:= "AniCur_Pink" ; settimer,AniCur_,-2,-2147483648 ;
if(!WMP) {
	missingwmps++
	;try,WMP:= Delete RemoteWMP
	;;WMP:= New RemoteWMP
}
WMP.player.Controls.Stop()
sleep, 20
WMP.player.Controls.Previous()
sleep, 20
Media:= WMP.player.currentMedia

thecall2:
gosub,WMP_Refresh_2
if(SongNew=SongOld) {
	sleep,100
	goto,thecall2
} else {
	duration:= Transparency_Inc:=""
	WMP.jump(Offset_Start)
	sleep,150
	WMP.player.Controls.play()
}
return,

/* 
youtube_next:
sendinput, {Media_Next}, chrome
 */

JumpNext: ;settimer, PlayPstateUpdateInterval, off
PosReal:= False, genre:= gnr:= SongNew:= ""
(!WMP? MissingWmps++)
WMP.player.Controls.Stop()
,WMP.player.Controls.Next()
,WMP.jump(Offset_Start)
,WMP.player.Controls.play()
Pre_compare: ;cur_:= "AniCur_bfly" ;settimer,AniCur_,-200,-2147483648;
SongNew=% WMP.player.currentMedia.sourceURL
iD3full:= iD3_StringGet2(SongNew)

thecall1:
sleep,250
if(SongNew=SongOld) {
	f_Htry:= True, (!Tries)? Tries:= 1 : ((Tries++<5)
	? (ssleep(250), goto("Pre_compare")) : (Tries:= 0))
} else {
	duration:= Transparency_Inc:= "", f_Htry:=	False
	, iD3full:= iD3_StringGet2(SongNew), SongNew:= SongOld
	, timer("Check_YASKIN",-20), PosReal:= GetPos() 
	if(PosReal) {
		sleep,500
		if(AutoScroll)
			SendMessage 0x1014,0,((PosReal *23)-150),,ahk_id %hndL% ;LVM_SCROLL.0x1014;;else,Tooltip,% "ERROR"
	} settimer,tooloff,-2000
	gosub,Genre_Search
	if(GoDie||pastenskip) {
		PosReal--
		goto,POST_GASM
}	}
return,

lalt & Pause::
~^!escape::
exitapp,

SearchSlSk:
setbatchlines,20 ;(!WMP?	WMP:= New RemoteWMP, missingwmps++)
Controls:= WMP.player.Controls, Media:= WMP.player.currentMedia
FullPath=% Media.sourceURL
process,exist,slsk2.exe		;"Windows Media Player"
msgb0x( (!ErrorLevel)? tt("Launching SlSk...`nTarget: " FullPath)
 : tt("SlSk returning from nap...`nNew target: " FullPath))
SplitPath,FullPath,,,,OutNameNoExt
2nd:=RegExReplace((1st:= RegExReplace(OutNameNoExt,Needle4," ")),Needle2, " ")
runwait,%	"C:\script\AHK\Working\slsk fix.ahk"
winGetPos,,,Width,Height,%WinTitle%
mouseGetPos,Orig_X,Orig_Y
BlockInput,	On
mouseMove,	145,90
send,		{LButton}
sendinput,% Stripped_Name:= RegExReplace(2nd,Needle3," ")
send,		{Enter}
mouseMove,	1787,218
send,		{LButton}
mouseMove,	Orig_X,Orig_Y
BlockInput,	Off
return,

SearchYT:
SplitPath,%	(UNC:=	((wmp.player.currentMedia).sourceURL)),,,,Name
name			:=	RegExReplace(name,	"i)\-" , " ")
1st				:=	RegExReplace(Name,	Needle4, " ")
2nd				:=	RegExReplace(1st,	Needle2, " ")
Stripped_Name	:=	RegExReplace(2nd,	Needle3, " ")
ytsearchstn		:=	""" " . Stripped_Name . " """ 
Run,% "firefox.exe -new-tab " ytsearchstr . ytsearchstn 
return,

SearchExp:
gosub,WMP_Refresh_2
gosub,Genre_Search
trayTip,Windows Media Player,path
FullPath:= SongNew
SplitPath,FullPath,,,,OutNameNoExt
run,explorer.exe %Search_Root%
winWaitActive,ahk_exe explorer.exe,,5
sleep,	1000
send,	{ctrl}{f}
sleep,	1500
send,%	Stripped_Name:= RegExReplace((2nd:= regExReplace((1st:= regExReplace(OutNameNoExt,Needle4," "))
		,Needle2," ")),"( . )|(^[a-z][\s])|( )|( )|( )|[.]", " ")
sleep,	500
send,	{enter}
return,

Genre_Search:
p 		:=	1, Matched_String:= "",	genre:= ""
o		:=	comobjcreate("Shell.Application")
SplitPath,z,file,directory,ext
od		:=	o.namespace(directory)
of		:=	od.parsename(file)
gnr		:=	od.getdetailsof(of,16) ; genre
while p:=	RegExMatch(SongNew, Genres, Matched_String, p + StrLen(Matched_String)) {
	switch,Matched_String {
		case,"reggae"	: Offset_Start:=11.5,p:=999,Genre:="reggae",Search_Root:="S:\- REGGAE"
		case,"rocksteady":Offset_Start:=11.5,p:=999,Genre:="reggae",Search_Root:="S:\- REGGAE"
		case,"riddim"	: Offset_Start:=11.5,p:=999,Genre:="riddim",Search_Root:="S:\- REGGAE"
		case,"Drum & Bass","dnb","drum and bass","jungle","intelligent","oldskool" :Offset_Start:=86
		,p:=999, Genre:="dnb", 	Search_Root:="S:\- DNB"
		case,"hiphop"	: Offset_Start:=17,	p:=999, Genre:="hiphop",Search_Root:="S:\- HIPHOP"
		case,"garage"	: Offset_Start:=45,	p:=999, Genre:="garage",Search_Root:="S:\- - MP3 -\Garage"
		case,"rock"		: Offset_Start:=17,	p:=999, Genre:="rock", 	Search_Root:="S:\- - MP3 -\- Other\Rock"
		case,"ambient"	: Offset_Start:=30,	p:=999, Genre:="ambient",Search_Root:="S:\- - MP3 -\Chill"
		case,"samples"	: Offset_Start:=0,	p:=999, Genre:="samples",Search_Root:="S:\Samples"
		case,"my music" : Offset_Start:=0,	p:=999, Genre:="my music",Search_Root:="S:\Documents\My Music"
		case,"audiobooks":Offset_Start:=0,	p:=999, Genre:="audiobooks",Search_Root:="S:\Documents\My Audio"
		case,"_SLSK_"	: Offset_Start:=45,	p:=999, Genre:="sLSk"
		case,"FOAD"		: Offset_Start:=0,	p:=999, Genre:=""
	}
	if(gnr="dnb")||(gnr="drum & bass")||(gnr="drum&bass")||(gnr="drum n bass")
		Offset_Start:=86, p:=999, Genre:="dnb",		Search_Root:="S:\- DNB",  f_H	:=1
	else,if(gnr="Reggae")|| (gnr="Dancehall")||(gnr="Ragge")||(gnr="Riddim") 
		Offset_Start:=11.5, p:=999, Genre:="reggae",Search_Root:="S:\- REGGAE", f_H	:=1
	else,if(gnr="Hip-Hop")|| (gnr="HipHop")||(gnr="Rap")||(gnr="Gangster Rap") 
		Offset_Start:=17, p:=999, Genre:="hiphop",	Search_Root:="S:\- HIPHOP", f_H	:=1
	else,if(gnr="Garage")|| (gnr="2 Step")||(gnr="Bassline")
		Offset_Start:=45, p:=999, Genre:="garage",	Search_Root:="S:\- - MP3 -\Garage", f_H	:=1
	else,if(gnr="Rock")|| (gnr="Rock n Roll")||(gnr="Metal")
		Offset_Start:=17, p:=999, Genre:="rock",	Search_Root:="S:\- - MP3 -\- Other\Rock", f_H:=1
	else,if(gnr="Ambient")|| (gnr="Chill Out")
		Offset_Start:=30, p:=999, Genre:="ambient",	Search_Root:="S:\- - MP3 -\Chill", f_H:=1
	else,if(gnr="Spoken Word")|| (gnr="Audiobook")
		Offset_Start:=0, p:=999, Genre:="audiobooks",Search_Root:="S:\Documents\My Audio", f_H:=1
	}
return,

WMP_Refresh: 
(!WMP? MissingWmps++)
try,{ 
	Controls:= WMP.player.Controls
	, Media:= WMP.player.currentMedia
}
return,

WMP_Refresh_2:
(!WMP? MissingWmps++)
try,{
	Controls:= WMP.player.Controls
	, Media:= WMP.player.currentMedia
} SongNew =% WMP.player.currentMedia.sourceURL
id3Art:= iD3_Artist(SongNew), id3Ttl:= iD3_Track(SongNew)
if(strlen(Media2del)>1)
	goto,Delete_
prOcess,Exist,WMPlayer.exe
sleep,200
DelCurrent:
Media2del:= wmp.player.currentMedia
sleep,100
File2Del=% Media2del.sourceURL
iD3full2:=iD3_StringGet(File2Del), id3Art2:= iD3_Artist(File2Del)
id3Ttl2:= iD3_Track(File2Del), idd_:= iD3full ;gosub,NowPlayingList_DelCurrent
settimer,JumpNext,-1 ;gosub,JumpNext
if(strlen(Media2del)>1) {
msgbox
setTimer,Delete_,-900 ;settimer,NowPlayingList_DelCurrent,-1
}
return,

Delete_:
FileRecycle,% File2Del
sleep.250
if(FileExist(File2Del)) {
	FileRecycle,% File2Del ;trayTip,Windows Media Player,Deleted %File2Del%,3,1
	if(!errorlevel&&!(FileExist(File2Del)) ) {
		tooltip % "Deleted: `n" iD3full2
	} else {
		ARRAYWANK:
		Deletearr.push(File2Del)
		for,index,element in Deletearr
		{
			if(FileExist(element)){
				File2Del:= element
				gosub,Delete_
				if(FileExist(element)) {
					tooltip % "You spiN,not good"
					settimer,tooloff,-1200
					FileRecycle,% element 
				} else {
					tooltip,% "Right round baby gg"
					DEADFILE:= Deletearr.pop(element) 
					settimer,tooloff,-1200
	}
}	}	}	}

if(!(exist:= FileExist(File2Del))) {
	trayTip,% "Deleted...",% id3Art2 " - " id3Ttl2,3,33
	File2Del:=Media2del:=""
	sleep,222
	gosub,cleanup
	gosub,WMP_refresh
	return,
} else {
	reTries++
	if(reTries>25) {
		msgbox,unable to Delete after 25
		gosub,cleanup
		gosub,WMP_refresh
		exit
	} else {
		sleep,400
		goto,Delete_
}	}
return,

add2Playlist:
Media:= WMP.player.currentMedia
Controls:= WMP.player.Controls
FullPath=% Media.sourceurl
if(fileexist("New_Playlist.m3u")) {
	if(!fileexist("Playlist.m3u"))
		fileMove,New_Playlist.m3u,Playlist.m3u
	else,try,{
			if(!fileexist(Playlist%p_Item%.m3u))
				fileMove,New_Playlist.m3u,Playlist%p_Item%.m3u
		} catch {
			p_Item:= p_Item+1
			SLEEP,80
		}
} else,FileAppend,%fullpath%`n,New_Playlist.m3u
return,

Dr:
SecsDuration:= (round(media.getItemInfo("Duration")))
Sample_Duration_min:= (Floor(SecsDuration/60))
if(Sample_Duration_Hr:= (Floor(Sample_Duration_min/60)))
	 Sample_Duration_min:= Sample_Duration_min-(Sample_Duration_Hr*60)
Sample_Duration_Sec:= (SecsDuration-(Sample_Duration_min*60))
Output_Duration=%Sample_Duration_Hr%:%Sample_Duration_min%:%Sample_Duration_Sec%
if(!Split)
	 extract_data_1=%OutDir%\%OutNameNoExt% - Extract.%OutExtension%
else,extract_data_1=%OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
if(instr(OutNameNoExt, "Trimmed"))
	 Output_FullUnc=%OutDir%\%OutNameNoExt%.%OutExtension%
else, Output_FullUnc=%OutDir%\%OutNameNoExt% - Trimmed.%OutExtension%
	fileGetTime,Old_D8,%FullPath%,m ;if errorlevel	;msgbox error
msgbox,% Output_FullUnc
run,%comspec% /c ffmpeg -i "%FullPath%" -ss 0:0:0 -to %extract_starttime% -c:v copy -c:a copy "%extract_data_1%",,hide

if(!trim2end) {
	msgbox,% "!trim2end 1" 
	extract_data_1=%OutDir%\%OutNameNoExt% - 1st half.%OutExtension%
	extract_data_2=%OutDir%\%OutNameNoExt% - 2nd half.%OutExtension%
	run,%comspec% /c ffmpeg -i "%FullPath%" -ss %extract_endtime% -to %Output_Duration% -c:v copy -c:a copy "%extract_data_2%",,hide
	if(Split)
		goto,Check_Output2
	FileAppend,file '%extract_data_1%'`n,% xtractData_Cc
	FileAppend,file '%extract_data_2%'`n,% xtractData_Cc
	sleep,% S
	msgbox,snkl
	runWait,%comspec% /c ffmpeg -y -f concat -safe 0 -i "%xtractData_Cc%" -c copy "%Output_FullUnc%",,hidden
	fileDelete,% extract_data_1
	fileDelete,% extract_data_2
	fileDelete,% xtractData_Cc	;FileRecycle, %FullPath%
} else,Output_FullUnc:= extract_data_1
loop,40
	if(!(PlayState:= fileexist(Output_FullUnc)))
		sleep,500
	else,break

if(trim2end)
	msgbox,% Output_FullUnc "`n2"
fileMove,% extract_data_1,% Output_FullUnc

Check_Output2:
sleep,% S
Output_FullUnc:=(Input_Filename_Full . "\" . (Output_Prefix:= OutNameNoExt) . "." . OutExtension)
if(PreserveFileDate) {
	fileSetTime,% Old_D8,% extract_data_1
	fileSetTime,% Old_D8,% extract_data_2
}
if(replaceoriginal)
	fileRecycle,% FullPath	;Output_FullUnc:= FullPath
settimer,check_3,-2000
return,

check_3:
if(!fileExist(FullPath)) {
	fileMove,% Output_FullUnc,% FullPath
} else {
	(!tried)? tried:=1 : tried++ 
	goto,Check_Output2
}
return,

Clip_Commander:
if(clipboard!=Monster_Clip) {
	settimer,Clip_Commander,off
	menu,tray,Icon,WMP.ico
}
return,


hwndGetMain(){
	winget,mainhand,id,ahk_class WMP Skin Host
	return,mainhand
}

SLsk_Rescue:
run,% SLsk_Rescue
return,

jmp(pos) {
	global wmp	;msgbox,% Current "d " pos "df "
	wmp.jump(Current*pos)
}

CloseCallback(GuiName) {
	try,gui,%GuiName%:Destroy
}

cleanup:
reTries:= 1,File2Del:=Media2del:=exist:=File2Del:=iD3full2:=id3Art2:=id3Ttl2:="" ;wmp:= Delete RemoteWMP
return,

Receive_WM_COPYDATA(byref wParam,byref lParam) {
	global Time_ExCat,CopyOfData
	CopyOfData:= (StrGet(NumGet(lParam + 2*A_PtrSize)))
	settimer,WM_COPYDATA_1,-20
	return,1
}

WM_COPYDATA_1() {
	switch,anus:= substr(CopyOfData,1,1) {
		case,"X" : settimer,WM_COPYDATA_2,-20 ;jmp(Time_ExCat:= LTrim(CopyOfData,"x")) 
		case,"v" : settimer,volTransp,-20
		default  : switch,CopyOfData {
			case,"Transp_Init" : TranspGui:= True
			settimer,Deets2Transp,-1
			case,"c" : settimer,Deets2Transp,-20
			default: settimer,% CopyOfData,-20
	}	}
	return,
}

WM_COPYDATA_2() {
	Time_ExCat:= LTrim(CopyOfData,"x")
	PlayPstateUpdateInterval()
	sleep,20 ;tt(Time_ExCat)
	Time_ExCat:= ""
	return,
}

Deets2Transp:
TranspGui:= true
(!WMP? MissingWmps++)
Media:= WMP.player.currentMedia
Controls:= WMP.player.Controls

Check_PS:
try,Duration:= WMP.player.currentMedia.getItemInfo("Duration")
PlayState:= WMP.player.PlayState ; 
Current:= WMP.player.Controls.currentPosition ;msgbox,% Duration " " current
Send_WMCOPYDATA("v" . Vol_WMP,"wmp_transp.ahk ahk_class AutoHotkey")
Send_WMCOPYDATA("i" . Current:= WMP.player.Controls.currentPosition,"wmp_transp.ahk ahk_class AutoHotkey")
Send_WMCOPYDATA("d" . Duration,"wmp_transp.ahk ahk_class AutoHotkey")
((PlayState="3")? (Send_WMCOPYDATA("p","wmp_transp.ahk ahk_class AutoHotkey"), playing:= true, timer("Check_PS",-5000))
: (Send_WMCOPYDATA("s","wmp_transp.ahk ahk_class AutoHotkey"), playing:= false, timer("Check_PS",-5000)))
return,

volsend_transp:
Send_WMCOPYDATA("v" . Vol_WMP,"wmp_transp.ahk ahk_class AutoHotkey")
return,

#u::
volTransp:
CVOL:= LTrim(CopyOfData,"v") ;tt(CVOL)
if(!Vol_WMP_obj) {
	winget,PiDWmP,pid,ahk_exe wmplayer.exe
	Vol_WMP_obj:= New AppVolume(PiDWmP)v:= VolWMPObj.GetVolume()
} if(CVOL!=v)
	VolWMPObj.SetVolume(CVOL)
return,

Open_Containing:
(!WMP? MissingWmps++)
, Media:= WMP.player.currentMedia
UNC=% Media.sourceURL
if(!Fileexist(UNC))
	msgb0x("Media",UNC . "`nWas not found in its previous location.",2500)
	,return()
o:= comobjcreate("Shell.Application")
SplitPath,UNC,file,directory,ext
if(!errorlevel) {
	od:= o.namespace(directory)
	of:= od.parsename(file)
	gnr:=od.getdetailsof(of,16) ;16=genre;
}
Controls:= WMP.player.Controls
SplitPath,UNC,,OutDir,OutExtension,OutNameNoExt
if(!isDirOpen:= explorer_checkpathopen(UNC)) {
	sleep,250
	2nd:= RegExReplace((1st:= (RegExReplace(UNC,"^.+\\|\.[^.]+$"))),"[']|[`]|[)]|[(]|[_]|( )|( )|(YouTube)"," ")
	clipboard:= RegExReplace(2nd,Needle3," ") ;"( . )|( )|( )|( )" ; maybe usefull to expand search scope.
	run,%COMSPEC% /c explorer.exe /select`,"%UNC%",,Hide ;ExplSHELLopen() tt("opening " OutDir "...+", 1000)
	sleep,% S
	sendInput,{F5}
} else {
	winactivate,ahk_id %isDirOpen%
	sleep,252
	fpath:= (OutNameNoExt . "." . OutExtension) ;;ControlClick , DirectUIHWND3, ahk_id %isDirOpen%	;  could do with checking if the target is already selected
	ControlSend,DirectUIHWND3,% fpath,ahk_id %isDirOpen%
} 1st:= 2nd:= UNC:= ""
return,

xtractmenu_open:
(!Secs2Sample_Start? Secs2Sample_Start:= "0", msgb0x("undefined region"))
settimer,GUI_,-1
return,

FIXW:  
return
(!hndL)? hndL:= GetHandle() : ()
sleep,500
s:= GetHandle2("ToolbarWindow323") 
SendMessage 0x0454,0,0x00000089,,ahk_id %s% ;TB_SETEXTENDEDSTYLE=0x0454 tbstyle_Ex_doublebuffer 0x80
f:= GetHandle2("ToolbarWindow324") 
SendMessage 0x0454,0,0x00000089,,ahk_id %f% ;tooltip % "Opacity tempfix applied`nfuck off "
n:=hwndGetMain() ;tooltip % n settimer,tooloff,-3000
return,

Restart_WMP:
(WMP? WMP:= delete RemoteWMP, ssleep(1800)) ;,;WMP:= New RemoteWMP)
sleep,% S
Media:= WMP.player.currentMedia, Path2File:=Media.sourceURL
, Controls:= WMP.player.Controls, time:= round(controls.currentPosition)
try,Process,Close,WMPlayer.exe 
sleep,% S
process,exist,WMPlayer.exe 
if(errorlevel)
	try,Process,Close,WMPlayer.exe 
sleep,% S
process,exist,WMPlayer.exe 
if(errorlevel)
	run,taskkill /F /IM WMPlayer.exe 
sleep,% S
run,WMPlayer.exe "%Path2File%"
sleep,% S
return,

NmPad_Togl:
NmPad_Togl:= !NmPad_Togl
NmPad_Togl_i:
if(NmPad_Togl) {
	menu,tray,check,Disable Numpad
	if(!num_init_trigger) {
		num_init_trigger:= True
		loop,10 {
			aa:= (a_index-1)
			Loop,Parse,NmPad_BList,`,
			{
				Hotkey,IfWinActive,% a_loopfield
				Hotkey,% "Numpad" .aa, zz
				numpadkeys_str:= (numpadkeys_str . "," . "Numpad" . aa)
				,NumPKeysArr.Push("Numpad" . aa)
		}	}
		Loop,Parse,num_others, `,
		{
			bb:= a_loopfield
			Loop,Parse,NmPad_BList, `,
			{
				Hotkey,IfWinActive, % a_loopfield
				Hotkey,% bb, zz
				numpadkeys_str:= (numpadkeys_str . "," . bb)
				,NumPKeysArr.Push(bb)
		}	}
	} else {
		for,index,element in NumPKeysArr
			Hotkey,% element, zz
	}
} else {
	menu,tray,uncheck,Disable Numpad
	if(!num_init_trigger) {
		num_init_trigger:= True
		loop,10 {
			cc:= (a_index-1)
			Loop,Parse, NmPad_BList, `,
				Hotkey, IfWinActive, % a_loopfield
				Hotkey, % "Numpad" . cc, zz
				numpadkeys_str:= (numpadkeys_str . "," . "Numpad" . cc)
				,NumPKeysArr.Push("Numpad" . cc)
		}
		Loop,Parse, num_others, `,
		{
			Loop,Parse,NmPad_BList, `,
				Hotkey,IfWinActive, % a_loopfield
				Hotkey,% a_loopfield, zz
				numpadkeys_str:= (numpadkeys_str . "," . a_loopfield)
				,NumPKeysArr.Push(a_loopfield)	
		}
	} else {
		for,index,element in NumPKeysArr
			Hotkey,%element%,off
}	}
return,

zz: ;TOOLTIP FGS;
bt:= a_thishotkey
if(bt contains "$" && bt!=$)
	bt:= strreplace( bt, "$")
if(bt contains "^" && bt!=$)
	bt:= strreplace( bt, "^", "Control + ")
if(bt contains "!" && bt!=$)
	bt:= strreplace( bt, "!", "Alt + ")
TT((bt . " Disabled."))
return,

ZinOut: ;midi in out script;
a="C:\Program Files\AutoHotkey\AutoHotkeyU32.exe" "C:\Script\AHK\Z_MIDI_IN_OUT\z_in_out.ahk"
run,% a,,hide
return,

PlayPstateUpdateInterval(interval:=5000) { ;wip;
	global Time_ExCat
	global static SongNew,SongOld,WMP
	static Media,Duration,Current,trigger_pa,trigger_pL,Controls,init=0,id3Ttl,id3Art,PlayState:= ""
	(init=0? WMP:= New RemoteWMP, init:= 1)
	Media:= WMP.player.currentMedia, Controls:= WMP.player.Controls, Current:= controls.currentPosition
	try,Duration:= Media.getItemInfo("Duration")
	if(Time_ExCat) {
		try,WMP.player.Controls.currentPosition:= Time_ExCat /(100 /Duration) 
		, Time_ExCat:="" ;if(uuid:=WMP.player.currentMedia.getItemInfo("WMCollectionID") 
		return, ; tt(UUid " UUID recognised") ;try ;for,i,v in medi
	} winget,plistwnd,id, != "{00000000-0000-0000-0000-000000000000}")t:="" ;t.=i " , " v	; msgbox % t ;}
	if((PlayState:= WMP.player.PlayState)=3) { ; Playing = 3
		(TranspGui?	re:= Send_WMCOPYDATA("p" . current ,"wmp_transp.ahk ahk_class AutoHotkey"))
		menu,tray,icon,% "C:\Icon\32\wmp_playing_d32.ico"
	} else,menu,tray,icon,% "C:\Icon\32\wmp_off_32.ico"
SongNew=% Media.sourceURL ;(SongOld="")?SongOld:=SongNew
IF(SongOld!=SongNew) {
	duration:= Transparency_Inc:= "", trigger_PL:= trigger_pa:= False
	, newiD3full:= iD3_StringGet(SongNew), id3Art:= iD3_Artist(SongNew)
	, id3Ttl:= iD3_Track(SongNew)
	if(id3Art="0"||id3Ttl="0") {
		SplitPath,SongNew,tOutFileName,tOutDir
		id3Art:= tOutDir . "\", id3Ttl:= tOutFileName
	}
	SongOld:= SongNew
	SplitPath,SongNew,,,OutExtension,OutNameNoExt
	if(pastenonext) {
		pastenonext:= False, iD3full:= iD3full2, PosReal--
		sleep,700
	} else,if(TranspGui) {
		duration:= Transparency_Inc:= "", Media:= WMP.player.currentMedia, Controls:= WMP.player.Controls
		, Duration:= WMP.player.currentMedia.getItemInfo("Duration"), PlayState:= WMP.player.PlayState
	try,Current:= WMP.player.Controls.currentPosition
	,Send_WMCOPYDATA("v" . Vol_WMP,"wmp_transp.ahk ahk_class AutoHotkey")
	,Send_WMCOPYDATA("i" . Current,"wmp_transp.ahk ahk_class AutoHotkey")
	,Send_WMCOPYDATA("d" . Duration,"wmp_transp.ahk ahk_class AutoHotkey")
	,((PlayState="3")? (Send_WMCOPYDATA("p","wmp_transp.ahk ahk_class AutoHotkey"), playing:= true, timer("Check_PS",-5000))
	: (Send_WMCOPYDATA("s","wmp_transp.ahk ahk_class AutoHotkey"), playing:= false, timer("Check_PS",-5000)))
	}
	(!(CListWnd:= winexist("ahk_id " CListWnd))? Skinhandle() :timer("Check_YASKIN",-32000) )

	settimer,Check_YASKIN,-20
}

try,PlayState:= WMP.player.PlayState
if(PlayState=3) { ; Playing = 3
	trigger_pa:= False
	if(!trigger_PL&&!trigger_pa) {
		trigger_PL:= True, Pstate(On)
		sleep,100
		trayTip,% ":Now-Playing ",% id3Art " - " id3Ttl, 3, 33
		menu,tray,Tip,% "Windows Media Player - Playing`n" 	newiD3full
		SongOld:= SongNew
	}
} else,if(PlayState=2||PlayState=1) {
		trigger_PL:= False
		if(!trigger_pa) {
			trigger_pa:= True
			PState(Off)
			trayTip,% "WMP Paused", % id3Art " - " id3Ttl, 3, 33
			menu,tray,Tip,% "Windows Media Player - Paused`n" newiD3full

		}
	}

	if(TranspGui)
		settimer,Deets2Transp,-1
}


; Transp_Refresh:
; (!(WMP)? WMP:= 	New RemoteWMP, missingwmps++)
; Controls 	:= 	WMP.player.Controls
; Current	:= 	controls.currentPosition
; Duration	:= 	WMP.player.currentMedia.getItemInfo("Duration")
; if(Time_ExCat) {
	; try,WMP.player.Controls.currentPosition:= Time_ExCat /(100 /duration)
	tt((Duration " dur`n" desired " desired`n" result " res`n" Time_ExCat " Time_ExCat`n" current " cur11`n" desired "!desired"),"center",5000)
	; Time_ExCat:=""
	; return
; }
; if((PlayState:= WMP.player.PlayState)=3) { ; Playing = 3
	; (TranspGui?	re:= Send_WMCOPYDATA("p" . current ,"wmp_transp.ahk ahk_class AutoHotkey"))
	; menu,tray,icon,% "C:\Icon\32\wmp_playing_d32.ico"
; } else,	menu,tray,icon,% "C:\Icon\32\wmp_off_32.ico"
; Media:= WMP.player.currentMedia
; SongNew =% Media.sourceURL
; IF(SongOld != SongNew) {
	; duration:= Transparency_Inc:=""
	; trigger_PL:= trigger_pa:= False
	; newiD3full:= iD3_StringGet(SongNew)
	; id3Art:= iD3_Artist(SongNew) 
	; id3Ttl:= iD3_Track(SongNew)
	; if((id3Art="0")||(id3Ttl="0")) {
		; SplitPath,SongNew,tOutFileName,tOutDir
		; id3Art:= tOutDir . "\"
		; id3Ttl:= tOutFileName	;	goto,PlayPstateUpdateInterval
	; }
	; SongOld:= SongNew
	; SplitPath,SongNew,,,OutExtension,OutNameNoExt
	; if(pastenonext) {
		; pastenonext:= False
		; iD3full:= iD3full2
		; PosReal:= PosReal -1
		; sleep,700
		; goto,POST_GASM
	; } else,if(TranspGui) {
		; duration:= Transparency_Inc:= ""
		; settimer,Deets2Transp,-1
; }

ps1212:
try
	PlayState:= WMP.player.PlayState
catch {
	sleep, 900 
	goto,ps1212
}
if(PlayState = 3) { ; Playing = 3
	trigger_pa	:= 	False
	if !trigger_PL||!trigger_pa {
		trigger_PL:= True	
		Pstate(On)
		sleep, 100
		trayTip,% ":Now-Playing ",% id3Art " - " id3Ttl, 3, 33
		menu, tray, Tip, % "Windows Media Player - Playing`n" 	newiD3full
		SongOld:= SongNew
	}
} else,if(PlayState = 2 or PlayState = 1) {
		trigger_PL 	:= 	False
		if !trigger_pa {
			trigger_pa 	:= 	True
			PState(Off)
			trayTip,% "WMP Paused", % id3Art " - " id3Ttl, 3, 33
			menu, tray, Tip, % "Windows Media Player - Paused`n" newiD3full
}	}	
	if(TranspGui)
		settimer,Deets2Transp,-1

return,

Icon_Alternate: ; if(A_TimeIdle < (420000 - 1000)) {
if(!IconAlternateEnabled && trigger_PL) {
	Try,menu,tray,Icon,% ic1,	
	IconAlternateEnabled:= True
} else {
	if trigger_PL {
		Try
			menu, tray, Icon, % ic2,
		Catch
			goto,Errormsg
		IconAlternateEnabled:= False
	} 
	else settimer, Icon_Alternate, off
}
return,

CursorReset:
DllCall("SystemParametersInfo", "uint", SPI_SetCurSORS:= 0x57, "uint", 0, "ptr", 0, "uint", 0)
return,

volup:
postMessage, 0x111, vol_up, 0, ,%WinTitle% 	
return,

VolDn:
postMessage, 0x111, vol_down, 0, ,%WinTitle%
return,

;ALTgr + PAGE UP ; Volume DOWN	
;return,
; AniCur_:
; setcur(%cur_%)
; return,
; SetCur(image_unc="") {
	; SetSystemCursor(image_unc)
	; sleep, 300 
	; RestoreCursor()
; }

NowPlayingList_DelCurrent:
;try,wmp:= Delete RemoteWMP 
if !wmp
	missingwmps++


;wmp:= New RemoteWMP 
NowPlayingList_DelCurrent2:

Media:= WMP.player.currentMedia
Controls:= WMP.player.Controls
SongOld=% Media.sourceURL
SplitPath,SongOld,,,, iD3full
id3full3:= iD3_StringGet2(SongOld)
((!hndL)? hndL:= hwndGetMain())
SendMessage,0x1004,0,0,,ahk_id %hndL% 				; LVM_GETITEMCOUNT=0x1004

tt(wmplist 	:= 	ErrorLevel)
PosReal:= GetPos()
POST_GASM:
if(GoDie) {
	GoDie:= False
	;wmp:= Delete RemoteWMP
	gosub,Delete_
} if(!PosReal) {
	(!hndL? hndL:=	hwndGetMain())
	tt(" in s") ;init issue;
	((cntt++<9)? goto(NowPlayingList_DelCurrent2))
} else {
	SendMessage,0x1008,PosReal,0,,ahk_id %hndL% ; Delete
	SendMessage,0x1004,0	,0	,,ahk_id %hndL% ; LVM_GETITEMCOUNT=0x1004
	 WMPListnew:= errorLevel
	(WMPListNew = WMPList)? tt(a:= tracklist.Delete(array_pos) . " Error Deleting in plist",1400):()
	(pastenskip? Pastenskip:= False)
}
Pstate("On")
return,

pastenonext: ; These are all lazy and almost the same work;
 PlayPstateUpdateInterval()
sleep,80
pastenonext:= True
Media:= wmp.player.currentMedia
SongOld=% Media.sourceURL
id3full2:= iD3_StringGet2(SongOld)
return,

;try,wmp:= Delete RemoteWMP
return,

GoDie: ;Main Delete entry,point ; Need refact0r ;
GoDie:= True
PasteNSkip:
(!wmp? missingwmps++)	; 	you lazy bastard, Matt
sleep,80
 Media:= wmp.player.currentMedia
if(a_thislabel="GoDie") {
 File2Del=% Media.sourceURL
SplitPath,File2Del,,,,iD3full2
} else,if(a_thislabel!="GoDie")
	File2Del:=""
Controls:= wmp.player.Controls
SongOld =% Media.sourceURL
id3Art2:= iD3_Artist(SongOld)
id3Ttl2:= iD3_Track(SongOld)
id3full:= iD3_StringGet2(SongOld)
id3full3:= id3full
;try,wmp:= Delete RemoteWMP
goto,jumpnext
return,

InstantPl() { ;(".WAV" in Explorer) insta-Soundfile playback on selected.;
	global InstantPl
	if((InstantPl:= !InstantPl)) {
		soundPlay,% "fx.wav"
		menu,tray,icon,% w2:= "WAV auto-preview",% "C:\Script\AHK\Z_MIDI_IN_OUT\icons.DLL",% "5" 
	} else,menu,tray,icon,% w2,% "C:\Script\AHK\Z_MIDI_IN_OUT\icons.DLL",% "6"
	return,
}

#if InstantPl

	~+down::
	 ~down::
	~+Up::
	 ~Up::
	if(InstantPl!="")
		settimer,sound_explorer_check,-10
	return,

	~f21:: ;file-unload;
	tt("initializing sound...",500)
	SoundPlay,0
	return,

S_Play(SoundFilePath=""){
	SoundPlay,% "NULL"
	SoundPlay,% SoundFilePath
	SetTimer, SounDExPLoRer_timeout,-12000001
	tt(SoundFilePath)
}

sound_explorer_check:
winget,hn,id,ahk_Class CabinetWClass
(!hn? hn:=winexist("a"))
ifWinNOTActive,ahk_group Explora
	return,
if(instr(res1:= Explorer_GetSelection(hn),"`n")) {
	r:= StrSplit(res1 , "`n")
	loop,
	if(r[a_index]) {
		try,s_Play(res1)
		sleep,120
	} else,break
} else,s_Play(res1)
return,

SoundExplorer_Timeout:
(!(InstantPl="")?(settimer,InstantPl,-1))
return,

#X::
np_GETLIST() 
return,

np_GETLIST() {
	if(hndL)
		ControlGet,ItemList,List,,,ahk_id %hndL%
	else,tt("2Log1c_BABY2")
	return,byref ItemList
}
 
GetHandle() {
	WinGet,LL,List,ahk_class WMP Skin Host 
	((LL="")?(return,0)) ; no list instances found
	loop,% LL {
		va:= LL%a_index%
		winGet,Style,Style,ahk_id %va%
		winGet,ExStyle,ExStyle,ahk_id %va%
		;if(style=0x16CF0000 && exstyle=0x000C0100 ) { ;x86 ansi
		if(style=0x16870000 && exstyle=0x000C0100)
			ControlGet,hundl,hwnd,,SysListView321,ahk_id %va%
	}
	return,(!(hundl="")?hundl : False)

}

GetHandle2(cname) 	{
	WinGet,LL,List,ahk_class WMP Skin Host 
	loop,% LL	{
		va:= LL%a_index%
		ControlGet,hundl,hwnd,,% cname,% "ahk_id " . va
	}
	return,(hundl="")? False : hundl
}

GetPos() {
	global hndL
	try,if(!id3fullstr:= iD3_StringGet2(SongNew))
		id3fullstr:= iD3_StringGet2(SongOld)
	h:= GetHandle() ;if(!hndL),try,h:= GetHandle(),else
	ControlGet,ItemList,List,,,ahk_id %hndL%
	if(!itemlist) { ;tt(" no PList ")	;settimer,TOOLOFF,-300
		if(!hndL)	;tt(" no h4ndle ")
			hndL:= GetHandle()
	} else,Loop,Parse,% ItemList, `n
	{
		Items:= StrSplit(a_loopfield, A_Tab)
		tracklist[A_Index]:= Items[1]
		if(tracklist[ A_Index]=id3fullstr)
			PosReal:= A_Index -1
	}
	return,(PosReal="")? False : PosReal
}

#w::
s:= GetHandle2("ToolbarWindow323")
postmessage,0x0454,0,0x00000089,,ahk_id %s% 
tooltip,% S ; TB_SETEXTENDEDSTYLE 0x0454 ; TBExtStyle_Ex_DBLBuff 0x80 ;
f:= GetHandle2("ToolbarWindow324") 
postMessage,0x0454,0,0x00000089,,ahk_id %f%
return,

MenuTray_init: ;iconz:= [] ;Iconz.Push(LoadPicture(a_scriptDir . "\WMP.ico"));
icoAr:= []
OpenMedia_M_TTL:= "Open media location"
srchSS_M_TTL:= "Search Alternatea on sLsK"
Srchexp_M_TTL:= "Search Explorer"
SrchYT_M_TTL:= "Search Youtube"
ZinOut_M_TTL:= "Run Zmidi_in_Out"
Cut_M_TTL:= "Fix White Playlist"
iCoDll:= "C:\Script\AHK\Z_MIDI_IN_OUT\icons.DLL"
menu,tray,color,080032
menu,tray,noStandard
menu,tray,MainWindow
menu,tray,Add,% TranspGuiTogl_M_TTL:= "Transport Gui",	TranspGuiTogl
menu,tray,Add,% _:=	"Sound &Control Panel (Windows 7)",_WinSndCPL_
menu,tray,Add,% mixerXP_M_TTL:= "Audio-Channel Mixer (Windows XP)",_SndMix4_WinXP_
Menu,tray,Default,% "Audio-Channel Mixer (Windows XP)"
menu,tray,Add,% 	"Steinberg Mixer", 		ur44Mixer
menu,tray,Add,% _:=	"Channel-setup", 		chsetup
menu,tray,Add,%	_:= "WAV auto-preview", 	InstantPl
menu,tray,Add,% 	"Open Script location", Open_ScriptDir
menu,tray,Add,% 	"Open Extract window", 	xtractmenu_open
menu,tray,Add,Restart Windows Media Player,	Restart_WMP
menu,tray,Add,Next, 			JumpNext
menu,tray,Add,Prev, 			JumpPrev
menu,tray,Add,Pause,			PauseToggle
menu,tray,Add,% OpenMedia_M_TTL,Open_Containing
menu,tray,Add,Delete,			GoDie
menu,tray,Add,Cut,				CutCurrent
menu,tray,Add,% srchexp_M_TTL,	SearchExp
menu,tray,Add,% srchSS_M_TTL,	SearchSlSk
menu,tray,Add,% srchYT_M_TTL,	SearchYT
menu,tray,Add,% Cut_M_TTL, 		FIXW
menu,tray,Add,% ZinOut_M_TTL,	ZinOut
menu,tray,Add,Rescue SLSk Window,SLsk_Rescue
menu,tray,Add,Disable Numpad,	NmPad_Togl
; menu,tray,Icon,% "C:\Icon\256\wmp_zbuFS.ico"
; menu,tray,icon,% icoAr[9],% iCoDll,%	"9"
; menu,tray,icon,% icoAr[14],% iCoDll,%	"14"
; menu,tray,icon,% icoAr[15],% iCoDll,%	"15"
; menu,tray,icon,% icoAr[19],% iCoDll,%	"19"
menu, 	tray, icon,% icoAr[5]:= "Open Extract window",% iCoDll,%	"5"
menu, 	tray, icon,% icoAr[7]:= "Open script location",% iCoDll,%	"7"
menu, 	tray, icon,% icoAr[8]:= "Rescue SLSk window",% iCoDll,%		"8"
menu,	tray, icon,% MixerXP_M_TTL,% iCoDll,%						"9"
menu,	tray, icon,% icoAr[12]:= "Restart Windows Media Player",% iCoDll,% "12"
menu, 	tray, icon,% icoAr[14]:= "Steinberg Mixer",% iCoDll,%		"14"
menu, 	tray, icon,% icoAr[15]:= "Delete",% iCoDll,%				"15"
menu, 	tray, icon,% icoAr[17]:= "Next",% iCoDll,%					"17"
menu, 	tray, icon,% icoAr[18]:= "Prev",% iCoDll,%					"18"
menu, 	tray, icon,% icoAr[19]:= "Open media location",% iCoDll,%	"7"
menu, 	tray, icon,% Cut_M_TTL,%		Cut_ico:= "C:\Icon\24\cut24.ico"
menu, 	tray, icon,% Zinout_M_TTL,%	zinout_ico:="C:\Icon\24\whistler_run_2.ico"
menu, 	tray, icon,% SrchYT_M_TTL,%	SrchYT_ico:= "YouTube.ico"
menu, 	tray, icon,% Cut_M_TTL,%		Cut_ico:= "C:\Icon\20\picklink - Copy.bmp"
menu, 	tray, icon,% Srchexp_M_TTL,%	Srchexp_ico:= "C:\Icon\20\search (2).ico"
menu, 	tray, icon,% SrchSS_M_TTL,% 	SrchSS_ico:= "C:\Icon\24\slsk24.ico"
menu,	tray, icon,% TranspGuiTogl_M_TTL,% TranspGuiTogl_ico:= "C:\Icon\24\sak24.ico"


menu,tray,% (NmPad_Togl?"check":"uncheck"),Disable Numpad
menu,tray,Standard
return,

	TranspGuiTogl:
((	TranspGuiTogl:= !TranspGuiTogl)? run("wmp_transp.ahk"	)) ;:sendm5g(quit 2 transp);;
return,

dmix:
settimer,_WinSndMix4_Togl_,-1
return,

AHK_NOTIFYICON(wParam, lParam) {
	switch,lParam {
		case,0x201: ; WM_LBUTTONDOWN
			settimer,dmix,-800
		case,0x202: ; WM_LBUTTONUP
				mouseGetPos,,,mhwnd
				winGetClass,cls,% ( "Ahk_iD " . mhwnd)
				if(cls!="Shell_TrayWnd") 
					msgbox,% cls
		;case,0x205: ; WM_RBUTTONUP
		case,0x206: ; WM_RBUTTONDBLCLK 
			;dmix_cancel:= true
			settimer,dmix,off
			SETTIMER,_SndMix4_WinXP_,-1
		;	case,0x020B: ; WM_XBUTTONDOWN 
		;	msgbox % a_thishotkey
		;case,0x0208: ; WM_MBUTTONUP 
		;	msgbox % a_thishotkey
	}
return,
}

ur44Mixer:
run,% "C:\Program Files (x86)\Steinberg\UR44\dspMixFx_UR44.exe"
return,

chsetup:
run,% "C:\Script\AHK\Z_MIDI_IN_OUT\sound_enumerate.ahk"
return,

_WinSndMix4_Togl_:
run,% "C:\Windows\System32\SndVol.exe -f 265805"
settimer,svolhandle,-500
return,

sVolHandle:
tt("TT")
global Mixer_Mon:= winexist("ahk_exe SndVol.exe")
return,

_SndMix4_WinXP_:
sleep,200
run,% "C:\Windows\System32\SndVol.exe -m 2035123"
sleep,200
	global SndMixr_hWND:=winexist("ahk_exe SndVol.exe")
return,

_WinSndCPL_:
runwait,% COMSPEC " /C " scpl,, hide
return,

varz:
global DBGTT,tt,NmPad_Togl,aa,bb,cc,hHeader,cur_,scpl,GoDie,pastenskip,numpadkeys_str,PRE_GASM,Stat3,IconChangeInterval,PstateUpdateInterval,iD3full2,num_init_trigger,pastenonext,iD3full,WinTitle,WMPConv,wmp,Media2del,trigger_pa,submittedok,wmplistnew,wmplist,PlayPstateUpdateInterval,hndL,PosReal,reTries,tracklist,Deletearr,NumPKeysArr,num_others,S,Play,Stop,Prev,Next,Pause,Vol_Up,Search_Root,Genre,Vol_Down,WMP,Media,Controls,File2Del,SongOld,PlayState,SongNew,Path2File,path2paste,gnr,choice,Output_FullUnc,PosRealwmplist,wmplistnewtracklist,GoDiepastenskip,id3Art2,id3Ttl2,id3full3,hurd_n,unc,CopyOfData,Vol_WMP_obj,Vol_WMP,idd_,CListWnd
 ;r,rr,oldr,mhwnd 

;global ,AniCurPrefix,AniCur_fprint,AniCur_hand,AniCur_Munch,AniCur_Apple,AniCur_banana,AniCur_COFFEE,AniCur_Pink,AniCur_Pian,AniCur_Mnote,AniCur_Vial,AniCur_swords,AniCur_cs,AniCur_city,AniCur_Cogs,AniCur_Clock,AniCur_StopWatch,AniCur_Shutter,AniCur_Camera,AniCur_prop,AniCur_TV,AniCur_mon,AniCur_pingpong,AniCur_peace,AniCur_Plane,AniCur_pred,AniCur_DINOSAUR,AniCur_horse,AniCur_jellyf,AniCur_wasp,AniCur_roach,AniCur_bfly,AniCur_flower,AniCur_flowerz,AniCur_tree,AniCur_Frozen,AniCur_Drip,AniCur_umbr,AniCur_sun,AniCur_1664,AniCur_plasmab,AniCur_pyra,AniCur_tri,AniCur_tric,AniCur_triG,AniCur_palette,AniCur_sheet,AniCur_lbolt,AniCur_wvain,AniCur_rocket,AniCur_orbit,AniCur_95busy1,AniCur_95busy2,
global AhkPath,pos_dpi,C0CK,myDoxdir,MyIconsdir,InstantPl,tcunt,cls,n,dmix_cancel,Time_ExCat,inittd,TranspGui,TranspGuiTogl
, Vol_WMP_obj
pos_dpi:= A_ScreenDPI
RegRead InstallDir,% "HKLM\SOFTWARE\AutoHotkey", InstallDir 
AhkPath:= ErrorLevel ? "C:\Program Files\Autohotkey" : InstallDir . "\AutoHotkey.exe"
NmPad_Togl:= True
DBGTT:= True
S:= 2000 ;; sleep, Time (ms)
tt 		:= 500
CHKBX_H:= "h15"
c0nda 		:= ("C:\Users\" . A_UserName . "\AnaCONDA3")
scpl 		:= (("" "C:\Windows\system32\rundll32.exe" "") . (" shell32.dll,Control_RunDLL mmsys.cpl,,playback"))
SLsk_Rescue:= "C:\Script\AHK\Z_MIDI_IN_OUT\slsk_rescue.ahk",
ytsearchstr	:= "https://www.youtube.com/results?search_query="
Needle3 	:= "( . )|(^[a-z][\s])|( )|( )|( )|[.]"
Needle2 	:= "i)(\s[a-z]{1,2}\s)"
xtractData_Cc	:=	"c:\out\temp.txt" 
Needle4:=	"i)[1234567890.'`)}{(_]|(-khz)(rmx)|(remix)|(mix)|(refix)|(vip)|(featuring)|( feat)|(ft)|(rfl)|(-boss)(-sour)|(its)|(it's)|(-)|(-bpm)|(edit)" 
Genres:=	"i)(dnb)|(Drum & Bass)|(reggae)|(riddim)|(hiphop)|(garage)|(rock)|(ambient)|(samples)|(my music)|(audiobooks)|(sLSk)|(FOAD)"
num_others:= "NumLock,NumpadDiv,NumpadMult,NumpadAdd,NumpadSub,NumpadEnter,NumpadPgDn,NumpadEnd,NumpadHome,NumpadClear,NumpadDel,NumpadIns,NumpadUp,NumpadLeft,NumpadRight,NumpadDown"
tracklist 	:= 	[]
Deletearr 	:= 	[]
NumPKeysArr:= 	[]
AutoScroll	:= 	False
On 			:= 	"On"
Off 		:= 	"Off"
trigger_PL 	:= 	False
tvmX 		:= 	0x112C
ic1			:= 	"WMP.ico"
ic2			:= 	"WMP2.ico"
splitstr 	:= 	"Split @ a)"	
del2endstr 	:= 	"Delete to end"
Play:= 0x2e0000, Stop:= 18809, Prev:= 18810, Next:= 18811, Pause:= 32808, Vol_Up:= 32815, Vol_Down = 32816, Offset_Start:= 4, reTries:= 1
IconChangeInterval:= 	1200
Enabled:= ComObjError(False)
GuiArray:= Object()
Colors:= ["0xD95319", "0xEDB120", "0x7E2F8E", "0x77AC30"]
return,

Open_ScriptDir(), dock()

AniParse_() {
	;static AnicoTTLlst
	 AnicoTTLlst:= "fprint,hand,Munch,Apple,banana,COFFEE,Pink,Pian,Mnote,Vial,swords,cs,city,Cogs,Clock,StopWatch,Shutter,Camera,prop,TV,mon,pingpong,peace,Plane,pred,DINOSAUR,horse,jellyf,wasp,roach,bfly,flower,flowerz,tree,Frozen,Drip,umbr,sun,1664,plasmab,pyra,tri,tric,triG,palette,sheet,lbolt,wvain,rocket,orbit,95busy1,95busy2,95busy1,95busy2"
	, AnicoNamelst:= "MY_BUSY,HAND,CY_04BUS,APPLE,BANANA,COFFEE,OU,PIANO,JA_01NOR,SC_WAIT,CS_01NOR,cursor_busy,CS_04BUS,MO_WAIT,TR_BUSY,WI_04BUS,CP_04BUS,WO_04BUS,TR_WAIT,TV,PC_BUSY,SC_WAIT,SX_BUSY,WO_01NOR,pred,DINOSAUR,HORSE,DA_BUSY,DA_WAIT,NA_BUSY,bfly,NA_WAIT,SX_WAIT,FL_01NOR,froz,DB_04BUS,FA_01NOR,GA_04BUS,ALLSEEING,SC_BUSY,GE_04BUS,GE_01NOR,RO_04BUS,AR_04BUS,DV_WAIT,JA_04BUS,RO_01NOR,PD_01NOR,SF_01NOR,SF_04BUS,WH_BUSY,WI_BUSY"
	, AniCurPrefix:= A_MyDocuments . "\My Pictures\Icons\" . "- CuRS0R\_ ANi\"
	Anicon:= {}
	loop,parse,% AnicoNamelst,`,
		(Anicon[ a_loopfield ]:= a_loopfield)
	for,name,a_path in Anicon
	{
		Anicon[name]:= (AniCurPrefix . a_path . ".ani")
		TT(Anicon[name] "`n" name)
	}
	return,Anicon
}