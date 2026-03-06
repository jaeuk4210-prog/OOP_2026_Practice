#!/bin/bash
# ==============================================================
#  OOP 2026 - One-click Environment Setup (macOS)
#
#  This script:
#    1. Downloads and installs Miniconda
#    2. Initializes conda in shell profile
#    3. Creates conda env (OOP) and installs packages
#    4. Git clones the practice repository
#    5. Runs environment verification tests
#
#  Usage:
#    bash setup_macos.sh
#    (or: chmod +x setup_macos.sh && ./setup_macos.sh)
# ==============================================================

# Do NOT use set -e: many check commands intentionally return non-zero

echo ""
echo "=================================================="
echo "  OOP 2026 Environment Setup (macOS)"
echo "=================================================="
echo ""

# ---- Configuration ----
ENV_NAME="OOP"
PYTHON_VER="3.9"
REPO_URL="https://github.com/ElionLAB/OOP_2026_Practice.git"
WORK_DIR="$HOME/OOP_2026_Practice"

# Temp dir fallback (some systems don't set $TMPDIR)
TMP_DIR="${TMPDIR:-/tmp}"

# ---- Detect existing conda installation ----
INSTALL_DIR=""

# Priority: miniconda3 > anaconda3 > homebrew conda
if [ -f "$HOME/miniconda3/bin/conda" ]; then
    INSTALL_DIR="$HOME/miniconda3"
elif [ -f "$HOME/anaconda3/bin/conda" ]; then
    INSTALL_DIR="$HOME/anaconda3"
elif [ -f "$HOME/opt/miniconda3/bin/conda" ]; then
    INSTALL_DIR="$HOME/opt/miniconda3"
elif [ -f "$HOME/opt/anaconda3/bin/conda" ]; then
    INSTALL_DIR="$HOME/opt/anaconda3"
elif [ -f "/opt/homebrew/Caskroom/miniconda/base/bin/conda" ]; then
    INSTALL_DIR="/opt/homebrew/Caskroom/miniconda/base"
elif command -v conda >/dev/null 2>&1; then
    # conda is on PATH already (e.g., Homebrew or custom install)
    INSTALL_DIR="$(conda info --base 2>/dev/null)"
fi

# Default install path for fresh install
if [ -z "$INSTALL_DIR" ]; then
    INSTALL_DIR="$HOME/miniconda3"
fi

CONDA_EXE="$INSTALL_DIR/bin/conda"
ENV_PYTHON="$INSTALL_DIR/envs/$ENV_NAME/bin/python"

# ---- Detect architecture ----
ARCH=$(uname -m)
if [ "$ARCH" = "arm64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
else
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
fi

# ---- Detect shell and profile ----
CURRENT_SHELL="$(basename "$SHELL")"

detect_profile() {
    case "$CURRENT_SHELL" in
        zsh)
            # zsh reads .zshrc for interactive shells
            echo "$HOME/.zshrc"
            ;;
        bash)
            # macOS bash reads .bash_profile for login shells
            if [ -f "$HOME/.bash_profile" ]; then
                echo "$HOME/.bash_profile"
            elif [ -f "$HOME/.bashrc" ]; then
                echo "$HOME/.bashrc"
            else
                echo "$HOME/.bash_profile"
            fi
            ;;
        fish)
            echo "$HOME/.config/fish/config.fish"
            ;;
        *)
            # Fallback: try .profile
            echo "$HOME/.profile"
            ;;
    esac
}

PROFILE="$(detect_profile)"

# ==============================================================
#  Step 1: Install Miniconda
# ==============================================================
echo "[1/5] Checking Miniconda..."

if [ -f "$CONDA_EXE" ]; then
    echo "      - Found conda at: $INSTALL_DIR"
    echo "      - Skipping installation."
else
    echo "      - No conda installation found."
    echo "      - Architecture: $ARCH"
    echo "      - Downloading Miniconda..."

    INSTALLER="$TMP_DIR/Miniconda3-latest-MacOSX.sh"
    if ! curl -fsSL -o "$INSTALLER" "$MINICONDA_URL"; then
        echo "[ERROR] Download failed. Check your internet connection."
        exit 1
    fi

    echo "      - Installing Miniconda to $INSTALL_DIR ..."
    if ! bash "$INSTALLER" -b -p "$INSTALL_DIR"; then
        echo "[ERROR] Miniconda installation failed."
        rm -f "$INSTALLER"
        exit 1
    fi
    rm -f "$INSTALLER"
    echo "      - Done."
fi

# ==============================================================
#  Step 2: Initialize conda in shell
# ==============================================================
echo ""
echo "[2/5] Initializing conda..."

# Make conda available in this session
if ! eval "$("$CONDA_EXE" shell.bash hook 2>/dev/null)"; then
    # Fallback: add to PATH directly
    export PATH="$INSTALL_DIR/bin:$PATH"
fi

VER=$("$CONDA_EXE" --version 2>&1) || true
if [ -z "$VER" ]; then
    echo "[ERROR] conda is not working. Check installation at: $INSTALL_DIR"
    exit 1
fi
echo "      - $VER"
echo "      - Shell: $CURRENT_SHELL"
echo "      - Profile: $PROFILE"

# Create profile file if it doesn't exist
if [ ! -f "$PROFILE" ]; then
    echo "      - Creating $PROFILE ..."
    touch "$PROFILE"
fi

# Check if conda init block already exists in profile
if grep -q "conda initialize" "$PROFILE" 2>/dev/null; then
    echo "      - conda already initialized in $PROFILE."
else
    echo "      - Running conda init ($CURRENT_SHELL)..."
    if "$CONDA_EXE" init "$CURRENT_SHELL" > /dev/null 2>&1; then
        echo "      - Added conda to $PROFILE."
    else
        # Fallback: manually add PATH export
        echo "      - conda init failed. Adding PATH manually..."
        echo "" >> "$PROFILE"
        echo "# >>> conda (added by OOP setup script) >>>" >> "$PROFILE"
        echo "export PATH=\"$INSTALL_DIR/bin:\$PATH\"" >> "$PROFILE"
        echo "# <<< conda <<<" >> "$PROFILE"
        echo "      - Added PATH export to $PROFILE."
    fi
fi

# Also init for zsh if user's shell is zsh but we're running in bash
if [ "$CURRENT_SHELL" = "zsh" ]; then
    if [ -f "$HOME/.zshrc" ] && ! grep -q "conda initialize" "$HOME/.zshrc" 2>/dev/null; then
        "$CONDA_EXE" init zsh > /dev/null 2>&1 || true
    fi
fi

# ==============================================================
#  Step 3: Conda env + packages
# ==============================================================
echo ""
echo "[3/5] Setting up conda env ($ENV_NAME)..."

# Accept conda ToS for default channels (required since conda 26.x)
for ch in \
    "https://repo.anaconda.com/pkgs/main" \
    "https://repo.anaconda.com/pkgs/r"; do
    "$CONDA_EXE" tos accept --override-channels --channel "$ch" 2>/dev/null || true
done

# Create env if it doesn't exist
if [ -f "$ENV_PYTHON" ]; then
    echo "      - Env already exists."
else
    echo "      - Creating env (Python $PYTHON_VER)..."
    if ! "$CONDA_EXE" create -n "$ENV_NAME" python="$PYTHON_VER" -y -q; then
        echo "[ERROR] Failed to create conda env."
        exit 1
    fi
    # Verify
    if [ ! -f "$ENV_PYTHON" ]; then
        echo "[ERROR] Env created but python not found. Something went wrong."
        exit 1
    fi
fi

# Core packages
if "$CONDA_EXE" run -n "$ENV_NAME" python -c "import pytest, bs4, PIL" 2>/dev/null; then
    echo "      - Core packages already installed."
else
    echo "      - Installing packages (beautifulsoup4, pytest, pillow, ipykernel)..."
    if ! "$CONDA_EXE" install -n "$ENV_NAME" beautifulsoup4 pytest pillow ipykernel -y -q; then
        echo "[ERROR] Package installation failed."
        exit 1
    fi
fi

# git (install in conda env so we don't depend on Xcode CLT)
if "$CONDA_EXE" run -n "$ENV_NAME" git --version >/dev/null 2>&1; then
    echo "      - git already installed."
else
    echo "      - Installing git..."
    "$CONDA_EXE" install -n "$ENV_NAME" git -y -q || true
fi

# tox
if "$CONDA_EXE" run -n "$ENV_NAME" python -c "import tox" 2>/dev/null; then
    echo "      - tox already installed."
else
    echo "      - Installing tox..."
    "$CONDA_EXE" run -n "$ENV_NAME" pip install tox -q || true
fi

# Jupyter kernel
echo "      - Registering Jupyter kernel..."
"$CONDA_EXE" run -n "$ENV_NAME" python -m ipykernel install --user \
    --name "$ENV_NAME" --display-name "Python 3 (OOP)" > /dev/null 2>&1 || true

# ==============================================================
#  Step 4: Clone repository
# ==============================================================
echo ""
echo "[4/5] Cloning repository..."

# Use conda env git first, then system git as fallback
GIT_CMD="$INSTALL_DIR/envs/$ENV_NAME/bin/git"
if [ ! -f "$GIT_CMD" ]; then
    # Check if system git exists WITHOUT triggering Xcode CLT dialog
    if [ -f "/usr/bin/git" ] && [ -f "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
        GIT_CMD="/usr/bin/git"
    elif command -v git >/dev/null 2>&1 && ! xcode-select -p >/dev/null 2>&1; then
        # git exists but Xcode CLT not installed - might trigger dialog
        # Try to use conda git from base env or skip
        if [ -f "$INSTALL_DIR/bin/git" ]; then
            GIT_CMD="$INSTALL_DIR/bin/git"
        else
            echo "      - Installing git via conda (avoiding Xcode CLT prompt)..."
            "$CONDA_EXE" install -n "$ENV_NAME" git -y -q 2>/dev/null || true
            GIT_CMD="$INSTALL_DIR/envs/$ENV_NAME/bin/git"
        fi
    elif command -v git >/dev/null 2>&1; then
        GIT_CMD="git"
    else
        echo "[ERROR] git not available. Install Xcode CLT: xcode-select --install"
        exit 1
    fi
fi

if [ -d "$WORK_DIR/.git" ]; then
    echo "      - Repository exists. Pulling latest..."
    cd "$WORK_DIR"
    "$GIT_CMD" pull origin main 2>&1 || true
    cd - > /dev/null
elif [ -d "$WORK_DIR" ]; then
    echo "      - Folder exists but not a git repo."
    echo "        Check: $WORK_DIR"
else
    echo "      - Cloning..."
    if ! "$GIT_CMD" clone "$REPO_URL" "$WORK_DIR"; then
        echo "[ERROR] Git clone failed."
        exit 1
    fi
fi

# ==============================================================
#  Step 5: Run tests
# ==============================================================
echo ""
echo "[5/5] Running tests..."
echo ""

cd "$WORK_DIR"
"$CONDA_EXE" run -n "$ENV_NAME" python tests/test_setup.py
TEST_RESULT=$?
cd - > /dev/null

echo ""
if [ "$TEST_RESULT" -eq 0 ]; then
    echo "=================================================="
    echo "  Setup completed successfully."
    echo "=================================================="
    echo ""
    echo "  Next steps:"
    echo "    1. Open folder in VSCode: $WORK_DIR"
    echo "    2. Cmd+Shift+P > Python: Select Interpreter"
    echo "       Select: Python 3.9.x ('OOP': conda)"
    echo "    3. In terminal: conda activate OOP"
    echo ""
    echo "  * Restart your terminal or run: source $PROFILE"
else
    echo "=================================================="
    echo "  Setup finished but some tests failed."
    echo "  Check the output above."
    echo "=================================================="
fi
echo ""
