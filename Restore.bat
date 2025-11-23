@echo off
echo =============================================
echo      WINDOWS 11 - RESTORE GAME OPTIMIZER
echo =============================================
echo.

:: ====== Restore previously disabled services (SAFE LIST) ======
set SERVICES=SysMain WSearch DiagTrack WerSvc XboxGipSvc XblAuthManager XblGameSave TabletInputService MapsBroker WbioSrvc

for %%A in (%SERVICES%) do (
    sc config "%%A" start= auto >nul 2>&1
    sc start "%%A" >nul 2>&1
    echo [OK] Restored %%A
)

echo.

:: ====== Restart OneDrive ======
start "" "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /f >nul
echo [OK] OneDrive restored

echo.

:: ====== Restore animations / transparency / visual effects ======
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableBlurBehind /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul
echo [OK] Restored visual effects

echo.

:: ====== Restore Widgets / Ads / Suggestions ======
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 1 /f >nul
echo [OK] Widgets / Suggestions restored

echo.

:: ====== Restore Game DVR / Game Bar ======
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 0 /f >nul
echo [OK] Game DVR restored

echo.

:: ====== Restore Network / Latency / FPS tweaks ======
reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 0 /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0 /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 20 /f >nul
echo [OK] Latency / Network settings restored

echo.

:: ====== Enable Hibernation ======
powercfg -h on >nul 2>&1
echo [OK] Hibernation re-enabled

echo =============================================
echo  Restore complete! Restart your PC to apply all settings.
echo =============================================
pause
