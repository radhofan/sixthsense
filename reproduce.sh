#!/usr/bin/env bash

# Install Miniconda
curl -fsSL https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o miniconda.sh
bash miniconda.sh -b -p $HOME/miniconda

# Set environment variables
export PATH="$HOME/miniconda/bin:$PATH"
export MAMBA_ROOT_PREFIX="$HOME/miniconda"

# Install Mamba
conda install -c conda-forge mamba -y

# Initialize Mamba shell
mamba shell init --shell=bash
source ~/.bashrc  # Reload shell config
eval "$(mamba shell hook --shell=bash)"

# Create and activate 'flex' environment
mamba install python=3.12 -c conda-forge
mamba activate sixthsense

# Installation
pip install -r sixthsense/requirements.txt
mkdir -p sixthsense/plots sixthsense/models sixthsense/results

# Download csvs
wget -O sixthsense/csvs/csvs.tar.gz "https://zenodo.org/record/6388301/files/csvs.tar.gz?download=1"
tar -xzvf sixthsense/csvs/csvs.tar.gz -C sixthsense/csvs --strip-components=1

# Run SixthSense
python sixthsense/train.py -f sixthsense/csvs/lrm_features.csv -l sixthsense/csvs/lrm_metrics.csv -a rf -m rhat_min -suf avg -bw -plt -saveas sixthsense/plots/results_rhat_min_lrm.png -keep _ast_ dt_ var_min var_max data_size -st -tname lightspeed -cv -ignore_vi






