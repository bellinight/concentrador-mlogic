@echo off
cls
echo "Ativar Concentrador"
xcopy /E /Y "C:\Mercadologic\Atualizacao\13.2.2\Concentrador\*"  "C:\Mercadologic\Concentrador\"

timeout /t 3 /nobreak >null
exit