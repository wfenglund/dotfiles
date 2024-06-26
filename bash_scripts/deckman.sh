#!/bin/bash

# Variables:
first_arg=$1
secon_arg=$2
third_arg=$3
deck_dir="$HOME/.dmdecks"

# Functions:
mkid () { # $1 = deck
  old_id=`awk 'BEGIN{FS=","};{print $1}' $deck_dir/$1 | sort -g | tail -1`
  if [ ${#old_id} == 0 ]
  then
    new_id="000"
  else
    new_id=$( bc <<< "$old_id+1" )
  fi
  printf "%03d\\n" "$new_id"
}

# Main program:
if [ ${#secon_arg} == 0 ] # if second argument is empty
then
  if [ $first_arg == "--help" ]
  then
    echo "Usage:"
    echo "$ deckman [FLAG]"$'\n'
    echo "Flags:"
    echo "--help"$'\t\t\t\t'"- display this info"
    echo "--new [DECK_NAME]"$'\t\t'"- create a new deck (in directory $deck_dir)."
    echo "--add [DECK_NAME] [CARD_INFO]"$'\t'"- add card to deck in the format \"STATUS,NAME,TYPE,COUNT,COMMENT\" (within quotes). Leave entry empty if unknown or undecided, but use four commas either way."
    echo "--rem [DECK_NAME] [CARD_ID]"$'\t\t'"- remove card related to the given card id."
    echo "--print [DECK_NAME]"$'\t\t'"- print deck."
  else
    echo "invalid deckman flag or input. run deckman --help for instructions."
  fi
else # if second argument is not empty
  ### New deck:
  if [ $first_arg == "--new" ]
  then
    mkdir -p $deck_dir
    touch $deck_dir/$secon_arg
  
  ### Add card to deck:
  elif [ $first_arg == "--add" ]
  then
    if test -f $deck_dir/$secon_arg
    then
      IFS=,;read -a card_arr <<< "$third_arg "
      for i in "${!card_arr[@]}"
      do
        card_arr[$i]="${card_arr[$i]:-unset}"
      done
      if [ ${#card_arr[@]} == 5 ]
      then
	card_id=`mkid $secon_arg` # generate card id
	card_arr=($card_id "${card_arr[@]}")
	echo "${card_arr[*]}" >> $deck_dir/$secon_arg
      else
        echo "Invalid number of entries. There must be exactly five: \"STATUS,NAME,TYPE,COUNT,COMMENT\" (within quotes)."
      fi
    else
      echo "deck $secon_arg does not exist. Create it with:"
      echo "$ deckman --new $secon_arg"
    fi

  ### Remove card from deck
  elif [ $first_arg == "--rem" ]
  then
    awk -v rm_id="$third_arg" 'BEGIN{FS=","};$1 != rm_id {print}' $deck_dir/$secon_arg | sort -g > $deck_dir/tmp
    mv $deck_dir/tmp $deck_dir/$secon_arg
  
  ### Print deck:
  elif [ $first_arg == "--print" ]
  then
    if test -f $deck_dir/$secon_arg
    then
      awk 'BEGIN{FS=","; print "id\tstatus\tname\ttype\tcount\tcomment"};{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' $deck_dir/$secon_arg
    else
      echo "deck $secon_arg does not exist. Create it with"
      echo "$ deckman --new $secon_arg"
    fi
  
  ### Invalid flag:
  else
    echo "invalid deckman flag or input. run deckman --help for instructions."
  fi
fi

