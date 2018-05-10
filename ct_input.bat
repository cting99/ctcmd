@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------intput-------------------------------------------
REM
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
if "%~1"=="HelpHint"	goto:HelpHint
echo.
call :Init
title %~0  "%*"
REM echo param1:%1
REM echo param2:%2
REM echo param3:%3

set param1=%~1
if not "%param1%"==""	set param1=%param1: =%
echo --------------------------------------------------------------------------
set inputParam=%*
if "%param1%"=="text"			call:inputText "%inputParam:~5%"		& goto:eof
if "%param1%"=="key"			call:inputKey "%inputParam:~4%"			& goto:eof
if "%param1%"=="genkey"		call:genericKeys "%~2"							& goto:eof
call :Help
goto:eof


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * key	：-h/-v/[keyCode]
REM echo * prop	：  [prop keyword]/:build/:mak
goto:eof


:CommonKeys
echo 常用key...
findStr /i "KEYCODE_POWER KEYCODE_MENU KEYCODE_BACK= KEYCODE_VOLUME KEYCODE_CAMERA" "%config_file_keys%"
echo.
pause
goto:eof


:View
call "%~dp0ct_common.bat" Open "%config_file_keys%"
pause
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo.
	echo input [字符串]
	echo key -h   ：本帮助
	echo key -v   ：查看keyCode.txt
	echo key [keyCode]：模拟按键
	echo.
	echo 如果不带参数，显示本帮助
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:PrintAllInfo
for /F "usebackq skip=1 eol=# tokens=1,3" %%a in ("%config_file_keys%") do (echo    * %%a ^= %%b)
goto:eof


:inputText
echo adb shell input text %~1
adb shell input text %~1
REM pause>nul
goto:eof


:inputKey
if "%~1"==""		goto:CommonKeys
if "%~1"=="-h"	goto:Help
if "%~1"=="-v"	goto:View
echo adb shell input keyevent %~1
adb shell input keyevent %~1
if "%~1"==""	(
 call:PrintAllInfo
 pause>nul
)
goto:eof


:getKeyName
set keyName=%~1
if "!keyName:~0,8!"=="KEYCODE_" (
REM echo keyName="!keyName!" 
 set keyName=!keyName: =!
 set keyName=!keyName:	=!
 if "%~2"=="short" set keyName=!keyName:~8!
REM echo keyName="!keyName!"
)
goto:eof


:genericKeys
@echo off
if "%~1"=="sample"	goto:genericSmaple
setlocal enabledelayedexpansion
REM public static final int KEYCODE_UNKNOWN         = 0;
echo.>"%config_file_keys%"
for /f "usebackq eol=* tokens=1,2,3,4,5,6 delims=;= " %%a in ("%config_file_keys_org%") do (
 call :getKeyName %%e
 set keyCode=
 if "%%a %%b %%c %%d !keyName:~0,8!"=="public static final int KEYCODE_" (  
  set keyCode=%%f
  echo !keyName! = !keycode!
  echo !keyName! !keycode!>>"%config_file_keys%"
 )
)
call "%~dp0ct_common.bat" Open "%config_file_keys%"
pause
goto:eof


:genericSmaple
@echo off
setlocal enabledelayedexpansion
REM public static final int KEYCODE_UNKNOWN = 0;
for /f "usebackq eol=* tokens=1,2,3,4,5,6 delims=;= " %%a in ("%config_file_keys_sample%") do (
 echo token1="%%a"
 echo token2="%%b"
 echo token3="%%c"
 echo token4="%%d"
 echo token5="%%e" 
 call :getKeyName %%e
 echo token5="!keyName!"
 set keyCode=%%f
 echo token6="!keyCode!"
 echo.
 echo.
)
pause
goto:eof


