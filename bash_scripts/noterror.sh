#!/bin/bash

add_note() { # only works if user can write in cur dir
	vim .temporary_noterror_note
	if [ -f ./.temporary_noterror_note ]
	then
	  note_title=`awk '/^# Notes:$/{ print NR }' $task_dir'/'$1'.task'`
	  note_start=`echo "$note_title + 1" | bc`
	  head -n $note_title $task_dir'/'$1'.task' > .temporary_noterror_task
	  echo "" >> .temporary_noterror_task
	  echo '## '`date`':' >> .temporary_noterror_task
	  cat .temporary_noterror_note >> .temporary_noterror_task
          tail -n +$note_start $task_dir'/'$1'.task' >> .temporary_noterror_task
	  if [[ `cat .temporary_noterror_task | wc -l` -gt `cat $task_dir'/'$1'.task' | wc -l` ]]
	  then
	    cat .temporary_noterror_task > $task_dir'/'$1'.task'
	    rm .temporary_noterror_task
	    if [ $2 == 'true' ] # if verbose option
	    then
	      echo "Adding note:"
	      echo ""
	      cat .temporary_noterror_note
	    fi
	  else
	    echo "Error. Is the formatting of the task correct?"
	  fi
	  rm .temporary_noterror_note
	fi
}

restore_priority() { # add existing tasks to priority list if they are not on it
  for task_full in $task_dir/*.task
  do
    task_file=${task_full/*\/}
    task_name=${task_file/'.task'/''}
    if [ ! `grep -x $task_name $task_dir'/task_priority_list.txt'` ]
    then
      echo $task_name >> $task_dir'/task_priority_list.txt'
    fi
  done
}

display_help() {
  echo "noterror.sh -[enpgv] [task name or priority number]"
  echo ""
  echo "-e : edit task or priority list (-e [task] or -ep)"
  echo "-n : new note"
  echo "-p : view priority list, add e to edit"
  echo "-g : go to the task path"
  echo "-c : cat (print) the full task document"
  echo "-v : verbose"
  echo "-h : display this help info"
}

task_dir=$HOME'/.noterror_tasks'
mkdir -p $task_dir

current_task='none'
if [[ ! $BASH_ARGV == -* ]] # if a task name given after flags
then
  current_task=$BASH_ARGV
fi

edit_task='false'
new_note='false'
priority='false'
go_to_path='false'
cat_task='false'
verbose='false'
show_help='false'

while getopts 't:enpgcvh' flag # task (required, created if nonexistent), edit task, new note, priority list, verbose
do
  case "${flag}" in
    t) current_task="${OPTARG}" ;;
    e) edit_task='true' ;;
    n) new_note='true' ;;
    p) priority='true' ;;
    g) go_to_path='true' ;;
    c) cat_task='true' ;;
    v) verbose='true' ;;
    h) show_help='true' ;;
  esac
done

if [ $current_task != 'none' ]
then
  num_regex='^[0-9]+$' # regex for matching an integer
  if [[ $current_task =~ $num_regex ]] # if integer
  then
    task_name=`sed "${current_task}q;d" $task_dir'/task_priority_list.txt'` # get the task of that priority
    # potential problem if number is higher than n tasks or if that row is empty
    if [ ${#task_name} -gt 0 ] # if task name is longer than 0 characters
    then
      current_task=$task_name
    else
      echo "Incorrect task reference given."
      exit 1
    fi
  fi
  if [ -f $task_dir'/'$current_task'.task' ] # if task exists
  then
    echo "Accessing task $current_task."
  else # if task does not exist
    echo "Creating task $current_task."
    echo "[ $current_task ]" >> $task_dir'/'$current_task'.task'
    echo "" >> $task_dir'/'$current_task'.task'
    echo `pwd` >> $task_dir'/'$current_task'.task'
    echo "" >> $task_dir'/'$current_task'.task'
    echo "# Description:" >> $task_dir'/'$current_task'.task'
    echo "" >> $task_dir'/'$current_task'.task'
    echo "# To do:" >> $task_dir'/'$current_task'.task'
    echo "" >> $task_dir'/'$current_task'.task'
    echo "# Notes:" >> $task_dir'/'$current_task'.task'
    echo $current_task >> $task_dir'/task_priority_list.txt'
  fi
  if [[ $cat_task == 'true' ]]
  then
    echo ''
    cat $task_dir'/'$current_task'.task'
  fi
# else
#   echo "No task was given."
#   exit 1
fi

if [ $priority == 'true' ] # if priority list is prompted
then
  restore_priority # restore priority list
  counter=1
  while read task_entry
  do
    echo "$counter. "$task_entry
    counter=$((counter + 1))
  done < $task_dir'/task_priority_list.txt'
fi

if [ $new_note == 'true' ] && [ $current_task != 'none' ]
then
  add_note $current_task $verbose
fi

if [ $edit_task == 'true' ] # if editing is requested
then
  if [ $current_task == 'none' ] # if no task given ()
  then
    if [ $verbose == 'true' ] # if verbose option
    then
      echo ""
      echo "Editing priority list."
    fi
    vim $task_dir'/task_priority_list.txt'
  else
    if [ $verbose == 'true' ] # if verbose option
    then
      echo ""
      echo "Editing task."
    fi
    vim $task_dir'/'$current_task'.task'
  fi
fi

if [ -f $task_dir'/'$current_task'.task' ] && [ $go_to_path == 'true' ]
then
  task_path=`head -3 $task_dir'/'$current_task'.task' | tail -1`
  cd $task_path
  $SHELL
fi

if [ $show_help == 'true' ]
then
  display_help
fi
