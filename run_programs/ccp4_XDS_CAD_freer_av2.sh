#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, HKL2000-output
# Step 1 of 5 -- CAD to import FreeR flags
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Input MTZ_1=truncate.mtz
INPUT_MTZ_1=$1
#INPUT_MTZ_1=/data/ailiena/AM_Drive_6/data/190418_test/proc/D5_15000_1_xds/D5_15000_1_truncate_freer.mtz

# Import FreeR_flags from another file
IMPORT_FREER="/data/mag/AM_Drive_8/data/FreeR_MTZs/av2/Av2_H3_Fe_output_P21.mtz" # HKLIN2

#comment out block for script testing-- leave commented to run REFMAC
#: <<'STOP'
#STOP

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ_1}")`
CASSETTE=`echo $(dirname "${INPUT_MTZ_1}") | rev | cut -d"/" -f 2 | rev`
WDIR=`echo $(dirname "${INPUT_MTZ_1}") | sed -e "s,$CASSETTE,proc,g"`
OUTPUT_MTZ=`echo "$WDIR"/"$FILENAME" | sed -e "s,truncate,truncate_freer,g"` #OUTPUT
OUTPUT_MTZ_FILENAME=`echo "$FILENAME" | sed -e "s,truncate,truncate_freer,g"`
LOGFILE_CAD="$WDIR"/log/"$OUTPUT_MTZ_FILENAME"_cad.log


date

################################################

echo "STARTING CAD..."
echo "starting input $INPUT_MTZ_1"

$CCP4/cad HKLIN1 $INPUT_MTZ_1 HKLIN2 $IMPORT_FREER HKLOUT $OUTPUT_MTZ <<+ >>$LOGFILE_CAD
 title
monitor BRIEF
labin file 1 -
    E1 = IMEAN -
    E2 = SIGIMEAN -
    E3 = I(+) -
    E4 = SIGI(+) -
    E5 = I(-) -
    E6 = SIGI(-) -
    E7 = F -
    E8 = SIGF -
    E9 = DANO -
    E10 = SIGDANO -
    E11 = F(+) -
    E12 = SIGF(+) -
    E13 = F(-) -
    E14 = SIGF(-) -
    E15 = ISYM
labout file 1 -
    E1 = IMEAN -
    E2 = SIGIMEAN -
    E3 = I(+) -
    E4 = SIGI(+) -
    E5 = I(-) -
    E6 = SIGI(-) -
    E7 = F -
    E8 = SIGF -
    E9 = DANO -
    E10 = SIGDANO -
    E11 = F(+) -
    E12 = SIGF(+) -
    E13 = F(-) -
    E14 = SIGF(-) -
    E15 = ISYM
ctypin file 1 -
    E1 = J -
    E2 = Q -
    E3 = K -
    E4 = M -
    E5 = K -
    E6 = M -
    E7 = F -
    E8 = Q -
    E9 = D -
    E10 = Q -
    E11 = G -
    E12 = L -
    E13 = G -
    E14 = L -
    E15 = Y
labin file 2 -
    E1 = FreeR_flag
labout file 2 -
    E1 = FreeR_flag
ctypin file 2 -
    E1 = I
+

echo 'CAD JOB DONE'
