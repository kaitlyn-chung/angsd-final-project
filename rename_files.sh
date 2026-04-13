#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=rename
#SBATCH --mem=40G

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