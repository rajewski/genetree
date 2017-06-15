#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=400G
#SBATCH --time=20:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

#This script assumes that the trimming of both the SE and PE files has already been completed and that the files are properly named bsed on the output of the Multi_Trimmomatic.sh script.

cd /rhome/arajewski/shared/genetree/results/Fabiana/

if [ ! -e insilico_read_normalization/combleft.norm.fq ] || [ ! -e insilico_read_normalization/right.norm.fq ]
then
    echo "$0 [$(date +%T)]: Combined SE and PE file note found. Please run the Multi_Trimmomatic.sh script or check file names."
    exit 1
else
     echo "$0 [$(date +%T)]: Input files found."
fi

echo "$0 [$(date +%T)]: Loading required packages."
module unload perl
module load perl/5.22.0
module load trinity-rnaseq

echo "$0 [$(date +%T)]: Running Trinity without trimming or normalization using $SLURM_NTASKS_PER_NODE cores and $SLURM_MEM_PER_NODE memory."
Trinity --seqType fq --max_memory $((SLURM_MEM_PER_NODE/1000))'G' --bflyCalculateCPU --left insilico_read_normalization/combleft.norm.fq --right insilico_read_normalization/right.norm.fq --SS_lib_type RF --CPU $SLURM_NTASKS --no_normalize_reads --full_cleanup --output /rhome/arajewski/shared/genetree/trinity_output_fabiana_SEPE

