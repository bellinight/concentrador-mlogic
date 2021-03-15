@echo off


xcopy /E /Y "C:\Mercadologi\cp-base\security\"  "C:\Program Files\Java\jdk-13.0.2\conf\security\"


xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\10\data\"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\12\data\"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\13\data\"


xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\10\data\"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres\"  "C:\Program Files\PostgreSQL\12\data\"
xcopy /E /Y "C:\Mercadologic\cp-base\postgres"  "C:\Program Files\PostgreSQL\13\data\"

exit