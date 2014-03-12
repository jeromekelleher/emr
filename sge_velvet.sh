#!/bin/bash 
# Grid Engine execution options
#$ -S /bin/bash
#$ -cwd
#$ -l virtual_free=4
#
# An example execution script to automate assembly using velvet
# and subsequent processing of the contigs using process_contigs.pl

ARGS=4         
E_BADARGS=85   # Wrong number of arguments passed to script.

if [ $# -ne "$ARGS" ]; then
    echo "Usage: $0 HASH_LENGTH FORWARD_FILE REVERSE_FILE ASSEMBLY_NAME"
    exit $E_BADARGS 
fi  

HASH_LENGTH=$1
IN_FORWARD_FILE=$2
IN_REVERSE_FILE=$3
ASSEMBLY_NAME=$4

WORK_DIR=$( mktemp -d /tmp/velvet_work.XXXXXXXXX )
VELVET_H_OPTS="-fastq -shortPaired -separate"
VELVET_G_OPTS="-long_mult_cutoff 1 -exp_cov 6 -ins_length 700 \
    -cov_cutoff 2 -min_contig_lgth 750"
FORWARD_FILE=$WORK_DIR/forward.fastq
REVERSE_FILE=$WORK_DIR/reverse.fastq

cp $IN_FORWARD_FILE $FORWARD_FILE 
cp $IN_REVERSE_FILE $REVERSE_FILE 
velveth $WORK_DIR $HASH_LENGTH $VELVET_H_OPTS \
    $FORWARD_FILE $REVERSE_FILE
velvetg $WORK_DIR $VELVET_G_OPTS
process_contigs.pl -i $WORK_DIR/contigs.fa -o $ASSEMBLY_NAME.$HASH_LENGTH 

# Now clean up the work directory.
rm -fR $WORK_DIR
