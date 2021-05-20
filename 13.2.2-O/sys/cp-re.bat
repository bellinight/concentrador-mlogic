@echo off
cls
rem Backup do concentrador
Set /p DirName= Renomeie o diretorio de backup :

xcopy c:\Mercadologic\Concentrador\* c:\Mercadologic\%DirName%\ /s /e

