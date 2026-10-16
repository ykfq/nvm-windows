@echo off
setlocal EnableExtensions

rem ---------------------------------------------------------------------------
rem Portable (noinstall) installer for NVM for Windows.
rem
rem This script configures NVM for the current Windows user only. It does not
rem require an elevated prompt and it asks for the NVM_SYMLINK location instead
rem of hard-coding it to C:\Program Files\nodejs.
rem ---------------------------------------------------------------------------

for %%I in ("%~dp0.") do set "NVM_PATH=%%~fI"
for %%I in ("%~dp0..\nodejs") do set "DEFAULT_SYMLINK=%%~fI"

echo.
echo NVM for Windows - portable installation (current user only)
echo.
set /P "NVM_PATH=Enter the absolute path where the nvm-windows zip file is extracted/copied to [%NVM_PATH%]: "
if not exist "%NVM_PATH%\nvm.exe" (
    echo.
    echo ERROR: nvm.exe was not found in "%NVM_PATH%".
    echo Please run install.cmd from the directory that contains nvm.exe.
    echo.
    pause
    exit /B 1
)
for %%I in ("%NVM_PATH%") do set "NVM_PATH=%%~fI"

set "NVM_SYMLINK=%DEFAULT_SYMLINK%"
set /P "NVM_SYMLINK=Enter the absolute path where the nodejs folder LINK to [%NVM_SYMLINK%]: "

set "NVM_HOME=%NVM_PATH%"

echo.
echo Installing NVM for Windows for the current user:
echo   NVM_HOME    = %NVM_HOME%
echo   NVM_SYMLINK = %NVM_SYMLINK%
echo.

rem Persist NVM_HOME and NVM_SYMLINK for the current user.
rem setx without /M writes to HKCU\Environment and does not need elevation.
setx NVM_HOME "%NVM_HOME%" >nul
if errorlevel 1 echo WARNING: Could not persist NVM_HOME with setx. Set it manually.
setx NVM_SYMLINK "%NVM_SYMLINK%" >nul
if errorlevel 1 echo WARNING: Could not persist NVM_SYMLINK with setx. Set it manually.

rem Add NVM_HOME and NVM_SYMLINK to the user PATH without wiping existing
rem user PATH entries. setuserenv.vbs writes the registry value as
rem REG_EXPAND_SZ so the variables are expanded by new shells.
if exist "%NVM_HOME%\setuserenv.vbs" (
    cscript //nologo "%NVM_HOME%\setuserenv.vbs" >nul
    if errorlevel 1 echo WARNING: Could not update the user PATH. Add %%NVM_HOME%% and %%NVM_SYMLINK%% manually.
) else (
    echo WARNING: setuserenv.vbs was not found. Add %%NVM_HOME%% and
    echo          %%NVM_SYMLINK%% to your user PATH manually.
)

rem Keep the install-time PATH for troubleshooting (as the original script did).
> "%NVM_HOME%\PATH.txt" echo PATH=%PATH%

if exist "%SYSTEMDRIVE%\Program Files (x86)\" (
    set "SYS_ARCH=64"
) else (
    set "SYS_ARCH=32"
)

(
    echo root: %NVM_HOME%
    echo path: %NVM_SYMLINK%
    echo arch: %SYS_ARCH%
    echo proxy: none
) > "%NVM_HOME%\settings.txt"

echo.
echo settings.txt written to "%NVM_HOME%\settings.txt".
echo.
echo NVM is now configured for this user.
echo Open a NEW terminal so the environment changes take effect, then run:
echo   nvm install lts
echo   nvm use lts
echo.

if exist "%NVM_SYMLINK%\node.exe" (
    echo NOTE: "%NVM_SYMLINK%" already contains node.exe. NVM will manage it as-is.
)

endlocal & set "NVM_HOME=%NVM_HOME%" & set "NVM_SYMLINK=%NVM_SYMLINK%"
@echo on