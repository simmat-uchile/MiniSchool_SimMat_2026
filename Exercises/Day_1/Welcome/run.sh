#!/bin/bash
#SBATCH --job-name=Exer0
#SBATCH --partition=debug
#SBATCH -c 1 #numero de CPUs
#SBATCH --output=example.out
#SBATCH --error=example.err
#SBATCH --mem=1500
#SBATCH -t 0-00:05:00
#SRUN --export=ALL

ml miniconda3
source $(conda info --base)/etc/profile.d/conda.sh
conda activate pyprocar-env

python particle_in_box.py
