@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------phone app----------------------------------------
REM
REM		[option]
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
if "%~1"=="HelpHint"	goto:HelpHint
echo.
call :Init
title %~0  "%*"
set label=%~1
if not "%label%"==""		set label=%label: =%
echo --------------------------------------------------------------------------
if "%label%"==""								goto :Help
if "%label%"=="h"								goto :Help

goto :PullData


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * data	：h/[option]/[pkgName]
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo data [package name]
	echo.
	echo data [option]
	echo.
	echo [option]^:
	call :PrintAllInfo
	echo.
	echo    * h   ：本帮助
	echo 如果不带参数，显示本帮助
	echo 配置文件： %config_file_apps%
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:PrintAllInfo
for /F "usebackq skip=1 eol=# tokens=1,2" %%a in ("%config_file_apps%") do (echo    * %%a ^: %%b)
goto:eof


:PullData
call :getPkgNameByOption %~1
if  "%pkgName%"=="" (
 echo 未知包名："%~1%"
 pause
 goto:Help
)
call :MakePullOutDir %pkgName%
echo.
echo adb pull /data/data/%pkgName% %temp%
echo.
adb pull /data/data/%pkgName%/databases 		%temp%\databases
adb pull /data/data/%pkgName%/cache 				%temp%\cache
adb pull /data/data/%pkgName%/shared_prefs 	%temp%\shared_prefs
adb pull /data/data/%pkgName%/files				 	%temp%\files
adb pull /data/data/%pkgName%/albumthumbs				 	%temp%\albumthumbs
REM adb pull /data/data/%pkgName%/ %temp%\
REM adb pull /data/app-lib/%pkgName%						%temp%\lib
call "%~dp0ct_common.bat" Open "%temp%"
pause
goto:eof


:getPkgNameByOption
set pkgName=%~1
for /F "usebackq skip=1 eol=# tokens=1,2" %%a in ("%config_file_apps%") do (
 if "%%a"=="%~1" (
  set pkgName=%%b
  goto:eof
 )
)
goto:eof


:MakePullOutDir
set temp=%outDir%\%~1
if exist "%temp%"	rmdir /s/q "%temp%"
mkdir "%temp%"
echo ---^> %temp%
goto:eof

