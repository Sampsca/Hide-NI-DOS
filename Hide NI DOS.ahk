;
; AutoHotkey Version: 1.0.48.5
; Language:       English
; Platform:       Optimized for Windows XP
; Author:         Sam.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force  ; Skips the dialog box and replaces the old instance automatically, which is similar in effect to the Reload command.
#NoTrayIcon
DetectHiddenWindows, On


IniRead, Path, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Path to JAR, %A_Space%
	IfEqual, Path
		GoSub, LoadPath

BAT = %A_Temp%\NearInfinity.bat
IniRead, Path, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Path to JAR, %A_Space%
IniRead, Xms, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Xms, %A_Space%
IniRead, Xmx, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Xmx, %A_Space%
IniRead, PermSize, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, PermSize, %A_Space%
IniRead, MaxPermSize, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, MaxPermSize, %A_Space%
IniRead, NewSize, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, NewSize, %A_Space%
IniRead, MaxNewSize, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, MaxNewSize, %A_Space%


IfEqual 1, -config ;Param 1 is "-config"
	{
	Gosub, Config
	WinWaitClose, Config ahk_class AutoHotkeyGUI
	GoSub, FileExit
	}
IfEqual 1, -about ;Param 1 is "-about"
	{
	Gosub, About
	WinWaitClose, About ahk_class AutoHotkeyGUI
	GoSub, FileExit
	}

IfExist, %BAT%
	FileDelete, %BAT%
;FileAppend, java -Xms512m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=128m -XX:NewSize=128m -XX:MaxNewSize=128m -jar "NearInfinity beta 20.jar", %BAT%
FileAppend, java%A_Space%, %BAT%
IfNotEqual, Xms
	FileAppend, -Xms%Xms%%A_Space%, %BAT%
IfNotEqual, Xmx
	FileAppend, -Xmx%Xmx%%A_Space%, %BAT%
IfNotEqual, PermSize
	FileAppend, -XX:PermSize=%PermSize%%A_Space%, %BAT%
IfNotEqual, MaxPermSize
	FileAppend, -XX:MaxPermSize=%MaxPermSize%%A_Space%, %BAT%
IfNotEqual, NewSize
	FileAppend, -XX:NewSize=%NewSize%%A_Space%, %BAT%
IfNotEqual, MaxNewSize
	FileAppend, -XX:MaxNewSize=%MaxNewSize%%A_Space%, %BAT%
FileAppend, -jar "%Path%", %BAT%


Run, %BAT%
WinWait, Near Infinity ahk_class SunAwtFrame
	WinWait, %ComSpec% ahk_class ConsoleWindowClass
	WinHide, %ComSpec% ahk_class ConsoleWindowClass
WinWaitClose, Near Infinity ahk_class SunAwtFrame
	FileDelete, %BAT%

FileExit:
ExitApp
	

Config:
	{
	Gui, 2:Default
	Gui, 2:-MinimizeBox +AlwaysOnTop
	Gui, 2:Add, Picture, x16 y10 w48 h48 , %A_ScriptDir%\Hide NI DOS (files)\PSicon48x48.ico
	Gui, 2:Font, S15 w700, Verdana
	Gui, 2:Add, Text, x71 y10 w270 h40 +Center cWhite, VM Options
	Gui, 2:Font, S10 w700, Verdana
	Gui, 2:Add, Text, x46 y50 w320 h20 cWhite, Run NI with the following VM Options:
	Gui, 2:Font, S8, Verdana
	Gui, 2:Add, Edit, x46 y80 w290 h20 cRed vEdit0 readonly -TabStop, %Path%
	Gui, 2:Add, Button, x336 y80 w30 h20 g____ -Wrap, ____
	Gui, 2:Add, Checkbox, x46 y110 w320 h30 cWhite vCheckbox1 gCheckbox1, Specify initial size of memory allocation pool.
	Gui, 2:Add, Edit, x76 y140 w90 h20 cRed vEdit1 readonly, %Xms%
	Gui, 2:Add, UpDown, x76 y140 w10 h20 0x80 vUpDown1 Range1-10000, 512 ;%Xms%
	Gui, 2:Add, Checkbox, x46 y170 w320 h30 cWhite vCheckbox2 gCheckbox2, Specify max size of memory allocation pool.
	Gui, 2:Add, Edit, x76 y200 w90 h20 cRed vEdit2 readonly, %Xmx%
	Gui, 2:Add, UpDown, x76 y200 w10 h20 0x80 vUpDown2 Range2-10000, 1024 ;%Xmx%
	Gui, 2:Add, Checkbox, x46 y230 w320 h30 cWhite vCheckbox3 gCheckbox3, Specify initial size of permanent generation memory.
	Gui, 2:Add, Edit, x76 y260 w90 h20 cRed vEdit3 readonly, %PermSize%
	Gui, 2:Add, UpDown, x76 y260 w10 h20 0x80 vUpDown3 Range1-10000, 128 ;%PermSize%
	Gui, 2:Add, Checkbox, x46 y290 w320 h30 cWhite vCheckbox4 gCheckbox4, Specify max size of permanent generation memory.
	Gui, 2:Add, Edit, x76 y320 w90 h20 cRed vEdit4 readonly, %MaxPermSize%
	Gui, 2:Add, UpDown, x76 y320 w10 h20 0x80 vUpDown4 Range1-10000, 128 ;%MaxPermSize%
	Gui, 2:Add, Checkbox, x46 y350 w320 h30 cWhite vCheckbox5 gCheckbox5, Specify initial size of new generation memory.
	Gui, 2:Add, Edit, x76 y380 w90 h20 cRed vEdit5 readonly, %NewSize%
	Gui, 2:Add, UpDown, x76 y380 w10 h20 0x80 vUpDown5 Range1-10000, 128 ;%NewSize%
	Gui, 2:Add, Checkbox, x46 y410 w320 h30 cWhite vCheckbox6 gCheckbox6, Specify max size of new generation memory.
	Gui, 2:Add, Edit, x76 y440 w90 h20 cRed vEdit6 readonly, %MaxNewSize%
	Gui, 2:Add, UpDown, x76 y440 w10 h20 0x80 vUpDown6 Range1-10000, 128 ;%MaxNewSize%
	Gui, 2:Add, Button, x96 y480 w100 h30 gRestoreDefaults, Restore Defaults
	Gui, 2:Add, Button, x216 y479 w100 h30 g2ButtonOK, OK
	Gui, 2:Color, 000000
	Gui, 2:Show, w415 h520, Config
	IfEqual, Xms
		{
		GuiControl,2:, Checkbox1, 0
		GuiControl,, Edit1, 512
		}
	IfNotEqual, Xms
		{
		GuiControl,2:, Checkbox1, 1
		StringReplace, Xms, Xms, m
		GuiControl,, Edit1, %Xms%
		}
	GoSub, Checkbox1
	IfEqual, Xmx
		{
		GuiControl,2:, Checkbox2, 0
		GuiControl,, Edit2, 1024
		}
	IfNotEqual, Xmx
		{
		GuiControl,2:, Checkbox2, 1
		StringReplace, Xmx, Xmx, m
		GuiControl,, Edit2, %Xmx%
		}
	GoSub, Checkbox2
	IfEqual, PermSize
		{
		GuiControl,2:, Checkbox3, 0
		GuiControl,, Edit3, 128
		}
	IfNotEqual, PermSize
		{
		GuiControl,2:, Checkbox3, 1
		StringReplace, PermSize, PermSize, m
		GuiControl,, Edit3, %PermSize%
		}
	GoSub, Checkbox3
	IfEqual, MaxPermSize
		{
		GuiControl,2:, Checkbox4, 0
		GuiControl,, Edit4, 128
		}
	IfNotEqual, MaxPermSize
		{
		GuiControl,2:, Checkbox4, 1
		StringReplace, MaxPermSize, MaxPermSize, m
		GuiControl,, Edit4, %MaxPermSize%
		}
	GoSub, Checkbox4
	IfEqual, NewSize
		{
		GuiControl,2:, Checkbox5, 0
		GuiControl,, Edit5, 128
		}
	IfNotEqual, NewSize
		{
		GuiControl,2:, Checkbox5, 1
		StringReplace, NewSize, NewSize, m
		GuiControl,, Edit5, %NewSize%
		}
	GoSub, Checkbox5
	IfEqual, MaxNewSize
		{
		GuiControl,2:, Checkbox6, 0
		GuiControl,, Edit6, 128
		}
	IfNotEqual, MaxNewSize
		{
		GuiControl,2:, Checkbox6, 1
		StringReplace, MaxNewSize, MaxNewSize, m
		GuiControl,, Edit6, %MaxNewSize%
		}
	GoSub, Checkbox6
	Return
	}
Return

____:
	{
	FileSelectFile, Path, 3, %A_ScriptDir%, Select NearInfinity's .JAR file., Java ARchive (*.jar)
		if Path =
			{
			Return
			}
		Else
			{
			GuiControl,2:Text, Edit0, %Path%
			}
	}
Return

Checkbox1:
	{
	Gui, 2:Submit, NoHide
	IfEqual, Checkbox1, 1
		{
		GuiControl, Enable, Edit1
		GuiControl, Enable, UpDown1
		}
	IfEqual, Checkbox1, 0
		{
		GuiControl, Disable, Edit1
		GuiControl, Disable, UpDown1
		}
	}
Return

Checkbox2:
	{
	Gui, 2:Submit, NoHide
	IfEqual, Checkbox2, 1
		{
		GuiControl, Enable, Edit2
		GuiControl, Enable, UpDown2
		}
	IfEqual, Checkbox2, 0
		{
		GuiControl, Disable, Edit2
		GuiControl, Disable, UpDown2
		}
	}
Return

Checkbox3:
	{
	Gui, 2:Submit, NoHide
	IfEqual, Checkbox3, 1
		{
		GuiControl, Enable, Edit3
		GuiControl, Enable, UpDown3
		}
	IfEqual, Checkbox3, 0
		{
		GuiControl, Disable, Edit3
		GuiControl, Disable, UpDown3
		}
	}
Return

Checkbox4:
	{
	Gui, 2:Submit, NoHide
	IfEqual, Checkbox4, 1
		{
		GuiControl, Enable, Edit4
		GuiControl, Enable, UpDown4
		}
	IfEqual, Checkbox4, 0
		{
		GuiControl, Disable, Edit4
		GuiControl, Disable, UpDown4
		}
	}
Return

Checkbox5:
	{
	Gui, 2:Submit, NoHide
	IfEqual, Checkbox5, 1
		{
		GuiControl, Enable, Edit5
		GuiControl, Enable, UpDown5
		}
	IfEqual, Checkbox5, 0
		{
		GuiControl, Disable, Edit5
		GuiControl, Disable, UpDown5
		}
	}
Return

Checkbox6:
	{
	Gui, 2:Submit, NoHide
	IfEqual, Checkbox6, 1
		{
		GuiControl, Enable, Edit6
		GuiControl, Enable, UpDown6
		}
	IfEqual, Checkbox6, 0
		{
		GuiControl, Disable, Edit6
		GuiControl, Disable, UpDown6
		}
	}
Return

2ButtonOK:
	{
	Gui, 2:Submit, NoHide
	IniWrite, "%Path%", %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Path to JAR
	IfEqual, Checkbox1, 1
		{
		IniWrite, %UpDown1%m, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Xms
		}
	IfEqual, Checkbox1, 0
		{
		IniWrite, %A_Space%, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Xms
		}
	IfEqual, Checkbox2, 1
		{
		IniWrite, %UpDown2%m, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Xmx
		}
	IfEqual, Checkbox2, 0
		{
		IniWrite, %A_Space%, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Xmx
		}
	IfEqual, Checkbox3, 1
		{
		IniWrite, %UpDown3%m, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, PermSize
		}
	IfEqual, Checkbox3, 0
		{
		IniWrite, %A_Space%, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, PermSize
		}
	IfEqual, Checkbox4, 1
		{
		IniWrite, %UpDown4%m, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, MaxPermSize
		}
	IfEqual, Checkbox4, 0
		{
		IniWrite, %A_Space%, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, MaxPermSize
		}
	IfEqual, Checkbox5, 1
		{
		IniWrite, %UpDown5%m, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, NewSize
		}
	IfEqual, Checkbox5, 0
		{
		IniWrite, %A_Space%, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, NewSize
		}
	IfEqual, Checkbox6, 1
		{
		IniWrite, %UpDown6%m, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, MaxNewSize
		}
	IfEqual, Checkbox6, 0
		{
		IniWrite, %A_Space%, %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, MaxNewSize
		}
	Gui, 2:Destroy
	}
Return

RestoreDefaults:
	{
	GuiControl,2:, Checkbox1, 1
		GuiControl, Enable, Edit1
		GuiControl, Enable, UpDown1
		GuiControl,, Edit1, 512
		GuiControl,, UpDown1, 512
	GuiControl,2:, Checkbox2, 1
		GuiControl, Enable, Edit2
		GuiControl, Enable, UpDown2
		GuiControl,, Edit2, 1024
		GuiControl,, UpDown2, 1024
	GuiControl,2:, Checkbox3, 1
		GuiControl, Enable, Edit3
		GuiControl, Enable, UpDown3
		GuiControl,, Edit3, 128
		GuiControl,, UpDown3, 128
	GuiControl,2:, Checkbox4, 1
		GuiControl, Enable, Edit4
		GuiControl, Enable, UpDown4
		GuiControl,, Edit4, 128
		GuiControl,, UpDown4, 128
	GuiControl,2:, Checkbox5, 1
		GuiControl, Enable, Edit5
		GuiControl, Enable, UpDown5
		GuiControl,, Edit5, 128
		GuiControl,, UpDown5, 128
	GuiControl,2:, Checkbox6, 1
		GuiControl, Enable, Edit6
		GuiControl, Enable, UpDown6
		GuiControl,, Edit6, 128
		GuiControl,, UpDown6, 128
	Gui, 2:Submit, NoHide
	}
Return


2GuiClose:
	{
	Gui, 2:Destroy
	}
Return


About:
	{
	Gui, 3:-SysMenu +AlwaysOnTop
	Gui, 3:Add, Picture, x36 y0 w50 h50 , %A_ScriptDir%\Hide NI DOS (files)\PSicon48x48.ico
	Gui, 3:Font, S15 w700, Verdana
	Gui, 3:Add, Text, x122 y20 w230 h30 +Center cWhite, Hide NI DOS  v1.00
	Gui, 3:Font, S10 w700, Verdana
	Gui, 3:Add, Text, x7 y50 w460 h40 +Center cWhite, Quietly runs NearInfinity with the specified VM Options.
	Gui, 3:Add, Text, x97 y90 w280 h20 +Center cWhite, Copyright © 2010 Sam Schmitz
	Gui, 3:Font, S8, Verdana
	Gui, 3:Add, Edit, x10 y120 w460 h300 +Center cWhite -TabStop ReadOnly, This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.`n`nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.`n`nYou should have received a copy of the GNU General Public License along with this program (%A_ScriptDir%\Hide NI DOS (files)\COPYING.html).  If not, see <http://www.gnu.org/licenses/>.`n`nYou may contact Sam Schmitz at <sampsca@yahoo.com> or by sending a PM to Sam. at <http://www.shsforums.net/index.php?showuser=10485>.
	Gui, 3:Add, Button, x188 y430 w100 h30 g3ButtonOK, OK
	Gui, 3:Color, 000000
	Gui, 3:Show, w480 h470, About
	}
Return

3ButtonOK:
    {
	3GuiClose:
		{
		Gui, 3:Destroy
		}
	Return
    }
Return



LoadPath:
	{
	FileSelectFile, Path, 3, %A_ScriptDir%, Select NearInfinity's .JAR file., Java ARchive (*.jar)
		if Path =
			{
			Return
			}
		Else
			{
			IniWrite, "%Path%", %A_ScriptDir%\Hide NI DOS (files)\Hide NI DOS Config.txt, Program Options, Path to JAR
			}
	}
Return