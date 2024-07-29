#!/bin/bash

#Transcript initation script

input="/home/birdlab/Desktop/microbepore/data/mapped/raw/${1}"
outdir="/home/birdlab/Desktop/microbepore/data/tss/trimmed"

# perform tss detection for pychopper auto > cutadapt_polyA > SSP-cutadapt > clipped  or for raw mapped reads
for file in ${input}/*/*.sorted.bam
do 
  # file and folder names
  foldername=${outdir}/${1}
  filename=$(basename ${file})
  filename=${filename%%.*}
  output=${foldername}/${filename}
 
  # make directories
  mkdir ${outdir} 2> /dev/null
  mkdir ${foldername} 2> /dev/null
  mkdir ${output} 2> /dev/null
  
  # step 1: calculate 5´positions for plus and minus strand
  bedtools genomecov \
    -ibam ${file} \
    -bga \
    -5 \
    -strand + > ${output}/${filename}.plus.bedgraph
  
  bedtools genomecov \
    -ibam ${file} \
    -bga \
    -5 \
    -strand - > ${output}/${filename}.minus.bedgraph
  
  
  # step 2: termseq peaks
  termseq_peaks ${output}/${filename}.plus.bedgraph ${output}/${filename}.plus.bedgraph --peaks ${output}/${filename}.plus.peaks --strand +
  termseq_peaks ${output}/${filename}.minus.bedgraph ${output}/${filename}.minus.bedgraph --peaks ${output}/${filename}.minus.peaks --strand -
  # step 3: add coverage information
  bedtools intersect \
    -wao \
    -a ${output}/${filename}.plus.peaks.oracle.narrowPeak \
    -b ${output}/${filename}.plus.bedgraph \
    > ${output}/${filename}.plus.peaks.oracle.narrowPeak.counts
    
  bedtools intersect \
    -wao \
    -a ${output}/${filename}.minus.peaks.oracle.narrowPeak \
    -b ${output}/${filename}.minus.bedgraph \
    > ${output}/${filename}.minus.peaks.oracle.narrowPeak.counts

  exit
done
