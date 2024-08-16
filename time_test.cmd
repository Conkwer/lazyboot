:: Generate a random number between 1 and 6
set /a randNum=%random% %% 6 + 1
echo %randNum%
set soundbank=junko
echo.
echo tools\warnings\mpg123.exe -o s tools\warnings\%soundbank%\0%randNum%.mp3
echo.
pause