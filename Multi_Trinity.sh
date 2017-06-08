#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=400G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

#This script assumes that the trimming of both the SE and PE files has already been completed and that the files are properly named bsed on the output of the Multi_Trimmomatic.sh script.

cd /rhome/arajewski/shared/genetree/analysis/

echo "$0 [$(date +%T)]: Renaming trimmed files for consistency."
mv PEreadsTrimmed_1P.fq.gz AllreadsTrimmed_1P.fq.gz
mv PEreadsTrimmed_2P.fq.gz AllreadsTrimmed_2P.fq.gz
mv PEreadsTrimmed_2U.fq.gz AllreadsTrimmed_2U.fq.gz

echo "$0 [$(date +%T)]: Loading required packages."
module unload perl
module load perl/5.22.0
module load trinity-rnaseq

echo "$0 [$(date +%T)]: Running Trinity without trimming using $SLURM_NTASKS_PER_NODE cores and $SLURM_MEM_PER_NODE memory."
Trinity --seqType fq --max_memory $SLURM_MEM_PER_NODE --bflyCalculateCPU --left AllreadsTrimmed_1P.fq.gz,AllreadsTrimmed_1U.fq.gz --right AllreadsTrimmed_2P.fq.gz,AllreadsTrimmed_2U.fq.gz --SS_lib_type RF --CPU $SLURM_NTASKS_PER_NODE  --output /rhome/arajewski/shared/genetree/trinity_output_fabiana_rerun

