@echo off
cls
echo Vamos Começar a Restauracao do Banco de Dados.
echo Restaurando DBMercadologic, aguarde...
echo Quando solicitado, digite a senha
pg_restore.exe --host localhost --port 5432 --username postgres --dbname DBMercadologic C:\Mercadologic\backup-update\DBMercadologic.backup
echo Restauração efetuada com sucesso, finalizando...
timeout /t 5 /nobreak >null
exit




