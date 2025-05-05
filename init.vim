" =============================================================================
" Neovim Configuration - init.vim
" Organized version of the user's simplified configuration.
"
" To use this file:
" 1. Save it as ~/.config/nvim/init.vim
" 2. Ensure you have vim-plug installed for Neovim.
"    See: https://github.com/junegunn/vim-plug#neovim
" 3. Open Neovim and run :PlugInstall to install plugins.
" =============================================================================

" Neovim defaults to nocompatible, no need to set it.
" filetype off is also handled by filetype plugin indent on below.

" =============================================================================
" Plugin Management (vim-plug)
" =============================================================================
" Ensure vim-plug is installed for Neovim.
" The path below is a common location for Neovim plugins.
call plug#begin('~/.local/share/nvim/plugged')

" -- Appearance & UI --
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline' " Shows indentation levels

" -- Editing Helpers --
Plug 'jiangmiao/auto-pairs' " Handles (), {} and the likes
Plug 'alvan/vim-closetag' " Handles html tags
Plug 'tpope/vim-surround' " Surrounds text with '' and the likes

" -- Utility --
Plug 'tpope/vim-obsession' " Session management
Plug 'airblade/vim-gitgutter' " Git integration in the sign column
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy file finder
Plug 'tpope/vim-fugitive' " Git wrapper (needed for airline branch display)

" -- Syntax Highlighting --
Plug 'lepture/vim-jinja' " Jinja2 syntax highlighting

" -- Themes --
Plug 'bluz71/vim-moonfly-colors' " Moonfly color scheme

call plug#end()

" =============================================================================
" General Settings
" =============================================================================

" -- Basic Behavior --
" Enable file type detection, plugin loading, and smart indenting.
filetype plugin indent on
" Disable swap files.
set noswapfile
" Update swap file (if enabled) or trigger events (like CursorHold) more frequently.
set updatetime=300 " Reduced for more responsive CursorHold events
" Disable the terminal bell, use visual bell instead.
set visualbell
set noerrorbells " Also disable error bells
" Set command height to 1 to save screen space.
set cmdheight=1
" Reduce clutter in the command line messages.
set shortmess+=c
" Set conceallevel to 0 to show concealed characters (e.g., in markdown).
set conceallevel=0

" -- Appearance --
" Enable true colors in the terminal if supported.
set termguicolors
" Set color scheme.
colorscheme moonfly
" Ensure dark background.
set bg=dark
" Enable 256 colors in the terminal (often overridden by termguicolors).
set t_Co=256
" Show line number.
set number
" Consider 'set relativenumber' for relative line numbers, useful for motions.
" set relativenumber
" set number relativenumber " Shows both current absolute and relative for others
" Highlight the current line.
set cursorline
" Show the cursor position in the status line.
set ruler
" Shows text width column
set colorcolumn=88

" -- Text Formatting & Indentation --
" Breaks the line at a 'break-able' character
set linebreak
" Disable text wrapping at a specific column.
" textwidth=88 was previously used, but linebreak handles wrapping.
" If you want hard wrapping at 88, uncomment textwidth.
" set textwidth=88
" Enable smart indentation, expand tabs to spaces, set tab/indent widths.
set smartindent
set expandtab
set shiftwidth=2
set tabstop=2

" -- Searching --
" Ignore case in searches by default.
" Use \C in search pattern to force case sensitivity.
set ignorecase
" Use smartcase to override ignorecase if the pattern contains uppercase characters.
set smartcase

" -- Scrolling --
" Keep at least 3 lines above and below the cursor when scrolling.
set scrolloff=3

" -- Language & Encoding --
" Set language to English for menus and messages.
let $LANG="en_US.UTF-8" " Use a more standard locale format
set langmenu=en_US.UTF-8
" Set encoding to UTF-8 for files and terminal.
set encoding=utf-8
set fileencodings=utf-8
" Neovim handles termencoding automatically based on encoding.
" let &termencoding=&encoding " This line is often not needed in modern Neovim
" set termencoding=utf-8 " This line is not needed in modern Neovim


" =============================================================================
" Key Mappings
" =============================================================================

" Set leader key to comma.
let mapleader = ","
" let maplocalleader = "," " Uncomment if you use local leader mappings

" -- Navigation --
" convert j and k keys to gj and gk in normal mode for logical line movement
map j gj
map k gk
" make moving around splits (much) easier
map <C-j> <C-w><C-j>
map <C-k> <C-w><C-k>
map <C-h> <C-w><C-h>
map <C-l> <C-w><C-l>

" -- Buffer Management --
" opens a new buffer
nmap <leader>n :enew<CR>
" goes to next buffer
nmap <leader>l :bn<CR>
" goes to previous buffer
nmap <leader>h :bp<CR>
" closes current buffer and opens previous one
nmap <leader>q :bp <BAR> bd #<CR>

" -- Clipboard --
" Use <leader>y to yank to the system clipboard (+)
" Yank operation to system clipboard (e.g., ,yw, ,yy)
nnoremap <leader>y "+y

" Visual Mode Mapping:
" Yank visual selection to system clipboard
xnoremap <leader>y "+y

" -- Search --
" use <F2> to deactivate search highlight
map <F2> <ESC>:nohls<ENTER>

" -- Formatting --
" formats HTML code (requires external formatter or plugin - removed in this version)
" nmap <F7> <ESC>:w<ENTER>gg=G<C-o><C-o>zz

" =============================================================================
" Plugin Specific Settings
" =============================================================================

" -------
" airline
" -------
" Adds '$' symbole whenever obsession is active
let g:airline_section_z = airline#section#create(['%{ObsessionStatus(''$'', '''')}', 'windowswap', '%3p%% ', 'linenr', ':%3v '])
" So that airline symbols are correctly displayed
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1
" Show the current file full path
let g:airline_section_c = '%f'
let g:airline_theme = 'moonfly' " Use 'moonfly' theme for airline
" Added this because airline doesn't show up
" until a new split is created
" source: airline faq
set laststatus=2
set fillchars+=stl:\ ,stlnc:\

" -------
" ctrlp
" -------
" Always start CtrlP in Mixed (buffer + file) mode
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_by_filename = 1
" To add a background for the CtrlP result prompt
" hi cursorline cterm=none ctermbg=99 ctermfg=black

" =============================================================================
" END OF CONFIGURATION
" =============================================================================
