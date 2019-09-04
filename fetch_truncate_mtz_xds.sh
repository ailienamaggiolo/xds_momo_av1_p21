#!/bin/bash
# before running "do_all.sh" need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start

###########################################################################
#
# Fetch all xds_truncate files for scripted processing, XDS-output
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

#comment out block for script testing-- leave commented to run script. Place STOP at end of comment block.
#: <<'STOP'
#STOP


# Extracts all truncate.mtz files from cassette directory and exports into "all_truncate_mtz.txt"
# Creates a second file which templates the processed files directory tree called "all_truncate_mtz_proc.txt"
# Note: directory structure is important here. Have all truncate_mtz files in a folder named with the cassette number.
# May need to trouble shoot by telling the script where the cassette number is in the directory. In this case, if each field is defined by "/" then the cassette number is the 7th field.


# Assign input directory, which must be a cassette number
IMPORT="/data/mag/AM_Drive_8/data/190705/147"

# Assign a cassette number from directory
CASSETTE=$(basename "${IMPORT}")

# Assign a working directory
WDIR=$(dirname "${IMPORT}")

# Assign a folder for proceesed files: proc
PROC=$WDIR/proc
###################################################################################


# make proc folder
if [ ! -f $PROC ]; then
  mkdir $PROC
else
   echo "output files to proc directory"
fi

EXPORT1=$WDIR/proc/all_truncate_mtz.txt
EXPORT2=$WDIR/proc/all_truncate_mtz_proc.txt

find $IMPORT -name "*truncate.mtz" > $EXPORT1
find $IMPORT -name "*truncate.mtz" | sed -e "s,$CASSETTE,proc,g" > $EXPORT2
