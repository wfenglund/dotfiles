#!/bin/bash

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
  echo "$ deckman [DECK_NAME] [FLAG] [...]"$'\n'
  echo "Flags:"
  echo "--hlp "$'\t\t\t'"- display this info"
  echo "--new "$'\t\t\t'"- create a new deck (in directory $deck_dir)."
  echo "--add [CRD_INFO]"$'\t'"- add card to deck in the format \"STATUS,NAME,TYPE,COUNT,NOTE\" (within quotes). Use four commas even if some entries are empty." # update to new functionality
  echo "--rem [CRD_ID]"$'\t\t'"- remove card related to the given card id."
  echo "--flt [CLMN:PTRN]"$'\t'"- print deck, with optional filtering parameters (column can be by name or number)."
  echo "--edt [CRD_ID:CLMN:NEW]"$'\t'"- given a card id and column, change the text in a card entry to something else."
  echo "--vim "$'\t\t\t'"- edit the deck directly with vim."
}

add_card () {
  deck_nam=$1
  card_str=$2
  deck_ncol=$((`awk 'BEGIN{FS=","};{print NF; exit}' $deck_dir/$deck_nam` - 1))
  IFS=,;read -a card_arr <<< "$card_str "
  for i in "${!card_arr[@]}"
  do
    card_arr[$i]="${card_arr[$i]:-unset}"
  done
  if [ ${#card_arr[@]} == $deck_ncol ] # if correct number of entries
  then
    card_id=`mkid $deck_nam` # generate card id
    card_arr=($card_id "${card_arr[@]}")
    echo "${card_arr[*]}" >> $deck_dir/$deck_nam
  else
    echo "Invalid number of entries. There must be exactly five: \"STATUS,NAME,TYPE,COUNT,NOTE\" (within quotes)." # edit to be generated
  fi
}

flt_deck () {
  ### Declare variables:
  deck_nam=$1
  filt_par=$2
  
  ### Generate dictionary:
  header=$(head -n 1 $deck_dir/$deck_nam)
  IFS=,;read -a cols <<< "$header"
  declare -A col_dict
  counter=1
  for i in ${cols[@]}
  do
    col_dict[$i]=$counter
    counter=$(($counter + 1))
  done

  ### Parse filtering arguments:
  if [ ${#filt_par} == 0 ] # if no argument is given
  then
    awk \
      'BEGIN{FS=","};{print}' \
      $deck_dir/$deck_nam | column -s ',' -t
  else
    IFS=:;read -r entry ptrn <<< $filt_par
    
    #### Figure out which column to filter by:
    value="\<$entry\>"
    if [[ ${cols[@]} =~ $value ]]
    then
      col_num=${col_dict[$entry]}
    else
      index=$(($entry - 1))
      col_num=${col_dict[${cols[$index]}]}
    fi

    #### Filter deck:
    awk \
      -v col="$col_num" -v val="$ptrn" \
      'BEGIN{FS=",";if(NR==1) print};{if(match($col, val) == (NR>1)) print}' \
      $deck_dir/$deck_nam | column -s ',' -t
  fi
}

edt_deck () {
  deck_nam=$1
  card_edt=$2
  IFS=: read -r card_id entry new_nfo <<< $card_edt
  
  ### Generate dictionary:
  header=$(head -n 1 $deck_dir/$deck_nam)
  IFS=,;read -a cols <<< "$header"
  declare -A col_dict
  counter=1
  for i in ${cols[@]}
  do
    col_dict[$i]=$counter
    counter=$(($counter + 1))
  done
  
  ### Figure out which column to edit:
  value="\<$entry\>"
  if [[ ${cols[@]} =~ $value ]]
  then
    ntry_col=${col_dict[$entry]}
  else
    index=$(($entry - 1))
    ntry_col=${col_dict[${cols[$index]}]}
  fi

  if [ ${#card_edt} == 0 ] # if no argument is given
  then
    echo "No filtering parameters given."
  elif [ ${#ntry_col} != 0 ] # if column was identified
  then
    awk \
      -v id="$card_id" -v col="$ntry_col" -v nfo="$new_nfo" \
      'BEGIN{FS=",";OFS=","};{if($1==id) {$col=nfo}; print}' \
      $deck_dir/$deck_nam > $deck_dir/tmp
    mv $deck_dir/tmp $deck_dir/$deck_nam
  else
    echo "Column not found."
  fi
}

parse_flags () {
  deck_nam=$1
  inp_flag=$2
  settings=$3
  ### Add card to deck:
  if [ $inp_flag == "--add" ]
  then
    add_card $deck_nam "$settings"
  ### Remove card from deck
  elif [ $inp_flag == "--rem" ]
  then
    awk \
      -v rm_id="$settings" \
      'BEGIN{FS=","};$1 != rm_id {print}' \
      $deck_dir/$deck_nam | sort -g > $deck_dir/tmp
    mv $deck_dir/tmp $deck_dir/$deck_nam
  ### Filter and print deck:
  elif [ $inp_flag == "--flt" ]
  then
    flt_deck $deck_nam "$settings"
  ### Edit a card in deck:
  elif [ $inp_flag == "--edt" ]
  then
    edt_deck $deck_nam $settings
  ### Edit the deck manually with vim:
  elif [ $inp_flag == "--vim" ]
  then
    vim $deck_dir/$deck_nam
  ### Invalid flag:
  else
    echo "Invalid deckman flag or input. run deckman.sh --hlp for instructions."
  fi
}

# Main program:

## Variables:
first_arg=$1
secon_arg=$2
third_arg=$3
deck_dir="$HOME/.dmdecks"

if [ ${#secon_arg} == 0 ]
then
  secon_arg="--flt"
fi

## Argument parsing:
if [ ${#first_arg} == 0 ] || [ $first_arg == "--hlp" ]
then
  print_hlp
elif [ -f $deck_dir/$first_arg ]
then
  parse_flags $first_arg $secon_arg "$third_arg"
elif [ $secon_arg == "--new" ]
then
  mkdir -p $deck_dir
  touch $deck_dir/$first_arg
  if [ ${#third_arg} == 0 ] # if no column names are given
  then
    echo "id,status,name,type,count,note" >> $deck_dir/$first_arg
  else
    clean_cols=${third_arg//" "/""} # remove all spaces
    echo "id,"$clean_cols >> $deck_dir/$first_arg
  fi
else
  echo "Deck $first_arg does not exist. Create it with:"
  echo "$ deckman.sh $first_arg --new"
  echo $'\n'"(or run deckman.sh --hlp for detailed instructions.)"
fi
