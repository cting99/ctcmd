@echo off
REM --------------------------------------------------------------------------------------
REM -----------------------------------------clear----------------------------------------
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
REM echo clear: %* & pause>nul
REM echo param1:%1
REM echo param2:%2
REM echo param3:%3

set label=%~1
if not "%label%"==""	set label=%label: =%
echo --------------------------------------------------------------------------

REM TODO
if "%label%"=="gatlog"				call:ClearDir %path_gat_log%					& goto:eof
if "%label%"=="mtklog"				call:ClearDir %outDir%\catlog					& goto:eof
if "%label%"=="apkout"				call:ClearDir %outDir%\ApkAnalysic		& goto:eof
if "%label%"=="data"					call:ClearDir %outDir%\database				& goto:eof
if "%label%"=="log"						del /s/q %outDir%\log*.txt		& pause	& goto:eof
if "%label%"=="video"					del /s/q %outDir%\video*.mp4	& pause & goto:eof
if "%label%"=="all"						call:ClearDir %outDir%								& goto:eof
if "%label%"=="dump"					call:ClearDir %outDir%\dumpsys				& goto:eof
if "%label%"=="prop"					call:ClearDir %outDir%\prop						& goto:eof

call :Help
goto:eof


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * clear	：h/gatlog/mtklog/apkout/data/log/video/prop/dump/all
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo clear：
	echo.
	echo clear [option]
	echo.
	echo [option]^:
	echo.
	echo    * gatlog		：清空 %path_gat_log%
	echo    * mtklog		：清空 %outDir%\catlog
	echo    * decode		：清空 %outDir%\apkdecode
	echo    * data		：清空 %outDir%\database
	echo    * log		：清空 %outDir%\log*.txt
	echo    * video		：清空 %outDir%\video*.mp4
	echo    * prop		：清空 %outDir%\prop
	echo    * dump		：清空 %outDir%\dumpsys
	echo    * all		：清空 %outDir%
	echo.
	echo    * h   ：本帮助
	echo 如果不带参数，显示本帮助
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:ClearDir
set temp=%~1
if not exist "%temp%" (
 echo 没有目录 %temp%
 pause>nul
 goto:eof
)
echo 开始删除文件夹...
for /f "usebackq" %%i in (` dir "%temp%" /AD /b`) do (
 echo   %temp%\%%~i
 rmdir /s/q "%temp%\%%~i"
)
echo.
echo 开始删除文件...
for /f "usebackq" %%i in (` dir "%temp%" /A-D /b`) do (
 del /s/q "%temp%\%%~i*"
)
echo.
pause
goto:eof
