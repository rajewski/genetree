This is the git repo for assembling several transcriptomes from 2x75bp NextSeq data

By Alex Rajewski, UC, Riverside, 2017

The input data is demultiplexed fastq files, so the barcodes have already been trimmed off, but not other quality trimming has taken place.

This will also be a de novo assembly, so there is no genome assembly to reference.

The Trinity.sh file is a single step file that will take one or more pairs of read fastq files and perform all necessary quality trimming and assembly. 

The files Multi_Trimmomatic.sh is the first in a series of scripts that can be used to assembly data coming from both paired-end and single-end data simultaneously.