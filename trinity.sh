#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1

cd /rhome/arajewski/shared/genetree/analysis/
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair1_ACAGTG.fastq.gz reads1.fastq.gz
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair2_ACAGTG.fastq.gz reads2.fastq.gz

module unload perl
module load perl/5.22.0
module load trinity-rnaseq

Trinity --seqType fq --max_memory 200G --left reads1.fastq.gz --right reads2.fastq.gz --trimmomatic --SS_lib_type RF --CPU 16 --grid_node_max_memory 4G  --output /rhome/arajewski/shared/genetree/trinity_output_fabiana
