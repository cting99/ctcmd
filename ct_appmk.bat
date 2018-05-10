echo off
:start
call:Backup
call:Update
goto:eof


:Backup
setlocal enabledelayedexpansion
set /p from=Backup输入要遍历的路径：
if not exist %from% echo 路径错误！& pause & goto:eof
for /r "%from%" %%i in (Android.mk) do (
 set toDir=output%%~pi
 if not exist !toDir! mkdir !toDir!
 copy %%i output%%~pnxi
)
goto:eof


:Update
setlocal enabledelayedexpansion
set /p from=AddAttribute输入要遍历的路径：
REM set from=%toDir%
if not exist %from% echo 路径错误！& pause & goto:eof
for /r "%from%" %%a in (Android.mk) do (
 set org=%%~dpnxa
 set bak=%%~dpaAndroid.mk.bak
 if exist "!org!" (
  copy !org! !bak!
  call:addAttribute !bak! !org!
  pause
  echo.
 )
)
goto:eof


:addAttribute
 echo  >"%~2"
 for /f "delims=" %%i in ("%~1") do (
  echo.
  echo %%i
  pause
  echo %%i>>"%~2"
  if "%%i"== "LOCAL_MODULE_CLASS := APPS" (
   echo LOCAL_DEX_PREOPT := false>>"%~2"
   echo LOCAL_MODULE_CLASS := APPS
  )
 )
 del /s/q "%~1"
goto:eof


:ReadFileByLine
for /f "delims=" %%i in ("%~1") do (
 echo %%i
)
goto:eof

