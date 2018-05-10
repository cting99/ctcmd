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
if "%label%"=="mtklog"					goto :PullMtklog
if "%label%"=="mtklog1"					goto :PullMtklog inone
if "%label%"=="slog"					goto :PullSlog
if not "%label%"=="" 						call :Pull %label%					& goto:eof
goto:eof


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * pull	：h/mtklog/mtklog1/mak/build.prop/generic/[remote path]
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo pull [option]
	echo.
	echo [option]^:
	call :PrintAllInfo
	echo.
	echo    * mtklog		：抓出mtklog
	echo    * mtklog1		：抓出mtklog（合一分区）
	echo    * slog		····：抓出slog（9832）
	echo.
	echo    * h   ：本帮助
	echo 如果不带参数，显示本帮助
	echo.
	echo 配置文件： %config_file_pull%
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:PrintAllInfo
for /F "usebackq skip=1 eol=# tokens=1,2" %%a in ("%config_file_pull%") do (echo    * %%a ^: %%b)
goto:eof


:ParsePullRemote
set pullRemote=%~1
for /F "usebackq skip=1 eol=# tokens=1,2" %%a in ("%config_file_pull%") do (
  if "%pullRemote%"=="%%a" (
	  set pullRemote=%%b
	  goto:eof
	)
)
goto:eof


:ParsePullLocal
set pullLocal=%~nx1
goto:eof


:Pull
echo.
call :ParsePullRemote %~1
call :ParsePullLocal  %pullRemote%
echo %~1	%pullRemote%	%pullLocal%
set temp=%outDir%\%pullLocal%
if not "%pullLocal%"=="" (echo.) & if exist "%temp%" (
 rmdir /s/q "%temp%"
)
echo.
echo adb pull %pullRemote% %temp%
echo.
adb pull %pullRemote% %temp%
call "%~dp0ct_common.bat" Open "%temp%"
echo. & pause
goto:eof


:PullMtklog
call "%~dp0ct_common.bat" FreshTimeName
call :MakePullOutDir catlog\mtklog_%timeName%

if "%1"=="inone" (
 echo 合一
 adb pull /storage/sdcard0/mtklog %temp%
) else (
 adb pull /mnt/sdcard/mtklog 	%temp%
)
adb pull /data/anr 						%temp%\anr
adb pull /data/aee_exp 				%temp%\data_aee_exp
adb pull /data/core 					%temp%\data_core
adb pull /data/tombstones 		%temp%\tombstones
adb pull /data/system/dropbox	%temp%\dropbox
call "%~dp0ct_common.bat" Open "%temp%"
pause
goto:eof


:PullSlog
call "%~dp0ct_common.bat" FreshTimeName
call :MakePullOutDir slog\%timeName%
adb pull /data/slog %temp%
call "%~dp0ct_common.bat" Open "%temp%"
goto:eof


:MakePullOutDir
set temp=%outDir%\%~1
if exist "%temp%"	rmdir /s/q "%temp%"
mkdir "%temp%"
echo ---^> %temp%
goto:eof


