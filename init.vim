" =============================================================================
" # VIM-PLUG: Plugin Manager
" =============================================================================
" Initialize vim-plug. Plugins will be installed to ~/.vim/plugged
call plug#begin('~/.vim/plugged')

" Plugin list:
Plug 'ctrlpvim/ctrlp.vim'                    " Fuzzy file finder
Plug 'jiangmiao/auto-pairs'                 " Auto-close pairs (brackets, quotes)
Plug 'alvan/vim-closetag'                    " Auto-close HTML/XML tags
Plug 'tpope/vim-surround'                    " Easily add/change/delete surroundings
Plug 'airblade/vim-gitgutter'                " Show git diff in the sign column
Plug 'cocopon/iceberg.vim'
Plug 'preservim/vim-indent-guides'         " Indent guides
Plug 'nvim-lualine/lualine.nvim'

" End vim-plug initialization
call plug#end()

" =============================================================================
" # Plugin Settings
" =============================================================================
let g:indent_guides_enable_on_vim_startup = 1

" Set indent guides colors for the iceberg theme
let g:indent_guides_color_change_percent = 3
autocmd ColorScheme iceberg highlight IndentGuidesOdd  ctermbg=233
autocmd ColorScheme iceberg highlight IndentGuidesEven ctermbg=232

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|node_modules$\|target$',
  \ }

if executable('rg')
  set grepprg=rg\ --color=never\ --vimgrep
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
endif

nnoremap <leader>fu :CtrlP<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>r :CtrlPMRU<CR>

" =============================================================================
" # Basic Settings
" =============================================================================
" Set leader key to comma
let mapleader = ","

" Enable syntax highlighting
syntax on

" Show line numbers
set number

" Indentation settings:
"   tabstop: number of spaces a tab counts for
"   shiftwidth: number of spaces for autoindent
"   expandtab: convert tabs to spaces
set tabstop=4
set shiftwidth=4
set expandtab

set noswapfile

set cursorline

" Enable file type detection, plugins, and indenting
filetype plugin indent on

set updatetime=100

set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * GitGutterAll

" =============================================================================
" # Key Mappings
" =============================================================================
" Map j/k to gj/gk for line wrapping navigation
nnoremap <silent> j  gj
nnoremap <silent> k  gk

" Window navigation with Ctrl + H/J/K/L
nnoremap <C-j>      <C-w><C-j>
nnoremap <C-k>      <C-w><C-k>
nnoremap <C-h>      <C-w><C-h>
nnoremap <C-l>      <C-w><C-l>

" Buffer management:
"   <leader>n: new empty buffer
"   <leader>l: next buffer
"   <leader>h: previous buffer
"   <leader>q: close current buffer
nnoremap <leader>n  :enew<CR>
nnoremap <leader>l  :bnext<CR>
nnoremap <leader>h  :bprevious<CR>
nnoremap <leader>q  :bp <BAR> bd #<CR>

" System clipboard integration:
"   <leader>y: yank to system clipboard
"   <leader>p: paste from system clipboard
"   <leader>P: paste from system clipboard before cursor
nnoremap <leader>y  "+y
xnoremap <leader>y  "+y
nnoremap <leader>p  "+p
nnoremap <leader>P  "+P
xnoremap <leader>p  "+p
xnoremap <leader>P  "+P

" Clear search highlight on F2
nnoremap <silent> <F2> :nohls<CR>

" =============================================================================
" # Theme
" =============================================================================
colorscheme iceberg

" Set a truly black background
highlight Normal ctermbg=NONE guibg=black
highlight NonText ctermbg=NONE guibg=black

" =============================================================================
" # Lualine
" =============================================================================

lua << EOF
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
EOF
