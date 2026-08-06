#!/bin/bash

# 0. Load the required modules in leftraru. Comment in other servers.
module load GCCcore/13.2.0; module load gnuplot

# 1. Parse the REPORT file safely for Nosé-Hoover output.
# Grabs Potential Energy, Kinetic Energy, and then Temperature to print the row.
awk '
/e_b>/ { U = $3; K = $4 }
/tmprt>/ { T = $3; print T, K, U }
' REPORT > md_metrics.dat

# 2. Check if data was actually found
if [ ! -s md_metrics.dat ]; then
    echo "Error: No MD data found in REPORT."
    exit 1
fi

# 3. Feed the data to gnuplot for ASCII terminal plotting
gnuplot <<-EOFMarker
    set term dumb size 80, 20
    set xlabel 'MD Step'
    
    # Plot 1: Temperature
    set title 'Temperature (K)'
    plot 'md_metrics.dat' using 0:1 with lines notitle
    
    # Plot 2: Kinetic Energy
    set title 'Kinetic Energy (eV)'
    plot 'md_metrics.dat' using 0:2 with lines notitle
    
    # Plot 3: Potential Energy
    set title 'Potential Energy (eV)'
    plot 'md_metrics.dat' using 0:3 with lines notitle
EOFMarker

# Clean up
rm md_metrics.dat
