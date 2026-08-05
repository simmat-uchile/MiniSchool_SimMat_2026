#!/usr/bin/env python3

"""
Grafica la convergencia de la energía total respecto al tamaño
de la celda en z para grafeno.

Entrada:
    results.dat

Formato esperado:
    4.300  -18.123456
    4.689  -18.234567
    ...

Salidas:
    vacuum_convergence.png
    vacuum_convergence.pdf
    vacuum_convergence_processed.dat
"""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np


# ---------------- Configuración ----------------

RESULTS_FILE = Path("results.dat")

# Número de átomos en la celda de grafeno
NATOMS = 2

# Se toma como referencia el cálculo con mayor vacío
REFERENCE = "largest"

# Criterio indicativo de convergencia, en meV/átomo
TOLERANCE_MEV_ATOM = 1.0

def read_results(filename: Path):
    """Lee distancia y energía desde results.dat."""

    if not filename.exists():
        raise FileNotFoundError(
            f"No se encontró el archivo {filename.resolve()}"
        )

    data = np.loadtxt(filename, comments="#")

    if data.ndim == 1:
        data = data.reshape(1, -1)

    if data.shape[1] < 2:
        raise ValueError(
            "results.dat debe contener al menos dos columnas: "
            "vacío/celda-z y energía."
        )

    vacuum = data[:, 0]
    energy = data[:, 1]

    # Eliminar filas no válidas
    valid = np.isfinite(vacuum) & np.isfinite(energy)
    vacuum = vacuum[valid]
    energy = energy[valid]

    if len(vacuum) < 2:
        raise ValueError(
            "Se necesitan al menos dos cálculos válidos."
        )

    # Ordenar por tamaño de celda
    order = np.argsort(vacuum)

    return vacuum[order], energy[order]


def main() -> None:
    vacuum, energy = read_results(RESULTS_FILE)

    if REFERENCE == "largest":
        reference_energy = energy[-1]
        reference_vacuum = vacuum[-1]
    else:
        raise ValueError("REFERENCE debe ser 'largest'.")

    # Diferencia de energía en meV/átomo
    delta_energy = (
        (energy - reference_energy) * 1000.0 / NATOMS
    )

    converged = np.abs(delta_energy) <= TOLERANCE_MEV_ATOM

    # Guardar datos procesados
    output_data = np.column_stack(
        (vacuum, energy, delta_energy, converged.astype(int))
    )

    header = (
        "cell_z_A  total_energy_eV  "
        "delta_energy_meV_per_atom  converged"
    )

    np.savetxt(
        "vacuum_convergence_processed.dat",
        output_data,
        header=header,
        fmt=["%.6f", "%.12f", "%.8f", "%d"],
    )

    # ---------------- Gráfico ----------------

    fig, ax = plt.subplots(figsize=(7.2, 5.2))

    ax.plot(
        vacuum,
        delta_energy,
        marker="o",
        linewidth=1.5,
        markersize=5,
        label=(
            rf"$[E(c)-E({reference_vacuum:.3f}\,\AA)]/"
            rf"{NATOMS}$"
        ),
    )

    ax.axhline(0.0, linewidth=1.0)

    ax.axhline(
        TOLERANCE_MEV_ATOM,
        linestyle="--",
        linewidth=1.0,
        label=rf"$\pm {TOLERANCE_MEV_ATOM:g}$ meV/atom",
    )

    ax.axhline(
        -TOLERANCE_MEV_ATOM,
        linestyle="--",
        linewidth=1.0,
    )

    ax.set_xlabel(r"cell length $c$ ($\AA$)")
    ax.set_ylabel(r"$\Delta E$ (meV/atom)")
    ax.set_title("convergence with respect to empty space")
    ax.grid(alpha=0.25)
    ax.legend()
    fig.tight_layout()

    fig.savefig("vacuum_convergence.png", dpi=300)
    fig.savefig("vacuum_convergence.pdf")

    # ---------------- Resumen en pantalla ----------------

    print("\nEmpty space convergence")
    print("-----------------------------------------------")
    print(
        f"Reference: c = {reference_vacuum:.3f} Å, "
        f"E = {reference_energy:.10f} eV"
    )
    print(
        f"Threshold: |ΔE| <= {TOLERANCE_MEV_ATOM:g} meV/átomo\n"
    )

    print(
        f"{'c (Å)':>10s} {'E (eV)':>18s} "
        f"{'ΔE (meV/atom)':>18s} {'Convergence':>10s}"
    )

    for c_value, e_value, de_value, is_converged in zip(
        vacuum, energy, delta_energy, converged
    ):
        status = "Sí" if is_converged else "No"

        print(
            f"{c_value:10.3f} "
            f"{e_value:18.10f} "
            f"{de_value:18.6f} "
            f"{status:>10s}"
        )

    print("\nArchivos generados:")
    print("  vacuum_convergence.png")
    print("  vacuum_convergence.pdf")
    print("  vacuum_convergence_processed.dat")


if __name__ == "__main__":
    main()

