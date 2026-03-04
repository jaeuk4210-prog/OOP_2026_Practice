# Object-Oriented Programming 2026 (3168) Lab Environment Setup Guide

> [한국어 버전](setup_guide.md) | [macOS version](setup_guide_macos_en.md)

This repository contains lab materials for the **Object-Oriented Programming 2026 (3168)** course.

The original textbook code was written for an earlier Python 3.x version, which causes **version compatibility issues** with certain packages and syntax in current environments. To address this, the lab environment and example code have been restructured based on Python 3.9.

> Based on Windows 11 + VSCode

---

## Step 1: Install VSCode and Extensions

> VSCode is already installed on the lab computers in **Saecheonnyeon Hall Room 403**. You can skip the installation step.

1. Download and install **VSCode** from [code.visualstudio.com](https://code.visualstudio.com/). (Skip this in the lab)
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

1. Download the **Windows 64-bit** installer from [anaconda.com/download](https://www.anaconda.com/download).
   - Miniconda: scroll down to the **Miniconda Installers** section and select **Windows 64-bit**.
   - Anaconda: select the Windows installer at the top of the page.
2. Run the installer. When prompted, check **"Add Miniconda3/Anaconda3 to my PATH environment variable"**.
   > This option is unchecked by default and shows a warning, but checking it allows `conda` to be recognized in any terminal.
3. After installation, **restart VSCode**.
4. Open a terminal in VSCode (`Ctrl + ~`).

### Manually Adding Environment Variables (if `conda` is not recognized)

If you did not check the PATH option during installation, add it manually:

1. Press `Win + S`, search for **"Edit the system environment variables"**, and open it.
2. Click **"Environment Variables..."** at the bottom.
3. Under **"User variables"**, select **Path** and click **Edit**.
4. Click **New** and add the following paths (replace `<username>` with your Windows username):

   **For Miniconda:**
   ```
   C:\Users\<username>\miniconda3
   C:\Users\<username>\miniconda3\Scripts
   C:\Users\<username>\miniconda3\condabin
   ```

   **For Anaconda:**
   ```
   C:\Users\<username>\anaconda3
   C:\Users\<username>\anaconda3\Scripts
   C:\Users\<username>\anaconda3\condabin
   ```

5. Click **OK** to close all dialogs, then **restart VSCode**.
6. Open a new terminal and verify:
   ```bash
   conda --version
   ```
   If a version number is displayed (e.g., `conda 24.x.x`), the setup is complete.

> If `conda` is still not recognized after the above steps:
> - Switch the terminal type to **Command Prompt** (dropdown next to the `+` button at the top-right of the terminal > Command Prompt).

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
| `conda` not recognized in VSCode terminal (PowerShell) | Switch the terminal type to **Command Prompt** (dropdown next to the `+` button at the top-right of the terminal > Command Prompt) |
| `conda` not recognized in Command Prompt either | Follow the manual PATH registration steps in Step 2 to add conda paths, then restart VSCode |
| PowerShell error when running `conda activate` | PowerShell execution policy issue. Open PowerShell **as Administrator** and run:<br>`Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`<br>Then run `conda init powershell` and restart VSCode |
| PowerShell shows `cannot be loaded because running scripts is disabled` | Same as the execution policy fix above |
| `conda` still not recognized after adding environment variables | Log out and back in, or restart the PC. Alternatively, switch the terminal type to Command Prompt |

### Python / Package Issues

| Symptom | Solution |
|---------|----------|
| `python` not recognized | Run `conda activate OOP` first |
| Interpreter not visible in VSCode | Restart VSCode and try again. If still missing, use "Enter interpreter path" to specify the path manually |
| `import pytest` fails | Run `conda activate OOP` then `conda install pytest -y` |
| System Python runs even after `conda activate OOP` | Run `where python` to check the path. The conda env path (`miniconda3\envs\OOP`) should appear at the top |

---

## References

This lab material is based on the following textbook:

- **Python Object-Oriented Programming, 4th Edition** — Steven F. Lott, Dusty Phillips (Packt Publishing)
- Original code repository: [PacktPublishing/Python-Object-Oriented-Programming---4th-edition](https://github.com/PacktPublishing/Python-Object-Oriented-Programming---4th-edition)
