import numpy as np
import matplotlib.pyplot as plt

# === LOAD DATA ===
# Multiwfn ya entrega la columna r en Bohr, no reconvertir desde Angstrom
data = np.loadtxt("RDF_ccsd_vs_DFA.txt")

r_bohr = data[:, 0]
ccsd = data[:, 1]

# === DFA FUNCTIONALS IN FIXED ORDER ===
# Mismo orden que en Be.gjf / Be.log: SVWN, pbe, pbe0, m062x, m11, hse06
dfas = [
    (2, "SVWN"),
    (4, "PBEPBE"),     # PBE
    (3, "PBE1PBE"),    # PBE0
    (5, "RM062X"),
    (7, "RM11"),        # col 7 en el archivo es m11
    (6, "RHSEH1PBE"),   # col 6 en el archivo es hse06
]

colors = ["tab:blue", "tab:green", "tab:orange", "tab:red", "tab:brown", "tab:purple"]

# === PLOT DIFFERENCE CURVES ===
plt.figure()
for i, (col, label) in enumerate(dfas):
    dfa = data[:, col]
    delta = dfa - ccsd
    plt.plot(r_bohr, delta, label=label, color=colors[i])

plt.axhline(0, color='black', linestyle='--', linewidth=0.8)
plt.xlabel("r (bohr)")
plt.ylabel("DFA(r) – CCSD(r)")
plt.title("Radial Density Differences")
plt.legend()
plt.tight_layout()
plt.savefig("rdf_differences_curves.png", dpi=300)

# === COMPUTE INTEGRATED ABSOLUTE ERRORS (regla trapezoidal) ===
errors = []
for col, label in dfas:
    dfa = data[:, col]
    abs_diff = np.abs(dfa - ccsd)
    delta_integral = np.trapz(abs_diff, r_bohr)
    errors.append((label, delta_integral))

# === BAR PLOT OF INTEGRATED ERRORS (same order as above) ===
labels = [label for (_, label) in dfas]
values = [val for (_, val) in errors]

plt.figure()
bars = plt.bar(labels, values, color="royalblue")
plt.ylabel("Integrated |DFA – CCSD| (electrons)")
plt.title("Integrated Radial Density Error")
plt.tight_layout()
plt.savefig("rdf_integrated_errors.png", dpi=300)
