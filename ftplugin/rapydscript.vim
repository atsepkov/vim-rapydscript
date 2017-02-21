set noexpandtab
set tabstop=4
set softtabstop=4
set magic

" highlight modes
let rapydscript_highlight_builtins = 1

" Setup syntastic integration
if !exists('g:syntastic_rapydscript_checkers')
    let g:syntastic_rapydscript_checkers = ['rapydscript']
endif

" jump to variable/function definition, also finds variables declared in groups (implicit tuples)
nnoremap ,d ?\(\(global\\|nonlocal\) (\{0,1\}[^=(]*.\\|def \)\><CR>

" jump to previous variable assignment (var= | var+= | var||= | etc)
nnoremap ,= ?\(\([ ]*,[ ]*$[a-z][a-z0-9]*[ ]*\)*)\)\{0,1\}\s*\([-+*/%.\|&x^]\\|\(\*\*\\|\|\|\\|>>\\|<<\)\)\{0,1\}=[^=]<CR>``0n<Right>

" comment/uncomment (already part of my main .vimrc)
"map ,# :s_^_#_<CR>:noh<CR>
"map ,* :s_#__<CR>:noh<CR>

set makeprg=echo\ 'Compiling\ %'\ &&\ rapydscript\ %\ &&\ echo\ 'Finished\ compiling'

" trigger Tabular automatically on :, but only when line looks like a legit
" hash
"inoremap <silent> : :<Esc>:call Align(':', '^\s\+[''"]\?[A-Za-z0-9_-]\+[''"]\?\s*:$')<CR>a

" dump current arg (in the future I should have this auto-prepend \ to hashes
" and arrays)
map ,D! viwoh"zy<F12>o<HOME>console.log('<ESC>"zpa:',<ESC>"zpa)<ESC>hh<F12>

" python style comments instead of the default C style
set commentstring=#\ %s


if has('python')
    command! -nargs=1 AvailablePython python <args>
    let s:available_short_python = ':py'
elseif has('python3')
    command! -nargs=1 AvailablePython python3 <args>
    let s:available_short_python = ':py3'
else
    throw 'No python support present, vim-isort will be disabled'
endif

command! Isort exec("AvailablePython isort_file()")

if !exists('g:vim_isort_map')
    let g:vim_isort_map = '<C-i>'
endif

if g:vim_isort_map != ''
    execute "vnoremap <buffer>" g:vim_isort_map s:available_short_python "isort_visual()<CR>"
endif

AvailablePython <<EOF
from __future__ import print_function
import vim
from sys import version_info

try:
    from isort import SortImports
    isort_imported = True
except ImportError:
    isort_imported = False


# in python2, the vim module uses utf-8 encoded strings
# in python3, it uses unicodes
# so we have to do different things in each case
using_bytes = version_info[0] == 2


def count_blank_lines_at_end(lines):
    blank_lines = 0
    for line in reversed(lines):
        if line.strip():
            break
        else:
            blank_lines += 1
    return blank_lines


def isort(text_range):
    if not isort_imported:
        print("No isort python module detected, you should install it. More info at https://github.com/fisadev/vim-isort")
        return

    blank_lines_at_end = count_blank_lines_at_end(text_range)

    old_text = '\n'.join(text_range)
    if using_bytes:
        old_text = old_text.decode('utf-8')

    new_text = SortImports(file_contents=old_text).output

    if using_bytes:
        new_text = new_text.encode('utf-8')

    new_lines = new_text.split('\n')

    # remove empty lines wrongfully added
    while new_lines and not new_lines[-1].strip() and blank_lines_at_end < count_blank_lines_at_end(new_lines):
        del new_lines[-1]

    text_range[:] = new_lines

def isort_file():
    isort(vim.current.buffer)

def isort_visual():
    isort(vim.current.range)

EOF
