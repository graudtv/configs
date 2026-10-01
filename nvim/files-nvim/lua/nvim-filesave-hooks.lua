local augroup = vim.api.nvim_create_augroup(
  "nvim-filesave-hooks", { clear = true }
)

local function expand(pat)
  pat = pat:gsub('~', vim.env.HOME)
  pat = pat:gsub('%$([%w_]+))', function (envvar) return vim.env[envvar] end)
  return pat
end

local function add_hooks(hooks)
  for pat, cmd in pairs(hooks) do
    local callback
    if type(cmd) == "string" then
      -- TODO: handle errors
      -- TODO: optionally async
      callback = function() vim.fn.system(cmd) end
    elseif type(cmd) == "function" then
      callback = cmd
    else
      error("command is not a function or string")
    end

    pat = expand(pat)

    vim.api.nvim_clear_autocmds({
      event = 'BufWritePost',
      pattern = pat,
      group = augroup
    })
    vim.api.nvim_create_autocmd('BufWritePost', {
      pattern = pat,
      group = augroup,
      callback = callback
    })
  end
end

return {
  add_hooks = add_hooks
}
