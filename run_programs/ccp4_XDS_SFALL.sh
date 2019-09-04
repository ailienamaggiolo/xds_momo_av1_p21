#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, HKL2000-output
# Step 4 of 5 -- SFALL calculate structure factors
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Declare directory for the location of CCP4 programs installed on your computer
CCP4='/programs/x86_64-linux/ccp4/7.0/ccp4-7.0/bin'

# Input MTZ_1=truncate_freer.mtz
INPUT_MTZ_1=$1
# For script trouble shooting: INPUT_MTZ='/data/ailiena/AM_Drive_6/data/190418_test/proc/D5_15000_1_xds/D5_15000_1_truncate_freer.mtz'


# Input PDB=REFMAC2.pdb
INPUT_PDB=`echo "$INPUT_MTZ_1" | sed -e 's,truncate,RBP,g' | sed -e 's,freer,refmac2,g' | sed -e 's,mtz,pdb,g'` # PDBIN


#comment out block for script testing-- leave commented to run REFMAC
#: <<'STOP'
#STOP

# Assign file name from directory
FILENAME=`echo $(basename "${INPUT_MTZ_1}")`

WDIR=$(dirname "${INPUT_MTZ_1}")
LOGFILE_SFALL="$WDIR"/log/"$FILENAME"_sfall.log

# Declare temporary output file names for SFALL
OUTPUT_SFALL=$INPUT_MTZ_1.mtz


date

#############################################################################

echo "STARTING SFALL..."
echo "starting input $INPUT_MTZ_1"



$CCP4/sfall HKLOUT $OUTPUT_SFALL XYZIN $INPUT_PDB HKLIN $INPUT_MTZ_1  <<+ >>$LOGFILE_SFALL
 title
LABIN  FP=F SIGFP=SIGF FREE=FreeR_flag F9=DANO F10=SIGDANO
labout -
  FC=FCalc PHIC=PHICalc
MODE SFCALC -
   XYZIN -
   HKLIN
symmetry 'P 1 21 1'
badd 0.0
vdwr 2.5
END
+


#clean up extensions
echo "cleaning extensions..."
NAME_SFALL=`echo "$INPUT_MTZ_1"| sed -e 's,freer,sfall,g'`
mv $OUTPUT_SFALL $NAME_SFALL

NAME_LOG=`echo "$FILENAME" | cut -d'.' -f 1 | sed -e 's,freer,sfall,g'`
mv $LOGFILE_SFALL "$WDIR"/log/"$NAME_LOG".log

echo 'SFALL JOB DONE'
