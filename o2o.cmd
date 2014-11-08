set "ANDROID_TOP_ROOT=D:/Android"
set "ANDROID_SDK_TOP_ROOT=D:/Android/android-studio/sdk"

set "NODEJS_TOP_ROOT=%ANDROID_TOP_ROOT%/nodejs"
set "NODEJS_ROOT=%NODEJS_TOP_ROOT%"
set "NODEJS_HOME=%NODEJS_TOP_ROOT%"
set "PATH=%NODEJS_ROOT%;%PATH%"
rem call %NODEJS_HOME%/nodevars.bat

node server.js

cmd

PAUSE
EXIT