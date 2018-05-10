@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------demo---------------------------------------------
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
REM echo demo: %* & pause>nul
REM echo param1:%1
REM echo param2:%2
REM echo param3:%3

set param1=%~1
if not "%param1%"==""	set param1=%param1: =%
echo --------------------------------------------------------------------------
if "%param1%"==""				goto:Help
if "%param1%"=="h"			goto:Help

REM TODO
if "%label%"==""				call :Help																& goto:eof

call :Help
goto:eof


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * demo	：h/
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo xxxxxx：
	echo.
	echo xxx [option]
	echo.
	echo [option]^:
	echo.
	echo    * mtklog		：抓出mtklog
	echo.
	echo    * h   ：本帮助
	echo 如果不带参数，显示本帮助
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof



:UpdateFileAndDirParam
set fileOption=%1
set filePath=%2
if "%3"=="-print"
	echo.
	echo fileOption	%fileOption%
	echo filePath		%filePath%
	echo.
goto:eof

:show_out_dirs
for /d %%i in (%outDir%\*) do (
 echo   %%~ni		：%%~fi
)
goto:eof

:show_out_all
for /f "usebackq" %%i in (` dir %outDir% /b`) do (
 echo   %%~ni		：%%~fi
)
goto:eof





