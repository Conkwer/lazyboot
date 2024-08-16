@echo off
rem examples: 45000; 11702
set lba=45000
set binary=1ST_READ.BIN

:: mkcdi.exe based on Python 3.12.3 and compiled via pyinstaller and do not works on WinXP
for /f "tokens=2 delims=[]" %%i in ('ver') do set VERSION=%%i
for /f "tokens=2-3 delims=. " %%i in ("%VERSION%") do set VERSION=%%i.%%j

if "%VERSION%" == "5.00" goto winxp
if "%VERSION%" == "5.0" goto winxp
if "%VERSION%" == "5.1" goto winxp
REM ---------------------------------

setlocal
set PATH=.\tools;%PATH%

REM ---------------------------------
if not exist data mkdir data

for /f "usebackq delims=" %%G in (`tools\busybox.exe sh ./tools/basher.sh`) do set "build=%%G"

if not exist ".\data\%binary%" sfk echo [yellow]Warning: %binary% not found.[def]&&timeout /t 7&&exit

attrib -R data\*.* >NUL

if not exist .\data\IP.BIN sfk echo [yellow]Warning: IP.BIN not found[def]&&echo creating generic IP.BIN..&&.\tools\busybox.exe sleep 2&&cls
if not exist .\data\IP.BIN busybox cp ./tools/precon/katana.bin ./data/IP.BIN

if exist .\data\1NOSDC.BIN set binary=1NOSDC.BIN&&busybox cp .\tools\precon\lodoss-5167.bin .\data\IP.BIN
if exist .\data\0WINCEOS.BIN set binary=0WINCEOS.BIN&&busybox cp .\tools\precon\wince.bin .\data\IP.BIN

echo ------------->>mkcdi.log&&echo %lba%>>mkcdi.log&&echo %binary%>>mkcdi.log

hack4 -w -p data\*.bin >NUL
hack4 -w -n %lba% data\*.bin >NUL
copy data\%binary% >NUL
copy data\IP.BIN >NUL

echo %binary% > tools\BINHACK
echo IP.BIN >> tools\BINHACK
echo %lba% >> tools\BINHACK

binhack < tools\BINHACK >NUL

move %binary% data\%binary% >NUL
move IP.BIN data\IP.BIN >NUL
:ignore


REM ----------------------------------
REM name generator
echo %build%>>mkcdi.log
set romname=dcgame
if exist .\tools\cfg\volumelabel.cfg set /p romname=<.\tools\cfg\volumelabel.cfg
if exist .\tools\romname.ini sfk echo -spat Your game is \q[green]"%romname%"[def]\q?
:: sfk echo Enter the name of your image
:: sfk echo Example: [cyan]lodoss[def]
echo.
:: set /P romname=
echo %romname%> .\tools\romname.ini&&echo %romname%>>mkcdi.log
sfk replace -binary /22// -dir tools -file romname.ini -yes -quiet


REM ---------------------------------
REM core script
if exist test.iso del test.iso
rem tools\logoinsert tools\logo.mr .\data\IP.BIN
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

:winxp
cd /D "%~dp0"&&set HOME=.\
call tools\Lazyboot.cmd