#!/bin/bash

# =============================================================================
# MLFF Bayesian Error (BEEF) Extraction and Plotting Script
# =============================================================================

LOGFILE="ML_LOGFILE"
DATAFILE="beef_forces.dat"

# 0. Load the required modules in leftraru. Comment in other servers.
module load GCCcore/13.2.0; module load gnuplot


if [[ ! -f "$LOGFILE" ]]; then
    echo "Error: $LOGFILE not found in the current directory."
    exit 1
fi

echo "Extracting Bayesian Error of Forces from $LOGFILE..."

# Parse the Logfile using the BEEF tag
# $2 is the MD Step, $4 is the Max Bayesian Error for Forces (eV/Å)
awk '/^BEEF/ {print $2, $4}' "$LOGFILE" > "$DATAFILE"

echo "Data saved to $DATAFILE. Generating plot..."

# Generate the Plot using Gnuplot
gnuplot <<- EOF
    # Output settings
    set terminal pngcairo size 800,500 enhanced font "Arial,12"
    set output "bayesian_error.png"
    
    # Titles and Labels
    set title "MLFF Bayesian Error Estimation of Forces" font ",14"
    set xlabel "MD Step"
    set ylabel "Max Bayesian Error (eV/Å)"
    
    # Aesthetics
    set grid
    set style line 1 lc rgb "#D9534F" lw 2 pt 7 ps 0.5   # Red line/points
    
    # Plotting command
    plot "$DATAFILE" using 1:2 with linespoints ls 1 title "Max BEEF (Forces)"
EOF

echo "Success! Plot saved as bayesian_error.png."
