%oldchk=formaldehyde_gs.chk
%chk=formaldehyde_tddft_T.chk
%mem=4GB
%nprocshared=4
#p PBE1PBE/aug-cc-pVDZ TD=(Triplets,NStates=10) Geom=AllCheck Guess=Read
   SCF=Tight  Pop=Full

Formaldehyde vertical singlet excitation spectrum at optimized ground-state geometry
