" Vim syntax file
" Language:	  RapydScript
" Maintainer: Alexander Tsepkov <atsepkov@pyjeon.com>
" Filenames:  *.pyj
"
" Based on:
"   python.vim by Ian McCracken <ian.mccracken@gmail.com>
"   python.vim by Dmitry Vasiliev <dima@hlabs.spb.ru>
"
" Includes support for:
"   * Highlighting of 'self' convention
"   * Separation of docstrings and other comments/strings
"   * Assignment
"   * Improved class/function highlighting, including arguments and base classes
"
"
" Options:
"
"    For set option do: let OPTION_NAME = 1
"    For clear option do: let OPTION_NAME = 0
"
" Option names:
"
"    For highlight builtin functions:
"       rapydscript_highlight_builtins
"
"    For highlight standard exceptions:
"       rapydscript_highlight_exceptions
"
"    For highlight string formatting:
"       rapydscript_highlight_string_formatting
"
"    For highlight str.format syntax:
"       rapydscript_highlight_string_format
"
"    For highlight string.Template syntax:
"       rapydscript_highlight_string_templates
"
"    For highlight indentation errors:
"       rapydscript_highlight_indent_errors
"
"    For highlight trailing spaces:
"       rapydscript_highlight_space_errors
"
"    For highlight doc-tests:
"       rapydscript_highlight_doctests
"
"    If you want all possible rapydscript highlighting:
"    (This option not override previously set options)
"       rapydscript_highlight_all
"
"    For fast machines:
"       rapydscript_slow_sync
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if exists("rapydscript_highlight_all") && rapydscript_highlight_all != 0
  " Not override previously set options
  if !exists("rapydscript_highlight_builtins")
    let rapydscript_highlight_builtins = 1
  endif
  if !exists("rapydscript_highlight_exceptions")
    let rapydscript_highlight_exceptions = 1
  endif
  if !exists("rapydscript_highlight_string_formatting")
    let rapydscript_highlight_string_formatting = 1
  endif
  if !exists("rapydscript_highlight_string_format")
    let rapydscript_highlight_string_format = 1
  endif
  if !exists("rapydscript_highlight_string_templates")
    let rapydscript_highlight_string_templates = 1
  endif
  if !exists("rapydscript_highlight_indent_errors")
    let rapydscript_highlight_indent_errors = 1
  endif
  if !exists("rapydscript_highlight_space_errors")
    let rapydscript_highlight_space_errors = 1
  endif
  if !exists("rapydscript_highlight_doctests")
    let rapydscript_highlight_doctests = 1
  endif
endif

" Keywords
syn keyword rapydscriptStatement	break continue del
syn keyword rapydscriptStatement	exec return new
syn keyword rapydscriptStatement	pass print raise
syn keyword rapydscriptStatement	global nonlocal assert
syn keyword rapydscriptStatement	yield

" Class definitions
syn region  rapydscriptClass start="^\s*class\>" end="\s*:" contains=rapydscriptClassDef,rapydscriptClassName,rapydscriptSuperclasses
syn keyword rapydscriptClassDef class contained nextgroup=rapydscriptClassName
syn match   rapydscriptClassName	"[a-zA-Z_$][a-zA-Z0-9_$]*" display contained nextgroup=rapydscriptSuperclasses skipwhite
syn region  rapydscriptSuperclasses start="("ms=s+1 end=")"me=e-1 keepend contained contains=rapydscriptSuperclass transparent
syn match   rapydscriptSuperclass "[a-zA-Z_$][a-zA-Z_0-9$]*" contained

" Function definitions
syn region  rapydscriptFunc start="\(^\|[^A-Za-z0-9_]\)def\>" end=")\s*:" keepend contains=rapydscriptFuncDef,rapydscriptFuncName,rapydscriptFuncParams
syn keyword rapydscriptFuncDef def contained nextgroup=rapydscriptFuncName skipwhite
syn match   rapydscriptFuncName	"[a-zA-Z_$][a-zA-Z0-9_$]*" display contained nextgroup=rapydscriptFuncParams skipwhite
syn region  rapydscriptFuncParams start="("ms=s+1 end=")"me=e-1 contained transparent contains=rapydscriptParam 
syn region   rapydscriptParam start="[a-zA-Z_$]" end="\(,\|)\s*:\)" contained contains=rapydscriptParamName,rapydscriptParamDefault,rapydscriptDefaultAssignment transparent nextgroup=rapydscriptParam
syn match rapydscriptParamName "[a-zA-Z_$][a-zA-Z0-9_$]*" contained nextgroup=rapydscriptDefaultAssignment skipwhite skipnl
syn match rapydscriptDefaultAssignment "=" nextgroup=rapydscriptParamDefault skipwhite contained skipnl

syn match rapydscriptParamDefault "=\@<=[^,]*" contained transparent contains=@rapydscriptStringType,@rapydscriptNumberType,@rapydscriptBuiltin,rapydscriptKeyword

syn keyword rapydscriptRepeat	for while
syn keyword rapydscriptConditional	if elif else
syn keyword rapydscriptPreCondit	import from as
syn keyword rapydscriptException	try except finally
syn keyword rapydscriptOperator	and in is not or to til

syn match rapydscriptAssignment "+=\|-=\|\*=\|/=\|//=\|%=\|&=\||=\|\^=\|>>=\|<<=\|\*\*="
syn match rapydscriptAssignment "="
syn match rapydscriptArithmetic "+\|-\|\*\|\*\*\|/\|//\|%\|<<\|>>\|&\||\|\^\|\~"
syn match rapydscriptComparison "<\|>\|<=\|>=\|==\|!="


" Decorators (not yet supported)
"syn match   rapydscriptDecorator	"@" display nextgroup=rapydscriptFunction skipwhite

" Comments
syn match   rapydscriptComment	"#.*$" display contains=rapydscriptTodo,@Spell
syn match   rapydscriptRun		"\%^#!.*$"
syn match   rapydscriptCoding	"\%^.*\(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
syn keyword rapydscriptTodo		TODO FIXME TEMP XXX contained

" Errors
syn match rapydscriptError		"\<\d\+[A-Za-z_]\+\>" display
"syn match rapydscriptError		"[$?]" display
syn match rapydscriptError		"[&|]\{2,}" display
syn match rapydscriptError		"[=]\{3,}" display

" TODO: Mixing spaces and tabs also may be used for pretty formatting multiline
" statements. For now I don't know how to work around this.
if exists("rapydscript_highlight_indent_errors") && rapydscript_highlight_indent_errors != 0
  syn match rapydscriptIndentError	"^\s*\( \t\|\t \)\s*\S"me=e-1 display
endif

" Trailing space errors
if exists("rapydscript_highlight_space_errors") && rapydscript_highlight_space_errors != 0
  syn match rapydscriptSpaceError	"\s\+$" display
endif


" Strings
syn region rapydscriptString		start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,@Spell
syn region rapydscriptString		start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,@Spell
syn region rapydscriptString		start=+"""+ end=+"""+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,rapydscriptDocTest2,rapydscriptSpaceError,@Spell
syn region rapydscriptString		start=+'''+ end=+'''+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,rapydscriptDocTest,rapydscriptSpaceError,@Spell

syn region rapydscriptDocstring  start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl contains=rapydscriptEscape,@Spell,rapydscriptDoctest,rapydscriptDocTest2,rapydscriptSpaceError
syn region rapydscriptDocstring  start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl contains=rapydscriptEscape,@Spell,rapydscriptDoctest,rapydscriptDocTest2,rapydscriptSpaceError

syn match  rapydscriptEscape		+\\[abfnrtv'"\\]+ display contained
syn match  rapydscriptEscape		"\\\o\o\=\o\=" display contained
syn match  rapydscriptEscapeError	"\\\o\{,2}[89]" display contained
syn match  rapydscriptEscape		"\\x\x\{2}" display contained
syn match  rapydscriptEscapeError	"\\x\x\=\X" display contained
syn match  rapydscriptEscape		"\\$"
syn match  rapydscriptEscape	    "\\u\x\{4}" display contained
syn match  rapydscriptEscapeError	"\\u\x\{,3}\X" display contained
syn match  rapydscriptEscape	    "\\U\x\{8}" display contained
syn match  rapydscriptEscapeError	"\\U\x\{,7}\X" display contained
syn match  rapydscriptEscape	    "\\N{[A-Z ]\+}" display contained
syn match  rapydscriptEscapeError	"\\N{[^A-Z ]\+}" display contained


" MAGIC functions
syn region rapydscriptMagicFunction		start=+JS('+ skip=+\\\\\|\\'\|\\$+ excludenl end=+')+ end=+$+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,@Spell
syn region rapydscriptMagicFunction		start=+JS("+ skip=+\\\\\|\\"\|\\$+ excludenl end=+")+ end=+$+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,@Spell
syn region rapydscriptMagicFunction		start=+JS("""+ end=+""")+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,rapydscriptDocTest2,rapydscriptSpaceError,@Spell
syn region rapydscriptMagicFunction		start=+JS('''+ end=+''')+ keepend contains=rapydscriptEscape,rapydscriptEscapeError,rapydscriptDocTest,rapydscriptSpaceError,@Spell


" Raw strings
syn region rapydscriptRawString	start=+r'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=rapydscriptRawEscape,@Spell
syn region rapydscriptRawString	start=+r"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=rapydscriptRawEscape,@Spell
syn region rapydscriptRawString	start=+r"""+ end=+"""+ keepend contains=rapydscriptDocTest2,rapydscriptSpaceError,@Spell
syn region rapydscriptRawString	start=+r'''+ end=+'''+ keepend contains=rapydscriptDocTest,rapydscriptSpaceError,@Spell

syn match rapydscriptRawEscape	+\\['"]+ display transparent contained

syn match  rapydscriptUniRawEscape		"\([^\\]\(\\\\\)*\)\@<=\\u\x\{4}" display contained
syn match  rapydscriptUniRawEscapeError	"\([^\\]\(\\\\\)*\)\@<=\\u\x\{,3}\X" display contained

if exists("rapydscript_highlight_string_formatting") && rapydscript_highlight_string_formatting != 0
  " String formatting
  syn match rapydscriptStrFormatting	"%\(([^)]\+)\)\=[-#0 +]*\d*\(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=rapydscriptString,rapydscriptRawString
  syn match rapydscriptStrFormatting	"%[-#0 +]*\(\*\|\d\+\)\=\(\.\(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=rapydscriptString,rapydscriptRawString
endif

if exists("rapydscript_highlight_string_format") && rapydscript_highlight_string_format != 0
  " str.format syntax
  syn match rapydscriptStrFormat "{{\|}}" contained containedin=rapydscriptString,rapydscriptRawString
  syn match rapydscriptStrFormat	"{\([a-zA-Z_][a-zA-Z0-9_]*\|\d\+\)\(\.[a-zA-Z_][a-zA-Z0-9_]*\|\[\(\d\+\|[^!:\}]\+\)\]\)*\(![rs]\)\=\(:\({\([a-zA-Z_][a-zA-Z0-9_]*\|\d\+\)}\|\([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*\(\.\d\+\)\=[bcdeEfFgGnoxX%]\=\)\=\)\=}" contained containedin=rapydscriptString,rapydscriptRawString
endif

if exists("rapydscript_highlight_string_templates") && rapydscript_highlight_string_templates != 0
  " String templates
  syn match rapydscriptStrTemplate	"\$\$" contained containedin=rapydscriptString,rapydscriptRawString
  syn match rapydscriptStrTemplate	"\${[a-zA-Z_$][a-zA-Z0-9_$]*}" contained containedin=rapydscriptString,rapydscriptRawString
  syn match rapydscriptStrTemplate	"\$[a-zA-Z_$][a-zA-Z0-9_$]*" contained containedin=rapydscriptString,rapydscriptRawString
endif

if exists("rapydscript_highlight_doctests") && rapydscript_highlight_doctests != 0
  " DocTests
  syn region rapydscriptDocTest	start="^\s*>>>" end=+'''+he=s-1 end="^\s*$" contained
  syn region rapydscriptDocTest2	start="^\s*>>>" end=+"""+he=s-1 end="^\s*$" contained
endif

" Numbers (ints, longs, floats, complex)
syn match   rapydscriptHexError	"\<0[xX]\x*[g-zG-Z]\x*[lL]\=\>" display

syn match   rapydscriptHexNumber	"\<0[xX]\x\+[lL]\=\>" display
syn match   rapydscriptOctNumber "\<0[oO]\o\+[lL]\=\>" display
syn match   rapydscriptBinNumber "\<0[bB][01]\+[lL]\=\>" display

syn match   rapydscriptNumber	"\<\d\+[lLjJ]\=\>" display

syn match   rapydscriptFloat		"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syn match   rapydscriptFloat		"\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syn match   rapydscriptFloat		"\<\d\+\.\d*\([eE][+-]\=\d\+\)\=[jJ]\=" display

syn match   rapydscriptOctError	"\<0[oO]\=\o*[8-9]\d*[lL]\=\>" display
syn match   rapydscriptBinError	"\<0[bB][01]*[2-9]\d*[lL]\=\>" display

if exists("rapydscript_highlight_builtins") && rapydscript_highlight_builtins != 0
  " Builtin functions, types and objects
  syn keyword rapydscriptBuiltinObj	True False None self this undefined true false
  syn keyword rapydscriptBuiltinObj	__debug__ __doc__ __file__ __name__ __package__

  syn keyword rapydscriptBuiltinModule	Math RegExp Image Error Array Object String Number
  syn keyword rapydscriptBuiltinModule	dict list

  syn keyword rapydscriptBuiltinFunc	__import__ abs all any apply
  syn keyword rapydscriptBuiltinFunc	basestring bin bool buffer bytearray bytes callable
  syn keyword rapydscriptBuiltinFunc	chr classmethod cmp coerce compile complex
  syn keyword rapydscriptBuiltinFunc	delattr dict dir divmod enumerate eval
  syn keyword rapydscriptBuiltinFunc	execfile file filter float format frozenset getattr
  syn keyword rapydscriptBuiltinFunc	globals hasattr hash help hex id 
  syn keyword rapydscriptBuiltinFunc	input int intern isinstance
  syn keyword rapydscriptBuiltinFunc	issubclass iter len list locals long map
  syn keyword rapydscriptBuiltinFunc	pow property range
  syn keyword rapydscriptBuiltinFunc	raw_input reduce reload repr
  syn keyword rapydscriptBuiltinFunc	reversed round set setattr
  syn keyword rapydscriptBuiltinFunc	slice sorted staticmethod str sum super tuple
  syn keyword rapydscriptBuiltinFunc	type unichr unicode vars xrange zip
endif

if exists("rapydscript_highlight_exceptions") && rapydscript_highlight_exceptions != 0
  " Builtin exceptions and warnings
  syn keyword rapydscriptExClass	BaseException
  syn keyword rapydscriptExClass	Exception StandardError ArithmeticError
  syn keyword rapydscriptExClass	LookupError EnvironmentError

  syn keyword rapydscriptExClass	AssertionError AttributeError BufferError EOFError
  syn keyword rapydscriptExClass	FloatingPointError GeneratorExit IOError
  syn keyword rapydscriptExClass	ImportError IndexError KeyError
  syn keyword rapydscriptExClass	KeyboardInterrupt MemoryError NameError
  syn keyword rapydscriptExClass	NotImplementedError OSError OverflowError
  syn keyword rapydscriptExClass	ReferenceError RuntimeError StopIteration
  syn keyword rapydscriptExClass	SyntaxError IndentationError TabError
  syn keyword rapydscriptExClass	SystemError SystemExit TypeError
  syn keyword rapydscriptExClass	UnboundLocalError UnicodeError
  syn keyword rapydscriptExClass	UnicodeEncodeError UnicodeDecodeError
  syn keyword rapydscriptExClass	UnicodeTranslateError ValueError VMSError
  syn keyword rapydscriptExClass	WindowsError ZeroDivisionError

  syn keyword rapydscriptExClass	Warning UserWarning BytesWarning DeprecationWarning
  syn keyword rapydscriptExClass	PendingDepricationWarning SyntaxWarning
  syn keyword rapydscriptExClass	RuntimeWarning FutureWarning
  syn keyword rapydscriptExClass	ImportWarning UnicodeWarning
endif

if exists("rapydscript_slow_sync") && rapydscript_slow_sync != 0
  syn sync minlines=2000
else
  " This is fast but code inside triple quoted strings screws it up. It
  " is impossible to fix because the only way to know if you are inside a
  " triple quoted string is to start from the beginning of the file.
  syn sync match rapydscriptSync grouphere NONE "):$"
  syn sync maxlines=200
endif

syn cluster rapydscriptStringType contains=rapydscriptString,rapydscriptRawString
syn cluster rapydscriptNumberType contains=rapydscriptNumber,rapydscriptHexNumber,rapydscriptFloat
syn cluster rapydscriptBuiltin    contains=rapydscriptBuiltinObj,rapydscriptBuiltinFunc

if version >= 508 || !exists("did_rapydscript_syn_inits")
  if version <= 508
    let did_rapydscript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink rapydscriptFuncDef     Statement
  HiLink rapydscriptFuncName    Entity
  HiLink rapydscriptParamName Test
  HiLink rapydscriptDefaultAssignment rapydscriptAssignment
  HiLink rapydscriptParamDefault Statement
  HiLink rapydscriptClassDef     Statement
  HiLink rapydscriptClassName    Entity
  HiLink rapydscriptSuperclass   Entity

  HiLink rapydscriptStatement	Statement
  HiLink rapydscriptPreCondit	Statement
  HiLink rapydscriptFunction		Function
  HiLink rapydscriptConditional	Conditional
  HiLink rapydscriptRepeat		Repeat
  HiLink rapydscriptException	Exception

  HiLink rapydscriptOperator		Operator
  HiLink rapydscriptAssignment	Operator
  HiLink rapydscriptComparison	Operator
  HiLink rapydscriptArithmetic   Operator

  HiLink rapydscriptDecorator	Define

  HiLink rapydscriptComment		Comment
  HiLink rapydscriptDocstring    Comment
  HiLink rapydscriptCoding		Special
  HiLink rapydscriptRun		Special
  HiLink rapydscriptTodo		Todo

  HiLink rapydscriptError		Error
  HiLink rapydscriptIndentError	Error
  HiLink rapydscriptSpaceError	Error

  HiLink rapydscriptString       String
  HiLink rapydscriptRawString    String
  HiLink rapydscriptMagicFunction PreProc

  HiLink rapydscriptEscape			Special
  HiLink rapydscriptEscapeError		Error
  HiLink rapydscriptUniEscape		Special
  HiLink rapydscriptUniEscapeError		Error
  HiLink rapydscriptUniRawEscape		Special
  HiLink rapydscriptUniRawEscapeError	Error

  HiLink rapydscriptStrFormatting	Special
  HiLink rapydscriptStrFormat	Special
  HiLink rapydscriptStrTemplate	    Special

  HiLink rapydscriptDocTest		Test
  HiLink rapydscriptDocTest2		Test

  HiLink rapydscriptNumber		Number
  HiLink rapydscriptHexNumber	Number
  HiLink rapydscriptOctNumber	Number
  HiLink rapydscriptBinNumber	Number
  HiLink rapydscriptFloat		Float
  HiLink rapydscriptOctError	    Error
  HiLink rapydscriptHexError		Error
  HiLink rapydscriptBinError		Error

  HiLink rapydscriptBuiltinObj   Number
  HiLink rapydscriptBuiltinModule	Module
  HiLink rapydscriptBuiltinFunc  Structure

  HiLink rapydscriptExClass	Structure

  delcommand HiLink
endif

let b:current_syntax = "rapydscript"
