@echo off


echo Criando DBMercadologic, aguarde...
timeout /t 5 /nobreak >null
createdb -h localhost -p 5432 -U postgres DBMercadologic
echo Banco criado com sucesso
timeout /t 5 /nobreak >null
cls
echo Vamos Começar a Restauracao do Banco de Dados.
echo Restaurando DBMercadologic, aguarde...
echo Quando solicitado, digite a senha
pg_restore.exe --host localhost --port 5432 --username postgres --dbname DBMercadologic C:\Mercadologic\dist\DBMercadologic.backup
echo Restauração efetuada com sucesso, finalizando...
timeout /t 5 /nobreak >null

cls

exit




