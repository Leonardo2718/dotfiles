filetype plugin indent on
set encoding=utf-8
"set digraph
syntax on
set number
"colorscheme inkpot
"colorscheme blacklight

" enable mouse support
set mouse=a

" tab/indent config
set tabstop=4
set shiftwidth=4
set expandtab

" highlight white space
set listchars=tab:»»,trail:·,eol:¬,extends:>,precedes:<
set list

" auto commands
autocmd BufWritePre * :%s/\s\+$//e " remove trailing white space before saving a file
autocmd BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
autocmd BufNewFile,BufRead trtrace.log* set filetype=trtracelog

" File type specific config (see `filetype.vim` for file type detection information,
" including a list of known file types)
autocmd FileType gitcommit call GitConfig()
autocmd FileType gitrebase call GitRebase()
autocmd FileType markdown call MarkdownConfig()
autocmd FileType rst call MarkdownConfig()
autocmd FileType trtracelog call TRTraceLog()

" config specific for git commit message
function! GitConfig()
    set spell spelllang=en_ca
    set textwidth=72
endfunction

" config specific for git rebasing
function! GitRebase()
    set cursorline
endfunction

" config specific for Markdown files
function! MarkdownConfig()
    set spell spelllang=en_ca
    set tabstop=2
    set shiftwidth=2
endfunction

function! TRTraceLog()
    syntax off
    set nolist
    set hlsearch
    set cursorline
    set nowrap
endfunction

function! LongLines()
    set cursorline
    set nowrap
endfunction

