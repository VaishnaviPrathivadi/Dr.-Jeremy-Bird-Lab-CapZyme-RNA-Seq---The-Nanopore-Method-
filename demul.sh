#! /bin/bash

# files
input="/home/birdlab/Desktop/Bird_lab_seq_data/FTTRNAKDas/no_sample/20230314_1327_MN40584_FAV92862_dbd37ce2/Basecalled/pass"
output="/home/birdlab/Desktop/Bird_lab_seq_data/FTTRNAKDas/no_sample/20230314_1327_MN40584_FAV92862_dbd37ce2/Basecalled/normal"

# Demultiplexing of (PCR-)cDNA files
guppy_barcoder \
--input_path "${input}" \
--save_path "${output}" \
--config "/home/birdlab/Desktop/Bird_lab_seq_data/FTTRNAKDas/no_sample/20230314_1327_MN40584_FAV92862_dbd37ce2/Basecalled/configuration.cfg" \
--barcode_kits SQK-PCB109 \
--progress_stats_frequency 60
