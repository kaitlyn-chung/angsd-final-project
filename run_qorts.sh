#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=qorts
#SBATCH --mem=100G

gtf_file=/athena/angsd/scratch/kch4018/angsd_project/genome_index/hg38.knownGene.gtf 
out_dir=/athena/angsd/scratch/kch4018/angsd_project/processed/qc/qorts
input_dir=/athena/cayuga_0019/scratch/kch4018/angsd_project/processed
jar_file=/athena/angsd/scratch/mef3005/share/envs/qorts/share/qorts-1.3.6-1/QoRTs.jar

mkdir -p $out_dir

conda activate qorts
for bam in $input_dir/*.bam; do
    sample=$(basename "$bam" .bam)
    echo "Running QoRTs for sample: $sample"
    
    java -Xmx90G -jar $jar_file QC \
        --stranded \
        --generatePlots \
        $bam \
        $gtf_file \
        $out_dir/$sample
done