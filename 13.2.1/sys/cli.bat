@echo off
rem instala CLI WINGET para instalação de programas sideload
C:\Mercadologic\dist\install-cli.appxbundle
timeout /t 5 /nobreak >null
REM C:\Mercadologic\dist\jdk-13.exe /q
REM Instala PostgreSQL 12
winget install PostgreSQL.PostgreSQL -h -v "12.4.1"
REM Instala OPEN JAVA 13 
winget install ojdkbuild.ojdkbuild -h -v "13.0.3-1"  
rem tempo de espera Prevenção
timeout /t 3 /nobreak >null

exit

