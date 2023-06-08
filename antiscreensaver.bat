@echo off
setlocal

REM Function to prevent screensaver and display from turning off
:prevent_screensaver
mode con: cols=50 lines=5
cls

REM Prompt for duration in minutes
set /P duration="Enter duration in minutes (0 for indefinite): "

REM Validate the duration input
echo %duration% | findstr /r "^[0-9]*$" >nul
if errorlevel 1 (
    echo Invalid duration. Please enter a valid number of minutes.
    timeout /t 2 >nul
    goto prevent_screensaver
)

REM Convert duration to seconds
set /a durationInSeconds=%duration% * 60

REM Start the screensaver and display prevention loop
echo Screensaver and display prevention started for %duration% minutes.
echo Press any key to stop.

REM Set screensaver and display prevention loop
set "stop="

REM Loop until the duration has elapsed or user interrupts
for /l %%i in (1,1,%durationInSeconds%) do (
    if defined stop (
        goto end_prevent_screensaver
    )

    REM Simulate user activity by pressing the "ESC" key
    powershell -Command "(New-Object -ComObject 'WScript.Shell').SendKeys('{ESC}')"

    REM Prevent display from turning off
    powershell -Command "Add-Type -TypeDefinition 'using System; public class P { [System.Runtime.InteropServices.DllImport(\"user32.dll\")] public static extern int SendMessage(int hWnd, int hMsg, int wParam, int lParam); }'; [P]::SendMessage(-1, 0x0112, 0xF170, 2)"

    timeout /t 1 >nul
)

:end_prevent_screensaver
REM Allow screensaver and display to activate
mode con: cols=50 lines=1
cls
echo Screensaver and display prevention stopped.
timeout /t 2 >nul
exit /b

REM Press any key to stop screensaver and display prevention
echo Press any key to stop screensaver and display prevention.
pause >nul
set "stop=1"
goto prevent_screensaver