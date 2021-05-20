@echo off
cls
color 4
Set /p DirName= Digite a Versao que deseja ativar:
echo "Ativar Concentrador"
xcopy /E /Y "C:\Mercadologic\Atualizacao\%DirName%\Concentrador\*"  "C:\Mercadologic\Concentrador\"

timeout /t 3 /nobreak >null
exit