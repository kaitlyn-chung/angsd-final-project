#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=make_index
#SBATCH --mem=100G

for file in processed/*.bam; do
  samtools index $file
  echo "$file indexed"
  done