# The path of this file should be ~/.config/fish/config.fish

set -U fish_greeting
set PATH $PATH /home/william/anaconda3/bin

neofetch

alias getbc="python /home/william/projects/python/finance/getbc.py"
alias tibia="./Games/tibia/Tibia/start-tibia-launcher.sh"

function erlrun
	erlc $argv.erl
	erl -noshell -s $argv start -s init stop
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
