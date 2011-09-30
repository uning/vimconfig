
"加载主要vimrc文件
so  ~/.vim/vimrc-common
"加载当前文件夹里vim配置


"set t_Co=256
"color mango

let g:author  = "Tingkun"
let g:email   = "tingkun@playcrab.com"
let g:company = "Playcrab Corp."

syntax on

" ctags
set tags+=~/.vim/systags

" encoding
"set encoding=utf-8
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-cn,euc-jp,euc-kr,latin1
set termencoding=utf-8
" set fileencoding of new file to utf-8
setglobal fenc=utf-8







"Settings{{
" <TAB> 自动转换为4个空格
"set smarttab
"set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" 不创建备份文件
set nobackup

" 搜索时边键入边搜索
set incsearch

" 不使用兼容vi的模式
"set nocompatible
" 设置backspace的工作方式
"set backspace=indent,eol,start   
set autoindent 

let mapleader=";"
" Open and close the NERD_tree.vim separately
nmap <F7> <ESC>:NERDTreeToggle<CR> 
"打开Tlist
nmap <F8> <ESC>:Tlist<CR> 
" 打开当前目录
nnoremap <leader>o :Explore<CR>
"快速打开文件
nnoremap <leader>f :FufFile<CR>
nnoremap <leader>b :FufBuffer<CR>

"快速切换split窗口 
nmap z <C-w><C-w>

"tag快速追踪
nmap tt <C-t>
nmap tg <C-]>


" 在新tab打开当前文件所在的目录
map nt :tabnew %:h<CR>
"tab窗口切换  
nmap <Space>  <Esc>:tabn<CR>

" 选中刚刚粘贴的行
nnoremap <leader>v V`]
" This is totally awesome - remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

" 调用php 检查当前文件的语法
map <F5> :call Execute_Script()<CR>


"js 设置
autocmd filetype javascript call Set_js_options()
function! Set_js_options()
	"执行脚本
	map <leader>e :!node %<cr>
	set makeprg="~/jsl -nologo -nofilelisting -nosummary -nocontext -conf ~/bin/jsl.conf -process %"
	set errorformat=%f(%l):\ %m
	if !exists('*JSsynCHK')
		function! JSsynCHK()
			ccl
			let winnum = winnr() " get current window number
			let linenum = line('.')
			let colnum = col('.')
			let cmd =  "%!jsl -nologo -nofilelisting -nosummary -nocontext -conf ~/bin/jsl.conf -stdin | sed 's/^/".substitute(bufname("%"), '/', '\\/', "g")."/g' >.vimerr; cat"
			"echo cmd
			silent execute cmd
			silent cf .vimerr
			cw 
			" open the error window if it contains error
			" return to the window with cursor set on the line of the first error (if any)
			execute winnum . "wincmd w"
			silent undo
			silent cf
			if 0 >= len(getqflist())
				w
				call cursor(linenum, colnum)
				"echo "no error"
			else
				echo "error" 
				"!cat  .vimerr 
			endif
		endfunction
	endif
	au!  BufWriteCmd  *.js    call JSsynCHK()

	"检查语法
	map <leader>c :call JSsynCHK()<CR>

endfunction
"autocmd BufNewFile,Bufread *.php call Set_php_options()
autocmd filetype php call Set_php_options()
function! Set_php_options()
	"au!  BufWriteCmd       call PHPsynCHK()
	au!  BufWriteCmd  *.php     call PHPsynCHK()
	au!  BufWriteCmd  *.inc     call PHPsynCHK()

	if !exists('*PHPsynCHK')
		function! PHPsynCHK()
			ccl
			let winnum = winnr() " get current window number
			let linenum = line('.')
			let colnum = col('.')
			let cmd =  "%!php -l -f /dev/stdin | sed 's/\\/dev\\/stdin/".substitute(bufname("%"), '/', '\\/', "g")."/g' >.vimerr; cat"
			"echo cmd
			silent execute cmd
			silent cf .vimerr
			cw 
			" open the error window if it contains error
			" return to the window with cursor set on the line of the first error (if any)
			execute winnum . "wincmd w"
			silent undo
			silent cf
			if 1 == len(getqflist())
				w
				call cursor(linenum, colnum)
				"echo "no error"
			else
				"echo "error" 
			endif
		endfunction
	endif
	"保存php文件前自动检查语法
	set keywordprg="help"
	map <leader>t :!phpunit %<cr>
	"执行单个单测
	map <leader>T [[f(b:!phpunit --filter <C-R><C-W> %<cr>

	set errorformat=%m\ in\ %f\ on\ line\ %l
	"检查语法
	map <leader>c :call PHPsynCHK()<CR>

	"执行php脚本
	map <leader>e :!php %<cr>

	"在原函数里执行单测
	map <leader>m :!phpunit --filter test<C-R><C-W> tests/unittest/%:t:rTest.php <cr>
	map tu :sp tests/unittest/%:t:rTest.php <cr>
	map tf [[f(b:!phpunit --filter test<C-R><C-W> tests/unittest/%:t:rTest.php <cr>
	map tr [[f(b:!phpunit  tests/unittest/%:t:rTest.php <cr>

	let g:AutoComplPop_Behavior = {}
	let g:AutoComplPop_Behavior['php'] = []
	call add(g:AutoComplPop_Behavior['php'], {
				\   'command'   : "\<C-x>\<C-o>", 
				\   'pattern'   : printf('\(->\|::\|\$\)\k\{%d,}$', 0),
				\   'repeat'    : 0,
				\})
endfunction
autocmd FileType javascript set omnifunc=javascrīptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP



function! Execute_Script()
	if &filetype == 'php'
		:w
		execute '!php %'
	elseif &filetype == 'python'
		:w
		execute '!python %'
	elseif &filetype == 'sh'
		:w
		execute '!bash -x %'
	endif
endfunction

" plframework
set tags+=/home/hotel/mywork/plframework/tags

" vimrc被修改时自动重新加载
autocmd! bufwritepost .vimrc source %
autocmd! bufwritepost myvimrc source %



" backspace in Visual mode deletes selection
vnoremap <BS> d
" CTRL-X is Cut
vnoremap <C-c> "+x
" CTRL-C is Copy
vnoremap <C-c> "+y
" CTRL-V is Paste
map <C-v> "+gP
cmap <C-v>	<C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.

exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" CTRL-Z is Undo; not in cmdline though
"noremap <C-Z> u
"inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
noremap <C-y> <C-R>
inoremap <C-y> <C-O><C-R>

" CTRL-A is Select all
noremap <C-a> gggH<C-O>G
inoremap <C-a> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-a> <C-C>gggH<C-O>G
onoremap <C-a> <C-C>gggH<C-O>G
snoremap <C-a> <C-C>gggH<C-O>G
xnoremap <C-a> <C-C>ggVG

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w
