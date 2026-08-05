#!/bin/bash
#---------------SBATCH Script - NLHPC ----------------
#SBATCH -J ENCUT_Conv_Test
#SBATCH -p general                   # Partition to submit to
#SBATCH --reservation=simmat
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2000 # Adjust memory as needed
#SBATCH --mail-user=your_email@example.com # Change to your email
#SBATCH --mail-type=ALL
#SBATCH -o convergence_%j.out
#SBATCH -e convergence_%j.err

#-----------------Toolchain---------------------------
ml purge
ml intel/2022.00

# ----------------Modules----------------------------
ml VASP-VTST/6.2.1

# ----------------Command--------------------------
# Adjust the number of threads to match the cores (-c) you requested
export OMP_NUM_THREADS=16
export MKL_NUM_THREADS=16
export MKL_DYNAMIC=FALSE

# --- START OF THE CONVERGENCE SCRIPT ---

# 1. Define the ENCUT values to test
ENCUT_VALUES="100 200 300 400 500"

# 2. Name of the file to save the results
OUTPUT_FILE="convergence_data.txt"

# 3. Command to run VASP (srun is handled by SBATCH)
VASP_COMMAND="vasp_std"

# 4. Write the header of the results file
echo "# ENCUT(eV)   Energy(eV)" > $OUTPUT_FILE

# 5. Main loop that iterates through each ENCUT value
for ENCUT in $ENCUT_VALUES; do
  
  echo "--- Calculating for ENCUT = $ENCUT eV ---"
  
  # Create a directory for this calculation
  DIR_NAME="ENCUT_${ENCUT}"
  mkdir -p $DIR_NAME
  
  # Copy the base VASP files
  cp POSCAR POTCAR KPOINTS $DIR_NAME
  
  # Create the INCAR file using a "here document"
  cat <<EOF > ${DIR_NAME}/INCAR
SYSTEM = ENCUT Convergence Test (ENCUT = ${ENCUT})
ISTART = 0        ! don't read WAVECAR
ENCUT = ${ENCUT}  ! energy cutoff
ISMEAR = 0        ! Gaussian smearing
SIGMA = 0.2      ! width of the smearing
EDIFF = 1e-6      ! electronic convergence

EOF

  # Move into the calculation directory
  cd $DIR_NAME
  
  # Run VASP
  srun $VASP_COMMAND
  
  # Extract the final energy from the OUTCAR
  # grep finds the line, tail -1 ensures it's the last one, awk extracts the 5th column
  ENERGY=$(grep "free  energy" OUTCAR | tail -1 | awk '{print $5}')
  
  # Return to the original directory (very important!)
  cd ..
  
  # Write the result to the output file
  if [ -n "$ENERGY" ]; then
    echo "ENCUT = $ENCUT eV, Energy = $ENERGY eV"
    printf "%-12s %s\n" "$ENCUT" "$ENERGY" >> $OUTPUT_FILE
  else
    echo "ERROR: Could not extract energy for ENCUT = $ENCUT"
    printf "%-12s %s\n" "$ENCUT" "ERROR" >> $OUTPUT_FILE
  fi

done

echo "✅ Convergence process finished. Check the '$OUTPUT_FILE' file."
# --- END OF SCRIPT ---
