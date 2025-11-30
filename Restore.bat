@echo off
title Restore Windows Settings - Game Optimizer
color 0a
echo =====================================================
echo        RESTORE WINDOWS SETTINGS
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
:: Restore stopped services
:: ===============================
echo Restoring Windows services...
set SERVICES=WSearch SysMain DiagTrack dmwappushservice "Fax" "MapsBroker" "RetailDemo" "WMPNetworkSvc" "XblGameSave" "XboxNetApiSvc" "PrintNotify" "WaaSMedicSvc"
for %%S in (%SERVICES%) do (
    echo Starting %%S...
    sc config "%%S" start=auto >nul 2>&1
    sc start "%%S" >nul 2>&1
)

:: ===============================
:: Restore Windows Tips & Notifications
:: ===============================
echo Restoring Windows Tips & Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v EnableAutoTray /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f >nul

:: ===============================
:: Restore Visual Effects
:: ===============================
echo Restoring Visual Effects to default...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul
reg add "HKCU\Control Panel\Desktop" /v WaitToKillAppTimeout /t REG_SZ /d 5000 /f >nul
reg add "HKCU\Control Panel\Desktop" /v HungAppTimeout /t REG_SZ /d 5000 /f >nul

:: ===============================
:: Restore Power Plan
:: ===============================
echo Restoring Balanced Power Plan...
powercfg -setactive SCHEME_BALANCED

:: ===============================
:: Restore Network Settings
:: ===============================
echo Restoring Network settings...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global chimney=default >nul
netsh int tcp set global congestionprovider=none >nul
netsh int ip set global taskoffload=default >nul
netsh int tcp set global ecncapability=default >nul

:: ===============================
:: Restore Game Mode & GPU scheduling
:: ===============================
echo Restoring Game Mode and GPU scheduling...
reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul

:: ===============================
:: Enable Background Apps (Windows 10/11)
:: ===============================
echo Restoring background apps...
powershell -Command "Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register '$($_.InstallLocation)\AppXManifest.xml'}" >nul 2>&1

:: ===============================
:: Restore Search Indexing
:: ===============================
echo Restoring Windows Search Indexing...
sc config "WSearch" start=delayed-auto >nul
sc start "WSearch" >nul

echo =====================================================
echo Restoration Complete! Your system is back to default.
echo Recommended: Restart your PC to apply all changes.
pause
exit
