" Vim color file
" Author: Alexander Tsepkov <atsepkov@pyjeon.com>
" A sample color scheme file that's compatible with the syntax file for
" rapydscript.vim in this bundle

set bg=dark
hi clear
if exists("syntax_on")
	syntax reset
endif

let colors_name = "rapyd"

hi Normal		ctermfg=231 ctermbg=NONE

hi Comment		ctermfg=240 cterm=italic
" reserved constatnts (True, False, self, etc.)
hi Constant		ctermfg=190 cterm=none
" classes/modules already existing in JS or stdlib
hi Module		ctermfg=33	cterm=bold
hi String		ctermfg=160 cterm=none
hi Statement	ctermfg=172 cterm=none
hi Entity		ctermfg=99 cterm=bold
" functions that are part of stdlib or JavaScript
hi Structure	ctermfg=69 cterm=none
" function arguments
hi Support		ctermfg=39 cterm=italic
hi LineNr		ctermfg=240 ctermbg=NONE cterm=italic
hi Title		ctermfg=100 ctermbg=NONE	cterm=bold
" special characters and end of file
hi NonText		ctermfg=160 ctermbg=236	cterm=none

hi Visual		cterm=reverse
hi VertSplit	ctermfg=white
hi StatusLine	ctermfg=82 ctermbg=NONE cterm=italic
hi StatusLineNC ctermfg=88 ctermbg=NONE
hi SpecialKey	ctermfg=88 ctermbg=NONE cterm=none


hi link Define			Entity
hi link Function		Entity

"hi link Structure		Support
hi link Special			Support
hi link Test			Support

hi link Character       Constant
hi link Number          Constant
hi link Boolean         Constant

hi link Float           Number

hi link Conditional     Statement
hi link StorageClass    Statement
hi link Operator        Statement
hi link Statement       Statement
