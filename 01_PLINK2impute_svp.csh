#!/usr/bin/csh

#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --cpus-per-task 8
#SBATCH --output=./logs/01_p2Imp.out
#SBATCH --error=./logs/01_p2Imp.err
#SBATCH --job-name=p2Imp
#SBATCH --mem 40G
#SBATCH --time 01:30:00

### Load modules ###
bash -c 'source /dcsrsoft/spack/bin/setup_dcsrsoft; module load gcc r bcftools htslib perl; exec csh'

#### Prep environment
mkdir -p ./logs
mkdir -p ./logs/phasing
mkdir -p ./logs/imputation
mkdir -p ./logs/concat
mkdir -p ./logs/filter


#############################################################################
#						   Set Variables here								#
#############################################################################
set PROJ = borghesi_gbs
set WD = /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes
set THREADS = 8
set MEM = 40000

## RAW input files
set FR1 = "$WD"/00_raw_files/Borghesi_0921_Plates1to14

## Path to reference files
set REF = /work/backup/gr-fe/pipaliya/gwas/reference/GRCh38/Homo_sapiens_assembly38

## Software
set PLINK = /work/backup/gr-fe/pipaliya/tools/plink

#############################################################################
#					     Final Report to Plink data set						#
#############################################################################

set REPORT = 0	# PED to BED
set QC = 0
set ONEKG = 0	# checks AF with 1KG ref and writes out outliers
set PCA = 0
set VCF = 1

if ($REPORT) then
  $PLINK --file "$FR1" --make-bed --out "$WD"/"$PROJ" --threads $THREADS --memory $MEM
endif

	#############################################################################
	#								    Sample QC								#
	#############################################################################


if ($QC) then
  
   ## QC by sample
  king -b "$WD"/$PROJ.bed --bysample --cpus $THREADS

  ## Exclude samples with excessive missingess or heterozygosity based on above King output
  ## And remove chr 0 SNPs  
  

  $PLINK --bfile "$WD"/$PROJ --remove QC1.failed.samples.txt --not-chr 0 --make-bed --out "$WD"/$PROJ.1
	## Prune data, IBS calculation, assess heterozygosity

#	$PLINK --bfile "$WD"/"$PROJ".1 --exclude "$WD"/"$PROJ"_MHC.snplist --indep-pairwise 1500 150 0.2 --make-bed --out "$WD"/"$PROJ"_LDpruned --memory $MEM --threads $THREADS
#	$PLINK --bfile "$WD"/"$PROJ"_LDpruned --extract "$WD"/"$PROJ"_LDpruned.prune.in --genome --out "$WD"/"$PROJ"_IBS --memory $MEM --threads $THREADS
#	$PLINK --bfile "$WD"/"$PROJ"_LDpruned --extract "$WD"/"$PROJ"_LDpruned.prune.in --het --out "$WD"/"$PROJ"_het --memory $MEM --threads $THREADS
  
	
  ### No removal at this stage. Needs to be taken care of when analysing the data!

	#############################################################################
	#								    Marker QC								#
	#############################################################################
	
  $PLINK --bfile "$WD"/"$PROJ" --geno 0.1 --make-bed --out "$WD"/"$PROJ"_sampleQCed --keep-allele-order --memory $MEM --threads $THREADS
  	
  $PLINK --bfile "$WD"/"$PROJ"_sampleQCed --freq --mind 0.1 --hwe 1e-10 --make-bed --out "$WD"/"$PROJ"_QC --keep-allele-order --memory $MEM --threads $THREADS

  
 ### Infer close relationship ###
  
  king -b "$WD"/"$PROJ"_QC.bed --related --degree 2 --cpus $THREADS --prefix "$PROJ"
endif


if ($ONEKG) then
	#############################################################################
	#					Check AF with 1KG reference panel
	############################################################################
	$PLINK --bfile "$WD"/"$PROJ"_QC --freq --out "$WD"/"$PROJ"_QC --memory $MEM --threads $THREADS
	
	perl /work/backup/gr-fe/pipaliya/gwas/reference/1kg_ref_panel/HRC-1000G-check-bim.pl \
    -b "$WD"/"$PROJ"_QC.bim \
    -f "$WD"/"$PROJ"_QC.frq \
    -r /work/backup/gr-fe/pipaliya/gwas/reference/1kg_ref_panel/1000GP_Phase3_combined.legend -g -p EUR

	head -n5 Run-plink.sh > "$WD"/Run-plink.mod.sh
	sed -i -- 's/plink/$1/g' "$WD"/Run-plink.mod.sh
	sed -i 's/.*/& --noweb/' "$WD"/Run-plink.mod.sh
	sh "$WD"/Run-plink.mod.sh $PLINK

	mkdir -p "$WD"/logs/1KG-check_OUT
	rm "$WD"/TEMP*
	mv "$WD"/*-"$PROJ"* "$WD"/Run-plink* "$WD"/logs/1KG-check_OUT/

endif


if ($PCA) then
	## Principal components analysis (PCA)

	mkdir -p "$WD"/PCA
	cp /work/backup/gr-fe/pipaliya/gwas/borghesi_gbs/genotypes/09_PCA/pre-imputation_null/run_PCA_svp.csh "$WD"/PCA
	cp "$WD"/"$PROJ"_QC.??? "$WD"/PCA
	cd "$WD"/PCA
	sbatch ./run_PCA_svp.csh "$PROJ"_QC
	cd "$WD"
endif



###########################################################################
###									Prepare for imputation							#
###########################################################################

if ($VCF) then
	$PLINK --bfile $WD/"$PROJ"_QC-updated --recode vcf-iid --keep-allele-order --out $WD/"$PROJ"_QC --memory $MEM --threads $THREADS
	bgzip -f $WD/"$PROJ"_QC.vcf
	bcftools index $WD/"$PROJ"_QC.vcf.gz --threads $THREADS

# Rename Chromosomes
	bcftools annotate -Oz --rename-chrs work/backup/gr-fe/pipaliya/gbs_gwas/chromosome_rename/number_chr.txt $WD/"$PROJ"_QC.vcf.gz > $WD/"$PROJ"_QC.xy.vcf.gz --threads $THREADS
	bcftools index $WD/"$PROJ"_QC.xy.vcf.gz --threads $THREADS
	
	# chec/fix ref
	bcftools +fixref $WD/"$PROJ"_QC.xy.vcf.gz -Oz -o $WD/"$PROJ".refcheck.vcf.gz -- -f $REF/human_g1k_v37.fasta
	bcftools index $WD/"$PROJ".refcheck.vcf.gz --threads $THREADS

	# double-check that everything is fine
	bcftools norm --check-ref w -f $REF/human_g1k_v37.fasta $WD/"$PROJ".refcheck.vcf.gz -Oz -o $WD/clean.vcf.gz --threads 28
	bcftools index $WD/clean.vcf.gz --threads 28
#	rm $WD/clean.vcf.gz
	
	# split clean vcf into vcf file per chromosomes for TOPMED Imputation Server
	
	bcftools index -s $WD/"$PROJ".vcf.gz | cut -f 1 | while read C; do bcftools view -O z -o split.${C}.vcf.gz $WD/"$PROJ".vcf.gz "${C}" ; done

### Plot AF vs 1KG ####
	mkdir -p AF_dist_data
  bcftools index $WD/"$PROJ".refcheck.vcf.gz
  bcftools annotate -c INFO/AF -a /data/PRTNR/CHUV/MED/jfellay/default_sensitive/redin/Genotyping/AF_ONEKG/af.vcf.gz $WD/"$PROJ".refcheck.vcf.gz | bcftools +af-dist | grep ^PROB > ./AF_dist_data/data.dist."$PROJ".refcheck.txt
  Rscript --vanilla /data/PRTNR/CHUV/MED/jfellay/default_sensitive/redin/Genotyping/plot.VCF.AF.R "$PROJ".refcheck

endif









