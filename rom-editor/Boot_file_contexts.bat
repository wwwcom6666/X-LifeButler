��
::  file_contexts��ȡ  by @xiaohuzz    2015.11.15
@echo off
%~d0
cd "%~p0"
IF EXIST "%~dp0windows_tools" SET PATH=%PATH%;"%~dp0windows_tools"
chmod -R 755 "%~dp0windows_tools"
Setlocal EnableDelayedExpansion
mode con lines=30 cols=70

if "%~1" == "" goto noargs
if /i "%~x1" NEQ ".img" goto noargs
set "file=%~f1"
if exist "%~n1" rd /s /q "%~n1" >nul
mkdir "%~n1"
copy "%file%" "%~n1" >nul
cd "%~n1"
ren "%~nx1" boot.img
bootimg.exe --unpack-bootimg boot.img
cd ..
copy "%~n1\initrd\file_contexts" "system_temp" >nul
echo.
echo   Ok  ��ɣ�
echo.
rd /s /q "%~n1" >nul
ping 127.1 -n 2 >nul 
goto end

:noargs
echo.
echo ��� boot.img ���� Boot_file_contexts.bat

:error
echo.
echo ����
echo.
echo ������رմ���
echo.
pause >nul

:end
