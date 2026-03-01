"""A simple script demonstrating environment validation."""

import sys


def verify_environment():
    version = sys.version_info
    print(f"Python Version: {version.major}.{version.minor}")
    print(f"Executable Path: {sys.executable}")


if __name__ == "__main__":
    verify_environment()
