" =======================================================================
" Version:     1.1.0
" Description: Vim plugin that enables syntax checking in syntastic with the rapydscript linter
" Maintainer:  Alexander Tsepkov <atspekov at gmail dot com>
" Based On Work From:  Kovid Goyal <kovid at kovidgoyal.net>
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

function! SyntaxCheckers_rapydscript_rapydscript_GetLocList() dict
    let makeprg = self.makeprgBuild({ 'args': '--lint' })

    let errorformat = '%f:%l:%c:%t:%m'

    let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

    for e in loclist
        let parts = matchlist(e['text'], '\v^([^:]*)\:(.*)')
        if len(parts) > 2 
            let e['hl'] = '\V' . (parts[1] ==# ';' ? ';' : '\<' . escape(parts[1], '\') . '\>')
            let e['text'] = parts[2]
        endif
    endfor

    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rapydscript',
    \ 'name': 'rapydscript'})

let &cpo = s:save_cpo
unlet s:save_cpo
