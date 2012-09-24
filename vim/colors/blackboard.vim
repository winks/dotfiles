" Vim color scheme
"
" Name:         blackboard.vim
" Maintainer:   Ben Wyrosdick <ben.wyrosdick@gmail.com>
" Last Change:  20 August 2009
" License:      public domain
" Version:      1.4

set background=dark
hi clear
if exists("syntax_on")
   syntax reset
endif

let g:colors_name = "blackboard"

" Colours in use
" --------------
" #FF5600 bright orange
" #FFDE00 yolk yellow
" #D8FA3C lemon yellow
" #61CE3C green
" #84A7C1 light blue
" #AEAEAE medium grey

"GUI Colors
highlight Normal guifg=White   guibg=#0B1022 ctermbg=233
highlight Cursor guifg=Black   guibg=Yellow
highlight CursorLine guibg=#191E2F ctermbg=235
highlight LineNr guibg=#323232 ctermbg=236 guifg=#888888 ctermfg=102
highlight Folded guifg=#1d2652 ctermfg=236 guibg=#070a15 ctermbg=233
highlight Pmenu guibg=#84A7C1 ctermbg=109
highlight Visual guibg=#283A76 ctermbg=24

"General Colors
highlight Comment guifg=#AEAEAE ctermfg=145
highlight Constant guifg=#D8FA3C ctermfg=191
highlight Keyword guifg=#FFDE00 ctermfg=220
highlight String guifg=#61CE3C ctermfg=77
highlight Type guifg=#84A7C1 ctermfg=109
highlight Identifier guifg=#61CE3C ctermfg=77 gui=NONE
highlight Function guifg=#FF5600 ctermfg=202 gui=NONE
highlight clear Search
highlight Search guibg=#1C3B79 ctermbg=24
highlight PreProc guifg=#FF5600 ctermfg=202

" StatusLine
highlight StatusLine  guifg=#000000 ctermfg=0 guibg=#ffffaf ctermbg=229 gui=italic
highlight StatusLineNC  guifg=#000000 ctermfg=0 guibg=#ffffff ctermbg=15 gui=NONE

"Invisible character colors
highlight NonText guifg=#4a4a59 ctermfg=239
highlight SpecialKey guifg=#4a4a59 ctermfg=239

"HTML Colors
highlight link htmlTag Type
highlight link htmlEndTag htmlTag
highlight link htmlTagName htmlTag

"Ruby Colors
highlight link rubyClass Keyword
highlight link rubyDefine Keyword
highlight link rubyConstant Type
highlight link rubySymbol Constant
highlight link rubyStringDelimiter rubyString
highlight link rubyInclude Keyword
highlight link rubyAttribute Keyword
highlight link rubyInstanceVariable Normal

"Rails Colors
highlight link railsMethod Type

"Sass colors
highlight link sassMixin Keyword
highlight link sassMixing Constant

"Outliner colors
highlight OL1 guifg=#FF5600 ctermfg=202
highlight OL2 guifg=#61CE3C ctermfg=77
highlight OL3 guifg=#84A7C1 ctermfg=109
highlight OL4 guifg=#D8FA3C ctermfg=191
highlight BT1 guifg=#AEAEAE ctermfg=145
highlight link BT2 BT1
highlight link BT3 BT1
highlight link BT4 BT1

"Markdown colors
highlight markdownCode guifg=#61CE3C ctermfg=77 guibg=#070a15 ctermbg=233
highlight link markdownCodeBlock markdownCode

"Git colors
highlight gitcommitSelectedFile guifg=#61CE3C ctermfg=77
highlight gitcommitDiscardedFile guifg=#C23621 ctermfg=130
highlight gitcommitWarning guifg=#C23621 ctermfg=130
highlight gitcommitBranch guifg=#FFDE00 ctermfg=220
highlight gitcommitHeader guifg=#84A7C1 ctermfg=109

