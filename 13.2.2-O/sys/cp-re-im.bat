@echo off
cls
rem echo "Copiando Security para pasta JAVA openJDK"
rem xcopy /E /Y "C:\Mercadologic\cp-base\security\*.*"  "C:\Program Files\ojdkbuild\java-13-openjdk-13.0.3-1\conf\security\"
rem timeout /t 3 /nobreak >null
rem xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\10\data\"
echo "Copiando Recursos e Imagens"
xcopy /E /Y "C:\Mercadologic\Concentrador\recursos\*.*"  "C:\Mercadologic\Atualizacao\13.2.2\Concentrador\recursos\"
xcopy /E /Y "C:\Mercadologic\Concentrador\imagens-pdv\*.*"  "C:\Mercadologic\Atualizacao\13.2.2\Concentrador\imagens-pdv\"
timeout /t 3 /nobreak >null
exit