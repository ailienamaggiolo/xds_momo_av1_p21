#!/bin/bash
# before running "do_all.sh" need to call --- /programs/x86_64-linux/ccp4/7.0/ccp4-7.0/start

###########################################################################
#
# Make file tree for processing crystallography files
#
#                                                 Ailiena Maggiolo 23/07/19
#
###########################################################################

# Make proc directories from all_truncate_mtz_proc.txt
# Note: directory structure is important here.

INPUT_MTZ_FILES="../proc/all_truncate_mtz_proc.txt"


while read in;
  do DIRS=`echo "$(dirname $in)"`
  mkdir $DIRS
done < $INPUT_MTZ_FILES
