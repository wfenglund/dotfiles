# .bashrc, rename file to '.bashrc' so that bash can find it
# these settings are mostly intended for uppmax

# Modules, activate the module command
case "$0" in
          -sh|sh|*/sh)	modules_shell=sh ;;
       -ksh|ksh|*/ksh)	modules_shell=ksh ;;
       -zsh|zsh|*/zsh)	modules_shell=zsh ;;
    -bash|bash|*/bash)	modules_shell=bash ;;
esac
module() { eval `/usr/local/Modules/$MODULE_VERSION/bin/modulecmd $modules_shell $*`; }

#############################
### CUSTOM SETTINGS START ###
#############################

# Path:
#PATH=$PATH:~/folder_to_add

# Load CGI scripts: (git clone https://github.com/cgi-nrm/CGIBashScripts)
source ~/CGIBashScripts/cgi_scripts.sh

# Modules:
module load vim

# Set history length:
HISTSIZE=100000
HISTFILESIZE=100000

# Aliases:
alias gnmkit="module load bioinfo-tools samtools vcftools bcftools MultiQC"
alias mdl="module load"
alias mds="module spider"
alias la="ls -a"
alias stpr="source set_variables.sh"
alias bashedit="vim ~/.bashrc"
alias erl="~/otp/bin/erl -config ~/.config/erlang/erlang.config"
alias erlc="~/otp/bin/erlc"
alias hrmsh="python ~/hrmsh/hrmsh.py"

## Project aliases:
alias hdata="cd /proj/snic2021-23-233/"
alias hcomp="cd /proj/snic2021-22-227/"
alias cgi="cd /proj/snic2022-22-78/william_analysis/"
alias 2cgi="cd /proj/naiss2023-23-140/william_analysis/"
alias porps="cd /proj/naiss2023-23-507/nobackup/tumlare"
alias efras="cd /proj/naiss2023-23-140/william_analysis/468_2022_euphrasia"
alias nuff="cd /proj/naiss2023-23-140/william_analysis/476_Nuphar"
alias dwnld="cd /proj/naiss2023-23-507/william_analysis/downloads"

# Functions:
roller ()
{
  for i in {0..1200}
  do
    lines=$($1 | wc -l)
    $1 | head -n${lines}   # print `$lines` lines
    sleep 2
    echo -e "\e[$((${lines}+1))A"     # go `$lines + 1` up
  done
}

statflag ()
{
  grep -E -T --color=always "[0-9]+ \+ [0-9]+ mapped" *flagstat.txt
}

lah ()
{
  ls -lah $1
}

nrmupload ()
{
  bash ~/cloudsend.sh/cloudsend.sh "$1" "https://nrmcloud.nrm.se/s/EbanzwdawgBM3ES"
}

erlrun () # compile and run erlang script with start function
{
  erlc $1
  module_name=${1/".erl"/""}
  erl -noshell -s $module_name start -s init stop 
}

## Colors:
white()
{
  echo -e "\e[0m"
}

yellow()
{
  echo -e "\e[33m"
}

gray()
{
  echo -e "\e[32m"
}

## Slurm functions: (moved to github/cgi-nrm/CGIBashScripts)
#rjb ()
#{
#  echo -e "\e[4mRunning:\e[0m\e[32m";
#  jobinfo -u willeng | grep " R " | awk '{print $1 "\t\t" $6 "\t" $8 "\t" $11 "\t" $3} END {if(NR==0) print "No jobs currently running"}';
#  echo -e "\e[0m";
#  echo -e "\e[4mPending:\e[0m\e[33m";
#  jobinfo -u willeng | grep " PD " | awk '{print $1 "\t" $2 "\t" $7 "\t" $9 "\t\t" $10 "\t" $4} END {if(NR==0) print "No jobs currently pending"}';
#  echo -e "\e[0m"
#}

#outslurm ()
#{
#  var1=$1
#  if [ ${#var1} == 0 ]; then var1=1; fi
#  ls | grep "slurm" | tail -$var1 | head -1 | xargs cat | sed '$q'
#}

#interact ()
#{
#  interactive -A naiss2023-22-16 -t 0:15:00;
#  gnmkit
#}

#mkblast ()
#{
#  if test -f "$1"
#  then
#    fasta_file=$1
#    out_file=${1/.fa/.out}
#    cur_dir=`pwd`
#    job_name=${1/.fa/_blast}
#    slurm_script=${1/.fa/_blast_script.sh}
#    slurm_script=${slurm_script/y_/}
#    echo "#! /bin/bash -l" > $slurm_script
#    echo "#SBATCH -A naiss2023-22-16" >> $slurm_script
#    echo "#SBATCH -p core" >> $slurm_script
#    echo "#SBATCH -n 20" >> $slurm_script
#    echo "#SBATCH -t 6:00:00" >> $slurm_script
#    echo "#SBATCH -J $job_name" >> $slurm_script
#    echo "" >> $slurm_script
#    echo "# go to this directory:" >> $slurm_script
#    echo "cd $cur_dir" >> $slurm_script
#    echo "" >> $slurm_script
#    echo "# load software modules:" >> $slurm_script
#    echo "module load bioinfo-tools blast" >> $slurm_script
#    echo "" >> $slurm_script
#    echo "# blast sequences:" >> $slurm_script
#    echo "blastn -query ./$fasta_file -db nt -out ./$out_file -outfmt \"6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore staxids sscinames scomnames\" -max_target_seqs 5 -num_threads 20" >> $slurm_script
#  else
#    echo "file $1 does not exist."
#  fi
#}

#mktar ()
#{
#  if test -d "$1"
#  then
#    folder_input=$1
#    folder_output=${1/\//.tar}
#    cur_dir=`pwd`
#    slurm_script="tar_script.sh"
#    echo "#! /bin/bash -l" > $slurm_script
#    echo "#SBATCH -A naiss2023-22-16" >> $slurm_script
#    echo "#SBATCH -p core" >> $slurm_script
#    echo "#SBATCH -n 20" >> $slurm_script
#    echo "#SBATCH -t 6:00:00" >> $slurm_script
#    echo "#SBATCH -J tar_folder" >> $slurm_script
#    echo "" >> $slurm_script
#    echo "# go to this directory:" >> $slurm_script
#    echo "cd $cur_dir" >> $slurm_script
#    echo "" >> $slurm_script
#    echo "# load software modules:" >> $slurm_script
#    echo "#module load bioinfo-tools" >> $slurm_script
#    echo "" >> $slurm_script
#    echo "# tar folder:" >> $slurm_script
#    echo "tar -cvf $folder_output ./$folder_input" >> $slurm_script
#  else
#    echo "folder $1 does not exist."
#  fi
#}

#lcratch () # list scratch discs of all running projects
#{
#  readarray -t scr_list < <(jobinfo -u willeng | grep " R " | awk '{print $11 " ls -lah /scratch/" $1}')
#  declare -p scr_list > /dev/null
#  if [ 1 -gt ${#scr_list} ] ; then echo "You have no running jobs." ; fi
#  for i in "${scr_list[@]}"
#  do
#    echo "${i##* }:"
#    ssh $i
#    echo ""
#  done
#}

#awsout ()
#{
#  outslurm | grep remaining | tail -1
#}

############################
### CUSTOM SETTINGS ENDS ###
############################

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/willeng/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/willeng/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/willeng/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/willeng/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<