" vimrc by fa[at]art-core.org
"
" shamelessly inspired by:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" http://blog.danielfischer.com/2010/11/19/a-starting-guide-to-vim-from-textmate/

colorscheme elflord

filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

set nocompatible

set modelines=0

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set encoding=utf-8
set scrolloff=3
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set noerrorbells
set visualbell
" set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set paste

if has("statusline")
    set laststatus=2
    " now set it up to change the status line based on mode¬
    if version >= 700
        hi StatusLine term=reverse ctermfg=blue ctermbg=white
        au InsertEnter * hi StatusLine term=reverse ctermfg=darkblue ctermbg=magenta
        au InsertLeave * hi StatusLine term=reverse ctermfg=darkblue ctermbg=white
    endif
    set statusline=%F%m%r%h%w\ [%{&ff}]\ %y\ [%L\ /\ %p%%]\ [%02l,%02v]
endif

if version >= 730
    set relativenumber
    set undofile
    set colorcolumn=85
endif

set directory=~/.vim/tmp
" Tell vim to remember certain things when we exit
" '10 : marks will be remembered for up to 10 previously edited files
" "100 : will save up to 100 lines for each register
" :20 : up to 20 lines of command-line history will be remembered
" % : saves and restores the buffer list
" n... : where to save the viminfo files
set viminfo='10,"100,:20,%,n~/.vim/.viminfo
let mapleader =","

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %¿
vnoremap <tab> %

set wrap
set textwidth=79
set formatoptions=qrn1

set list
set listchars=tab:»·

" hardcore mode
"nnoremap <up> <nop>
"nnoremap <down> <nop>
"nnoremap <left> <nop>
"nnoremap <right> <nop>
"inoremap <up> <nop>
"inoremap <down> <nop>
"inoremap <left> <nop>
"inoremap <right> <nop>
nnoremap j gj
nnoremap k gk

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap ; :

" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" reselect the text that was just pasted
nnoremap <leader>v V`]
nnoremap <leader>l :tabnew<CR>

nnoremap <leader>w <C-w>v<C-w>l

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <leader>r :so ~/.vimrc

" nerd tree shortcut
map <leader>n :NERDTreeToggle<CR>

if has("gui_running")
    au GUIEnter * set lines=52 columns=90
    set guifont=Monaco
    colorscheme mustang

    set cursorline
endif

"command W w
"command Q q
"command Wq wq

set title

" Folding
set foldenable
set foldmarker={,}
set foldmethod=marker
set foldlevel=100

if has("syntax")
    syntax on
endif

highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"                      trail | space+tab | tabs not at start of line
match ExtraWhitespace /\s\+$\| \+\ze\t\|[^\t]\ts\t\+/

"au FocusLost * : wa
au FocusGained * :call Highlight_cursor()
au FocusLost * :call Autosave()

" When editing a file, always jump to the last cursor position¬
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |exe "normal g`\"" |endif
" title
autocmd BufEnter * let &titlestring = hostname() . " [ vim " . expand("%:p:~") . " ]"
autocmd VimLeavePre * let &titlestring = getcwd()

augroup filetypedetect
"    au! BufRead,BufNewFile *.pp     setfiletype puppet
"    au! BufRead,BufNewFile +.inc    setfiletype php
    au BufRead,BufNewFile *.pp              set filetype=puppet
augroup END

augroup Programming
    autocmd!
    autocmd BufWritePost *.pp !puppet parser validate <afile>
augroup END

function! Highlight_cursor ()
    set cursorline
    redraw
    sleep 1
    set nocursorline
endfunction
function! Autosave ()
    if &modified && bufname('%') != ""
        write
        echo "Autosaved file while you were absent"
    endif
endfunction

set sessionoptions=blank,buffers,curdir,folds,help
",resize,tabpages,winsize

"let MRU_File = '~/.vim/.vim_mru_files'
