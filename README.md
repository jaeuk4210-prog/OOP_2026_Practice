# Object-Oriented Programming 2026 (3168)

Practice repository for the Python Object-Oriented Programming course (Python OOP 수업 실습 저장소)

## Textbook (교재)

[Python Object-Oriented Programming, 4th Edition (Packt)](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)

## Environment Setup (환경 설정)

See the setup guides below (설치 가이드를 참고하세요):

| OS | English | Korean (한국어) |
|----|---------|----------------|
| Windows | [Setup Guide](docs/setup_guide_en.md) | [설치 가이드](docs/setup_guide.md) |
| macOS | [Setup Guide](docs/setup_guide_macos_en.md) | [설치 가이드](docs/setup_guide_macos.md) |

### Quick Start (빠른 시작)

```bash
conda create -n OOP python=3.9 -y
conda activate OOP
conda install beautifulsoup4 pytest pillow ipykernel -y
pip install tox
python -m ipykernel install --user --name OOP --display-name "Python 3 (OOP)"
```

### Verify Setup (환경 검증)

```bash
python tests/test_setup.py
```

## Pulling Updates (업데이트 받기)

After the initial `git clone` on the first day of class, run the following command to get the latest materials (새로운 자료가 추가되면 아래 명령어로 최신 내용을 받을 수 있습니다):

```bash
cd OOP_2026_Practice
git pull origin main
```

> **What if there's a merge conflict? (충돌이 발생하면?)**
>
> If your local changes overlap with newly updated files, a **merge conflict** may occur.
> Use one of the following methods to resolve it (아래 방법 중 하나를 사용하세요):
>
> **Option 1 — Commit your changes first, then pull (커밋 후 pull)**
> ```bash
> git add .
> git commit -m "Save my practice code"
> git pull origin main
> ```
>
> **Option 2 — Stash your changes, pull, then restore (임시 저장 후 pull)**
> ```bash
> git stash
> git pull origin main
> git stash pop
> ```

## Project Structure (프로젝트 구조)

```
OOP_2026_Practice/
├── docs/              # Documentation (설치 가이드 등 문서)
├── tests/             # Setup verification tests (환경 검증 테스트)
├── ch_01/             # Chapter 1 practice (실습)
│   ├── src/           # Notebooks and source code (노트북 및 소스 코드)
│   └── tests/
├── ch_02/             # Chapter 2 practice (실습)
│   ├── src/
│   └── tests/
└── ...
```
