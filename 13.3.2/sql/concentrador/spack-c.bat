rem Scriptpack via psql

setlocal enableDelayedExpansion
@echo off
ECHO. > "Execucao.log"
for %%G in (*.sql) do (

	ECHO -------------------------------------------------------- >> "Execucao.log"
	ECHO !DATE! !TIME! Executando o script "%%G"... >> "Execucao.log"
	ECHO -------------------------------------------------------- >> "Execucao.log"
	ECHO. >> "Execucao.log"
	
	psql -U postgres -w -d DBMercadologic -p 5432  -a -f "%%G" >> "Execucao.log"
	
	ECHO. >> "Execucao.log"
	ECHO Fim da execucao: !DATE! !TIME! >> "Execucao.log"
	ECHO -------------------------------------------------------- >> "Execucao.log"
	ECHO. >> "Execucao.log"
	ECHO. >> "Execucao.log"
)
exit
