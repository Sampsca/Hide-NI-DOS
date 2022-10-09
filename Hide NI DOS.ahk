;
; AutoHotkey Version: 1.1.34.04
; Language:       English
; Platform:       Optimized for Windows 10
; Author:         Sam.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn All, StdOut  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force  ; Skips the dialog box and replaces the old instance automatically, which is similar in effect to the Reload command.

OnError("Traceback")

Global PS_Version:="v2.0.0.0"
Global PS_Temp:=RegExReplace(A_Temp,"\\$") "\Hide NI DOS"
Global PS_Dir:=RegExReplace(A_ScriptDir,"\\$") "\Hide NI DOS (files)"

Global hConfig:=hAbout:=0
Global NIPath, DesktopShortcut, HideConsole, Logging, InitialHeapSize, InitialHeapSizeE, InitialHeapSizeUD, MaxHeapSize, MaxHeapSizeE, MaxHeapSizeUD, InitialYoungMemory, InitialYoungMemoryE, InitialYoungMemoryUD, MaxYoungMemory, MaxYoungMemoryE, MaxYoungMemoryUD, CustomOptions, CustomOptionsE, PrintVersion, PrintHelp, OverrideGame, Game, SpecifyGamePath, GamePath, GamePathB

If A_Args.Count()
	{
	For n,Param in A_Args
		{
		If (Param="-Config")
			LoadConfig(), ConfigGUI()
		If (Param="-About")
			AboutGUI()
		}
	}
Else
	{
	LoadConfig()
	If !FileExist(NIPath)
		ConfigGUI()
	Else
		{
		Run()
		GoTo, 2GuiClose
		}
	;AboutGUI()
	}
Return

AboutGUI(){
	Margin:=10, Margin2:=Margin*2, Width0:=480, Height0:=470
	Gui, 3:Margin, %Margin%, %Margin%
	Gui, 3:-SysMenu +AlwaysOnTop +HwndhAbout
	Gui, 3:Add, Picture, xm y0 w48 h48 Section, % (A_IsCompiled?A_ScriptFullPath:PS_Dir "\PSicon48x48.ico")
	Gui, 3:Font, S15 w700, Verdana
	Temp:=Width0-(2*Margin+48)*2
	Gui, 3:Add, Text, x+m ym w%Temp% r1 +Center cWhite, Hide NI DOS %PS_Version%
	Gui, 3:Font, S10 w700, Verdana
	Width1:=Width0-2*Margin
	Gui, 3:Add, Text, xm y+%Margin% w%Width1% r1 +Center cWhite, Quietly runs NearInfinity with the specified VM Options.
	Gui, 3:Add, Text, xm y+%Margin2% w%Width1% r1 +Center cWhite, Copyright © 2010-2022 Sam Schmitz
	Gui, 3:Font, S8, Verdana
	Gui, 3:Add, Edit, xm y+%Margin2% w%Width1% h300 +Center cWhite -TabStop ReadOnly, This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.`n`nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.`n`nYou should have received a copy of the GNU General Public License along with this program (%PS_Dir%\COPYING.html).  If not, see <https://www.gnu.org/licenses/>.`n`nYou may contact Sam Schmitz at <sampsca@yahoo.com> or by sending a PM to Sam. at <http://www.shsforums.net/user/10485-sam/>.`n`nThanks to ScuD for originally telling me which command-line arguments he uses when running NearInfinity.
	Temp:=Width0//2-50
	Gui, 3:Add, Button, x%Temp% y+%Margin% w100 h30 +Default g3ButtonOK, OK
	Gui, 3:Color, 000000
	Gui, 3:Show, w%Width0% h%Height0%, About
}

ConfigGUI(){
	Margin:=10, Margin2:=Margin*2, Width0:=550, Height0:=460, Button1:=50, EditUD:=90
	Gui, 2:Default
	Gui, 2:Margin, %Margin%, %Margin%
	Gui, 2:-MinimizeBox +AlwaysOnTop +HwndhConfig
	Gui, 2:Add, Picture, xm y0 w48 h48 Section, % (A_IsCompiled?A_ScriptFullPath:PS_Dir "\PSicon48x48.ico")
	Gui, 2:Font, S15 w700, Verdana
	Temp:=Width0-(2*Margin+48)*2
	Gui, 2:Add, Text, x+m ym w%Temp% r1 +Center cWhite, Configure Hide NI DOS
	Gui, 2:Font, S8, Verdana
	Width1:=Width0-2*Margin

	Gui, 2:Add, GroupBox, xm y+%Margin% w%Width1% h100 cWhite, Global Settings
	Gui, 2:Add, Text, xp+%Margin% yp+%Margin2% r1 cWhite Section, Path to NearInfinity.jar :
	Gui, 2:Add, Edit, x+m yp w304 r1 cRed ReadOnly -TabStop vNIPath, %NIPath%
	Temp:=Width0-2*Margin-Button1
	Gui, 2:Add, Button, x%Temp% yp w%Button1% hp gSelectNIPath, &Select
	Width2:=Width1//2-2*Margin
	Gui, 2:Add, CheckBox, xs y+m w%Width2% r1 cWhite vDesktopShortcut, Create Desktop Shortcut
	Gui, 2:Add, CheckBox, x+m yp w%Width2% r1 cWhite vLogging, Enable Logging
	Gui, 2:Add, CheckBox, xs y+m w%Width2% r1 cWhite vHideConsole, Hide Console Window
	Gui, 2:Add, Button, x+m yp-5 w100 h20 gGoToLogs, Go to Logs

	Width4:=(Width1-Margin)//2
	Gui, 2:Add, GroupBox, xm y+%Margin2% w%Width4% h260 cWhite, Java VM Memory Options
	Width5:=Width4-2*Margin
	Gui, 2:Add, CheckBox, xs yp+%Margin2% r1 cWhite Section vInitialHeapSize gToggleCBEUD, Initial Heap Size
	Gui, 2:Add, Edit, xp+%Margin2% y+5 w%EditUD% r1 cRed ReadOnly vInitialHeapSizeE, 512
	Gui, 2:Add, UpDown, Range1-10240 vInitialHeapSizeUD, 512
	Gui, 2:Add, CheckBox, xs y+m w%Width5% r1 cWhite vMaxHeapSize gToggleCBEUD, Max Heap Size
	Gui, 2:Add, Edit, xp+%Margin2% y+5 w%EditUD% r1 cRed ReadOnly vMaxHeapSizeE, 2048
	Gui, 2:Add, UpDown, Range1-10240 vMaxHeapSizeUD, 2048
	Gui, 2:Add, CheckBox, xs y+m w%Width5% r1 cWhite vInitialYoungMemory gToggleCBEUD, Initial Young Generation Memory
	Gui, 2:Add, Edit, xp+%Margin2% y+5 w%EditUD% r1 cRed ReadOnly vInitialYoungMemoryE, 128
	Gui, 2:Add, UpDown, Range1-10240 vInitialYoungMemoryUD, 128
	Gui, 2:Add, CheckBox, xs y+m w%Width5% r1 cWhite vMaxYoungMemory gToggleCBEUD, Max Young Generation Memory
	Gui, 2:Add, Edit, xp+%Margin2% y+5 w%EditUD% r1 cRed ReadOnly vMaxYoungMemoryE, 512
	Gui, 2:Add, UpDown, Range1-10240 vMaxYoungMemoryUD, 512
	Gui, 2:Add, CheckBox, xs y+m w%Width5% r1 cWhite vCustomOptions gToggleCBEUD, Custom Options
	Temp:=Width5-Margin2
	Gui, 2:Add, Edit, xp+%Margin2% y+5 w%Temp% r1 cRed Disabled vCustomOptionsE,
	Temp:=Width4-80
	Gui, 2:Add, Button, x%Temp% ys w80 h30 gRestoreJavaDefaults, Restore Defaults

	Gui, 2:Add, GroupBox, x+%Margin2% ys-%Margin2% w%Width4% h260 cWhite, NearInfinity Options
	Gui, 2:Add, CheckBox, xp+%Margin% yp+%Margin2% r1 cWhite Section vPrintVersion gPrintVersion, Print Version Info
	Gui, 2:Add, CheckBox, xs y+m w%Width5% r1 cWhite vPrintHelp gPrintHelp, Print Console Help
	Gui, 2:Add, CheckBox, xs y+m r1 cWhite vOverrideGame gOverrideGame, Override Game Type
	Temp:=Width1-EditUD
	Gui, 2:Add, DropDownList, x%Temp% yp w%EditUD% hp r17 vGame, BG1|BG1-TotSC|Tutu|BG2-SoA|BG2-ToB||BGT|IWD|IWD-HoW|IWD-TotLM|IWD2|PST|BG1-EE|BG1-SoD|BG2-EE|EET|IWD-EE|PST-EE
	Gui, 2:Add, CheckBox, xs y+5 w%Width5% r1 cWhite vSpecifyGamePath gSpecifyGamePath, Specify Game Path:
	Temp:=Width5-Margin2-Button1-5
	Gui, 2:Add, Edit, xp+%Margin2% y+5 w%Temp% r1 cRed ReadOnly Disabled vGamePath,
	Temp:=Width1-Button1
	Gui, 2:Add, Button, x%Temp% yp w%Button1% hp Disabled vGamePathB gSelectGamePath, Select
	Temp:=Round(Width1-Width4/2-80/2+Margin)
	Gui, 2:Add, Button, x%Temp% y+%Margin2% w80 h30 gRestoreNIDefaults, Restore Defaults

	Gui, 2:Add, Button, xm w80 h23 gSaveConfigAndExit, &OK
	Temp:=Width0//2-80//2
	Gui, 2:Add, Button, x%Temp% yp wp hp g2GuiClose, &Cancel
	Temp:=Width0-80-Margin
	Gui, 2:Add, Button, x%Temp% yp wp hp gRun, &Run

	Gui, 2:Color, black
	InitializeConfigGUI()
	Gui, 2:Show, w%Width0% h%Height0% x150 y200, Config - Hide NI DOS %PS_Version%
	Return
}

SelectNIPath(){
	Gui 2:+OwnDialogs
	Path:=(FileExist(NIPath)?NIPath:"")
	FileSelectFile, Path, 3, %Path%, Select NearInfinity's .JAR file., Java ARchive (*.jar)
	If (Path="")
		Return
	NIPath:=Path
	GuiControl,2:Text, NIPath, %Path%
}

SetDefaults(){
	If FileExist(A_ScriptDir "\NearInfinity.jar")
		NIPath:=A_ScriptDir "\NearInfinity.jar"
	Else
		NIPath:=""
	DesktopShortcut:=1, HideConsole:=1, Logging:=0
	SetJavaDefaults()
	SetNIDefaults()
}

SetJavaDefaults(){
	InitialHeapSize:=1, InitialHeapSizeE:=512, InitialHeapSizeUD:=512, MaxHeapSize:=1, MaxHeapSizeE:=2048, MaxHeapSizeUD:=2048, InitialYoungMemory:=1, InitialYoungMemoryE:=128, InitialYoungMemoryUD:=128, MaxYoungMemory:=1, MaxYoungMemoryE:=512, MaxYoungMemoryUD:=512, CustomOptions:=0, CustomOptionsE:=""
}

SetNIDefaults(){
	PrintVersion:=0, PrintHelp:=0, OverrideGame:=0, Game:="BG2-ToB", SpecifyGamePath:=0, GamePath:=""
}

LoadConfig(){
	INIPath:=A_AppData "\Infinity Engine Modding Tools\Hide NI DOS\Hide NI DOS Config.txt"
	SetDefaults()
	If FileExist(INIPath)
		{
		For k,v in ["NIPath","DesktopShortcut","HideConsole","Logging","InitialHeapSize","InitialHeapSizeE","InitialHeapSizeUD","MaxHeapSize","MaxHeapSizeE","MaxHeapSizeUD","InitialYoungMemory","InitialYoungMemoryE","InitialYoungMemoryUD","MaxYoungMemory","MaxYoungMemoryE","MaxYoungMemoryUD","CustomOptions","CustomOptionsE","PrintVersion","PrintHelp","OverrideGame","Game","SpecifyGamePath","GamePath"]
			IniRead, %v%, %INIPath%, Program Options, %v%, % (v=""?A_Space:v)
		}
	Else
		FileCreateDir, % A_AppData "\Infinity Engine Modding Tools\Hide NI DOS\"
}

SaveConfig(){
	Gui, 2:Submit, NoHide
	INIPath:=A_AppData "\Infinity Engine Modding Tools\Hide NI DOS\Hide NI DOS Config.txt"
	If !FileExist(INIPath)
		{
		FileCreateDir, % A_AppData "\Infinity Engine Modding Tools\Hide NI DOS\"
		FileAppend, [Hide NI DOS Config]`r`nCopyright © 2010-2022 Sam Schmitz`r`n`r`n[Program Options], %INIPath%
		}
	For k,v in ["NIPath","DesktopShortcut","HideConsole","Logging","InitialHeapSize","InitialHeapSizeE","InitialHeapSizeUD","MaxHeapSize","MaxHeapSizeE","MaxHeapSizeUD","InitialYoungMemory","InitialYoungMemoryE","InitialYoungMemoryUD","MaxYoungMemory","MaxYoungMemoryE","MaxYoungMemoryUD","CustomOptions","CustomOptionsE","PrintVersion","PrintHelp","OverrideGame","Game","SpecifyGamePath","GamePath"]
		IniWrite, % %v%, %INIPath%, Program Options, %v%
	CreateShortcut()
}

RestoreJavaDefaults(){
	Gui, 2:Submit, NoHide
	SetJavaDefaults()
	InitializeConfigGUI()
}

RestoreNIDefaults(){
	Gui, 2:Submit, NoHide
	SetNIDefaults()
	InitializeConfigGUI()
}

CreateShortcut(){
	If (DesktopShortcut & FileExist(NIPath) & !FileExist(A_Desktop "\NearInfinity.lnk")) ; Link doesn't already exist
		FileCreateShortcut, %A_ScriptFullPath%, %A_Desktop%\NearInfinity.lnk, %A_ScriptDir%, , Quietly runs NearInfinity with the specified VM Options., % (A_IsCompiled?A_ScriptFullPath:PS_Dir "\PSicon48x48.ico")
}

CBIsTrue(MyGui,ControlID){
	MyGui:=(MyGui=""?A_DefaultGui:MyGui)
	;GuiControlGet, OutputVar, %MyGui%:SubCommand, ControlID, Value
	GuiControlGet, Enabled, %MyGui%:Enabled, %ControlID%
	GuiControlGet, Visible, %MyGui%:Visible, %ControlID%
	GuiControlGet, Checked, %MyGui%:, %ControlID%
	Return (Enabled&Visible&Checked?1:0)
}

InitializeConfigGUI(){
	For k,v in ["NIPath","DesktopShortcut","HideConsole","Logging","InitialHeapSize","InitialHeapSizeE","InitialHeapSizeUD","MaxHeapSize","MaxHeapSizeE","MaxHeapSizeUD","InitialYoungMemory","InitialYoungMemoryE","InitialYoungMemoryUD","MaxYoungMemory","MaxYoungMemoryE","MaxYoungMemoryUD","CustomOptions","CustomOptionsE","PrintVersion","PrintHelp","OverrideGame","SpecifyGamePath","GamePath"]
		GuiControl, 2:, %v%, % %v%
	GuiControl, 2:ChooseString, Game, %Game%
	ToggleCBEUD("InitialHeapSize")
	ToggleCBEUD("MaxHeapSize")
	ToggleCBEUD("InitialYoungMemory")
	ToggleCBEUD("MaxYoungMemory")
	ToggleCBEUD("CustomOptions")
	PrintVersion("PrintVersion")
	PrintHelp("PrintHelp")
	OverrideGame("OverrideGame")
	SpecifyGamePath("SpecifyGamePath")
}

GoToLogs(){
	If !FileExist(PS_Temp)
		FileCreateDir, %PS_Temp%
	Run, explore %PS_Temp%
}

ToggleCBEUD(CtrlHwnd,GuiEvent:="",EventInfo:="",ErrLevel:=""){
	GuiControlGet, Checked, , %CtrlHwnd%
	GuiControlGet, Name, Name, %CtrlHwnd%
	GuiControl, Enable%Checked%, %Name%E
	GuiControl, Enable%Checked%, %Name%UD
}

PrintVersion(CtrlHwnd,GuiEvent:="",EventInfo:="",ErrLevel:=""){
	GuiControlGet, Checked, , %CtrlHwnd%
	NChecked:=!Checked
	For k,v in ["PrintHelp","OverrideGame","SpecifyGamePath"]
		GuiControl, Enable%NChecked%, %v%
	Checked2:=CBIsTrue(A_Gui,"SpecifyGamePath")
	GuiControl, Enable%Checked2%, GamePath
	GuiControl, Enable%Checked2%, GamePathB
}

PrintHelp(CtrlHwnd,GuiEvent:="",EventInfo:="",ErrLevel:=""){
	GuiControlGet, Checked, , %CtrlHwnd%
	NChecked:=!Checked
	For k,v in ["PrintVersion","OverrideGame","SpecifyGamePath"]
		GuiControl, Enable%NChecked%, %v%
	Checked2:=CBIsTrue(A_Gui,"SpecifyGamePath")
	GuiControl, Enable%Checked2%, GamePath
	GuiControl, Enable%Checked2%, GamePathB
}

OverrideGame(CtrlHwnd,GuiEvent:="",EventInfo:="",ErrLevel:=""){
	GuiControlGet, Checked, , %CtrlHwnd%
	GuiControlGet, Checked2, , SpecifyGamePath
	GuiControl, Enable%Checked%, Game
	NChecked:=!Checked & !Checked2
	For k,v in ["PrintVersion","PrintHelp"]
		GuiControl, Enable%NChecked%, %v%
	If NChecked
		{
		GuiControlGet, Checked3, , PrintVersion
		GuiControlGet, Checked4, , PrintHelp
		If Checked3
			PrintVersion("PrintVersion","","")
		Else If Checked4
			PrintHelp("PrintHelp","","")
		}
}

SpecifyGamePath(CtrlHwnd,GuiEvent:="",EventInfo:="",ErrLevel:=""){
	GuiControlGet, Checked, , %CtrlHwnd%
	GuiControlGet, Checked2, , OverrideGame
	GuiControl, Enable%Checked%, GamePath
	GuiControl, Enable%Checked%, GamePathB
	NChecked:=!Checked & !Checked2
	For k,v in ["PrintVersion","PrintHelp"]
		GuiControl, Enable%NChecked%, %v%
	If NChecked
		{
		GuiControlGet, Checked3, , PrintVersion
		GuiControlGet, Checked4, , PrintHelp
		If Checked3
			PrintVersion("PrintVersion","","")
		Else If Checked4
			PrintHelp("PrintHelp","","")
		}
}

SelectGamePath(){
	Gui 2:+OwnDialogs
	Path:=(FileExist(GamePath)?GamePath:"")
	FileSelectFile, Path, 3, %Path%\CHITIN.KEY, Open game: Locate keyfile, Infinity Keyfile (*.key)
	If (Path="")
		Return
	SplitPath, Path, , GamePath
	GuiControl,2:Text, GamePath, %GamePath%
}

Run(){
	A_Quote:=Chr(34)
	Gui, 2:Submit, NoHide
	If !FileExist(NIPath)
		throw Exception("NearInfinity could not be found at " A_Quote NIPath A_Quote ".",,"`n`n" Traceback())
	CreateShortcut()
	; java.exe -Xms512m -Xmx1024m -XX:NewSize=128m -XX:MaxNewSize=128m -jar "NearInfinity.jar"
	Command:="java.exe"
	If InitialHeapSize
		Command.=" -Xms" InitialHeapSizeUD "m"
	If MaxHeapSize
		Command.=" -Xmx" MaxHeapSizeUD "m"
	If InitialYoungMemory
		Command.=" -XX:NewSize=" InitialYoungMemoryUD "m"
	If MaxYoungMemory
		Command.=" -XX:MaxNewSize=" MaxYoungMemoryUD "m"
	If CustomOptions
		Command.=" " CustomOptionsE
	Command.=" -jar " A_Quote NIPath A_Quote
	If PrintVersion
		Command.=" -v"
	If PrintHelp
		Command.=" -h"
	If OverrideGame
		Command.=" -t " Game
	If SpecifyGamePath
		{
		If !FileExist(GamePath "\chitin.key")
			throw Exception(A_Quote GamePath A_Quote " does not appear to be a valid game path.",,"`n`n" Traceback())
		Command.=" " A_Quote GamePath A_Quote
		}
	If Logging
		{
		If !FileExist(PS_Temp)
			FileCreateDir, %PS_Temp%
		Command.=" 1>> " A_Quote PS_Temp "\Log_" A_Now ".txt" A_Quote " 2>&1"
		}
	Pause:=(!(HideConsole|Logging)&(PrintVersion|PrintHelp)?" && Pause":"")
	Run, %ComSpec% /c "echo %Command% && %Command%%Pause%", %NIPath%, % (HideConsole?"Hide":""), NIPID
}

3GuiClose:
3ButtonOK:
	Gui, 3:Destroy
	If !WinExist("ahk_id " hConfig) AND !WinExist("ahk_id " hAbout)
		ExitApp
	Return

SaveConfigAndExit:
	SaveConfig()

2GuiEscape:
2GuiClose:
	Gui, 2:Destroy
	If WinExist("ahk_id " hConfig) OR WinExist("ahk_id " hAbout)
		Return
    ExitApp

Esc::
	Reload
Return

#Include <PS_ExceptionHandler> ; https://github.com/Sampsca/PS_ExceptionHandler