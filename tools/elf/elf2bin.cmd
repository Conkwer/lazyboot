@echo off
sh-elf-objcopy.exe -O binary main.elf 2st_read.bin
scramble 2st_read.bin 1st_read.bin
del 2st_read.bin
echo Okey
pause