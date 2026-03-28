#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --job-name=multiqc
#SBATCH --mem=8G

out_dir=/athena/angsd/scratch/kch4018/angsd_project/processed/qc/qorts

conda activate multiqc

multiqc "$out_dir" -o "$out_dir/multiqc_report"