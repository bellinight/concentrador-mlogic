@echo off

echo Vamos Começar a Restauracao do Banco de Dados.
echo Criando DBMercadologic, aguarde...
echo Quando solicitado, digite a senha (postgres)
timeout /t 5 /nobreak >null
createdb -h localhost -p 5432 -W -U postgres DBMercadologic
echo Banco criado com sucesso
timeout /t 5 /nobreak >null
cls
echo Restaurando DBMercadologic, aguarde...
echo Quando solicitado, digite a senha (postgres)
pg_restore.exe --host localhost --port 5432 --username postgres --dbname DBMercadologic C:\Mercadologic\dist\DBMercadologic.backup
echo Restauração efetuada com sucesso, finalizando conexão.
timeout /t 10 /nobreak >null

echo Conferindo Path
echo %Path%
timeout /t 3 /nobreak >null
cls
echo Este e um passo importante para conclusao do Concentrador.
timeout /t 2 /nobreak >null
echo Altere a senha do usuario postgres de "postgres" para "local no PGAdmin".
timeout /t 2 /nobreak >null
echo Tecle enter para com
echo Executando PGAdmin aguarde...
timeout /t 5 /nobreak >null
"C:\Program Files\PostgreSQL\12\pgAdmin 4\bin\pgAdmin4.exe"
timeout /t 10
exit




