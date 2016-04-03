#! /bin/bash

CACHE="$HOME/.cache/tagvim"

# ctags tag generation arguments
KINDS="p"
FIELDS="iaS"
EXTRA="q"

# Set up standard dirs
if [ ! -d "$CACHE" ]; then
	echo "-->Creating cache dir"
	mkdir "$CACHE"
	echo "-->Downloading modified C++ headers"
	curl -L 'http://www.vim.org/scripts/download_script.php?src_id=9178' > "$CACHE/cpp_src.tar.bz2"
	echo "-->Extracting C++ sources"
	tar xf "$CACHE/cpp_src.tar.bz2" -C "$CACHE"
	echo "-->Modifying sources"
	cd "$CACHE/cpp_src"
	rm *.tcc
	sed -i 's/bits\///g' *
	for i in *; do
		grep -E -v '#include.*[^\s\/]/[^\s\/]' $i | \
			grep -E -v "#include.*tcc"> temp
		mv temp $i
	done
	echo "-->Generating tags for stdcpp"
	cd "$CACHE"
	mkdir stdcpp
	cd cpp_src
	for i in *; do
		ctags --c++-kinds=+"$KINDS" --fields=+"$FIELDS" --extra=+"$EXTRA" \
			-f "$CACHE/stdcpp/$i" "$i"
	done
	cd "$CACHE"
	rm cpp_src.tar.bz2
	touch filelist
fi

for k in $(cat "$CACHE/filelist"); do
	for i in $(find "$k" -not -type d); do
		mkdir -p "$CACHE$(dirname "$i")"
		if [ ! -f "$CACHE$i" ] || [[ "$i" =~ $1* ]]; then
			echo "Generating tags for $i"
			ctags --c++-kinds=+"$KINDS" --fields=+"$FIELDS" --extra=+"$EXTRA" \
				-f "$CACHE/$i" "$i"
		fi
	done
done
