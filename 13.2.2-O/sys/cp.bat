@echo off
cls
color 5
echo "Copiando Postgres_hba"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres\*.*"  "C:\Program Files\PostgreSQL\12\data\"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres\*.*"  "C:\Program Files\PostgreSQL\13\data\"
timeout /t 3 /nobreak >null
exit