notes_file=$HOME"/.universal_notes.txt"

if [ -f $notes_file ]
then
  vim $notes_file
else
  touch $notes_file
  vim $notes_file
fi
