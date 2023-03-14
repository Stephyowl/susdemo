RunAsTask_CreateShortcut( TaskName := "", Folder := "", ShcName := "" ) { ; by SKAN, http://goo.gl/yG6A1F
  Local LINK, Description

  IfEqual, TaskName,, Return 
  LINK := ( FileExist( Folder )  ? Folder : A_ScriptDir ) "\" ( ShcName ? ShcName : A_ScriptName ) ".lnk"
  FileGetShortcut, %LINK%,,,, Description
  If ( Description <> Taskname ) 
    FileCreateShortcut, schtasks.exe, %LINK%, %A_WorkingDir%,/run /tn "%TaskName%", %TaskName%,,,, 7
}