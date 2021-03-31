echo off
cls
color 03
for /F "tokens=1-4 delims=/ " %%I in ('DATE /t') do SET data=%%L-%%K-%%J
for /F "TOKENS=1-2* delims=:" %%A in ('TIME /t') do SET hora=%%Ahr%%Bmin
SET caminho=C:\Mercadologic\backup-update\
SET database=DBMercadologic
echo off
echo Arquivo de Backup: %caminho%%database%.backup
echo off
echo off
color 02
timeout /t 5 > null
set BACKUP_FILE=%caminho%%database%.sql
SET PGPASSWORD=local
pg_dump -h localhost -p 5432 -U postgres -F c > %caminho%%database%.backup %database%
rem echo %BACKUP_FILE%
pg_dumpall -p 5432 -U postgres -h localhost -f %BACKUP_FILE%
if not exist %caminho%%database%_%data%_%hora%.backup goto MESSAGE
if not exist %caminho%%database%_%data%_%hora%.sql goto MESSAGE
echo ------------------------------------------
echo BACKUP REALIZADO COM SUCESSO !!!!
echo ------------------------------------------
pause
echo off
goto END
:MESSAGE
echo *******************************************
echo ATENCAO: ERRO NA CRIACAO DO BACKUP !
echo *******************************************
echo off
:END