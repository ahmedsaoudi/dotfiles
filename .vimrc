set nocompatible 
filetype off
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" LIST OF PLUGINS
" ===============

Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" handles (), {} and the likes
Plugin 'jiangmiao/auto-pairs'

" handles html tags
Plugin 'alvan/vim-closetag'
 
" surrounds text with '' and the likes
" using shortcuts
Plugin 'tpope/vim-surround'
Plugin 'skammer/vim-css-color'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-syntastic/syntastic'
Plugin 'psf/black'
 
" shows indentation levels
" (the vertical lines on the 
" left of the screen)
Plugin 'yggdroot/indentline'
Plugin 'tpope/vim-obsession'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'lepture/vim-jinja'

" needed to show git branch on airline
Plugin 'tpope/vim-fugitive'

" THEMES
" ------
Plugin 'cocopon/iceberg.vim'
Plugin 'bcicen/vim-vice'

" PLUGINS I NO LONGER NEED
" ========================
" Plugin 'scrooloose/nerdTree'
" Plugin 'ervandew/supertab'
" Plugin 'bling/vim-bufferline'
" Plugin 'edsono/vim-matchit' (no longer available)
" Plugin 'Valloric/YouCompleteMe'
" Plugin 'vim-pandoc/vim-pandoc'
" Plugin 'jistr/vim-nerdtree-tabs'

call vundle#end()

filetype plugin indent on

set diffexpr=MyDiff()
function MyDiff()
	let opt = '-a --binary '
	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	let arg1 = v:fname_in
	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	let arg2 = v:fname_new
	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	let arg3 = v:fname_out
	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	let eq = ''
	if $VIMRUNTIME =~ ' '
		if &sh =~ '\<cmd'
			let cmd = '""' . $VIMRUNTIME . '\diff"'
			let eq = '"'
		else
			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
		endif
	else
		let cmd = $VIMRUNTIME . '\diff'
	endif
	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" Allows the use of smartcase in search and subtitutions
" To enforce case sensetivity use: set smartcase!
" set ignorecase
set smartcase

" let maplocalleader = ","
let mapleader = ","

" Set color scheme to 'VICE'
colorscheme iceberg

" 256 colors terminals
set t_Co=256

" Show line number
set number

" Set language to 'English'
let $LANG="en"

" Set menu's language to English
set langmenu=en

" Minimal number of screen lines to keep above and below the cursor
set scrolloff=3

" Breaks the line at a 'break-able' character
set linebreak

" The window that the mouse pointer is on is automatically activated.
" set mousef

" Hide the toolbar
" set guioptions-=T

" Disable max width for text
set textwidth=0

" Set encoding to UTF-8
set fileencodings=utf-8
set fileencoding=utf-8
let &termencoding=&encoding
set encoding=utf-8
set termencoding=utf-8

" Show the ruler
set ruler

" Added this because airline doesn't show up
" until a new split is created
" source: airline faq
set laststatus=2
set fillchars+=stl:\ ,stlnc:\

" So that airline symbols are correctly displayed
let g:airline_powerline_fonts=1

let g:airline#extensions#branch#enabled=1

" no swap files
set noswapfile

"Update the swap file everytime a 1000 characters are typed ...
" set updatecount=1000

" ... or every 5000ms
" set updatetime=5000

" NO BELLS!!!
set visualbell

"KEYS MAPPINGS
""""""""""""""

" convert j and k keys to gj and gk in normal mode
map j gj
map k gk

" make moving around splits (much) easier
map <C-j> <C-w><C-j>
map <C-k> <C-w><C-k>
map <C-h> <C-w><C-h>
map <C-l> <C-w><C-l>

" Use key <F11> to toggle 'full screen' mode on/off
" map <F11> <ESC>:call FullScreenMode()<Enter>

" use <F2> to deactivate search highlight
map <F2> <ESC>:nohls<ENTER>

""""""""""""""""

" Enable some indenting options
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2

" adds '$' symbole whenever obsession is active
let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])
"
" Closes preview window for YouCompleteMe
" let g:ycm_autoclose_preview_window_after_insertion = 1

" this section tries to improve buffer's usage
" hides a buffer instead of closing it
" set hidden

" opens a new buffer
nmap <leader>n :enew<CR>

" goes to next buffer
nmap <leader>l :bn<CR>

" goes to previous buffer
nmap <leader>h :bp<CR>

" closes current buffer and opens previous one
nmap <leader>q :bp <BAR> bd #<CR>

" Toggle NERDTree tabs 
" nmap <leader>t :NERDTreeTabsToggle<CR>

" for youcompleteme
"
" let g:ycm_autoclose_preview_window_after_completion=1
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <leader>k :YcmCompleter GoTo<CR>
" nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
" nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

" let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
" let g:ycm_use_ultisnips_completer = 1 " Default 1, just ensure
" let g:ycm_seed_identifiers_with_syntax = 1 " Completion for programming language's keyword
" let g:ycm_complete_in_comments = 1 " Completion in comments
" let g:ycm_complete_in_strings = 1 " Completion in string

" To add a background for the CtrlP result prompt
" hi cursorline cterm=none ctermbg=99 ctermfg=black 
set cursorline

" Always start CtrlP in Mixed (buffer + file) mode
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_by_filename = 1

" Show the current file full path
let g:airline_section_c = '%f'
let g:airline_theme = 'dark'


" syntastic suppress messages
let g:syntastic_quiet_messages = { 'regex': ['missing-docstring'] }

" for the black plugin
let g:black_virtualenv="~/virtualenvs/vim_black"
