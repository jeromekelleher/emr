#!/bin/bash
# Simple script to automate submitting jobs to SGE.
FWD=P.cact_411_1M_F_trim.fastq
REV=P.cact_411_1M_R_trim.fastq
NAME=P.cact

for h in $( seq 11 2 51 ); do 
    qsub sge_velvet.sh $h $FWD $REV $NAME 
done
