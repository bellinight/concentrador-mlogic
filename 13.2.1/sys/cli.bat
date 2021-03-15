@echo off

C:\Mercadologic\dist\install-cli.appxbundle
timeout /t 5 /nobreak >null
C:\Mercadologic\dist\jdk-13.exe /q

winget install --silent PostgreSQL.PostgreSQL -v "12.4.1" 

timeout /t 3 /nobreak >null

exit

