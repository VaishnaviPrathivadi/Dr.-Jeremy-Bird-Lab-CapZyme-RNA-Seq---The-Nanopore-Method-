#! /bin/bash

input="/home/birdlab/Desktop/microbepore/data/FAST5/${1}"
output_cDNA="/home/birdlab/Desktop/microbepore/data/basecalled/${1}"

# Basecalling of cDNA files
guppy_basecaller \
--input_path "${input}" \
--save_path "${output_cDNA}" \
-c dna_r9.4.1_450bps_hac.cfg \
--compress_fastq \
--recursive \
--progress_stats_frequency 60 \
--chunks_per_runner 256 \
--gpu_runners_per_device 4 \
--num_callers 1 \
-x auto \
--barcode_kits SQK-PCB109
