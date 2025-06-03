local M = {}

--- Convert lua module name to file path within config directory
local function resolve_module(path)
  local config_path = vim.fn.stdpath("config")
  if path:sub(1, 1) == "." then
    path = config_path .. path:sub(2)
  elseif path:sub(1, 1) ~= "/" then
    path = config_path .. "/lua/" .. path:gsub("%.", "/")
  end
  return path
end

--- Convert file path to lua module name
local function resolve_path(path)
  local config_path = vim.fn.stdpath("config")
  if path:sub(1, #config_path) == config_path then
    path = path:sub(#config_path + 1)
  end
  return path:gsub("/", "."):gsub("%.lua$", "")
end

local function foreach_lua_do(path, func)
  local files = vim.fn.readdir(path, [[v:val =~ '\.lua$']])
  for _, file in ipairs(files) do
    local full_path = path .. "/" .. file
    if vim.fn.isdirectory(full_path) == 0 then
      func(full_path)
    end
  end
end

--- Load lua modules contained within the provided module path.
--- Modules are loaded in lexicographical order.
function M.auto(module)
  foreach_lua_do(resolve_module(module), function(full_path)
    require(resolve_path(full_path))
  end)
end

return M
