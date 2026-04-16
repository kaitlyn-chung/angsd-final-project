#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --array=0-16
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --job-name=qorts
#SBATCH --mem=32G

conda activate qorts

gtf_file=/athena/angsd/scratch/kch4018/angsd_project/genome_index/hg38.refGene.gtf
out_dir=/athena/angsd/scratch/kch4018/angsd_project/STAR_aligned/qorts_qc
input_dir=/athena/cayuga_0019/scratch/kch4018/angsd_project/STAR_aligned
jar_file=/athena/angsd/scratch/mef3005/share/envs/qorts/share/qorts-1.3.6-1/QoRTs.jar

mkdir -p $out_dir

bams=("$input_dir"/*.bam)
bam="${bams[$SLURM_ARRAY_TASK_ID]}"

sample=$(basename "$bam" .bam)
echo "Running QoRTs for sample: $sample"
    
java -Xmx24G -jar $jar_file QC \
    --numThreads 2 \
    --stranded \
    --generatePlots \
    $bam \
    $gtf_file \
    $out_dir/$sample