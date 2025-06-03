local M = {}

--- Load lua modules contained within the provided module path.
--- Modules are loaded in lexicographical order.
function M.auto(module)
  local mod = require("util.module")
  local resolved = mod.resolve_module(module)
  mod.foreach_lua_do(resolved, function(full_path)
    require(mod.resolve_path(full_path))
  end)
end

return M
