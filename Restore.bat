@echo off
echo =============================================
echo      WINDOWS 11 - RESTORE OPTIMIZER SETTINGS
echo =============================================
echo.

:: ====== Start previously disabled services ======
set SERVICES=SysMain WSearch DiagTrack WerSvc XboxGipSvc XblAuthManager XblGameSave TabletInputService CDPSvc CDPUserSvc MapsBroker WbioSrvc

for %%A in (%SERVICES%) do (
    sc config "%%A" start= auto >nul 2>&1
    sc start "%%A" >nul 2>&1
    echo [OK] Started %%A
)

echo.

:: ====== Restart OneDrive ======
start "" "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /f >nul
echo [OK] OneDrive restarted

echo.

:: ====== Restore animations / transparency / visual effects ======
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableBlurBehind /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul
echo [OK] Restored animations / transparency / visual effects

echo.

:: ====== Enable Widgets ======
reg add "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 1 /f >nul
echo [OK] Enabled Widgets

echo.

:: ====== Enable Game DVR / Game Bar ======
reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AudioCaptureEnabled /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 0 /f >nul
echo [OK] Restored Game DVR / Game Bar

echo.

:: ====== Restore Input Lag / FPS tweaks ======
reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 0 /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 20 /f
echo [OK] Restored default input / network settings

echo.

:: ====== Enable Hibernation ======
powercfg -h on >nul 2>&1
echo [OK] Hibernation enabled

echo =============================================
echo   Done! Please restart your PC to apply all restored settings
echo =============================================
pause
