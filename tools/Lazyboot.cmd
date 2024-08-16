@echo off&&cls

:: 20250511
set LAZYVERSION=v6.0

:BEGINNING

if exist binhack.exe cd ..
:: if exist binhack.exe echo Don^'t run this script here^!&exit
tools\SFK color white


:SETTINGS
setLocal EnabledelayedExpansion

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
if !c!==17 set "doomer=%%A"
if !c!==18 set "soundbank=%%A"
)

:: mkcdi.exe based on Python 3.12.3 and compiled via pyinstaller and do not works on WinXP so cdi4dc will be forced if WinXP will be detected. Should work on Win7 and Win10
for /f "tokens=2 delims=[]" %%i in ('ver') do set VERSION=%%i
for /f "tokens=2-3 delims=. " %%i in ("%VERSION%") do set VERSION=%%i.%%j

if "%VERSION%" == "5.00" set tool=cdi4dc
if "%VERSION%" == "5.0" set tool=cdi4dc
if "%VERSION%" == "5.1" set tool=cdi4dc


:: CHECKING FILES
set step=1
set session1=AUDIO
set goingto=SBTYPE_DEF
set errorresult= The following file(s) needed to run the script not found: 

set TITLE=TITLE Lazyboot %lazyversion%
if not exist .\data md data
if not exist .\audio md audio
if not exist .\roms md roms
if not exist .\tools set errorresult=%errorresult%.\tools\; &set goingto=ERROR
if not exist tools\audio.raw set errorresult=%errorresult%tools\audio.raw; &set goingto=ERROR
if not exist tools\bincon.exe set errorresult=%errorresult%tools\bincon.exe; &set goingto=ERROR
if not exist tools\binhack.exe set errorresult=%errorresult%tools\binhack.exe; &set goingto=ERROR
if not exist tools\cygiconv-2.dll set errorresult=%errorresult%tools\cygiconv-2.dll; &set goingto=ERROR
if not exist tools\cygintl-3.dll set errorresult=%errorresult%tools\cygintl-3.dll; &set goingto=ERROR
if not exist tools\cygwin1.dll set errorresult=%errorresult%tools\cygwin1.dll; &set goingto=ERROR
if not exist tools\hack4.exe set errorresult=%errorresult%tools\hack4.exe; &set goingto=ERROR
if not exist tools\lbacalc.exe set errorresult=%errorresult%tools\lbacalc.exe; &set goingto=ERROR

if %automatic%==automatic_on call tools\automatic.bat

if not exist tools\logoinsert.exe set errorresult=%errorresult%tools\logoinsert.exe; &set goingto=ERROR
if not exist tools\mkisofs.exe set errorresult=%errorresult%tools\mkisofs.exe; &set goingto=ERROR
if not exist tools\setvar set errorresult=%errorresult%tools\setvar; &set goingto=ERROR
::if exist tools\timer.cfg del tools\timer.cfg>nul


if %goingto%==ERROR goto ERROR

:: checking ROMs in ROMS folder
dir "roms" /a-d >nul 2>nul && (
    goto EMU_FOUND
) || (
    ECHO This directory is empty >NUL
)
:: end




:PRINT_TITLE

cls
%TITLE%

if %logo%==logo_off goto LOGO_OFF




:: LOGO IS ON
tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT[def] [yellow]%lazyversion%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]+++++++++++++++++++++++++++[def]   [yellow]WARNING: LOGO IS ON[def]   [cyan]+++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]_______________________________________________________________________________[def]
:: echo.
:: tools\SFK echo STEP %STEP%
echo.
goto %goingto% 
:: END


:: LOGO IS OFF
:LOGO_OFF
tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT[def] [yellow]%lazyversion%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]++++++++++++++++++++++++++[def]   [green]WARNING: LOGO IS OFF[def]  [cyan]+++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]_______________________________________________________________________________[def]
:: echo.
:: tools\SFK echo STEP %STEP%
echo.
goto %goingto% 
:: END


:ERROR

set goingto=END
:: cls
echo.&tools\SFK echo [red]ERROR: something is missing or error occured![def]
tools\SFK echo incorrect [green]sortfile.str[def] file format, maybe? Please, investigate.
echo.
tools\busybox.exe ls
echo.
tools\SFK echo [cyan]sortfile.str example:[def]
echo.
tools\busybox.exe cat ./tools/sortfile.str_example.txt
echo.
pause
cls
%TITLE% ERROR^!
echo.
tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT[def] [yellow]%lazyversion%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]_______________________________________________________________________________[def]
echo.


tools\SFK echo [red]ERROR^![def] 
echo.

echo   Some errors occurred while processing ...
echo.
echo   %errorresult%
echo.
echo   Creating of SelfBoot image cancelled. Closing script..
echo.

goto %goingto%

:SBTYPE_DEF

:: play the sound in menu
if "%soundbank%"=="twisted" call :SOUND_IN_MENU


set goingto=SBTYPE_DEF
set sb_type=cdi

tools\SFK echo    [cyan]What type of selfboot image you need?[def]
echo.

:: MAIN MENU
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
tools\SFK echo [cyan]1 - CDI[def] (DiscJuggler image, 2Gb max)
tools\SFK echo [red]2 - MDS/MDF[def] (with CDDA audio)
tools\SFK echo [magenta]3 - GDI[def] (Gigabyte Disc image, 1.1Gb max)
tools\SFK echo [cyan]4 - CDI[def] (in [red]data[def]^/[cyan]data[def] mode, 2Gb max)
tools\SFK echo [Green]5 - SDISO[def] (for Dreamshell)
::tools\SFK echo [magenta]6 - EMULS^/VIDEO[def] (CDI, audio/data)
tools\SFK echo [yellow]7 - OPTIONS[def]
tools\SFK echo 9 - Exit (to Windows)
:: *************

echo.
tools\SFK echo    If you do not know what to choose press enter
tools\SFK echo    [cyan]Please enter the number:[def]
set input_type=1
set /P input_type=   

:user_input
if %input_type%==1 set sb_type=cdi
if %input_type%==2 set sb_type=mds_cdda&set doomer=dummy_off
if %input_type%==4 set sb_type=sdiso&set session1=DATA
if %input_type%==5 set sb_type=sdiso&set doomer=dummy_off
if %input_type%==6 set sb_type=emu
if %tool%==mkcdi set sb_type=cdi&set doomer=dummy_off
if %input_type%==3 set sb_type=gdi&set doomer=dummy_off
if %input_type%==7 set sb_type=options
if %input_type%==8 set sb_type=mds
if %input_type%==9 set sb_type=exit

if %input_type%==cdi set sb_type=cdi
if %input_type%==mds set sb_type=mds
if %input_type%==mdf set sb_type=mds
if %input_type%==gdi set sb_type=gdi
if %input_type%==mds_cdda set sb_type=mds_cdda
if %input_type%==sdiso set sb_type=sdiso
if %input_type%==dummy set sb_type=cdi&set doomer=dummy_on
if %input_type%==emu set sb_type=emu
if %input_type%==video set sb_type=emu
if %input_type%==options set sb_type=options
if %input_type%==exit set sb_type=exit

::echo User input was ^"%input_type%^" and ^"%sb_type%^" mode will be used.

if %sb_type%==mds_cdda (
    dir ".\audio\*.*" /b /a-d 2>nul | findstr /r /c:"." >nul || (
		echo the user tried to use cdda with no audio, that's makes no sense ^(using CDI instead^)>>.\log.txt
        set input_type=1 & goto user_input
    )
)

if %sb_type%==mds_cdda (
    if not exist .\tools\LazyAudio\audio2wav.bat echo Prepearing files..&&.\tools\7z.exe x -o.\tools\LazyAudio\ .\tools\LazyAudio\LazyAudio.tar -aoa>NUL
    )
	
:: echo User input changed to ^"%input_type%^" and ^"%sb_type%^" mode will be used.

if %sb_type%==emu cls&echo.&tools\SFK echo Put your ROMs^/VIDEO in [cyan]ROMS[def] folder&tools\SFK echo new options will be available if files are found&tools\SFK echo [green]BIN[def];[green]ZIP[def];[green]GEN[def];[green]SMC[def],etc. [green]MP4[def];[green]AVI[def];[green]MKV[def] supported&echo.&pause&goto BEGINNING
if %sb_type%==cdi set goingto=labeling&set sb_tool=%tool%
if %sb_type%==gdi set goingto=GDI_labeling
if %sb_type%==mds set goingto=labeling&set sb_tool=MDS4DC
if %sb_type%==mds_cdda set goingto=labeling&set sb_tool=MDS4DC
if %sb_type%==options call tools\options.bat
if %sb_type%==exit exit
if %sb_type%==quit exit
if %sb_type%==sdiso set dcsystem=dreamshell&set goingto=labeling&set sb_tool=%tool%

:: session1=data set goingto=labeling set sb_type=cdi&set sb_tool=%tool%
:: MAIN MENU END



:: BONUS FEATURES

:: Set binhack based on input_type
if "%input_type%"=="kos" (
    tools\sfk replace -quiet tools\cfg\settings.ini /default/kos/ /wince/kos/ /katana/kos/ /binhack_on/binhack_off/ -yes
    set binhack=binhack_off
    goto BEGINNING
)

if "%input_type%"=="wince" (
    tools\sfk replace -quiet tools\cfg\settings.ini /default/wince/ /kos/wince/ /katana/wince/ /binhack_off/binhack_on/ -yes
    set binhack=binhack_on
    goto BEGINNING
)

if "%input_type%"=="katana" (
    tools\sfk replace -quiet tools\cfg\settings.ini /default/katana/ /wince/katana/ /kos/katana/ /binhack_off/binhack_on/ -yes
    set binhack=binhack_on
    goto BEGINNING
)

:: Handle default settings
if "%input_type%"=="default" (
    copy /Y tools\settings.def tools\cfg\settings.ini >nul
    copy /Y tools\logos\not_sega.mr tools\logo.mr >nul
    goto SETTINGS
)

:: Toggle logo settings
if "%input_type%"=="nologo" (
    tools\SFK replace -quiet tools\cfg\settings.ini "/logo_on/logo_off/" -yes
    del /f /q tools\logo.mr
    goto SETTINGS
)

if "%input_type%"=="logo" (
    tools\SFK replace -quiet tools\cfg\settings.ini "/logo_off/logo_on/" -yes
    copy /Y tools\logos\not_sega.mr tools\logo.mr >nul
    goto SETTINGS
)

:: Toggle binhack settings
if "%input_type%"=="nobinhack" (
    tools\SFK replace -quiet tools\cfg\settings.ini "/binhack_on/binhack_off/" -yes
    goto SETTINGS
)

if "%input_type%"=="binhack" (
    tools\SFK replace -quiet tools\cfg\settings.ini "/binhack_off/binhack_on/" -yes
    goto SETTINGS
)

:: Simplify input_type conditions
if "%input_type%"=="slower" set input_type=mastering
if "%input_type%"=="slow" set input_type=mastering
if "%input_type%"=="mastering" (
    tools\sfk replace -quiet tools\cfg\settings.ini /default/katana/ /wince/katana/ /kos/katana/ /binhack_off/binhack_on/ /mkcdi/cdi4dc/ /dummy_off/dummy_on/ -yes
    set binhack=binhack_off
    goto SETTINGS
)

if "%input_type%"=="faster" set input_type=fast
if "%input_type%"=="fast" (
    tools\sfk replace -quiet tools\cfg\settings.ini /default/katana/ /wince/katana/ /kos/katana/ /binhack_off/binhack_on/ /cdi4dc/mkcdi/ /dummy_on/dummy_off/ -yes
    set binhack=binhack_off
    goto SETTINGS
)

:: END



if %goingto%==labeling set STEP=2

echo.
if %dcsystem%==dreamshell if not %session1%==DATA tools\SFK echo    Begin to create [cyan]SDISO[def] image. &echo.
if %goingto%==labeling if not %session1%==DATA tools\SFK -spat echo    Image in [green]%session1%[def]^/[cyan]DATA[def] mode - going to  STEP %STEP%...&echo.&pause
if %goingto%==labeling if %session1%==DATA tools\SFK -spat echo    Image in [red]%session1%[def]^/[cyan]DATA[def] mode - going to  STEP %STEP%...&echo.&pause
if %goingto%==GDIBuilder echo    Begin to create GDI. going to  STEP %STEP%..&echo.&pause


goto PRINT_TITLE


:: GDI_labeling
:GDI_labeling

if not exist gdi_image md gdi_image>NUL
if not exist gdi_image\track01.bin goto GDI_ERROR01
if not exist gdi_image\track02.raw goto GDI_ERROR02
if not exist gdi_image\*.gdi goto GDI_ERROR03

goto GDIBuilder

:GDI_ERROR01
tools\SFK echo [red]WARNING:[def]  [cyan]track01.bin[def] not found in gdi_image directory.
echo Use original one, if possible.
tools\busybox.exe sleep 2
tools\busybox.exe cp ./tools/BuildGDI/default/track01.bin ./gdi_image
echo.
goto GDI_labeling
exit

:GDI_ERROR02
tools\SFK echo [red]WARNING:[def]  [cyan]track02.raw[def] not found in gdi_image directory.
echo Use original one, if possible.
tools\busybox.exe sleep 2
tools\busybox.exe cp ./tools/BuildGDI/default/track02.raw ./gdi_image
echo.
goto GDI_labeling
exit

:GDI_ERROR03
tools\SFK echo [red]WARNING:[def]   [cyan]*.gdi[def] not found in gdi_image directory. 
echo Use original one, if possible.
tools\busybox.exe sleep 2
tools\busybox.exe cp ./tools/BuildGDI/default/disc.gdi ./gdi_image
echo.
goto GDI_labeling
exit

:GDI_ERROR04
tools\SFK echo [red]ERROR:[def] [cyan]IP.BIN[def] not found in DATA directory. 
echo The image will not boot
pause
goto GDIBuilder

:: end
:: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++





:: GDIBuilder Start
:: ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:GDIBuilder
cls

tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT[def] [yellow]%lazyversion%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]+++++++++++++++++++++[def]   [yellow]GDI Builder: use at you own risk[def]   [cyan]++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]_______________________________________________________________________________[def]
echo.

tools\SFK echo [red]WARNING:[def] [cyan]If you want to change IP.BIN (Region, Name, etc).. Do it NOW![def]
echo This is the ultimate chance to do it before generating the data track.
echo.
pause


:: compatibility
set BINARY=1ST_READ.BIN
if exist data\0WINCEOS.BIN set BINARY=0WINCEOS.BIN
set BOOTSECTOR=IP.BIN

if not exist data\%BINARY% tools\SFK echo [red]WARNING:[def] Binary [yellow]"%BINARY%"[def] not found. Make sure main binary files are in the Data folder!!&echo.&pause&echo.
:: Half-Life
if exist data\HALFLIFE_DC.EXE tools\busybox.exe cp .\tools\database\9F22\0WINCEOS.BIN data\0WINCEOS.BIN&&if exist data\1ST_READ.BIN tools\busybox.exe rm ./data/1ST_READ.BIN&&if not exist data\IP.BIN tools\busybox.exe cp .\tools\database\9F22\9F22-hl1-JUE.BIN data\IP.BIN>NUL
if exist data\HALFLIFE_DC.EXE if not exist data\0GDTEX.PVR tools\busybox.exe cp ./tools/database/9F22/0GDTEX.PVR ./data/0GDTEX.PVR>NUL

if not exist data\%BOOTSECTOR% set BOOTSECTOR=IP.BIN&if %BINARY%==0WINCEOS.BIN copy tools\boots2 data\IP.BIN >NUL
if not exist data\%BOOTSECTOR% set BOOTSECTOR=IP.BIN&copy tools\boots1 data\IP.BIN >NUL
:: --------------------------


if %logo%==logo_on tools\logoinsert tools\logo.mr data\IP.BIN > tools\NUL


set volumelabel=%datalabel%
if not exist .\tools\cfg\volumelabel.cfg echo DREAMISO>.\tools\cfg\volumelabel.cfg
if %volumelabel%==DREAMISO set /p volumelabel=<.\tools\cfg\volumelabel.cfg

cls
tools\SFK echo [cyan]++++++++++++++++++++++++++++++[def]   [red]LAZYBOOT[def] [yellow]%lazyversion%[def]   [cyan]++++++++++++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]+++++++++++++++++++++[def]   [yellow]GDI Builder: use at you own risk[def]   [cyan]++++++++++++++++++++++++[def] 
tools\SFK echo [cyan]_______________________________________________________________________________[def]
echo.

tools\SFK echo    Please enter the name of your disk image.
tools\SFK echo    Ex: [yellow]Shenmue2[def] ^([yellow]8 letters is recommended[def]^). 
tools\SFK echo    [cyan]PRESS ENTER[def] to use previous name ^([magenta]%volumelabel%[def]^).

set /P volumelabel=   
echo.
echo Please wait.
set volumelabel="%volumelabel%"



:: checking if ISO 9660 data label name is standart

if %isonamechk%==isonamechk_off goto SKIP_NAMECHK_GDI
set chkname=%volumelabel%
set allowed=34
echo %chkname%>"data\%~n0.tmpchk" 
for %%i in ("data\%~n0.tmpchk") do set /A z=%%~zi-2 
del /f /q data\*.tmpchk
if %z% GTR %allowed% set volumelabel=DREAMCAST-GAME
:SKIP_NAMECHK_GDI
:: end of this checking

echo %volumelabel%> .\tools\cfg\volumelabel.cfg
tools\SFK.exe replace -binary /20/2D/ /22// /2A/2D/ /3F/2D/ /2F/2D/ /5C/2D/ /5B/2D/ /5D/2D/ /3A/2D/ /3B/2D/ /7C/2D/ /2C/2D/ /25/2D/ /26/2D/ /24/2D/ /40/2D/ -dir .\tools\cfg\ -file volumelabel.cfg -yes -quiet
set /p volumelabel=<.\tools\cfg\volumelabel.cfg
:: end of section


tools\BuildGDI\buildgdi.exe -data data -ip data\IP.BIN -output gdi_image -v "%volumelabel%" -raw -gdi .\gdi_image\disc.gdi

echo.
tools\SFK echo [cyan]Done. Check your GDI in gdi_image folder.[def]
if %alert%==alert_off goto SKIP_ALERT
call :SOUND
pause
exit
:: GDIBuilder END




:labeling

set goingto=LBA_CALC
set volumelabel=%datalabel%
if not exist .\tools\cfg\volumelabel.cfg echo DREAMISO>.\tools\cfg\volumelabel.cfg
if %volumelabel%==DREAMISO set /p volumelabel=<.\tools\cfg\volumelabel.cfg


tools\SFK echo    Please enter the name of your disk image.
tools\SFK echo    Ex: [yellow]Shenmue2[def] ^([yellow]8 letters is recommended[def]^).
tools\SFK echo    [cyan]PRESS ENTER[def] to use previous name ^([magenta]%volumelabel%[def]^).
echo.
:labeling_NOecho

set /p volumelabel=   
set volumelabel="%volumelabel%"
echo.

set chkname=%volumelabel%

:: checking if ISO 9660 data label name is standart

:: skip if OFF in config
if %isonamechk%==isonamechk_off goto SKIP_NAMECHK
:: end

set allowed=34
echo %chkname%>"data\%~n0.tmpchk" 
for %%i in ("data\%~n0.tmpchk") do set /A z=%%~zi-2 
del /f /q data\*.tmpchk
if %z% GTR %allowed% goto ERROR_DATALABEL
:SKIP_NAMECHK
:: end of this checking

echo %volumelabel%> .\tools\cfg\volumelabel.cfg
tools\SFK.exe replace -binary /20/2D/ /22// /2A/2D/ /3F/2D/ /2F/2D/ /5C/2D/ /5B/2D/ /5D/2D/ /3A/2D/ /3B/2D/ /7C/2D/ /2C/2D/ /25/2D/ /26/2D/ /24/2D/ /40/2D/ -dir .\tools\cfg\ -file volumelabel.cfg -yes -quiet
set /p volumelabel=<.\tools\cfg\volumelabel.cfg

echo.
set STEP=3
echo    OK, going to STEP %STEP%..
echo.
pause

if %sb_type%==mds_cdda set goingto=CDDA_INFO&goto PRINT_TITLE

goto %goingto%

:ERROR_DATALABEL
tools\SFK echo [red]ERROR:[red] [red]%volumelabel%[def] is too long
tools\SFK echo ^(disable this warning in [yellow]settings.ini[def] if needed^)
echo.
pause
echo.
tools\SFK echo    Please [cyan]ENTER THE NAME[def] again
echo.
goto labeling_NOecho





:CDDA_INFO

set goingto=CDDA_INFO
set CDDA_CONF=null

tools\SFK echo [cyan]Verification of audio files..[def]
echo.

if exist audio\*.adx goto MEDIA_FOUND 
if exist audio\*.mp3 goto MEDIA_FOUND
if exist audio\*.xm goto MEDIA_FOUND
if exist audio\*.mod goto MEDIA_FOUND
if exist audio\*.it goto MEDIA_FOUND
if exist audio\*.flac goto MEDIA_FOUND
if exist audio\*.ogg goto MEDIA_FOUND
if exist audio\*.aac goto MEDIA_FOUND
if exist audio\*.wma goto MEDIA_FOUND
if exist audio\*.avi goto MEDIA_FOUND
if exist audio\*.flv goto MEDIA_FOUND
if exist audio\*.mpg goto MEDIA_FOUND
if exist audio\*.mp4 goto MEDIA_FOUND
if exist audio\*.s3m goto MEDIA_FOUND
if exist audio\*.wma goto MEDIA_FOUND
if exist audio\*.spc goto MEDIA_FOUND
if exist audio\*.vgm goto MEDIA_FOUND
if exist audio\*.vgz goto MEDIA_FOUND
if exist audio\*.wav goto MEDIA_FOUND
goto SKIP03


:MEDIA_FOUND
tools\SFK echo Media files found in [cyan]AUDIO[def] folder. They will be converted to compatible format.
pause


:LazyAudio
for %%I in (audio\*.*) do move  "%%I" "tools\LazyAudio\audio" 
move tools\LazyAudio\audio\*.raw audio\ >NUL
move tools\LazyAudio\audio\*.snd audio\ >NUL

cd tools\LazyAudio
call audio2raw.bat
cd..
cd..
for %%I in (.\tools\LazyAudio\audio\*.*) do move "%%I" "audio\" 
cls
set goingto=SKIP07
goto PRINT_TITLE



:: dcemu-pack-20171109
:EMU_FOUND

if not exist .\tools\dcemu-pack-20171109\EmuGen\EmuGen.cmd echo Prepearing files..&&.\tools\7z.exe x -o.\tools\dcemu-pack-20171109\ .\tools\dcemu-pack-20171109\dcemu-pack-20171109.tar -aoa>NUL&&cls
	
set emulname=unknown

if exist "tools\dcemu-pack-20171109\DreamSNES\ROMS\*" del /q "tools\dcemu-pack-20171109\DreamSNES\ROMS\*" >NUL
if exist "tools\dcemu-pack-20171109\EmuGen\ROMS\*" del /q "tools\dcemu-pack-20171109\EmuGen\ROMS\*" >NUL
if exist "tools\dcemu-pack-20171109\GenPlusDC\ROMS\*" del /q "tools\dcemu-pack-20171109\GenPlusDC\ROMS\*" >NUL
if exist "tools\dcemu-pack-20171109\NesterDC\ROMS\*" del /q "tools\dcemu-pack-20171109\NesterDC\ROMS\*" >NUL
if exist "tools\dcemu-pack-20171109\SegaGen\ROMS\*" del /q "tools\dcemu-pack-20171109\SegaGen\ROMS\*" >NUL
if exist "tools\dcemu-pack-20171109\SNES4ALL\ROMS\*" del /q "tools\dcemu-pack-20171109\SNES4ALL\ROMS\*" >NUL
if exist "tools\dcemu-pack-20171109\GypPlay\MOVIES\*" del /q "tools\dcemu-pack-20171109\GypPlay\MOVIES\*" >NUL

if exist roms\*.smc set emulname=DreamSNES&set emutype=smc
if exist roms\*.sfc set emulname=DreamSNES&set emutype=sfc
if exist roms\*.fig set emulname=DreamSNES&set emutype=fig
if exist roms\*.gen set emulname=EmuGen&set emutype=gen
if exist roms\*.nes set emulname=NesterDC&set emutype=nes
if exist roms\*.avi set emulname=GypPlay&set emutype=avi
if exist roms\*.mkv set emulname=GypPlay&set emutype=mkv
if exist roms\*.mp4 set emulname=GypPlay&set emutype=mp4
if exist roms\*.bin set emulname=SegaGen&set emutype=bin
if exist roms\*.zip set emulname=DreamSNES&set emutype=zip

if not %emulname%==GypPlay tools\SFK echo [Green]%emulname%[def]^([Green].%emutype%[def]^) ROMs detected
if %emulname%==GypPlay tools\SFK echo [Green]%emulname%[def]^([Green].%emutype%[def]^) media detected&set manname=empty&pause&goto EMUL_manname
tools\SFK sleep 500
echo.
tools\SFK echo CDI will be created with predefined emulator
tools\SFK echo [cyan]What emulator you want to use?[def]
echo.

:: EMUMENU
tools\SFK echo [cyan]1 - DreamSNES[def] ^(SMC, SFC, FIG^)
tools\SFK echo [red]2 - EmuGen[def] ^(BIN, GEN^)
tools\SFK echo [magenta]3 - GenPlusDC[def] ^(ZIP. In ZIP can be BIN, GEN^)
tools\SFK echo [red]4 - NesterDC[def] ^(NES, not zipped^)
tools\SFK echo [Green]5 - SegaGen[def] ^(BIN, GENs^)
tools\SFK echo [cyan]6 - SNES4ALL[def] ^(ZIP, SMC^)
tools\SFK echo 7 - Exit (to Windows)

echo.
tools\SFK echo [cyan]Please enter the number:[def]
set manname=empty
set /P manname=

:EMUL_manname
if %manname%==1 set emulname=DreamSNES
if %manname%==2 set emulname=EmuGen
if %manname%==3 set emulname=GenPlusDC
if %manname%==4 set emulname=NesterDC
if %manname%==5 set emulname=SegaGen
if %manname%==6 set emulname=SNES4ALL
if %manname%==7 EXIT
if %emulname%==GypPlay set manname=8
:: END EMUMENU


:: INPUT CHECKER
if %manname%==empty echo.&tools\SFK echo [red]Input valid number[def]&pause&cls&goto EMU_FOUND
SET "var="&for /f "delims=0123456789" %%i in ("%manname%") do set var=%%i
if defined var (set numeric=no) else (set numeric=yes)
if %numeric%==no cls&goto EMU_FOUND
:: END


echo.
:EMUL_IMG
:: tools\timemer stopwatch start >NUL
tools\timer.exe start

if %emulname%==GypPlay tools\sfk list -nosub -relnames roms .avi .mkv .mp4 .flv .\tools\dcemu-pack-20171109\%emulname%\roms\ +copy .\tools\dcemu-pack-20171109\%emulname%\ -yes
echo.
if not %emulname%==GypPlay tools\sfk list -nosub -relnames roms .gen .bin .\tools\dcemu-pack-20171109\%emulname%\ROMS\ +copy .\tools\dcemu-pack-20171109\%emulname%\ -yes>NUL

echo.
cd "tools\dcemu-pack-20171109\%emulname%\"
call %emulname%
cd.. &cd.. &cd..
for %%I in ("tools\dcemu-pack-20171109\%emulname%\*.cdi") do move "%%I" ".\">NUL&del /f /q "tools\dcemu-pack-20171109\%emulname%\roms\*"&RMDIR /s/q "tools\dcemu-pack-20171109\%emulname%\data\"&exit
cls
set goingto=SKIP07
goto SB_DONE
:: END


:SKIP07
set goingto=CDDA_INFO
goto SKIP04

:SKIP03

tools\SFK echo Files must be in the [cyan]AUDIO[def] folder and in RAW format.
tools\SFK echo MP3, OGG, MP4 and WAV are supported too.
echo.
tools\SFK echo [cyan]List of files to be used as audiotracks[def]^:
goto SKIP05


:SKIP04
cd audio
if exist *.snd ren *.snd *.raw
cd ..

tools\SFK echo [cyan]List of files to be used as audiotracks^:[def]
echo.
DIR /B audio\*.raw
echo.
tools\SFK echo Use all files in the [cyan]AUDIO[def] folder as audiotracks?
tools\SFK echo Enter [cyan]Y[def] if YES and [cyan]N[def] if NO.
tools\SFK echo If you select NO, you will need to input file names order
echo.
goto SKIP06

:SKIP05

cd audio
if exist *.snd ren *.snd *.raw
cd ..

echo.
DIR /B audio\*.raw
echo.
tools\SFK echo Use all files in the [cyan]AUDIO[def] folder as audiotracks?
tools\SFK echo Enter [cyan]Y[def] if YES and [cyan]N[def] if NO.
tools\SFK echo If you select NO, you will need to input file names order
echo.


:SKIP06
set CDDA_CONF=YES
set /P CDDA_CONF=   

if /I %CDDA_CONF%==Y set CDDA=audio\*.raw&goto CDDA_END
if /I %CDDA_CONF%==YES set CDDA=audio\*.raw&goto CDDA_END
if /I %CDDA_CONF%==N goto NEWCDDA_DEF
if /I %CDDA_CONF%==NO goto NEWCDDA_DEF

goto PRINT_TITLE

:NEWCDDA_DEF

set goingto=CDDA_END
set CDDA=null

echo.
echo Input file names that should be used as audiotracks.
echo.
tools\SFK echo EX.: For [cyan]track01.raw[def] and [cyan]track02.raw[def] enter:
echo.
tools\SFK echo [cyan]audio\track01.raw audio\track02.raw[def] ^(Note that the tracks are written in the same order in the disk image^)
echo.
tools\SFK echo [red]WARNING[def]: use only short names without space^!
echo Enter file names to be used as audiotracks for CDDA:
echo.
set /P CDDA=   

goto %goingto%

:CDDA_END

set goingto=LBA_CALC

if not exist audio\*.raw set CDDA=tools\audio.raw
if %CDDA%==null set CDDA=tools\audio.raw

echo.
set STEP=4
echo    OK, going to STEP %STEP%..
echo.

pause

goto %goingto%




:LBA_CALC

cls
set goingto=BINHACK_set
:: set LBA=%lbavalue%
if %sb_type%==cdi set LBA=11702&goto BINHACK_set
if %sb_type%==mds set LBA=11702&goto BINHACK_set
if %sb_type%==sdiso set LBA=0&GOTO BINHACK_SET


copy tools\setvar tools\setvar2.bat >NUL

tools\lbacalc %CDDA% >> tools\setvar2.bat

call tools\setvar2.bat
del tools\setvar2.bat

goto %goingto%


:BINHACK_SET

set goingto=BINHACK_DEF
set BINARY=1ST_READ.BIN
set BOOTSECTOR=IP.BIN


:: Record of Lodoss War main binary
if exist data\1NOSDC.BIN set BINARY=1NOSDC.BIN
:: WindowsCE main binary
if exist data\0WINCEOS.BIN set BINARY=0WINCEOS.BIN




:: compatibility database

:: Record of Lodoss War
if exist data\1NOSDC.BIN if not exist data\IP.BIN tools\busybox.exe cp .\tools\database\5167\5167-lodoss-EUJ.bin data\IP.BIN >NUL

:: Half-Life
if exist data\HALFLIFE_DC.EXE if exist data\0WINCEOS.BIN if not exist data\IP.BIN tools\busybox.exe cp .\tools\database\9F22\9F22-hl1-JUE.BIN data\IP.BIN >NUL

:: if not original release of Half-Life is detected (1ST_READ.BIN) it force you to use vanilla IP.BIN (from GDI) and rename the main binary to 0WINCEOS
if exist data\HALFLIFE_DC.EXE if not exist data\1ST_READ.BIN if not exist .\data\0WINCEOS.BIN tools\busybox.exe cp ./tools/database/9F22/0WINCEOS.BIN ./data/0WINCEOS.BIN&&set BINARY=0WINCEOS.BIN>NUL
if exist data\HALFLIFE_DC.EXE if exist data\1ST_READ.BIN tools\busybox.exe mv ./data/1ST_READ.BIN ./data/0WINCEOS.BIN&& tools\busybox.exe cp ./tools/database/9F22/9F22-hl1-JUE.BIN ./data/IP.BIN&&set BINARY=0WINCEOS.BIN>NUL 
if exist data\HALFLIFE_DC.EXE if not exist data\0GDTEX.PVR tools\busybox.exe cp ./tools/database/9F22/0GDTEX.PVR ./data/0GDTEX.PVR

:: Generic WinCE
if not exist data\IP.BIN if %BINARY%==0WINCEOS.BIN copy tools\boots2 data\IP.BIN>NUL

:: Katana
if not exist data\IP.BIN copy tools\boots1 data\IP.BIN>NUL
:: end of section
goto PRINT_TITLE





:BINHACK_DEF
if exist data/SONIC2 goto SONIC2
:ANTISONIC
set goingto=BINHACK_DEF
set BINHACK_CONF=null

tools\SFK echo [cyan]HACK4 and BINHACK[def]:
tools\SFK echo Modify %BINARY% and %BOOTSECTOR% for SelfBoot
echo.

::  ELF KISS
set cnt=0
for %%I in (data\*.elf) do set /A cnt += 1
if %namelist%==namelist_on for %%a in (data\*.elf) do echo %%~na >> data\namelist.txt
if %cnt%==1 goto ELF_KOS

if %sb_type%==mds_cdda goto SKIP_2BINHACK

if %inducer%==inducer_off goto SKIP_INDUCER
if exist data\*.sbi goto MULTIMENU_SBI
:SKIP_INDUCER
if %binhack%==binhack_off goto HOMEBREW
:SKIP_2BINHACK
::  END ELF KISS


if not exist data\%BINARY% tools\SFK echo [red]WARNING:[def] Binary [yellow]"%BINARY%"[def] not found. Make sure main binary files are "in the data folder."&echo.&pause&echo.


tools\SFK echo Binary files [yellow]%BINARY%[def] and [yellow]%BOOTSECTOR%[def] are modified to the following values:
echo.
tools\SFK echo Binary = [cyan]%BINARY%[def]
tools\SFK echo Bootsector = [magenta]%BOOTSECTOR%[def]
tools\SFK echo LBA ^(MSINFO^) = [red]%LBA%[def]
echo.

echo Some info:
echo "Binary" and "Bootsector" set to standard values.
if %sb_type%==mds_cdda echo Bootsector data allocated. A value calculated from the size of & echo total audio files in RAW format  in  \audio folder reported in STEP 3
if %sb_type%==cdi echo Bootsector data allocated. Continue without CDDA.
if %sb_type%==mds echo Bootsector data allocated. Continue without CDDA.

echo.
tools\SFK echo [cyan]If you don't know what it does, press[def] [red]ENTER[def]
echo Everything will work fine in 90^%% of cases.
echo.
echo Do you want to use these values to "Binary", "Bootsector" and "LBA"?
tools\SFK echo -spat Enter \q"[cyan]Y[def]\q" (yes), \q"[cyan]N[def]\q" (no) or [cyan]LBA VALUE[def] (any number):
echo.
set BINHACK_CONF=YES
set /P BINHACK_CONF=   

if /I %BINHACK_CONF%==N set goingto=NEWBINHACK_DEF
if /I %BINHACK_CONF%==NO set goingto=NEWBINHACK_DEF
if /I %BINHACK_CONF%==Y goto BINHACK_DO
if /I %BINHACK_CONF%==YES goto BINHACK_DO

:: VOD CHECKER
SET "var="&for /f "delims=0123456789" %%i in ("%BINHACK_CONF%") do set var=%%i
if defined var (set numeric=no) else (set numeric=yes)

if %numeric%==yes tools\sfk.exe echo -spat You enter the [cyan]number[def] and it set as LBA [yellow]%BINHACK_CONF%[def] value&set LBA=%BINHACK_CONF% &goto BINHACK_DO
:: END


goto PRINT_TITLE


:HOMEBREW
if exist data\unscrambled.bin goto KALLISTI
tools\SFK echo But this is [red]DISABLED[def] in options or [cyan]elf binary[def] found
echo image will be created with default values...
echo.
tools\SFK echo This is [green]KallistiOS[def] (homebrew) game?
tools\SFK echo -spat Enter \q[cyan]Y[def]\q if YES and \q[cyan]N[def]\q if NO:
echo.
set HOMEBREW_CONF=YES
set /P HOMEBREW_CONF=   

if /I %HOMEBREW_CONF%==N goto KATANA
if /I %HOMEBREW_CONF%==NO goto KATANA
if /I %HOMEBREW_CONF%==Y goto KALLISTI
if /I %HOMEBREW_CONF%==YES goto KALLISTI

:KATANA
if not exist data\%BINARY% tools\SFK echo   [red]WARNING:[def] Binary [yellow]"%BINARY%"[def] not found. Make sure main binary files are in the Data folder!!&echo.&pause&echo.
if not exist data\%BOOTSECTOR% set BOOTSECTOR=IP.BIN&if %BINARY%==0WINCEOS.BIN copy tools\boots2 data\IP.BIN >NUL
if not exist data\%BOOTSECTOR% set BOOTSECTOR=IP.BIN&copy tools\boots1 data\IP.BIN >NUL
goto SB_CRIMAGE

:KALLISTI
if not exist data\IP.BIN COPY tools\boots3 data\IP.BIN >NUL
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL
if not exist data\unscrambled.bin set BINARY=1ST_READ.BIN&GOTO SB_CRIMAGE
if exist data\unscrambled.bin del /f /q data\1ST_READ.BIN
if exist data\unscrambled.bin tools\elf\scramble.exe data\unscrambled.bin data\1ST_READ.BIN
del /f /q data\unscrambled.bin
set BINARY=1ST_READ.BIN
goto SB_CRIMAGE


:ELF_KOS
tools\SFK echo But this is [cyan]disabled[def] because [cyan]elf[def] binary found
tools\SFK echo image will be created with default values...
echo.
ren data\*.elf main.elf
if not exist data\unscrambled.bin set scramble=disabled
if exist data\unscrambled.bin ren data\unscrambled_old.bin
tools\elf\sh-elf-objcopy.exe -O binary data/main.elf data/unscrambled.bin
tools\elf\scramble.exe data\unscrambled.bin data\1ST_READ.BIN
if exist data\unscrambled.bin del /f /q data\unscrambled.bin
if exist data\1ST_READ.BIN del /f /q data\main.elf
if exist data\unscrambled_old.bin ren data\unscrambled.bin
pause
:SKIP_SCRAMBLE
set BINARY=1ST_READ.BIN
if not exist data\IP.BIN copy tools\boots3 data\IP.BIN >NUL
if %logo%==logo_on tools\logoinsert.exe tools\logo.mr data\IP.BIN > tools\NUL


goto SB_CRIMAGE


:MULTIMENU_SBI
tools\unzip.exe -qq -o tools\database\inducer.zip -d data\
for %%I in (data\*.sbi) do tools\unzip.exe -qq -o "%%I" -d "data\temp"
xcopy /Y /R /S /E data\temp\Inducer\*.* data\*.* >nul
rmdir /s /q data\temp
del /f /q data\*.sbi
echo.
tools\SFK echo [red]SBI[def] [cyan]file format detected. Binhack disabled.[cyan]
tools\SFK echo [cyan]Edit files in data (add roms, music, etc) if needed[def]
tools\SFK echo [magenta]Are your ready to continue?[def]
echo.
pause
goto KALLISTI




:SONIC2
echo    Sonic Adventure 2 detected. Do you want to use prepatched files?
echo    Note: Logoinsert not supported.
echo    "Enter "Y", if YES and "N", if NO:
echo.
set SONIC2=YES
set /P SONIC2=   
if /I %SONIC2%==N goto ANTISONIC
if /I %SONIC2%==NO goto ANTISONIC
if /I %SONIC2%==Y goto SONICFILES
if /I %SONIC2%==YES goto SONICFILES


:SONICFILES
set volumelabel="SONIC2"
tools\unzip.exe -o tools\database\sa2.zip -d data\
goto SB_CRIMAGE





:NEWBINHACK_DEF

set goingto=NEWBINHACK_DEF
set NEWBINHACK_VALUE=11702


tools\sfk echo [cyan]HACK4 and BINHACK[def]:&echo.
tools\sfk echo Modify [cyan]%BINARY%[def] and [cyan]%BOOTSECTOR%[def] for SelfBoot
echo.
tools\sfk echo What you want to change before using the HACK4 and BINHACK?
echo. 
tools\sfk echo [cyan]Please enter the number[def]:
echo.
tools\sfk echo    [cyan]1[def] - Binary
tools\sfk echo    [cyan]2[def] - Bootsector
tools\sfk echo    [cyan]3[def] - LBA ^(MSINFO^)
tools\sfk echo    [cyan]4[def] - return to menu (CANCEL)
tools\sfk echo    [cyan]5[def] - just create CDI image from it (without changing any values)
echo.
set /P NEWBINHACK_VALUE=   
echo.

if %NEWBINHACK_VALUE%==4 set goingto=BINHACK_DEF&goto PRINT_TITLE
if %NEWBINHACK_VALUE%==5 set goingto=SB_CRIMAGE
if %NEWBINHACK_VALUE%==1 (
echo   Enter the new name of main binary file:
set /P BINARY=   
echo.

set goingto=BINHACK_DEF

echo    Return to the previous screen. Check the new values for Binary, Bootsector
echo    and LBA ^(MSINFO^) at the top of screen ...
echo.

pause

)

if %NEWBINHACK_VALUE%==2 (
echo    Enter the new name of main binary file:
set /P BOOTSECTOR=   
echo.

set goingto=BINHACK_DEF

echo    Return to the previous screen. Check the new values for Binary, Bootsector
echo    and LBA at the top of screen ...
echo.

pause

)

if %NEWBINHACK_VALUE%==3 (
echo   Enter the new value for LBA ^(MSINFO^):
set /P LBA=   
echo.

set goingto=BINHACK_DEF

echo    Return to the previous screen. Check the new values for Binary, Bootsector
echo    and LBA ^(MSINFO^) at the top of screen ...
echo.

pause
)

if not exist data\%BINARY% (
echo   File "%BINARY%" not found. Go back
echo.
pause
goto LBA_CALC
)

if not exist data\%BOOTSECTOR% (
echo    File "%BOOTSECTOR%" not found. Go back
echo.
pause
goto LBA_CALC
)

goto PRINT_TITLE




:: HACK4 &BINHACK
:BINHACK_DO

set goingto=CREATE_DUMMY

ATTRIB -R data\*.* >NUL

tools\hack4 -w -p data\*.bin >NUL
tools\hack4 -w -n %LBA% data\*.bin >NUL

copy data\%BINARY% >NUL
copy data\%BOOTSECTOR% >NUL

if %BINARY%==0WINCEOS.BIN tools\bincon 0WINCEOS.BIN 0WINCEOS.BIN %BOOTSECTOR% > NUL

echo %BINARY% > tools\BINHACK
echo %BOOTSECTOR% >> tools\BINHACK
echo %LBA% >> tools\BINHACK

tools\binhack < tools\BINHACK >NUL
if %logo%==logo_on tools\logoinsert tools\logo.mr %BOOTSECTOR% >NUL
if exist %BINARY% move %BINARY% data\ >NUL
if exist %BOOTSECTOR% move %BOOTSECTOR% data\ >NUL
echo.


set STEP=4
if %sb_type%==mds_cdda set STEP=5

tools\SFK echo [red]WARNING:[def] [cyan]If you want to change IP.BIN (Region, Name, etc).. Do it NOW![def]
echo.
echo This is the ultimate chance to do it before generating the track data.
if not %doomer%==dummy_on echo You can put dummy file in data, if needed.
echo.
echo    OK, going to STEP %STEP%...
echo.
pause

goto PRINT_TITLE


:CREATE_DUMMY

if %doomer%==dummy_on if %LBA% GTR 11702 set doomer=dummy_off&tools\sfk.exe echo [yellow]WARNING:[def] dummy is disabled for LBA [yellow]%LBA%[def](use 11702 instead)&echo.
if %doomer%==dummy_off goto SB_CRIMAGE
cd .\tools
sfk echo [cyan]DUMMY CREATOR[def]
sfk echo ^(dummy file will be hidden in file system^)
sfk sleep 1700;
echo.
du --bytes --summarize ..\data | cut -f1 >datasize.txt
set /p DATASIZE=<datasize.txt
sfk sleep 300;
set /a DATASIZE_MB="%DATASIZE%/1024000"
sfk echo [cyan]DATA SIZE[def] = [green]%DATASIZE_MB%[def] Mb
sfk sleep 500;

set DISC_SIZE=712841213
set /a MAXSIZE="%DISC_SIZE%-7340032"
set /a MAXSIZE_MB="%MAXSIZE%/1024000"

sfk echo [cyan]MAXSIZE[def] = [green]%MAXSIZE_MB%[def] Mb
sfk sleep 500;
echo.

set /a DUMMY_FILE="%MAXSIZE%-%DATASIZE%"
set /a DUMMY="%DUMMY_FILE%/1024000"

if /i %DATASIZE% GEQ %MAXSIZE% sfk echo [red]ERROR[def]^: [red]Too big size of all data[def]&set doomer=dummy_off


sfk sleep 300
if %doomer%==dummy_off sfk echo [cyan]DUMMY FILE[def] = [green]%DUMMY%[def] Mb ^(disabled^)
if %doomer%==dummy_on sfk echo OK, [cyan]DUMMY FILE[def] = [green]%DUMMY%[def] Mb

sfk sleep 500
echo.&echo.

if %doomer%==dummy_on Doomer.exe %DUMMY_FILE% "..\data\0.0">NUL
set doomer=dummy_off
cd..



:SB_CRIMAGE
if %doomer%==dummy_on call :CREATE_DUMMY
set goingto=SB_DONE
if exist %sortfile% set SORT=-sort %sortfile%
if exist data\0.0 set DUMMY=-hide 0.0 -hide-joliet 0.0
if exist data\Desktop.ini set EXC=-m Desktop.ini
if exist data\Thumbs.db set EXC=%EXC% -m Thumbs.db
if exist data\autorun.inf set HIDE=-hide autorun.inf

tools\sfk echo    [cyan]MKISOFS and %sb_tool%[def]:
tools\sfk echo    Generate ISO with game data..
tools\sfk echo    Completion of the SelfBoot creation.
echo.
tools\sfk echo    [cyan]MKISOFS[def]: Generating ISO [magenta]%volumelabel%[def] ...
echo.

:: tools\timemer stopwatch start >NUL
tools\timer.exe start

if %tool%==cdi4dc (
    if %LBA% GTR 11702 (
		set sb_type=sdiso&set session1=DATA&&set doomer==dummy_off
    )
)

if %sb_type%==sdiso tools\mkisofs -C 0,%LBA% -V %volumelabel% %SORT% %DUMMY% %EXC% %HIDE% -exclude IP.BIN -G data\%BOOTSECTOR% -l -J -r -o %volumelabel%.iso data

if not %sb_type%==sdiso tools\mkisofs -C 0,%LBA% -V %volumelabel% %SORT% %DUMMY% %EXC% %HIDE% -exclude IP.BIN -G data\%BOOTSECTOR% -l -J -r -o %volumelabel%.iso data
echo.

if not exist %volumelabel%.iso set errorresult=Error creating the data of the game. Process of SelfBoot creation cancelled.&goto ERROR

if %LBA% GTR 11702 tools\sfk.exe echo LBA value set as [yellow]%LBA%[def]&echo.

if %tool%==cdi4dc (
    if %LBA% GTR 11702 (
		tools\isofix.exe %volumelabel%.iso %volumelabel%_fixed.iso %LBA%
        tools\busybox.exe mv %volumelabel%_fixed.iso %volumelabel%.iso
        del /f /q "header.iso">NUL
        del /f /q "bootfile.bin">NUL
        echo.&tools\sfk.exe echo -spat Well, image is fixed for LBA [yellow]%LBA%[def]&tools\sfk.exe echo Now it can be usable for [red]%tool%[def].&echo Let's continue..&tools\busybox.exe sleep 2s&echo.
    )
)

if %session1%==DATA tools\%sb_tool% %volumelabel%.iso %volumelabel%.cdi -d
if %sb_type%==sdiso goto %goingto%

echo    %sb_tool%: Generating SelfBoot image...
echo.

if %sb_type%==mds_cdda tools\%sb_tool% -c %volumelabel%.mds %volumelabel%.iso %CDDA%
if %sb_type%==mds tools\%sb_tool% -a %volumelabel%.mds %volumelabel%.iso
if %sb_type%==cdi tools\%sb_tool% %volumelabel%.iso %volumelabel%.cdi -l %LBA%

if not exist %volumelabel%.MDS set errorresult=Error creating the data of the game. Process of SelfBoot creation cancelled.&if %sb_type%==mds_cdda goto ERROR
if not exist %volumelabel%.MDS set errorresult=Error creating the data of the game. Process of SelfBoot creation cancelled.&if %sb_type%==mds goto ERROR
if not exist %volumelabel%.cdi set errorresult=Error creating the data of the game. Process of SelfBoot creation cancelled.&if %sb_type%==cdi goto ERROR




goto %goingto%



:SB_DONE
for /f "usebackq delims=" %%G in (`tools\busybox.exe sh ./tools/basher.sh`) do set "timestamp=%%G"

if exist "%volumelabel%.cdi" ren "%volumelabel%.cdi" "%volumelabel%.tmp" >NUL
if not exist archive\ mkdir archive >NUL
if exist *.cdi move /y *.cdi archive\ >NUL
if exist "%volumelabel%.tmp" ren "%volumelabel%.tmp" "%volumelabel%.cdi" >NUL

if %input_type%==4 del /f /q %volumelabel%.iso >NUL
if %sb_type%==sdiso if exist %volumelabel%.iso ren %volumelabel%.iso "%volumelabel%-%timestamp%.iso" >NUL
if exist "%volumelabel%.cdi" ren "%volumelabel%.cdi" "%volumelabel%-%timestamp%.cdi" >NUL
if exist "%volumelabel%.mds" ren "%volumelabel%.mds" "%volumelabel%-%timestamp%.mds" >NUL
if exist "%volumelabel%.mdf" ren "%volumelabel%.mdf" "%volumelabel%-%timestamp%.mdf" >NUL



set goingto=END
::echo.
if not %sb_tool%==ISO2CDI echo.
@tools\SFK color white
if not %sb_tool%==ISO2CDI echo.


if %alert%==alert_off goto SKIP_ALERT
call :SOUND

:SKIP_ALERT
tools\timer.exe stop
:: tools\timemer stopwatch view>.\tools\cfg\time.txt

for /f "delims=" %%i in ('.\tools\timer.exe view') do (
    set "stopwatch=%%i"
    echo time passed: !stopwatch!
	echo.
)

for /f "delims=" %%i in ('.\tools\timer.exe view -m') do (
    set "output=%%i"
    .\tools\sfk.exe echo It took you: [magenta]!output![def] minutes
)

if exist "%volumelabel%.iso" del /f /q "%volumelabel%.iso"
goto %goingto%



:END
echo %volumelabel%-%timestamp%.cdi>.\tools\lastname.txt
echo.
endlocal
pause
exit


:SOUND
if %alert%==alert_off goto :eof
:: set soundbank=classic
:: despair, avatar, classic, custom, twisted

echo    Run Alarm sound now...
:: Generate a random number between 1 and 6
set /a randNum=%random% %% 6 + 1
if "%soundbank%"=="classic" set randNum=1
if "%soundbank%"=="despair" set /a randNum=%random% %% 6 + 1
if "%soundbank%"=="twisted" set /a randNum=%random% %% 4 + 1
if "%soundbank%"=="avatar" set /a randNum=%random% %% 6 + 1
if "%soundbank%"=="unused" set "%soundbank%"="classic"&&set randNum=1
echo.

if not exist ".\tools\warnings\%soundbank%\0%randNum%.mp3" set randNum=1

:: background_play
cd .\tools\warnings&&background_play.exe "%soundbank%" "0%randNum%.mp3"&&cd ..&&cd ..

:: not background_play
::tools\warnings\mpg123.exe -o s "tools\warnings\%soundbank%\0%randNum%.mp3"
echo.
goto :eof

:SOUND_IN_MENU
:: plays sound in background with background_play.exe in main menu, mostly for "twisted" soundbank
::setlocal enabledelayedexpansion
set /a rand=%random% %% 2 + 1

if %alert%==alert_on (
    cd .\tools\warnings
    if !rand!==1 (
        "background_play.exe" "%soundbank%" "make-your-selection.mp3"
    ) else if !rand!==2 (
        "background_play.exe" "%soundbank%" "make-your-selection2.mp3"
    )
    cd ..&&cd ..
)
goto :eof


:cdi_unpacker
:: work in progress