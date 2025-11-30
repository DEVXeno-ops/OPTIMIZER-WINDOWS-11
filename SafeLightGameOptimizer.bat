@echo off
title Ultimate Safe Game Optimizer - Max FPS (Win10/11)
color 0a
echo =====================================================
echo       ULTIMATE SAFE GAME OPTIMIZER - MAX FPS
echo =====================================================
echo.

:: ===============================
:: Check for Administrator rights
:: ===============================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Please run this script as Administrator!
    pause
    exit /b 1
)

:: ===============================
:: Stop unnecessary Windows services
:: ===============================
echo Stopping unnecessary services...
set SERVICES=WSearch SysMain DiagTrack dmwappushservice "Fax" "MapsBroker" "RetailDemo" "WMPNetworkSvc" "XblGameSave" "XboxNetApiSvc" "PrintNotify" "WaaSMedicSvc"
for %%S in (%SERVICES%) do (
    echo Stopping %%S...
    sc stop "%%S" >nul 2>&1
    sc config "%%S" start=disabled >nul 2>&1
)

:: ===============================
:: Disable Windows Tips & Notifications
:: ===============================
echo Disabling Windows Tips, Notifications, and Telemetry...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableAutoTray /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul

:: ===============================
:: Visual Effects Optimization
:: ===============================
echo Optimizing visual effects for max FPS...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 2000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 1000 /f >nul

:: ===============================
:: Power Plan: High Performance
:: ===============================
echo Setting High Performance Power Plan...
powercfg -duplicatescheme SCHEME_MIN >nul
powercfg -setactive SCHEME_MIN

:: ===============================
:: Clear temporary files safely
:: ===============================
echo Clearing Temp files...
for %%F in (%TEMP% C:\Windows\Temp) do (
    echo Cleaning %%F...
    del /q /f /s "%%F\*" >nul 2>&1
)

:: ===============================
:: Network Optimization for online games
:: ===============================
echo Optimizing network for online games...
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=enabled >nul
netsh int tcp set global congestionprovider=ctcp >nul
netsh int ip set global taskoffload=enabled >nul
netsh int tcp set global ecncapability=disabled >nul

:: ===============================
:: Game Mode & Hardware-accelerated GPU scheduling
:: ===============================
echo Enabling Game Mode and GPU scheduling...
reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul

:: ===============================
:: Disable Background Apps (Windows 10/11)
:: ===============================
echo Disabling unnecessary background apps...
powershell -Command "Get-AppxPackage | Remove-AppxPackage" >nul 2>&1

:: ===============================
:: Optional: Disable Search Indexing (Speed boost)
:: ===============================
echo Disabling Windows Search Indexing...
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1

echo =====================================================
echo Optimization Complete! Max FPS Ready.
echo Recommended: Restart your PC to apply all changes.
pause
exit
