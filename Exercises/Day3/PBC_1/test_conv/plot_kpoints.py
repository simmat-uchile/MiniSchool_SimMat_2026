"""
Plot k-point convergence test.

Reads 'k_convergence.txt' with two columns:
  column 1 -> k-point grid label (e.g. "4x4x4")
  column 2 -> Total Energy (eV)
"""

import numpy as np
import matplotlib.pyplot as plt

# Load data: column 1 is a text label, column 2 is a number
labels = np.loadtxt("k_convergence.txt", usecols=0, dtype=str)
energy = np.loadtxt("k_convergence.txt", usecols=1)

x = np.arange(len(labels))

# Plot
plt.figure(figsize=(8, 6))
plt.plot(x, energy, marker="o", linestyle="-")
plt.xticks(x, labels)
plt.title("K-point Convergence Test")
plt.xlabel("K-point Grid")
plt.ylabel("Total Energy (eV)")
plt.tight_layout()

# Save without opening a window
plt.savefig("kpoints_convergence.png", dpi=150)
plt.close()
