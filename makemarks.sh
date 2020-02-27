#!/bin/sh

numnot=$#


usage(){
	echo "usage: ./makemarks fich1 fich2 fich3 fich4"
	echo 4 fichs needed
	exit 1
}

escrnot(){
	echo $* | sed 's/ /\t\t/' | sed 's/ /\t/g' >> notasfinales.txt
}

calculmedalum(){
	nombre=$1
	shift
	i=1
	not=$(cat $* | awk /$nombre/ | awk '{tot+=$2}{print $2}
							END{print tot/NR}')
	escrnot $nombre $not 
}

alumNP(){
	nombre=$1
	shift
	notf=""
	for f in $*
	do
		if test $(cat $f | grep $nombre | wc -l) -eq 0;then
			not="-"
		else
			not=$(cat $f | awk /$nombre/ | awk '{print $2}')
		fi
		notf="$notf $not"
	done
		escrnot $nombre $notf NP
}

numnottot(){
	nombre=$1
	shift
	if test $(cat $* | awk /$nombre/ | wc -l) -ge $numnot;then
		calculmedalum $nombre $*
	else
		alumNP $nombre $*
	fi
}

alums(){
	for a in $(cat $*| awk /^[a-zA-Z]/ | awk '{print $1}' | sort | uniq)
	do
		numnottot $a $*
	done
}

if test $# -eq 4;then
	titcolum=$(cat $* | grep Nombre | sed 's/#Nombre//')
	echo '#Nombre' $titcolum 'Final'| sed 's/ /\t\t/' | sed -e's/ /\t/g' -e's/notas/Ejer/g'>> notasfinales.txt
	alums $*
else
	usage
fi
