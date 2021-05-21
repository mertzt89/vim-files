--- Function management
local fn = {}

fn._bound_funcs = {}

--- Makes a new command to call a Lua function
--
-- @tparam string cmd The command name
-- @tparam function func The function to call with args as func(arg_string)
-- @tparam[opt] int|string num_args see `:help :command-nargs`
function fn.make_vim_fn(vim_fn, lua_fn)
  num_args = num_args or 0

  local func_name = vim_fn

  local func_name_escaped = func_name
  -- Escape Lua things
  func_name_escaped = func_name_escaped:gsub("'", "\\'")
  func_name_escaped = func_name_escaped:gsub('"', '\\"')
  func_name_escaped = func_name_escaped:gsub("\\[", "\\[")
  func_name_escaped = func_name_escaped:gsub("\\]", "\\]")

  -- Escape VimScript things
  -- We only escape `<` - I couldn't be bothered to deal with how <lt>/<gt> have angle brackets in themselves
  -- And this works well-enough anyways
  func_name_escaped = func_name_escaped:gsub("<", "<lt>")

  fn._bound_funcs[func_name] = lua_fn
end

return fn

