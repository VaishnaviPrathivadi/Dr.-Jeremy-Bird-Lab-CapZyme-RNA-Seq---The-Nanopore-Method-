#! /bin/bash

input="/home/birdlab/Desktop/microbepore/data/mapped/raw/${1}" # input directory with all remapped files
outdir="/home/birdlab/Desktop/microbepore/data/salmon"
transcripts="/home/birdlab/Desktop/microbepore/data/genome/${2}.transcripts.fasta"

for file in ${input}/*/*remapped.sorted.bam
do
	# folder and filenames
	f_ex=${file##*/}
	foldername=${1}
	filename=${f_ex%%.*}
	output=$outdir/${foldername}/${filename}

	# create dir for quantification using salmon in alignment-based mode (e.g. used in conda environment)
	mkdir ${outdir}
	mkdir ${outdir}/${foldername}
	mkdir ${output}

	# use conda in alignment-based mode
	salmon quant \
	-t ${transcripts} \
	-l A \
	-a ${file} 
	-o ${output} \
	--threads 8
done
