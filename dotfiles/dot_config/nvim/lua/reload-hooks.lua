local hooks = {}

local function add(func, ...)
  if type(func) ~= "function" then
    error("failed to add a reload hook: not a function")
  end
  local args = { ... }
  table.insert(hooks, function () func(unpack(args)) end)
end

local function run()
  -- Clear the hook list because the callbacks may add new hooks
  local h = hooks
  hooks = {}
  for _, func in ipairs(h) do
    func()
  end
end

return {
  add = add,
  run = run,
}
