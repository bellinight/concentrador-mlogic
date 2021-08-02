@echo off
echo Limpando...
dropdb -h localhost -p 5432 -U postgres DBTeste
echo Criando DBTeste, aguarde...
rem echo Quando solicitado, digite a senha do usuario postgres
createdb -h localhost -p 5432 -U postgres DBTeste
echo Banco criado com sucesso
echo Vamos Comecar a Restauracao do Banco de Dados.
echo Restaurando DBMercadologic em DBTeste, aguarde...
rem echo Quando solicitado, digite a senha do usuario postgres
pg_restore.exe --host localhost --port 5432 --username postgres --dbname DBTeste C:\Mercadologic\backup-update\DBMercadologic.backup
echo Restauração efetuada com sucesso, finalizando...
exit




