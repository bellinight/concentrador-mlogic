@echo off

winget install -h Notepad++.Notepad++
winget install -h RARLab.WinRAR
winget install -h Devolutions.RemoteDesktopManagerFree

timeout /t 5 /nobreak >null
 
exit