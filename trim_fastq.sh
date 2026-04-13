#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --array=1-16
#SBATCH --cpus-per-task=4
#SBATCH --job-name=trim
#SBATCH --mem=30G

conda activate trim-galore

samples_list="/athena/angsd/scratch/kch4018/angsd_project/samples.txt"

THREADS=${SLURM_CPUS_PER_TASK}

SAMPLE=$(sed -n "${SLURM_ARRAY_TASK_ID}p" $samples_list)

prefix="${SAMPLE%_1.fastq.gz}"
mate2="${prefix}_2.fastq.gz"

outdir="$(dirname "$SAMPLE")/trimmed_qc"
mkdir -p "$outdir"

trim_galore --cores $THREADS \
  -q 20 \
  --paired "${prefix}_1.fastq.gz" "$mate2" \
  --length 35 \
  --retain_unpaired \
  --stringency 5 \
  --fastqc --fastqc_args "--threads 1" --output_dir "$outdir"