au!
"""""""""""" gVim settings
if has('gui_running')
    au GUIEnter * simalt ~x
    set guifont=Consolas\ for\ Powerline\ FixedD:h11
    set langmenu=en_US
    let $LANG = 'en_US'
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    set guioptions=
    let &colorcolumn=join(range(120,500),",")
endif

set encoding=utf-8
""""""""""""" div
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk" || _curfile =~ ".*\.md" || _curfile =~ ".*\.snippets"
    set noexpandtab
else
    set shiftwidth=4
    set expandtab
    set tabstop=4
endif

let g:localvimrc_sandbox=0
let g:localvimrc_ask=0

" generic settings
set noshowmode
set lazyredraw
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
set previewheight=1
let mapleader = " "
syntax on
set rop=type:directx,geom:1,taamode:1


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
        let g:gruvbox_italic=0
        let g:gruvbox_bold=0
        let g:gruvbox_invert_selection=0
        colors gruvbox
    else
        colors busybee
    endif
catch /^Vim\%((\a\+)\)\=:E185/ "colorscheme does not exist
    colors desert " backup
endtry
"highlight clear SignColumn
""""""" CtrlP
set wildignore=*.pyc,*.o,*.d,*.crf,*.elf,*.axf,_viminfo,*._2i,*.lst,*.dep,*.exe,*.bin
let g:ctrlp_by_filename = 1
let g:ctrlp_custom_ignore = '.*\.(pyc|obj|o|crf|d|bin|exe)'
let g:ctrlp_prompt_mappings = {'AcceptSelection("e")': ['<c-t>'], 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'], }
nnoremap <leader>p :CtrlPMRU<CR>
nnoremap <silent> <leader>f :CtrlPFunky<CR>
let g:ctrlp_funky_syntax_highlight=1
let g:ctrlp_funky_after_jump='ztjzok'
""""""" Template
let g:templates_name_prefix='.template_'
""""""" Syntastic
if has('gui_running') && !exists('g:loaded_syntastic_plugin')
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 0
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:syntastic_c_compiler = 'arm-none-eabi-gcc'
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
    let g:airline_symbols.notexists = ' ✶'
    let g:airline#extensions#ctrlp#enabled = 1
    let g:airline#extensions#tabline#left_sep = "\u2b80"
    let g:airline#extensions#tabline#left_alt_sep = "\u2b81"
else
    let g:loaded_airline=1
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
fu! SetPythonOptions()
    set noexpandtab
    set nocindent
    set tabstop=8
    set expandtab
    set shiftwidth=4
    set softtabstop=4
    set smartindent
endf

fu! Autowrap()
    if synID(line("."),col("."),1)==0
        normal gqip
    endif
endf

fu! SetAdocOptions()
    setl syntax=asciidoc
    setl wrap
    setl linebreak
    setl nolist
    setl textwidth=129
    setl wrapmargin=0
    setl nocindent
    " line navigation for wrapped lines
    nnoremap  <buffer> <silent> k gk
    nnoremap  <buffer> <silent> j gj
    nnoremap  <buffer> <silent> 0 g0
    nnoremap  <buffer> <silent> $ g$
    compiler asciidoctor
    let &colorcolumn=join(range(&textwidth+1,999),",")
endf

fu! SetUVfileOptions()
    setl syntax=xml
    setl shiftwidth=2
    setl softtabstop=2
    setl smartindent
    setl nocindent
    setl foldmethod=indent
    setl foldlevelstart=999
    setl foldminlines=0
    setl foldnestmax=999
endf
fu! SetPreviewOptions()
    setl nonu
    setl cc=999
    setl syntax=c
endf
"quickfix stuff
au BufWinEnter quickfix setl cc=999 " No color column in quickfix window
au BufWinEnter quickfix resize 6
au BufWinEnter quickfix nnoremap <buffer> <Esc> :q<CR>
au BufWinEnter * if &previewwindow | call SetPreviewOptions() | endif

" autocommands
au BufRead,BufNewFile *.html.erb set filetype=html
au BufRead,BufNewFile *.adoc call SetAdocOptions()
au CursorHold *.adoc call Autowrap()
au BufRead,BufNewFile *.uvprojx call SetUVfileOptions()
au BufRead,BufNewFile *.ino set filetype=cpp " Arduino
au BufRead,BufNewFile *.py call SetPythonOptions()
au BufRead,BufNewFile *.md set filetype=markdown
au BufWritePost *.msc silent exe "call job_start('mscgen -T png " . expand('%') ."')"
au BufWritePost *.dot silent exe "call job_start('dot -Tpng -O " . expand('%') ."')"
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
nnoremap <A-j> ddp
nnoremap <A-k> ddkP
inoremap <A-j> <Esc>ddp
inoremap <A-k> <Esc>ddkP
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
"tab navigation
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
inoremap <C-Tab> <Esc>gt
inoremap <C-S-Tab> <Esc>gT
vnoremap <C-Tab> <Esc>gt
vnoremap <C-S-Tab> <Esc>gT

" auto pair
let g:AutoPairsMapSpace = 0
""""""""""""""""""""""""" VARIOUS
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

noremap <leader>c <Esc>:call ScratchCompile()<CR>

" Stack overflow
nnoremap <leader>s :StackOverflow<space>

" wrap paragraph
nnoremap <leader>q gqip

" Tab
vnoremap <leader>t :Tab /\S\+;<CR>

"uv
nnoremap <leader>up :call UV#SelProj()<CR>
nnoremap <leader>ut :call UV#SelTarget()<CR>
nnoremap <leader>ue :call UVedit()<CR>

function! Incr()
  let a = line('.') - line("'<")
  let c = virtcol("'<")
  if a > 0
    execute 'normal! '.c.'|'.a."\<C-a>"
  endif
  normal `<
endfunction
vnoremap <C-a> :call Incr()<CR>

fu! Func(name)
    echo 'Searching for ' . a:name . '...'
    let re = '^\(static\ \+\)*\(inline\ \+\)*\(\w\+\ \+\)' . a:name . '\s*('
    let loc = system('grep --color -rnI --include=*.c "' . re . '" .')
    try
        let file = matchstr(loc, "^[^:]*")
        let line = matchstr(loc, "^[0-9]*", strlen(file) + 1)
        let filename = matchstr(file, "[^/]*$")
        try
            exe ':tab sbuf ' . filename
            call cursor(line, 1)
        catch
            try
                exe ':tabe ' . file
                call cursor(line, 1)
            catch
                echo 'Cannot find file ' . filename
                echom v:exception
            endtry
        endtry
    catch
        echo 'grep failed, returned ' . loc
    endtry
endf
fu! FuncPeek(name)
    echo 'Searching for ' . a:name . '...'
    let re = '^\(static\ \+\)*\(inline\ \+\)*\(\w\+\ \+\)' . a:name . '\s*('
    let loc = system('grep --color -rnI --include=*.c "' . re . '" .')
    try
        let file = matchstr(loc, "^[^:]*")
        let line = matchstr(loc, "^[0-9]*", strlen(file) + 1)
        let filename = matchstr(file, "[^/]*$")
        set nosb
        exe ':2sp +' .line . ' ' . file
        exe 'normal! ' . line . 'G'
        exe 'normal! <C-w><C-j>'
    catch
        echo 'grep failed, returned ' . loc
    endtry
endf
fu! FuncEcho(name)
    let re = '^\(static\ \+\)*\(inline\ \+\)*\(\w\+\ \+\)' . a:name . '\s*('
    let loc = system('grep --color -rnI --include=*.c "' . re . '" .')
    try
        let signature = matchstr(loc, "[^:]*$")
        let output = matchstr(signature, "[^)]*)")
        if strlen(output) == 0
            echo signature[:-2]
        else
            echo output
        endif
    catch
        echo 'grep failed, returned ' . loc
    endtry
endf

com! -nargs=1 Func :call Func(<f-args>)
nnoremap <silent> <F12> "*yiw:call Func(@*)<CR>
nnoremap <silent> <S-F12> "*yiw:call FuncPeek(@*)<CR>
nnoremap <silent> <C-F12> "*yiw:call FuncEcho(@*)<CR>
inoremap <silent> <F12> <Esc>"*yiw:call Func(@*)<CR>
inoremap <silent> <S-F12> <Esc>"*yiw:call FuncPeek(@*)<CR>
inoremap <silent> <C-F12> <Esc>"*yiw:call FuncEcho(@*)<CR>
vnoremap <silent> <F12> <Esc>"*yiw:call Func(@*)<CR>
vnoremap <silent> <S-F12> <Esc>"*yiw:call FuncPeek(@*)<CR>
vnoremap <silent> <C-F12> <Esc>"*yiw:call FuncEcho(@*)<CR>

fu! MakeNote(name)
    let l:filepath = '$USERPROFILE/notes/' . a:name . '.md'
    exe ':tabe ' . l:filepath
    if !filereadable(glob(l:filepath))
        exe ':normal! cc# ' . substitute(a:name, '\w', '\U\0', '')
        :normal o
    endif
endf
com! -nargs=1 Note :call MakeNote(<f-args>)

fu! FuncSearchBack()
    return getline(search('^\(static \| inline \)*\w\+\s\+\w\+(.*)\s*{\=\s*$', 'bwnc'))
endf
fu! SetFuncSearchStatusline()
    let g:airline_section_b='%{FuncSearchBack()}'
    :AirlineRefresh
endf
fu! RestoreBranchIndicator()
    let g:airline_section_b='%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
    :AirlineRefresh
endf
au BufLeave *.c call RestoreBranchIndicator()
au BufEnter,BufWinEnter *.c call SetFuncSearchStatusline()


