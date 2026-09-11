" vimrc by fa[at]art-core.org
"
" this is light on deps, but still assumes:
"
" autoload/pathogen.vim
" colors/tokyonight.vim
" pack/plugins/start/ctrlp
" pack/vendor/start/nerdtree
"
" mostly tested on Vim Classic 8.3 now
"
" shamelessly inspired by:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
" http://blog.danielfischer.com/2010/11/19/a-starting-guide-to-vim-from-textmate/

" yes this needs to be at the very top
set nocompatible

" Tell vim to remember certain things when we exit
" '10 : marks will be remembered for up to 10 previously edited files
" :20 : up to 20 lines of command-line history will be remembered
" % : saves and restores the buffer list
" n... : where to save the viminfo files
if isdirectory($HOME . '/.vim/tmp') == 0
    :silent !mkdir -p ~/.vim/tmp >/dev/null 2>&1
endif
set viminfo+='10,:20,%,n~/.vim/.viminfo
set directory=~/.vim/tmp//
set backupdir=~/.vim/tmp//
set undodir=~/.vim/tmp//

filetype off
execute pathogen#infect()
filetype plugin indent on

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
let &titleold=getcwd()

set equalalways
set splitbelow splitright

if has("statusline")
    set laststatus=2
    set statusline=%F%m%r%h%w\ [%{&ff}]\ %y\ [%L\ /\ %p%%]\ [%02l,%02v]
endif

set colorcolumn=80

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
set listchars=tab:»·,nbsp:·

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
:noremap <leader>j :set listchars=tab:»·,space:·,nbsp:·,trail:·<CR>
:noremap <leader>i :set invlist<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" source ~/.vimrc
nnoremap <leader>r :so ~/.vimrc

" nerd tree shortcut
map <leader>n :NERDTreeToggle<CR>

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
nnoremap <leader>p :CtrlP<CR>

set t_Co=256

set background=dark
set termguicolors

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 1
colorscheme tokyonight
let g:Powerline_symbols = 'fancy'

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
    " Treat .rss files as XML
        au BufNewFile,BufRead *.rss     set ft=xml
    " Treat .json files as javascript
        au BufNewFile,BufRead *.json    set ft=javascript
        au BufNewFile,BufRead *.go      set ft=go
    augroup END

    augroup Programming
        autocmd!
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

"au VimEnter * RainbowParenthesesToggle
"au Syntax * RainbowParenthesesLoadRound
"au Syntax * RainbowParenthesesLoadSquare
"au Syntax * RainbowParenthesesLoadBraces

let g:netrw_liststyle=3
map <Leader>e :vsp<CR>:Explore<CR>
map <Leader>E :e .<CR>
