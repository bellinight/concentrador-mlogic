@echo off
cls
color 6
Set /p DirName= Digite a Versao, (*numero e pontos (EX: 13.3.0)):
rem Copia recursos e imagens do concentrador antigo
echo "Copiando Recursos e Imagens"
xcopy /E /Y "C:\Mercadologic\Concentrador\recursos\*.*"  "C:\Mercadologic\Atualizacao\%DirName%\Concentrador\recursos\"
xcopy /E /Y "C:\Mercadologic\Concentrador\imagens-pdv\*.*"  "C:\Mercadologic\Atualizacao\%DirName%\Concentrador\imagens-pdv\"
timeout /t 3 /nobreak >null
exit