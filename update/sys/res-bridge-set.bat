@echo off
color 7
echo "Restaurando APPSetings"
xcopy /E /Y "C:\Mercadologic\dist\Config.AppSettings.xml"  "C:\Program Files (x86)\Processa Sistemas\DataBridge\"
xcopy /E /Y "C:\Mercadologic\dist\Config.ConnectionStrings.xml"  "C:\Program Files (x86)\Processa Sistemas\DataBridge\"
exit




