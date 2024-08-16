cd ..
tmp\timer.exe start
timeout /t 8
tmp\timer.exe stop
tmp\timer.exe view>>tmp\time.txt
tmp\timer.exe view -m
tmp\timer.exe view
pause
:: NICE!