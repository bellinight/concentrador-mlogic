@echo off

echo Conferindo Path
echo %Path%
timeout /t 3 /nobreak >null
cls
echo Passo importante para conclusão da instalacao do Concentrador.
timeout /t 2 /nobreak >null
echo Altere a senha do usuario postgres de "postgres" para "local".
timeout /t 2 /nobreak >null
echo Executando PGAdmin aguarde...
timeout /t 5 /nobreak >null

"C:\Program Files\PostgreSQL\12\pgAdmin 4\bin\pgAdmin4.exe"

timeout /t 60