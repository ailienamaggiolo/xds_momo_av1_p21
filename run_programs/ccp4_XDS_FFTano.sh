#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, XDS-output
# Step 5 of 5 -- FFT convert ano mtz to map
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Input output_CAD_ANO.mtz
INPUT_MTZ=$1
# For script trouble shooting: INPUT_MTZ='/data/ailiena/AM_Drive_6/data/190418_test/proc/D5_15000_1_xds/D5_15000_1_truncate_freer.mtz'


#comment out block for script testing-- leave commented to run
#: <<'STOP'
#STOP

#Input FFT ano =truncate_sfall.mtz
INPUT_FFT=`echo "$INPUT_MTZ"| sed -e 's,freer,sfall,g'`

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ}")`

WDIR=$(dirname "${INPUT_MTZ}")

LOGFILE_FFT="$WDIR"/log/"$FILENAME".log

# Declare output file names for REFMAC rigid body refine
OUTPUT_HKLOUT=$INPUT_MTZ.map


date

#############################################################################

echo "STARTING FFT..."
echo "starting input $INPUT_FFT"


$CCP4/fft HKLIN $INPUT_FFT MAPOUT $OUTPUT_HKLOUT <<+ >>$LOGFILE_FFT
title
xyzlim asu
scale F1 1.0
labin -
  DANO=DANO SIG1=SIGDANO PHI=PHICalc
end
+


#clean up extensions
echo "cleaning extensions..."

NAME_FFT=`echo "$INPUT_MTZ" | sed -e 's,freer,sfall_ano,g' | cut -d'.' -f 1`
mv $INPUT_MTZ.map $NAME_FFT.map

NAME_LOG=`echo "$FILENAME" | cut -d'.' -f 1`
mv $LOGFILE_FFT "$WDIR"/log/"$NAME_LOG"_map.log

echo 'FFT JOB DONE'
