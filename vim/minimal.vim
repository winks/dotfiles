set nocompatible

if isdirectory($HOME . '/.vim/tmp') == 0
    :silent !mkdir -p ~/.vim/tmp >/dev/null 2>&1
endif
set viminfo+='10,:20,%,n~/.vim/.viminfo
set directory=~/.vim/tmp//
set backupdir=~/.vim/tmp//
set undodir=~/.vim/tmp//
let MRU_File = expand("$HOME/.vim/.vim_mru_files")

execute pathogen#infect()

"set modelines=0
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
"set expandtab
"
"set encoding=utf-8
"set autoindent
"set showmode
"set showcmd
"set hidden
"set wildmenu
"set wildmode=list:longest
"set noerrorbells
"set visualbell
"set ttyfast
"set ruler
"set backspace=indent,eol,start
"set paste
"set title
"let &titleold=getcwd()

let mapleader=","

nnoremap / /\v
vnoremap / /\v
"set ignorecase
"set smartcase
"set gdefault
"set incsearch
"set showmatch
"set hlsearch

set wrap
set textwidth=79
set formatoptions=qrn1

if has("syntax")
    syntax on
endif

set t_Co=256

set background=dark
colorscheme solarized
"let g:Powerline_symbols = 'fancy'
"let g:fuf_dataDir = expand("$HOME/.vim/.vim-fuf-data")

" FuzzyFinder
"nmap ,f :FufFileWithCurrentBufferDir<CR>
"nmap ,b :FufBuffer<CR>
nmap ,f :CtrlP<CR>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
