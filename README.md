# Network dynamics underlying contextually mediated intentional forgetting

This repository contains data and code used to produce the paper ["_Network dynamics underlying contextually mediated intentional forgetting_"](https://www.context-lab.com/publications) by Megan Liu and Jeremy R. Manning. The repository is organized as follows:

```
root
└── code : all code used in the paper
    └── notebooks : jupyter notebooks for paper analyses
└── data : all data used in the paper
    ├── raw : raw data before processing
    └── processed : all processed data
└── paper : all files to generate paper
    └── figs : pdf copies of each figure
```

Our project uses [davos](https://github.com/ContextLab/davos) to improve shareability and compatability across systems.

# Setup instructions

Note: we have tested these instructions on MacOS and Ubuntu (Linux) systems.  We *think* they are likely to work on Windows systems too, but we haven't explicitly verified Windows compatability.

We recommend running all of the analyses in a fresh Python 3.10 conda environment.  To set up your environment:
  1. Install [Anaconda](https://www.anaconda.com/)
  2. Clone this repository by running the following in a terminal: `git clone https://github.com/ContextLab/directed-forgetting-network-dynamics.git`  
  3. Create a new (empty) virtual environment by running the following (in the terminal): `conda create --name directed-forgetting python=3.10` (follow the prompts)
  4. Navigate (in terminal) to the activate the virtual environment (`conda activate directed-forgetting`)
  5. Install support for jupyter notebooks (`conda install -c anaconda ipykernel jupyter`) and then add the new kernel to your notebooks (`python -m ipykernel install --user --name=directed-forgetting`).  Follow any prompts that come up (accepting the default options should work).
  6. Navigate to the `code` directory (`cd code`) in terminal
  7. Start a notebook server (`jupyter notebook`) and click on the notebook you want to run in the browser window that comes up.  The `network_analyses.ipynb` notebook is a good place to start.  Selecting "Restart & Run All" from the "Kernel" menu will automatically run all cells.
  8. When you're running the notebooks, always make sure the notebook kernel is set to `directed-forgetting` (indicated in the top right).  If not, in the `Kernel` menu at the top of the notebook, select "Change kernel" and then "directed-forgetting".
  9. To stop the server, send the "kill" command in terminal (e.g., `ctrl` + `c` on a Mac or Linux system).
  10. To "exit" the virtual environment, type `conda deactivate`.

Notes:
- After setting up your environment for the first time, you can skip steps 1, 2, 3, and 5 when you wish to re-enter the analysis environment in the future.
- To run any notebook:
  - Select the desired notebook from the Jupyter "Home Page" menu to open it in a new browser tab
  - Verify that the notebook is using the `directed-forgetting` kernel, using the above instructions to adjust the kernel if needed.
  - Select "Kernel" $\rightarrow$ "Restart & Run All" to execute all of the code in the notebook.

To remove the `directed-forgetting` environment from your system, run `conda remove --name directed-forgetting --all` in the terminal and follow the prompts.  (If you remove the `directed-forgetting` environment, you will need to repeat the initial setup steps if you want to re-run any of the code in the repository.)

Each notebook contains embedded documentation that describes what the various code blocks do.  Any figures you generate will end up in `paper/figs/source`.  Statistical results are printed directly inside each notebook when you run it.