#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --array=1-16
#SBATCH --job-name=alignment
#SBATCH --mem=100G

STAR_Dir="/athena/angsd/scratch/kch4018/angsd_project/genome_index"

samples_list="/athena/angsd/scratch/kch4018/angsd_project/reads.txt"

r1=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $samples_list)
base="${r1%_1_val_1.fq.gz}"
r2="${base}_2_val_2.fq.gz"

sample="$(basename "$base")"
outdir="/athena/angsd/scratch/kch4018/angsd_project/STAR_aligned"
mkdir -p "$outdir"


conda activate angsd

if [[ ! -s "$r1" || ! -s "$r2" ]]; then
    echo "[$(date)] Skipping sample '$sample': paired files missing or empty"
    exit 0
fi

STAR --runMode alignReads \
    --runThreadN 12 \
    --genomeDir "$STAR_Dir" \
    --readFilesIn "${r1}" "${r2}" \
    --readFilesCommand zcat \
    --outFileNamePrefix "$outdir/$sample." \
    --outSAMtype BAM SortedByCoordinate