@echo off
::--------------------------------------------------------------------------------------
::--------------------------------------������------------------------------------------
:start
if "%~1"=="HelpHint"	goto:HelpHint
call :Init
title %~0  "%*"
set param1=%~1
if not "%param1%"=="" set param1=%param1: =%
echo --------------------------------------------------------------------------
if "%param1%"==""				goto:Help
if "%param1%"=="h"			goto:Help
if not exist "%param1%"	goto:Help
goto:deCompile "%~1" "%~2"

:Init
call "%~dp0ct_common.bat" Init
goto:eof


:HelpHint
echo * decode��h/[apkPath] {jar}
echo * jadx  ��
goto:eof


:Help
echo %0
echo.
  cls
  echo ------------------------------------------------------------------------------
	echo.
	echo ������apk��
	echo.
	echo decode [apkpath] {jar}
	echo   ��:��������Դ       decode xx\xxx.apk
	echo   ��:��������Դ�ʹ��� decode xx\xxx.apk jar
	echo decode h
	echo.
	echo ���������������ʾ������
	echo.
  echo ------------------------------------------------------------------------------
  pause
goto:eof




:deCompile
if "%~x1"==".apk"	(
 call :deCompileApk %*
) else (
 call :traversalApks %*
)
echo.
echo ----^> %compileOutDir%
call "%~dp0ct_common.bat" Open %compileOutDir%
pause>nul
goto:eof


:deCompileApk
 echo %~dpnx1
 call :CollectData "%~dpnx1"
 call :getResourcesFromApk "%~dpnx1"
 if "%~2"=="jar" (
 	call :apkDexToJar "%~dpnx1"
 	call :viewCompiledJar
 )
 echo.
 echo.
goto:eof


:traversalApks
REM echo traversalApks:%1
REM for /r "%~1" %%i in (*.apk) do (echo %%i)
for /r "%~1" %%i in (*.apk) do (call :deCompileApk %%i %2)
goto:eof


:CollectData
set orgApk=%~1
set apkName=%~n1
set compileOutDir=%outDir%\ApkAnalysic\%apkName%
if exist "%compileOutDir%" 			rmdir /s/q "%compileOutDir%"
if not exist "%compileOutDir%" 	mkdir "%compileOutDir%"
REM call :PrintVariable
goto:eof


:PrintVariable
echo.
echo orgApk	= %orgApk%
echo apkName = %apkName%
echo outDir	= %compileOutDir%
echo.
goto:eof


:getResourcesFromApk
echo ������ͼƬ�����ֵ���Դ...
java -jar %jar_apktool%  d -f "%~1" -o "%compileOutDir%">nul
goto:eof


:apkDexToJar
echo ��ѹ��classes.dex...
"%exe_WinRAR%" x "%~1" classes.dex "%compileOutDir%"
echo ������jar...
call %bat_dex2jar% "%compileOutDir%\classes.dex" -o "%compileOutDir%\%apkName%-dex2jar.jar">nul
goto:eof


:viewCompiledJar
call "%~dp0ct_common.bat" Open "%compileOutDir%"
echo ��Դ��...
call "%~dp0ct_common.bat" Delay 2
%exe_jd_gui% "%compileOutDir%\%apkName%-dex2jar.jar">nul
goto:eof
