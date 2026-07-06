" =============================================================================
" # VIM-PLUG: Plugin Manager
" =============================================================================
" Initialize vim-plug. Plugins will be installed to ~/.vim/plugged
call plug#begin('~/.vim/plugged')

" Plugin list:
Plug 'ctrlpvim/ctrlp.vim'             " Fuzzy file finder
Plug 'jiangmiao/auto-pairs'           " Auto-close pairs (brackets, quotes)
Plug 'alvan/vim-closetag'             " Auto-close HTML/XML tags
Plug 'tpope/vim-surround'             " Easily add/change/delete surroundings
Plug 'airblade/vim-gitgutter'         " Show git diff in the sign column
Plug 'cocopon/iceberg.vim'
Plug 'preservim/vim-indent-guides'    " Indent guides
Plug 'nvim-lualine/lualine.nvim'      " Status line

" LSP & Formatting Plugins
Plug 'neovim/nvim-lspconfig'         " Official LSP configurations
Plug 'hrsh7th/nvim-cmp'              " The completion engine framework
Plug 'hrsh7th/cmp-nvim-lsp'          " Integrates LSP with the completion engine

" End vim-plug initialization
call plug#end()

" =============================================================================
" # Plugin Settings
" =============================================================================
let g:indent_guides_enable_on_vim_startup = 1
" Set indent guides colors for the iceberg theme
let g:indent_guides_color_change_percent = 3
autocmd ColorScheme iceberg highlight IndentGuidesOdd ctermbg=233
autocmd ColorScheme iceberg highlight IndentGuidesEven ctermbg=232

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_extensions = ['buffer', 'mru']
let g:ctrlp_show_prompt = 1
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
let g:ctrlp_custom_ignore = {
  \ 'dir': '\.git$\|node_modules$\|target$',
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
" Set leader key to comma (Your leader is COMMA!)
let mapleader = ","

" Enable file type detection, plugins, and indenting BEFORE loading LSP
filetype plugin indent on
syntax on

" Show line numbers
set number
set colorcolumn=80

" Indentation settings:
set tabstop=4
set shiftwidth=4
set expandtab
set noswapfile
set cursorline
set updatetime=100
set autoread

autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * GitGutterAll

" =============================================================================
" # Key Mappings
" =============================================================================
" Map j/k to gj/gk for line wrapping navigation
nnoremap <silent> j gj
nnoremap <silent> k gk

" Window navigation with Ctrl + H/J/K/L
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-l> <C-w><C-l>

" Buffer management:
nnoremap <leader>n :enew<CR>
nnoremap <leader>l :bnext<CR>
nnoremap <leader>h :bprevious<CR>
nnoremap <leader>q :bp <BAR> bd #<CR>

" System clipboard integration:
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
xnoremap <leader>p "+p
xnoremap <leader>P "+P

" Seach options
set ignorecase
set smartcase

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
" # Lua Configuration (Lualine, LSP & Auto-Completion)
" =============================================================================
lua << EOF
-- 1. Setup Lualine
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = ' ', right = ' '},
    disabled_filetypes = { statusline = {'ctrlp'}, winbar = {}, },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = { statusline = 1000, tabline = 1000, winbar = 1000, }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 1}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }
}

-- 2. Setup LSP and Code Completion safely
-- Passing custom configuration settings to the ruff LSP client
vim.lsp.config('ruff', {
    init_options = {
        settings = {
            configuration = "~/.config/ruff/ruff.toml"
        }
    }
})


vim.lsp.enable('ruff')
vim.lsp.codelens.enable()
vim.lsp.inlay_hint.enable()

-- Global fallback mapping just in case (uses whatever leader is active)
vim.keymap.set('n', '<leader>f', function() 
vim.lsp.buf.format({ async = true }) 
end, { desc = 'Format Code' })
EOF
