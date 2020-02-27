#!/bin/sh

usage(){
    echo "usage: logusers dir"
    exit 1
}

faildir(){
    echo Directory $1 already exists
    exit 1
}

saveps(){
    for u in $users
    do
        file=$(echo $dirname/$u.log)
        ps -u $u | awk '{print $1}' | tail +2> $file
    done
}

checkdir(){
    if test -d $dirname;then
        faildir $dirname
    else
        mkdir $dirname
    fi
}

if test $# -eq 1;then
    dirname=$1
    users=$(who | awk '{print $1}')
    checkdir 
    saveps
else
    usage
fi