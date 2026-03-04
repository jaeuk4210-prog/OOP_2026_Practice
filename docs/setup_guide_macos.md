# Object-Oriented Programming 2026 (3168) 실습 환경 설치 가이드 (macOS)

> [English version](setup_guide_macos_en.md) | [Windows 버전](setup_guide.md)

본 저장소는 **Object-Oriented Programming 2026 (3168)** 수업의 실습 자료입니다.

교재의 원본 코드는 Python 3.x 초기 버전 기준으로 작성되어 있어, 현재 환경에서 일부 패키지 및 문법의 **버전 호환 문제**가 발생합니다. 이를 해결하기 위해 실습 환경과 예제 코드를 Python 3.9 기준으로 재구성하였습니다.

> macOS + VSCode 기준

---

## Step 1: VSCode 설치 및 확장 프로그램

1. [code.visualstudio.com](https://code.visualstudio.com/) 에서 **VSCode** 를 다운로드하여 설치합니다.
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

1. [anaconda.com/download](https://www.anaconda.com/download) 에서 **macOS** 설치 파일을 다운로드합니다.
   - Apple Silicon (M1/M2/M3/M4): **macOS Apple M1 64-bit pkg**
   - Intel Mac: **macOS Intel x86 64-bit pkg**
2. 설치를 진행합니다 (기본 옵션 유지).
3. 설치가 완료되면 **VSCode를 재시작**합니다.
4. VSCode에서 터미널을 엽니다 (`` Ctrl + ` `` 또는 메뉴 **Terminal > New Terminal**).

### macOS 시스템 환경 변수(PATH) 등록

설치 프로그램이 자동으로 `conda init`을 실행하여 쉘 프로파일에 conda를 등록합니다. 수동으로 확인하거나 수정하려면 아래 절차를 따릅니다:

1. 터미널을 열고 아래 명령을 실행합니다:
   ```bash
   conda init zsh
   ```
   **bash**를 사용하는 경우(구형 macOS):
   ```bash
   conda init bash
   ```

2. 쉘 설정 파일을 다시 불러옵니다:
   ```bash
   source ~/.zshrc
   # bash를 사용하는 경우:
   source ~/.bash_profile
   ```

3. conda가 올바르게 등록되었는지 확인합니다:
   ```bash
   conda --version
   which conda
   echo $PATH
   ```
   - `conda --version`: 버전 번호(예: `conda 24.x.x`)가 출력되면 정상입니다.
   - `which conda`: conda 경로(예: `/Users/<사용자명>/miniconda3/bin/conda`)가 출력되어야 합니다.
   - `echo $PATH`: 출력 결과에 `miniconda3/bin` 또는 `anaconda3/bin` 경로가 포함되어 있어야 합니다.

> `conda init`으로 해결되지 않는 경우, `~/.zshrc`(또는 `~/.bash_profile`)에 아래 줄을 직접 추가할 수 있습니다:
> ```bash
> export PATH="$HOME/miniconda3/bin:$PATH"
> ```
> Anaconda의 경우: `export PATH="$HOME/anaconda3/bin:$PATH"`
>
> 추가 후 적용: `source ~/.zshrc`

> 위 방법을 모두 시도한 후에도 `conda`가 인식되지 않는 경우, VSCode를 완전히 닫았다가 다시 엽니다.

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

1. VSCode에서 `Cmd + Shift + P`를 눌러 명령 팔레트를 엽니다.
2. **"Python: Select Interpreter"** 를 입력하고 선택합니다.
3. 목록에서 `Python 3.9.x ('OOP': conda)` 항목을 선택합니다.
4. 하단 상태 표시줄에 선택한 인터프리터가 표시되는지 확인합니다.

> 목록에 보이지 않으면 "Enter interpreter path"를 선택하고 conda 환경 경로를 직접 입력합니다:
> ```
> ~/miniconda3/envs/OOP/bin/python
> ```
> Anaconda를 설치한 경우: `~/anaconda3/envs/OOP/bin/python`

> `.ipynb` 파일을 열면 우측 상단의 커널 선택에서 **Python 3 (OOP)** 를 선택하세요.

---

## Step 5: 저장소 clone 및 환경 검증

git을 설치합니다:

```bash
conda install git -y
```

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
| VSCode 터미널에서 `conda`가 인식되지 않음 | `conda init zsh` (또는 `conda init bash`) 실행 후 `source ~/.zshrc` 적용, VSCode 재시작 |
| `conda init` 실행 후에도 인식 안 됨 | `~/.zshrc`에 `export PATH="$HOME/miniconda3/bin:$PATH"` 직접 추가 후 `source ~/.zshrc` |
| `conda: command not found` | `echo $PATH`로 conda 경로 포함 여부 확인. 없으면 Step 2의 환경 변수 등록 절차 수행 |
| `which conda`가 `/usr/bin/conda` 또는 빈 값 출력 | conda가 PATH에 등록되지 않음. `conda init zsh` 실행 후 VSCode 재시작 |
| 터미널 재시작마다 conda가 초기화됨 (`base` 프롬프트가 사라짐) | `~/.zshrc` 파일에 conda 초기화 블록이 있는지 확인. 없으면 `conda init zsh` 재실행 |

### Python / 패키지 문제

| 증상 | 해결 방법 |
|------|-----------|
| `python`이 시스템 Python을 가리킴 | `conda activate OOP` 후 `which python`으로 경로 확인 (`miniconda3/envs/OOP/bin/python`이어야 함) |
| VSCode에서 인터프리터가 안 보임 | VSCode 재시작 후 다시 시도. 그래도 안 되면 "Enter interpreter path"로 `~/miniconda3/envs/OOP/bin/python` 직접 입력 |
| `import pytest` 실패 | `conda activate OOP` 후 `conda install pytest -y` |
| Permission denied 에러 | `pip install --user` 사용 또는 conda 환경 활성화(`conda activate OOP`) 확인 |

---

## 출처

본 실습 자료는 아래 교재를 기반으로 작성되었습니다:

- **Python Object-Oriented Programming, 4th Edition** — Steven F. Lott, Dusty Phillips (Packt Publishing)
- 원본 코드 저장소: [PacktPublishing/Python-Object-Oriented-Programming---4th-edition](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)
