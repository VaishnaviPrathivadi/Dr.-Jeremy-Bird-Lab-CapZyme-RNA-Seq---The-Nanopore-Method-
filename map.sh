#! /bin/bash

input="/home/birdlab/Desktop/microbepore/data/basecalled/${1}/pass"
fasta="/home/birdlab/Desktop/microbepore/data/genome/${2}.fasta"
transcripts="/home/birdlab/Desktop/microbepore/data/genome/${2}.transcripts.fasta"
outdir="/home/birdlab/Desktop/microbepore/data/mapped/raw"

# Mapping & Remapping - loop through all FASTQs
for file in $(ls -1 ${input}/*/*.fastq*)
do
	# folder and filenames
  	f_ex=${file##*/}
  	foldername=${1} # depending on how you name your files 
  	filename=${f_ex%%.*}
	output="${outdir}/${foldername}/${filename}" # run_id/barcode_id
	sam=${output}/${filename}.sam
	bam=${output}/${filename}.bam
	sorted=${output}/${filename}.sorted.bam
	refile=${output}/${filename}.remapped.fastq
	resam=${output}/${filename}.remapped.sam
	rebam=${output}/${filename}.remapped.bam
	resorted=${output}/${filename}.remapped.sorted.bam

	# make directories
	mkdir "${outdir}/${foldername}" # run_id
	mkdir ${output}

	if [[ ${filename} =~ "RNA" ]]
	then
		# align using minimap2
		minimap2 -ax splice -p 0.99 -uf -k14 --MD -t 8 ${fasta} ${file} > ${sam} # DRS
	else
		minimap2 -ax splice -p 0.99 -k14 --MD -t 8 ${fasta} ${file} > ${sam} # (PCR-)cDNA
	fi

	# convert to sorted.bam file
	samtools view -bS ${sam} -o ${bam}
	samtools sort ${bam} -o ${sorted}
	samtools index ${sorted}

	# bam to fastq for remapping of mapped reads
	bedtools bamtofastq -i ${sorted} -fq ${refile}

	# map again
	if [[ ${filename} =~ "RNA" ]]
	then
		minimap2 -ax splice -p 0.99 -uf -k14 --MD -t 8 ${transcripts} ${refile} > ${resam}
	else
		minimap2 -ax splice -p 0.99 -k14 --MD -t 8 ${transcripts} ${refile} > ${resam}
	fi
		
	# convert to sorted.bam file
	samtools view -bS ${resam} -o ${rebam}
	samtools sort ${rebam} -o ${resorted}
	samtools index ${resorted}
done
