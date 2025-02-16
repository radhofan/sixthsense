### NOTE: THIS REPO IS INTENDED AS A REPRODUCIBLE PAPER EXPERIMENT AND IS INTENDED TO BE RAN INSIDE A TERMINAL IN EITHER TROVI/BINDER
### THIS README.MD MAY HAVE MORE INSTRUCTIONS THAN THE ORIGINAL REPO TO ENSURE PERFECT REPLICATION
### REPRODUCE THIS REPO IN TROVI VIA THIS LINK: https://chameleoncloud.org/experiment/share/7b5e006f-97de-4a5a-becb-5d265c1a92be
### REPRODUCE THIS REPO IN BINDER VIA THIS LINK: https://mybinder.org/ 
    - GitHub Repository : `https://github.com/radhofan/sixthsense.git`  
    - Notebook File : `reproduce.ipynb`
### ORIGINAL REPO LINK: https://github.com/uiuc-arc/sixthsense

## SixthSense

This repository contains the source code of our paper: [SixthSense:
Debugging Convergence Problems in Probabilistic
Programs via Program Representation Learning](https://saikatdutta.web.illinois.edu/papers/sixthsense-fase22.pdf) 
published at FASE 2022 conference.

## Set up Trovi Project (if using trovi) :

cd into correct working directory

Deactivate default conda trovi environment
```bash
conda deactivate
```

### Installation

SixthSense requires python 3.6 (at least). We recommend setting up a conda environment to run SixthSense. We have tested SixthSense on Ubuntu 18.04 64 bit.

Installation Steps:
- Install dependencies:
`pip install -r requirements.txt`
- Setup Directories:
`mkdir -p plots models results`
- Download the csv files from [Zenodo](https://zenodo.org/record/6388301)
-We will download the csvs and extract it here :
```bash
wget -O csvs/csvs.tar.gz "https://zenodo.org/record/6388301/files/csvs.tar.gz?download=1"
tar -xzvf csvs/csvs.tar.gz -C csvs --strip-components=1
```

### Running SixthSense

- We will use these settings for the sake of reproducing this paper, we will run for a model class and get prediction scores :

`python train.py -f csvs/lrm_features.csv -l csvs/lrm_metrics.csv -a rf -m rhat_min -suf avg -bw -plt -saveas plots/results_rhat_min_lrm.png -keep _ast_ dt_ var_min var_max data_size -st -tname lightspeed -cv -ignore_vi`

- To training SixthSense for a model class and get prediction scores, run :

`python train.py -f csvs/[classname]_features.csv -l csvs/[classname]_metrics.csv -a [ml algorithm] -m [metric] -suf avg -bw -plt -saveas plots/results_[metric]_[classname].png -keep _ast_ dt_ var_min var_max data_size -st -tname [model name] -cv -ignore_vi`

where `classname` is one of `lrm`, `timeseries`, or `mixture`;
`[ml algo]` should be `rf` for random forest;
`model name` is the name of the model, see `subcategories/[classname].json` for all model names.


- To train using runtime samples (Use `runtime` instead of `plt`):

 `python train.py -f csvs/[classname]_features.csv -l csvs/[classname]_metrics.csv -a [ml algorithm] -m [metric] -suf avg -bw -runtime -saveas plots/results_[metric]_[classname].png -keep _ast_ dt_ var_min var_max data_size -st -tname [model name] -cv -ignore_vi`

- To train using warmup samples (Use `-runtime`  and `-warmup` instead of `plt`):

`python train.py -f csvs/[classname]_features.csv -l csvs/[classname]_metrics.csv -a [ml algorithm] -m [metric] -suf avg -bw -runtime -warmup -saveas plots/results_[metric]_[classname].png -keep _ast_ dt_ var_min var_max data_size -st -tname [model name] -cv -ignore_vi`

To change the sampling/warmup iterations, change lines 730-738 in `train.py`.

This script will compute the prediction scores (F1/Precision/Recall/AUC) for the given model class keep the given model and its mutants in test set and other mutants in training set

After this script runs, prediction scores for all convergence thresholds will be printed on screen and saved in `results` folder, and the plot in `plots` folder

You can change the thresholds in `train.py` by changing the `thresholds` variable

- To get the important features of a program that contribute most to the prediction (to guide debugging):

`python train.py -f csvs/[classname]_features.csv -l csvs/[classname]_metrics.csv -a [ml algorithm] -m [metric] -suf avg -bw -th [threshold] -saveas plots/temp.png -keep _ast_ dt_ var_min var_max data_size -st -tname [model name] -ignore_vi --tree -special [prog_index]`

where `threshold` is one of `1.05`, `1.1`, `1.15`, or `1.2`;
`prog_index` is the index of program in the `[classname]_metrics.csv` files, e.g. `progs20200425-172437571193_prob_rand_7`;
`model name` is the name of the model for this program. It can be found in the `[classname]_features.csv` files, e.g. `naive-bayes-unsup`. Also, see `subcategories/[classname].json` for all model names.

The script will output the top 20 features that contribute most to the prediction, together with their contribution scores.

### Command Line Options

Options:
```
-f: features file path;
-l: metrics file path
-a: ml algorithm to run; options: rf (random forest), maj (majority)
-m: metric to use (from metrics file); options: rhat_min (gelman rubin diagnostic)
-suf: file suffix to use
-bw: enable balance by weight
-plt: evaluate with different metric threshold. For rhat, the thresholds are 1.05, 1.1, 1.15, and 1.2
-saveas: path for saving output plot
-keep: fields from feature files to keep
-st: split by model type: keep all mutants of a model type (e.g., lightspeed) in test set and train with remaining mutants
-tname: name of model type
-cv: do cross validation
--tree:  get feature contributions for the program specified by index (special)
--special: index of program for which to get feature contributions (use index from
the [classname]_metrics.csv files)
-runtime: Use runtime features from 10-60 sampling iterations. Can be changed in Lines 730-740.
-warmup: Use runtime features from warmup iterations 10-600. Can be changed in Lines 730-740.
```

All feature and metric files are in `csvs` folder.
