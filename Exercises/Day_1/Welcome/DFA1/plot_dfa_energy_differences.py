import re
import matplotlib.pyplot as plt

# === INPUT LOG FILES ===
logfile = "Be.log"
ccsd_logfile = "Be_ccsd.log"

# === PARSE REFERENCE ENERGY FROM CCSD LOG ===
# Nota: ajustar el patrón si el nivel de teoría o el keyword de Gaussian cambian
reference_energy = None
with open(ccsd_logfile, 'r') as f:
    for line in f:
        match = re.search(r'CCSD\(T\)=\s*(-?\d+\.\d+)', line) or \
                re.search(r'E\(CORR\)=\s*(-?\d+\.\d+)', line)
        if match:
            reference_energy = float(match.group(1))

if reference_energy is None:
    raise RuntimeError(f"No se encontró la energía CCSD en {ccsd_logfile}")

# === PARSE DFA LOG FILE ===
methods = []
energies = []

with open(logfile, 'r') as f:
    for line in f:
        if "SCF Done:" in line:
            match = re.search(r'SCF Done:\s+E\(([^)]+)\)\s+=\s+(-?\d+\.\d+)', line)
            if match:
                methods.append(match.group(1))
                energies.append(float(match.group(2)))

if not methods:
    raise RuntimeError(f"No se encontraron líneas 'SCF Done' en {logfile}")

# === COMPUTE ENERGY DIFFERENCES ===
delta_E_mHa = [(E - reference_energy) * 1000 for E in energies]

# === PLOT ===
plt.figure()
plt.bar(methods, delta_E_mHa, color="royalblue")
plt.axhline(0, color='black', linestyle='--')
plt.ylabel("ΔE (mHartree)")
plt.title("SCF Energy Deviations from CCSD")
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig("scf_energy_deviations_dfa.png", dpi=300)
