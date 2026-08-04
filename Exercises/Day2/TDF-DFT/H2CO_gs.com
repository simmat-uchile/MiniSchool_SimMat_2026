%chk=formaldehyde_gs.chk
%mem=4GB
%nprocshared=4
#p PBE1PBE/aug-cc-pVDZ Opt Freq SCF=Tight

Formaldehyde ground-state optimization and frequency calculation

0 1
C      0.000000     0.000000     0.000000
O      0.000000     0.000000     1.210000
H      0.000000     0.943000    -0.588000
H      0.000000    -0.943000    -0.588000

