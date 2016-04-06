let s:plugloc = expand('<sfile>:p:h')

function! CreateTaglist()
	if &l:filetype != "cpp"
		return
	endif
	execute 'pyfile ' . s:plugloc . '/parse_includes.py'
	let sfile = $HOME . "/.cache/tagvim/settags" . expand('%:p')
	let tgs = &l:tags
	call writefile([tgs], sfile)
endfunc

function! UpdateTags()
	if &l:filetype != "cpp"
		return
	endif
	let cache = $HOME . "/.cache/tagvim/"
	let tgs = split(&l:tags, ',')
	for i in tgs
		let i = i[ len(cache) :]
		if i =~ '^local'
			let i = i[5:]
			call system('echo "' . i . '" >> ' . cache . 'filelist')
		endif
	endfor
	execute 'silent !' . s:plugloc . '/gentags.sh ' . expand('%:p')
endfunc

function! SetTagList()
	let cache = $HOME . "/.cache/tagvim/settags"
	execute 'silent !mkdir -p ' . cache . expand('%:p:h')
	if filereadable(cache . expand('%:p'))
		 let temp = readfile(cache . expand('%:p'))
		 let &l:tags = temp[0]
	else
		echo "Taglist file for this file does not exist, please call" .
					\ "CreatTaglist()"
	endif
endfunc

function! AddTagFolder(folder)
	let cache = $HOME . "/.cache/tagvim/"
	execute 'silent !echo "' . a:folder . '" >> ' . cache . 'filelist'
	execute 'silent !' . s:plugloc . '/gentags.sh'
endfunc

augroup tagvim
	autocmd!
	autocmd Filetype cpp call UpdateTags()
	autocmd Filetype cpp call SetTagList()
augroup END
