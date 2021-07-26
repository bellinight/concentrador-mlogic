@echo off
cls
echo Efetuando backup do concentrador...
rem Set /p DirName= Renomeie o diretorio de backup :
xcopy c:\Mercadologic\Concentrador\*.* c:\Mercadologic\Concentrador_old\ /s /e

