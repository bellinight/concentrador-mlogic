@echo off 
cd %1%

rem Validando se o JAVA_HOME existe nas variaveis de ambiente
rem Esta variavel e utilizada para localizar o Cacerts do Java.
if not defined JAVA_HOME (
	echo Nao existe a variavel de ambiente JAVA_HOME.
	echo Favor criar a respectiva variavel apontando para a pasta do Java.
	echo Por exemplo: C:\Program Files\Java\jre7
	exit /b
)

rem Somente o Windows tem a variavel de ambiente "OS" definida
if defined OS (
	set JAVA_BIN=%JAVA_HOME%\bin
	set CACERTS=%JAVA_HOME%\lib\security\cacerts
)

rem Definindo valores padräes
set PATH=%PATH%;%JAVA_BIN%
set SENHA_DEFAULT=pr0c3ss4
set CERT_DEFAULT=CertificadoDigital.jks
if exist %CERT_DEFAULT% del /Q %CERT_DEFAULT%

:PRE_VALIDACAO
echo. 
echo E necessario que o certificado *.pfx do cliente ja esteja nesta pasta.
choice /M "O certificado do cliente ja esta na pasta "
if ERRORLEVEL 2 goto :SEM_CERTIFICADO
if ERRORLEVEL 1 goto :PRINCIPAL

:PRINCIPAL
	rem Comando que busca, dentro da pasta, o certificado que sera instalado
	rem e em seguida escreve o nome dentro do arquivo "tmp.txt",o qual sera atribu¡do para
	rem a variavel CERT_ORIG. (Obs: nao encontrei uma forma de fazer a atribuicao diretamente)
	(dir /B *.pfx)>>tmp.txt
	set /P CERT_ORIG=<tmp.txt
	del tmp.txt
	echo.
	echo -------------------------------------------------
	echo Importanto o certificado %CERT_ORIG%
	echo -------------------------------------------------
	set /P CERT_ORIG_SENHA="Informe a senha do certificado: " 
	cls
	echo -------------------------------------------------
	echo Gerando o %CERT_DEFAULT%
	echo -------------------------------------------------
	
	rem Comando responsavel por importar o certificado do cliente para dentro da
	rem keystore CertificadoDigital.jks, que sera usada para assinar os XMLs.
	keytool -importkeystore -srckeystore "%CERT_ORIG%" -srcstorepass "%CERT_ORIG_SENHA%" -srcstoretype pkcs12 -destkeystore "%CERT_DEFAULT%" -storepass "%SENHA_DEFAULT%" -deststoretype JKS 

	rem Comando que lista os dados do certificado, inclusive o alias, e escreve o nome 
	rem dentro do arquivo "tmp.txt", o qual sera utilizado no loop seguinte.
	(keytool -list -keystore "%CERT_ORIG%" -storetype pkcs12 -storepass "%CERT_ORIG_SENHA%")>>tmp.txt
	
	rem Comando que pega o alias dentro do arquivo "tmp.txt".
	rem O Alias sempre estara na linha "6" e antes da primeira v¡rgula ",".
	for /F "skip=5 delims=," %%a in (tmp.txt) do set ALIAS=%%a&goto :NEXTLINE
	:NEXTLINE
	del tmp.txt
	echo.
	
	rem Comando que altera a senha do CertificadoDigital.jks e tambem a senha da
	rem chave do certificado, colocando a senha padrao.
	keytool -keypasswd -alias "%ALIAS%" -keypass "%CERT_ORIG_SENHA%" -new "%SENHA_DEFAULT%" -keystore "%CERT_DEFAULT%" -storepass "%SENHA_DEFAULT%" -storetype JKS
	goto :END

:SEM_CERTIFICADO
	echo.
	echo Coloque o certificado *.pfx do cliente na pasta e rode o script novamente.
	echo.
	pause

:END
echo.
echo Certificado %CERT_DEFAULT% gerado com sucesso!
pause
echo.
