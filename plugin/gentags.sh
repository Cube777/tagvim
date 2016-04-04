#! /bin/bash

source vars.sh

for k in $(cat "$CACHE/filelist"); do
	if [ $k == "/stdcpp" ]; then continue; fi
	for i in $(find "$k" -not -type d); do
		dir="system"
		if [[ $k =~ ^$HOME ]]; then dir="local"; fi
		mkdir -p "$CACHE/$dir$(dirname "$i")"
		echo "$dir"
		if [ ! -f "$CACHE/$dir$i" ] || [[ "$i" =~ $1* ]]; then
			echo "Generating tags for $i"
			ctags --c++-kinds=+"$KINDS" --fields=+"$FIELDS" --extra=+"$EXTRA" \
				-f "$CACHE/$dir$i" "$i"
		fi
	done
done
