@echo off & setlocal enabledelayedexpansion & title <nul
mode 91,10 & color 0a & title Copiador Processa & cd. & echo=
@echo Carregando aplicacao de copia.
timeout /t 5 /nobreak
set /p "_dir_Origem= Digite ou Cole o caminho de origem: " && (
dir /d "!_dir_Origem!" | findstr /l \[\.\.\] > nul && (
set /p "_dir_Destino= Digite o diretorio de destino: "

if not "!_dir_Destino!\\" == "\\" goto :^? ) ) || echo= 
echo= Revise os seus argumentos/parâmetros informados:
echo= "!_dir_Origem!"  "!_dir_Origem!" & exit /b  ...

:^?
xcopy /c /y /e /v /f /i "!_dir_Origem!" "!_dir_Destino!"