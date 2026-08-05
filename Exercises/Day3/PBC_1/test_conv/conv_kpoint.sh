#!/bin/bash
#---------------SBATCH Script for K-point Convergence----------------
#SBATCH -J K_Conv_Test
#SBATCH -p general                   # Partition to submit to
#SBATCH --reservation=simmat
#SBATCH -n 1
#SBATCH --ntasks-per-node=1
#SBATCH -c 2                      # Requesting 4 cores is sufficient for these calculations
#SBATCH --mem-per-cpu=2000
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=your_email@example.com # Change to your email
#SBATCH -o kpoints_%j.out
#SBATCH -e kpoints_%j.err

#-----------------Toolchain & Modules---------------------------
ml purge
ml intel/2022.00
ml VASP-VTST/6.2.1

# ----------------Environment Variables--------------------------
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MKL_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MKL_DYNAMIC=FALSE

echo "Starting K-point convergence test on $SLURM_NODELIST with $SLURM_CPUS_PER_TASK cores."

# --- START OF THE CONVERGENCE SCRIPT ---

# 1. File to save results
OUTPUT_FILE="k_convergence.txt"

# 2. Command to run VASP
VASP_COMMAND="vasp_std"

# 3. Write the header for the results file
echo "# K-point Grid    Energy(eV)" > $OUTPUT_FILE

# 4. Loop through multipliers 1, 2, 3, and 4
for i in 1 2 3 4; do
  
  # Calculate grid dimensions
  k1=$(($i * 4))
  k2=$(($i * 4))
  k3=$(($i * 3))
  
  GRID="${k1}x${k2}x${k3}"
  echo "--- Calculating for K-point grid: $GRID ---"
  
  # Create a directory for this calculation
  DIR_NAME="K_${GRID}"
  mkdir -p $DIR_NAME
  
  # Copy base files (make sure INCAR has a converged ENCUT)
  cp POSCAR POTCAR INCAR $DIR_NAME
  
  # Create the KPOINTS file for this grid
  cat <<EOF > ${DIR_NAME}/KPOINTS
Automatic mesh
0
Monkhorst-Pack
$k1 $k2 $k3
0 0 0
EOF

  # Change into the calculation directory
  cd $DIR_NAME
  
  # Run VASP
  srun $VASP_COMMAND
  
  # Extract the final energy from the OUTCAR
  ENERGY=$(grep "free  energy" OUTCAR | tail -1 | awk '{print $5}')
  
  # Write the result to the output file (which is in the parent directory)
  if [ -n "$ENERGY" ]; then
    printf "%-15s %s\n" "$GRID" "$ENERGY" >> ../$OUTPUT_FILE
  else
    printf "%-15s %s\n" "$GRID" "ERROR" >> ../$OUTPUT_FILE
  fi

  # Return to the original directory
  cd ..

done

echo "✅ K-point convergence process finished. Check the '$OUTPUT_FILE' file."
