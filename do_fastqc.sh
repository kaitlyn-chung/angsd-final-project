#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --job-name=fastqc
#SBATCH --mem=100G


preT_dir="/athena/angsd/scratch/kch4018/angsd_project/pre_T"
postT_dir="/athena/angsd/scratch/kch4018/angsd_project/on_T"

DIRS=("$preT_dir" "$postT_dir")

for dir in "${DIRS[@]}"; do
    outdir="$dir/fastqc_results"    
    mkdir -p "$outdir"
    for file in "$dir"/*.fastq.gz; do
        fastqc "$file" --threads 4 --extract -o "$outdir"
    done
done