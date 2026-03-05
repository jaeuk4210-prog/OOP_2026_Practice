@echo off
setlocal

:: ============================================================
::  OOP 2026 - One-click Environment Setup (Windows)
::
::  1. Download and install Miniconda
::  2. Set PATH environment variable
::  3. Create conda env (OOP) and install packages
::  4. Git clone the practice repository
::  5. Run environment verification tests
::
::  Usage: Double-click this file or run in CMD
:: ============================================================

echo.
echo ==================================================
echo   OOP 2026 Environment Setup
echo ==================================================
echo.

:: ----------------------------------------------------------
::  Configuration
:: ----------------------------------------------------------
set "INSTALL_DIR=%USERPROFILE%\miniconda3"
set "ENV_NAME=OOP"
set "PYTHON_VER=3.9"
set "REPO_URL=https://github.com/ElionLAB/OOP_2026_Practice.git"
set "WORK_DIR=%USERPROFILE%\OOP_2026_Practice"
set "INSTALLER=%TEMP%\Miniconda3-latest-Windows-x86_64.exe"
set "MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
set "CONDA_BAT=%INSTALL_DIR%\condabin\conda.bat"

:: ----------------------------------------------------------
::  Step 1: Install Miniconda
:: ----------------------------------------------------------
echo [1/5] Checking Miniconda...

if exist "%CONDA_BAT%" (
    echo       - Already installed. Skipping.
    goto :set_path
)

echo       - Downloading Miniconda...
curl -L -o "%INSTALLER%" "%MINICONDA_URL%"
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Download failed. Check internet connection.
    goto :error_exit
)

echo       - Installing Miniconda (silent mode)...
start /wait "" "%INSTALLER%" /InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /S /D=%INSTALL_DIR%
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Installation failed.
    goto :error_exit
)

echo       - Cleaning up installer.
del /f "%INSTALLER%" >nul 2>&1

:: ----------------------------------------------------------
::  Step 2: Set PATH
:: ----------------------------------------------------------
:set_path
echo.
echo [2/5] Setting PATH...

:: Add to current session
set "PATH=%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%INSTALL_DIR%\condabin;%INSTALL_DIR%\Library\bin;%PATH%"

:: Verify conda works
call "%CONDA_BAT%" --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] conda not found at: %CONDA_BAT%
    goto :error_exit
)
for /f "tokens=*" %%V in ('call "%CONDA_BAT%" --version 2^>^&1') do echo       - %%V

:: Register PATH permanently via PowerShell (handles strings safely)
powershell -NoProfile -Command ^
    "$condaPaths = '%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%INSTALL_DIR%\condabin;%INSTALL_DIR%\Library\bin';" ^
    "$current = [Environment]::GetEnvironmentVariable('Path', 'User');" ^
    "if ($current -and $current -like '*miniconda3*') {" ^
    "  Write-Host '      - conda PATH already registered.';" ^
    "} else {" ^
    "  if ($current) { $newPath = $condaPaths + ';' + $current } else { $newPath = $condaPaths };" ^
    "  [Environment]::SetEnvironmentVariable('Path', $newPath, 'User');" ^
    "  Write-Host '      - Registered conda in user PATH.';" ^
    "}"

:: ----------------------------------------------------------
::  Step 3: Create conda env and install packages
:: ----------------------------------------------------------
echo.
echo [3/5] Creating conda env and installing packages...

call "%CONDA_BAT%" env list 2>nul | findstr /c:"\%ENV_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo       - Removing existing env...
    call "%CONDA_BAT%" env remove -n %ENV_NAME% -y >nul 2>&1
)

echo       - Creating env (Python %PYTHON_VER%)...
call "%CONDA_BAT%" create -n %ENV_NAME% python=%PYTHON_VER% -y -q
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Failed to create conda env.
    goto :error_exit
)

echo       - Installing packages...
call "%CONDA_BAT%" install -n %ENV_NAME% beautifulsoup4 pytest pillow git ipykernel -y -q
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Package installation failed.
    goto :error_exit
)

echo       - Installing tox...
call "%CONDA_BAT%" run -n %ENV_NAME% pip install tox -q

echo       - Registering Jupyter kernel...
call "%CONDA_BAT%" run -n %ENV_NAME% python -m ipykernel install --user --name %ENV_NAME% --display-name "Python 3 (OOP)" >nul 2>&1

:: ----------------------------------------------------------
::  Step 4: Clone repository
:: ----------------------------------------------------------
echo.
echo [4/5] Cloning repository...

set "GIT_CMD=%INSTALL_DIR%\envs\%ENV_NAME%\Library\bin\git.exe"
if not exist "%GIT_CMD%" set "GIT_CMD=git"

if exist "%WORK_DIR%\.git" (
    echo       - Repository exists. Pulling latest...
    pushd "%WORK_DIR%"
    "%GIT_CMD%" pull origin main
    popd
) else if exist "%WORK_DIR%" (
    echo       - Folder exists but not a git repo. Check: %WORK_DIR%
) else (
    "%GIT_CMD%" clone "%REPO_URL%" "%WORK_DIR%"
    if %ERRORLEVEL% neq 0 (
        echo [ERROR] Git clone failed.
        goto :error_exit
    )
)

:: ----------------------------------------------------------
::  Step 5: Run verification tests
:: ----------------------------------------------------------
echo.
echo [5/5] Running tests...
echo.

pushd "%WORK_DIR%"
call "%CONDA_BAT%" run -n %ENV_NAME% python tests/test_setup.py
set "TEST_RESULT=%ERRORLEVEL%"
popd

:: ----------------------------------------------------------
::  Done
:: ----------------------------------------------------------
echo.
if %TEST_RESULT% equ 0 (
    echo ==================================================
    echo   Setup completed successfully.
    echo ==================================================
    echo.
    echo   Next steps:
    echo     1. Open folder in VSCode: %WORK_DIR%
    echo     2. Ctrl+Shift+P, "Python: Select Interpreter"
    echo        Select: Python 3.9.x ('OOP': conda)
    echo     3. In terminal: conda activate OOP
    echo.
) else (
    echo ==================================================
    echo   Setup finished but some tests failed.
    echo   Check the output above.
    echo ==================================================
    echo.
)

pause
exit /b 0

:error_exit
echo.
echo ==================================================
echo   An error occurred. Check the message above.
echo ==================================================
echo.
pause
exit /b 1
