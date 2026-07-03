#!/bin/zsh

source "$HOME/miniconda3/etc/profile.d/conda.sh"
conda activate seurat
export RSTUDIO_WHICH_R="$CONDA_PREFIX/bin/R"
open -na "RStudio"
