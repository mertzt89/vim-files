local M = {}

---@class util.command
---@field command string
---@field desc? string
---@field fn? function(args: vim.api.keyset.create_user_command.command_args)
---@field subcommands? util.command[]
---@field opt? vim.api.keyset.user_command

local function _complete(command, args)
  vim.print("Completing command: " .. command.command .. " with args: " .. vim.inspect(args))

  -- Iterate through args and call _complete against matching subcommands
  if #args > 1 and command.subcommands then
    for _, subcommand in ipairs(command.subcommands) do
      vim.print("Checking subcommand: " .. subcommand.command .. " == " .. args[1])
      if subcommand.command == args[1] then
        table.remove(args, 1) -- Remove the matched subcommand from args
        return _complete(subcommand, args)
      end
    end
  elseif command.subcommands then
    return vim.tbl_map(function(subcommand)
      return subcommand.command
    end, command.subcommands)
  end
end

---@param command util.command
local function _create(command)
  local opt = command.opt or {}
  local nargs = opt.nargs

  if not nargs then
    nargs = command.subcommands and "*" or 0
  end

  local complete = opt.complete
    or function(cur_arg, args, _)
      local input = { table.unpack(Util.split(args), 2) }
      if cur_arg and cur_arg == "" then
        input = vim.list_extend(input, { cur_arg })
      end

      return _complete(command, input)
    end

  vim.print("Creating command: " .. command.command .. (command.desc and " - " .. command.desc or ""))
  vim.api.nvim_create_user_command(command.command, command.fn or function(_) end, {
    nargs = nargs,
    complete = complete,
  })
end

---@param commands util.command|util.command[]
function M.create(commands)
  if type(commands) ~= "table" then
    commands = { commands }
  end
  for _, command in ipairs(commands) do
    _create(command)
  end
end

return M
