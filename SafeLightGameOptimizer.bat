@echo off
echo =============================================
echo       WINDOWS 11 - ULTIMATE GAME OPTIMIZER
echo =============================================
echo.

:: ====== Disable non-essential services (safe) ======
set SERVICES=SysMain WSearch DiagTrack WerSvc XboxGipSvc XblAuthManager XblGameSave TabletInputService CDPSvc CDPUserSvc MapsBroker WbioSrvc

for %%A in (%SERVICES%) do (
    sc stop "%%A" >nul 2>&1
    sc config "%%A" start= disabled >nul 2>&1
    echo [OK] Disabled %%A
)

echo.

:: ====== Temporarily stop OneDrive ======
taskkill /f /im OneDrive.exe >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "" /f >nul
echo [OK] Temporarily stopped OneDrive

echo.

:: ====== Disable animations / transparency / visual effects ======
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableBlurBehind /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 0 /f
echo [OK] Disabled animations / transparency / visual effects

echo.

:: ====== Disable Widgets / Ads / Suggestions ======
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
echo [OK] Disabled Widgets / Ads / Suggestions

echo.

:: ====== Disable Game DVR / Game Bar ======
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
echo [OK] Disabled Game DVR / Game Bar

echo.

:: ====== Low Latency / Network / Input tweaks ======
reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 1 /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d ffffffff /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
echo [OK] Applied low latency gaming tweaks

echo.

:: ====== Disable Hibernation ======
powercfg -h off
echo [OK] Disabled Hibernation

echo =============================================
echo   Ultimate optimization complete! Restart your PC for full effect
echo =============================================
pause
