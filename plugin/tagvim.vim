let s:plugloc = expand('<sfile>:p:h')

function! CreateTagList()
	if &l:filetype != "cpp"
		return
	endif
	execute 'silent !' . s:plugloc . '/gentags.sh gen ' . expand('%:p')
	call SetTagList()
endfunc

function! UpdateLocalTags()
	if &l:readonly
		return
	endif
	if &l:filetype != "cpp"
		return
	endif
	execute 'silent !' . s:plugloc . '/gentags.sh local ' . expand('%:p')
endfunc

function! ForceUpdateTags(loc)
	if &l:filetype != "cpp"
		return
	endif
	execute 'silent !' . s:plugloc . '/gentags.sh force ' . a:loc
endfunc

function! SetTagList()
	if &l:readonly
		return
	endif
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
endfunc

augroup tagvim
	autocmd!
	autocmd Filetype cpp call UpdateLocalTags()
	autocmd Filetype cpp call SetTagList()
augroup END
