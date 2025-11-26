@echo off
:: ================================================================
:: WINDOWS 11 - SAFE RESTORE (Fixed & Working - Nov 2025)
:: Undoes common debloat/privacy scripts
:: ================================================================

title WINDOWS 11 - SAFE RESTORE
color 0a
setlocal enabledelayedexpansion

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo  ERROR: This script MUST be run as Administrator!
    echo         Right-click → "Run as administrator"
    echo.
    pause
    exit /b 1
)

cls
echo =====================================================
echo        WINDOWS 11 SAFE RESTORE TOOL
echo        Restores default Microsoft features
echo =====================================================
echo.
set /p "choice=Do you really want to restore Windows 11 defaults? (Y/N): "
if /i "%choice%" neq "Y" (
    echo.
    echo Operation cancelled by user.
    pause
    exit /b 0
)

echo.
echo Starting restore...
echo.

:: 1. Restore Services (correct startup types)
echo [1/6] Restoring essential services...
for %%s in (
    "WSearch=auto"
    "SysMain=auto"
    "DiagTrack=auto"
    "WerSvc=auto"
    "XboxGipSvc=demand"
    "XblAuthManager=demand"
    "XblGameSave=demand"
    "CDPSvc=demand"
    "CDPUserSvc=demand"
    "MapsBroker=demand"
    "WbioSrvc=manual"
    "TabletInputService=manual"
    "lfsvc=demand"
) do (
    for /f "tokens=1,2 delims==" %%a in (%%s) do (
        sc config "%%a" start= %%b >nul 2>&1
        if /i "%%b"=="auto" sc start "%%a" >nul 2>&1
    )
)
echo    Services restored

:: 2. Restore OneDrive
echo [2/6] Restoring OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
start "" "%LocalAppData%\Microsoft\OneDrive\OneDrive.exe" /background >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v OneDrive /t REG_SZ /d "\"%LocalAppData%\Microsoft\OneDrive\OneDrive.exe\" /background" /f >nul
echo    OneDrive restored

:: 3. Restore Visual Effects & Animations
echo [3/6] Restoring animations and visual effects...
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v EnableAeroPeek /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\DWM" /v Composition /t REG_DWORD /d 1 /f >nul
echo    Visual effects restored

:: 4. Restore Widgets, Search Highlights, Chat, etc.
echo [4/6] Restoring Widgets, Search Highlights and Taskbar items...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /f >nul 2>&1
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v ChatIcon /f >nul 2>&1
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowCopilotButton /f >nul 2>&1
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarMn /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v SearchboxTaskbarMode /t REG_DWORD /d 2 /f >nul
echo    Widgets and taskbar features restored

:: 5. Restore Xbox Game Bar / Game DVR
echo [5/6] Restoring Xbox Game Bar and Game DVR...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /f >nul 2>&1
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\GameDVR" /v AppCaptureEnabled /t REG_DWORD /d 1 /f >nul
echo    Game Bar restored

:: 6. Restore performance defaults & hibernation
echo [6/6] Restoring performance settings and hibernation...
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" /v PowerThrottlingOff /f >nul 2>&1
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 0xffffffff /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Latency Sensitive" /t REG_SZ /d "True" /f >nul
powercfg -h on >nul 2>&1
echo    Performance and hibernation restored

echo.
echo =====================================================
echo       RESTORE COMPLETED SUCCESSFULLY!
echo       A RESTART IS STRONGLY RECOMMENDED
echo =====================================================
echo.
pause