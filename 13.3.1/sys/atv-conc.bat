@echo off

color 9

rem Set /p DirName= Digite a Versao que deseja ativar:
echo "Realmente deseja atualizar para nova versão?"
echo "Este processo não pode ser revertido..."

del /f /a C:\Mercadologic\concentrador\*.*
xcopy /E /Y "C:\Mercadologic\Atualizacao\concentrador\*.*"  "C:\Mercadologic\concentrador\"

timeout /t 3 /nobreak >null
exit