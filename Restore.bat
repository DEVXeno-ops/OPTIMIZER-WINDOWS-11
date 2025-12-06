@echo off
title Windows Restore - Game Optimizer
color 0a
echo =====================================================
echo        RESTORING WINDOWS SETTINGS (Default)
echo =====================================================
echo.

:: ===============================
:: Check for Administrator rights
:: ===============================
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Run as Administrator!
    pause
    exit /b 1
)

echo ===============================
echo Restoring Windows Services
echo ===============================
set SERVICES=WSearch SysMain DiagTrack dmwappushservice Fax MapsBroker RetailDemo WMPNetworkSvc XblGameSave XboxNetApiSvc PrintNotify WaaSMedicSvc

for %%S in (%SERVICES%) do (
    echo Restoring %%S...
    sc config "%%S" start=delayed-auto >nul 2>&1
    sc start "%%S" >nul 2>&1
)

echo ===============================
echo Restoring Notifications
echo ===============================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f >nul

echo ===============================
echo Restore Visual Effects
echo ===============================
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul

echo ===============================
echo Restore Power Plan
echo ===============================
powercfg -setactive SCHEME_BALANCED >nul

echo ===============================
echo Restore Networking
echo ===============================
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global chimney=default >nul
netsh int tcp set global congestionprovider=none >nul
netsh int ip set global taskoffload=default >nul
netsh int tcp set global ecncapability=default >nul

echo ===============================
echo Restore Game Mode
echo ===============================
reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul

echo Enable Hardware GPU Scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f >nul

echo Restore GameDVR...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul

echo ===============================
echo Restore Background apps
echo ===============================
powershell -Command "Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul 2>&1

echo ===============================
echo Restore Search Indexing
echo ===============================
sc config "WSearch" start=delayed-auto >nul
sc start "WSearch" >nul

echo =====================================================
echo DONE! Windows restored to default settings!
echo Restart recommended!
pause
exit
