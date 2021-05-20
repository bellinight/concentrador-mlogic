@echo off
cls
rem adiciona variavel JAVA_HOME para o OpenJDK
echo "Aplicando Variavel JAVA_HOME"
SETX -m JAVA_HOME "C:\Program Files\Java\jdk-13.0.2"
timeout /t 3 /nobreak >null
rem Aplica os pth´s necessarios para os concentrador acessar java e postgresql
echo "Aplicando Path as Variaveis de Sistema"
SETX -m Path "%Path%;C:\Program Files\PostgreSQL\12\bin;C:\Program Files\PostgreSQL\13\bin;C:\Program Files\Java\jdk-13.0.2\bin"
timeout /t 3 /nobreak >null
exit