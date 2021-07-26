@echo off
rem Compartilha a PASta do sistema para todos usuarios com acesso full
net share Mercadologic$=c:\Mercadologic /grant:todos,full
net share Mercadologic$\Distribuicao=c:\Mercadologic\Distribuicao /grant:todos,full




