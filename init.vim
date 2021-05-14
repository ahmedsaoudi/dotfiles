call plug#begin()

Plug 'neomake/neomake'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" handles (), {} and the likes
Plug 'jiangmiao/auto-pairs'

" handles html tags
Plug 'alvan/vim-closetag'
 
" surrounds text with '' and the likes
" using shortcuts
Plug 'tpope/vim-surround'
" Plug 'vim-syntastic/syntastic'
Plug 'psf/black'
" Plug 'Valloric/YouCompleteMe'

Plug 'mattn/emmet-vim', {'for': ['html', 'css']}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

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

" Plug 'cocopon/iceberg.vim'
Plug 'zacanger/angr.vim'

call plug#end()

filetype plugin indent on

" Allows the use of smartcase in search and subtitutions
" To enforce case sensetivity use: set smartcase!
" IT'S IMPORTANT TO LEAVE IGNORECASE
" SO THAT SMARTCASE BEHAVES AS EXPOECTED
set ignorecase
set smartcase


" let maplocalleader = ","
let mapleader = ","

" Set color scheme to 'VICE'
colorscheme angr

set cursorline
hi cursorline ctermbg=233

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
map <F8> <ESC>:w<ENTER>:Neomake<ENTER><C-j>

" Emmet
nmap ,, <C-y>,

" Toggle NERDTree tabs 
" nmap <leader>t :NERDTreeTabsToggle<CR>

" --( youceompleteme )B---

" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" nnoremap <leader>k :YcmCompleter GoTo<CR>
" nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
" nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

" ===============
" PLUGINS PARAMS
" ===============
"
" -------
" airline
" -------
" 
" adds '$' symbole whenever obsession is active
let g:airline_section_z = airline#section#create([
  \ '%{ObsessionStatus(''$'', '''')}', 
  \ 'windowswap',
  \ '%3p%% ', 
  \ 'linenr', 
  \ ':%v '
  \])

" So that airline symbols are correctly displayed
let g:airline_powerline_fonts=1

let g:airline#extensions#branch#enabled=1

" Show the current file full path
let g:airline_section_c = '%f'
" hides the encoding section
let g:airline_section_y = ''
let g:airline_theme = 'dark'

" Added this because airline doesn't show up
" until a new split is created
" source: airline faq
set laststatus=2
set fillchars+=stl:\ ,stlnc:\

" -------
" neomake
" -------
let g:neomake_open_list = 2
" let g:neomake_javascript_enabled_makers = ['eslint']

" -----------------
" for youcompleteme
" -----------------

" let g:ycm_autoclose_preview_window_after_completion=1
" let g:ycm_collect_identifiers_from_tags_files = 1 " Let YCM read tags from Ctags file
" let g:ycm_use_ultisnips_completer = 1             " Default 1, just ensure
" let g:ycm_seed_identifiers_with_syntax = 1        " Completion for programming language's keyword
" let g:ycm_complete_in_comments = 1                " Completion in comments
" let g:ycm_complete_in_strings = 1                 " Completion in string

" Closes preview window for YouCompleteMe
" let g:ycm_autoclose_preview_window_after_insertion = 1

" -------
"  ctrlp
" -------

" Always start CtrlP in Mixed (buffer + file) mode
let g:ctrlp_cmd = 'CtrlPBuffer'
let g:ctrlp_by_filename = 1
let g:ctrlp_custom_ignore = 'static_files'

" To add a background for the CtrlP result prompt
" hi cursorline cterm=none ctermbg=99 ctermfg=black 

" ---------
" syntastic
" ---------

" use the pylint checker
" pylint needs to be installed first:
" sudo apt install pylint
" let g:syntastic_python_checkers = ['pylint']
" let g:syntastic_python_pylint_args = "--rcfile=" . $HOME . "/.pylintrc"
" 
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" 
" " don't check on buffer save
" let g:syntastic_check_on_wq = 0
" let g:syntastic_mode_map = {'mode': 'passive'}
" 
" " syntastic suppress messages
" let g:syntastic_quiet_messages = { 'regex': [ 
"                                         \ "Unable to import \'django*",
"                                         \ "No name 'parse' in module 'urllib'",
"                                         \ "Unable to import 'urllib.parse'",
"                                         \ "Unable to import 'chouf.models'",
"                                         \ "No name 'models' in module 'chouf'",
"                                         \]}
"
"
"  TESING COC CONFIG
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" set signcolumn=no

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
