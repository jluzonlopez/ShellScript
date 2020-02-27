#!/bin/bash

usage(){
  echo "usage: catletter.sh <directory>"
  exit 1
}

dooutfich(){
  let=$(echo "${let,,}")
  shift
  if test -f $let.output;then
    rm $let.output 2>/dev/null
  fi

  touch $let.output

  for f in $*;do
    cat $f >> $let.output
  done
}


if test $# -eq 1;then
  cd $1
  list=$(ls *.txt | sort)
  leftfichs=$(echo $list | wc -w)
  while test $leftfichs -gt 0
  do
    let=$(echo $list | head -c 1)
    letcap=$(echo "${let^^}")
    letmin=$(echo "${let,,}")
    sameletfich=$(ls *.txt | sort | tail -n $leftfichs | egrep ^[$letcap$letmin])
    dooutfich $let $sameletfich
    leftfichs=$(echo $leftfichs-$(echo $sameletfich | wc -w) | bc)
    list=$(ls *.txt | sort | tail -n $leftfichs)
  done
else
  usage
fi
