@echo off
color 5
echo "Copiando APPSetings"
xcopy /E /Y "C:\Program Files (x86)\Processa Sistemas\DataBridge\Config.AppSettings.xml"  "C:\Mercadologic\dist\"
xcopy /E /Y "C:\Program Files (x86)\Processa Sistemas\DataBridge\Config.ConnectionStrings.xml"  "C:\Mercadologic\dist\"
exit




