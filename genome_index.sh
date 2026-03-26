#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --job-name=genome_index
#SBATCH --mem=50G

genome_index="/athena/angsd/scratch/kch4018/angsd_project/genome_index"
fasta="$genome_index"/hg38.fa.gz
gtf="$genome_index"/hg38.knownGene.gtf.gz
fasta_unzipped="$genome_index"/hg38.fa
gtf_unzipped="$genome_index"/hg38.knownGene.gtf

cd $genome_index

echo "Preparing FASTA/GTF..."
# Only uncompress if needed
if [[ ! -s "${fasta_unzipped}" ]]; then
  echo "Uncompressing FASTA -> ${fasta_unzipped}"
  gunzip -c "${fasta}" > "${fasta_unzipped}"
fi

if [[ ! -s "${gtf_unzipped}" ]]; then
  echo "Uncompressing GTF -> ${gtf_unzipped}"
  gunzip -c "${gtf}" > "${gtf_unzipped}"
fi

STAR --runMode genomeGenerate \
     --runThreadN 8 \
     --genomeDir "${genome_index}" \
     --genomeFastaFiles "${fasta_unzipped}" \
     --sjdbGTFfile "${gtf_unzipped}" \
     --sjdbOverhang 149 \
     --genomeSAindexNbases 14