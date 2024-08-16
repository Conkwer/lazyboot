@echo off

:FIRST_WARNING
if exist binhack.exe cd ..
rem if exist binhack.exe echo Don^'t run this script here^!&exit
tools\SFK color white

setLocal EnabledelayedExpansion
:SETTINGS_SET
if not exist tools\cfg\settings.ini copy /Y tools\settings.def tools\cfg\settings.ini >nul

set /a c=0
for /f "UseBackQ delims=" %%A in ("tools\cfg\settings.ini") do (
set /a c+=1
if !c!==1 set "automatic=%%A"
if !c!==2 set "sortfile=%%A"
if !c!==3 set "logo=%%A"
if !c!==4 set "alert=%%A"
if !c!==5 set "imagename=%%A"
if !c!==6 set "tool=%%A"
if !c!==7 set "mainbinary=%%A"
if !c!==8 set "scramble=%%A"
if !c!==9 set "binhack=%%A"
if !c!==10 set "datalabel=%%A"
if !c!==11 set "lbavalue=%%A"
if !c!==12 set "cdda=%%A"
if !c!==13 set "dcsystem=%%A"
if !c!==14 set "namelist=%%A"
if !c!==15 set "inducer=%%A"
if !c!==16 set "isonamechk=%%A"
)


REM checking if ISO 9660 data label name is standart
Set checkname=%datalabel%
REM skip if OFF in config
if %isonamechk%==isonamechk_off goto LBA_CALC
REM end
set allowed=9
echo %checkname%>"data\%~n0.tmpchk" 
for %%i In ("data\%~n0.tmpchk") Do Set /A result=%%~zi-2 
if exist data\*.tmpchk del /f /q data\*.tmpchk
if %result% GTR %allowed% goto ERROR_DATALABEL
REM end of this checking


:LBA_CALC
SET LBA=%lbavalue%
SET BINARY=%mainbinary%
if exist data\0WINCEOS.BIN set BINARY=0WINCEOS.BIN
SET BOOTSECTOR=IP.BIN
set BINHACK_CONF=null
set VOLUMELABEL="%datalabel%"



tools\SFK echo   [yellow]AUTOMATIC MODE[def] [cyan]is[def] [yellow]ON[def][cyan]. No questions will be asked[def]
echo.
tools\SFK echo   [cyan]Image will be called[def] [magenta]%imagename%[def].
echo.
tools\SFK sleep 900




:BINHACK_DEF
set SB_TOOL=%tool%
tools\SFK echo [magenta]HACK4 AND BINHACK:[def]
echo.
tools\SFK echo Modify [yellow]%BINARY%[def] and [yellow]%BOOTSECTOR%[def] for SelfBoot
echo.

REM  ELF KISS
set cnt=0
for %%I in (data\*.elf) do set /A cnt += 1
if %namelist%==namelist_on for %%a in (data\*.elf) do echo %%~na >> data\namelist.txt
if %cnt%==1 goto ELF_KOS

if %inducer%==inducer_off goto SKIP_INDUCER
if exist data\*.sbi goto MULTIMENU_SBI
:SKIP_INDUCER
if %binhack%==binhack_off goto HOMEBREW
:SKIP_2BINHACK
REM  END ELF KISS

if not exist data\%BINARY% goto BINARY_NOTFOUND
if not exist data\%BOOTSECTOR% set BOOTSECTOR=IP.BIN&IF %BINARY%==0WINCEOS.BIN copy tools\boots2 data\IP.BIN > tools\NULL
if not exist data\%BOOTSECTOR% set BOOTSECTOR=IP.BIN&copy tools\boots1 data\IP.BIN > tools\NULL
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL
tools\SFK echo    Binary files %BINARY% and %BOOTSECTOR% modified with the following values:
echo.
tools\SFK echo  Binary = [cyan]%BINARY%[def]
tools\SFK echo  Bootsector = [magenta]%BOOTSECTOR%[def]
tools\SFK echo  MSINFO value = [red]%LBA%[def]
echo.
tools\SFK echo [cyan]Bootsector data allocated. Continue without CDDA.[def]
echo Everything will work fine in 90% of cases.
echo.
tools\SFK sleep 600
goto BINHACK_DO



:HOMEBREW

tools\SFK echo But this is [cyan]disabled[def] in OPTIONS
echo image will be created with default settings...
echo.

if %dcsystem%==kos goto KALLISTI
if %dcsystem%==katana goto KATANA
if %dcsystem%==wince goto WINCE

echo This is KallistiOS (homebrew) game?
tools\SFK echo "Enter [cyan]"Y"[def], if YES and [cyan]"N"[def], if NO:
echo.
SET /P HOMEBREW_CONF=   

IF %HOMEBREW_CONF%==N goto KATANA
IF %HOMEBREW_CONF%==NO goto KATANA
IF %HOMEBREW_CONF%==Y GOTO KALLISTI
IF %HOMEBREW_CONF%==YES GOTO KALLISTI


:WINCE
REM for the future

:KATANA
IF NOT EXIST data\%BINARY% ECHO   Warning: Binary "%BINARY%" not found. Make sure main binary files are in the Data folder!!!&ECHO.&PAUSE&ECHO.
IF NOT EXIST data\%BOOTSECTOR% SET BOOTSECTOR=IP.BIN&IF %BINARY%==0WINCEOS.BIN COPY tools\boots2 data\IP.BIN > tools\NULL
IF NOT EXIST data\%BOOTSECTOR% SET BOOTSECTOR=IP.BIN&COPY tools\boots1 data\IP.BIN > tools\NULL
goto SB_CRIMAGE
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL

:KALLISTI
if not exist data\IP.BIN COPY tools\boots3 data\IP.BIN > tools\NULL
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL
goto SB_CRIMAGE

:ELF_KOS
tools\SFK echo [cyan]But this is [yellow]disabled[def] [cyan]because[def] [yellow]elf[def] [cyan]binary found[def]
tools\SFK echo image will be created with default values...
echo.
ren data\*.elf main.elf
if exist data\unscrambled.bin ren data\unscrambled_old.bin
tools\elf\sh-elf-objcopy.exe -O binary data/main.elf data/unscrambled.bin
tools\elf\scramble.exe data\unscrambled.bin data\1ST_READ.BIN
del /f /q data\unscrambled.bin
if exist data\1ST_READ.BIN del /f /q data\main.elf
if exist data\unscrambled_old.bin ren data\unscrambled.bin
set BINARY=1ST_READ.BIN
if not exist data\IP.BIN COPY tools\boots3 data\IP.BIN > tools\NULL
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL

goto SB_CRIMAGE


:MULTIMENU_SBI
tools\SFK echo [red]SBI[def] [cyan]file format detected. Binhack disabled.[cyan]
if not exist data\IP.BIN COPY tools\boots3 data\IP.BIN > tools\NULL
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL
tools\unzip.exe -qq -o tools\database\inducer.zip -d data\
for %%I in (data\*.sbi) do tools\unzip.exe -qq -o "%%I" -d "data\temp"
xcopy /Y /R /S /E data\temp\Inducer\*.* data\*.* >nul
rmdir /s /q data\temp
del /f /q data\*.sbi
echo.
tools\SFK echo [cyan]Edit files in data (add roms, music, etc) if needed[def]
tools\SFK echo [magenta]Are your ready to continue?[def]
echo.
pause
echo.
goto SB_CRIMAGE


:BINHACK_DO

ATTRIB -R data\*.* > tools\NULL
tools\hack4 -w -p data\*.bin > tools\NULL
tools\hack4 -w -n %LBA% data\*.bin > tools\NULL
copy data\%BINARY% > tools\NULL
copy data\%BOOTSECTOR% > tools\NULL
if %BINARY%==0WINCEOS.BIN tools\bincon 0WINCEOS.BIN 0WINCEOS.BIN %BOOTSECTOR% > tools\NULL
echo %BINARY% > tools\BINHACK
echo %BOOTSECTOR% >> tools\BINHACK
echo %LBA% >> tools\BINHACK
tools\binhack < tools\BINHACK > tools\NULL
move %BINARY% data\ >NUL
move %BOOTSECTOR% data\ >NUL


:SB_CRIMAGE
if exist %sortfile% set SORT=-sort %sortfile%
if exist data\0.0 set DUMMY=-hide 0.0 -hide-joliet 0.0
if exist data\Desktop.ini set EXC=-m Desktop.ini
if exist data\Thumbs.db set EXC=%EXC% -m Thumbs.db
if exist data\autorun.inf set HIDE=-hidden autorun.inf
tools\SFK echo [magenta]MKISOFS AND %tool%:[def]
if not exist data\%BINARY% goto BINARY_NOTFOUND
tools\SFK sleep 500

echo.
echo Generate ISO with game data..
tools\SFK sleep 500
echo.
echo MKISOFS: Generating ISO "%VOLUMELABEL%"...
tools\SFK sleep 500

tools\mkisofs -C 0,%LBA% -V %VOLUMELABEL% %SORT% %DUMMY% %EXC% %HIDE% -G data\%BOOTSECTOR% -l -J -r -o %VOLUMELABEL%.iso data

echo.

if not exist %VOLUMELABEL%.iso goto ERROR
tools\SFK echo [magenta]%SB_TOOL%: Generating SelfBoot image...[def]
echo.
tools\SFK sleep 500


tools\%SB_TOOL% %VOLUMELABEL%.iso %VOLUMELABEL%.cdi -l %LBA%
if not exist %VOLUMELABEL%.cdi goto ERROR

goto SKIP_ERRORS


:NON_SELFBOOT
echo.
echo Generate ISO with game data..
tools\SFK sleep 500
echo.
echo MKISOFS: Generating ISO %VOLUMELABEL%...
tools\SFK sleep 500
tools\mkisofs -V %VOLUMELABEL% %SORT% %DUMMY% %EXC% %HIDE% -l -J -r -o %VOLUMELABEL%.iso data
echo.
if not exist %VOLUMELABEL%.iso goto ERROR
echo.
tools\SFK echo [cyan]Image creating is complete.[def]
echo.

tools\datetimemsec >tools\timestamp.txt
set /p timestamp=<tools\timestamp.txt

ren %VOLUMELABEL%.iso "%imagename%-%timestamp%.iso" >NUL
if exist tools\NULL del  /f /q tools\NULL >nul
goto OK_DONE



:ERROR
tools\SFK echo [red]ERROR:[def] Error creating the data of the game. Process of SelfBoot creation cancelled
:ERROR_E
tools\SFK echo Exiting...
tools\SFK sleep 4000
pause
exit




:SKIP_ERRORS
echo.
tools\SFK echo [cyan]Creating of selfboot image is complete![def]
echo.

tools\datetimemsec >tools\timestamp.txt
set /p timestamp=<tools\timestamp.txt
if exist %datalabel%.cdi ren %datalabel%.cdi "%imagename%-%timestamp%.cdi" >NUL
if exist %datalabel%.mds ren %datalabel%.mds "%imagename%-%timestamp%.mds" >NUL
if exist %datalabel%.mdf ren %datalabel%.mdf "%imagename%-%timestamp%.mdf" >NUL

del /f /q %VOLUMELABEL%.iso
if exist tools\NULL del  /f /q tools\NULL >nul

:OK_DONE
tools\SFK echo [yellow]DONE![def]
tools\SFK sleep 500
echo.
tools\SFK echo  [yellow]Exiting...[def]
tools\SFK sleep 2700
exit

:BINARY_NOTFOUND
tools\SFK echo [red]WARNING:[def] [yellow]data\%BINARY% not found[def]
tools\SFK echo non-selfboot ISO instead CDI will be created.
echo.
tools\SFK echo Do you want to continue? 

pause
goto NON_SELFBOOT

:ERROR_DATALABEL
tools\SFK echo [red]ERROR:[red] [red]%datalabel%[def] is too long name for volume name
del /f /q data\*.tmpchk

SET VOLUMELABEL=dcgame
echo.
tools\SFK echo    Please [cyan]ENTER THE NAME[def] of your disk image
tools\SFK echo    Ex: Ikaruga, Shenmue2, etc. If empty, it will be called [green]%VOLUMELABEL%[def].
tools\SFK echo    Just press ENTER for use DEFAULT name

SET /P VOLUMELABEL=   
SET VOLUMELABEL="%VOLUMELABEL%"
echo.
tools\SFK replace -quiet tools\cfg\settings.ini "/%datalabel%/%VOLUMELABEL%/" -yes
goto :SETTINGS_SET

