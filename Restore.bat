@echo off
title WINDOWS 11 - SAFE RESTORE
color 0a

echo =====================================================
echo        WINDOWS 11 RESTORE (SAFE + YES/NO)
echo =====================================================

set /p USERCHOICE=Do you want to restore all settings to default? (Y/N): 

if /i "%USERCHOICE%" NEQ "Y" (
    echo.
    echo Restore cancelled.
    pause
    exit
)

echo.
echo ============== RESTORING WINDOWS... ===============

:: -----------------------------------------------------
:: Restore important services
:: -----------------------------------------------------
echo [1/6] Restoring Windows services...

set SERVICES=SysMain WSearch DiagTrack WerSvc XboxGipSvc XblAuthManager XblGameSave TabletInputService CDPSvc CDPUserSvc MapsBroker WbioSrvc

for %%A in (%SERVICES%) do (
    sc config "%%A" start= auto >nul 2>&1
    sc start "%%A" >nul 2>&1
)

echo    -> Services restored


:: -----------------------------------------------------
:: OneDrive
:: -----------------------------------------------------
echo [2/6] Restoring OneDrive...

start "" "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "OneDrive" /t REG_SZ /d "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /f >nul

echo    -> OneDrive restored


:: -----------------------------------------------------
:: Visual Effects / Animations
:: -----------------------------------------------------
echo [3/6] Restoring Windows animations & visual effects...

reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableBlurBehind /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul

echo    -> Visual effects restored


:: -----------------------------------------------------
:: Widgets / Suggestions
:: -----------------------------------------------------
echo [4/6] Restoring Widgets & system recommendations...

reg add "HKLM\Software\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f >nul

echo    -> Widgets restored


:: -----------------------------------------------------
:: Game DVR
:: -----------------------------------------------------
echo [5/6] Restoring GameDVR & Xbox Game Bar...

reg add "HKLM\Software\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul

echo    -> Game Bar restored


:: -----------------------------------------------------
:: Power / Network Settings
:: -----------------------------------------------------
echo [6/6] Restoring system performance defaults...

reg add "HKLM\System\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /t REG_DWORD /d 0 /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0 /f >nul
reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 20 /f >nul

echo    -> Default performance restored


:: -----------------------------------------------------
:: Hibernation
:: -----------------------------------------------------
powercfg -h on >nul 2>&1
echo    -> Hibernation restored


echo.
echo =====================================================
echo          RESTORE COMPLETE – RESTART REQUIRED
echo =====================================================
pause
