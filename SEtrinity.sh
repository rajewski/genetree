#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=100G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

cd /rhome/arajewski/shared/genetree/analysis/

module unload perl
module load perl/5.22.0
module load trinity-rnaseq

Trinity --seqType fq --max_memory $((SLURM_MEM_PER_NODE/1000))'G' --bflyCalculateCPU --single SEreadsTrimmed.fq.gz --SS_lib_type R --CPU $SLURM_NTASKS --full_cleanup --output /rhome/arajewski/shared/genetree/trinity_output_fabianaSEonly
