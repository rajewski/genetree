This is the git repo for assembling several transcriptomes from 2x75bp NextSeq data

By Alex Rajewski, UC, Riverside, 2017

The input data is demultiplexed fastq files, so the barcodes have already been trimmed off, but not other quality trimming has taken place.

This will also be a de novo assembly, so there is no genome assembly to reference.

The Trinity.sh file is a single step file that will take one or more pairs of read fastq files and perform all necessary quality trimming and assembly. 

Multi_Trimmomatic.sh is the first in a series of scripts that can be used to assemble data coming from both paired-end and single-end data simultaneously. This script runs only trimmomatic with the default Trinity settings on a set of single-end data and then on a set of paired-end data. It ultimately combines the surviving single-end reads into the fq file of the reads from the paired end dataset that survived the trimming without their corresponding pair partner.

Multi_Trinity.sh takes the output files of Mult_Trimmomatic and runs a trinity assembly with normalization on them.