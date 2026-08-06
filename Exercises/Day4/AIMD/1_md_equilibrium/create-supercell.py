#!/usr/bin/env python

from ase.io import read, write

# 1. Define the supercell expansion along each lattice vector
N1 = 3
N2 = 3
N3 = 3

# 2. Read the initial unit cell
# 'format="vasp"' ensures ASE knows exactly how to parse the file
unit_cell = read('POSCAR-unitcell', format='vasp')

# 3. Generate the supercell
# ASE elegantly handles the lattice vectors and atomic positions 
# when you multiply the Atoms object by a tuple.
supercell = unit_cell * (N1, N2, N3)

# 4. Save the new supercell
write('POSCAR', supercell, format='vasp')

# Print some feedback for the students so they know it worked
print(f"Successfully created a {N1}x{N2}x{N3} supercell!")
print(f"Initial atoms: {len(unit_cell)}")
print(f"Final atoms:   {len(supercell)}")
