@echo off

echo "Aplicando Variavel JAVA_HOME"
SETX -m JAVA_HOME "C:\Program Files\Java\jdk-13.0.2\"
timeout /t 3 /nobreak >null
echo "Aplicando Path as Variaveis de Sistema"
SETX -m Path "%Path%;C:\Program Files\Java\jdk-13.0.2\bin;C:\Program Files\Java\jdk-13.0.1\bin;C:\Program Files\PostgreSQL\12\bin"
timeout /t 3 /nobreak >null

exit