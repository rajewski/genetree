#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=50G
#SBATCH --time=06:00:00
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL

cd /rhome/arajewski/shared/genetree/analysis

module unload perl
module load perl/5.22.0
module load trinity-rnaseq

insilico_read_normalization.pl --seqType fq --JM 10G --max_cov 50 --single ../results/Fabiana/SEreadsTrimmed.fq.gz --SS_lib_type R
