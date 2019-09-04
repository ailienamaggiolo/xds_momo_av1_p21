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


# This program calls scripted versions of CAD, REFMAC rigid body, and REFMAC restrained
# Input file --> text file with list of all XDS_truncate.mtz files with full paths "all_truncate_mtz.txt"
# Note: the input file is different than the "all_truncate_mtz_proc.txt" which is used to create the directories for processed files

while read in;
  do /data/mag/AM_Drive_8/ccp4_scripts/XDS_momo/pipeline_ano.sh "$in";
done < ../proc/all_truncate_mtz.txt
#done < /data/ailiena/AM_Drive_6/data/190418_test/proc/all_truncate_mtz.txt
