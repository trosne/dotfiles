"""""""""""" gVim settings
if has('gui_running')
    au GUIEnter * simalt ~x
    set guifont=Consolas\ for\ Powerline\ FixedD:h11
    set langmenu=en_US
    let $LANG = 'en_US'
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    set guioptions-=T
    set guioptions-=m
    set guioptions-=e
endif

set encoding=utf-8
""""""""""""" div
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk" || _curfile =~ ".*\.md"
    set noexpandtab
else
    set shiftwidth=4
    set expandtab
    set tabstop=4
endif

let g:syntastic_c_include_dirs = []
let g:localvimrc_sandbox=0
let g:localvimrc_ask=0

" generic settings
set ruler
set noswapfile
set autoread
set number
set smartindent
set backspace=indent,eol,start
set clipboard=unnamed
set incsearch
set splitright
set splitbelow
set backspace=2
set laststatus=2
let mapleader = " "
syntax enable


"folding
function! FoldText()
    let first_line = getline(v:foldstart)
    let first_line = substitute(first_line, '^\s*', '')
    let last_line = getline(v:foldend)
    let n = v:foldend - v:foldstart + 1
    let content_text = '...'
    if n==3
        let content_text = substitute(getline(v:foldstart+1), '^\s*\**\s*', "", "")
        if strlen(content_text) > 30
            let content_text = content_text[:27] . '...'
        endif
    endif
    let info = "+-- " . n . " lines: "
    let fold_len = 49
    let content_len = (strlen(info) + strlen(content_text))
    return info . first_line[: fold_len - 2 - content_len/2] . " " . content_text . " " . last_line[-(fold_len + 1) + content_len/2 + content_len%2:] . ' '
endfunction

set foldtext=FoldText()
set foldmethod=syntax
set foldnestmax=1

"Trim whitespace
function! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun
"automatically on save:
autocmd BufWritePre * :call TrimWhitespace()
""""""""""""""" extensions
if has('gui_running')
    execute pathogen#infect()
endif
""""""""""""""" Colorscheme
let g:solarized_italic = 0
try
    if has('gui_running')
        colors busybee
    else
        colors busybee
    endif
catch /^Vim\%((\a\+)\)\=:E185/ "colorscheme does not exist
    colors desert " backup
endtry
highlight clear SignColumn
let &colorcolumn=join(range(80,999),",")
""""""" CtrlP
set wildignore=*.pyc,*.o,*.d,*.crf,*.elf,*.axf
let g:ctrlp_by_filename = 1
let g:ctrlp_custom_ignore = '.*\.(pyc|o|crf|d)'
let g:ctrlp_prompt_mappings = {'AcceptSelection("e")': ['<c-t>'], 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'], }
nnoremap <leader>p :CtrlPMRU<CR>
nnoremap <silent> <leader>f :CtrlPFunky<CR>
let g:ctrlp_funky_syntax_highlight=1
let g:ctrlp_funky_after_jump='ztjzok'
""""""" Template
let g:templates_name_prefix='.template_'
""""""" Syntastic
if has('gui_running')
    "set statusline+=%#warningmsg#
    "set statusline+=%{SyntasticStatuslineFlag()}
    "set statusline+=%*
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_c_compiler = 'gcc'
    let g:syntastic_c_compiler_options = '-std=gnu99 -DSVCALL_AS_NORMAL_FUNCTION'
    let g:syntastic_loc_list_height=4
    let g:syntastic_enable_balloons=0
    let g:syntastic_enable_signs=0
else
    let g:loaded_syntastic_plugin=1
endif

""""""" airline
if has('gui_running')
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
    "let g:airline#extensions#syntastic#enabled = 1
    let g:airline#extensions#ctrlp#enabled = 1
    "let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#tabline#left_sep = "\u2b80"
    let g:airline#extensions#tabline#left_alt_sep = "\u2b81"
else
    let g:loaded_airline=1
    let g:loaded_xolox_misc=1
endif
" Youcompleteme
let g:ycm_server_python_interpreter="C:/Python27/python.exe"
let g:ycm_confirm_extra_conf=0
let g:ycm_key_list_previous_completion = ['<Up>', '<C-k>']
let g:ycm_key_list_select_completion   = ['<Down>', '<C-j>', '<Tab>']
let g:ycm_goto_buffer_command = 'new-or-existing-tab'
let g:ycm_min_num_of_chars_for_completion = 99
let g:ycm_min_num_identifier_candidate_chars = 4
nnoremap <Leader>e :YcmDiags<CR>
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
    nnoremap  <buffer> <silent> k gk
    nnoremap  <buffer> <silent> j gj
    nnoremap  <buffer> <silent> 0 g0
    nnoremap  <buffer> <silent> $ g$
    noremap <silent> <C-F7> :w<CR>:!start /min cmd /c C:\Users\trsn\Downloads\asciidoc-8.6.9\asciidoc-8.6.9\asciidoc.py % <CR>
:endfunction

"quickfix stuff
au BufWinEnter quickfix setl cc=999 " No color column in quickfix window
au BufWinEnter quickfix resize 6
au BufWinEnter quickfix nnoremap <buffer> <Esc> :q<CR>

" autocommands
au BufRead,BufNewFile *.html.erb set filetype=html
au BufRead,BufNewFile *.adoc call SetAdocOptions()
au BufRead,BufNewFile *.ino set filetype=cpp " Arduino
au BufRead,BufNewFile *.py call SetPythonOptions()
au BufRead,BufNewFile *.md set filetype=markdown
au BufWritePost *.msc silent !start mscgen -T png %
au BufWritePost *.adoc silent !start /min cmd /c C:/Users/trsn/Downloads/asciidoc-8.6.9/asciidoc-8.6.9/asciidoc.py %
au FileType c silent set cindent
au FileType cpp set cindent
augroup Binary
    au!
      au BufReadPre  *.bin let &bin=1
      au BufReadPost *.bin if &bin | %!xxd
      au BufReadPost *.bin set ft=xxd | endif
      au BufWritePre *.bin if &bin | %!xxd -r
      au BufWritePre *.bin endif
      au BufWritePost *.bin if &bin | %!xxd
      au BufWritePost *.bin set nomod | endif
augroup END
""""""""""""""" mapping
command! Vimrc tabedit $VIM\.vimrc
nnoremap <F7> :Make<CR>

""""""""""""""""""""""" MOVEMENT
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
"tab navigation
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
inoremap <C-Tab> <Esc>gt
inoremap <C-S-Tab> <Esc>gT
vnoremap <C-Tab> <Esc>gt
vnoremap <C-S-Tab> <Esc>gT

""""""""""""""""""""""""" Various
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
map <leader>n <Esc>:call NextError()<CR>

"font set
nnoremap <F11> :set guifont=*<CR>
" Shift tab to reduce indent level
inoremap <S-Tab> <C-d>
"insert mode paste
inoremap <C-v> <Esc>pa
" stop the bloody minimizing -> do undo instead
nnoremap <C-z> u

"scratch compilation:
function! ScratchCompile()
    if expand("%:p") == expand('$TEMP\temp.c')
        silent !cmd  /c "gcc % -o %:h\\temp.exe -mno-ms-bitfields -std=c99" && cls && "%:h\temp.exe" & echo. & echo --------------------------------- & pause
    else
        :execute "tab drop $TEMP\\temp.c"
        :execute "normal gg\"_dG"
        :execute "read $TEMP\\template.c"
        :execute "normal gg\"_ddzR/main\<CR>jj"
        :execute "w"
    endif
:endfunction
noremap <leader>c <Esc>:call ScratchCompile()<CR>

"ctags
nnoremap <F12> :YcmCompleter GoToDefinition<CR>
inoremap <F12> <Esc>:YcmCompleter GoToDefinition<CR>
nnoremap <C-F12> 5<C-w><C-]>
inoremap <C-F12> <Esc>5<C-w><C-]>
" Stack overflow
nnoremap <leader>s :StackOverflow<space>

"uv
nnoremap <leader>up :call UV#SelProj()<CR>
nnoremap <leader>ut :call UV#SelProj()<CR>
