#!/bin/sh
dflag=n
cflag=n

faildir(){
	echo directory doesnt exist
	exit 1
}

usage(){
	echo usage: '[-d directory] [-c options] word' 1>&2 
	exit 1
}

comp(){
	cd $1
	for f in $(ls | egrep '(\.c)$');do
		d=$(echo $f | sed s/..$//)
		if test $cflag = y;then
			if test -z $w;then
				gcc $opt -o $d $f
			else
				gcc $opt -o $d $f 2>&1| grep $w
			fi
			
		else
			if test -z $w;then
				gcc -o $d $f
			else
				gcc -o $d $f 2>&1| grep $w
			fi
		fi		
	done
}

checkd(){
	if ls $2 >/dev/null;then
		dflag=y
		path=$2
	else
		faildir
	fi
}

checkopt(){
	cflag=y
	if echo $1 | egrep '^(-W)' >/dev/null;then
		op1=$1
		shift
	fi
	if echo $1 | egrep '^(-W)' >/dev/null;then
		op2=$1
		shift
	fi
	opt=$op1" "$op2
}

checkatr(){
	while test $# -gt 0
	do
		if echo $1 | egrep '^-d$' >/dev/null;then
			if test $dflag = y; then
				echo Bad Usage d
				usage
			else	
				checkd $*
				shift;shift
			fi
		fi

		if echo $1 | egrep '^-c$' >/dev/null;then
			if test $cflag = y; then
				echo Bad usage c 
				usage
			else
				shift
				checkopt $*
				if test -z $op1;then
					echo no opt1 >/dev/null
				else
					shift
				fi
				if test -z $op2;then
					echo no opt2 >/dev/null
				else
					shift
				fi
			fi
		fi

		if test $# -eq 1;then
			w=$1
			shift
		fi
	done
	if test $dflag = n;then
		path='.'
	fi
}


checkatr $*
comp $path

