#!/bin/bash -l
#SBATCH --ntasks=64
#SBATCH --nodes=1

module load perl/5.22.0
module load trinity-rnaseq

Trinity --seqType fq --max_memory=50G --left flowcell608_lane1_pair1_ACAGTG.fastq.gz --right flowcell608_lane1_pair2_ACAGTG.fastq.gz --trimmomatic --CPU 64 --verbose ../trinityoutput/Fabiana
