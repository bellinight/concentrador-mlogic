@echo off
echo Criando DBMercadologic, aguarde...
timeout /t 2 /nobreak >null
createdb -h localhost -p 5432 -U postgres DBMercadologic
echo Banco criado com sucesso
timeout /t 2 /nobreak >null
cls
echo Vamos Começar a Indexação do Banco de Dados.
echo Aplicando Banco de dados Padrão, aguarde...
rem echo Quando solicitado, digite a senha
pg_restore --host localhost --port 5432 --username postgres --dbname DBMercadologic C:\Mercadologic\dist\DBMercadologic.backup
echo finalizando...
timeout /t 2 /nobreak >null
exit




