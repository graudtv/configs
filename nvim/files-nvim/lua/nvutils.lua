-- Enabled/disable confirmation of package installations with vim.pack
local vim_pack_confirm = false;

function nvim_minimum_required(version)
  if vim.fn.has("nvim-" .. version) ~= 1 then
    error(string.format("Too old neovim. At least v%s required", version))
  end
end

function add_package(plugin)
  vim.pack.add({'https://github.com/' .. plugin}, {confirm = vim_pack_confirm})
end

function unload_package(pkg)
  package.loaded[pkg] = nil
end

function reload_package(pkg)
  package.loaded[pkg] = nil
  require(pkg)
end

-- Omit any table that has `enabled = false` property
function skip_disabled(config)
  if type(config) ~= "table" then
    return config
  end
  if config.enabled ~= nil and not config.enabled then
    return nil
  end
  local res = {}
  for k, v in pairs(config) do
    res[k] = skip_disabled(v)
  end
  res.enabled = nil
  return res
end
