function! SetTags()
	pyfile parse_includes.py
endfunc

function! UpdateTags()
	let cache = $HOME . "/.cache/tagvim/"
	let plugloc = expand('%:p:h')
	call system('echo "' . expand('%:p') . '" >> ' . cache . 'filelist')
	call system("awk '!seen[$0]++' " . cache . 'filelist')
	call system(plugloc . '/setup.sh')
endfunc
