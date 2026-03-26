#! /bin/bash -l

#SBATCH --partition=angsd_class
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --job-name=kc_align
#SBATCH --mem=200G

preT_dir="/athena/angsd/scratch/kch4018/angsd_project/pre_T"
postT_dir="/athena/angsd/scratch/kch4018/angsd_project/post_T"

# for pre-treatment
egrep _pre SRP542825.txt | cut -f 2 | egrep -o '[^;]+'  | xargs printf 'ftp://%s\n'| xargs wget --directory-prefix=$preT_dir

# for post-treatment
egrep _onT SRP542825.txt | cut -f 2 | egrep -o '[^;]+'  | xargs printf 'ftp://%s\n'| xargs wget --directory-prefix=$postT_dir