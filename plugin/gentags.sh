#! /bin/bash

sloc=$(dirname ${BASH_SOURCE[0]})
source "$sloc/vars.sh"

awk '!seen[$0]++' "$CACHE/filelist" >> tmp && mv tmp "$CACHE/filelist"

for k in $(cat "$CACHE/filelist"); do
	if [ $k == "/stdcpp" ]; then continue; fi
	for i in $(find "$k" -not -type d); do
		dir="system"
		if [[ $k =~ ^$HOME ]]; then dir="local"; fi
		mkdir -p "$CACHE/$dir$(dirname "$i")"
		if [ ! -f "$CACHE/$dir$i" ] || [[ "$i" =~ $1* ]]; then
			ctags --language-force=c++ --c++-kinds=+$KINDS --fields=+$FIELDS \
				--extra=+"$EXTRA" -f "$CACHE/$dir$i" "$i"
		fi
	done
done
