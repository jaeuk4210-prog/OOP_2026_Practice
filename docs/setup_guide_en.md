# Object-Oriented Programming 2026 (3168) Lab Environment Setup Guide

> [한국어 버전](setup_guide.md) | [macOS version](setup_guide_macos_en.md)

This repository contains lab materials for the **Object-Oriented Programming 2026 (3168)** course.

The original textbook code was written for an earlier Python 3.x version, which causes **version compatibility issues** with certain packages and syntax in current environments. To address this, the lab environment and example code have been restructured based on Python 3.9.

> Based on Windows 11 + VSCode

---

## Step 1: Install VSCode and Extensions

1. Download and install **VSCode** from [code.visualstudio.com](https://code.visualstudio.com/).
2. Launch VSCode and click the **Extensions** icon (four squares) in the left sidebar.
3. Search for and install the following extensions:
   - **Python** (Microsoft) — Python language support
   - **Pylance** (Microsoft) — Code autocompletion and type checking
   - **Jupyter** (Microsoft) — Jupyter Notebook support (run `.ipynb` files)

---

## Step 2: Install Miniconda

1. Download the **Miniconda Windows 64-bit** installer from [anaconda.com/download](https://www.anaconda.com/download).
2. Run the installer (keep default options).
3. After installation, **restart VSCode**.
4. Open a terminal in VSCode (`Ctrl + ~`).

> If `conda` is not recognized in the terminal:
> - Close VSCode completely and reopen it.
> - Or switch the terminal type to **Command Prompt** (dropdown next to the `+` button at the top-right of the terminal > Command Prompt).

---

## Step 3: Create Virtual Environment and Install Dependencies

Run the following commands in order in the VSCode terminal.

1. Create a virtual environment:

```bash
conda create -n OOP python=3.9 -y
```

2. Activate the virtual environment:

```bash
conda activate OOP
```

If `(OOP)` appears before your prompt, the activation was successful.

3. Install required packages:

```bash
conda install beautifulsoup4 pytest pillow -y
pip install tox
```

4. Install `ipykernel` and register the kernel for Jupyter Notebook labs:

```bash
conda install ipykernel -y
python -m ipykernel install --user --name OOP --display-name "Python 3 (OOP)"
```

---

## Step 4: Select the conda Interpreter in VSCode

1. Press `Ctrl + Shift + P` in VSCode to open the Command Palette.
2. Type **"Python: Select Interpreter"** and select it.
3. Choose `Python 3.9.x ('OOP': conda)` from the list.
4. Verify that the selected interpreter is displayed in the bottom status bar.

> If it does not appear in the list, select "Enter interpreter path" and enter the conda environment path manually:
> `C:\Users\<username>\miniconda3\envs\OOP\python.exe`

> When you open a `.ipynb` file, select **Python 3 (OOP)** from the kernel picker in the top-right corner.

---

## Step 5: Clone Repositories and Verify Environment

Clone the textbook repository in the VSCode terminal:

```bash
git clone https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition.git
```

Run the environment verification test:

```bash
conda activate OOP

# Run directly
python tests/test_setup.py

# Or run with pytest
pytest tests/test_setup.py -v
```

If all items show **PASS**, the environment setup is complete.

---

## Project Structure

```
OOP_2026_Practice/
├── docs/              # Documentation (setup guide, etc.)
├── tests/             # Environment verification tests
├── ch_01/             # Chapter 1 lab
│   ├── src/
│   └── tests/
├── ch_02/             # Chapter 2 lab
│   ├── src/
│   └── tests/
└── ...
```

---

## Troubleshooting

| Symptom | Solution |
|---------|----------|
| `conda` not recognized in VSCode terminal | Restart VSCode or switch terminal type to Command Prompt |
| `python` not recognized | Run `conda activate OOP` first |
| Interpreter not visible in VSCode | Restart VSCode and try again |
| `import pytest` fails | Run `conda activate OOP` then `conda install pytest -y` |

---

## References

This lab material is based on the following textbook:

- **Python Object-Oriented Programming, 4th Edition** — Steven F. Lott, Dusty Phillips (Packt Publishing)
- Original code repository: [PacktPublishing/Python-Object-Oriented-Programming---4th-edition](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)
