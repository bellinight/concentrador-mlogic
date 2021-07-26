echo off

Set /p IP= Digite o IP do concentrador:


powershell -Command "(gc C:\Mercadologic\concentrador\hibernate.cfg.xml) -replace '//localhost', '//%IP%' | Out-File C:\Mercadologic\concentrador\hibernate.cfg.xml"
powershell -Command "(gc C:\Mercadologic\concentrador\hibernate.cfg.xml) -replace 'validate', 'update' | Out-File C:\Mercadologic\concentrador\hibernate.cfg.xml"