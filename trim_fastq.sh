#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=trim_fastq
#SBATCH --mem=100G

DIRS=(
  "/athena/angsd/scratch/kch4018/angsd_project/pre_T"
  "/athena/angsd/scratch/kch4018/angsd_project/post_T"
)

conda activate trim-galore

THREADS=${SLURM_CPUS_PER_TASK}

for dir in "${DIRS[@]}"; do
    for f in "$dir"/*_1.fastq.gz; do
    echo "DIR: $dir"
    basename=${f%_1.fastq.gz}
    echo $basename
    trim_galore --cores $THREADS -q 20 --paired "$basename"_1.fastq.gz "$basename"_2.fastq.gz --length 35 --retain_unpaired  --stringency 5 --fastqc --fastqc_args "--threads $THREADS" --output_dir "$dir"
    done
done