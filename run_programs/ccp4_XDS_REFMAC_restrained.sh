#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, HKL2000-output
# Step 5 of 8 -- REFMAC5 restrained refinement
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Retrieve truncate_freer.mtz
INPUT_MTZ=$1
# For script trouble shooting: INPUT_MTZ='/data/ailiena/AM_Drive_6/data/190418_test/proc/D5_15000_1_xds/D5_15000_1_truncate_freer.mtz'

# Input REFMAC1.pdb
INPUT_PDB=`echo "$INPUT_MTZ" | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac1,g' | sed -e 's,mtz,pdb,g'` # XYZIN
# for scripting trouble shooting: INPUT_PDB=/data/ailiena/AM_Drive_6/data/190418_test/proc/D5_15000_1_xds/D5_15000_1_RBP_refmac1.pdb


#comment out block for script testing-- leave commented to run REFMAC
#: <<'STOP'

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ}")`

WDIR=$(dirname "${INPUT_MTZ}")

LOGFILE_REFMAC2="$WDIR"/log/"$FILENAME".log

# Declare output file names for REFMAC rigid body refine
OUTPUT_XYZOUT=$INPUT_MTZ.pdb
OUTPUT_HKLOUT=$INPUT_MTZ.mtz
OUTPUT_LIBOUT=$INPUT_MTZ.libout_done

date

#############################################################################

echo "STARTING REFMAC RESTRAINED..."
echo "starting input $INPUT_PDB"

$CCP4/refmac5 XYZIN $INPUT_PDB XYZOUT $OUTPUT_XYZOUT HKLIN $INPUT_MTZ HKLOUT $OUTPUT_HKLOUT LIBOUT $OUTPUT_LIBOUT <<+ >>$LOGFILE_REFMAC2

make check NONE
make -
    hydrogen ALL -
    hout NO -
    peptide NO -
    cispeptide YES -
    ssbridge YES -
    symmetry YES -
    sugar YES -
    connectivity NO -
    link NO
refi -
    type REST -
    resi MLKF -
    meth CGMAT -
    bref ISOT
ncyc 10
scal -
    type SIMP -
    LSSC -
    ANISO -
    EXPE
solvent YES
weight -
    AUTO
monitor MEDIUM -
    torsion 10.0 -
    distance 10.0 -
    angle 10.0 -
    plane 10.0 -
    chiral 10.0 -
    bfactor 10.0 -
    bsphere 10.0 -
    rbond 10.0 -
    ncsr 10.0
labin  FP=F SIGFP=SIGF -
   FREE=FreeR_flag
labout  FC=FC FWT=FWT PHIC=PHIC PHWT=PHWT DELFWT=DELFWT PHDELWT=PHDELWT FOM=FOM
PNAME unknown
DNAME unknown010
RSIZE 80
EXTERNAL WEIGHT SCALE 10.0
EXTERNAL USE MAIN
EXTERNAL DMAX 4.2
END
+


#clean up extensions
echo "cleaning extensions..."

NAME_REFMAC2=`echo "$INPUT_MTZ" | cut -d'.' -f 1 | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac2,g'`
mv $INPUT_MTZ.mtz $NAME_REFMAC2.mtz
mv $INPUT_MTZ.pdb $NAME_REFMAC2.pdb

NAME_LOG=`echo "$FILENAME" | cut -d'.' -f 1 | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac2,g'`
mv $LOGFILE_REFMAC2 "$WDIR"/log/"$NAME_LOG".log


echo 'REFMAC RESTRAINED JOB DONE'
