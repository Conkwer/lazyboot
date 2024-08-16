@echo off

::11702, 45000
set lba=45000
set volumename=dcgame

mkcdi.exe -i .\data -V "%volumename%" -l %lba%
rem  pyinstaller --onefile --add-binary "mkisofs.exe;." mkisofs_int.py

timeout /t 10
exit