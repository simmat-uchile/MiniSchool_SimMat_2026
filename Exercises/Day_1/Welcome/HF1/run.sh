#!/bin/bash
#SBATCH --job-name=G09
#SBATCH --partition=general
#SBATCH -c 2 #numero de CPUs
#SBATCH --output=example.out
#SBATCH --error=example.err
#SBATCH --mem=1500
#SRUN --export=ALL
#SBATCH -t 0-00:20:00

ml intel/2019b 
ml g09/D01

g09 He.gjf > He.log #linea descomentada

