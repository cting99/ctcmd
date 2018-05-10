@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------dumpsys------------------------------------------
REM
REM		in
REM		xx
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
if "%~1"=="HelpHint"	goto:HelpHint
echo.
call :Init
title %~0  "%*"
REM echo param1："%~1"
REM echo param2："%~2"
echo.
set param1=%~1
if not "%param1%"==""	set param1=%param1: =%
echo --------------------------------------------------------------------------
if "%param1%"==""					goto:Help
if "%param1%"=="h"				goto:Help

if "%param1%"=="unlock"			goto:Unlock
if "%param1%"=="top"			goto:GetTop
if "%param1%"=="tops"			goto:GetTops
if "%param1%"=="density"	goto:GetDensity
if "%param1%"=="ime"			goto:GetIme
if "%param1%"=="widget"		goto:GetCurrentWidget
if "%param1%"=="mem"			goto:GetMemory
if "%param1%"=="mount"		goto:GetMount

call :getPkgNameByOption %~1
if "%~2"==""							call:GepApkMainInfo			&	goto:eof
if "%~2"=="version"				call:GetApkVersion			&	goto:eof
if "%~2"=="path"					call:GetApkPath					&	goto:eof

call :Help
goto:eof


:Init
call "%~dp0ct_common.bat" Init
set dump_dir=%outDir%\dumpsys
goto:eof


:HelpHint
echo * sys	：h/unlock/top/density/ime/widget/mem/[pkgname or option] [version/path]
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo dumpsys^:
	echo.
	echo sys [option]
	echo.
	echo [option]^:
	echo.
	echo    * unlock	：解锁
	echo    * top		：当前界面
	echo    * tops	：当前多个界面
	echo    * density		：分辨率、密度
	echo    * ime		：所有输入法
	echo    * widget：当前桌面widget
	echo    * mem		：内存和进程
	echo    * 包名 [version/path]
	echo.
	echo    * h   ：本帮助
	echo 如果不带参数，显示本帮助
	echo.
  echo ------------------------------------------------------------------------------
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


:MakeSureDumpDirExit
REM param,file name
if not exist "%dump_dir%" mkdir "%dump_dir%"
if not "%~1"=="" (
 set out_file=%dump_dir%\%~1
)
goto:eof


:SysDump
REM param1,command
REM param2,keyword
REM param3,file name
echo.
call :MakeSureDumpDirExit %~3
if "%~2"=="" (
 echo %~1
 echo.
 %~1 > "%out_file%"
 call "%~dp0ct_common.bat" Open "%out_file%"
) else (
 echo %~1^|findstr /i "%~2"
 echo.
 %~1 > "%out_file%"
 findstr /i "%~2" "%out_file%"
 echo.
 echo ---^>%out_file%
)
pause
goto:eof


:Unlock
echo adb shell wm dismiss-keyguard
adb shell wm dismiss-keyguard
pause
goto:eof


:GetTop
REM call:ShellDump "dumpsys activity" "top"
REM call:ShellDump "dumpsys activity processes" "top-activity"
REM  call:ShellDump "dumpsys window windows" mTopFullscreenOpaqueWindowState
REM  call:ShellDump "dumpsys window windows" "mFocusedApp=AppWindowToken"
REM adb shell dumpsys window windows|findstr /i "mFocusedApp=AppWindowToken"
call :SysDump "adb shell dumpsys window windows" "mFocusedApp=AppWindowToken" "dumpsys_window_top.txt"
goto:eof

:GetTops
call :SysDump "adb shell dumpsys window w" "name=" "dumpsys_window_tops.txt"
goto:eof



:GetDensity
REM  adb shell dumpsys window displays|findstr /i "init"
call :SysDump "adb shell dumpsys window displays" "init" "dumpsys_window_displays.txt"
goto:eof


:GetIme
REM  adb shell ime list|findstr /i "mId"
call :SysDump "adb shell ime list" "mId" "dumpsys_ime.txt"
goto:eof

:GetCurrentWidget
call :SysDump "adb shell dumpsys appwidget" "" "dumpsys_current_widget.txt"
goto:eof


:GepApkMainInfo
REM  adb shell dumpsys package %pkgName%|findstr /i "version path time="
call :SysDump "adb shell dumpsys package %pkgName%" "version path time=" "dumpsys_pkg_%pkgName:.=_%.txt"
goto:eof


:GetMount
echo adb shell dumpsys mount
echo.
adb shell dumpsys mount
echo.
pause
goto:eof


:GetMemory
call :SysDump "adb shell df" "Size /" "dumpsys_df.txt"
call :SysDump "adb shell dumpsys meminfo" "RAM:" "dumpsys_meminfo.txt"
goto:eof


:PullPkgInfo
call :MakePullOutDir pkgInfo
echo   dump package...		& adb shell dumpsys package>%temp%\packages.txt
echo   dump activity...		&	adb shell dumpsys activity>%temp%\activities.txt
echo   dump ime...				& adb shell ime list>%temp%\imes.txt
echo   dump window...			& adb shell dumpsys window>%temp%\window.txt
call "%~dp0ct_common.bat" Open "%temp%"
goto:eof