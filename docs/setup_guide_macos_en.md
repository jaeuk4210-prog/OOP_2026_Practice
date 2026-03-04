# Object-Oriented Programming 2026 (3168) Lab Environment Setup Guide (macOS)

> [한국어 버전](setup_guide_macos.md) | [Windows version](setup_guide_en.md)

This repository contains lab materials for the **Object-Oriented Programming 2026 (3168)** course.

The original textbook code was written for an earlier Python 3.x version, which causes **version compatibility issues** with certain packages and syntax in current environments. To address this, the lab environment and example code have been restructured based on Python 3.9.

> Based on macOS + VSCode

---

## Step 1: Install VSCode and Extensions

1. Download and install **VSCode** from [code.visualstudio.com](https://code.visualstudio.com/).
2. Launch VSCode and click the **Extensions** icon (four squares) in the left sidebar.
3. Search for and install the following extensions:
   - **Python** (Microsoft) — Python language support
   - **Pylance** (Microsoft) — Code autocompletion and type checking
   - **Jupyter** (Microsoft) — Jupyter Notebook support (run `.ipynb` files)

---

## Step 2: Install Miniconda or Anaconda

You can use either **Miniconda** (lightweight, recommended) or **Anaconda** (full distribution). Both work the same way for this course.

- **Miniconda**: Minimal installer — includes only conda and Python. Suitable for most users.
- **Anaconda**: Full distribution — includes conda, Python, and 250+ pre-installed packages. Takes more disk space (~3 GB).

1. Download the **macOS** installer from [anaconda.com/download](https://www.anaconda.com/download).
   - Apple Silicon (M1/M2/M3/M4): **macOS Apple M1 64-bit pkg**
   - Intel Mac: **macOS Intel x86 64-bit pkg**
2. Run the installer (keep default options).
3. After installation, **restart VSCode**.
4. Open a terminal in VSCode (`` Ctrl + ` `` or menu **Terminal > New Terminal**).

### Registering Environment Variables (PATH) on macOS

The installer automatically runs `conda init`, which adds conda to your shell profile. To verify or fix this manually:

1. Open a terminal and run:
   ```bash
   conda init zsh
   ```
   If you use **bash** instead of zsh (older macOS):
   ```bash
   conda init bash
   ```

2. Reload the shell configuration:
   ```bash
   source ~/.zshrc
   # or for bash:
   source ~/.bash_profile
   ```

3. Verify that conda is correctly registered:
   ```bash
   conda --version
   which conda
   echo $PATH
   ```
   - `conda --version` should display a version number (e.g., `conda 24.x.x`).
   - `which conda` should display the conda path (e.g., `/Users/<username>/miniconda3/bin/conda`).

> If `conda init` does not work, you can manually add the following line to `~/.zshrc` (or `~/.bash_profile`):
> ```bash
> export PATH="$HOME/miniconda3/bin:$PATH"
> ```
> For Anaconda: `export PATH="$HOME/anaconda3/bin:$PATH"`
>
> Then reload: `source ~/.zshrc`

> If `conda` is still not recognized after reloading, close VSCode completely and reopen it.

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

1. Press `Cmd + Shift + P` in VSCode to open the Command Palette.
2. Type **"Python: Select Interpreter"** and select it.
3. Choose `Python 3.9.x ('OOP': conda)` from the list.
4. Verify that the selected interpreter is displayed in the bottom status bar.

> If it does not appear in the list, select "Enter interpreter path" and enter the conda environment path manually:
> ```
> ~/miniconda3/envs/OOP/bin/python
> ```
> If you installed Anaconda: `~/anaconda3/envs/OOP/bin/python`

> When you open a `.ipynb` file, select **Python 3 (OOP)** from the kernel picker in the top-right corner.

---

## Step 5: Clone Repositories and Verify Environment

Install git:

```bash
conda install git -y
```

Clone the lab repository in the VSCode terminal:

```bash
git clone https://github.com/ElionLAB/OOP_2026_Practice.git
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

### Environment Variables / conda Not Recognized

| Symptom | Solution |
|---------|----------|
| `conda` not recognized in VSCode terminal | Run `conda init zsh` (or `conda init bash`), then `source ~/.zshrc`, and restart VSCode |
| Still not recognized after `conda init` | Manually add `export PATH="$HOME/miniconda3/bin:$PATH"` to `~/.zshrc`, then run `source ~/.zshrc` |
| `conda: command not found` | Run `echo $PATH` to check if conda path is included. If not, follow the PATH registration steps in Step 2 |
| `which conda` returns `/usr/bin/conda` or nothing | conda is not registered in PATH. Run `conda init zsh` and restart VSCode |
| conda prompt (`base`) disappears after restarting terminal | Check if the conda init block exists in `~/.zshrc`. If missing, run `conda init zsh` again |

### Python / Package Issues

| Symptom | Solution |
|---------|----------|
| `python` points to system Python | Run `conda activate OOP` then verify with `which python` (should show `miniconda3/envs/OOP/bin/python`) |
| Interpreter not visible in VSCode | Restart VSCode and try again. If still missing, use "Enter interpreter path" and enter `~/miniconda3/envs/OOP/bin/python` directly |
| `import pytest` fails | Run `conda activate OOP` then `conda install pytest -y` |
| Permission denied error | Use `pip install --user` or verify the conda environment is activated (`conda activate OOP`) |

---

## References

This lab material is based on the following textbook:

- **Python Object-Oriented Programming, 4th Edition** — Steven F. Lott, Dusty Phillips (Packt Publishing)
- Original code repository: [PacktPublishing/Python-Object-Oriented-Programming---4th-edition](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)
