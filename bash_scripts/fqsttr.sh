get_stats() {
  echo "- Sequence lengths:,"
  zcat $1 | awk 'NR % 4 == 2' | awk '{print length}' | Rscript -e 'summary(scan("stdin", quiet = TRUE))'
  count_seq=`zgrep "^@" ./$1 | wc -l`
  echo "- Sequence count:,"
  echo "    "$count_seq
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
