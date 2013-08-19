set expandtab
set tabstop=4
set softtabstop=4
set magic

" highlight modes
let rapydscript_highlight_builtins = 1

" jump to variable/function definition, also finds variables declared in groups (implicit tuples)
nnoremap ,d ?\(\(global\\|nonlocal\) (\{0,1\}[^=(]*.\\|def \)\><CR>

" jump to previous variable assignment (var= | var+= | var||= | etc)
nnoremap ,= ?\(\([ ]*,[ ]*$[a-z][a-z0-9]*[ ]*\)*)\)\{0,1\}\s*\([-+*/%.\|&x^]\\|\(\*\*\\|\|\|\\|>>\\|<<\)\)\{0,1\}=[^=]<CR>``0n<Right>

" comment/uncomment (already part of my main .vimrc)
"map ,# :s_^_#_<CR>:noh<CR>
"map ,* :s_#__<CR>:noh<CR>

set makeprg=echo\ 'Compiling\ %'\ &&\ rapydscript\ %\ &&\ echo\ 'Finished\ compiling'
