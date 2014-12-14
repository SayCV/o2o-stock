@rem @echo off 2>con 3>&2 4>>%0
@echo off
rem if not "%~1"=="p" start /min cmd.exe /c %0 p&exit
title %~n0
cd /d %~dp0
set HOME=%cd%
set ORIGIN_HOME=%cd%

for /f "tokens=3" %%a in ('wmic os get Caption') do if /i "%%a" neq "" set MDK_WIN_VER=%%a
rem Query whether this system is 32-bit or 64-bit
rem See also: http://stackoverflow.com/a/24590583/1299302
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" |^
find /i "x86" > NUL && set arch_ext=32 || set arch_ext=64

if "%MDK_WIN_VER%"=="xp" (
	set "CHROME_TOP_ROOT=%userprofile%/Local Settings/Application Data/Chromium"
	rem set "CHROME_TOP_ROOT=C:/Program Files/Google/Chrome"
) else (
	rem set "CHROME_TOP_ROOT=%userprofile%/AppData/Local/Chromium"
	set "CHROME_TOP_ROOT=C:/Program Files (x86)/Google/Chrome"
)

set "PATH=%CHROME_TOP_ROOT%/Application;%PATH%"

set "ANDROID_TOP_ROOT=D:/Android"
set "ANDROID_SDK_TOP_ROOT=D:/Android/android-studio/sdk"

set "NODEJS_TOP_ROOT=%ANDROID_TOP_ROOT%/nodejs"
set "NODEJS_ROOT=%NODEJS_TOP_ROOT%"
set "NODEJS_HOME=%NODEJS_TOP_ROOT%"
set "PATH=%NODEJS_ROOT%;%PATH%"

if /i %MDK_WIN_VER%==xp (
	set "NODEJS_USER_DFLT_HOME=%userprofile%/Application Data"
) else (
	set "NODEJS_USER_DFLT_HOME=%userprofile%/AppData/Roaming"
)

if not exist "%NODEJS_USER_DFLT_HOME%/npm" (
	cd /d %NODEJS_USER_DFLT_HOME% && mkdir npm
)	
cd %HOME%
	
for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop"') do (
	set desk=%%j
)

if not exist localNpmInstall.stamp (
	echo call %NODEJS_HOME%/nodevars.bat >> temp.bat
	echo npm config set prefix "%NODEJS_HOME%" >> temp.bat
	call temp.bat
	del temp.bat

	call npm install
	type nul>localNpmInstall.stamp
)
if exist "%desk%\%~N0.lnk" (
	goto :ingore_shortcut
)

@echo off
SETLOCAL ENABLEDELAYEDEXPANSION
SET LinkName=%~N0
SET Esc_LinkDest=%%desk%%\!LinkName!.lnk
SET Esc_LinkTarget=%%HOME%%\%~N0.cmd
SET cSctVBS=CreateShortcut.vbs
SET LOG=".\%~N0_runtime.log"
((
  echo Set oWS = WScript.CreateObject^("WScript.Shell"^) 
  echo sLinkFile = oWS.ExpandEnvironmentStrings^("!Esc_LinkDest!"^)
  echo Set oLink = oWS.CreateShortcut^(sLinkFile^) 
  echo oLink.TargetPath = oWS.ExpandEnvironmentStrings^("!Esc_LinkTarget!"^)
  echo oLink.Save
)1>!cSctVBS!
cscript //nologo .\!cSctVBS!
DEL !cSctVBS! /f /q
)1>>!LOG! 2>>&1

:ingore_shortcut
cd %HOME%
set "URL=http://localhost:8000"

if not exist "%CHROME_TOP_ROOT%" (
	start /min iexplore "%URL%"
) else (
	start /min chrome "%URL%"
)

node server.js

if "%errorlevel%"=="0" ( 
	PAUSE
)

EXIT
