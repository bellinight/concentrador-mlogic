mode con:cols=80 lines=10
@echo off
color 9
rem Set /p DirName= Digite a Versao que deseja ativar:
echo "Realmente deseja atualizar para nova versao?"
echo "Este processo nao pode ser revertido..."
rd /s C:\Mercadologic\Concentrador
echo "Copiando"
xcopy /E /Y "C:\Mercadologic\Programas\Concentrador\*.*"  "C:\Mercadologic\Concentrador\"
xcopy /E /Y "C:\Mercadologic\Concentrador_old\imagens-pdv\*.*"  "C:\Mercadologic\Concentrador\imagens-pdv\"
xcopy /E /Y "C:\Mercadologic\Concentrador_old\recursos\*.*"  "C:\Mercadologic\Concentrador\recursos\"
xcopy /E /Y "C:\Mercadologic\Programas\pdv-13.3.2-linux.tar.gz"  "C:\Mercadologic\Concentrador\distribuicao"

timeout /t 3 /nobreak >null
exit
