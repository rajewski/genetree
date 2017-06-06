#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

cd /rhome/arajewski/shared/genetree/analysis/

echo "Removing previous links and creating new ones"
rm -f PEreads*
rm -f SEreads*

ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608/flowcell608_lane1_pair1_ACAGTC.fastq.gz PEreads1.fastq.gz
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell608/flowcell608_lane1_pair2_ACAGTG.fastq.gz PEreads2.fastq.gz
ln -s /rhome/arajewski/shared/genetree/sequencing/flowcell636/flowcell636_lane1_pair1_ACAGTG.fastq.gz SEreads.fastq.gz

echo "Loading required packages"
module unload perl
module load perl/5.22.0
module load trinity-rnaseq

echo "beginning single end sequence trimming with $SLURM_NTASKS cores."
#Single End Trimming

java -jar /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.4.0/trinity-plugins/Trimmomatic/trimmomatic.jar SE -threads $SLURM_NTASKS -phred33 SEreads.fastq.gz SEreadsTrimmed.fq.gz  ILLUMINACLIP:/bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.4.0/trinity-plugins/Trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25
