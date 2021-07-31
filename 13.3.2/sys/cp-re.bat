mode con:cols=80 lines=10
@echo off
echo Efetuando backup do concentrador...
rem Set /p DirName= Qual a Versão Atual:
rd /s C:\Mercadologic\Concentrador_old
xcopy c:\Mercadologic\Concentrador\*.* c:\Mercadologic\Concentrador_old\ /s /e

