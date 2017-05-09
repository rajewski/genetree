#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=400G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

cd /rhome/arajewski/shared/genetree/analysis/
rm -f reads*

ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair1_ACTTGA.fastq.gz reads1.fastq.gz
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair2_ACTTGA.fastq.gz reads2.fastq.gz
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair1_GATCAG.fastq.gz reads3.fastq.gz
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608_lane1_pair2_GATCAG.fastq.gz reads4.fastq.gz

module unload perl
module load perl/5.22.0
module load trinity-rnaseq

Trinity --seqType fq --max_memory 320G --bflyCalculateCPU --left reads1.fastq.gz,reads3.fastq.gz --right reads2.fastq.gz,reads4.fastq.gz --trimmomatic --SS_lib_type RF --CPU 16 --full_cleanup --output /rhome/arajewski/shared/genetree/trinity_output_cestrumdiurnum
