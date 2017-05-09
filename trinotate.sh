#!/bin/bash -l
#SBATCH --ntasks=16
#SBATCH --nodes=1
#SBATCH --mem=320G
#SBATCH --time=07:00:00                                                                                                            
#SBATCH --mail-user=araje002@ucr.edu
#SBATCH --mail-type=ALL 

module unload perl
module load perl/5.22.0
module load trinityrna-seq
module load trinotate

if [ ! -e ../trinity_output_$1/Trinity.fasta ]
then
    echo "$0: Input transcriptome does not exist. Please check the filename."
    exit 1
else 
    echo "$0: Found input fasta assembly from Trinity."
fi


#Run Transdecoder to find the ORFs but add in the name of hte transdecoder ouptu file
if [ ! -e ../trinity_output_$1/transcripts.fasta.transdecoder.pep ]
then
    echo "$0: List of ORFs not found. Running TransDecoder now."
    module load transdecoder
    TransDecoder.LongOrfs -t Trinity.fasta
    echo "$0: TransDecoder is finished, moving file to output directory."
    mv transcripts.fasta.transdecoder.pep
    echo "$: TransDecoder output copying done."
else
    echo "$0: List of TransDecoder ORFs found, skipping this step."
fi


