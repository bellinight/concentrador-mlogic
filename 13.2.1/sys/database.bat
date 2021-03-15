@echo off

echo Criando DBMercadologic, aguarde...
echo Quando solicitado, digite a senha (postgres)
createdb -h localhost -p 5432 -W -U postgres DBMercadologic
echo Banco criado com sucesso
cls
echo Restaurando DBMercadologic, aguarde...
echo Quando solicitado, digite a senha (postgres)
pg_restore.exe --host localhost --port 5432 --username postgres --dbname DBMercadologic C:\Mercadologic\dist\DBMercadologic.backup
echo Restauração efetuada com sucesso

timeout /t 5 /nobreak >null

exit




