@echo off
rem examples: 45000; 11702
set lba=45000
set binary=1ST_READ.BIN

setlocal
set PATH=.\system;%PATH%

REM ---------------------------------
if not exist data mkdir data
cd system&&busybox.exe bash date.sh&&cd ..


if not exist ".\data\%binary%" sfk echo [yellow]Warning: 1ST_READ.BIN not found.[def]&&timeout /t 7&&exit

attrib -R data\*.* >NUL

if not exist .\data\IP.BIN sfk echo [yellow]Warning: IP.BIN not found[def]&&echo creating generic IP.BIN..&&.\system\busybox.exe sleep 2&&cls
if not exist .\data\IP.BIN busybox cp ./system/precon/katana.bin ./data/IP.BIN

if exist .\data\1NOSDC.BIN set binary=1NOSDC.BIN&&busybox cp .\system\precon\lodoss-5167.bin .\data\IP.BIN
if exist .\data\0WINCEOS.BIN set binary=0WINCEOS.BIN&&busybox cp .\system\precon\wince.bin .\data\IP.BIN

echo ------------->>builder.log&&echo %lba%>>builder.log&&echo %binary%>>builder.log

hack4 -w -p data\*.bin >NUL
hack4 -w -n %lba% data\*.bin >NUL
copy data\%binary% >NUL
copy data\IP.BIN >NUL

echo %binary% > system\BINHACK
echo IP.BIN >> system\BINHACK
echo %lba% >> system\BINHACK

binhack < system\BINHACK >NUL

move %binary% data\%binary% >NUL
move IP.BIN data\IP.BIN >NUL
:ignore


REM ----------------------------------
REM name generator
set /p build=<.\system\build.ver
echo %build%>>builder.log
if not exist .\system\romname.ini echo dreamcast-game>>.\system\romname.ini
set /p romname=< .\system\romname.ini
if exist .\system\romname.ini sfk echo -spat Your game is \q[green]"%romname%"[def]\q?
sfk echo Enter the name of your image
sfk echo Example: [cyan]lodoss[def]
echo.
set /P romname=
echo %romname%> .\system\romname.ini&&echo %romname%>>builder.log
sfk replace -binary /22// -dir system -file romname.ini -yes -quiet


REM ---------------------------------
REM core script
if exist test.iso del test.iso
rem system\logoinsert system\logo.mr .\data\IP.BIN
set sort=&&if exist sortfile.str set sort=-sort sortfile.str
mkisofs -C 0,%lba% -V "%romname%" %sort% -exclude IP.BIN -G data\IP.BIN -l -J -r -o test.iso data
iso2cdi -i .\test.iso -l %lba% -o .\image.cdi
if exist image.cdi del test.iso
rem ren image.cdi "%romname%-%build%.tmp"&&del *.cdi&&ren *.tmp *.cdi
ren image.cdi "%romname%-%build%.tmp"
if not exist archive mkdir archive
if exist *.cdi move *.cdi .\archive\>NUL
ren *.tmp *.cdi
sfk echo file [cyan]"%romname%-%build%.cdi"[def] is created.
sfk echo this windows will be closed automatically
timeout /t 10

exit
