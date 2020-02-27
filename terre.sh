#!/bin/sh

usage(){
  echo "usage: ./terre.sh fich"
  exit 1
}

calmax(){
  max=0.0
  for v in $*;do
    if test $(echo $v'>'$max | bc -l) -eq 1;then
      max=$v
    fi
  done
  echo $max
}

calmed(){
  reg=$(echo $1 | awk '{print tolower($0)}')
  shift
  tot=0
  for v in $*;do
    tot=$tot+$v
  done
  tot=$(echo $tot | bc)
  med=$(echo "scale=3;$tot / $#" | bc -l)
  echo -n "$reg $med "
}

selectreg(){
  fich=$1
  shift
  while test $# -gt 0
  do
    deepval=$(cat $fich | sed -n '/'$1'/,/'$2'/p' | awk '{print $3}')
    magval=$(cat $fich | sed -n '/'$1'/,/'$2'/p' | awk '{print $4}')
    calmed $1 $deepval
    calmax $magval
    shift
  done
}

if test $# -eq 1;then
  regions=$(cat $1 | awk /^[a-zA-Z]/)
  selectreg $1 $regions
else
  usage
fi
