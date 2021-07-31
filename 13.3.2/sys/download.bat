mode con:cols=80 lines=10
@echo off
echo Baixando Arquivos
bitsadmin /transfer PostgreSql /download /priority foreground https://www.dropbox.com/s/poxmyv10w2vfn87/postgresql-12.5-1-windows-x64.exe?dl=1 C:\Mercadologic\Programas\bd-source.exe
bitsadmin /transfer MLFULL /download /priority foreground https://www.dropbox.com/s/jy7c7vqk6eo9h85/ML_13.3.2.zip?dl=1 C:\Mercadologic\Programas\ML_13.3.2.zip
bitsadmin /transfer Java13 /download /priority foreground https://www.dropbox.com/s/hqrxn018ewskg4f/jdk-13.0.2_windows-x64_bin.exe?dl=1 C:\Mercadologic\Programas\java-source.exe





