#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, XDS-output
# Step 2 of 5 -- REFMAC5 rigid body refinement with truncate_freer.mtz
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Retrieve truncate_freer.mtz
INPUT_MTZ=$1
# For script trouble shooting: INPUT_MTZ='/data/ailiena/AM_Drive_6/data/190418_test/proc/D5_15000_1_xds/D5_15000_1_truncate_freer.mtz'


# Import MR model for phasing with phaser MR
IMPORT_RBP="/data/mag/AM_Drive_8/data/MR_models/av2/Av2_B5_refmac13_MR.pdb" # XYZIN

# Import sequence for phaser MR
IMPORT_SEQ="/data/mag/AM_Drive_8/data/fasta_files/av2/P00459.fasta" # XYZIN

#comment out block for script testing-- leave commented to run REFMAC
#: <<'STOP'
#STOP

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ}")`
WDIR=$(dirname "${INPUT_MTZ}")

LOGFILE_PHASERMR="$WDIR"/log/"$FILENAME"_PHASERMR.log
PHASER_TEMP="$WDIR"/log

# Declare output file names for REFMAC rigid body refine
OUTPUT_XYZOUT=$INPUT_MTZ.pdb
OUTPUT_HKLOUT=$INPUT_MTZ.mtz
OUTPUT_LIBOUT=$INPUT_MTZ.libout_done


date

#############################################################################

echo "STARTING PHASER MR..."
echo "starting input $INPUT_MTZ"

$CCP4/phaser <<+ >>$LOGFILE_PHASERMR
MODE MR_AUTO
ROOT $PHASER_TEMP
JOBS 8
#---DEFINE DATA---
HKLIN $INPUT_MTZ
LABIN  I=IMEAN SIGI=SIGIMEAN
SGALTERNATIVE SELECT HAND
#---DEFINE ENSEMBLES---
ENSEMBLE ensemble1 &
    PDB $IMPORT_RBP IDENT 1.0
#---DEFINE COMPOSITION---
COMPOSITION BY ASU
COMPOSITION PROTEIN SEQ $IMPORT_SEQ NUMBER 1
#---SEARCH PARAMETERS---
SEARCH ENSEMBLE ensemble1 NUMBER 1
+

#clean up extensions
echo "cleaning extensions..."
NAME_MTZ=`echo "$INPUT_MTZ" | cut -d'.' -f 1 | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac1,g'`
mv $INPUT_MTZ.mtz $NAME_MTZ.mtz

NAME_PDB=`echo "$INPUT_MTZ" | cut -d'.' -f 1 | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac1,g'`
mv $INPUT_MTZ.pdb $NAME_PDB.pdb

NAME_LOG=`echo "$FILENAME" | cut -d'.' -f 1 | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac1,g'`
mv $LOGFILE_REFMAC "$WDIR"/log/"$NAME_LOG".log

echo 'PHASER MR JOB DONE'
