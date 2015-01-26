set lines=100 
set columns=165

let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk"
  set noexpandtab
else
  set expandtab
  set tabstop=4
  set shiftwidth=4
endif

au BufRead,BufNewFile *.adoc set syntax=asciidoc


set tags=./tags;/
set number
set backspace=indent,eol,start

set clipboard=unnamed
syntax on

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

autocmd BufRead, BufNewFile *.html.erb set filetype=html
