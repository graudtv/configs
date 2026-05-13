--require 'unrequire'
require 'nvutils'

nvim_minimum_required("0.12.0")

--------------- Useful functions/commands ---------------

local commands = require('custom-commands')
commands.bind("IndentWithSpaces", commands.indent_with_spaces)
commands.bind("IndentWithTabs", commands.indent_with_tabs)
commands.bind("Reload", commands.reload_nvim_config)
commands.bind("Edit", commands.edit_nvim_config)
commands.bind("Run", commands.run_nvim_script)
commands.bind("BackupFile", commands.create_current_file_backup)
commands.bind("TrimTrailingSpaces", commands.trim_trailing_spaces)
commands.bind("ChmodXSelf", commands.chmod_x_self)

on_reload = commands.on_reload
on_reload(reload_package, 'nvutils')
on_reload(reload_package, 'custom-commands')

-- Keybinding for the Run command
vim.keymap.set({'n', 'v'}, '<leader>r', ':Run<CR>', {
  desc = 'Run the current file or visual selection as vim/lua script' })

-- Like :e, but start at the directory of the current file
vim.keymap.set('n', '<leader>e', function()
  local dirname = vim.fn.expand('%:h') .. '/'
  vim.api.nvim_feedkeys(":e " .. dirname, 'n', true)
end, { desc = 'Like :e, but start at the directory of the current file' })

local augroup = vim.api.nvim_create_augroup("nvimrc", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "kitty",
  group = augroup,
  callback = function()
    vim.api.nvim_create_autocmd("BufWritePost", {
      buffer = 0,
      callback = function()
        vim.fn.system("kitten @ load-config")
      end,
    })
  end,
})

--------------- General settings ---------------
-- [ Display settings ]
vim.o.number = true          -- Show line numbers
vim.o.rnu = true             -- Relative line numbers. rnu + number => also
                             -- show index of the current line
vim.o.cursorline = true      -- Highlight the current line
vim.o.colorcolumn = '80'     -- Vertical ruler (highlight 80-th column)
vim.o.showmode = false       -- Don't show current mode (insert/replace/etc),
                             -- because airline plugin does this
vim.o.showcmd = true         -- Show 'count' when entering commands like 10gg
vim.o.helpheight = 80        -- Make :help window take the whole screen
vim.o.sidescroll = 1         -- Scroll long lines by one symbol
vim.o.sidescrolloff = 0      -- Start scrolling long lines at specified
                             -- offset (default value ensured)
-- [ Text wrapping settings ]
vim.o.wrap = false           -- Disable wrapping by default
vim.o.breakindent = true     -- Keep indentation when wrapping
vim.o.showbreak = ">>"       -- Prefix to be printed when wrapping lines
vim.o.linebreak = true       -- Wrap lines on word boundaries
-- [ Windows' settings ]
vim.o.splitbelow = true      -- Open new window below, not above
vim.o.splitright = true      -- Open new window to the right, not to the left
vim.o.winheight = 20         -- Use at least winheight rows for window
vim.o.winwidth = 84          -- Use at least winwidth columns for window
-- [ Search settings ]
vim.o.hlsearch = true        -- Highlight search results
vim.o.incsearch = false      -- Cursor behaves really odd under incremental,
                             -- disable it
vim.o.wrapscan = false       -- Wrapping makes it hard to follow the cursor
vim.o.ignorecase = true      -- More convenient search
vim.o.smartcase = true       --/
vim.o.tagcase = 'smart'      -- More convenient search for tags
-- [ Command-line completion settings ]
vim.o.wildmenu = true        -- Enable pop-up menu in command mode (useful
                             -- when entering filenames/options/etc)
vim.o.wildmode = 'longest,list'
                             -- Bash-like completion style for wildmenu
-- [ Indentation and formatting settings ]
vim.o.textwidth = 0          -- Do not break too long lines
vim.opt.formatoptions:remove('r')
                             -- Don't continue comment when pressing Enter
                             -- in insert mode within comment
vim.opt.formatoptions:remove('o')
                             -- Don't continue comment when pressing o/O
                             -- within comment
vim.o.autoindent = true      -- Automatically insert indents (when starting
                             -- a new line or similar)
vim.o.smartindent = true     --/
vim.cmd.IndentWithSpaces()   -- I prefer spaces over tabs
-- [ Keymap ]
vim.o.keymap = 'russian-jcukenwin'
                             -- Russian layout support
vim.o.iminsert = 0           -- Disable side-effects of the previous command
vim.o.imsearch = 0           --/
-- [ Reset weird nvim defaults ]
vim.o.guicursor = 'n-v-c-i:block'
vim.o.mouse = ''
-- [ Other settings ]
vim.o.backspace = 'indent,eol,start'
                             -- Enable backspace in insert mode
vim.o.hidden = true          -- Allow hidding modified buffer
vim.o.timeout = true         -- Enable timeouts
vim.o.timeoutlen = 1000      -- Timeout for key bindings (ms)
vim.o.ttimeoutlen = 50       -- Timeout for multi-character key codes (ms)
vim.o.modeline = true        -- Read mode line if there's such one in a file
vim.o.fixendofline = false   -- Don't add eol if file doesn't have it
vim.o.autoread = false       -- Do not reload file without consent
-- TODO: fix representation of tab names (tabline)

--------------- Plugins ---------------

config = skip_disabled {
  easymotion = { enabled = true },
  easyescape = { enabled = true },
  bufexplorer = { enabled = true },
  fzf = { enabled = true },
  colorschemes = {
    ['morhetz/gruvbox'] = { enabled = true },
    ['folke/tokyonight.nvim'] = { enabled = true },
    ['rebelot/kanagawa.nvim'] = { enabled = true },
    ['catppuccin/nvim'] = { enabled = true },
    ['navarasu/onedark.nvim'] = { enabled = true },
    ['sainnhe/gruvbox-material'] = {
      enabled = true,
      vars = { gruvbox_material_background = 'dark' },
    },
    ['sainnhe/everforest'] = {
      enabled = true,
      vars = { everforest_background = 'hard' },
    },
  },
  colorscheme = 'onedark',
}

-- easymotion -- quick movement within text
if config.easymotion then
  add_package('easymotion/vim-easymotion')
  vim.keymap.set('n', 'gs', '<plug>(easymotion-s)')
  vim.keymap.set('n', 'gl', '<plug>(easymotion-bd-jk)')
  vim.keymap.set('n', 'gw', '<plug>(easymotion-bd-w)')
  vim.keymap.set('n', 'ge', '<plug>(easymotion-bd-e)')
end

-- easyescape -- helps to get rid of undesired visual effects when using
-- 'fd'/'fj' or similar sequence to escape insert mode
if config.easyescape then
  add_package('zhou13/vim-easyescape')
  vim.g.easyescape_chars = { f = 1, j = 1 }
  vim.g.easyescape_timeout = 2000
  vim.keymap.set('c', 'fg', '<Esc>')
end

if config.bufexplorer then
  add_package('jlanzarotta/bufexplorer')
  vim.g.bufExplorerShowNoName = 1
end

-- fuzzy search for files, tags and more
if config.fzf then
  add_package('junegunn/fzf')
  add_package('junegunn/fzf.vim')
end

-- Colorschemes
for colorscheme, opts in pairs(config.colorschemes) do
  add_package(colorscheme)
  for var, value in pairs(config.colorschemes.vars or {}) do
    vim.g[var] = value
  end
end

-- vim.g.airline_theme = 'catppuccin'
require('onedark').setup({style = 'warmer'})

vim.cmd.colorscheme(config.colorscheme)


--[[
add_package('graudtv/picktheme.nvim')

local picktheme = require('picktheme')
picktheme.add('gruvbox')
picktheme.add('onedark')
picktheme.add{
  name = "onedark"
  variants = {"warm", "warmer", "dark", "darker"},
  setup = function(variant)
    require('onedark').setup({style = variant})
  end
}
--]]

-- Nerd Font icons for filetypes and other stuff
add_package('nvim-tree/nvim-web-devicons')

-- lualine - pretty and configurable statusline
add_package('nvim-lualine/lualine.nvim')
require('lualine').setup({
  options = {
    theme = 'onedark'
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {'%f'},
    lualine_x = {'encoding'},
    lualine_y = {'filetype', 'lsp_status'},
    lualine_z = {'%p%% %l/%L:%c'},
  },
})

-- Syntax highlighting for justfile-s
add_package('NoahTheDuke/vim-just')

add_package('neovim/nvim-lspconfig')
-- add_package('nvim-treesitter/nvim-treesitter')
add_package('tpope/vim-fugitive')
vim.keymap.set('n', '<leader>g', ':Git ')

add_package('nvim-lua/plenary.nvim')
add_package('nvim-telescope/telescope.nvim')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

-- LSP
vim.diagnostic.config({
  virtual_text = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "\u{f444}",
      [vim.diagnostic.severity.WARN] = "\u{f444}"
    }
  }
})
--vim.lsp.enable('clangd')
vim.o.signcolumn = 'yes'

vim.keymap.set('n', 'gd', vim.lsp.buf.declaration)

--------------- Raw custom bindings ---------------
-- Show next half-page of file
vim.keymap.set({'n', 'v'}, '<Space>', '<C-d>')
vim.keymap.set({'n', 'v'}, 'J', '<C-d>')
-- Show previous half-page of file
vim.keymap.set({'n', 'v'}, 'K', '<C-u>')
-- Show next line of file, don't move cursor
vim.keymap.set({'n', 'v'}, '<C-j>', '<C-e>')
-- Show previous line of file, don't move cursor
vim.keymap.set({'n', 'v'}, '<C-k>', '<C-y>')
-- On MacBook keyboard '`' key has different position from most of keyboards;
-- instead, '§' key is located where '`' is expected to be
vim.keymap.set('n', '§', '`')
-- Switch keyboard layout. Note that <C-^> has different meaning in normal mode
vim.keymap.set('i', '<C-l>', '<C-^>')
vim.keymap.set('n', '<C-l>', 'a<C-^><Esc>')

-- vim: filetype=lua
