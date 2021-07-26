@echo off
color 9
echo "Realmente deseja ativar a nova versão?"
echo "Este processo não pode ser revertido..."
Pause
del /f /a C:\Mercadologic\concentrador\*.*
xcopy /E /Y "C:\Mercadologic\Atualizacao\concentrador\*.*"  "C:\Mercadologic\concentrador\"
echo Finalizando...
timeout /t 3 /nobreak >null
exit