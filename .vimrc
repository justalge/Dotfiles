set nocompatible              " be iMproved, required
filetype off                  " required

"=====================================================
" Vundle settings
"=====================================================
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'		" let Vundle manage Vundle, required

"---------=== Colors ===-------------
Plugin 'jnurmine/Zenburn'
Plugin 'altercation/vim-colors-solarized'

"---------=== Code/project navigation ===-------------
Plugin 'scrooloose/nerdtree' 	    	" Project and file navigation
Plugin 'majutsushi/tagbar'          	" Class/module browser

"------------------=== Other ===----------------------
Plugin 'bling/vim-airline'   	    	" Lean & mean status/tabline for vim
Plugin 'fisadev/FixedTaskList.vim'  	" Pending tasks list
Plugin 'rosenfeld/conque-term'      	" Consoles as buffers
Plugin 'tpope/vim-surround'	   	" Parentheses, brackets, quotes, XML tags, and more

"--------------=== Snippets support ===---------------
Plugin 'garbas/vim-snipmate'		" Snippets manager
Plugin 'MarcWeber/vim-addon-mw-utils'	" dependencies #1
Plugin 'tomtom/tlib_vim'		" dependencies #2
Plugin 'honza/vim-snippets'		" snippets repo

"---------------=== Languages support ===-------------

" ---YouCompleteMe---
Plugin 'Valloric/YouCompleteMe'
let g:ycm_confirm_extra_conf = 0
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1,
      \ 'python': 1
      \}

" --- Python ---
Plugin 'klen/python-mode'	        " Python mode (docs, refactor, lints, highlighting, run and ipdb and more)
Plugin 'davidhalter/jedi-vim' 		" Jedi-vim autocomplete plugin
Plugin 'mitsuhiko/vim-jinja'		" Jinja support for vim
Plugin 'mitsuhiko/vim-python-combined'  " Combined Python 2/3 for Vim
Plugin 'szymonmaszke/vimpyter'		" View .ipynb files and start Jupyter Notebook by <leader>j

call vundle#end()            		" required
filetype on
filetype plugin on
filetype plugin indent on

"=====================================================
" General settings
"=====================================================

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","

set backspace=indent,eol,start
aunmenu Help.
aunmenu Window.
let no_buffers_menu=1
set mousemodel=popup

set ruler
set completeopt-=preview
set gcr=a:blinkon0
if has("gui_running")
  set cursorline
endif
set ttyfast

" Enable code highlighting
syntax on
if has("gui_running")
" GUI? set the colortheme and window size
  set lines=50 columns=125
  set background=dark
  colorscheme solarized
" uncomment the following lines if you want start NERDTree/TagBar when vim starts
" autocmd vimenter * TagbarToggle
" autocmd vimenter * NERDTree
" autocmd vimenter * if !argc() | NERDTree | endif

" wether vim on MAC?
if has("mac")
  set guifont=Consolas:h13
  set fuoptions=maxvert,maxhorz
else
" default GUI
  set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 10
endif
else
" wether vim in terminal?
  colorscheme zenburn
endif

tab sball
set switchbuf=useopen

" switch off squeaking and blinking
set visualbell t_vb=
set novisualbell

set enc=utf-8	     " use utf-8 as default encoding
set ls=2             " always show statusbar
set incsearch	     " incremental search
set hlsearch	     " highlight search
set nu	             " show line numbers
set scrolloff=5	     " 5 lines below and above cursor

" switch off backups and swap files
set nobackup 	     " no backup files
set nowritebackup    " only in case you don't want a backup file while editing
set noswapfile 	     " no swap files

" hide panels
"set guioptions-=m   " menu
set guioptions-=T    " toolbar
"set guioptions-=r   " scrollbars

" settings on Tab
set smarttab
set tabstop=8

" when there is more than 80 symbols printed in Ruby/Python/js/C/C++ highlight
augroup vimrc_autocmds
    autocmd!
    autocmd FileType ruby,python,javascript,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType ruby,python,javascript,c,cpp match Excess /\%80v.*/
    autocmd FileType ruby,python,javascript,c,cpp set nowrap
augroup END

" set directory with SnipMate settings
let g:snippets_dir = "~/.vim/vim-snippets/snippets"
let g:snipMate = { 'snippet_version' : 1 }


" Vim-Airline settings
set laststatus=2
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''


" TagBar settings
map <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 0 " disable autofocus when tagbar invoked

" NerdTree settings
" start NERDTree on F3
map <F3> :NERDTreeToggle<CR>
"ignore files with the following extensions
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']
"make NerdTree show dotfiles
let NERDTreeShowHidden=1

" TaskList settings
map <F2> :TaskList<CR> 	   " show task list on F2

"=====================================================
" Python-mode settings
"=====================================================
" switch off code autocomplete (we use jedi-vim and YouCompleteMe instead)
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0

" docs
let g:pymode_doc = 0
let g:pymode_doc_key = 'K'
" code checking
let g:pymode_lint = 1
"let g:pymode_lint_checker = 'pyflakes,pep8'

"let g:pymode_lint_ignore='E501,W601,C0110'
" check after saving
let g:pymode_lint_write = 1

" virtualenv support
let g:pymode_virtualenv = 1

" breakpoints
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_key = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" switch off code autofold
let g:pymode_folding = 0

" switch off code run (we use conque-term instead)
let g:pymode_run = 0

" Disable choose first function/method at autocomplete
let g:jedi#popup_select_first = 0

"=====================================================
" User hotkeys
"=====================================================
" ConqueTerm
" start interpreter on F5
nnoremap <F5> :ConqueTermSplit ipython<CR>
" start debug-mode on <F6>
nnoremap <F6> :exe "ConqueTermSplit ipython " . expand("%")<CR>
let g:ConqueTerm_StartMessages = 0
let g:ConqueTerm_CloseOnEnd = 0
" PEP8 code checking via 'p8'
autocmd FileType python map <buffer> p8 :PymodeLint<CR>

" autocomplete via <Ctrl+Space>
inoremap <C-space> <C-x><C-o>

" syntax switching
nnoremap <leader>Th :set ft=htmljinja<CR>
nnoremap <leader>Tp :set ft=python<CR>
nnoremap <leader>Tj :set ft=javascript<CR>
nnoremap <leader>Tc :set ft=css<CR>
nnoremap <leader>Td :set ft=django<CR>

"=====================================================
" Languages support
"=====================================================

" --- Python ---
"autocmd FileType python set completeopt-=preview " uncomment if you don't want jedi-vim show docs on method/class
autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8
\ formatoptions+=croq softtabstop=4 smartindent
\ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd FileType pyrex setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with

" --- JavaScript ---
let javascript_enable_domhtmlcss=1
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd BufNewFile,BufRead *.json setlocal ft=javascript

" --- HTML ---
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

" --- template language support (SGML / XML too) ---
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd bufnewfile,bufread *.rhtml setlocal ft=eruby
autocmd BufNewFile,BufRead *.mako setlocal ft=mako
autocmd BufNewFile,BufRead *.tmpl setlocal ft=htmljinja
autocmd BufNewFile,BufRead *.py_tmpl setlocal ft=python
let html_no_rendering=1
let g:closetag_default_xml=1
let g:sparkupNextMapping='<c-l>'
autocmd FileType html,htmldjango,htmljinja,eruby,mako let b:closetag_html_style=1
autocmd FileType html,xhtml,xml,htmldjango,htmljinja,eruby,mako source ~/.vim/scripts/closetag.vim

" --- CSS ---
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4






"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"changing split sizes
nnoremap <Up> <C-W><kMinus>
nnoremap <Down> <C-W><kPlus>
nnoremap <Right> <C-W>>
nnoremap <Left> <C-W><
nnoremap = <C-W>=
nnoremap _ <C-W>_
nnoremap <Bar> <C-W>\|

"mappings for buffers
" Move to the previous buffer with "gp"
nnoremap gp :bp<CR>
" Move to the next buffer with "gn"
nnoremap gn :bn<CR>
" List all possible buffers with "gl"
nnoremap gl :ls<CR>
" List all possible buffers with "gb" and accept a new buffer argument [1]
nnoremap gb :ls<CR>:b
" Close current buffer
nnoremap gq :bd!<CR>
" Close partiqular buffer
nnoremap gd :bd!

"mappings for switching tabs
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>

" vimpyter bindings
autocmd Filetype ipynb nmap <silent><Leader>c :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>

" copy/paste clipboard bindings
noremap <leader>y "+y
noremap <leader>p "+p
noremap <leader>d "+d
noremap <leader>dd "+dd
