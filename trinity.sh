#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1

cd /rhome/arajewski/shared/genetree/analysis/

module unload perl
module load perl/5.22.0
module load trinity-rnaseq

Trinity --seqType fq --SS_lib_type RF --max_memory=50G --left /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair1_ACAGTG.fastq.gz --right /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair2_ACAGTG.fastq.gz --trimmomatic --CPU 16 --verbose --output /rhome/arajewski/shared/genetree/trinity_output_fabiana
