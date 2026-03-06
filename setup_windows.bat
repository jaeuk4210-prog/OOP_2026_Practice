@echo off
chcp 65001 >nul 2>nul
setlocal EnableDelayedExpansion

echo.
echo ==================================================
echo   OOP 2026 Environment Setup
echo ==================================================
echo.

:: ---- Configuration ----
set "INSTALL_DIR=%USERPROFILE%\miniconda3"
set "ENV_NAME=OOP"
set "PYTHON_VER=3.9"
set "REPO_URL=https://github.com/ElionLAB/OOP_2026_Practice.git"
set "WORK_DIR=%USERPROFILE%\OOP_2026_Practice"
set "CONDA_EXE=%INSTALL_DIR%\Scripts\conda.exe"
set "ENV_PYTHON=%INSTALL_DIR%\envs\%ENV_NAME%\python.exe"
set "ENV_PIP=%INSTALL_DIR%\envs\%ENV_NAME%\Scripts\pip.exe"
set "MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
set "INSTALLER=%TEMP%\Miniconda3-latest.exe"

:: ---- Check for non-ASCII username ----
:: Verify USERNAME consists only of ASCII alphanumeric, dot, underscore, hyphen
echo %USERNAME%| findstr /r "^[a-zA-Z0-9._-]*$" >nul 2>nul
if errorlevel 1 (
    echo [WARNING] Your Windows username contains non-ASCII characters
    echo          or special symbols.
    echo          This may cause issues with Miniconda installation.
    echo          If the setup fails, please ask your instructor for help.
    echo.
)

:: ---- Check for spaces in USERPROFILE ----
echo "%USERPROFILE%"| findstr /c:" " >nul 2>nul
if not errorlevel 1 (
    echo [WARNING] Your username path contains spaces.
    echo          Path: %USERPROFILE%
    echo          Miniconda may fail to install. If so, ask your instructor.
    echo.
)

:: ---- Step 1: Install Miniconda ----
echo [1/5] Checking Miniconda...

if exist "%CONDA_EXE%" (
    echo       - Already installed at %INSTALL_DIR%
    goto :step2
)

:: Check if Anaconda is installed instead
if exist "%USERPROFILE%\anaconda3\Scripts\conda.exe" (
    echo       - Found Anaconda installation. Using it.
    set "INSTALL_DIR=%USERPROFILE%\anaconda3"
    set "CONDA_EXE=%USERPROFILE%\anaconda3\Scripts\conda.exe"
    set "ENV_PYTHON=%USERPROFILE%\anaconda3\envs\%ENV_NAME%\python.exe"
    set "ENV_PIP=%USERPROFILE%\anaconda3\envs\%ENV_NAME%\Scripts\pip.exe"
    goto :step2
)

:: Check download tool availability
curl --version >nul 2>nul
if errorlevel 1 (
    echo [ERROR] curl is not available on this system.
    echo         Windows 10 1803 or later is required.
    echo         Please install Miniconda manually from:
    echo         https://docs.conda.io/en/latest/miniconda.html
    goto :fail
)

echo       - Downloading Miniconda...
curl -L -o "%INSTALLER%" "%MINICONDA_URL%"
if not exist "%INSTALLER%" (
    echo [ERROR] Download failed. Check your internet connection.
    goto :fail
)

echo       - Installing Miniconda to %INSTALL_DIR% ...
"%INSTALLER%" /InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /S /D=%INSTALL_DIR%
if not exist "%CONDA_EXE%" (
    echo [ERROR] Miniconda installation failed.
    echo         This can happen if your username contains spaces or
    echo         non-English characters. Try running as Administrator,
    echo         or install Miniconda manually to C:\miniconda3
    goto :fail
)
del "%INSTALLER%" >nul 2>nul
echo       - Done.

:: ---- Step 2: Set PATH ----
:step2
echo.
echo [2/5] Setting PATH...

set "CONDA_PATHS=!INSTALL_DIR!;!INSTALL_DIR!\Scripts;!INSTALL_DIR!\condabin;!INSTALL_DIR!\Library\bin"
set "PATH=!CONDA_PATHS!;%PATH%"

"!CONDA_EXE!" --version >nul 2>nul
if errorlevel 1 (
    echo [ERROR] conda not working. Check installation.
    goto :fail
)
for /f "tokens=*" %%v in ('"!CONDA_EXE!" --version 2^>nul') do echo       - %%v

:: Register in user PATH permanently (only if not already present)
set "USER_PATH="
for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USER_PATH=%%b"

:: Check if conda is already in user PATH
set "_CHECK_PATH=.!USER_PATH!"
echo !_CHECK_PATH! | findstr /i /c:"conda" >nul 2>nul
if errorlevel 1 goto :set_path
echo       - conda PATH already registered.
goto :step3

:set_path
:: Build new PATH value
set "_NEW_PATH=!CONDA_PATHS!"
if defined USER_PATH set "_NEW_PATH=!CONDA_PATHS!;!USER_PATH!"

:: Check setx 1024 char limit using a temp file size check
set "_TMPFILE=%TEMP%\_path_len_check.tmp"
echo !_NEW_PATH!> "!_TMPFILE!"
for %%f in ("!_TMPFILE!") do set "_PATH_SIZE=%%~zf"
del "!_TMPFILE!" >nul 2>nul
if !_PATH_SIZE! gtr 1026 (
    echo [WARNING] User PATH would exceed 1024 characters after adding conda.
    echo          conda is available in THIS session only.
    echo          You may need to add conda to PATH manually.
    echo          See: docs\setup_guide.md
    goto :step3
)

:: Use reg add to preserve REG_EXPAND_SZ type (setx always writes REG_SZ)
reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!_NEW_PATH!" /f >nul 2>nul
if errorlevel 1 (
    :: Fallback to setx if reg add fails
    setx Path "!_NEW_PATH!" >nul 2>nul
)
:: Notify other programs that environment has changed
rundll32 user32.dll,UpdatePerUserSystemParameters >nul 2>nul
echo       - Registered conda in user PATH.

:: ---- Step 3: Conda env + packages ----
:step3
echo.
echo [3/5] Setting up conda env (%ENV_NAME%)...

:: Accept conda ToS (conda 24.x+, silently skip if not supported)
"!CONDA_EXE!" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main >nul 2>nul
"!CONDA_EXE!" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r >nul 2>nul
"!CONDA_EXE!" tos accept --override-channels --channel https://repo.anaconda.com/pkgs/msys2 >nul 2>nul

if not exist "!ENV_PYTHON!" goto :create_env

:: Env exists - verify Python version matches expected major.minor
"!ENV_PYTHON!" -c "import sys; exit(0 if sys.version.startswith('%PYTHON_VER%') else 1)" >nul 2>nul
if not errorlevel 1 (
    echo       - Env already exists.
    goto :install_packages
)

:: Wrong Python version - show actual version and recreate
for /f "usebackq tokens=*" %%v in (`"!ENV_PYTHON!" -c "import sys; print(sys.version.split()[0])"`) do set "CURRENT_PY=%%v"
echo       - Env exists but has Python !CURRENT_PY! (expected %PYTHON_VER%.x).
echo       - Recreating env...
"!CONDA_EXE!" env remove -n %ENV_NAME% -y -q >nul 2>nul

:create_env
echo       - Creating env (Python %PYTHON_VER%)...
"!CONDA_EXE!" create -n %ENV_NAME% python=%PYTHON_VER% -y -q
if exist "!ENV_PYTHON!" goto :install_packages

echo       - Default channel failed. Trying conda-forge...
"!CONDA_EXE!" create -n %ENV_NAME% -c conda-forge python=%PYTHON_VER% -y -q
if not exist "!ENV_PYTHON!" (
    echo [ERROR] Failed to create conda env.
    goto :fail
)

:install_packages
:: Check core packages using env python directly (avoids conda run PATH issues)
"!ENV_PYTHON!" -c "import pytest, bs4, PIL" >nul 2>nul
if errorlevel 1 goto :do_install_core
echo       - Core packages already installed.
goto :check_git

:do_install_core
echo       - Installing packages (beautifulsoup4, pytest, pillow, ipykernel)...
"!CONDA_EXE!" install -n %ENV_NAME% beautifulsoup4 pytest pillow ipykernel -y -q

:: Verify installation
"!ENV_PYTHON!" -c "import pytest, bs4, PIL" >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Package installation failed.
    echo         Check your internet connection or try again later.
    goto :fail
)

:check_git
set "GIT_CMD=!INSTALL_DIR!\envs\%ENV_NAME%\Library\bin\git.exe"
if exist "!GIT_CMD!" (
    echo       - git already installed.
    goto :check_tox
)
where git >nul 2>nul
if not errorlevel 1 (
    echo       - git found on system PATH.
    set "GIT_CMD=git"
    goto :check_tox
)
echo       - Installing git...
"!CONDA_EXE!" install -n %ENV_NAME% git -y -q
set "GIT_CMD=!INSTALL_DIR!\envs\%ENV_NAME%\Library\bin\git.exe"

:check_tox
"!ENV_PYTHON!" -c "import tox" >nul 2>nul
if errorlevel 1 goto :do_install_tox
echo       - tox already installed.
goto :register_kernel

:do_install_tox
echo       - Installing tox...
"!ENV_PIP!" install tox -q

:register_kernel
echo       - Registering Jupyter kernel...
"!ENV_PYTHON!" -m ipykernel install --user --name %ENV_NAME% --display-name "Python 3 (OOP)" >nul 2>nul

:: ---- Step 4: Clone repository ----
echo.
echo [4/5] Cloning repository...

if not exist "!GIT_CMD!" (
    where git >nul 2>nul
    if errorlevel 1 (
        echo [ERROR] git not found.
        goto :fail
    )
    set "GIT_CMD=git"
)

if exist "%WORK_DIR%\.git" goto :git_pull
if exist "%WORK_DIR%" goto :git_exists_no_repo
goto :git_clone

:git_pull
echo       - Repository exists. Pulling latest...
pushd "%WORK_DIR%"
"!GIT_CMD!" pull origin main 2>&1
if errorlevel 1 (
    echo [WARNING] git pull failed. There may be local changes.
    echo          You can resolve this manually later.
)
popd
goto :step5

:git_exists_no_repo
echo       - Folder exists but not a git repo.
echo         Check: %WORK_DIR%
goto :step5

:git_clone
echo       - Cloning to %WORK_DIR% ...
"!GIT_CMD!" clone "%REPO_URL%" "%WORK_DIR%"
if not exist "%WORK_DIR%\.git" (
    echo [ERROR] Git clone failed.
    goto :fail
)

:: ---- Step 5: Run tests ----
:step5
echo.
echo [5/5] Running tests...
echo.

set "PYTHONIOENCODING=utf-8"
pushd "%WORK_DIR%"
"!ENV_PYTHON!" tests/test_setup.py
set "TEST_RESULT=!errorlevel!"
popd

echo.
if "!TEST_RESULT!"=="0" goto :success
goto :test_fail

:success
echo ==================================================
echo   Setup completed successfully.
echo ==================================================
echo.
echo   Next steps:
echo     1. Open folder in VSCode: %WORK_DIR%
echo     2. Ctrl+Shift+P ^> Python: Select Interpreter
echo        Select: Python %PYTHON_VER%.x ('OOP': conda)
echo     3. In terminal: conda activate OOP
echo.
goto :end

:test_fail
echo ==================================================
echo   Setup finished but some tests failed.
echo   Check the output above.
echo ==================================================
echo.
goto :end

:fail
echo.
echo [Setup aborted due to error]
echo.

:end
endlocal
pause
