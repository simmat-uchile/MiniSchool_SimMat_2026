#!/bin/bash
#---------------SBATCH Script for a VASP Calculation----------------
#SBATCH -J MyVaspJob              # Job name
#SBATCH -p general                   # Partition to submit to
#SBATCH --reservation=simmat
#SBATCH -n 1                      # Total number of tasks
#SBATCH --ntasks-per-node=1       # Tasks per node
#SBATCH -c 2                     # Cores per task (adjust as needed)
#SBATCH --mem=1G                 # Memory allocated (adjust as needed)
#SBATCH --time=00:15:00           # Time limit (HH:MM:SS)
#SBATCH --mail-type=END,FAIL      # Email notifications
#SBATCH --mail-user=your_email@example.com # Your email address
#SBATCH -o job_%j.out
#SBATCH -e job_%j.err

#-----------------Toolchain & Modules---------------------------
echo "Loading modules..."
ml purge
ml intel/2022.00
ml VASP-VTST/6.2.1

# ----------------Environment Variables--------------------------
# Automatically set threads to match the number of cores requested
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MKL_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MKL_DYNAMIC=FALSE

# ----------------Execution--------------------------------------
echo "Starting VASP calculation on node $SLURM_NODELIST with $SLURM_CPUS_PER_TASK cores."
echo "Start time: $(date)"

# Run VASP
srun vasp_std

echo "End time: $(date)"
echo "✅ VASP calculation finished."
