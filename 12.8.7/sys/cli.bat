@echo off


echo Instala OPEN JAVA 13 

winget install -h ojdkbuild.ojdkbuild -v "13.0.3-1"  

timeout /t 3 /nobreak

exit

