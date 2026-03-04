# Object-Oriented Programming 2026 (3168) 실습 환경 설치 가이드

> [English version](setup_guide_en.md) | [macOS 버전](setup_guide_macos.md)

본 저장소는 **Object-Oriented Programming 2026 (3168)** 수업의 실습 자료입니다.

교재의 원본 코드는 Python 3.x 초기 버전 기준으로 작성되어 있어, 현재 환경에서 일부 패키지 및 문법의 **버전 호환 문제**가 발생합니다. 이를 해결하기 위해 실습 환경과 예제 코드를 Python 3.9 기준으로 재구성하였습니다.

> Windows 11 + VSCode 기준

---

## Step 1: VSCode 설치 및 확장 프로그램

> 새천년관 403호 실습실 컴퓨터에는 VSCode가 이미 설치되어 있으므로, 별도로 설치하지 않아도 됩니다.

1. [code.visualstudio.com](https://code.visualstudio.com/) 에서 **VSCode** 를 다운로드하여 설치합니다. (실습실에서는 생략)
2. VSCode를 실행한 후, 왼쪽 사이드바의 **확장(Extensions)** 아이콘(네모 4개 모양)을 클릭합니다.
3. 다음 확장 프로그램을 검색하여 설치합니다:
   - **Python** (Microsoft) — Python 언어 지원
   - **Pylance** (Microsoft) — 코드 자동완성 및 타입 검사
   - **Jupyter** (Microsoft) — Jupyter Notebook 지원 (`.ipynb` 파일 실행)

---

## Step 2: Miniconda 또는 Anaconda 설치

**Miniconda**(경량, 권장) 또는 **Anaconda**(풀 배포판) 중 하나를 선택해 설치할 수 있습니다. 이 수업에서는 두 가지 모두 동일하게 사용 가능합니다.

- **Miniconda**: 최소 설치 — conda와 Python만 포함. 대부분의 사용자에게 적합합니다.
- **Anaconda**: 풀 배포판 — conda, Python, 250개 이상의 패키지 포함. 설치 용량이 큽니다(약 3 GB).

1. [anaconda.com/download](https://www.anaconda.com/download) 에서 **Windows 64-bit** 설치 파일을 다운로드합니다.
   - Miniconda: 페이지 하단의 **Miniconda Installers** 섹션에서 **Windows 64-bit** 선택.
   - Anaconda: 페이지 상단의 Windows 설치 파일 선택.
2. 설치를 진행합니다. 설치 중 **"Add Miniconda3/Anaconda3 to my PATH environment variable"** 옵션을 체크합니다.
   > 이 옵션은 기본적으로 체크 해제되어 있고 경고 문구가 표시되지만, 체크하면 어느 터미널에서도 `conda`를 바로 사용할 수 있습니다.
3. 설치가 완료되면 **VSCode를 재시작**합니다.
4. VSCode에서 터미널을 엽니다 (`Ctrl + ~`).

### 시스템 환경 변수 수동 등록 (`conda`가 인식되지 않는 경우)

설치 시 PATH 옵션을 체크하지 않았다면 아래 방법으로 직접 등록합니다:

1. `Win + S`를 눌러 **"시스템 환경 변수 편집"** 을 검색하여 엽니다.
2. 하단의 **"환경 변수..."** 버튼을 클릭합니다.
3. **"사용자 변수"** 에서 **Path**를 선택하고 **편집**을 클릭합니다.
4. **새로 만들기**를 클릭하여 아래 경로를 추가합니다 (`<사용자명>`은 본인의 Windows 사용자 이름으로 변경):

   **Miniconda의 경우:**
   ```
   C:\Users\<사용자명>\miniconda3
   C:\Users\<사용자명>\miniconda3\Scripts
   C:\Users\<사용자명>\miniconda3\condabin
   ```

   **Anaconda의 경우:**
   ```
   C:\Users\<사용자명>\anaconda3
   C:\Users\<사용자명>\anaconda3\Scripts
   C:\Users\<사용자명>\anaconda3\condabin
   ```

5. **확인**을 눌러 모든 창을 닫은 후 **VSCode를 재시작**합니다.
6. 새 터미널을 열고 아래 명령으로 확인합니다:
   ```bash
   conda --version
   ```
   버전 번호(예: `conda 24.x.x`)가 표시되면 등록이 완료된 것입니다.

> 위 방법을 모두 시도한 후에도 `conda`가 인식되지 않는 경우:
> - 터미널 유형을 **Command Prompt**로 변경합니다 (터미널 우측 상단 `+` 옆 드롭다운 > Command Prompt).

---

## Step 3: 가상환경 생성 및 의존성 설치

VSCode 터미널에서 다음 명령을 순서대로 실행합니다.

1. 가상환경을 생성합니다:

```bash
conda create -n OOP python=3.9 -y
```

2. 가상환경을 활성화합니다:

```bash
conda activate OOP
```

프롬프트 앞에 `(OOP)`가 표시되면 성공입니다.

3. 필수 패키지를 설치합니다:

```bash
conda install beautifulsoup4 pytest pillow -y
pip install tox
```

4. Jupyter Notebook 실습을 위해 `ipykernel`을 설치하고 커널을 등록합니다:

```bash
conda install ipykernel -y
python -m ipykernel install --user --name OOP --display-name "Python 3 (OOP)"
```

---

## Step 4: VSCode에서 conda 인터프리터 선택

1. VSCode에서 `Ctrl + Shift + P`를 눌러 명령 팔레트를 엽니다.
2. **"Python: Select Interpreter"** 를 입력하고 선택합니다.
3. 목록에서 `Python 3.9.x ('OOP': conda)` 항목을 선택합니다.
4. 하단 상태 표시줄에 선택한 인터프리터가 표시되는지 확인합니다.

> 목록에 보이지 않으면 "Enter interpreter path"를 선택하고 conda 환경 경로를 직접 입력합니다:
> `C:\Users\<사용자명>\miniconda3\envs\OOP\python.exe`

> `.ipynb` 파일을 열면 우측 상단의 커널 선택에서 **Python 3 (OOP)** 를 선택하세요.

---

## Step 5: 저장소 clone 및 환경 검증

VSCode 터미널에서 실습 저장소를 clone합니다:

```bash
git clone https://github.com/ElionLAB/OOP_2026_Practice.git
```

환경 검증 테스트를 실행합니다:

```bash
conda activate OOP

# 직접 실행
python tests/test_setup.py

# 또는 pytest로 실행
pytest tests/test_setup.py -v
```

모든 항목이 **PASS**로 표시되면 환경 구성이 완료된 것입니다.

---

## 프로젝트 구조

```
OOP_2026_Practice/
├── docs/              # 설치 가이드 등 문서
├── tests/             # 환경 검증 테스트
├── ch_01/             # Chapter 1 실습
│   ├── src/
│   └── tests/
├── ch_02/             # Chapter 2 실습
│   ├── src/
│   └── tests/
└── ...
```

---

## 문제 해결

### 환경 변수 / conda 인식 문제

| 증상 | 해결 방법 |
|------|-----------|
| VSCode 터미널(PowerShell)에서 `conda`가 인식되지 않음 | 터미널 유형을 **Command Prompt**로 변경 (터미널 우측 상단 `+` 옆 드롭다운 > Command Prompt) |
| Command Prompt에서도 `conda`가 인식되지 않음 | Step 2의 환경 변수 수동 등록 절차에 따라 PATH에 conda 경로 추가 후 VSCode 재시작 |
| PowerShell에서 `conda activate` 실행 시 오류 발생 | PowerShell 실행 정책 문제. **관리자 권한**으로 PowerShell을 열고 아래 명령 실행:<br>`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`<br>이후 `conda init powershell` 실행 후 VSCode 재시작 |
| PowerShell에서 `conda : 이 시스템에서 스크립트를 실행할 수 없습니다` 오류 | 위 PowerShell 실행 정책 해결 방법과 동일 |
| 환경 변수 등록 후에도 `conda`가 인식되지 않음 | 로그아웃 후 재로그인 하거나 PC를 재시작. 또는 터미널 유형을 Command Prompt로 변경 |

### Python / 패키지 문제

| 증상 | 해결 방법 |
|------|-----------|
| `python`이 인식되지 않음 | `conda activate OOP` 후 실행 |
| VSCode에서 인터프리터가 안 보임 | VSCode 재시작 후 다시 시도. 그래도 안 되면 "Enter interpreter path"로 직접 경로 입력 |
| `import pytest` 실패 | `conda activate OOP` 후 `conda install pytest -y` |
| `conda activate OOP` 후에도 시스템 Python이 실행됨 | `where python` 명령으로 경로 확인. conda 환경 경로(`miniconda3\envs\OOP`)가 최상단에 있어야 함 |

---

## 출처

본 실습 자료는 아래 교재를 기반으로 작성되었습니다:

- **Python Object-Oriented Programming, 4th Edition** — Steven F. Lott, Dusty Phillips (Packt Publishing)
- 원본 코드 저장소: [PacktPublishing/Python-Object-Oriented-Programming---4th-edition](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)
