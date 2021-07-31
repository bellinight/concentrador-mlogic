mode con:cols=80 lines=10
@echo off
powershell.exe -NoP -NonI -Command "Expand-Archive 'C:\Mercadologic\Programas\ML_13.3.2.zip' 'C:\Mercadologic\Programas\'"

powershell.exe -NoP -NonI -Command "Expand-Archive 'C:\Mercadologic\Programas\Concentrador.zip' 'C:\Mercadologic\Programas\'"

powershell.exe -NoP -NonI -Command "Expand-Archive 'C:\Mercadologic\Programas\Utilitario.zip' 'C:\Mercadologic\'"