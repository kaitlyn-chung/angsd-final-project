#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --job-name=featureCounts
#SBATCH --mem=100G

gtf=/athena/angsd/scratch/kch4018/angsd_project/genome_index/hg38.refGene.gtf
input_dir=/athena/cayuga_0019/scratch/kch4018/angsd_project/processed/*.bam
output=/athena/cayuga_0019/scratch/kch4018/angsd_project/processed/feature_counts.txt

conda activate angsd
featureCounts \
    -p \
    -s 2 \
    --countReadPairs \
    -T 12 \
    -a $gtf \
    -o $output \
    $input_dir