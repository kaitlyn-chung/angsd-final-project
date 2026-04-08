#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=do_qc
#SBATCH --mem=40G

conda activate multiqc

DIRS=(
  "/athena/angsd/scratch/kch4018/angsd_project/pre_T"
  "/athena/angsd/scratch/kch4018/angsd_project/post_T"
)

for dir in "${DIRS[@]}"; do
    echo "Running MultiQC on ${dir}"
    multiqc "$dir" -o "$dir/multiqc"
done