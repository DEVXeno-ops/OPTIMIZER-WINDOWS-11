@echo off
title Windows Restore - Game Optimizer (FULL RESTORE 2025)
color 0a

echo =====================================================
echo       RESTORING WINDOWS SETTINGS TO DEFAULT
echo =====================================================
echo.

:: ===== Admin Check =====
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Run as Administrator!
    pause
    exit /b 1
)


:: ===== Windows services =====
echo Restoring Windows Services...
for %%S in (
    WSearch
    SysMain
    DiagTrack
    dmwappushservice
    RetailDemo
    PrintNotify
    MapsBroker
    XblGameSave
    XboxNetApiSvc
    WMPNetworkSvc
    Fax
    WaaSMedicSvc
) do (
    sc config "%%S" start=delayed-auto >nul 2>&1
    sc start "%%S" >nul 2>&1
)


:: ===== Notifications =====
echo Restoring Notifications...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f >nul


:: ===== Visual Effects =====
echo Restoring Visual Effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul


:: ===== Power Settings =====
echo Restoring Balanced Power Plan...
powercfg -setactive SCHEME_BALANCED >nul


:: ===== Network Stack =====
echo Restoring Network settings...
netsh int tcp set global autotuninglevel=normal >nul
netsh int tcp set global chimney=default >nul
netsh int tcp set global congestionprovider=none >nul
netsh int ip set global taskoffload=default >nul
netsh int tcp set global ecncapability=default >nul


:: ===== Game Mode =====
echo Restoring Game Mode settings...
reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul


:: ===== GPU HW Scheduling (default) =====
echo Restoring GPU hardware scheduling...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 1 /f >nul


:: ===== Game DVR =====
echo Restoring Game DVR settings...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul


:: ===== Background Apps =====
echo Restoring Background Apps...
powershell -Command "Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}" >nul


:: ===== Search Indexing =====
echo Restoring Search Indexing...
sc config "WSearch" start=delayed-auto >nul
sc start "WSearch" >nul


:: ===== Delivery Optimization =====
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f >nul


:: ===== Restore Telemetry (Required for Windows Update) =====
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 1 /f >nul


echo =====================================================
echo RESTORE COMPLETE! System reverted to default settings!
echo RECOMMENDED: Restart Windows
echo =====================================================
pause
exit
