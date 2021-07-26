@echo off
cls
rem Set /p vpostgres= Digite a Versao da:
color 5
echo "Copiando Postgres_hba"
xcopy /E /Y "C:\Program Files\PostgreSQL\10\data\pg_hba.conf"  "C:\Program Files\PostgreSQL\12\data\"
xcopy /E /Y "C:\Program Files\PostgreSQL\10\data\postgresql.conf"  "C:\Program Files\PostgreSQL\12\data\"
rem Copia appsetigns do Databridge
exit




