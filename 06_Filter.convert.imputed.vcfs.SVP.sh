#!/bin/bash

#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4G
#SBATCH --time 72:00:00
#SBATCH --output=plink_convert.%a.out
#SBATCH --error=plink_convert.%a.error
#SBATCH --array=1-23
#SBATCH --job-name=plink_convert

#############################################################
#### Filter imputed VCF files per chromosome ####
#############################################################

## Specify number of cpus-per-task given and memory (Mb) for plink ##
THREADS=2
MEM=10000

## variables 
chr=$(sed -n ${SLURM_ARRAY_TASK_ID}p chr_list.txt)
ref=/work/backup/gr-fe/pipaliya/gwas/reference/GRCh38/Homo_sapiens_assembly38.fasta

## Specify number of cpus-per-task given and memory (Mb) for plink ##
THREADS=2
MEM=10000

## Filter imputed VCF on R2 score > 0.3 ###
./bcftools view -Ou -i 'R2>0.3' $chr.dose.vcf.gz -o $chr.concat.filt.vcf.gz --threads $THREADS

## Convert individual filtered vcfs to bcf format and index resulting bcf
./bcftools view -Ob -o $chr.filt.bcf $chr.concat.filt.vcf.gz
./bcftools index -f $chr.filt.bcf --threads $THREADS

## Check ref filtered bcf files and output a TEMP filtered file followed by indexing
./bcftools norm -Ou -m -any $chr.filt.bcf | ./bcftools norm -Ob --check-ref x -f $ref -o $chr.filt.tmp.bcf
./bcftools index $chr.filt.tmp.bcf --threads $THREADS

## Convert filtered files to PLINK using the filtered bcf and temp files - keeping rs ID if present  ###
./bcftools norm -Ou -m -any $chr.filt.bcf | \
  ./bcftools norm -Ob --check-ref x -f $REF -o $chr.filt.tmp.bcf

./bcftools index $chr.filt.tmp.bcf --threads $THREADS

./bcftools annotate -Ou -x ID -I +'%CHROM:%POS:%REF:%ALT' $chr.filt.tmp.bcf | \
  ./bcftools norm --rm-dup all -Ob | \
  ./plink --bcf /dev/stdin \
   --set-missing-var-ids @:#:\$1:\$2 \
   --keep-allele-order \
   --double-id \
   --biallelic-only \
   --make-bed \
   --allow-extra-chr 0 \
   --memory $MEM \
   --threads $THREADS \
   --out ./PLINK/$chr.BorghesiGBS

### Update ID, so either rsID or chr:pos:ref:alt ID is kept ###
## use bcftools query to extract list of rs SNPs from "./TMP/$chr.filt.tmp.bcf"
./bcftools query -f '%ID\t%CHROM:%POS:%REF:%ALT\n' $chr.filt.tmp.bcf > $chr.BorghesiGBS.snps.tmp 
awk -F "[\t:]" '{if ($1 ~ "rs") print $1,$5":"$2":"$3":"$4; else print $5":"$6":"$7":"$8,$5":"$6":"$7":"$8}' $chr.BorghesiGBS.snps.tmp > $chr.BorghesiGBS.snps

## perform the update
./plink --bfile ./PLINK/$chr.BorghesiGBS \
  --update-name ./PLINK/$chr.BorghesiGBS.snps 1 2 \
  --make-bed \
  --keep-allele-order \
  --memory $MEM \
  --threads $THREADS \
  --out ./PLINK/$chr.BorghesiGBS.rs

### Clean ###
##rm ./TMP/$CHR.filt.tmp.bcf
##rm ./PLINK/txt/$CHR.$PROJECT.snps.tmp




