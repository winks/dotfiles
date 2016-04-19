" vimrc by fa[at]art-core.org
"
" shamelessly inspired by:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" http://blog.danielfischer.com/2010/11/19/a-starting-guide-to-vim-from-textmate/

" Tell vim to remember certain things when we exit
" '10 : marks will be remembered for up to 10 previously edited files
" :20 : up to 20 lines of command-line history will be remembered
" % : saves and restores the buffer list
" n... : where to save the viminfo files
if has('win32')
    set viminfo='10,:20,%,n$HOME/vimfiles/_viminfo
    set directory=$HOME/vimfiles/tmp
    let g:fuf_dataDir = expand("$HOME/vimfiles/vim-fuf-data")
    let MRU_File = expand("$HOME/vimfiles/_vim_mru_files")
else
    set viminfo='10,:20,%,n~/.vim/.viminfo
    set directory=$HOME/.vim/tmp
    let g:fuf_dataDir = expand("$HOME/.vim/.vim-fuf-data")
    let MRU_File = expand("$HOME/.vim/.vim_mru_files")
endif

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
set ttyfast
set ruler
set backspace=indent,eol,start
set paste
set title

set equalalways
set splitbelow splitright


if has("statusline")
    set laststatus=2
    " now set it up to change the status line based on mode
    if version >= 700
"        hi StatusLine term=reverse ctermfg=darkblue ctermbg=white
"        au InsertEnter * hi StatusLine term=reverse ctermfg=darkblue ctermbg=30 guibg=#003853
"        au InsertLeave * hi StatusLine term=reverse ctermfg=darkblue ctermbg=white guibg=#003853
    endif
    set statusline=%F%m%r%h%w\ [%{&ff}]\ %y\ [%L\ /\ %p%%]\ [%02l,%02v]
endif

if version >= 730
    set relativenumber
    set undofile
    set colorcolumn=80
endif


let mapleader =","

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set wrap
set textwidth=79
set formatoptions=qrn1

set list
set listchars=tab:»·

" hardcore mode: unmap arrow keys
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

if has("user_commands")
    command! -bang -nargs=? -complete=file E e<bang> <args>
    command! -bang -nargs=? -complete=file W w<bang> <args>
    command! -bang -nargs=? -complete=file Wq wq<bang> <args>
    command! -bang -nargs=? -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

nnoremap ; :

nnoremap <leader><space> :noh<cr>
nnoremap <tab> %¿
vnoremap <tab> %

" Vertical and horizontal split then hop to a new buffer
:noremap <leader>h <C-w>n
:noremap <leader>v :vnew<CR>
" strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
" reselect the text that was just pasted
nnoremap <leader>v V`]
" open new tab
nnoremap <leader>e :tabnew<CR>

" What the hell is this supposed to do?
"nnoremap <leader>w <C-w>v<C-w>l

" line numbers
:noremap <leader>l :set number!<CR>
" Invisible characters
:noremap <leader>i :set list!<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" source ~/.vimrc
nnoremap <leader>r :so ~/.vimrc

" nerd tree shortcut
map <leader>n :NERDTreeToggle<CR>
" FuzzyFinder
nmap ,f :FufFileWithCurrentBufferDir<CR>
nmap ,b :FufBuffer<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
nnoremap <leader>p :CtrlP<CR>

if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
    nmap <Leader>a:: :Tabularize /:\zs<CR>
    vmap <Leader>a:: :Tabularize /:\zs<CR>
    nmap <Leader>a, :Tabularize /,<CR>
    vmap <Leader>a, :Tabularize /,<CR>
    nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
    vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
endif

if has("gui_running")
    au GUIEnter * set lines=52 columns=90
    set guifont=Noto\ Mono\ 10
    set colorcolumn=80

    set background=light
    "colorscheme darkspectrum
    colorscheme ironman
    set cursorline
    let g:Powerline_symbols = 'fancy'
else
    set t_Co=256

    set background=dark
    colorscheme solarized
    "colorscheme elflord
    "set cursorline
    let g:Powerline_symbols = 'fancy'
endif

"command W w
"command Q q
"command Wq wq

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

au FocusGained * :call Highlight_cursor()
au FocusLost * :call Autosave()

if has("autocmd")
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |exe "normal g`\"" |endif
    " title
    autocmd BufEnter * let &titlestring = hostname() . " [ vim " . expand("%:p:~") . " ]"
    autocmd VimLeavePre * let &titlestring = getcwd()

    " Syntax of these languages is fussy over tabs Vs spaces
    autocmd FileType phtml setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType yaml  setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType jade  setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType html  setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType sass  setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType less  setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType xml   setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType py    setlocal ts=4 sts=2 sw=2 expandtab
    autocmd FileType go    setlocal ts=4 sts=2 sw=2 noexpandtab
    autocmd FileType Makefile setlocal ts=4 sts=2 sw=2 noexpandtab
    " Delete white spaces on save
    autocmd BufWritePre *.html,*.php,*.pthml,*.js,*.xml :call <SID>StripTrailingWhitespaces()
    " Source the vimrc file after saving it
    autocmd BufWritePost .vimrc source $MYVIMRC

    augroup filetypedetect
        au BufNewFile,BufRead *.pp      set ft=puppet
    " Treat .rss files as XML
        au BufNewFile,BufRead *.rss     set ft=xml
    " Treat .json files as javascript
        au BufNewFile,BufRead *.json    set ft=javascript
        au BufNewFile,BufRead *.go      set ft=go
    augroup END

    augroup Programming
        autocmd!
        autocmd BufWritePost *.pp !puppet parser validate <afile>
        autocmd BufWritePost *.pp !puppet-lint <afile>
        autocmd BufWritePost *.php !php -l <afile>
    augroup END
endif

" Highlight the cursorline
function! Highlight_cursor ()
    set cursorline
    redraw
    sleep 1
    set nocursorline
endfunction

" Autosaving
function! Autosave ()
    if &modified && bufname('%') != ""
        write
        echo "Autosaved file while you were absent"
    endif
endfunction

" StripTrailingWhitespaces
function! <SID>StripTrailingWhitespaces()
    " Preparation : save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    "call Tabstyle_spaces()
    call cursor(l, c)
endfunction

set sessionoptions=blank,buffers,curdir,folds,help
",resize,tabpages,winsize

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:netrw_liststyle=3
map <Leader>e :vsp<CR>:Explore<CR>
map <Leader>E :e .<CR>
