@echo off
setlocal
rem Let Windows PowerShell load its own built-in module paths.
set "PSModulePath="
set "LAUNCHER_SCRIPT=%~dp0src\ChatGPT-Codex-Selector-v0.3.ps1"
if not exist "%LAUNCHER_SCRIPT%" (
    echo Launcher source is missing. Extract the complete ZIP before running.
    pause
    exit /b 1
)
start "" "%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -STA -WindowStyle Hidden -ExecutionPolicy Bypass -File "%LAUNCHER_SCRIPT%"
exit /b
