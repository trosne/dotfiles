"""""""""""" gVim settings
set lines=400
set columns=170
set ruler

if has('gui_running')
  au GUIEnter * simalt ~x
  set guifont=Consolas\ for\ Powerline\ FixedD:h10
endif

set encoding=utf-8
""""""""""""" div
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk"
    set noexpandtab
else 
    set shiftwidth=4
    set expandtab
    set tabstop=4
    set cindent
endif

set tags=./tags;/
set number
set backspace=indent,eol,start

set clipboard=unnamed

syntax enable

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
set laststatus=2

""""""""""""""" extensions
execute pathogen#infect()

"""""" neocomplcache
let g:neocomplcache_enable_at_startup = 1
" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

""""""" airline
let g:airline_powerline_fonts=1
let g:airline_symbols = {}
let g:airline_left_sep = "\u2b80" "use double quotes here
let g:airline_left_alt_sep = "\u2b81"
let g:airline_right_sep = "\u2b82"
let g:airline_right_alt_sep = "\u2b83"
let g:airline_symbols.branch = "\u2b60"
let g:airline_symbols.readonly = "\u2b64"
let g:airline_symbols.linenr = "\u2b61"
let g:airline_symbols.space = ' '
""""""""""""""" Colorscheme
let g:solarized_italic = 0
try
    if has('gui_running')
        colors solarized
    else
        colors desert
    endif
catch /^Vim\%((\a\+)\)\=:E185/ "colorscheme does not exist
    colors desert " backup
endtry

""""""""""""""" File types
function! SetPythonOptions()
    set noexpandtab
    set nocindent
    set tabstop=8
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set smartindent
endfunction
function! SetAdocOptions()
    set syntax=asciidoc
    set wrap
    set linebreak
    set nolist
    set textwidth=0
    set wrapmargin=0
    set nocindent
    " line navigation for wrapped lines
    noremap  <buffer> <silent> k gk
    noremap  <buffer> <silent> j gj
    noremap  <buffer> <silent> 0 g0
    noremap  <buffer> <silent> $ g$nnoremap j gj
endfunction

au BufRead,BufNewFile *.html.erb set filetype=html
au BufRead,BufNewFile *.adoc call SetAdocOptions()
au BufRead,BufNewFile *.ino set filetype=cpp " Arduino
au BufRead,BufNewFile *.py call SetPythonOptions()

""""""""""""""" mapping
command! -nargs=* Make make <args> | cwindow 3
command! Vimrc tabedit $USERPROFILE\.vimrc
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


