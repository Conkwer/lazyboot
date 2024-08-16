@echo off
cd .\tools
sfk echo [cyan]capacity checker (80min)[def]
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


sfk sleep 300
if /i %DATASIZE% GEQ %MAXSIZE% sfk echo [cyan]FREE SPACE[def] = [red]%DUMMY%[def] Mb&goto end
sfk echo [cyan]FREE SPACE[def] = [green]%DUMMY%[def] Mb

:end
sfk sleep 500
echo.&echo.
pause