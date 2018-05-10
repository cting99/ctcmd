@echo off
REM --------------------------------------------------------------------------------------
REM ---------------------------------Common functions-------------------------------------
REM		Init											-p
REM		FreshTimeName
REM		Delay
REM		Edit
REM --------------------------------------------------------------------------------------
REM --------------------------------------------------------------------------------------


:start
REM echo common: %* & pause>nul
call :%*
goto:eof


:Init
set outDir=%~dp0output
if not exist "%outDir%" mkdir "%outDir%"

set out_file_analysis=%outDir%\analysis.txt

set path_gat_log=E:\SPL\cting\GAT_Log

REM  config files
set config_file_apps=%~dp0config\config_apps.txt
set config_file_pull=%~dp0config\config_pull.txt
set config_file_keys_org=%~dp0config\KeyEvent.java
set config_file_keys_sample=%~dp0config\KeyEventSampleTest.java
set config_file_keys=%~dp0config\KeyEvent.txt

REM  常用工具
REM set exe_GAT=%~dp0\Tools\GAT_v3.1716.3(Official)\gat-win32-x86_64-3\modules\monitor\GAT.exe
REM set exe_E_Consulter=%~dp0\Tools\E-Consulter\E-Consulter.exe
REM set dir_AAPT=D:\Android\sdk\build-tools\24.0.2

REM 编辑工具
set exe_notepad=%windir%\system32\notepad.exe
set exe_UltraEdit=C:\Program Files (x86)\IDM Computer Solutions\UltraEdit\uedit32.exe
set exe_notepadplus=D:\常用应用\Notepad++\notepad++.exe
if exist %exe_notepad% (set exe_txt=%exe_notepad%)
if exist %exe_UltraEdit% (set exe_txt="%exe_UltraEdit%)  
if exist %exe_notepadplus% (set exe_txt=%exe_notepadplus%)

REM  反编译工具
set exe_WinRAR=C:\Program Files\WinRAR\WinRAR.exe
set jar_apktool=%~dp0decompile\apktool.2.1.0\apktool_2.1.0.jar
set bat_dex2jar=%~dp0decompile\dex2jar-2.1-SNAPSHOT\d2j-dex2jar.bat
set exe_jd_gui=%~dp0decompile\jd-gui-windows-1.4.0\jd-gui.exe
set jadx=%~dp0decompile\jadx-0.6.1\bin\jadx-gui.bat

if "%1"=="-p" call :PrintParam & echo wait in common.init & pause>nul
goto:eof



:PrintParam
echo.
echo outDir=%outDir%
echo config_file_apps=%config_file_apps%
pause
echo.
goto:eof



:FreshTimeName
set timeName=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set timeName=%timeName: =%
echo common: timeName=%timeName%
goto:eof



:ParsePath
REM /system/build.prop								build.prop
REM /system/priv-app/Contacts/Contacts.apk			Contacts.apk
REM /system/priv-app/Contacts/						Contacts
REM /system/priv-app/Contacts						Contacts
set tempPath=%~1
if "%tempPath%"==""	(
 set tempName=
 goto:eof
)
if "%tempPath:~-1%"=="/" 	set tempPath=%tempPath:~0,-1%
call:GetName %tempPath%
goto:eof


:GetName
set tempName=%~nx1
echo %~1 ^: %tempName%
goto:eof


:Delay
REM  param second
@echo off
echo.
REM echo 延时前：%time%
ping /n %1 127.0.0.1 >nul
REM echo 延时后：%time%
goto:eof


:Edit
if not exist "%~1" echo 路径有误："%~1" & pause & goto:eof
REM echo "%exe_txt%" "%~1" & pause & goto:eof
"%exe_txt%" "%~1"
goto:eof


:Open
if exist "%~1" (
 start "" "%~1"
 echo ---^> %~1
)
goto:eof


