@echo off
title Ultimate Safe Game Optimizer - Max FPS (Win10/11)
color 0a

echo =====================================================
echo       ULTIMATE SAFE GAME OPTIMIZER - MAX FPS
echo =====================================================
echo.

:: ======================================================
:: Admin Check
:: ======================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Run as Administrator!
    pause
    exit /b 1
)


:: ======================================================
:: Stop unnecessary Windows services (Safe list)
:: ======================================================
echo Stopping unnecessary services...

set SERVICES=DiagTrack dmwappushservice RetailDemo PrintNotify MapsBroker XblGameSave XboxNetApiSvc WMPNetworkSvc Fax WaaSMedicSvc

for %%S in (%SERVICES%) do (
    echo Stopping %%S ...
    sc stop "%%S" >nul 2>&1
    sc config "%%S" start=disabled >nul 2>&1
)


:: ======================================================
:: Disable Tips and Notifications
:: ======================================================
echo Disabling Windows Notifications...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul


:: ======================================================
:: Improve Visual performance
:: ======================================================
echo Optimizing Visual Effects...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul


:: ======================================================
:: REAL High Performance (Correct!)
:: ======================================================
echo Enabling High Performance Mode...

powercfg -setactive scheme_min >nul || powercfg -setactive SCHEME_MIN >nul


:: ======================================================
:: Clear Temp safely
:: ======================================================
echo Clearing Temp files safely...

powershell -command "Remove-Item -Path $env:TEMP\* -Recurse -ErrorAction SilentlyContinue"
powershell -command "Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -ErrorAction SilentlyContinue"


:: ======================================================
:: Network optimization
:: ======================================================
echo Optimizing Network...

netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=enabled >nul
netsh int tcp set global congestionprovider=ctcp >nul
netsh int tcp set global ecncapability=disabled >nul


:: ======================================================
:: Game Mode + GPU Hardware Scheduling
:: ======================================================
echo Enabling Game Mode and GPU Scheduling...

reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul


:: ======================================================
:: Disable background apps (no remove system apps)
:: ======================================================
echo Disabling background apps (safe)...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul


:: ======================================================
:: Disable Search index (optional but safe)
:: ======================================================
echo Disabling Windows Search Index...

sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1


echo =====================================================
echo Optimization DONE!  Max FPS Activated.
echo PLEASE Restart Windows
echo =====================================================
pause
exit
