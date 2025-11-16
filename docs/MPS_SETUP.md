# macOS MPS / Metal setup for DeepFace (Apple Silicon)

This document explains how to create an isolated Python environment on macOS (Apple Silicon) and install the packages needed to run DeepFace with hardware acceleration via TensorFlow-Metal and PyTorch MPS.

Important notes
- Use a dedicated virtual environment (venv or conda/mamba). Installing system-wide or into an existing env with conflicting packages will cause the dependency conflicts you saw (numpy, keras, typing-extensions, protobuf, tensorboard).
- We install `tensorflow-macos` and `tensorflow-metal` via pip. For PyTorch MPS, use the PyTorch metal wheel index. Install PyTorch *before* packages that pull a different numpy/typing-extensions.

Recommended steps (venv)

1) Create and activate a venv (zsh):

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
```

2) Install TensorFlow macOS (TensorFlow + Metal plugin):

```bash
pip install tensorflow-macos==2.13.1 tensorflow-metal==0.7.0
```

Note: tensorflow-macos 2.13.1 requires numpy<=1.24.3 and keras<2.14; the `requirements-macos-mps.txt` pins compatible versions.

3) Install PyTorch (Metal) - use the official PyTorch metal index. Pick the latest torch version that supports your macOS and Python.

```bash
pip install --index-url https://download.pytorch.org/whl/metal.html torch torchvision torchaudio
```

If pip cannot find a compatible wheel ("No matching distribution"), that usually means one of:
- Your Python version isn't supported (torch metal wheels typically require Python 3.8 - 3.11; check which versions are provided).
- You're on Intel macOS (metal wheels are for Apple Silicon) or the wheel index doesn't have a build for your exact platform.

If that happens, either:
- Switch to a supported Python (create a venv/conda with python 3.10 or 3.11), or
- Use conda/mamba with `pytorch` from `pytorch` channel if available for your platform.

Example conda/mamba approach (recommended if pip wheel missing):

```bash
conda create -n deepface-mps python=3.10 -y
conda activate deepface-mps
# install pip first
python -m pip install --upgrade pip
# then install tensorflow-macos+metal via pip
pip install tensorflow-macos==2.13.1 tensorflow-metal==0.7.0
# and try PyTorch wheel via pip index
pip install --index-url https://download.pytorch.org/whl/metal.html torch torchvision torchaudio
```

4) Install the project's macOS-friendly requirements (this file purposefully omits tensorflow and torch):

```bash
pip install -r requirements-macos-mps.txt
```

5) Install other optional packages (ultralytics, retina-face, mtcnn) after torch/tf

```bash
pip install ultralytics
pip install retina-face mtcnn
```

6) Install the package in editable mode:

```bash
pip install -e .
```

Verification

Python checks to run inside the activated venv:

```python
import torch
print('torch:', torch.__version__, 'device_mps:', torch.backends.mps.is_available())

import tensorflow as tf
print('tf built with cuda:', tf.test.is_built_with_cuda())
print('tf devices:', tf.config.list_physical_devices())
```

If `torch` import fails with "No matching distribution found for torch", recreate the environment with a supported Python version (3.10 / 3.11). If `torch` imports but `mps` is False, your platform may not be Apple Silicon or the wheel is not a metal build.

Troubleshooting
- If you see numpy/keras/typing-extensions conflicts, check for preinstalled packages in the environment. Create a fresh venv or conda env and follow the steps strictly.
- If ultralytics triggers dependency conflicts, install it after `tensorflow-macos` and `torch` so pip can choose compatible versions.
