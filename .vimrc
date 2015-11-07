"""""""""""" gVim settings
"set lines=400
"set columns=170
set ruler
set noswapfile

if has('gui_running')
  au GUIEnter * simalt ~x
  set guifont=Consolas\ for\ Powerline\ FixedD:h10,Consolas:h10
  set langmenu=en_US
  let $LANG = 'en_US'
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif

set encoding=utf-8
""""""""""""" div
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk" || _curfile =~ "*.nmake"
    set noexpandtab
else
    set shiftwidth=4
    set expandtab
    set tabstop=4
endif

set tags=./tags,./..tags,./../../tags,tags,$SDK_ROOT/../tags,_vimtags
set number
set backspace=indent,eol,start

set clipboard=unnamed

set incsearch

syntax enable

let &colorcolumn=join(range(101,999),",")

function! FoldBrace()
	if getline(v:lnum)[0] == '{'
		return '>1'
	endif
	if getline(v:lnum)[0] == '}'
		return '<1'
	endif
    " Fold license header:
    if getline(v:lnum) =~ '^\/\*.*$' && v:lnum == 1
        return '>1'
    endif
    if getline(v:lnum) =~ '^\*\{2,}\/\s*$'
        return '<1'
    endif
    " Fold documentation comments:
    if getline(v:lnum) =~ '^\/\*\*\s*$' " catch /**\n
        return '>1'
    endif
    if getline(v:lnum) =~ '^\s*\*\/\s*$'
        return '<1'
    endif
	return foldlevel(v:lnum)
endfunction
set foldexpr=FoldBrace()
set foldmethod=expr

set splitright
set backspace=2
set laststatus=2


if has('gui_running')
    set guioptions-=T
    set guioptions-=m
    set guioptions-=e
endif

"Trim whitespace
function! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun
"automatically on save:
autocmd BufWritePre * :call TrimWhitespace()
""""""""""""""" extensions
execute pathogen#infect()
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
highlight clear SignColumn
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')
"""""" neocomplcache
let g:neocomplcache_enable_at_startup = 1
" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
""""""" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_include_dirs = [  '%SDK_ROOT%/components/softdevice/s130/headers',
                                    \'%SDK_ROOT%/components/device',
                                    \'%SDK_ROOT%/components/toolchain',
                                    \'%SDK_ROOT%/components/toolchain/gcc',
                                    \'%SDK_ROOT%/components/libraries/util',
                                    \'C:/Users/trsn/Documents/SDK8/examples/smart-mesh/mesh/include',
                                    \'C:/Users/trsn/Documents/SDK8/examples/smart-mesh/scripts/Unity/src'
                                    \]
let g:syntastic_c_compiler_options = '-std=gnu99 -DSVCALL_AS_NORMAL_FUNCTION'
let g:syntastic_loc_list_height=4

""""""" airline
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_left_sep = "\u2b80" "use double quotes here
let g:airline_left_alt_sep = "\u2b81"
let g:airline_right_sep = "\u2b82"
let g:airline_right_alt_sep = "\u2b83"
let g:airline_symbols.branch = "\u2b60"
let g:airline_symbols.readonly = "\u2b64"
let g:airline_symbols.linenr = "\u2b61"
let g:airline_symbols.space = ' '
let g:airline#extensions#tabline#left_sep = "\u2b80"
let g:airline#extensions#tabline#left_alt_sep = "\u2b81"
let g:airline#extensions#syntastic#enabled = 1
""""""" easytags
let g:easytags_async = 1
au FocusGained * HighlightTags
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
    noremap <silent> <F5> :w<CR>:!start /min cmd /c C:\Users\trsn\Downloads\asciidoc-8.6.9\asciidoc-8.6.9\asciidoc.py % <CR>
:endfunction

au BufRead,BufNewFile *.html.erb set filetype=html
au BufRead,BufNewFile *.adoc call SetAdocOptions()
au BufRead,BufNewFile *.ino set filetype=cpp " Arduino
au BufRead,BufNewFile *.py call SetPythonOptions()
au FileType c set cindent
au FileType cpp set cindent


""""""""""""""" alternate.vim
map <C-S-k><C-S-o> :AV<CR>
noremap <C-k><C-o> :A<CR>
noremap <S-F12> <Leader>ih

""""""""""""""" mapping
command! -nargs=* Make cd ./gcc || make -w <args> || cd %:p:h | cwindow 3
command! Vimrc tabedit $USERPROFILE\.vimrc
map Make <F7>

map p p=j

map <C-c> Esc
function! NextError()
    try
        lnext
    catch
        try
            ll
        catch
            echo "No more errors"
        endtry
    endtry
:endfunction

function! PrevError()
    try
        lprev
    catch
        try
            ll
        catch
            echo "No more errors"
        endtry
    endtry
:endfunction
map <F4> <Esc>:call NextError()<CR>
map <S-F4> <Esc>:call PrevError()<CR>

"window split navigation
nnoremap <C-H> <C-W><C-H>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-J> <C-W><C-J>

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

inoremap <S-Tab> <C-d>

"scratch compilation:
function! ScratchCompile()
    if expand("%:p") == expand('$TEMP\temp.c')
        silent !cmd  /c "gcc % -o %:h\\temp.exe -mno-ms-bitfields -std=c99" && cls && "%:h\temp.exe" & echo. & echo --------------------------------- & pause
    else
        :execute "tab drop $TEMP\\temp.c"
        :execute "normal ggdG"
        :execute "read $TEMP\\template.c"
        :execute "normal ggddzR/main\<CR>jj"
        :execute "w"
    endif
:endfunction
noremap <F5> <Esc>:call ScratchCompile()<CR>

"ctags
nnoremap <F12> <C-]>
inoremap <F12> <Esc><C-]>
nnoremap <C-F12> 5<C-w><C-]>
inoremap <C-F12> <Esc>5<C-w><C-]>

"comment:
function! CommentOut()
    try
        execute '.s:\(\s*\)/\* \(.*\) \*/\s*:\1\2:g'
    catch /E486:/
        try
            execute '.s:\(\s*\)/\*\(.*\)\*/\s*:\1\2:g'
        catch /E486:/
            try
                execute '.s:\(\s*\)\(.*\):\1/\* \2 \*/:g'
            catch /E486:/
                echo "Error while commenting out"
            endtry
        endtry
    endtry
:endfunction
map <silent> <C-k><C-c> :call CommentOut()<CR>

