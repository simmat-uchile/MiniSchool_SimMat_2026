#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p general 
##SBATCH --reservation=simmat
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4  
#SBATCH --mem-per-cpu=1000
#SBATCH -t 1:00:00
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#-----------------Toolchain---------------------------
ml purge
ml intel/2019b
# ----------------Módulos-----------------------------
ml g16/B.01
# ----------------Comandos--------------------------
export OMP_NUM_THREADS=1

export GAUSS_SCRDIR=/tmp/$SLURM_JOBID
mkdir -p $GAUSS_SCRDIR

# Assign variables from command line arguments
INPUT_FILE=$1

# Execute Gaussian using the provided argument
srun g16 "$INPUT_FILE"

# Clean up scratch directory after job finishes
rm -rf $GAUSS_SCRDIR
