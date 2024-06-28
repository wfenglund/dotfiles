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

print_hlp () {
  echo "Usage:"
  echo "$ deckman [FLAG] [...] [...]"$'\n'
  echo "Flags:"
  echo "--hlp"$'\t\t\t\t\t'"- display this info"
  echo "--new [DECK_NAME]"$'\t\t\t'"- create a new deck (in directory $deck_dir)."
  echo "--add [DECK_NAME] [CARD_INFO]"$'\t\t'"- add card to deck in the format \"STATUS,NAME,TYPE,COUNT,COMMENT\" (within quotes). Leave entry empty if unknown or undecided, but use four commas either way."
  echo "--rem [DECK_NAME] [CARD_ID]"$'\t\t'"- remove card related to the given card id."
  echo "--flt [DECK_NAME] [ENTRY:PTRN]"$'\t\t'"- print deck, with optional filtering parameters."
  echo "--edt [DECK_NAME] [CARD_ID:ENTRY:NEW]"$'\t'"- change the text in a card entry to something else."
  echo "--vim [DECK_NAME]"$'\t\t\t'"- edit the deck directly with vim."
}

add_card () {
  deck_nam=$1
  card_str=$2
  if test -f $deck_dir/$deck_nam
  then
    IFS=,;read -a card_arr <<< "$card_str "
    for i in "${!card_arr[@]}"
    do
      card_arr[$i]="${card_arr[$i]:-unset}"
    done
    if [ ${#card_arr[@]} == 5 ]
    then
      card_id=`mkid $deck_nam` # generate card id
      card_arr=($card_id "${card_arr[@]}")
      echo "${card_arr[*]}" >> $deck_dir/$deck_nam
    else
      echo "Invalid number of entries. There must be exactly five: \"STATUS,NAME,TYPE,COUNT,COMMENT\" (within quotes)."
    fi
  else
    echo "deck $deck_nam does not exist. Create it with:"
    echo "$ deckman --new $deck_nam"
  fi
}

flt_deck () {
  deck_nam=$1
  filt_par=$2
  declare -A col_dict=( ["id"]="1" ["status"]="2" ["name"]="3" ["type"]="4" ["count"]="5" ["comment"]="6" )
  if test -f $deck_dir/$deck_nam
  then
    if [ ${#filt_par} == 0 ] # if no argument is given
    then
      awk 'BEGIN{FS=","; print "id\tstatus\tname\ttype\tcount\tcomment"};{print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' $deck_dir/$deck_nam
    else
      IFS=: read -r entry ptrn <<< $filt_par
      entry_col=${col_dict[$entry]}
      awk -v column="$entry_col" -v val="$ptrn" 'BEGIN{FS=","; print "id\tstatus\tname\ttype\tcount\tcomment"};{if($column == val) print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' $deck_dir/$deck_nam
    fi
  else
    echo "deck $secon_arg does not exist. Create it with"
    echo "$ deckman --new $secon_arg"
  fi
}

edt_deck () {
  deck_nam=$1
  card_edt=$2
  IFS=: read -r card_id entry new_nfo <<< $card_edt
  declare -A col_dict=( ["id"]="1" ["status"]="2" ["name"]="3" ["type"]="4" ["count"]="5" ["comment"]="6" ) # there are issues if unknown choice is selected
  entry_col=${col_dict[$entry]}
  if test -f $deck_dir/$deck_nam
  then
    if [ ${#card_edt} == 0 ] # if no argument is given
    then
      echo "No filtering parameters given."
    else
      awk -v id="$card_id" -v col="$entry_col" -v nfo="$new_nfo" 'BEGIN{FS=",";OFS=","};{if($1==id) {$col=nfo}; print}' $deck_dir/$deck_nam > $deck_dir/tmp
      mv $deck_dir/tmp $deck_dir/$deck_nam
    fi
  else
    echo "deck $secon_arg does not exist. Create it with"
    echo "$ deckman --new $secon_arg"
  fi
}

# Main program:
if [ ${#first_arg} == 0 ] # if no argument is given
then
  echo "invalid deckman flag or input. run deckman --hlp for instructions."
elif [ ${#secon_arg} == 0 ] # if second argument is empty
then
  if [ $first_arg == "--hlp" ]
  then
    print_hlp
  else
  echo "invalid deckman flag or input. run deckman --hlp for instructions."
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
    add_card $secon_arg $third_arg

  ### Remove card from deck
  elif [ $first_arg == "--rem" ]
  then
    awk -v rm_id="$third_arg" 'BEGIN{FS=","};$1 != rm_id {print}' $deck_dir/$secon_arg | sort -g > $deck_dir/tmp
    mv $deck_dir/tmp $deck_dir/$secon_arg
  
  ### Filter and print deck:
  elif [ $first_arg == "--flt" ]
  then
    flt_deck $secon_arg $third_arg
  
  ### Edit a card in deck:
  elif [ $first_arg == "--edt" ]
  then
    edt_deck $secon_arg $third_arg

  ### Edit the deck manually with vim:
  elif [ $first_arg == "--vim" ]
  then
    vim $deck_dir/$secon_arg
  
  ### Invalid flag:
  else
    echo "invalid deckman flag or input. run deckman --hlp for instructions."
  fi
fi

