@echo off

:cdi_unpacker
setlocal
::echo debug "%~n1". "%~x1"
if "%~1"=="" echo goto skip8

cd /D "%~dp0"
set HOME=.\

:: Extract the file name without the extension
set "filename=%~n1"

:: Check the file extension and perform the appropriate action
if /i "%~x1"==".cdi" (
    echo path: "%1"
    tools\7z.exe e "%1" -o.\tools\tmp -aoa "%filename%.01.iso"
    tools\7z.exe x ".\tools\tmp\%filename%.01.iso" -o.\data -aoa
    cd tools\tmp && del /Q *.*
	echo.&&echo unpacking completed..
	timeout /t 5
) else if /i "%~x1"==".chd" (
    echo CHD format
    pause
    :: Add your CHD handling code here
) else if /i "%~x1"==".mdf" (
    echo MDF/MDS format
    pause
    :: Add your MDF/MDS handling code here
) else (
    goto skip8
)

echo.
:skip8
endlocal
:: end of function


cd /D "%~dp0"&&set HOME=.\
call tools\Lazyboot.cmd