@echo off
title WINDOWS 11 - SAFE RESTORE
color 0a
setlocal

:: Request administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo [ERROR] This script must be run as Administrator!
    echo         Right-click and select "Run as administrator"
    pause
    exit /b 1
)

echo =====================================================
echo        WINDOWS 11 RESTORE (SAFE + YES/NO)
echo =====================================================

set /p USERCHOICE="Do you want to restore all settings to default? (Y/N): "

if /i "%USERCHOICE%" NEQ "Y" (
    echo.
    echo Restore cancelled by user.
    pause
    exit /b 0
)

echo.
echo ============== RESTORING WINDOWS 11... ==============
echo.

:: -----------------------------------------------------
:: 1. Restore critical services (with proper delayed-auto where needed)
:: -----------------------------------------------------
echo [1/6] Restoring Windows services...

set SERVICES=SysMain^=auto WSearch^=auto DiagTrack^=auto WerSvc^=auto ^
             XboxGipSvc^=demand XblAuthManager^=demand XblGameSave^=demand ^
             TabletInputService^=manual CDPSvc^=demand CDPUserSvc^=demand ^
             MapsBroker^=demand WbioSrvc^=manual

for %%S in (%SERVICES%) do (
    for /f "tokens=1,2 delims==" %%A in ("%%S") do (
        echo   - Setting %%A to %%B
        sc config "%%A" start= %%B >nul 2>&1
        if /i "%%B"=="auto" sc start "%%A" >nul 2>&1
    )
)

echo    -> Services restored

:: -----------------------------------------------------
:: 2. Restore OneDrive
:: -----------------------------------------------------
echo [2/6] Restoring OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
start "" "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /background >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /t REG_SZ /d "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /f >nul
echo    -> OneDrive restored

:: -----------------------------------------------------
:: 3. Restore visual effects & animations
:: -----------------------------------------------------
echo [3/6] Restoring animations and visual effects...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v Composition /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableWindowColorization /t REG_DWORD /d 1 /f >nul
echo    -> Visual effects restored

:: -----------------------------------------------------
:: 4. Restore Widgets, News, and Suggestions
:: -----------------------------------------------------
echo [4/6] Restoring Widgets and recommendations...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v ChatIcon /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 1 /f >nul
echo    -> Widgets and suggestions restored

:: -----------------------------------------------------
:: 5. Restore Game DVR / Xbox Game Bar
:: -----------------------------------------------------
echo [5/6] Restoring Xbox Game Bar and Game DVR...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
echo    -> Game Bar restored

:: -----------------------------------------------------
:: 6. Restore performance defaults (remove throttling limits)
:: -----------------------------------------------------
echo [6/6] Restoring default performance settings...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul
powercfg -h on >nul 2>&1
echo    -> Performance and hibernation restored

echo.
echo =====================================================
echo       RESTORE COMPLETE - RESTART RECOMMENDED
echo =====================================================
echo.
echo Please restart your computer for all changes to take effect.
pause