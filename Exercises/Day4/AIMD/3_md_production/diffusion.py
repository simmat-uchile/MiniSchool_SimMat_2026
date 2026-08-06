#!/usr/bin/env python

from ase.io import read
import numpy as np
import matplotlib.pyplot as plt

# 1. Skip frames! '::5' reads every 5th frame. 
# This cuts reading time by 80% with no loss of diffusion accuracy.
traj = read('XDATCAR', index='::5', format='vasp-xdatcar')
print(f"Loaded {len(traj)} frames.")

# 2. Extract all fractional coordinates at once into a 3D NumPy array
# Shape will be (n_steps, n_atoms, 3)
frac_positions = np.array([atoms.get_scaled_positions() for atoms in traj])

# 3. Unwrap the periodic boundaries using pure math (vectorized)
# Calculate the step-to-step changes
deltas = np.diff(frac_positions, axis=0)

# The magic trick: if an atom jumps across the cell boundary, 
# its fractional change will be > 0.5 or < -0.5. 
# Subtracting the rounded value perfectly corrects this jump!
deltas -= np.round(deltas)

# Rebuild the continuous, unwrapped fractional trajectory
unwrapped_frac = np.zeros_like(frac_positions)
unwrapped_frac[0] = frac_positions[0]
unwrapped_frac[1:] = frac_positions[0] + np.cumsum(deltas, axis=0)

# 4. Convert back to real Cartesian coordinates (Angstroms)
cell = traj[0].get_cell()[:]
cart_positions = unwrapped_frac @ cell

# 5. Calculate MSD instantly
# Subtract the initial positions (t=0) from all steps
displacements = cart_positions - cart_positions[0]

# Square the displacements (x^2 + y^2 + z^2) and average over all atoms
# axis=-1 sums coordinates, axis=1 averages over the 54 atoms
msd = np.mean(np.sum(displacements**2, axis=-1), axis=1)

# Plotting
time_fs = np.arange(len(msd)) * 2.0 * 5 # 2 fs per step * 5 (skipped frames)
plt.plot(time_fs, msd, linewidth=2)
plt.xlabel('Time (fs)')
plt.ylabel('MSD (Å²)')
plt.title('Mean Square Displacement (Vectorized)')
plt.grid(True)
plt.show()
