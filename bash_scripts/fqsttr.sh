get_stats() {
  first_seq=`zcat ./$1 | head -n 2 | tail -n 1`
  count_seq=`zgrep "^@" ./$1 | wc -l`
  echo "Read length:,"${#first_seq}
  echo "Sequence count:,"$count_seq
}

get_stats $1 | column -s ',' -t
