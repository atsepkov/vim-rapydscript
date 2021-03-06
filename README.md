vim-rapydscript
===============

I do a lot of my development in RapydScript, I also do all of my development in vim. Out of the box, vim doesn't realize how similar RapydScript is to Python, and doesn't attempt to use any sort of indentation, syntax highlighting or other logic when working with RapydScript file. This plugin aims to fix that, and also make RapydScript compatible with some of the fancier vim logic I use. Feel free to use it for your own work.

If you want TagBar plugin to be compatible with RapydScript, find the line adding Python support, and add RapydScript right below it as follows:

	let s:known_types.python = type_python
	let s:known_types.rapydscript = type_python

I also recommend you check out https://github.com/atsepkov/vim-pydocstring repository that allows you to effortlessly create docstrings in Python and RapydScript (this is a fancier version of heaveshell's vim-pydocstring plugin)

Installation
============
If you want the easiest, laziest way to install this plugin, just get Vundle plugin and then add the following line to your .vimrc:

	Bundle "atsepkov/vim-rapydscript"

Then run `:BundleInstall` command in vim and it will automatically download this repo from github and set it up.

Otherwise, you can download this repo manually and unpack it inside your .vim directory and hope that you don't have anything else by the name 'rapydscript' in any of these directories, or it will get overwritten.

Note that to work properly with this bundle, vim needs to be told which file you'll be associating with RapydScript. The recommended file extension for RapydScript is .pyj, so you will need to add the following line to your .vimrc:

	au BufRead,BufNewFile *.pyj set filetype=rapydscript
