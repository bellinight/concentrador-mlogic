@echo off

color 9

rem Set /p DirName= Digite a Versao que deseja ativar:
echo "Realmente deseja atualizar para nova versão?"
echo "Este processo não pode ser revertido..."

del /f /a C:\Mercadologic\Concentrador\*.*
xcopy /E /Y "C:\Mercadologic\Programas\Concentrador\*.*"  "C:\Mercadologic\Concentrador\"
xcopy /E /Y "C:\Mercadologic\Concentrador_old\imagens-pdv\*.*"  "C:\Mercadologic\Concentrador\imagens-pdv\"
xcopy /E /Y "C:\Mercadologic\Concentrador_old\recursos\*.*"  "C:\Mercadologic\Concentrador\recursos\"

timeout /t 3 /nobreak >null
exit