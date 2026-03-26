#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --job-name=do_qc
#SBATCH --mem=100G

conda activate angsd
fastqc *.bam --extract -t 12 -o "qc"