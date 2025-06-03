local M = {}
local ensure = {}

function M.ensure(name)
  if not ensure[name] then
    table.insert(ensure, name)
  end
end

function M.get_ensure()
  return ensure
end

return M
