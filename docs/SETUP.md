# Setup Guide

1) Create and activate a venv (zsh):

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
```

2) Install requirements:

```
pip install -r requirements-macos-mps.txt
```

3) Install the package in editable mode:

```bash
pip install -e .
```

4) Run project

```
python3 deepface/api/src/api.py
```