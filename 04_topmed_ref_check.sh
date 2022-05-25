#!/bin/bash
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH	--cpus-per-task=16
#SBATCH --mem-per-cpu=8G
#SBATCH --mail-user=shweta.pipaliya@epfl.ch
#SBATCH --job-name=topmed_ref_check
#SBATCH --error=topmed_ref_check_error

perl HRC-1000G-check-bim.pl -b Borghesi_0921_Plates1to14_QC.bim -f Borghesi_0921_Plates1to14_QC.frq -r PASS.Variantsbravo-dbsnp-all.tab.gz -h

#end