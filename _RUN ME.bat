@Echo Off
SetLocal EnableExtensions DisableDelayedExpansion

CD /D "%~dp0."

for /f "tokens=1,2 delims==" %%a in (src/settings.ini) do (
if %%a==major set major=%%b
if %%a==minor set minor=%%b
if %%a==revision set revision=%%b
)

echo Installed Version - %major%.%minor%.%revision%

echo.

If Exist "src\ops\setupdone.txt" (
    Echo 1. Run Server
    Echo 2. Change Settings
    "%SystemRoot%\System32\choice.exe" /C 12 /M "Do you want to run the server, or change your settings"
    If Not ErrorLevel 2 (

        cls
        echo Starting Server...
        cd %~dp0
        cd src/server
        call node index.js

    ) Else (

        cls
        cd %~dp0
        cd src/settings
        call node index.js

    )
) Else (
    PushD "src\server" 2>NUL && (
        Echo Installing Modules...
        echo.
        Call npm install
        call npm install ini
        PopD
    )
    PushD "src\settings" 2>NUL && (
        Call npm install
        call npm install ini
        call npm install cli-color
        PopD
    )

    PushD "src\.keep\updater" 2>NUL && (
        Call npm install
        call npm install request-promise
        call npm install ini
        call npm install download-file-sync
        call npm install cli-color
        call npm install rimraf
        PopD
    )

    CD /D "%~dp0."

    echo setupdone>src/ops/setupdone.txt

    cls
    echo Modules installed!
    echo Rerun this file to start server or change settings.
)

Pause