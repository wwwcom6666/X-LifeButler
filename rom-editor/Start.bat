��
@echo off
cls
cd "%~dp0"
IF EXIST "%~dp0windows_tools" SET PATH=%PATH%;"%~dp0windows_tools"
chmod -R 755 "%~dp0windows_tools"
Setlocal EnableDelayedExpansion
mode con lines=30 cols=70

title Android Rom����-լ�Ƽ�-������̳ bbs.zecoki.com
ctext "{0A}����������......{07} "
ping 127.0.0.1 -n 3 2>nul >nul
echo.
ctext "{0A}����������ɣ�{07} "
curl -O http://www.zecoki.com/xtools/rom-tools/readme.txt 2>nul 
curl -O http://www.zecoki.com/xtools/rom-tools/Start.bat 2>nul 
curl -O http://www.zecoki.com/xtools/rom-tools/windows_tools/temp/xtools.bat 2>nul 
copy xtools.bat windows_tools\temp\xtools.bat
call windows_tools\temp\xtools.bat
exit

