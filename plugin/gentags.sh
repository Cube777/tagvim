#! /bin/bash

source vars.sh

for k in $(cat "$CACHE/filelist"); do
	if [ ! -d "$k" ]; then continue; fi
	for i in $(find "$k" -not -type d); do
		mkdir -p "$CACHE$(dirname "$i")"
		if [ ! -f "$CACHE$i" ] || [[ "$i" =~ $1* ]]; then
			echo "Generating tags for $i"
			ctags --c++-kinds=+"$KINDS" --fields=+"$FIELDS" --extra=+"$EXTRA" \
				-f "$CACHE/$i" "$i"
		fi
	done
done
