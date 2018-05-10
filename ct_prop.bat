@echo off
REM --------------------------------------------------------------------------------------
REM -------------------------------------prop---------------------------------------------
REM
REM		[prop keyword]
REM		:build
REM		:mak
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
if "%param1%"=="h"			goto:Help
if "%param1%"==""				goto:getAll
if "%param1%"==":all"		goto:getAllprops
if "%param1%"==":build"	goto:getBuildpropfile
if "%param1%"==":mak"		goto:getProjectConfig
call :searchPropFromAll %param1%
goto:eof


:Init
call "%~dp0ct_common.bat" Init
set prop_dir=%outDir%\prop
set file_name_buildprop=build.prop
set file_name_allprop=all.prop
set file_name_mak=ProjectConfig.mk
goto:eof


:HelpHint
echo * prop	：h/:all/:build/:mak/[keyword]
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo.
	echo prop [option]
	echo.
	echo [option]^:
	echo.
	echo    * :all	：抓出 当前所有properties
	echo    * :build	：抓出 /system/build.prop
	echo    * :mak	：抓出 /system/data/misc/ProjectConfig.mk
	echo    * :[keyword]	：在所有properties中搜索keyword
	echo.
	echo    * h   	：本帮助
	echo 如果不带参数，抓出all properties, build.prop, ProjectConfig.mk
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof


:MakeSurePropDirExit
REM param,file name
if not exist "%prop_dir%" mkdir "%prop_dir%"
if not "%~1"=="" (
 set out_file=%prop_dir%\%~1
)
goto:eof


:PullOut
REM param1,echo 
REM param2,file name
REM param3,command
echo %~1
call :MakeSurePropDirExit %~2
%~3  "%out_file%"
call "%~dp0ct_common.bat" Open "%out_file%"
echo.
pause
goto:eof


:getAllprops
call :PullOut "All properties..." "%file_name_allprop%" "adb shell getprop >"
goto:eof


:getBuildpropfile
call :PullOut "/system/build.prop..." "%file_name_buildprop%" "adb pull /system/build.prop"
goto:eof


:searchPropFromAll
echo adb shell getprop^|find /i "%1"
echo.
adb shell getprop|find /i "%1"
echo.
echo prop搜索结束。
pause>nul
goto:eof


:getProjectConfig
call :PullOut "ProjectConfig.mk..." "%file_name_mak%" "adb pull /system/data/misc/ProjectConfig.mk"
goto:eof


:getAll
call :MakeSurePropDirExit
echo adb pull /system/data/misc/ProjectConfig.mk
adb pull /system/data/misc/ProjectConfig.mk "%prop_dir%\%file_name_mak%"
echo adb pull /system/build.prop
adb pull /system/build.prop 								"%prop_dir%\%file_name_buildprop%"
echo adb shell getprop
adb shell getprop 													> "%prop_dir%\%file_name_allprop%"
call "%~dp0ct_common.bat" Open "%prop_dir%"
pause
goto:eof