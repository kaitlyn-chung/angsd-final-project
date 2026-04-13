#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=featureCounts
#SBATCH --mem=40G

gtf=/athena/angsd/scratch/kch4018/angsd_project/genome_index/hg38.refGene.gtf
bam_dir=/athena/cayuga_0019/scratch/kch4018/angsd_project/STAR_aligned/*.bam

output=/athena/cayuga_0019/scratch/kch4018/angsd_project/feature_count/feature_counts.txt
mkdir -p "$(dirname "$output")"

conda activate angsd
featureCounts \
    -p \
    -s 2 \
    --countReadPairs \
    -T 8 \
    -t exon \
    -g gene_id \
    -a $gtf \
    -o $output \
    $bam_dir