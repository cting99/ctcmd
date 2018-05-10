@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------aapt---------------------------------------------
REM
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
if "%~1"=="HelpHint"		goto:HelpHint
echo.
call :Init
title %~0  "%*"

set param1=%~1
if not "%param1%"=="" set param1=%param1: =%
echo --------------------------------------------------------------------------
if "%param1%"=="open"		start %dir_AAPT%	&	goto:eof

if "%param1%"==""				goto:Help
if "%param1%"=="h"			goto:AAPT
if not exist "%param1%"	goto:AAPT

call:getInfos "%~1" "%~2"
goto:eof


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * aapt	：h/open/[local apkpath] {view}
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo 解析apk包：
	echo.
	echo aapt [apkpath] {view}
	echo aapt open ：打开aapt所在目录
	echo aapt h    ：aapt支持的操作
	echo 如果不带参数，显示本帮助
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:AAPT
echo %dir_AAPT%\aapt %*
%dir_AAPT%\aapt %*
pause
goto:eof


:getInfos 
call :CollectData "%~dpnx1"
if "%~x1"==".apk"	(
 call :analysisApk "%~dpnx1"
) else (
 call :traversalApks "%~dpnx1"
)
type %analysisFile%
echo.	&	echo 结束
if "%~2"=="view" (
 call "%~dp0ct_common.bat" Open %analysisFile%
) else (
 echo ----^> %analysisFile%
)
pause>nul
goto:eof


:analysisApk
REM echo analysisApk:%1
setlocal enabledelayedexpansion
if "%~x1"==".apk" (
 	set apkName=%~n1
 	set localApk=%~1
 	set outBadingFile=%aaptOutDir%\!apkName!_badging.txt
 	%dir_AAPT%\aapt dump badging "!localApk!">"!outBadingFile!"
  echo !localApk!>>"!analysisFile!"
	findstr "package: launchable-activity: sdkVersion: targetSdkVersion:" "!outBadingFile!">>"!analysisFile!"
	echo.>>%analysisFile%
  echo.>>%analysisFile%
)
goto:eof


:traversalApks
REM echo traversalApks:%1
REM for /r "%~1" %%i in (*.apk) do (echo %%i)
for /r "%~1" %%i in (*.apk) do (call :analysisApk %%i)
goto:eof


:printParams
echo.
echo aaptOutDir="%aaptOutDir%"
echo analysisFile="%analysisFile%"
echo.
goto:eof


:CollectData
echo checking %~1 ...
set aaptOutDir=%outDir%\ApkAnalysic
set analysisFile=%aaptOutDir%\analysis.txt
echo.>%analysisFile%
if not exist "%aaptOutDir%" mkdir "%aaptOutDir%"
REM call :printParams
goto:eof


:GetAllBasicInfo
echo.
echo aapt dump %~1% 
echo   ---^> %aaptOutDir%\
%dir_AAPT%\aapt dump badging 			"%~1%" > "%aaptOutDir%\aapt_badging.txt"
%dir_AAPT%\aapt dump permissions 	"%~1%" > "%aaptOutDir%\aapt_permissions.txt"
%dir_AAPT%\aapt dump resources   	"%~1%" > "%aaptOutDir%\aapt_resources.txt"
%dir_AAPT%\aapt l   							"%~1%" > "%aaptOutDir%\aapt_list.txt"
call "%~dp0ct_common.bat" Open "%aaptOutDir%"
goto:eof

