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
alias hrmsh="python3 ~/hrmsh/hrmsh.py"
alias wikiw="python3 ~/dotfiles/config_scripts/wikiw.py ~/dotfiles/config_scripts/wikiw.txt"
alias wikiwfish="python3 ~/dotfiles/config_scripts/wikiw.py ~/dotfiles/config_scripts/wikiwfish.txt"

## Project aliases:
alias hdata="cd /proj/snic2021-23-233/"
alias hcomp="cd /proj/snic2021-22-227/"
alias cgi="cd /proj/snic2022-22-78/william_analysis/"
alias 2cgi="cd /proj/naiss2023-23-140/william_analysis/"
alias porps="cd /proj/naiss2023-23-507/nobackup/tumlare"
alias efras="cd /proj/naiss2023-23-140/william_analysis/468_2022_euphrasia"
alias nuff="cd /proj/naiss2023-23-140/william_analysis/476_Nuphar"
alias dwnld="cd /proj/naiss2023-23-507/william_analysis/downloads"
alias 1dard="cd /cfs/klemming/projects/supr/naiss2023-23-140/"

# Functions:
#roller ()
#{
#  for i in {0..1200}
#  do
#    lines=$($1 | wc -l)
#    $1 | head -n${lines}   # print `$lines` lines
#    sleep 2
#    echo -e "\e[$((${lines}+1))A"     # go `$lines + 1` up
#  done
#}

statflag ()
{
  grep -E -T --color=always "[0-9]+ \+ [0-9]+ mapped" *flagstat.txt
}

lah ()
{
  ls -lah $1
}

#nrmupload ()
#{
#  bash ~/cloudsend.sh/cloudsend.sh "$1" "https://nrmcloud.nrm.se/s/EbanzwdawgBM3ES"
#}

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

############################
### CUSTOM SETTINGS ENDS ###
############################

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

## >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/home/willeng/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/home/willeng/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/home/willeng/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/home/willeng/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
## <<< conda initialize <<<
