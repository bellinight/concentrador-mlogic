@echo off

echo Conferindo Path
echo %Path%
timeout /t 10 
cls
echo Este e um passo importante para conclusao do Concentrador.
timeout /t 2 /nobreak >null
echo Altere a senha do usuario postgres de "postgres" para "local no PGAdmin".
timeout /t 2 /nobreak >null
echo Tecle enter para co
echo Executando PGAdmin aguarde...
timeout /t 5 /nobreak >null
"C:\Program Files\PostgreSQL\12\pgAdmin 4\bin\pgAdmin4.exe"
timeout /t 60