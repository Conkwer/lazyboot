@echo off
goto func

REM :::::::::::pause
:pause
    echo.
    sfk echo "[cyan]Press enter to continue ..[def]"
    set /p nul=
	goto :eof
REM :::::::::::pause
:func

sfk echo [cyan]This tool generate [green]dummy[def] [cyan]file named 0.0 in the[def] [green]data[def] [cyan]folder[def]
echo Are you ready?
pause
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

if /i %DATASIZE% GEQ %MAXSIZE% sfk echo [red]ERROR[def]^: [red]Too big size of all data[def]&sfk sleep 300&sfk echo [cyan]DUMMY FILE[def] = [green]%DUMMY%[def] Mb ^(disabled^)&sfk sleep 500&echo.&goto end
sfk echo OK, [cyan]DUMMY FILE[def] = [green]%DUMMY%[def] Mb&sfk sleep 500
echo.

Doomer.exe %DUMMY_FILE% "..\data\0.0"


:end
pause