@echo off
if exist tools\DreamcastCdiTool\GameFolderDreamcast\ tools\rm -r tools/DreamcastCdiTool/GameFolderDreamcast/
setlocal enabledelayedexpansion
SFK color white

set /p volumelabel=<volumelabel.txt
set filename=%volumelabel%.cdi


SET manualModification=disabled
SET keepFiles=false
set pickDestinationFolder=false
set silent=false

set gameFolderPostfix=GameFolderDreamcast
set gameWorkingDir=%~dp0%gameFolderPostfix%
set launchDir=%~dp0





echo.
%launchDir%\sfk.exe echo [cyan]::cdi to data^/data folder[def]
%launchDir%\sfk.exe sleep 1200

:cdi_to_data_data_folder
set shouldCreateCDI=1
set initialFileFormat=Audio-Data

set gameName=not set
for %%i in (%filename%) do ( 
set gameName=%%~ni
set gameFileName=%%~nxi
)

set gameName=%gameName: =_%
%launchDir%\sfk.exe echo [cyan]Selected Game Name is[def] [green]%gameName%[def]
%launchDir%\sfk.exe sleep 1200
set gameFolder="%gameWorkingDir%\%gameName%"
mkdir %gameFolder%
cd %gameFolder%
set workDir=%cd%
echo workDir=%workDir%





echo.
%launchDir%\sfk.exe echo [cyan]::extracting CDI file content..[def]
%launchDir%\sfk.exe sleep 1200
::extracting CDI file content
"%launchDir%cdirip.exe" "%launchDir%%filename%" "%workDir%"




echo.
%launchDir%\sfk.exe echo [cyan]::reading LBA value for game data file..[def]
%launchDir%\sfk.exe sleep 1200
::reading LBA value for game data file
"%launchDir%cdirip.exe" "%launchDir%%filename%" -info>cdiripinfo.log
for /f "tokens=8 delims= " %%i in ('FINDSTR /C:"LBA" "%workDir%"\cdiripinfo.log') do set "lba=%%i"




echo.
%launchDir%\sfk.exe echo [cyan]::reading track number for game data file..[def]
%launchDir%\sfk.exe sleep 1200
::reading track number for game data file
type "%workDir%"\cdiripinfo.log | find /c "LBA">"%workDir%"\track_number.log
set /p trackNumber=< "%workDir%"\track_number.log
if "%keepFiles%"=="false" del "%workDir%"\track_number.log
if "%keepFiles%"=="false" del cdiripinfo.log




echo.
%launchDir%\sfk.exe echo [cyan]::add leading zero if needed[def]
%launchDir%\sfk.exe sleep 1200
::add leading zero if needed
if 1%trackNumber% LSS 100 SET trackNumber=0%trackNumber%
set trackNumber=%trackNumber:~-2%

set sessionNumber=02
if "%trackNumber%"=="01" set sessionNumber=01
set isoFileName=s%sessionNumber%t%trackNumber:~-2%.iso
echo lba=%lba%
echo isoFileName=%isoFileName%




echo.
%launchDir%\sfk.exe echo [cyan]::fix image so it's possible to extract it's content[def]
%launchDir%\sfk.exe sleep 1200
::fix image so it's possible to extract it's content
(
echo %isoFileName%
echo %lba%
)|"%launchDir%\isofix"

set archiveForExtraction=fixed.iso




echo.
%launchDir%\sfk.exe echo [cyan]::delete unnecessary files[def]
%launchDir%\sfk.exe sleep 1200
::delete unnecessary files
if "%keepFiles%"=="false" del %isoFileName%
if "%keepFiles%"=="false" del *.wav
if "%keepFiles%"=="false" del *.cue



echo.
%launchDir%\sfk.exe echo [cyan]::extracting iso content..[def]
%launchDir%\sfk.exe sleep 1200
::extracting iso content
set extractedFolder=%gameName%
echo Extracting %archiveForExtraction% to plain folder... Please wait...
"%launchDir%\7z" x -y -o%extractedFolder% %archiveForExtraction% >nul
::"%launchDir%\piso" extract %archiveForExtraction% / -od %extractedFolder%




echo.
%launchDir%\sfk.exe echo [cyan]::delete unnecessary files[def]
%launchDir%\sfk.exe sleep 1200
::delete unnecessary files
if "%keepFiles%"=="false" del %archiveForExtraction%
if "%keepFiles%"=="false" del header.iso




set bootFile=""

if exist %extractedFolder%\0.000 set bootFile=0.000
if exist %extractedFolder%\1ST_READ.BIN set bootFile=1ST_READ.BIN
if exist %extractedFolder%\0WINCEOS.BIN set bootFile=0WINCEOS.BIN
 
if %bootFile%=="" echo Can't locate boot file ^(1ST_READ.BIN or 0WINCEOS.BIN^)&SFK sleep 500&exit

set bootSector=IP.BIN
echo bootFile="%bootFile%"

if not exist bootfile.bin copy %extractedFolder%\IP.BIN
ren bootfile.bin %bootSector%
move %extractedFolder%\%bootFile% ".\" >nul

(
echo %bootFile%
echo %bootSector%
echo 0
)|"%launchDir%\binhack32"

move %bootFile% %extractedFolder% >nul
move IP.BIN %extractedFolder% >nul

echo.
%launchDir%\sfk.exe echo Convertation to self booting folder for [green]%gameName%[def] finished



echo.
%launchDir%\sfk.exe echo [cyan]::cdi to data^/data folder end[def]
%launchDir%\sfk.exe sleep 1200
:cdi_to_data_data_folder_end
cd %launchDir%



echo.
%launchDir%\sfk.exe echo [cyan]::bootable cdi from folder[def]
%launchDir%\sfk.exe sleep 1200
:bootable_cdi_from_folder
echo.
echo Creating CDI data-data file...

cd %gameFolder%
set volumeName=%gameName:~0,32%
%launchDir%\sfk.exe echo volumeName = [green]%volumeName%[def]
echo Working directory is: ^"Lazyboot^\tools^\DreamcastCdiTool^\GameFolderDreamcast^\^%volumeName%^\"
echo.
%launchDir%\sfk.exe echo [yellow]Last chance to modify selfboot folder's content.[def]
echo When Ready press ENTER to proceed with creation of CDI image...
echo.
pause
echo Creating bootable ISO from folder...
"%launchDir%\mkisofs" -C 0,0 -G %extractedFolder%\IP.BIN -V %volumeName% -joliet -rock -l -o data.iso %extractedFolder% >nul


%launchDir%\sfk.exe echo Creating CDI from ISO... [yellow]Please Wait...[def]
"%launchDir%\cdi4dc" data.iso %gameName%.cdi -d >nul
echo Creation of %gameName%.cdi is finished.
echo Full path to CDI image is %cd%\%gameName%.cdi


%launchDir%\sfk.exe echo [cyan]::delete unnecessary files[def]
%launchDir%\sfk.exe sleep 1200
::delete unnecessary files
del data.iso

cd %launchDir%



echo.
echo ::delete_folder
:delete_folder

rd /s /q "%gameWorkingDir%\%gameName%\%gameName%\"


 
%launchDir%\sfk.exe echo [green]end of convertions[def]
%launchDir%\sfk.exe sleep 1700
echo.

