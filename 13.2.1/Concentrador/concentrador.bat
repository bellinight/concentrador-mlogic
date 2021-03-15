 :: Executa os comandos sem mostra-los no prompt
@echo off

:: Mostra o processo rodando e procura pelo proprio:
tasklist /FI "IMAGENAME eq javaw.exe" 2>nul |find /I /N "javaw.exe">nul
start javaw --enable-preview -cp ".;lib/*;lib/help/*;lib/hibernate/*;lib/lib-relatorios/*;lib/message-queue/*;lib/nfce/*;lib/leitor-biometrico/*" br.com.pi.concentrador.Main