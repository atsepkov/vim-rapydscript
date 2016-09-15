" =======================================================================
" Version:     1.0.0
" Description: Vim plugin that enables syntax checking in syntastic with the rapydscript linter
" Maintainer:  Kovid Goyal <kovid at kovidgoyal.net>
" License:     Copyright (C) 2015 Kovid Goyal (Vim License)
" The same license that vim is distributed under. See :help license
" ======================================================================

" See
" https://github.com/scrooloose/syntastic/wiki/Syntax-Checker-Guide#external

if exists("g:loaded_syntastic_rapydscript_rapydscript_checker")
    finish
endif
let g:loaded_syntastic_rapydscript_rapydscript_checker = 1

let s:save_cpo = &cpo
set cpo&vim

if exists('g:syntastic_extra_filetypes')
    call add(g:syntastic_extra_filetypes, 'rapydscript')
else
    let g:syntastic_extra_filetypes = ['rapydscript']
endif

function! SyntaxCheckers_rapydscript_rapydscript_IsAvailable() dict
    return executable(self.getExec())
endfunction

function! SyntaxCheckers_rapydscript_rapydscript_GetHighlightRegex(item)
    let term = a:item['highlightname']
    if term == ';'
        return '\V;'
    endif
    if term !=# ''
        return '\V\<' . escape(term, '\') . '\>'
    endif
    return ''
endfunction

function! SyntaxCheckers_rapydscript_rapydscript_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args': '--lint' })

    let errorformat = '%f:%l:%c:%t:%m'

    let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

    for e in loclist
        let parts = split(e['text'], ':', 1)
        let e['vcol'] = 0
        let e['text'] = join(parts[1:], ':')
        let e['highlightname'] = parts[0]
    endfor

    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rapydscript',
    \ 'name': 'rapydscript'})

let &cpo = s:save_cpo
unlet s:save_cpo
