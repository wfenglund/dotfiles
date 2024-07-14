if [ -f ~/.universal_notes.txt ]
then
  vim ~/.universal_notes.txt
else
  touch ~/universal_notes.txt
  vim ~/universal_notes.txt
fi
