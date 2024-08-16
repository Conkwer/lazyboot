@echo off
setlocal enabledelayedexpansion
tools\timer.exe start
timeout /t 3
tools\timer.exe stop

tools\timer.exe view -m
pause

pwd&&pause
for /f "delims=" %%i in ('.\tools\timer.exe view -m') do (
    set "output=%%i"
    .\tools\sfk.exe echo It took you: [magenta]!output![def]  minutes
)
cd ..

pause
