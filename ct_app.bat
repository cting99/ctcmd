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
echo * app	：h/[option] [in/xx]
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
	echo    * in   ：安装
	echo    * xx   ：卸载
	echo    * h   ：本帮助
	echo 如果不带参数，显示本帮助
	echo 配置文件： %config_file_apps%
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
  echo 没有 %1，请从以下选择：
  call :PrintAllInfo
  echo.
  echo 在 %config_file_apps% 里面可以配置
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
echo 启动 %1...
adb shell am start -n %1
echo.
if %errorlevel%==0 pause & goto:eof
set openAgain=
set /p openAgain=打开失败，是否重试？^(y/n^)
if "%openAgain%"=="y" call :OpenApp %1
goto:eof


:InstallApp
REM  param apkPath,pkgName,clsName
@echo off
if not exist "%~1"		echo 本地不存在指定apk！ 	& pause>nul & goto:eof
if "%2"==""						echo echo 包名为空！ 			& pause>nul & goto:eof
if "%3"==""						echo echo 类名为空！	 		& pause>nul & goto:eof
call :UnInstallApp %2
echo.
call "%~dp0ct_common.bat" Delay 4
echo 安装 %1...
adb install %1
call :OpenApp %2/%3
goto:eof


:UnInstallApp
REM  param pkgName
@echo off
if "%~1"==""					echo 包名为空！ 					& pause>nul & goto:eof
echo.
echo 卸载 %1...
adb uninstall %1
goto:eof