@rem @echo off 2>con 3>&2 4>>%0
@echo off
rem if not "%~1"=="p" start /min cmd.exe /c %0 p&exit
title %~n0
cd /d %~dp0
set HOME=%cd%
set ORIGIN_HOME=%cd%

set "CHROME_TOP_ROOT_XP=%userprofile%/AppData/Local/Chromium"
set "CHROME_TOP_ROOT_WIN7_XP=%userprofile%/Local Settings/Application Data/Chromium"
set "PATH=%CHROME_TOP_ROOT_XP%/Application;%PATH%"
set "PATH=%CHROME_TOP_ROOT_WIN7_XP%/Application;%PATH%"

set "ANDROID_TOP_ROOT=D:/Android"
set "ANDROID_SDK_TOP_ROOT=D:/Android/android-studio/sdk"

set "NODEJS_TOP_ROOT=%ANDROID_TOP_ROOT%/nodejs"
set "NODEJS_ROOT=%NODEJS_TOP_ROOT%"
set "NODEJS_HOME=%NODEJS_TOP_ROOT%"
set "PATH=%NODEJS_ROOT%;%PATH%"

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

if not exist "%CHROME_TOP_ROOT_WIN7_XP%" (
	start /min iexplore "%URL%"
) else (
	start /min chrome "%URL%"
)

node server.js

PAUSE
EXIT