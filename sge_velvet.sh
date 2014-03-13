#!/bin/bash 
# An example execution script to automate assembly using velvet
# and subsequent processing of the contigs using process_contigs.pl
#
# Grid Engine execution options
#$ -S /bin/bash
#$ -cwd
# These two parameters are very important, as they restrict the amount
# of resources allocated to each job. The first specifies the number 
# of slots on a node required, and the second is the amount of memory
# PER SLOT. Therefore, if we have 4 slots and a virtual_free of 2G
# we would reserve a total of 8G of memory.
#$ -pe smp 4 
#$ -l virtual_free=4G

ARGS=4         
E_BADARGS=85   # Wrong number of arguments passed to script.
if [ $# -ne "$ARGS" ]; then
    echo "Usage: $0 HASH_LENGTH FORWARD_FILE REVERSE_FILE ASSEMBLY_NAME"
    exit $E_BADARGS 
fi  

HASH_LENGTH=$1
FORWARD_FILE=$2
REVERSE_FILE=$3
ASSEMBLY_NAME=$4

WORK_DIR=$TMPDIR
VELVET_H_OPTS="-fastq -shortPaired -separate"
VELVET_G_OPTS="-long_mult_cutoff 1 -exp_cov 6 -ins_length 700 \
    -cov_cutoff 2 -min_contig_lgth 750"

velveth $WORK_DIR $HASH_LENGTH $VELVET_H_OPTS $FORWARD_FILE $REVERSE_FILE
velvetg $WORK_DIR $VELVET_G_OPTS
process_contigs.pl -i $WORK_DIR/contigs.fa -o $ASSEMBLY_NAME.$HASH_LENGTH 

