function! SetTags()
	let l:sdir = expand('%:p:h')
	pyfile parse_includes.py
endfunc

function! UpdateTags()
	if &filetype != "cpp"
		finish
	let cache = $HOME . "/.cache/tagvim/"
	let plugloc = expand('%:p:h')
	call system('echo "' . expand('%:p') . '" >> ' . cache . 'filelist')
	call system("awk '!seen[$0]++' " . cache . 'filelist')
	call system(plugloc . '/setup.sh')
endfunc

augroup tagvim
	autocmd!
	autocmd Filetype cpp call UpdateTags()
	autocmd Filetype cpp call SetTags()
augroup END
