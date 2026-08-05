import pyprocar
import numpy as np
import matplotlib.pyplot as plt

fermi_energy= 5.3669 
pyprocar.bandsplot(code='vasp',
                   dirname='./',
                   elimit=[-8.5,8.5],
                   mode='plain',
                   color='pink',
                   fermi= fermi_energy,
                   savefig='./bands1.png',
                   show=False,
                   print_plot_opts=True)


pyprocar.bandsplot(code='vasp',
                   dirname='./',
                   elimit=[-5.5,5.5],
                   mode='parametric',
                   atoms=[0],
                   orbitals=[1,3],
                   fermi= fermi_energy,
                   savefig='./bands2.png',
                   show=False,
                   print_plot_opts=True)
