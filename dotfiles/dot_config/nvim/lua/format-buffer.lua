local M = {}
local formatters = {}

local function get_active_visual_selection()
    local from = vim.fn.line("v")
    local to = vim.fn.line(".")
    if from <= to then
      return from, to
    else
      return to, from
    end
end

local function format_buf_with(formatter)
  local mode = vim.api.nvim_get_mode().mode
  local line = vim.api.nvim_win_get_cursor(0)[1]

  if mode == 'n' then
    vim.cmd("%!" .. formatter)
  else
    local from, to = get_active_visual_selection()
    vim.cmd(('%s,%s!%s'):format(from, to, formatter))
    vim.api.nvim_input("<Esc>")
  end
  -- find first non-space symbol
  local col = vim.fn.match(vim.fn.getline(line), '\\S')
  -- move the cursor somewhere nearby original position
  -- TODO: try to track the position more accurately
  vim.api.nvim_win_set_cursor(0, {line, col});
end

local function format_buf()
  local filetype = vim.bo.filetype
  if filetype == '' then
    vim.notify('Cannot format this file: filetype not specified', vim.log.levels.ERROR)
    return
  end
  local formatter = formatters[filetype]
  if formatter == nil then
    vim.notify('Cannot format this file: no formatter registered for this filetype', vim.log.levels.ERROR)
    return
  end
  format_buf_with(formatter)
end

function M.setup(config)
  formatters = config.formatters
  keymap = config.keymap or '<Plug>(format-buffer)'

  vim.keymap.set({'n', 'v'}, keymap, format_buf, {
    desc = 'format buffer with language-specific formatter'
  })

  if config.command then
    vim.api.nvim_create_user_command(config.command, format_buf, {
      range = '%',
      desc = 'format buffer with language-specific formatter'
    })
  end
end

return M
