#!/bin/bash
#SBATCH --time=10:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=1
#SBATCH --mem-per-cpu=40G
#SBATCH --mail-user=shweta.pipaliya@epfl.ch
#SBATCH --job-name=bcftools_fixref
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

module load StdEnv/2020 gcc/9.3.0 bcftools/1.13

bcftools +fixref Borghesi_0921_Plates1to14_QC.chr.xy.vcf.gz -Oz -o Borghesi_0921_Plates1to14_QC.chr.xy.vcf.gz -- -f Homo_sapiens_assembly38.fasta