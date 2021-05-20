@echo off
color 7
cls
start C:\Mercadologic\Atualizacao\Programas\databridge-1.7.0.msi
echo Aguarde a instalacao finalizar para continuar.
pause
timeout /t 5 /nobreak >null

exit