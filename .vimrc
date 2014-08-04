

let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk"
  set noexpandtab
else
  set expandtab
  set tabstop=2
  set shiftwidth=2
endif

set tags=./tags;/
set number

set clipboard=unnamed


set cindent

function FoldBrace()
	if getline(v:lnum)[0] == '{'
		return '>1'
	endif
	if getline(v:lnum)[0] == '}'
		return '<1'
	endif
	return foldlevel(v:lnum)
endfunction
set foldexpr=FoldBrace()
set foldmethod=expr

command -nargs=* Make make <args> | cwindow 3
map Make <F7>

map p p=j

set splitright

colors desert
