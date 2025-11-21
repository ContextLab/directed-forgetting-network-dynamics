# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a neuroscience research project analyzing network dynamics underlying contextually mediated intentional forgetting. The project uses fMRI data and includes:
- Network analysis using Jupyter notebooks
- NIFTI neuroimaging data processing
- Factor analysis with radial basis functions (RBF)
- Schaefer brain parcellation atlases (100-1000 parcels)

## Environment Setup

**Python version:** 3.10 (conda environment recommended)

**Environment name:** `directed-forgetting`

### Initial setup:
```bash
conda create --name directed-forgetting python=3.10
conda activate directed-forgetting
conda install -c anaconda ipykernel jupyter
python -m ipykernel install --user --name=directed-forgetting
cd code
jupyter notebook
```

### Running notebooks:
1. Always verify the kernel is set to `directed-forgetting` (shown in top right)
2. Change kernel via: Kernel → Change kernel → directed-forgetting
3. Run all cells: Kernel → Restart & Run All

## Dependency Management

This project uses **davos** for automatic dependency management in notebooks. Dependencies are auto-installed on first run, so there's no traditional requirements.txt file.

Key libraries used:
- numpy, pandas
- nibabel (NIFTI neuroimaging format)
- nilearn (neuroimaging ML)
- Various neuroimaging and visualization tools

## Repository Structure

```
code/
  ├── network_analyses.ipynb    # Main analysis notebook
  ├── helpers.py                # Core utility functions
  ├── dffr_preprocess.sh        # FSL preprocessing pipeline (historical)
  ├── clusters/                 # Brain parcellation atlases (NIFTI files)
  └── data/                     # Preprocessed data (NPZ files)

data/
  ├── DFFR/                     # Raw fMRI data (gitignored, downloaded from Dropbox)
  ├── networks/                 # Schaefer parcellation atlases and labels
  ├── regressors/               # Task regressors
  ├── scratch/                  # Temporary outputs (gitignored)
  └── behavior.csv              # Behavioral data

paper/
  ├── figs/source/              # Generated figures (output directory)
  └── main.tex                  # LaTeX manuscript
```

## Core Architecture

### Data Format: CMU Format
The project uses a custom "CMU format" for fMRI data manipulation:
- **Y**: timepoints × voxels matrix (fMRI timeseries)
- **R**: voxels × 3 matrix (voxel spatial coordinates in MNI space)

Key conversion functions in `helpers.py`:
- `nii2cmu()`: NIFTI → CMU format with optional masking
- `cmu2nii()`: CMU format → NIFTI (requires template)

### Factor Analysis Framework
The project implements a spatial factor analysis approach:
- `get_factors()`: Creates RBF-based spatial factors from center coordinates
- `get_weights()`: Calculates temporal weights via ridge regression or OLS
  - Default: ridge regression (regularization parameter β = var(data))

### File Paths (helpers.py)
All paths are constructed relative to the repository root:
```python
basedir = os.path.split(os.getcwd())[0]  # Assumes code/ is CWD
datadir = os.path.join(basedir, 'data')
figdir = os.path.join(basedir, 'paper', 'figs', 'source')
```

## Data Pipeline

1. **Raw data** (DFFR.zip) is downloaded from Dropbox URL in `helpers.py`
2. **Preprocessing** was done with FSL (see `dffr_preprocess.sh`) - historical reference only
3. **Preprocessed data** is stored as NPZ files in `code/data/`:
   - `preprocessed.npz`: Full preprocessed timeseries
   - `masked.npz`: Gray-matter masked data
4. **Analysis** happens in `network_analyses.ipynb`
5. **Figures** are saved to `paper/figs/source/`

## FSL Preprocessing Pipeline (Historical)

The `dffr_preprocess.sh` script documents the original FSL preprocessing:
1. Skull stripping (BET)
2. Registration to MNI152 2mm standard space
3. Gray matter segmentation (FAST)
4. Motion correction (MCFLIRT)
5. Application of gray matter mask to functional data

**Note:** This script requires FSL installation and was run on raw data. Current work uses the preprocessed outputs.

## Development Notes

- **Working directory assumption:** Scripts/notebooks assume you're in the `code/` directory
- **Figure output:** All generated figures go to `paper/figs/source/`
- **Scratch space:** Temporary files use `data/scratch/` (gitignored except .pkl files are listed)
- **Brain atlases:** Multiple Schaefer parcellations available in `code/clusters/` and `data/networks/`
- **Data downloads:** Raw DFFR data downloads automatically via davos from the Dropbox URL
