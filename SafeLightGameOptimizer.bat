@echo off
title WINDOWS 11 - ULTIMATE GAME OPTIMIZER (SAFE)
color 0a

echo =====================================================
echo          WINDOWS 11 - ULTIMATE GAME OPTIMIZER
echo =====================================================
echo.

set /p CONFIRM=Do you want to apply the gaming optimization tweaks? (Y/N): 

if /i "%CONFIRM%" NEQ "Y" (
    echo.
    echo Optimization cancelled.
    pause
    exit
)

echo.
echo =============== APPLYING OPTIMIZATION... ===============

:: ---------------------------------------------------------
:: Disable NON-essential services (safe for gaming)
:: ---------------------------------------------------------
echo [1/7] Disabling non-essential services...

set SERVICES=SysMain WSearch DiagTrack WerSvc XboxGipSvc XblAuthManager XblGameSave TabletInputService MapsBroker WbioSrvc

for %%A in (%SERVICES%) do (
    sc stop "%%A" >nul 2>&1
    sc config "%%A" start= disabled >nul 2>&1
)

echo     -> Services disabled


:: ---------------------------------------------------------
:: Stop OneDrive (temporary)
:: ---------------------------------------------------------
echo [2/7] Stopping OneDrive...

taskkill /f /im OneDrive.exe >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /f >nul 2>&1

echo     -> OneDrive stopped


:: ---------------------------------------------------------
:: Disable animations / transparency
:: ---------------------------------------------------------
echo [3/7] Disabling visuals for max FPS...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableBlurBehind /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f >nul

echo     -> Animations disabled


:: ---------------------------------------------------------
:: Disable ads / widgets / suggestions
:: ---------------------------------------------------------
echo [4/7] Removing ads & widgets...

reg add "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f >nul

echo     -> Widgets disabled


:: ---------------------------------------------------------
:: Disable Game DVR / Game Bar for FPS & latency
:: ---------------------------------------------------------
echo [5/7] Applying Xbox/GameDVR tweaks...

reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f >nul

echo     -> Game DVR disabled


:: ---------------------------------------------------------
:: Ultra low latency & network tweaks
:: ---------------------------------------------------------
echo [6/7] Applying low latency tweaks...

reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d ffffffff /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul

echo     -> Low latency applied


:: ---------------------------------------------------------
:: Disable Hibernate
:: ---------------------------------------------------------
echo [7/7] Disabling Hibernation...

powercfg -h off >nul 2>&1

echo     -> Hibernation disabled


echo.
echo =====================================================
echo       OPTIMIZATION COMPLETE! RESTART REQUIRED
echo =====================================================
pause
