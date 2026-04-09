#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=download
#SBATCH --mem=100G

preT_dir="/athena/angsd/scratch/kch4018/angsd_project/pre_T"
postT_dir="/athena/angsd/scratch/kch4018/angsd_project/on_T"
table="/athena/angsd/scratch/kch4018/angsd_project/SRP542825.txt"

mkdir -p "$preT_dir" "$postT_dir"

# for pre-treatment
egrep _pre $table | cut -f 2 | egrep -o '[^;]+'  | xargs printf 'ftp://%s\n'| xargs wget --directory-prefix=$preT_dir

# for post-treatment
egrep _onT $table | cut -f 2 | egrep -o '[^;]+'  | xargs printf 'ftp://%s\n'| xargs wget --directory-prefix=$postT_dir

DIRS=($preT_dir $postT_dir)

awk -F'\t' '{print $1, $3}' $table|
while read -r srr label; do
  for dir in "${DIRS[@]}"; do
    for file in "${dir}"/*"${srr}"*; do
      [[ -e "$file" ]] || continue

      new="${file//$srr/$label}"

      if [[ "$file" != "$new" ]]; then
        echo "Renaming: $file → $new"
        mv -- "$file" "$new"
      fi
    done
  done
done