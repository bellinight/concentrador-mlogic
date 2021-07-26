echo off

rem Set /p txt01= Digite a Versao que deseja ativar:


powershell -Command "(gc C:\Mercadologic\concentrador\hibernate.cfg.xml) -replace 'update', 'validate' | Out-File C:\Mercadologic\concentrador\hibernate.cfg.xml"