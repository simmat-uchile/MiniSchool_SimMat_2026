#!/bin/bash
# ----------------SLURM Parameters----------------
#SBATCH -p general 
#SBATCH --reservation=simmat
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1 
#SBATCH --mem-per-cpu=3000
#SBATCH -t 1:00:00
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err

#-----------------Toolchain---------------------------
ml purge
ml gcc/14.2.0-nlhpc  openmpi/4.1.8-zen4-j
# ----------------Modulos----------------------------
ml vasp/6.6.0-mpi-zen4-o
# ----------------Comando--------------------------
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export MKL_DYNAMIC=FALSE

srun vasp_gam

