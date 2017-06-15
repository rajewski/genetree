#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=50G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

PEfile1=flowcell608/flowcell608_lane1_pair1_ACAGTG.fastq.gz
PEfile2=flowcell608/flowcell608_lane1_pair2_ACAGTG.fastq.gz
SEfile=flowcell636/flowcell636_lane1_pair1_ACAGTG.fastq.gz

cd /rhome/arajewski/shared/genetree/results/Fabiana/

#Check the input files exist
if [ ! -e ../../sequencing/$PEfile1 ] || [ ! -e ../../sequencing/$PEfile2 ] || [ ! -e ../../sequencing/$SEfile ]
then
    echo "$0 [$(date +%T)]: One of more inputs do not exist. Please check the filenames."
    exit 1
else 
    echo "$0 [$(date +%T)]: Input files successfully located."
fi

#Load required packages
echo "$0 [$(date +%T)]: Loading required packages"
module unload perl
module load perl/5.22.0
module load trinity-rnaseq

#Check for previous runs and do single end trimming
if [ ! -e SEreadsTrimmed.fq.gz ]
then
    echo "$0 [$(date +%T)]: Trimming Single-end read files with Trimmomatic using $SLURM_NTASKS cores."
    echo "$0 [$(date +%T)]: Creating symlinks to datafiles."
    ln -s /rhome/arajewski/shared/genetree/sequencing/$SEfile SEreads.fastq.gz
    echo "$0 [$(date +%T)]: Running Trimmomatic."
    java -jar /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.4.0/trinity-plugins/Trimmomatic/trimmomatic.jar SE -threads $SLURM_NTASKS -phred33 SEreads.fastq.gz SEreadsTrimmed.fq.gz  ILLUMINACLIP:/bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.4.0/trinity-plugins/Trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25
    find -type l -delete
    echo "$0 [$(date +%T)]: Done."
else
    echo "$0 [$(date +%T)]: Trimmed Single-end Read File exists, skipping this step."
fi

#Do separate in silico normalization to prevent discarding unpaired data
if [ ! -e insilico_read_normalization/single.norm.fq ]
then
    echo "$0 [$(date +%T)]: Performing in silico read normalization on single-end trimmed reads"
    mkdir insilico_read_normalization
    insilico_read_normalization.pl --seqType fq --JM $((SLURM_MEM_PER_NODE)/1000)'G' --max_cov 50 --single ../SEreadsTrimmed.fq.gz --SS_lib_type R --CPU $SLURM_NTASKS --output insilico_read_normalization --max_pct_stdev 10000
    echo "$0 [$(date +%T)]: Done."
else
   echo "$0 [$(date +%T)]: Normalized read file detected, skipping this step."
fi 

#Check for previous run and do paired end trimming
if [ ! -e PEreadsTrimmed_1P.fq.gz ] || [ ! -e PEreadsTrimmed_2P.fq.gz ] || [ ! -e PEreadsTrimmed_1U.fq.gz ] || [ ! -e PEreadsTrimmed_2U.fq.gz ]
then
    echo "$0 [$(date +%T)]: Trimming paired-end read files with Trimmomatic using $SLURM_NTASKS cores."
    echo "$0 [$(date +%T)]: Creating symlinks to datafiles."
    ln -s /rhome/arajewski/shared/genetree/sequencing/$PEfile1 PEreads1.fastq.gz
    ln -s /rhome/arajewski/shared/genetree/sequencing/$PEfile2 PEreads2.fastq.gz
    echo "$0 [$(date +%T)]: Running Trimmomatic."
    java -jar /bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.4.0/trinity-plugins/Trimmomatic/trimmomatic.jar PE -threads $SLURM_NTASKS -phred33 PEreads1.fastq.gz PEreads2.fastq.gz -baseout PEreadsTrimmed.fq.gz  ILLUMINACLIP:/bigdata/bioinfo/pkgadmin/opt/linux/centos/7.x/x86_64/pkgs/trinity-rnaseq/2.4.0/trinity-plugins/Trimmomatic/adapters/TruSeq3-SE.fa:2:30:10 SLIDINGWINDOW:4:5 LEADING:5 TRAILING:5 MINLEN:25
    find -type l -delete
    echo "$0 [$(date +%T)]: Done."
else
    echo "$0 [$(date +%T)]: Trimmed paired-end read files exist, skipping this step."
fi

#Do in silico read normalization for paired end data
if [ ! -e insilico_read_normalization/right.norm.fq ] || [ ! -e insilico_read_normalization/left.norm ]
then
    echo "$0 [$(date +%T)]: Performing in silico read normalization on paired-end trimmed reads"
    mkdir insilico_read_normalization
    insilico_read_normalization.pl --seqType fq --JM $((SLURM_MEM_PER_NODE)/1000)'G' --max_cov 50 --CPU $SLURM_NTASKS --output insilico_read_normalization   --max_pct_stdev 10000  --SS_lib_type RF  --left PEreadsTrimmed_1P.fq.gz,PEreadsTrimmed_1U.fq.gz --right PEreadsTrimmed_2P.fq.gz,PEreadsTrimmed_2U.fq.gz --pairs_together --PARALLEL_STATS
    echo "$0 [$(date +%T)]: Done."

else
   echo "$0 [$(date +%T)]: Normalized read file detected, skipping this step."
fi

#Combine the single-end reads into the 1st set of unpaired paired-end reads
echo "$0 [$(date +%T)]: Appending single-end reads into the paired-end file." 
cat left.norm.fa single.norm.fa > combinedleft.norm.fa 
