# Object-Oriented Programming 2026 (3168) Lab Environment Setup Guide (macOS)

> [한국어 버전](setup_guide_macos.md) | [Windows version](setup_guide_en.md)

This repository contains lab materials for the **Object-Oriented Programming 2026 (3168)** course.

The original textbook code was written for an earlier Python 3.x version, which causes **version compatibility issues** with certain packages and syntax in current environments. To address this, the lab environment and example code have been restructured based on Python 3.9.

> Based on macOS + VSCode

---

## Step 1: Install Miniconda and Create a Virtual Environment

Miniconda includes Python, so there is no need to install Python separately.

1. Download the **Miniconda macOS** installer from [anaconda.com/download](https://www.anaconda.com/download).
   - Apple Silicon (M1/M2/M3/M4): **macOS Apple M1 64-bit pkg**
   - Intel Mac: **macOS Intel x86 64-bit pkg**
2. Run the installer (keep default options).
3. Open **Terminal** (Terminal.app or iTerm2) and create a virtual environment:

```bash
conda create -n OOP python=3.9 -y
```

4. Activate the virtual environment:

```bash
conda activate OOP
```

If `(OOP)` appears before your prompt, the activation was successful.

> If `conda` is not recognized, restart the terminal or run:
> ```bash
> source ~/miniconda3/etc/profile.d/conda.sh
> ```
> If you installed Anaconda, the path may be `~/anaconda3/etc/profile.d/conda.sh`.

---

## Step 2: Install VSCode and Extensions

1. Download and install **VSCode** from [code.visualstudio.com](https://code.visualstudio.com/).
2. Launch VSCode and click the **Extensions** icon (four squares) in the left sidebar.
3. Search for and install the following extensions:
   - **Python** (Microsoft) — Python language support
   - **Pylance** (Microsoft) — Code autocompletion and type checking
   - **Jupyter** (Microsoft) — Jupyter Notebook support (run `.ipynb` files)

---

## Step 3: Select the conda Interpreter in VSCode

1. Press `Cmd + Shift + P` in VSCode to open the Command Palette.
2. Type **"Python: Select Interpreter"** and select it.
3. Choose `Python 3.9.x ('OOP': conda)` from the list.
4. Verify that the selected interpreter is displayed in the bottom status bar.

> If it does not appear in the list, select "Enter interpreter path" and enter the conda environment path manually:
> ```
> ~/miniconda3/envs/OOP/bin/python
> ```
> If you installed Anaconda: `~/anaconda3/envs/OOP/bin/python`

---

## Step 4: Clone the Lab Repository and Install Dependencies

1. Open a terminal in VSCode (`` Ctrl + ` `` or menu **Terminal > New Terminal**).
2. Navigate to your working directory and clone this lab repository:

```bash
git clone https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition.git
```

3. With the conda environment activated, install the required packages:

```bash
conda activate OOP
conda install beautifulsoup4 pytest pillow -y
pip install tox
```

4. Install `ipykernel` and register the kernel for Jupyter Notebook labs:

```bash
conda install ipykernel -y
python -m ipykernel install --user --name OOP --display-name "Python 3 (OOP)"
```

> When you open a `.ipynb` file in VSCode, select **Python 3 (OOP)** from the kernel picker in the top-right corner.
> The **Jupyter** (Microsoft) VSCode extension must be installed.

---

## Step 5: Verify the Environment

Run the test script to confirm that the environment is correctly configured:

```bash
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
| `conda` not recognized | Restart terminal or run `source ~/miniconda3/etc/profile.d/conda.sh` |
| `python` points to system Python | Run `conda activate OOP` then verify with `which python` |
| Interpreter not visible in VSCode | Restart VSCode and try again |
| `import pytest` fails | Run `conda activate OOP` then `conda install pytest -y` |
| Permission denied error | Use `pip install --user` or verify conda environment is activated |

---

## References

This lab material is based on the following textbook:

- **Python Object-Oriented Programming, 4th Edition** — Steven F. Lott, Dusty Phillips (Packt Publishing)
- Original code repository: [PacktPublishing/Python-Object-Oriented-Programming---4th-edition](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)
