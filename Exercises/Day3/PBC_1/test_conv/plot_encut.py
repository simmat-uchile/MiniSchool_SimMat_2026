"""
Plot ENCUT convergence test.

Reads 'convergence_data.txt' with two columns:
  column 1 -> ENCUT (eV)
  column 2 -> Total Energy (eV)
"""

import numpy as np
import matplotlib.pyplot as plt

# Load data (columns: ENCUT, Total Energy)
data = np.loadtxt("convergence_data.txt")
encut = data[:, 0]
energy = data[:, 1]

# Plot
plt.figure(figsize=(8, 6))
plt.plot(encut, energy, marker="o", linestyle="-")
plt.title("ENCUT Convergence Test")
plt.xlabel("ENCUT (eV)")
plt.ylabel("Total Energy (eV)")
plt.tight_layout()

# Save without opening a window
plt.savefig("encut_convergence.png", dpi=150)
plt.close()
