set noexpandtab
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

" trigger Tabular automatically on :, but only when line looks like a legit
" hash
"inoremap <silent> : :<Esc>:call Align(':', '^\s\+[''"]\?[A-Za-z0-9_-]\+[''"]\?\s*:$')<CR>a

" dump current arg (in the future I should have this auto-prepend \ to hashes
" and arrays)
map ,D! viwoh"zy<F12>o<HOME>console.log('<ESC>"zpa:',<ESC>"zpa)<ESC>hh<F12>

" python style comments instead of the default C style
set commentstring=#\ %s
