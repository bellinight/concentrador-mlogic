@echo off
color 7
cls
start C:\Mercadologic\Programas\databridge-1.8.0.msi
echo Aguarde a instalacao finalizar para continuar.
pause
timeout /t 5 /nobreak >null

exit