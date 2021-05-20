@echo off
echo "Copiando Security para pasta JAVA openJDK"
xcopy /E /Y "C:\Mercadologic\cp-base\security\"  "C:\Program Files\ojdkbuild\java-13-openjdk-13.0.3-1\conf\security\"
timeout /t 3 /nobreak >null

rem xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\10\data\"
echo "Copiando Postgres_hba para pasta PostgreSQL\12\data\"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\12\data\"
rem xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\13\data\"
timeout /t 3 /nobreak >null

exit