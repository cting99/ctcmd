@echo off
REM cls
REM --------------------------------------------------------------------------------------
REM -------------------------------------------adb----------------------------------------
REM
REM		port
REM		killport
REM		killport
REM		log
REM		video
REM		h
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
if "%~1"=="HelpHint"	goto:HelpHint
echo.
title %~0  "%*"
call :Init
REM echo adb: %* & pause>nul
set label=%~1
if not "%label%"=="" set label=%label: =%
echo --------------------------------------------------------------------------

set params=%*

if "%label%"=="" 					goto:ConnectAdb
if "%label%"=="port" 			goto:CheckAdbPort
if "%label%"=="killport" 	goto:CheckAdbPortAndKill
if "%label%"=="log"			 	goto:RecordLog
if "%label%"=="video"		 	goto:RecordScreen
if "%label%"=="h" 				goto:Help
if "%label%"=="prop"			call:Prop %params:~4%			& goto:eof
goto:Adb


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * adb	：h/port/killport/video/log
REM echo * prop	：  [prop keyword]/:build/:mak
goto:eof


:Help
cls
echo ------------------------------------------------------------------------------
echo.
echo adb [option]
echo.
echo [option]^:
echo   * port  	：检查adb端口5093
echo   * killport  	：检查adb端口5093并结束相关进程
echo   * video  	：手机录屏
echo   * log  	：录制手机log
echo   * prop [xxx\:build]
echo   * h  		：帮助
echo.
echo 如果不带参数，会运行adb root和adb remount
echo.
echo ------------------------------------------------------------------------------
pause>nul
goto:eof


:Adb
echo.
echo adb %*
adb %*
if not "%errorlevel%"=="0"	(
 echo fail...
)
REM echo 结束
pause
goto:eof


:RecordScreen
call "%~dp0ct_common.bat" FreshTimeName
echo 开始录屏...
set recordName=video_%timeName%.mp4
set recordMp4=/mnt/sdcard/DCIM/%recordName%
adb shell screenrecord %recordMp4%
adb pull %recordMp4% %outDir%
call "%~dp0ct_common.bat" Open "%outDir%"
echo. & pause>nul
goto:eof


:RecordLog
call "%~dp0ct_common.bat" FreshTimeName
set logName=log_%timeName%.txt
set temp=%outDir%\%logName%
echo logcat...
adb shell logcat -v time > %temp%
call "%~dp0ct_common.bat" Open "%temp%"
echo. & pause>nul
goto:eof


:ConnectAdb
@echo off
echo.
echo 测试adb...
set adbAgain=
adb root & adb remount
if %errorlevel%==1 (
 set /p adbAgain=是否重新测试adb？^(y/n^)
)
if "%adbAgain%"=="y" call :ConnectAdb
goto:eof



:CheckAdbPort
cls
echo --------------------------------------------------------------------------
::netstat -ano | findstr "5037"
for /F "usebackq tokens=1,2,3,4,5" %%a in (`"netstat -ano | findstr "5037""`) do (
  if not "%%e"=="0" echo %%a	%%b	%%c	  %%d	%%e
)
echo --------------------------------------------------------------------------
echo 上面的数据最后一列是pid，在任务管理器里面结束对应的进程，可以释放5037端口
start C:\WINDOWS\system32\taskmgr.exe
echo.
echo 按任意键测试adb & pause>nul
call :ConnectAdb
pause
goto:eof



:CheckAdbPortAndKill
cls
for /F "usebackq tokens=5" %%a in (`"netstat -ano | findstr "5037""`) do (
  if not "%%a"=="0" TASKKILL /f /PID %%a
)
echo.
echo 按任意键测试adb & pause>nul
call :ConnectAdb
pause
goto:eof


:Prop
set param1=%~1
if not "%param1%"=="" set param1=%param1: =%
if "%param1%"==""				goto:getAllprops
if "%param1%"==":build"	goto:getBuildpropfile
if "%param1%"==":mak"		goto:getProjectConfig
call :searchPropFromAll %param1%
goto:eof


:getAllprops
echo properties...
set path_properties=%outDir%\properties.txt
call :DeleteFile "%path_properties%"
adb shell getprop > "%path_properties%"
call "%~dp0ct_common.bat" Open "%path_properties%"
pause>nul
goto:eof


:getBuildpropfile
echo system/build.prop...
set path_properties=%outDir%\build.prop
call :DeleteFile "%path_properties%"
adb pull /system/build.prop "%path_properties%"
call "%~dp0ct_common.bat" Open "%path_properties%"
pause>nul
goto:eof


:searchPropFromAll
echo search property %1 ...
echo.
adb shell getprop|find /i "%1"
echo.
echo prop搜索结束。
pause>nul
goto:eof


:getProjectConfig
echo ProjectConfig...
set path_projectconfig=%outDir%\ProjectConfig.mk
call :DeleteFile "%path_projectconfig%"
adb pull /system/data/misc/ProjectConfig.mk "%path_projectconfig%"
call "%~dp0ct_common.bat" Open "%path_projectconfig%"
pause>nul
goto:eof


:DeleteFile
if exist "%~1" (
 del /q "%~1"
)
goto:eof

