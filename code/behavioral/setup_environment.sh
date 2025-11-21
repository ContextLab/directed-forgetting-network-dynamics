#!/bin/bash

# Setup script for directed forgetting behavioral analysis
# This script is idempotent - safe to run multiple times

set -e  # Exit on error

echo "=========================================="
echo "Directed Forgetting Behavioral Analysis"
echo "Environment Setup Script"
echo "=========================================="
echo ""

# Environment name
ENV_NAME="directed-forgetting-behavioral"

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "Conda not found. Installing Miniconda..."

    # Detect OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        ARCH=$(uname -m)
        if [[ "$ARCH" == "arm64" ]]; then
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh"
        else
            MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    else
        echo "Unsupported operating system: $OSTYPE"
        echo "Please install conda manually from https://docs.conda.io/en/latest/miniconda.html"
        exit 1
    fi

    # Download and install Miniconda
    MINICONDA_SCRIPT="/tmp/miniconda_installer.sh"
    echo "Downloading Miniconda from $MINICONDA_URL..."
    curl -L -o "$MINICONDA_SCRIPT" "$MINICONDA_URL"

    echo "Installing Miniconda..."
    bash "$MINICONDA_SCRIPT" -b -p "$HOME/miniconda3"

    # Initialize conda
    echo "Initializing conda..."
    "$HOME/miniconda3/bin/conda" init bash

    # Source the conda setup
    source "$HOME/miniconda3/etc/profile.d/conda.sh"

    # Clean up
    rm "$MINICONDA_SCRIPT"

    echo "Miniconda installed successfully!"
else
    echo "✓ Conda is already installed"
    # Make sure conda is available in this script
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        source "$HOME/miniconda3/etc/profile.d/conda.sh"
    elif [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        source "$HOME/anaconda3/etc/profile.d/conda.sh"
    fi
fi

echo ""

# Check if environment already exists
if conda env list | grep -q "^${ENV_NAME} "; then
    echo "✓ Environment '$ENV_NAME' already exists"
    echo "  Activating existing environment..."
else
    echo "Creating new conda environment: $ENV_NAME"
    echo "  Python version: 3.10"
    conda create -y --name "$ENV_NAME" python=3.10
    echo "✓ Environment created successfully"
fi

# Activate the environment
echo ""
echo "Activating environment: $ENV_NAME"
conda activate "$ENV_NAME"

# Install/update required packages
echo ""
echo "Installing/updating required packages..."
echo "  This may take a few minutes..."

# Install packages using conda where available (faster and more reliable)
conda install -y -c conda-forge \
    numpy \
    pandas \
    matplotlib \
    seaborn \
    jupyter \
    ipykernel

# Install mat73 using pip (not available in conda)
pip install -q mat73

echo "✓ All packages installed successfully"

# Add the kernel to Jupyter
echo ""
echo "Adding kernel to Jupyter..."
python -m ipykernel install --user --name="$ENV_NAME" --display-name="Python (directed-forgetting-behavioral)"
echo "✓ Jupyter kernel added"

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "To use this environment:"
echo "  1. Activate it: conda activate $ENV_NAME"
echo "  2. Start Jupyter: jupyter notebook"
echo "  3. Open: serial_position_analysis.ipynb"
echo "  4. Select kernel: 'Python (directed-forgetting-behavioral)'"
echo ""
echo "To deactivate: conda deactivate"
echo "To remove: conda env remove --name $ENV_NAME"
echo ""
