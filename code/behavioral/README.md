# Directed Forgetting: Behavioral Data Analysis

This standalone package contains behavioral data and analysis code from a directed forgetting experiment.

## Overview

In this experiment, participants:
1. Studied **List 1** (a series of words)
2. Received a memory cue: either **"Remember"** or **"Forget"**
3. Studied **List 2** (another series of words)
4. Attempted to recall all words from both lists

## Contents

```
behavioral/
├── README.md                       # This file
├── setup_environment.sh            # Automated environment setup script
├── behavioral_data.pkl             # Behavioral data (24 participants)
├── serial_position_analysis.ipynb  # Jupyter notebook for analysis
└── extract_behavioral_data.py      # Data extraction script (optional)
```

## Quick Start

### 1. Setup Environment

Run the setup script to automatically install all dependencies:

```bash
./setup_environment.sh
```

This script will:
- Install conda if needed (Miniconda)
- Create a conda environment with Python 3.10
- Install all required packages (numpy, pandas, matplotlib, seaborn, jupyter, mat73)
- Add a Jupyter kernel
- **It's idempotent**: safe to run multiple times

### 2. Run the Analysis

```bash
# Activate the environment
conda activate directed-forgetting-behavioral

# Start Jupyter notebook
jupyter notebook

# Open serial_position_analysis.ipynb
# Make sure kernel is set to "Python (directed-forgetting-behavioral)"
```

### 3. Explore the Data

The notebook walks through:
- Loading the behavioral data
- Visualizing serial position curves
- Comparing Remember vs. Forget conditions
- Computing summary statistics

## Data Format

### File: `behavioral_data.pkl`

Python pickle file containing a dictionary:

```python
{
    'participant_id': {
        'spc': array,           # Serial position curve data
        'cuetype': array,       # Cue types (0=Remember, 1=Forget)
        'recmats': array,       # Recall matrices
        'correct_recalls': ..., # Correct recall data
        # ... additional fields
    },
    # ... 24 participants total
}
```

### Key Data Fields

| Field | Type | Description |
|-------|------|-------------|
| `spc` | 2D array (lists × positions) | Serial position curve: probability of recalling word at each position |
| `cuetype` | 1D array | Cue type for each list (0 = Remember, 1 = Forget) |
| `recmats` | Array | Binary recall matrices (1 = recalled, 0 = not recalled) |
| `correct_recalls` | Array | Number of correct recalls per list |
| `reclist` | Array | Order in which items were recalled |
| `pfr` | Array | Probability of first recall |

### Loading the Data

```python
import pickle

# Load behavioral data
with open('behavioral_data.pkl', 'rb') as f:
    behavior = pickle.load(f)

# Access a participant's data
participant_id = list(behavior.keys())[0]
participant_data = behavior[participant_id]

# Get serial position curve
spc = participant_data['spc']  # Shape: (n_lists, n_positions)

# Get cue types
cues = participant_data['cuetype']  # 0 = Remember, 1 = Forget
```

### Example Analysis

```python
import numpy as np
import matplotlib.pyplot as plt

# Calculate average serial position curves by cue type
remember_lists = participant_data['cuetype'] == 0
forget_lists = participant_data['cuetype'] == 1

remember_spc = participant_data['spc'][remember_lists.ravel()].mean(axis=0)
forget_spc = participant_data['spc'][forget_lists.ravel()].mean(axis=0)

# Plot
plt.plot(remember_spc, label='Remember', marker='o')
plt.plot(forget_spc, label='Forget', marker='s')
plt.xlabel('Serial Position')
plt.ylabel('Recall Probability')
plt.legend()
plt.title('Serial Position Curves')
plt.show()
```

## Data Details

- **Number of participants**: 24
- **Excluded participants**: 2 (sync issues, ceiling performance)
- **Total participants in original study**: 26

### Cue Type Encoding

- `0` = **Remember** cue (participants instructed to remember List 1)
- `1` = **Forget** cue (participants instructed to forget List 1)

### Serial Position Curve

The serial position curve (`spc`) shows the probability of recalling a word based on its position in the study list.

- **Rows**: Individual study lists
- **Columns**: Serial positions (1, 2, 3, ...)
- **Values**: Recall probability (0.0 to 1.0)

## Requirements

- Python 3.10+
- numpy
- pandas
- matplotlib
- seaborn
- jupyter
- mat73

All dependencies are automatically installed by `setup_environment.sh`.

## Manual Installation

If you prefer not to use the setup script:

```bash
# Create conda environment
conda create -n directed-forgetting-behavioral python=3.10
conda activate directed-forgetting-behavioral

# Install packages
conda install -c conda-forge numpy pandas matplotlib seaborn jupyter ipykernel
pip install mat73

# Add Jupyter kernel
python -m ipykernel install --user --name=directed-forgetting-behavioral
```

## Troubleshooting

### "ModuleNotFoundError: No module named 'mat73'"

```bash
conda activate directed-forgetting-behavioral
pip install mat73
```

### "Kernel not found in Jupyter"

```bash
conda activate directed-forgetting-behavioral
python -m ipykernel install --user --name=directed-forgetting-behavioral
```

Then restart Jupyter and select the kernel from the top-right menu.

### Setup script fails on Windows

The setup script is designed for macOS and Linux. Windows users should:
1. Install Miniconda manually from https://docs.conda.io/en/latest/miniconda.html
2. Use the manual installation steps above

## Citation

If you use this data, please cite:

> Manning JR, Hulbert JC, Williams J, Piloto L, Sahakyan L, Norman KA (2016) A neural signature of contextually mediated intentional forgetting. Psychonomic Bulletin and Review, 23(5): 1534 - 1542.

Paper: [http://link.springer.com/content/pdf/10.3758%2Fs13423-016-1024-7.pdf](http://link.springer.com/content/pdf/10.3758%2Fs13423-016-1024-7.pdf)

## License

This data is shared for research and educational purposes.

## Contact

For questions about the data or analysis, please contact the corresponding author.

## Additional Resources

- Full paper: [Manning et al. (2016)](http://link.springer.com/content/pdf/10.3758%2Fs13423-016-1024-7.pdf)
