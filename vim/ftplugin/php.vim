" Vim Compiler File
" Compiler:	php
" Maintainer:	Mikolaj Machowski <mikmach@wp.pl>
" Last Change:  2002-01-06 Stephen Thorne <stephen@mu.com.au>
   
if exists("current_compiler")
    finish
endif
let current_compiler = "php"

let s:cpo_save = &cpo
set cpo&vim


" Running :make will run php's lint filter over the currently
" opened file.
" your PHP cli (or cgi) executable may be different
set makeprg=php\ \-\l\ %\\\|\ grep\ '</b>\ on\ line\ <b>'

" Error format seems to change between versions, if this script
" doesn't seem to work, see if the format is incorrect
set errorformat=<b>%*[^<]</b>:\ \ %m\ in\ <b>%f</b>\ on\ line\ <b>%l</b><br\ />


let &cpo = s:cpo_save
unlet s:cpo_save

set runtimepath+=~/.vim/php_doc
set tags+=~/.vim/php_doc/doc/tags

autocmd BufNewFile,Bufread *.ros,*.inc,*.php set keywordprg="help"
