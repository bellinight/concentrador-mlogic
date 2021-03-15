@echo off

echo Conferindo Variaveis do sistema.
echo %JAVA_HOME%
timeout /t 3 /nobreak >null
echo Conferindo Path
echo %Path%
timeout /t 3 /nobreak >null
pause
cls
echo Passo importante para conclusão da instalacao do Concentrador.
timeout /t 2 /nobreak >null
echo Altere a senha do usuario postgres de "postgres" para "local".
timeout /t 2 /nobreak >null
echo Executando PGAdmin aguarde...
timeout /t 5 /nobreak >null

"C:\Program Files\PostgreSQL\12\pgAdmin 4\bin\pgAdmin4.exe"