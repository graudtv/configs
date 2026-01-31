require 'nvutils'

nvim_minimum_required("0.12.0")

--------------- Useful functions/commands ---------------

-- Display already existing tab symbols as 8 spaces
-- Expand newly entered tabs into 2 spaces
vim.api.nvim_create_user_command('IndentWithSpaces', function()
  vim.o.tabstop = 8
  vim.o.softtabstop = 2
  vim.o.shiftwidth = 2
  vim.o.expandtab = true
end, {})

-- Display tabs as 8 spaces
-- Pressing tab or shifting inserts tab symbol (not 8 spaces)
vim.api.nvim_create_user_command('IndentWithTabs', function()
  vim.o.tabstop = 8
  vim.o.softtabstop = 8
  vim.o.shiftwidth = 8
  vim.o.expandtab = false
end, {})

-- Reload vim config
vim.api.nvim_create_user_command('Reload', function()
  vim.cmd.source(vim.fn.expand('$MYVIMRC'))
end, {})


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
-- TODO: fix representation of tab names (tabline)

--------------- Plugins ---------------

config = {
  easymotion = { enabled = true },
  easyescape = { enabled = true },
  bufexplorer = { enabled = true },
  colorscheme = 'onedark',
}

-- easymotion -- quick movement within text
if config.easymotion.enabled then
  add_package('easymotion/vim-easymotion')
  vim.keymap.set('n', 'gs', '<plug>(easymotion-s)')
  vim.keymap.set('n', 'gl', '<plug>(easymotion-bd-jk)')
  vim.keymap.set('n', 'gw', '<plug>(easymotion-bd-w)')
  vim.keymap.set('n', 'ge', '<plug>(easymotion-bd-e)')
end

-- easyescape -- helps to get rid of undesired visual effects when using
-- 'fd'/'fj' or similar sequence to escape insert mode
if config.easyescape.enabled then
  add_package('zhou13/vim-easyescape')
  vim.g.easyescape_chars = { f = 1, j = 1 }
  vim.g.easyescape_timeout = 2000
  vim.keymap.set('c', 'fg', '<Esc>')
end

if config.bufexplorer.enabled then
  add_package('jlanzarotta/bufexplorer')
  vim.g.bufExplorerShowNoName = 1
end

-- Colorschemes
add_package('morhetz/gruvbox')
add_package('folke/tokyonight.nvim')
add_package('rebelot/kanagawa.nvim')
add_package('catppuccin/nvim')
add_package('sainnhe/gruvbox-material')
add_package('navarasu/onedark.nvim')
add_package('sainnhe/everforest')

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

-- vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = "mix"
-- vim.g.airline_theme = 'catppuccin'
require('onedark').setup({style = 'warmer'})

vim.g.everforest_background = 'hard'

vim.cmd.colorscheme(config.colorscheme)

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
