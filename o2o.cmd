@rem @echo off 2>con 3>&2 4>>%0
@echo off
if not "%~1"=="p" start /min cmd.exe /c %0 p&exit
title %~n0
cd /d %~dp0
set HOME=%cd%
set ORIGIN_HOME=%cd%

set "CHROME_TOP_ROOT_XP=%userprofile%/AppData/Local/Chromium"
set "CHROME_TOP_ROOT_WIN7=%userprofile%/Local Settings/Application Data/Chromium"
set "PATH=%CHROME_TOP_ROOT_XP%/Application;%PATH%"
set "PATH=%CHROME_TOP_ROOT_WIN7%/Application;%PATH%"

set "ANDROID_TOP_ROOT=D:/Android"
set "ANDROID_SDK_TOP_ROOT=D:/Android/android-studio/sdk"

set "NODEJS_TOP_ROOT=%ANDROID_TOP_ROOT%/nodejs"
set "NODEJS_ROOT=%NODEJS_TOP_ROOT%"
set "NODEJS_HOME=%NODEJS_TOP_ROOT%"
set "PATH=%NODEJS_ROOT%;%PATH%"
rem call %NODEJS_HOME%/nodevars.bat

if not exist localNpmInstall.stamp (
	call npm install
	type nul>localNpmInstall.stamp
)
cd %HOME%

set "URL=http://localhost:3000"

if not exist "%CHROME_TOP_ROOT_XP%" (
	if not exist "%CHROME_TOP_ROOT_WIN7%" (
		start /min iexplore "%URL%"
	)
) else (
	start /min chrome "%URL%"
)

node server.js

PAUSE
EXIT