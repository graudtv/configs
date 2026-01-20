-- Enabled/disable confirmation of package installations with vim.pack
local vim_pack_confirm = false;

function nvim_minimum_required(version)
  if not vim.fn.has("nvim-" .. version) then
    error(string.format("Too old neovim. At least v%s required", version))
  end
end

function add_package(plugin)
  vim.pack.add({'https://github.com/' .. plugin}, {confirm = vim_pack_confirm})
end
