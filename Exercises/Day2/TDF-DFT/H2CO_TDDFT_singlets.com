%oldchk=formaldehyde_gs.chk
%chk=formaldehyde_tddft_S.chk
%mem=4GB
%nprocshared=4
#p PBE1PBE/aug-cc-pVDZ TD=(Singlets,NStates=10) Geom=AllCheck Guess=Read
   SCF=Tight  Pop=Full

Formaldehyde vertical singlet excitation spectrum at optimized ground-state geometry
