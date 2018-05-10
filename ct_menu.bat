@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------------menu---------------------------------------
REM
REM		h
REM		s
REM		edit
REM		gat
REM		econ
REM		aapt
REM		decode
REM		-print  输出ct_common.bat里面的变量
REM
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------

:start
echo.
goto:Help


:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
REM echo * gat	：GAT
REM echo * econ	：E-Consulter
echo * edit	：[filePath]
goto:eof


:Help
cls
call :Init
title %~0
echo --------------------------------------------------------------------------
echo.
call :HelpHint
call "%~dp0ct_clear.bat" 			HelpHint
echo.
echo mtklog	直接开启mtklog
call "%~dp0ct_adb.bat" 				HelpHint
call "%~dp0ct_prop.bat" 			HelpHint
call "%~dp0ct_app.bat" 				HelpHint
call "%~dp0ct_pull.bat" 			HelpHint
call "%~dp0ct_pull_data.bat" 	HelpHint
call "%~dp0ct_dumpsys.bat" 		HelpHint
call "%~dp0ct_input.bat"	 		HelpHint
echo.
echo 本地apk分析
REM call "%~dp0ct_aapt.bat" 			HelpHint
call "%~dp0ct_decompile.bat"	HelpHint
echo.
echo 测试广播"adb shell am broadcast -a ct.intent.action.test"
echo 测试act "adb shell am start -n pkgName/.actName"
echo 测试电量"adb shell dumpsys battery set level 16"

echo --------------------------------------------------------------------------
echo %date% %time%
echo.
set inputs=
set /p inputs=输入：
echo.

if "%inputs%"=="mtklog" (
adb shell am broadcast -a com.mediatek.mtklogger.ADB_CMD -e cmd_name start--ei cmd_target 23
pause
goto:Help
)
if "%inputs%"=="q"						goto:eof
if "%inputs:~0,4%"=="edit"		call :pick_%inputs%															& goto:Help
if "%inputs:~0,4%"=="open"		call :pick_o %inputs:~4%												& goto:Help
if "%inputs%"=="s"		 				call :pick_%inputs%															& goto:Help
if "%inputs%"=="h"		 				call :pick_%inputs%															& goto:Help
if "%inputs%"=="-print"		 		call :pick_%inputs%															& goto:Help
if "%inputs%"=="gat"		 			call :pick_%inputs%															& goto:Help
if "%inputs%"=="econ"		 			call :pick_%inputs%															& goto:Help
if "%inputs:~0,5%"=="clear"		call "%~dp0ct_clear.bat" 			%inputs:~5%			  & goto:Help

if "%inputs:~0,4%"=="aapt"		call "%~dp0ct_aapt.bat"				%inputs:~4%			  & goto:Help
if "%inputs:~0,3%"=="app"			call "%~dp0ct_app.bat" 				%inputs:~3%			  & goto:Help
if "%inputs:~0,3%"=="adb"			call "%~dp0ct_adb.bat" 				%inputs:~3%				& goto:Help
if "%inputs:~0,4%"=="prop"		call "%~dp0ct_prop.bat"				%inputs:~4%				& goto:Help
if "%inputs:~0,6%"=="decode"	call "%~dp0ct_decompile.bat" 	%inputs:~6%			  & goto:Help
if "%inputs:~0,4%"=="jadx"	call :pick_%inputs%			  & goto:Help
if "%inputs:~0,3%"=="sys"			call "%~dp0ct_dumpsys.bat"		%inputs:~3%				& goto:Help
if "%inputs:~0,4%"=="data"		call "%~dp0ct_pull_data.bat"	%inputs:~4%				& goto:Help
if "%inputs:~0,4%"=="pull"		call "%~dp0ct_pull.bat" 			%inputs:~4%			  & goto:Help
if "%inputs:~0,3%"=="key"			call "%~dp0ct_input.bat"			key %inputs:~3%		& goto:Help
if "%inputs:~0,4%"=="text"		call "%~dp0ct_input.bat"			text %inputs:~4%	& goto:Help

REM for keycode
if "%inputs:~0,7%"=="genkey"	call "%~dp0ct_input.bat" genkey %inputs:~7%		& goto:Help

goto:doOrgCmd


:doOrgCmd
echo %inputs%
%inputs%
@echo on
pause
@echo off
goto:Help


:pick_h
goto:eof


:pick_s
start
goto:eof

:pick_o
REM echo "%*"
start "" "%*"
goto:eof


:pick_edit
REM echo call "%~dp0ct_common.bat" Edit "%~1"
call "%~dp0ct_common.bat" Edit "%~1"
REM pause
goto:eof


:pick_-print
call "%~dp0ct_common.bat" Init -p
goto:eof



::--------------------------------------------------------------------------------------
::-------------------------------------PC工具-------------------------------------------

:pick_gat
start %exe_GAT%
goto:eof


:pick_econ
start %exe_E_Consulter%
goto:eof

:pick_jadx
start %jadx%
goto:eof

