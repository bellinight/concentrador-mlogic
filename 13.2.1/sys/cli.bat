@echo off

echo instala CLI WINGET para instalação de programas sideload

C:\Mercadologic\dist\install-cli.appxbundle

echo Aguarde o Final da Instalação para Prosseguir...

pause

echo Instala PostgreSQL 12

winget install  -h PostgreSQL.PostgreSQL -v "12.4.1"

timeout /t 5 >null

echo Instala OPEN JAVA 13 

winget install -h ojdkbuild.ojdkbuild -v "13.0.3-1"  

timeout /t 3 /nobreak >null

exit

