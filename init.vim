" =============================================================================
" Neovim Configuration - Optimized for 4GB RAM, Django, Telescope
" Using ruff-lsp (via server name 'ruff'), with position encoding fix.
" =============================================================================

" Ensure vim-plug is installed for Neovim.
call plug#begin('~/.local/share/nvim/plugged')

" -- Appearance & UI --
Plug 'itchyny/lightline.vim'                 " Lighter statusline
Plug 'bluz71/vim-moonfly-colors'             " Moonfly color scheme
Plug 'lukas-reineke/indent-blankline.nvim'   " Efficient indent guides (v3)
" Plug 'nvim-tree/nvim-web-devicons'       " (Commented out as using plain text)
Plug 'onsails/lspkind.nvim'                  " Text kinds for LSP completion

" -- Editing Helpers --
Plug 'jiangmiao/auto-pairs'                 " Auto-close pairs
Plug 'alvan/vim-closetag'                    " Auto-close HTML/XML tags
Plug 'tpope/vim-surround'                    " Easily surround text

" -- Utility --
Plug 'tpope/vim-obsession'                   " Session management
Plug 'airblade/vim-gitgutter'                " Git diff in sign column
Plug 'ctrlpvim/ctrlp.vim'                    " Fuzzy file finder
Plug 'tpope/vim-fugitive'                    " Git wrapper

" -- Syntax Highlighting --
Plug 'lepture/vim-jinja'                     " Jinja2 syntax
Plug 'tweekmonster/django-plus.vim'          " Django specific niceties

" -- Language Server Protocol (LSP) & Autocompletion --
Plug 'neovim/nvim-lspconfig'                 " LSP configuration utility
Plug 'hrsh7th/nvim-cmp'                      " Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp'                  " LSP source for nvim-cmp
Plug 'hrsh7th/cmp-buffer'                    " Buffer source for nvim-cmp
Plug 'hrsh7th/cmp-path'                      " Path source for nvim-cmp
Plug 'hrsh7th/cmp-vsnip'                     " Snippet source for nvim-cmp
Plug 'hrsh7th/vim-vsnip'                     " Snippet engine

" -- Linting & Formatting --
Plug 'nvim-lua/plenary.nvim'                  " Prerequisite for none-ls/null-ls
                                             " Telescope
Plug 'nvimtools/none-ls.nvim'                " For other linters/formatters

" -- Fuzzy Finder & UI (Telescope) --
Plug 'nvim-telescope/telescope.nvim',            { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

call plug#end()

" =============================================================================
" General Settings
" =============================================================================
filetype plugin indent on
set autoindent
set smartindent

set noswapfile
set nobackup
set nowritebackup
set undofile
set undodir=~/.local/share/nvim/undodir
silent !mkdir -p ~/.local/share/nvim/undodir

set updatetime=300
set visualbell
set noerrorbells
set cmdheight=1
set shortmess+=c
set conceallevel=0
set signcolumn=yes

set termguicolors
set bg=dark
colorscheme moonfly

set number
set cursorline
set ruler
set colorcolumn=88
set linebreak
set scrolloff=5
set laststatus=2

set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

set ignorecase
set smartcase

let $LANG="en_US.UTF-8"
set langmenu=en_US.UTF-8
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,latin1

" =============================================================================
" Key Mappings
" =============================================================================
let mapleader = ","
let maplocalleader = "\\"

nnoremap <silent> j  gj
nnoremap <silent> k  gk

nnoremap <C-j>      <C-w><C-j>
nnoremap <C-k>      <C-w><C-k>
nnoremap <C-h>      <C-w><C-h>
nnoremap <C-l>      <C-w><C-l>

nnoremap <leader>n  :enew<CR>
nnoremap <leader>l  :bnext<CR>
nnoremap <leader>h  :bprevious<CR>
nnoremap <leader>q  :bp <BAR> bd #<CR>

nnoremap <leader>y  "+y
xnoremap <leader>y  "+y
nnoremap <leader>p  "+p
nnoremap <leader>P  "+P
xnoremap <leader>p  "+p
xnoremap <leader>P  "+P

nnoremap <silent> <F2> :nohls<CR>

nnoremap <silent> K          <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gd         <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD         <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gi         <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr         <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rn <cmd>lua vim.lsp.buf.rename()<CR>
" Use :lua instead of <cmd>lua for this one to fit, remove space in table
nnoremap <silent> <leader>e  :lua vim.diagnostic.open_float({scope='line'})<CR>
nnoremap <silent> [d         <cmd>lua vim.diagnostic.goto_prev({float=false})<CR>
nnoremap <silent> ]d         <cmd>lua vim.diagnostic.goto_next({float=false})<CR>
nnoremap          <leader>qf <cmd>lua vim.diagnostic.setqflist()<CR>

" General LSP formatting command.
" This will use the active LSP that supports formatting.
nnoremap          <leader>f  <cmd>lua vim.lsp.buf.format({async=true})<CR>

" =============================================================================
" Plugin Specific Settings (Vimscript)
" =============================================================================

" -------
" lightline
" -------
function! LightlineLspDiagnostics()
  if luaeval('not _G.vim or not _G.vim.diagnostic')
    return ''
  endif
  let errors_cmd = "select(2, pcall(_G.vim.diagnostic.get_count, 0, " .
        \ "_G.vim.diagnostic.severity.ERROR)) or 0"
  let warnings_cmd = "select(2, pcall(_G.vim.diagnostic.get_count, 0, " .
        \ "_G.vim.diagnostic.severity.WARN)) or 0"
  let info_cmd = "select(2, pcall(_G.vim.diagnostic.get_count, 0, " .
        \ "_G.vim.diagnostic.severity.INFO)) or 0"
  let hints_cmd = "select(2, pcall(_G.vim.diagnostic.get_count, 0, " .
        \ "_G.vim.diagnostic.severity.HINT)) or 0"

  let errors   = luaeval(errors_cmd)
  let warnings = luaeval(warnings_cmd)
  let info     = luaeval(info_cmd)
  let hints    = luaeval(hints_cmd)
  let components = []
  if errors > 0   | call add(components, 'E:' . errors)   | endif
  if warnings > 0 | call add(components, 'W:' . warnings) | endif
  if info > 0     | call add(components, 'I:' . info)     | endif
  if hints > 0    | call add(components, 'H:' . hints)    | endif
  if empty(components) | return '' | endif
  return '[' . join(components, ' ') . ']'
endfunction

let g:lightline = {
      \ 'colorscheme': 'moonfly',
      \ 'active': {
      \   'left': [
      \     [ 'mode', 'paste' ],
      \     [ 'gitbranch', 'readonly', 'filename', 'modified' ]
      \   ],
      \   'right': [
      \     [ 'diagnostics', 'lineinfo' ],
      \     [ 'percent' ],
      \     [ 'filetype', 'fileencoding', 'fileformat' ],
      \     [ 'obsession' ]
      \   ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head',
      \   'obsession': 'ObsessionStatus',
      \   'diagnostics': 'LightlineLspDiagnostics'
      \ },
      \ 'separator':    { 'left': '>', 'right': '<' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }
let g:obsession_status_format = '%s'

" -------
" ctrlp
" -------
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMRU'
let g:ctrlp_by_filename = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn|node_modules|bower_components|venv|' .
  \           '\.venv|\.ruff_cache|\.tox|dist|build|target|env|__pycache__)$',
  \ 'file': '\v\.(exe|so|dll|pyc|o|swp|lock|DS_Store)$',
  \ 'link': 'some_bad_symbolic_link',
  \ }
let g:ctrlp_working_path_mode = 'ra'

" =============================================================================
" Lua Configuration Block
" =============================================================================
lua << EOF

-- =======================================
-- Indent Blankline Setup (v3 Syntax)
-- =======================================
local ibl_ok, ibl = pcall(require, "ibl")
if not ibl_ok then
  vim.notify("indent-blankline (ibl) not found.", vim.log.levels.WARN)
else
  ibl.setup({
    indent  = { char = "|" },
    scope   = { enabled = true, show_start = true, show_end = true },
    exclude = {
      filetypes = {
        "help", "packer", "NvimTree", "dashboard", "lazy", "mason",
        "neo-tree", "TelescopePrompt", "alpha"
      },
      buftypes  = { "terminal", "nofile" },
    },
  })
end

-- =======================================
-- nvim-cmp Setup (Autocompletion)
-- =======================================
local cmp_ok, cmp = pcall(require, 'cmp')
if not cmp_ok then
  vim.notify("nvim-cmp not found.", vim.log.levels.ERROR)
else
  local lspkind_ok, lspkind = pcall(require, 'lspkind')
  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
      vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col):match("%s") == nil
  end
  cmp.setup({
    snippet = {
      expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>']     = cmp.mapping.scroll_docs(-4),
      ['<C-f>']     = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>']     = cmp.mapping.abort(),
      ['<CR>']      = cmp.mapping.confirm({ select = true }),
      ['<Tab>']     = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_next_item()
        elseif vim.fn["vsnip#available"](1) == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
            "<Plug>(vsnip-expand-or-jump)", true, true, true
          ), "")
        elseif has_words_before() then cmp.complete()
        else fallback() end
      end, { "i", "s" }),
      ['<S-Tab>']   = cmp.mapping(function(fallback)
        if cmp.visible() then cmp.select_prev_item()
        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
            "<Plug>(vsnip-jump-prev)", true, true, true
          ), "")
        else fallback() end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' }, { name = 'vsnip' },
      { name = 'buffer' },   { name = 'path' }
    }),
    formatting = {
      format = lspkind_ok and lspkind.cmp_format({
        mode          = 'text', -- Plain display
        maxwidth      = 50,
        ellipsis_char = '...'
      }) or nil,
    }
  })
end

-- =======================================
-- nvim-lspconfig Setup
-- =======================================
local lspconfig_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_ok then
  vim.notify("nvim-lspconfig not found.", vim.log.levels.ERROR)
else
  local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if cmp_nvim_lsp_ok then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  -- *** THIS IS THE FIX for position encoding mismatch ***
  -- Advertise support for utf-16 (preferred by Pyright) and utf-8.
  capabilities.offsetEncoding = {"utf-16"}

  local on_attach_common = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- LSP completion

    if client.server_capabilities.documentHighlightProvider then
      local augroup_name = "LspDocumentHighlight" .. bufnr
      local highlight_augroup = vim.api.nvim_create_augroup(
        augroup_name, { clear = true }
      )
      vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
        group    = highlight_augroup,
        buffer   = bufnr,
        callback = vim.lsp.buf.document_highlight
      })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group    = highlight_augroup,
        buffer   = bufnr,
        callback = vim.lsp.buf.clear_references
      })
    end
    if client.supports_method("textDocument/formatting") then
      local augroup_name = "LspFormatOnSave" .. bufnr
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup(augroup_name, {clear = true}),
        buffer   = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr, async = true })
        end
      })
      vim.notify(
        "LSP client " .. client.name ..
        " supports formatting. Format on save enabled for buffer " ..
        bufnr,
        vim.log.levels.INFO
      )
    end
  end

  lspconfig.pyright.setup({
    capabilities = capabilities, -- Pass shared capabilities
    on_attach    = on_attach_common,
    settings     = {
      python = {
        analysis = {
          autoSearchPaths        = true,
          diagnosticMode         = "workspace",
          useLibraryCodeForTypes = true,
          typeCheckingMode       = "off"
        }
      }
    }
  })

  local ruff_server_name = "ruff"
  if lspconfig[ruff_server_name] then
    lspconfig[ruff_server_name].setup({
      capabilities = capabilities,
      on_attach    = on_attach_common,
      init_options = { -- Optional
        positionEcoding = "utf-16"
      --   settings = {
      --     args = {},
      --   }
     }
    })
  else
    vim.notify(
      "LSP config for '" .. ruff_server_name ..
      "' not found in nvim-lspconfig. " ..
      "Ensure ruff-lsp is installed and nvim-lspconfig is up-to-date.",
      vim.log.levels.WARN
    )
  end

  lspconfig.html.setup({
    capabilities = capabilities, on_attach = on_attach_common
  })
  lspconfig.cssls.setup({
    capabilities = capabilities, on_attach = on_attach_common
  })
  lspconfig.jsonls.setup({
    capabilities = capabilities, on_attach = on_attach_common
  })

end

-- =======================================
-- none-ls (null-ls module) Setup - For any non-Ruff tools
-- =======================================
local null_ls_ok, null_ls_module = pcall(require, "null-ls")

if not null_ls_ok then
  vim.notify(
    "null-ls module (for none-ls.nvim) not found or failed to load: " ..
    tostring(null_ls_module),
    vim.log.levels.WARN
  )
else
  local B = null_ls_module.builtins
  local sources_list = {}

  -- Add any OTHER linters or formatters here if you use them with none-ls

  null_ls_module.setup({
    sources = sources_list,
    debug   = false,
  })
end

-- =======================================
-- Telescope Setup
-- =======================================
local telescope_ok, telescope = pcall(require, "telescope")
if not telescope_ok then
  vim.notify("Telescope not found.", vim.log.levels.ERROR)
else
  local actions_ok, actions = pcall(require, 'telescope.actions')
  local builtin_ok, builtin = pcall(require, 'telescope.builtin')
  if not (actions_ok and builtin_ok) then
    vim.notify(
      "Failed to load Telescope actions/builtin.", vim.log.levels.ERROR
    )
  else
    telescope.setup({
      defaults = {
        prompt_prefix          = "S: ",
        selection_caret        = "> ",
        path_display           = { "smart" },
        mappings               = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist +
                        actions.open_qflist,
            ["<esc>"] = actions.close,
            ["<CR>"]  = actions.select_default,
            ["<C-s>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
          },
          n = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-q>"] = actions.send_selected_to_qflist +
                        actions.open_qflist,
            ["<esc>"] = actions.close,
            ["q"]     = actions.close,
            ["s"]     = actions.select_horizontal,
            ["v"]     = actions.select_vertical,
            ["t"]     = actions.select_tab,
          },
        },
        file_ignore_patterns   = {
          "%.git/", "node_modules/", "__pycache__/", "%.pyc", "%.o", "%.so",
          "%.dll", "venv/", ".venv/", "env/", ".env/", "target/", "build/",
          "dist/", "%.lock", ".ruff_cache/", "%.DS_Store"
        },
        layout_strategy        = 'horizontal',
        layout_config          = {
          horizontal     = {
            prompt_position = 'top',
            preview_width   = 0.55,
            results_width   = 0.45
          },
          vertical       = { mirror = false },
          width          = 0.87,
          height         = 0.80,
          preview_cutoff = 120,
        },
        sorting_strategy       = "ascending",
        scroll_strategy        = "cycle",
      },
      pickers = {
        find_files = {
          theme = "dropdown", hidden = true, previewer = true
        },
        live_grep   = { theme = "dropdown", previewer = true },
        grep_string = { theme = "dropdown", previewer = true },
        buffers     = {
          theme                 = "dropdown",
          sort_mru              = true,
          ignore_current_buffer = true,
          previewer             = true
        },
        help_tags   = { theme = "dropdown", previewer = true },
        oldfiles    = { theme = "dropdown", cwd_only = false },
        lsp_document_symbols = {
          theme = "dropdown", previewer = true
        },
        lsp_workspace_symbols = {
          theme = "dropdown", previewer = true
        },
      },
      extensions = {
        fzf = {
          fuzzy                   = true,
          override_generic_sorter = true,
          override_file_sorter    = true,
          case_mode               = "smart_case",
        }
      }
    })
    pcall(telescope.load_extension, 'fzf')

    local map = vim.keymap.set
    map('n', '<leader>ff', builtin.find_files,
      { desc = '[F]ind [F]iles' })
    map('n', '<leader>fg', builtin.live_grep,
      { desc = '[F]ind by [G]rep (rg)' })
    map('n', '<leader>fb', builtin.buffers,
      { desc = '[F]ind [B]uffers' })
    map('n', '<leader>fh', builtin.help_tags,
      { desc = '[F]ind [H]elp tags' })
    map('n', '<leader>fo', builtin.oldfiles,
      { desc = '[F]ind [O]ld files (MRU)'})
    map('n', '<leader>fz', builtin.grep_string,
      { desc = '[F]ind by grep [Z]tring under cursor'})

    map('n', '<leader>ds', builtin.lsp_document_symbols,
      { desc = '[D]ocument [S]ymbols' })
    map('n', '<leader>ws', builtin.lsp_dynamic_workspace_symbols,
      { desc = '[W]orkspace [S]ymbols' })
    map('n', '<leader>lr', builtin.lsp_references,
      { desc = '[L]SP [R]eferences' })
    map('n', '<leader>li', builtin.lsp_implementations,
      { desc = '[L]SP [I]mplementations' })
    map('n', '<leader>ld', builtin.lsp_definitions,
      { desc = '[L]SP [D]efinitions (Telescope UI)'})
  end
end
EOF

" =============================================================================
" Autocommands for specific filetypes
" =============================================================================
augroup PythonSettings
    autocmd!
    autocmd FileType python,django,jinja setlocal shiftwidth=2 tabstop=2
          \ | setlocal softtabstop=2
    autocmd FileType python,django,jinja setlocal commentstring=#\ %s
augroup END

augroup HtmlDjangoSettings
    autocmd!
    autocmd FileType htmldjango,jinja setlocal commentstring={#\ %s\ #}
augroup END

" =============================================================================
" Auto-Install vim-plug if not found & install plugins
" =============================================================================
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        \ | echo "vim-plug installed. Plugins installed. Sourced init.vim."
endif

if !empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
      \ && empty(glob('~/.local/share/nvim/plugged/*'))
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
        \ | echo "Plugins installed. Sourced init.vim."
endif

" =============================================================================
" END OF CONFIGURATION
" =============================================================================
