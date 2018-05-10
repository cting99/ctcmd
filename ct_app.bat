@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------phone app----------------------------------------
REM
REM		in [option]
REM		xx [option]
REM		[option]
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
if "%~1"=="HelpHint"	goto:HelpHint
echo.
call :Init
title %~0  "%*"
REM echo phone app: %* & pause>nul
REM echo param1:%1
REM echo param2:%2
REM echo param3:%3

call :UpdateParams
set label=%~1
if not "%label%"==""	set label=%label: =%
echo --------------------------------------------------------------------------
if "%label%"=="" 					goto:Help
if "%label%"=="h"					goto:Help

if not "%label%"=="" call :GetInfoByName %label%

if "%~2"=="in" 				call :InstallApp %appLocation% %appPkgName% %appClsName%	& goto:eof
if "%~2"=="xx" 				call :UnInstallApp %appPkgName%														& goto:eof
if not "%appPkgName%%appClsName%"=="" (
 call :OpenApp %appPkgName%/%appClsName%
) else (
 pause
)
goto:eof


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * app	��h/[option] [in/xx]
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo app [option] [in/xx]
	echo.
	echo [option]^:
	call :PrintAllInfo
	echo.
	echo    * in   ����װ
	echo    * xx   ��ж��
	echo    * h   ��������
	echo ���������������ʾ������
	echo �����ļ��� %config_file_apps%
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:UpdateParams
set appOptioin=%~1
set appPkgName=%~2
set appClsName=%~3
set appLocation=%~4
if "%5"=="-print" (
	echo.
	echo appOptioin	%appOptioin%
	echo appPkgName	%appPkgName%
	echo appClsName	%appClsName%
	echo appLocation	%appLocation%
	echo.
)
goto:eof


:GetInfoByName
call :UpdateParams
for /F "usebackq skip=1 eol=# tokens=1,2,3,4" %%a in ("%config_file_apps%") do (
  if "%1"=="%%a" (
	  REM echo    * %%a = %%b
	  call :UpdateParams "%%~a" "%%~b" "%%~c"	"%%d" -print
	  goto:eof
	)
)
if "%appOptioin%"=="" (
  echo û�� %1���������ѡ��
  call :PrintAllInfo
  echo.
  echo �� %config_file_apps% �����������
)
goto:eof


:PrintAllInfo
call :UpdateParams
for /F "usebackq skip=1 eol=# tokens=1,2,3,4" %%a in ("%config_file_apps%") do (echo    * %%a	= %%b/%%c)
goto:eof


:PrintInfoByPkg
call :UpdateParams
for /F "usebackq skip=1 eol=# tokens=1,2,3,4" %%a in ("%config_file_apps%") do ( if not "%%c"==""  echo    * %%a	^: %%b/%%c)
goto:eof



:OpenApp
REM  param pkgName/clsName
@echo off
echo.
echo ���� %1...
adb shell am start -n %1
echo.
if %errorlevel%==0 pause & goto:eof
set openAgain=
set /p openAgain=��ʧ�ܣ��Ƿ����ԣ�^(y/n^)
if "%openAgain%"=="y" call :OpenApp %1
goto:eof


:InstallApp
REM  param apkPath,pkgName,clsName
@echo off
if not exist "%~1"		echo ���ز�����ָ��apk�� 	& pause>nul & goto:eof
if "%2"==""						echo echo ����Ϊ�գ� 			& pause>nul & goto:eof
if "%3"==""						echo echo ����Ϊ�գ�	 		& pause>nul & goto:eof
call :UnInstallApp %2
echo.
call "%~dp0ct_common.bat" Delay 4
echo ��װ %1...
adb install %1
call :OpenApp %2/%3
goto:eof


:UnInstallApp
REM  param pkgName
@echo off
if "%~1"==""					echo ����Ϊ�գ� 					& pause>nul & goto:eof
echo.
echo ж�� %1...
adb uninstall %1
goto:eof