"=============================================================================
" File:        syntax\PowerQueryM.vim
" Last Change: 27.01.2025
" Version:     0.0.2
"=============================================================================

if exists("b:current_syntax")
    finish
endif

let s:cpo_save = &cpo
set cpo&vim

" TODO: Is MPQ case-sensitive?
syntax case ignore

" Comments (section 12.1.2)
syn keyword mpq_comment_todo				contained TODO FIXME XXX DEBUG NOTE HACK
" syn match   mpq_Comment		"//.*$" contains=@mpq_Comment,mpq_comment_todo,@Spell
syn region  mpq_Comment	  start="//" skip="\\$" end="$" keepend contains=mpq_comment_todo,@Spell
syn region  mpq_Comment		start="/\*"  end="\*/" keepend contains=mpq_Comment,mpq_comment_todo,@Spell

" Literals (section 12.1.5)
" TODO: Match octal numbers. Hex numbers too?
syntax match	mpq_number "\d\+\.\d\+[eE][-+]\?\d\+"
syntax match	mpq_number     "\.\d\+[eE][-+]\?\d\+"
syntax match	mpq_number       "\d\+[eE][-+]\?\d\+"
syntax match	mpq_number                     "\d\+"
syntax region	mpq_string start=/"/hs=s+1 skip=/\\|\"/ end=/"/he=e-1

syn keyword mpq_Label			  LET IN
syn keyword mpq_conditional	IF THEN ELSE
syn keyword mpq_Constant		ERROR TRUE FALSE
syn keyword mpq_Exception	  TRY OTHERWISE

" Keywords (section 12.1.7)
syntax keyword  mpq_keywords	EACH AND AS IS META NOT OR SECTION SHARED TYPE
syntax keyword	mpq_Builtin #BINARY #DATE #DATETIME #DATETIMEZONE #DURATION
syntax keyword	mpq_Builtin #INFINITY #NAN #SECTIONS #SHARED #TABLE #TIME

" Operators (section 12.1.8)
syntax match	mpq_oper "[-,;=<>]"
syntax match	mpq_oper "<="
syntax match	mpq_oper ">="
syntax match	mpq_oper "<>"
syntax match	mpq_oper "[-+*]"
syntax match	mpq_oper "[^/]\zs\/\ze[^/]"   " Needs to differentiate from comment leader
syntax match	mpq_oper "[&()@?]"
syntax match	mpq_oper "[[\]{}]"
syntax match	mpq_oper "=>"
syntax match	mpq_oper "\.\{2,3\}"

" Lists (section 12.2.3.17)
syntax region	mpq_list start="{" end="}"	contains=ALL

" Records (section 12.2.3.18)
syntax region	mpq_record start="\[" end="\]"	contains=ALL

" Type expression (section 12.2.3.25)
" OBS: Using 'syntax keyword' does not work very well because 'list', 'record', and
"      possibly other keyswords overlaps with standard library objects like List and
"      Record. And 'syntax keyword' has a higher priority than 'syntax match'.
syntax match	mpq_ptype '\<\(any\|anynonnull\|binary\|date\|datetime\|datetimezone\|duration\|function\)\>'
syntax match	mpq_ptype '\<\(list\|logical\|none\|null\|number\|record\|table\|text\|type\)\>'

" Treat standard library objects and functions (File.Contents, List.First, List.Select, etc) as keywords.
" TODO: Match all library objects and functions.
syntax match	mpq_library  "Excel\.\w\+"
syntax match	mpq_library  "File\.\w\+"
syntax match	mpq_library  "List\.\w\+"
syntax match	mpq_library  "Record\.\w\+"
syntax match	mpq_library  "Replacer\.\w\+"
syntax match	mpq_library  "Table\.\w\+"
syntax match	mpq_library  "Text\.\w\+"

" {{{1 Catch errors caused by wrong parenthesis. Copied from awk.vim v. 2012-05-18.
" FIXME: Disabled for now since I do not understand what it is doing and if it is
"        applicable to MPQ.
if 0
  syntax region	mpq_paren	transparent start="(" end=")" contains=ALLBUT,mpq_paren_error,mpq_spec_char,mpq_list,mpt_record,mpq_comment_todo,mpq_regex,mpq_brackets,mpq_char_class
  syntax match	mpq_paren_error	display ")"
  syntax match	mpq_in_paren	display contained "[{}]"

  syntax region	mqp_brackets	contained start="\[\^\]\="ms=s+2 start="\[[^\^]"ms=s+1 end="\]"me=e-1 contains=mqp_brkt_regxxp,mqp_char_class

  syntax match	mqp_char_class	contained "\[:[^:\]]*:\]"
  syntax match	mqp_brkt_regex	contained "\\.\|.\-[^]]"
  syntax match	mqp_regex	contained "/\^"ms=s+1
  syntax match	mqp_regex	contained "\$/"me=e-1
  syntax match	mqp_regex	contained "[?.*{}|+]"
  syntax match	mpq_spec_char	contained '\.'
endif
" }}}1

hi def link mpq_comment_todo    Todo
hi def link mpq_Comment         Comment
hi def link mpq_string          Constant
hi def link mpq_number          Number
hi def link mpq_ident           Identifier
hi def link mpq_oper            Operator
hi def link mpq_keywords        Keyword
hi def link mpq_library         Keyword
hi def link mpq_ptype           Keyword
hi def link mpq_list            Structure
hi def link mpq_record          Structure
hi def link mpq_Label           Label
hi def link mpq_conditional     Conditional
hi def link mpq_Constant        Constant
hi def link mpq_Exception       Exception
hi def link mpq_Builtin         Function

let b:current_syntax = "powerquerym"

let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 et fdm=marker
