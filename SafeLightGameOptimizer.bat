@echo off
title Ultimate Safe Game Optimizer - MAX FPS (2025)
color 0a

echo =====================================================
echo          ULTIMATE SAFE GAME OPTIMIZER
echo =====================================================
echo.

:: Admin
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Please run as Administrator!
    pause
    exit /b 1
)

echo ========================
echo Optimizing Performance...
echo ========================


:: ==== STOP SERVICES ====
for %%S in (
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
    sc stop "%%S" >nul 2>&1
    sc config "%%S" start=disabled >nul 2>&1
)


:: ==== DISABLE TOAST ====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f >nul


:: ==== VISUAL ====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul


:: ==== GAME MODE ====
reg add "HKLM\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul


:: ==== GPU HARDWARE SCHEDULING ====
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f >nul


:: ==== GAME DVR & BACKGROUND CAPTURE ====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul


:: ==== HIGH PERFORMANCE ====
powercfg -setactive scheme_min >nul || powercfg -setactive SCHEME_MIN >nul


:: ==== CLEAN TEMP ====
powershell -command "Remove-Item -Path $env:TEMP\* -Recurse -ErrorAction SilentlyContinue"
powershell -command "Remove-Item -Path 'C:\Windows\Temp\*' -Recurse -ErrorAction SilentlyContinue"


:: ==== NETWORK ====
netsh int tcp set global autotuninglevel=disabled >nul
netsh int tcp set global chimney=enabled >nul
netsh int tcp set global congestionprovider=ctcp >nul
netsh int tcp set global ecncapability=disabled >nul
netsh int ip set global taskoffload=enabled >nul


:: ==== BACKGROUND APPS ====
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f >nul


:: ==== DISABLE SEARCH INDEX ====
sc stop "WSearch" >nul 2>&1
sc config "WSearch" start=disabled >nul 2>&1


:: ==== GPU Priority ====
reg add "HKLM\SOFTWARE\Microsoft\DirectDraw" /v EmulationOnly /t REG_DWORD /d 0 /f >nul


:: ==== VRAM Prioritization ====
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 10 /f >nul


echo.
echo ================================
echo Optimization Finished!
echo Restart Windows for best results
echo ================================
pause
exit
