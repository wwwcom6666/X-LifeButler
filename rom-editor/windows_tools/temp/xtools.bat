��
cls
@echo off
del xtools.bat
if not exist images_out\nul (mkdir images_out)
if not exist images_temp\nul (mkdir images_temp)

cls
title Android Rom����-լ�Ƽ�-������̳ bbs.zecoki.com

:main
cls
echo.
ctext "   {0D}Android Rom����-լ�Ƽ�-������̳ bbs.zecoki.com{07}   {\n}"
echo *****************************************************
ctext     "          {0B}1. ���Img {07}       {0B}2. Img��� {07}{\n}"
echo *****************************************************
ctext     "          {0A}3. �˳� {07}          {0C}4. ��� {07} {\n}"
echo *****************************************************
echo.
set /p number=����ѡ��,��Enterȷ�ϣ�|| set number="0"
if %number%==1 goto ���Img
if %number%==2 goto Img���

if /I %number%==3 goto Exit
if /I %number%==4 goto Cleanup
echo.
ctext "{0C} %number% ����һ����Чѡ����������룡 {07}{\n}"
echo.
pause
goto main


:���Img
cls
echo.
echo ***************************************************
echo *          	                                  *
ctext "*         {0B} �뽫Img�ļ������ images_temp{07}          *{\n}"
echo *          	                                  *
echo *    	                                          *
echo ***************************************************
echo.

:jiebao_sys
if not exist images_temp\system.img goto imgerror 
if exist images_temp\system_ goto imgerror00 

cls
color 0B
echo.
ctext " {0A}���ڽ�ѹ,���Ե�...... {07} {\n}"
echo.
if exist "images_temp\system.img" Imgextractor images_temp\system.img -i | findstr /r /c:"^Open image" > images_temp\size.txt
if exist "images_temp\system_\.journal" (
del /q "images_temp\system_\.journal" > nul
echo.
ctext " {0A}��ѹsystem��� {07} , {0A}������ images_temp\system_{07} {\n}"
ctext " {0A}system_ ���ɶ��ƣ�ɾ������ӣ��޸ĵ�{07} {\n}"
echo.
)
goto jiebao_data

:imgerror
echo.
ctext "{0C} images_tempĿ¼��system.img������ {07}{\n}"
echo.
goto jiebao_data

:imgerror00
echo.
ctext "{0C} images_temp·����system_Ŀ¼δ���� {07}{\n}"
echo.
goto jiebao_data



:jiebao_data
if not exist images_temp\userdata.img goto imgerror1 
if exist images_temp\userdata_ goto imgerror11 

if exist "images_temp\userdata.img" Imgextractor images_temp\userdata.img -i | findstr /r /c:"^Open image" > images_temp\size1.txt
if exist "images_temp\userdata_\.journal" (
del /q "images_temp\userdata_\.journal" > nul
echo.
ctext " {0A}��ѹuserdata��� {07} , {0A}������ images_temp\userdata_{07} {\n}"
ctext " {0A}userdata_ ���ɶ��ƣ�ɾ������ӣ��޸ĵ�{07} {\n}"
echo.
)
goto jiebao_cust


:imgerror1
echo.
ctext "{0C} images_tempĿ¼��userdata.img������ {07}{\n}"
echo.
goto jiebao_cust

:imgerror11
echo.
ctext "{0C} images_temp·����userdata_Ŀ¼δ���� {07}{\n}"
echo.
goto jiebao_cust



:jiebao_cust
if not exist images_temp\cust.img goto imgerror2
if exist images_temp\cust_ goto imgerror22

if exist "images_temp\cust.img" Imgextractor images_temp\cust.img -i | findstr /r /c:"^Open image" > images_temp\size2.txt
if exist "images_temp\cust_\.journal" (
del /q "images_temp\cust_\.journal" > nul
echo.
ctext " {0A}��ѹcust��� {07} , {0A}������ images_temp\cust_{07} {\n}"
ctext " {0A}cust_ ���ɶ��ƣ�ɾ������ӣ��޸ĵ�{07} {\n}"
echo.
)
pause
goto main

:imgerror2
echo.
ctext "{0C} images_tempĿ¼��cust.img������ {07}{\n}"
echo.
pause
goto main

:imgerror22
echo.
ctext "{0C} images_temp·����cust_Ŀ¼δ���� {07}{\n}"
echo.
pause
goto main







:Img���
if not exist images_temp\system_ goto user���

:sys���
cls
echo ***********************sys���****************************
echo *          	                                  *
ctext "* {0B} �汾��5.x ��ȡ file_contexts ���� images_temp{07}  *{\n}"
echo *          	                                  *
ctext "*     {0B} 1- ���Ϊsparse ext4��ʽIMG(������ˢ){07}      *{\n}"
echo *          	                                  *
ctext "*     {0B} 2- ���Ϊraw ext4��ʽIMG(���ڿ�ˢ){07}         *{\n}"
echo *    	                                          *
ctext "*    {0B}  E.����{07}                                     *{\n}"
echo *    	                                          *
echo ***********************sys���****************************
echo.
set /p num=����ѡ��,��Enterȷ�ϣ�|| set num="0"
if %num%==1 goto sparse
if %num%==2 goto raw
if /I %num%==E goto main
echo.
ctext "{0C} %number% ����һ����Чѡ����������룡 {07}{\n}"
echo.
pause
goto Img���

:sparse
cls
color 0A
for /f "tokens=6 delims= " %%i in (images_temp\size.txt) do (
	set dev=%%i
)
for /f "tokens=2 delims==" %%a in ('findstr /r /c:"^ro.build.version.release" images_temp\system_\build.prop') do (
set var=%%a
)
set version=%var:~0,1%
if "%version%" == "6" goto sparse5.x
if "%version%" == "5" goto sparse5.x
if "%version%" == "4" goto sparse4.x
goto versionerror

:sparse5.x
make_ext4fs -s -T 0 -S images_temp\file_contexts -l %dev% -a system images_out\sparse.system.img  images_temp\system_
if errorlevel == 1 goto img���error
echo.--------------------------------- 
echo 5.x system������ ����images_out
echo.
pause
goto user���

:sparse4.x
make_ext4fs -s -l %dev% -a  system images_out\sparse.system.img images_temp\system_
if errorlevel == 1 goto img���error
echo.--------------------------------- 
echo 4.x system������ ����images_out
echo.
pause
goto user���
 
:raw
cls
color 0A
for /f "tokens=6 delims= " %%i in (images_temp\size.txt) do (
	set dev=%%i
)
for /f "tokens=2 delims==" %%a in ('findstr /r /c:"^ro.build.version.release" images_temp\system_\build.prop') do (
set var=%%a
)
set version=%var:~0,1%
if "%version%" == "6" goto raw5.x
if "%version%" == "5" goto raw5.x
if "%version%" == "4" goto raw4.x
goto versionerror

:raw5.x
make_ext4fs -T 0 -S images_temp\file_contexts -l %dev% -a system images_out\raw.system.img  images_temp\system_
if errorlevel == 1 goto img���error
echo.--------------------------------- 
echo 5.x system������ ����images_out
echo.
pause
goto user���

:raw4.x
make_ext4fs -l %dev% -a system images_out\raw.system.img images_temp\system_
if errorlevel == 1 goto img���error
echo.--------------------------------- 
echo 4.x system������ ����images_out
echo.
pause
goto user���

:img���error
echo.
ctext "{0C} ����images_tempĿ¼��system_��file_contexts�ļ��Ƿ���� {07}{\n}"
echo.
pause
goto Img���

:versionerror
echo.
echo ���� ��׿�汾���� 4.x ���� 5.x 
echo.
echo ������ص����˵�
echo.
goto main

:Cleanup
cls
rd /s /q system_new.transfer > nul 2>&1
rd /s /q images_out > nul 2>&1
rd /s /q images_temp > nul 2>&1
mkdir system_new.transfer > nul 2>&1
mkdir images_out > nul 2>&1
mkdir images_temp > nul 2>&1
goto main








:user���
if not exist images_temp\userdata_ goto cust���

cls
echo ************************user���***************************
echo *          	                                  *
echo *          	                                  *
ctext "*     {0B} 1- ���Ϊsparse ext4��ʽIMG(������ˢ){07}      *{\n}"
echo *          	                                  *
ctext "*     {0B} 2- ���Ϊraw ext4��ʽIMG(���ڿ�ˢ){07}         *{\n}"
echo *    	                                          *
ctext "*    {0B}  E.����{07}                                     *{\n}"
echo *    	                                          *
echo **************************user���*************************
echo.
set /p num=����ѡ��,��Enterȷ�ϣ�|| set num="0"
if %num%==1 goto sparse1
if %num%==2 goto raw1
if /I %num%==E goto main
echo.
ctext "{0C} %number% ����һ����Чѡ����������룡 {07}{\n}"
echo.
pause
goto user���

:sparse1
cls
color 0A
for /f "tokens=6 delims= " %%i in (images_temp\size1.txt) do (
	set dev=%%i
)
goto sparse4.x1


:sparse4.x1
make_ext4fs -s -l %dev% -a  userdata images_out\sparse.userdata.img images_temp\userdata_
if errorlevel == 1 goto user���error
echo.--------------------------------- 
echo userdata������ ����images_out
echo.
pause
goto cust���
 
:raw1
cls
color 0A
for /f "tokens=6 delims= " %%i in (images_temp\size1.txt) do (
	set dev=%%i
)

goto raw4.x1


:raw4.x1
make_ext4fs -l %dev% -a userdata images_out\raw.userdata.img images_temp\userdata_
if errorlevel == 1 goto user���error
echo.--------------------------------- 
echo userdata������ ����images_out
echo.
pause
goto cust���

:user���error
echo.
ctext "{0C} ����images_tempĿ¼��userdata_�ļ��Ƿ���� {07}{\n}"
echo.
pause
goto user���






:cust���
if not exist images_temp\cust_ goto main

cls
echo ************************��׿�汾�ж�***************************
echo *          	                                  *
echo *          	                                  *
ctext "*     {0B} 1- ��׿5.0����{07}      *{\n}"
echo *          	                                  *
ctext "*     {0B} 2- ��׿4.4����{07}         *{\n}"
echo *    	                                          *
ctext "*    {0B}  E.����{07}                                     *{\n}"
echo *    	                                          *
echo **************************cust���*************************
echo.
set /p number=����ѡ��,��Enterȷ�ϣ�|| set number="0"
if %number%==1 goto cust5.x
if %number%==2 goto cust4.x

echo.
ctext "{0C} %number% ����һ����Чѡ����������룡 {07}{\n}"
echo.
pause
goto main

:cust5.x
cls
echo ***********************cust���****************************
echo *          	                                  *
ctext "* {0B} �汾��5.x ��ȡ file_contexts ���� images_temp{07}  *{\n}"
echo *          	                                  *
ctext "*     {0B} 1- ���Ϊsparse ext4��ʽIMG(������ˢ){07}      *{\n}"
echo *          	                                  *
ctext "*     {0B} 2- ���Ϊraw ext4��ʽIMG(���ڿ�ˢ){07}         *{\n}"
echo *    	                                          *
ctext "*    {0B}  E.����{07}                                     *{\n}"
echo *    	                                          *
echo ***********************cust���****************************
echo.
set /p num=����ѡ��,��Enterȷ�ϣ�|| set num="0"
if %num%==1 goto sparse2
if %num%==2 goto raw2
if /I %num%==E goto main
echo.
ctext "{0C} %number% ����һ����Чѡ����������룡 {07}{\n}"
echo.
pause
goto cust���

:sparse2
cls
color 0A
for /f "tokens=6 delims= " %%i in (images_temp\size2.txt) do (
	set dev=%%i
)

goto sparse5.x2

:sparse5.x2
make_ext4fs -s -T 0 -S images_temp\file_contexts -l %dev% -a cust images_out\sparse.cust.img  images_temp\cust_
if errorlevel == 1 goto cust���error
echo.--------------------------------- 
echo 5.x cust������ ����images_out
echo.
pause
goto main

:raw5.x2
make_ext4fs -T 0 -S images_temp\file_contexts -l %dev% -a cust images_out\raw.cust.img  images_temp\cust_
if errorlevel == 1 goto cust���error
echo.--------------------------------- 
echo 5.x cust������ ����images_out
echo.
pause
goto main



:cust4.x
cls
echo ***********************cust���****************************
echo *          	                                  *
ctext "* {0B} �汾��5.x ��ȡ file_contexts ���� images_temp{07}  *{\n}"
echo *          	                                  *
ctext "*     {0B} 1- ���Ϊsparse ext4��ʽIMG(������ˢ){07}      *{\n}"
echo *          	                                  *
ctext "*     {0B} 2- ���Ϊraw ext4��ʽIMG(���ڿ�ˢ){07}         *{\n}"
echo *    	                                          *
ctext "*    {0B}  E.����{07}                                     *{\n}"
echo *    	                                          *
echo ***********************cust���****************************
echo.
set /p num=����ѡ��,��Enterȷ�ϣ�|| set num="0"
if %num%==1 goto sparse2
if %num%==2 goto raw2
if /I %num%==E goto main
echo.
ctext "{0C} %number% ����һ����Чѡ����������룡 {07}{\n}"
echo.
pause
goto cust���

:sparse4.x2
make_ext4fs -s -l %dev% -a  cust images_out\sparse.system.img images_temp\cust_
if errorlevel == 1 goto cust���error
echo.--------------------------------- 
echo 4.x cust������ ����images_out
echo.
pause
goto main
 
:raw2
cls
color 0A
for /f "tokens=6 delims= " %%i in (images_temp\size2.txt) do (
	set dev=%%i
)

set version=%var:~0,1%
goto raw4.x2

:raw4.x2
make_ext4fs -l %dev% -a cust images_out\raw.cust.img images_temp\cust_
if errorlevel == 1 goto cust���error
echo.--------------------------------- 
echo 4.x cust������ ����images_out
echo.
pause
goto main


:cust���error
echo.
ctext "{0C} ����images_tempĿ¼��cust_��file_contexts�ļ��Ƿ���� {07}{\n}"
echo.
pause
goto cust���




:versionerror
echo.
echo ���� ��׿�汾���� 4.x ���� 5.x 
echo.
echo ������ص����˵�
echo.
goto main

pause >nul
:Exit
del windows_tools\temp\xtools.bat
exit
