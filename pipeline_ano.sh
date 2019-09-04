#!/bin/bash
#need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start


###########################################################################
#
# Molecular replacement of Av1 by rigid body refinement, XDS-output
#
# Step 1 of 5 -- CAD to import FreeR flags
# Step 2 of 5 -- REFMAC5 rigid body refinement with truncate_freer.mtz
# Step 3 of 5 -- REFMAC5 restrained refinement with truncate_freer.mtz
# Step 4 of 5 -- SFALL calculate structure factors
# Step 5 of 5 -- FFT convert ano mtz to map
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

date

# Before running this program, run autoxds with the correct spacegroup and unit cell parameters. Also make sure that anomalous reflections are recorded (param friedel=FALSE).
# The input for this program is a scaled and truncated map: XXX_XDS_truncate.mtz

#comment out block for script testing-- leave commented to run script. Place STOP at end of comment block.
#: <<'STOP'
#STOP

# Directory for each homemade script for CCP4 run_programs
RUN_PROGRAMS='/data/mag/AM_Drive_8/ccp4_scripts/XDS_momo/run_programs'


#-------# CAD to import FreeR flags

# Use the XDS_truncate.mtz as input files
# Note: FreeR flag imported in CAD. Directory and filename is declared in the "ccp4_XDS_CAD_FreeR_proc" program.
      # For script trouble shooting: INPUT_MTZ='/data/ailiena/AM_Drive_6/data/190418_test/379/D5_15000_1_xds/D5_15000_1_truncate.mtz'
INPUT_MTZ=$1 #INPUT

# output of CAD with imported FreeR flags = truncate_freer.mtz
CASSETTE=`echo $(dirname "${INPUT_MTZ}") | rev | cut -d"/" -f 2 | rev`
WDIR=`echo $(dirname "${INPUT_MTZ}") | sed -e "s,$CASSETTE,proc,g"`
FILENAME=`echo $(basename "${INPUT_MTZ}")`
OUTPUT_MTZ=`echo "$WDIR"/"$FILENAME" | sed -e "s,truncate,truncate_freer,g"` #OUTPUT


#-------# RBP_REFMAC

# RBP_REFMAC input mtz file = truncate_freer.mtz
# RBP_REFMAC input pdb file = MR_MODEL.pdb (defined in ccp4_XDS_REFMAC_RBP.sh as "IMPORT_PDB")

# output of RBP_REFMAC (with ano) = REFMAC1.MTZ
REFMAC_MTZ=`echo $(basename "${INPUT_MTZ}") | sed -e 's,truncate,RBP_refmac1,g'`
OUTPUT_REFMAC1_MTZ=`echo "$WDIR"/"$REFMAC_MTZ"` #OUTPUT_RBP_REFMAC1

# output of RBP_REFMAC (with ano) = REFMAC1.PDB
REFMAC_PDB=`echo $(basename "${INPUT_MTZ}") | sed -e 's,truncate,RBP_refmac1,g'| sed -e 's,mtz,pdb,g'`
OUTPUT_REFMAC1_PDB=`echo "$WDIR"/"$REFMAC_PDB"` #OUTPUT_RBP_REFMAC1


#-------# REFMAC_RESTRAINED

# REFMAC_RESTRAINED input mtz file = truncate_freer.mtz
# REFMAC_RESTRSINED input pdb file = $OUTPUT_REFMAC1_PDB (defined in ccp4_XDS_REFMAC_RBP.sh as "OUTPUT_REFMAC1_PDB")

# output of RBP_REFMAC = RBP_REFMAC1.MTZ
REFMAC2_MTZ=`echo $(basename "${INPUT_MTZ}") | sed -e 's,truncate,RBP_refmac2,g'`
OUTPUT_REFMAC2_MTZ=`echo "$WDIR"/"$REFMAC2_MTZ"` #OUTPUT_RBP_REFMAC2

# output of RBP_REFMAC (with ano) = REFMAC1.PDB
REFMAC2_PDB=`echo $(basename "${INPUT_MTZ}") | sed -e 's,truncate,RBP_refmac2,g' | sed -e 's,mtz,pdb,g'`
OUTPUT_REFMAC2_PDB=`echo "$WDIR"/"$REFMAC2_PDB"` #OUTPUT_RBP_REFMAC2


#-------# SFALL

# SFALL input mtz file1 = truncate_freer.mtz #$OUTPUT_MTZ
# SFALL input pdb file = REFMAC2.pdb #$OUTPUT_REFMAC2_PDB

NAME_SFALL=`echo $(basename "${INPUT_MTZ}") | sed -e 's,truncate,truncate_sfall,g'`
OUTPUT_SFALL=`echo "$WDIR"/"$NAME_SFALL"` #OUTPUT_SFALL



#-------# FFT_ANO

# FFT input mtz file = OUTPUT_CAD_ANO.mtz #$OUTPUT_CAD_ANO
NAME_FFT=`echo $(basename "${NAME_SFALL}") | sed -e 's,sfall,sfall_ano,g' | sed -e 's,mtz,map,g'`
OUTPUT_FFT=`echo "$WDIR"/"$NAME_FFT"` #OUTPUT_FFT


#-------# make file to output all log files in each data set
LOGDIR=$WDIR/log

if [ ! -f $LOGDIR ]; then
  mkdir $LOGDIR
else
   echo "writing progress to log directory. Continuing next step..."
fi


#############################################################################


# Run CAD step 1 of 5
if [ ! -f $OUTPUT_MTZ ]; then
  $RUN_PROGRAMS/ccp4_XDS_CAD_freer.sh $INPUT_MTZ
else
   echo "$OUTPUT_MTZ exists. Continuing next step..."
fi


# Run REFMAC rigid body refine step 2 of 5
if [ ! -f $OUTPUT_REFMAC1_PDB ]; then
  $RUN_PROGRAMS/ccp4_XDS_REFMAC_RBP.sh $OUTPUT_MTZ
else
  echo "$OUTPUT_REFMAC1_PDB exists. Continuing next step.. "
fi


# Run REFMAC restrained refine step 3 of 5
if [ ! -f $OUTPUT_REFMAC2_MTZ ]; then
  $RUN_PROGRAMS/ccp4_XDS_REFMAC_restrained.sh $OUTPUT_MTZ
else
    echo "$OUTPUT_REFMAC2_MTZ exits. Continuing next step..."
fi


# Run SFALL for anomalous maps step 4 of 5
if [ ! -f $OUTPUT_SFALL ]; then
  $RUN_PROGRAMS/ccp4_XDS_SFALL.sh $OUTPUT_MTZ
else
    echo "$OUTPUT_SFALL exits. Continuing next step..."
fi


# Run FFT convert to map step 5 of 5
if [ ! -f $OUTPUT_FFT ]; then
  $RUN_PROGRAMS/ccp4_XDS_FFTano.sh $OUTPUT_MTZ
else
    echo "$OUTPUT_FFT exits. Continuing next step..."
fi


echo "PROCESSING COMPLETE: SUCCESS"
date
