# The path of this file should be ~/.config/fish/config.fish

# Path:
set PATH $PATH /home/william/anaconda3/bin

# Greeting
set -U fish_greeting
neofetch

# Aliases:
alias 3up="cd ../../../"
alias erl="erl -config ~/.config/erlang/erlang.config"
alias untar="tar -xvf"
alias lah="ls -lah"
alias nocaps="setxkbmap -option caps:ctrl_modifier" # Change caps lock into ctrl
alias rebar3="~/rebar3/rebar3"

## Monitor aliases:
alias 3screenwork="xrandr --output eDP --primary --mode 2240x1400 --pos 1920x60 --rotate normal --output HDMI-A-0 --mode 1920x1200 --pos 0x260 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --mode 1920x1080 --pos 4160x380 --rotate normal --output DisplayPort-3 --off"
alias 1screenwork="xrandr --output eDP --primary --mode 2240x1400 --pos 0x0 --rotate normal --output HDMI-A-0 --off --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off"
alias 2screenclone="xrandr --output eDP --primary --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off"
alias 2screendouble="xrandr --output eDP --primary --mode 2240x1400 --pos 0x760 --rotate normal --output HDMI-A-0 --mode 3840x2160 --pos 2240x0 --rotate normal --output DisplayPort-0 --off --output DisplayPort-1 --off --output DisplayPort-2 --off --output DisplayPort-3 --off"

## Home specific:
alias getbc="python /home/william/projects/python/finance/getbc.py"
alias tibia="./Games/tibia/Tibia/start-tibia-launcher.sh"

## Work specific:
alias astral="java -jar /home/william/Astral/astral.5.7.8.jar"
alias figtree="java -Xms64m -Xmx512m -jar /home/william/figtree/FigTree_v1.4.4/lib/figtree.jar"
alias catsequences="./catsequences/catsequences"

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
	Rscript ~/.config_scripts/webBlast.r $argv
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
