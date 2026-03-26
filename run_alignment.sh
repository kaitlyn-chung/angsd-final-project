#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=align_reads
#SBATCH --mem=100G

STAR_Dir="/athena/angsd/scratch/kch4018/angsd_project/genome_index"

DIRS=(
  "/athena/angsd/scratch/kch4018/angsd_project/pre_T"
  "/athena/angsd/scratch/kch4018/angsd_project/post_T"
)

for dir in "${DIRS[@]}"; do
    for r1 in "$dir"/*_1_val_1.fq.gz; do
    echo "DIR: $dir"
    
    # Base path without the suffix
    base="${r1%_1_val_1.fq.gz}"

    # Mates and sample name
    r2="${base}_2_val_2.fq.gz"
    sample="$(basename "$base")"
    out_prefix="${dir}/${sample}."

    STAR --runMode alignReads \
        --runThreadN 8 \
        --genomeDir "$STAR_Dir" \
        --readFilesIn "${r1}" "${r2}" \
        --readFilesCommand zcat \
        --outFileNamePrefix "$out_prefix" \
        --outSAMtype BAM SortedByCoordinate
    done
done