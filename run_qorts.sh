#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=qorts
#SBATCH --mem=100G

bam_file=/athena/angsd/scratch/kch4018/angsd_project/pre_T/processed/SRR31204761.Aligned.sortedByCoord.out.bam 
gtf_file=/athena/angsd/scratch/kch4018/angsd_project/index_files/genomic.gtf
out_dir=/athena/angsd/scratch/kch4018/angsd_project/pre_T/processed/qc

jar_file=/athena/angsd/scratch/mef3005/share/envs/qorts/share/qorts-1.3.6-1/QoRTs.jar

mkdir -p $out_dir

conda activate qorts
java -jar $jar_file \
QC --stranded --generatePlots \
$bam_file $gtf_file $out_dir

java -jar $jar_file generateSamplePlots $out_dir \
    --makeSeparatePngs