mode con:cols=80 lines=10
@echo off
del /Q C:\Mercadologic\Programas\*.*
mkdir /Q C:\Mercadologic\Programas
echo Baixando Arquivos
bitsadmin /transfer PostgreSql /download /priority foreground https://www.dropbox.com/s/poxmyv10w2vfn87/postgresql-12.5-1-windows-x64.exe?dl=1 C:\Mercadologic\Programas\bd-source.exe
bitsadmin /transfer MLFULL /download /priority foreground https://www.dropbox.com/s/jy7c7vqk6eo9h85/ML_13.3.2.zip?dl=1 C:\Mercadologic\Programas\ML_13.3.2.zip
bitsadmin /transfer Java13 /download /priority foreground https://www.dropbox.com/s/hqrxn018ewskg4f/jdk-13.0.2_windows-x64_bin.exe?dl=1 C:\Mercadologic\Programas\java-source.exe
bitsadmin /transfer SqlCompact32 /download /priority foreground https://www.dropbox.com/s/321i6sop2girbfq/SSCERuntime_x86-ENU.msi?dl=1 C:\Mercadologic\Programas\java-source.exe
bitsadmin /transfer SqlCompact64 /download /priority foreground https://www.dropbox.com/s/wfv53nf3taopl5i/SSCERuntime_x64-ENU.msi?dl=1 C:\Mercadologic\Programas\java-source.exe
bitsadmin /transfer TKGER /download /priority foreground https://www.dropbox.com/s/gdiy6ew0lrtrrva/Toolkit.Gerencial-1.9.20-Setup.msi?dl=1 C:\Mercadologic\Programas\java-source.exe
bitsadmin /transfer ML-Backup /download /priority foreground https://www.dropbox.com/s/kkf6up3zy9yxmwi/Mlogic-1.0.11_r23077-Setup.msi?dl=1 C:\Mercadologic\Programas\java-source.exe
bitsadmin /transfer  ElginLib /download /priority foreground https://www.dropbox.com/s/4g8q6d2jep79m37/Biblioteca%20Elgin-9.rar?dl=1' C:\Mercadologic\Programas\java-source.exe
bitsadmin /transfer  ML-Update /download /priority foreground https://drive.google.com/u/0/uc?export=download&confirm=zJJf&id=1unmdgu8yUCbN594KKlXIS5lhFNk7O3Gc C:\Mercadologic\Programas\ML-Update.exe

    