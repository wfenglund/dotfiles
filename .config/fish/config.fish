# The path of this file should be ~/.config/fish/config.fish

# Path:
set PATH $PATH $HOME/anaconda3/bin
fish_add_path $HOME/dotfiles/bash_scripts

# Greeting
set -U fish_greeting
neofetch

# Aliases:
alias 3up="cd ../../../"
alias erl="erl -config ~/.config/erlang/erlang.config"
alias untar="tar -xvf"
alias lah="ls -lah"
alias nocaps="source ~/dotfiles/config_scripts/remap_keys.sh" # Change caps lock into less and greater and insert to bar, if caps get stuck activated, run 'onboard' and deactivate
nocaps # remap caps key and insert key
alias rebar3="~/rebar3/rebar3"
alias getbc="python ~/dotfiles/config_scripts/getbc.py"
alias wikiw="python ~/dotfiles/config_scripts/wikiw.py ~/dotfiles/config_scripts/wikiw.txt"
alias fishwiki="python ~/dotfiles/config_scripts/wikiw.py ~/dotfiles/config_scripts/fishwiki.txt"
alias unnotate="bash ~/dotfiles/bash_scripts/unnotate.sh" # access universal notes
alias lonotate="bash ~/dotfiles/bash_scripts/unnotate.sh notes.txt" # create/access notes file at present location
alias fqsttr="bash ~/dotfiles/bash_scripts/fqsttr.sh"

## SSH:
alias uppmax_ssh="ssh willeng@rackham.uppmax.uu.se"
alias dardel_ssh="ssh wenglund@dardel.pdc.kth.se"
alias nrmdna_ssh="ssh willengl@nrmdna01.nrm.se"

## Home specific:
alias tibia="./Games/tibia/Tibia/start-tibia-launcher.sh"

## Work specific:
alias astral="java -jar /home/william/Astral/astral.5.7.8.jar"
alias figtree="java -Xms64m -Xmx512m -jar /home/william/figtree/FigTree_v1.4.4/lib/figtree.jar"
alias catsequences="./catsequences/catsequences"
alias todowork="bash ~/dotfiles/bash_scripts/unnotate.sh $HOME/cgi/todo.txt" # access work todo list

### Monitor aliases:
alias 3screenwork="xrandr --output eDP --primary --mode 2240x1400 --pos 1920x0 --rotate normal --output HDMI-A-0 --mode 1920x1200 --pos 4160x200 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --mode 1920x1080 --pos 0x320 --rotate normal --output DisplayPort-3 --off"
alias 1screenwork="xrandr --output eDP --primary --mode 2240x1400 --pos 0x0 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off"
alias 2screenclone="xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off"
alias 2screendouble="xrandr --output eDP --primary --mode 2240x1400 --pos 0x760 --rotate normal --output HDMI-A-0 --mode 3840x2160 --pos 2240x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off"
alias 2screenhome="xrandr --output eDP-1 --primary --mode 1920x1080 --pos 2560x360 --rotate normal --output HDMI-1 --mode 2560x1440 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-2 --off --output DP-1-0 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off"


# Functions:
function gitguide
  echo "git clone <url>"
  echo "git branch"
  echo "git checkout -b <branch name>"
  echo "git remote add upstream <url>"
  echo "# add and commit changes"
  echo "git checkout main"
  echo "git pull upstream main"
  echo "git checkout <branch name>"
  echo "git merge main"
  echo "git push origin <branch name>"
  # git remote set-url origin https://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@github.com/wfenglund/eDNA
  echo "# Make pull request"
  echo ""
end

function zhead
  zcat $argv | head -n 20
end

function erlrun # compile and run a file.erl with a start-function
  erlc $argv
  string replace ".erl" "" $argv | read module_name
  erl -noshell -s $module_name start -s init stop
end

function OnlineBlaster
  Rscript ~/dotfiles/config_scripts/webBlast.r $argv
end

function length ()
  string length $argv
end

function zdiff
	bash ~/dotfiles/bash_scripts/zdiff.sh $argv[1] $argv[2]
end

function pmocver ()
  python ~/CGIBashScripts/subscripts/pmocver.py $argv
end

if status is-interactive
  # Commands to run in interactive sessions can go here
end
