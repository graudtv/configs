-- Usage:
-- local commands = require('custom-commands')
-- commands.bind('SomeName', commands.some_command)

--------------- Helper code ---------------

local commands = {}

function commands.bind(name, command)
  vim.api.nvim_create_user_command(name, command.command, command.opts)
end

-- Register a one-shot hook for the commands.reload_nvim_config command
function commands.on_reload(func, ...)
  require("reload-hooks").add(func, ...)
end

-- I'm not sure if it's useful, but this can be used as
-- commands.some_command:bind('SomeName')
local function rbind(self, name)
  commands.bind(name, self)
end

local function create_command(name, command, opts)
  commands[name] = {
    command = command,
    opts = opts,
    bind = rbind
  }
end

--------------- Definitions of commands ---------------

-- Display already existing tab symbols as 8 spaces
-- Expand newly entered tabs into 2 spaces
create_command('indent_with_spaces', function()
  vim.o.tabstop = 8
  vim.o.softtabstop = 2
  vim.o.shiftwidth = 2
  vim.o.expandtab = true
end, { desc = "Use 2-spaces indentation" })

-- Display tabs as 8 spaces
-- Pressing tab or shifting inserts tab symbol (not 8 spaces)
create_command('indent_with_tabs', function()
  vim.o.tabstop = 8
  vim.o.softtabstop = 8
  vim.o.shiftwidth = 8
  vim.o.expandtab = false
end, { desc = "Use tabs for indentation" })

-- Reload nvim config
create_command('reload_nvim_config', function()
  -- package.loaded['nvutils'] = nil
  -- package.loaded['custom-commands'] = nil
  require("reload-hooks").run()
  vim.cmd.source(vim.fn.expand('$MYVIMRC'))
end, { desc = 'Reload nvim config' })

-- Edit nvim config
create_command('edit_nvim_config', function()
  vim.cmd.edit(vim.fn.expand('$MYVIMRC'))
end, { desc = 'Edit nvim config' })

-- Create backup of the current file
create_command('create_current_file_backup', function()
  vim.cmd('write!', vim.fn.expand('%') .. '.orig')
end, { desc = 'Create backup of the current file (adds .orig suffix)' })

-- Trim trailing spaces from all lines
create_command('trim_trailing_spaces', function()
  vim.cmd("%s/\\s\\+$//e")
  vim.cmd.noh();
end, { desc = 'Trim trailing spaces from all lines'})

-- Source the current file or visual selection as vim/lua script
create_command('run_nvim_script', function(args)
  if vim.o.filetype == "" then
    vim.notify("Cannot run this script: 'filetype' is not set")
  elseif vim.o.filetype ~= "vim" and vim.o.filetype ~= "lua" then
    vim.notify("Cannot run this script: 'filetype' is neither 'vim' or 'lua'")
  else
    vim.cmd(("%s,%s" .. "source"):format(args.line1, args.line2))
  end
end, { desc = 'Run the current file or visual selection as vim/lua script', range = "%" })

-- Run chmod +x on the current file
create_command('chmod_x_self', function()
  vim.fn.system(("chmod +x '%s'"):format(vim.fn.expand('%')))
  vim.cmd.edit()
end, { desc = 'Run chmod +x on the current file' })

return commands
