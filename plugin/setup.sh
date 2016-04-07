#! /bin/bash

sloc="$(dirname ${BASH_SOURCE[0]})"
source "$sloc/vars.sh"

echo "-->Creating cache dir"
mkdir -p "$CACHE"
touch "$CACHE/filelist"
