#! /bin/bash

sloc=$(dirname ${BASH_SOURCE[0]})
source "$sloc/vars.sh"

awk '!seen[$0]++' "$CACHE/filelist" >> tmp && mv tmp "$CACHE/filelist"

if [ ! $# -eq 2 ]; then exit 1; fi

incs=""
if [ "$1" == "gen" ]; then
	special=""

	for i in $(cat "$CACHE/filelist"); do
		if [ "$i" == "/usr/include/c++" ]; then continue; fi
		special="$special-I \"$i\" "
	done

	incs=$(gcc -M $special "$2" --std=c++11 | sed -e 's/[\\ ]/\n/g' |\
		sed -e '/^$/d' -e '/\.o:[ \t]*$/d')

	mkdir -p "$CACHE/settags$(dirname $2)"
	echo -n "" > "$CACHE/settags$2"
	for i in $incs; do
		echo -n "$CACHE$i," >> "$CACHE/settags$2"
	done

elif [ "$1" == "force" ]; then
	incs=$(find "$2" -not -type d)
	for i in $incs; do if [ -f "$CACHE$i" ]; then rm "$CACHE$i"; fi; done

elif [ "$1" == "local" ]; then
	incs=$2

else
	exit 1
fi

for i in $incs; do
	if [ ! -f "$CACHE$i" ] || [ "$i" == "$2" ]; then
		mkdir -p "$CACHE$(dirname $i)"
		loc=$i
		if [[ $i =~ ^/usr/include/c++ ]]; then
			sed 's/namespace std _GLIBCXX_VISIBILITY(default)/namespace std/' \
			"$i" > /tmp/tagvim.temp
			i="-I _GLIBCXX_NOEXCEPT /tmp/tagvim.temp"
		fi
		ctags --language-force=c++ --c++-kinds=+"$KINDS" --fields=+"$FIELDS" \
			--extra=+"$EXTRA" -f "$CACHE$loc" $i
	fi
done
