#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=16
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=shweta.pipaliya@epfl.ch
#SBATCH --job-name=topmed
#SBATCH --output=topmed_out


./CreateTOPMed.pl -i bravo-dbsnp-all.vcf.gz

#end