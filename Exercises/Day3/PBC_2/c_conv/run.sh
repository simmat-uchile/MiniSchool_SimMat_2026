#!/bin/bash
#SBATCH --reservation=simmat
#SBATCH --job-name=C2-vacuum
#SBATCH --partition=general
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=400M
#SBATCH --output=TareaVASP-%j.out
#SBATCH --error=TareaVASP-%j.err
#SBATCH --time=01:00:00

# Detener el script si ocurre un error
set -euo pipefail

# ---------------- Toolchain ----------------
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

# Evitar que cada proceso MPI cree hilos adicionales
export OMP_NUM_THREADS=1

# Archivo donde se guardarán las energías
RESULTS_FILE="results.dat"

# Eliminar resultados anteriores, si existen
rm -f "${RESULTS_FILE}"

# Valores del parámetro c, correspondiente al vacío
for d in \
    4.300 4.689 5.078 5.467 \
    5.856 6.245 6.634 7.023 \
    7.412 7.801 8.190 8.579 \
    8.968 9.357 9.746 10.135
do
    echo "=================================================="
    echo "Ejecutando cálculo para d = ${d} Å"
    echo "Fecha: $(date)"
    echo "=================================================="

    cat > POSCAR << EOF
graphene
1.0
     2.4676485649928095    0.0000000000000000    0.0000000000000000
    -1.2338242824964032    2.1370463448960484    0.0000000000000000
     0.0000000000000000    0.0000000000000000    ${d}
C
2
Direct
     0.3333333333333357    0.6666666666666643    0.5000000000000000
     0.6666666666666643    0.3333333333333357    0.5000000000000000
EOF

    # Ejecutar VASP con los recursos asignados por SLURM
    srun --ntasks="${SLURM_NTASKS}" vasp_std > "vasp.${d}.out"

    # Guardar archivos principales de cada cálculo
    cp OUTCAR "OUTCAR.${d}"
    cp OSZICAR "OSZICAR.${d}"
    cp CONTCAR "CONTCAR.${d}"
    cp CHGCAR "CHGCAR.${d}"

    # Extraer la última energía libre TOTEN del OUTCAR
    energy=$(awk '/free  energy   TOTEN/ {energy=$5} END {print energy}' OUTCAR)

    # Verificar que se haya encontrado la energía
    if [[ -z "${energy}" ]]; then
        echo "ERROR: no se encontró la energía para d = ${d}" >&2
        echo "${d} NaN" >> "${RESULTS_FILE}"
        exit 1
    fi

    echo "${d} ${energy}" >> "${RESULTS_FILE}"

    echo "d = ${d} Å; energía = ${energy} eV"
done

echo "=================================================="
echo "Todos los cálculos finalizaron correctamente."
echo "Resultados guardados en ${RESULTS_FILE}"
echo "Fecha final: $(date)"
echo "=================================================="
