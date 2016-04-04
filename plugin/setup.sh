#! /bin/bash

source vars.sh

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
	mkdir "$CACHE/local"
	mkdir -p "$CACHE/system/stdcpp"
	mkdir "$CACHE/settags"
	cd "$CACHE/cpp_src"
	for i in *; do
		ctags --c++-kinds=+"$KINDS" --fields=+"$FIELDS" --extra=+"$EXTRA" \
			-f "$CACHE/system/stdcpp/$i" "$i"
	done
	rm "$CACHE/cpp_src.tar.bz2"
	echo "/stdcpp" > "$CACHE/filelist"
fi


