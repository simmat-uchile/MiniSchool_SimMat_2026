#!/usr/bin/env python3

"""
Plot the first three wave functions of a particle
in a one-dimensional infinite potential box.
"""

import matplotlib

# Required when running on a cluster without a graphical display
matplotlib.use("Agg")

import matplotlib.pyplot as plt
import numpy as np


# ============================================================
# Configuration
# ============================================================

BOX_LENGTH = 1.0
NUMBER_OF_POINTS = 1000
QUANTUM_STATES = [1, 2, 3]
OUTPUT_FILE = "particle_in_box.png"


# ============================================================
# Particle-in-a-box wave function
# ============================================================

def wave_function(x: np.ndarray, n: int, length: float) -> np.ndarray:
    """
    Return the normalized wave function for a particle
    in a one-dimensional infinite potential box.

    Parameters
    ----------
    x
        Positions inside the box.
    n
        Principal quantum number.
    length
        Length of the box.
    """
    normalization = np.sqrt(2.0 / length)

    return normalization * np.sin(
        n * np.pi * x / length
    )


# ============================================================
# Main program
# ============================================================

def main() -> None:
    """Create and save the particle-in-a-box figure."""

    x = np.linspace(
        0.0,
        BOX_LENGTH,
        NUMBER_OF_POINTS,
    )

    fig, ax = plt.subplots(figsize=(8, 5))

    for n in QUANTUM_STATES:
        psi = wave_function(
            x=x,
            n=n,
            length=BOX_LENGTH,
        )

        ax.plot(
            x / BOX_LENGTH,
            psi,
            linewidth=2,
            label=fr"$n={n}$",
        )

    # Draw the boundaries of the box
    ax.axvline(0.0, linestyle="--", linewidth=1)
    ax.axvline(1.0, linestyle="--", linewidth=1)
    ax.axhline(0.0, linewidth=0.8)

    ax.set_xlabel(r"Position, $x/L$")
    ax.set_ylabel(r"Wave function, $\psi_n(x)$")
    ax.set_title(
        "Particle in a One-Dimensional Infinite Potential Box"
    )

    ax.legend()
    ax.set_xlim(0.0, 1.0)
    ax.margins(y=0.15)

    fig.tight_layout()

    fig.savefig(
        OUTPUT_FILE,
        dpi=300,
        bbox_inches="tight",
    )

    plt.close(fig)

    print(f"Figure successfully created: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
