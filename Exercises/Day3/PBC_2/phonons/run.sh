#!/bin/bash
#SBATCH -J QE
#SBATCH -p general
#SBATCH --reservation=simmat
#SBATCH -n 4
#SBATCH --ntasks-per-node=4  
#SBATCH --mem-per-cpu=1000 
#SBATCH -o %j_%x.out
#SBATCH -e %j_%x.err
#SBATCH --time=00:25:00           # Time limit (HH:MM:SS)

ml purge 
ml intel-compilers/2022.0.1  
ml impi/2021.5.0
ml  QuantumESPRESSO/7.2

srun pw.x < scf.in > scf.out
srun ph.x < ph.in > ph.out
srun q2r.x < q2r.in > q2r.out
srun matdyn.x < phband.in >phband.out
