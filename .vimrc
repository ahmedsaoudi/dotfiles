set nocompatible 
filetype off

" used by vundle
" to re-enable vundle, uncomment bellow
" and replace Plug by Plugin in the list
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" Plugin 'VundleVim/Vundle.vim'
" v--- this needs to be moved at the end of the
" list of plugins below
" call vundle#end()

call plug#begin('~/.vim/plugged')

" ===============
" LIST OF PLUGINS
" ===============

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" handles (), {} and the likes
Plug 'jiangmiao/auto-pairs'

" handles html tags
Plug 'alvan/vim-closetag'
 
" surrounds text with '' and the likes
" using shortcuts
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
Plug 'psf/black'
Plug 'Valloric/YouCompleteMe'
 
" shows indentation levels
" (the vertical lines on the 
" left of the screen)
Plug 'yggdroot/indentline'
Plug 'tpope/vim-obsession'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'lepture/vim-jinja'

" needed to show git branch on airline
Plug 'tpope/vim-fugitive'

" THEMES
" ------
Plug 'cocopon/iceberg.vim'
Plug 'bcicen/vim-vice'

" PLUGINS I NO LONGER NEED
" ========================
" Plugin 'scrooloose/nerdTree'
" Plugin 'ervandew/supertab'
" Plugin 'bling/vim-bufferline'
" Plugin 'edsono/vim-matchit' (no longer available)
" Plugin 'vim-pandoc/vim-pandoc'
" Plugin 'jistr/vim-nerdtree-tabs'

call plug#end()

" ================
" GENERAL SETTINGS 
" ================

filetype plugin indent on

" Allows the use of smartcase in search and subtitutions
" To enforce case sensetivity use: set smartcase!
" IT'S IMPORTANT TO LEAVE IGNORECASE
" SO THAT SMARTCASE BEHAVES AS EXPOECTED
set ignorecase
set smartcase

set cursorline

" let maplocalleader = ","
let mapleader = ","

" Set color scheme to 'VICE'
colorscheme iceberg
" for some reason the maker of this theme decided to make light version the default one.
" this is here to fix that.
set bg=dark 

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

" Disable max width for text
set textwidth=88

" Shows text width column
set colorcolumn=88

" Set encoding to UTF-8
set fileencodings=utf-8
set fileencoding=utf-8
let &termencoding=&encoding
set encoding=utf-8
set termencoding=utf-8

" Show the ruler
set ruler

" no swap files
set noswapfile

"Update the swap file everytime a 1000 characters are typed ...
" set updatecount=1000

" ... or every 5000ms
set updatetime=500

" NO BELLS!!!
set visualbell

" Enable some indenting options
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2

" =============
" KEYS MAPPINGS
" =============

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

" opens a new buffer
nmap <leader>n :enew<CR>

" goes to next buffer
nmap <leader>l :bn<CR>

" goes to previous buffer
nmap <leader>h :bp<CR>

" closes current buffer and opens previous one
nmap <leader>q :bp <BAR> bd #<CR>

" formats HTML code
nmap <F7> <ESC>:w<ENTER>gg=G<C-o><C-o>zz

" --( python specific )------

map <F9> <ESC>:w<ENTER>:Black<CR>
map <F8> <ESC>:w<ENTER>:SyntasticCheck <ENTER>:lopen<C-j>

" Toggle NERDTree tabs 
" nmap <leader>t :NERDTreeTabsToggle<CR>

" --( youceompleteme )B---

map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
nnoremap <leader>k :YcmCompleter GoTo<CR>
nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

" ===============
" PLUGINS PARAMS
" ===============
"
" -------
" airline
" -------
" 
" adds '$' symbole whenever obsession is active
let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])

" So that airline symbols are correctly displayed
let g:airline_powerline_fonts=1

let g:airline#extensions#branch#enabled=1

" Show the current file full path
let g:airline_section_c = '%f'
let g:airline_theme = 'dark'

" Added this because airline doesn't show up
" until a new split is created
" source: airline faq
set laststatus=2
set fillchars+=stl:\ ,stlnc:\


" -----------------
" for youcompleteme
" -----------------

let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1             " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1        " Completion for programming language's keyword
let g:ycm_complete_in_comments = 1                " Completion in comments
let g:ycm_complete_in_strings = 1                 " Completion in string

" Closes preview window for YouCompleteMe
" let g:ycm_autoclose_preview_window_after_insertion = 1

" -------
"  ctrlp
" -------

" Always start CtrlP in Mixed (buffer + file) mode
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_by_filename = 1

" To add a background for the CtrlP result prompt
" hi cursorline cterm=none ctermbg=99 ctermfg=black 

" ---------
" syntastic
" ---------

" use the pylint checker
" pylint needs to be installed first:
" sudo apt install pylint
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_python_pylint_args = "--rcfile=" . $HOME . "/.pylintrc"

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0

" don't check on buffer save
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {'mode': 'passive'}

" syntastic suppress messages
let g:syntastic_quiet_messages = { 'regex': [ 
                                        \ "Unable to import \'django*",
                                        \ "No name 'parse' in module 'urllib'",
                                        \ "Unable to import 'urllib.parse'",
                                        \ "Unable to import 'chouf.models'",
                                        \ "No name 'models' in module 'chouf'",
                                        \]}

" =======
" GARBAGE 
" =======

" apparently, this is only needed for windows!!!!
" set diffexpr=MyDiff()
" function MyDiff()
" 	let opt = '-a --binary '
" 	if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
" 	if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
" 	let arg1 = v:fname_in
" 	if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
" 	let arg2 = v:fname_new
" 	if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
" 	let arg3 = v:fname_out
" 	if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
" 	let eq = ''
" 	if $VIMRUNTIME =~ ' '
" 		if &sh =~ '\<cmd'
" 			let cmd = '""' . $VIMRUNTIME . '\diff"'
" 			let eq = '"'
" 		else
" 			let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
" 		endif
" 	else
" 		let cmd = $VIMRUNTIME . '\diff'
" 	endif
" 	silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
" endfunction

