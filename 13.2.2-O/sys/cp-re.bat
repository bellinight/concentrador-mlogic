@echo off
cls

Set /p DirName= Renomeie o diretorio de backup :

xcopy c:\Mercadologic\Concentrador\* c:\Mercadologic\%DirName%\ /s /e

