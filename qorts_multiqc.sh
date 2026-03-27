#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=multiqc
#SBATCH --mem=50G

conda activate multiqc

qorts_dir=/athena/angsd/scratch/kch4018/angsd_project/processed/qc/qorts

multiqc $qorts_dir -o $qorts_dir/multiqc_report