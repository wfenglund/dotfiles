get_stats() {
  first_seq=`zcat ./$1 | head -n 2 | tail -n 1`
  count_seq=`zgrep "^@" ./$1 | wc -l`
  echo "- Read length:,"${#first_seq}
  echo "- Sequence count:,"$count_seq
}

counter=0
for arg # for every argument
do
  if [ $counter -gt 0 ]
  then
    echo ""
  fi
  echo $arg
  get_stats $arg | column -s ',' -t
  counter=$((counter + 1))
done
