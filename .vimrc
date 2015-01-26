"""""""""""" gVim settings
set lines=400
set columns=170
set ruler

if has('gui_running')
  set guifont=Consolas:h10
  au GUIEnter * simalt ~x
endif

""""""""""""" div
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk"
  set noexpandtab
else
  set expandtab
  set tabstop=4
  set shiftwidth=4
endif

set tags=./tags;/
set number
set backspace=indent,eol,start

set clipboard=unnamed

syntax enable

set cindent

function! FoldBrace()
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

set splitright
set backspace=2

colors solarized
""""""""""""""" File types
au BufRead,BufNewFile *.html.erb set filetype=html
au BufRead,BufNewFile *.adoc set syntax=asciidoc
au BufRead,BufNewFile *.ino set filetype=cpp " Arduino


""""""""""""""" mapping
command! -nargs=* Make make <args> | cwindow 3
map Make <F7>

map p p=j

map <C-c> Esc

"window split navigation
nnoremap <C-J> <C-W><C-H>
nnoremap <C-K> <C-W><C-L>
nnoremap <C-H> <C-W><C-K>
nnoremap <C-L> <C-W><C-J>

"move line up or down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

"insert mode paste
inoremap <C-v> <Esc>pa

"tab navigation
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
inoremap <C-Tab> <Esc><C-Tab>
inoremap <C-S-Tab> <Esc><C-S-Tab>


