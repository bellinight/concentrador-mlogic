@echo off
cls
winget install Notepad++.Notepad++ -h
winget install RARLab.WinRAR -h
winget install UltraVNC.UltraVNC -h
winget install mRemoteNG.mRemoteNG  -h
timeout /t 5 /nobreak >null

exit