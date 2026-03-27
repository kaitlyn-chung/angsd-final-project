#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=multiqc
#SBATCH --mem=100G

conda activate multiqc
multiqc $qorts_dir -o $out_dir/multiqc_report