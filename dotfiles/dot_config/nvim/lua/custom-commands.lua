-- Usage:
-- local commands = require('custom-commands')
-- commands.bind('SomeName', commands.some_command)

--------------- Helper code ---------------

local commands = {}

function commands.bind(name, command)
  vim.api.nvim_create_user_command(name, command.command, command.opts)
  return command
end

function commands.keymap(mode, lhs, cmd)
  vim.keymap.set(mode, lhs, cmd.command)
end

-- Register a one-shot hook for the commands.reload_nvim_config command
function commands.on_reload(func, ...)
  require("reload-hooks").add(func, ...)
end

-- I'm not sure if it's useful, but this can be used as
-- commands.some_command:bind('SomeName')
local function bind_method(self, name)
  commands.bind(name, self)
  return self
end

local function keymap_method(self, mode, keys)
  vim.keymap.set(mode, keys, self.command, { desc = self.opts.desc })
  return self
end

local function create_command(name, command, opts)
  commands[name] = {
    command = command,
    opts = opts,
    bind = bind_method,
    keymap = keymap_method
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

create_command('diagnostic_toggle', function ()
  if vim.diagnostic.config().virtual_lines then
    vim.diagnostic.config({virtual_text = true, virtual_lines = false})
  else
    vim.diagnostic.config({virtual_text = false, virtual_lines = true})
  end
end, { desc = 'Toggle diagnostic display mode'})

create_command('pp_comment_v_toggle', function()
  local vbegin = math.min(vim.fn.line('.'), vim.fn.line('v'))
  local vend = math.max(vim.fn.line('.'), vim.fn.line('v'))
  local cond = vim.api.nvim_buf_get_lines(0, vbegin - 2, vbegin - 1, false)[1]
  local fi = vim.api.nvim_buf_get_lines(0, vbegin - 2, vbegin - 1, false)[1]
  if cond == "#if 0" then
    vim.api.nvim_buf_set_lines(0, vbegin - 2, vbegin - 1, true, { "#if 1" })
  elseif cond == "#if 1" then
    vim.api.nvim_buf_set_lines(0, vbegin - 2, vbegin - 1, true, { "#if 0" })
  else
    vim.api.nvim_buf_set_lines(0, vend, vend, true, { "#endif" })
    vim.api.nvim_buf_set_lines(0, vbegin - 1, vbegin - 1, true, { "#if 0" })
  end
  -- exit v mode
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
end, { desc = 'Wrap visual block into preprocessor-style comment or toggle comment' })

create_command('pp_comment_n_toggle', function()
  local idx = vim.fn.line('.') - 1
  while idx >= 0 do
    local cond = vim.api.nvim_buf_get_lines(0, idx, idx + 1, true)[1]
    if cond == "#if 0" then
      vim.api.nvim_buf_set_lines(0, idx, idx + 1, true, { "#if 1" })
      return
    end
    if cond == "#if 1" then
      vim.api.nvim_buf_set_lines(0, idx, idx + 1, true, { "#if 0" })
      return
    end
    idx = idx - 1
  end
  vim.notify("Not inside comment block", vim.log.levels.ERROR)
end, { desc = 'Toggle surrounding preprocessor-style comment' })

create_command('pp_comment_n_delete', function()
  local function starts_with(s, prefix)
    return string.sub(s, 1, #prefix) == prefix
  end

  local function find_start()
    local idx = vim.fn.line('.') - 1
    local skip = 0
    while idx >= 0 do
      local line = vim.api.nvim_buf_get_lines(0, idx, idx + 1, true)[1]
      if (line == '#if 0' or line == '#if 1') and skip >= 0 then
        return idx, skip
      elseif starts_with(line, '#if') then
        skip = skip + 1
      elseif starts_with(line, '#endif') then
        skip = skip - 1
      end
      idx = idx - 1
    end
  end

  local function find_end(skip)
    local idx = vim.fn.line('.') - 1
    while idx >= 0 do
      local line = vim.api.nvim_buf_get_lines(0, idx, idx + 1, true)[1]
      if starts_with(line, '#endif') then
        if skip > 0 then
          skip = skip - 1
        else
          return idx
        end
      elseif starts_with(line, '#if') then
        skip = skip + 1
      end
      idx = idx + 1
    end
  end

  local cstart, skip = find_start()
  if cstart == nil then
    vim.notify("Not inside comment block (failed to find block start)", vim.log.levels.ERROR)
    return
  end
  local cend = find_end(skip)
  if cend == nil then
    vim.notify("Not inside comment block (failed to find block end)", vim.log.levels.ERROR)
    return
  end
  vim.api.nvim_buf_set_lines(0, cend, cend + 1, true, {})
  vim.api.nvim_buf_set_lines(0, cstart, cstart + 1, true, {})
end, { desc = 'Remove surrounding preprocessor-style comment' })


return commands
