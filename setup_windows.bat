@echo off
chcp 65001 >nul 2>&1

:: ============================================================
::  OOP 2026 실습 환경 원클릭 설치 스크립트 (Windows)
::
::  이 스크립트는 다음을 자동으로 수행합니다:
::    1. Miniconda 다운로드 및 설치
::    2. 환경 변수(PATH) 설정
::    3. conda 가상환경(OOP) 생성 및 패키지 설치
::    4. 실습 저장소 git clone
::    5. 환경 검증 테스트 실행
::
::  사용법: 이 파일을 더블클릭하거나 CMD에서 실행
:: ============================================================

echo.
echo ==================================================
echo   OOP 2026 실습 환경 자동 설치
echo ==================================================
echo.

:: ----------------------------------------------------------
::  설정값
:: ----------------------------------------------------------
set "INSTALL_DIR=%USERPROFILE%\miniconda3"
set "ENV_NAME=OOP"
set "PYTHON_VER=3.9"
set "REPO_URL=https://github.com/ElionLAB/OOP_2026_Practice.git"
set "WORK_DIR=%USERPROFILE%\OOP_2026_Practice"
set "INSTALLER=%TEMP%\Miniconda3-latest-Windows-x86_64.exe"
set "MINICONDA_URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe"
set "CONDA_CMD=%INSTALL_DIR%\condabin\conda.bat"

:: ----------------------------------------------------------
::  Step 1: Miniconda 설치
:: ----------------------------------------------------------
echo [1/5] Miniconda 설치 확인 중...

if exist "%CONDA_CMD%" (
    echo       - Miniconda가 이미 설치되어 있습니다. 건너뜁니다.
    goto :set_path
)

echo       - Miniconda를 다운로드합니다...
echo         URL: %MINICONDA_URL%

curl -L -o "%INSTALLER%" "%MINICONDA_URL%"
if %ERRORLEVEL% neq 0 (
    echo [오류] 다운로드에 실패했습니다. 인터넷 연결을 확인하세요.
    goto :error_exit
)

echo       - Miniconda를 설치합니다 (자동 설치 모드)...
start /wait "" "%INSTALLER%" /InstallationType=JustMe /RegisterPython=0 /AddToPath=0 /S /D=%INSTALL_DIR%
if %ERRORLEVEL% neq 0 (
    echo [오류] Miniconda 설치에 실패했습니다.
    goto :error_exit
)

echo       - 설치 완료. 임시 파일을 삭제합니다.
del /f "%INSTALLER%" >nul 2>&1

:: ----------------------------------------------------------
::  Step 2: 환경 변수(PATH) 설정
:: ----------------------------------------------------------
:set_path
echo.
echo [2/5] 환경 변수 설정 중...

:: 현재 세션 PATH에 conda 경로 추가
set "PATH=%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%INSTALL_DIR%\condabin;%INSTALL_DIR%\Library\bin;%PATH%"
set "CONDA_PATHS=%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%INSTALL_DIR%\condabin;%INSTALL_DIR%\Library\bin"

:: conda 작동 확인
call "%CONDA_CMD%" --version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [오류] conda가 인식되지 않습니다. 설치 경로를 확인하세요.
    goto :error_exit
)
for /f "tokens=*" %%V in ('call "%CONDA_CMD%" --version 2^>^&1') do echo       - %%V

:: 사용자 PATH에 영구 등록 (delayed expansion을 이 블록에서만 사용)
setlocal EnableDelayedExpansion
set "NEED_REG=0"

reg query "HKCU\Environment" /v Path >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=2,*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul ^| findstr /i "Path"') do set "CUR_PATH=%%B"
) else (
    set "CUR_PATH="
)

echo !CUR_PATH! | findstr /i /c:"miniconda3\condabin" >nul 2>&1
if !ERRORLEVEL! neq 0 (
    if "!CUR_PATH!"=="" (
        set "FINAL_PATH=%CONDA_PATHS%"
    ) else (
        set "FINAL_PATH=%CONDA_PATHS%;!CUR_PATH!"
    )
    reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!FINAL_PATH!" /f >nul 2>&1
    echo       - 사용자 PATH에 conda 경로를 등록했습니다.
) else (
    echo       - conda 경로가 이미 PATH에 등록되어 있습니다.
)
endlocal

:: ----------------------------------------------------------
::  Step 3: 가상환경 생성 및 패키지 설치
:: ----------------------------------------------------------
echo.
echo [3/5] 가상환경 '%ENV_NAME%' 생성 및 패키지 설치 중...

:: 기존 환경이 있으면 제거 후 재생성
call "%CONDA_CMD%" env list 2>nul | findstr /c:"\%ENV_NAME%" >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo       - 기존 '%ENV_NAME%' 환경을 제거합니다...
    call "%CONDA_CMD%" env remove -n %ENV_NAME% -y >nul 2>&1
)

echo       - 가상환경을 생성합니다 (Python %PYTHON_VER%)...
call "%CONDA_CMD%" create -n %ENV_NAME% python=%PYTHON_VER% -y -q
if %ERRORLEVEL% neq 0 (
    echo [오류] 가상환경 생성에 실패했습니다.
    goto :error_exit
)

echo       - 패키지를 설치합니다 (beautifulsoup4, pytest, pillow, git, ipykernel)...
call "%CONDA_CMD%" install -n %ENV_NAME% beautifulsoup4 pytest pillow git ipykernel -y -q
if %ERRORLEVEL% neq 0 (
    echo [오류] 패키지 설치에 실패했습니다.
    goto :error_exit
)

echo       - tox를 설치합니다...
call "%CONDA_CMD%" run -n %ENV_NAME% pip install tox -q
if %ERRORLEVEL% neq 0 (
    echo [경고] tox 설치에 실패했습니다. 나중에 수동으로 설치하세요.
)

echo       - Jupyter 커널을 등록합니다...
call "%CONDA_CMD%" run -n %ENV_NAME% python -m ipykernel install --user --name %ENV_NAME% --display-name "Python 3 (OOP)" >nul 2>&1

:: ----------------------------------------------------------
::  Step 4: 저장소 clone
:: ----------------------------------------------------------
echo.
echo [4/5] 실습 저장소를 clone합니다...

set "GIT_CMD=%INSTALL_DIR%\envs\%ENV_NAME%\Library\bin\git.exe"
if not exist "%GIT_CMD%" set "GIT_CMD=git"

if exist "%WORK_DIR%\.git" (
    echo       - 저장소가 이미 존재합니다. 최신 상태로 업데이트합니다...
    pushd "%WORK_DIR%"
    "%GIT_CMD%" pull origin main
    popd
) else if exist "%WORK_DIR%" (
    echo       - 폴더가 이미 존재하지만 git 저장소가 아닙니다.
    echo         %WORK_DIR% 폴더를 확인하세요.
) else (
    "%GIT_CMD%" clone "%REPO_URL%" "%WORK_DIR%"
    if %ERRORLEVEL% neq 0 (
        echo [오류] 저장소 clone에 실패했습니다.
        goto :error_exit
    )
)

:: ----------------------------------------------------------
::  Step 5: 환경 검증 테스트
:: ----------------------------------------------------------
echo.
echo [5/5] 환경 검증 테스트를 실행합니다...
echo.

pushd "%WORK_DIR%"
call "%CONDA_CMD%" run -n %ENV_NAME% python tests/test_setup.py
set "TEST_RESULT=%ERRORLEVEL%"
popd

:: ----------------------------------------------------------
::  완료
:: ----------------------------------------------------------
echo.
if %TEST_RESULT% equ 0 (
    echo ==================================================
    echo   설치가 완료되었습니다.
    echo ==================================================
    echo.
    echo   다음 단계:
    echo     1. VSCode에서 폴더 열기: %WORK_DIR%
    echo     2. Ctrl+Shift+P ^> "Python: Select Interpreter"
    echo        ^> Python 3.9.x ('OOP': conda) 선택
    echo     3. 터미널에서: conda activate OOP
    echo.
) else (
    echo ==================================================
    echo   설치는 완료되었지만, 일부 테스트가 실패했습니다.
    echo   위 출력을 확인하세요.
    echo ==================================================
    echo.
)

pause
exit /b 0

:error_exit
echo.
echo ==================================================
echo   설치 중 오류가 발생했습니다.
echo   위 오류 메시지를 확인하고 다시 시도하세요.
echo ==================================================
echo.
pause
exit /b 1
