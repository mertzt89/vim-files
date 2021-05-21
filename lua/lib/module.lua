-- module.lua
-- Configuration Modules
local log = require 'lib.log'
local plugman = require 'lib.plugman'

local module = {}
module.modules = {}

function module.add(name)
  table.insert(module.modules, {name = name, module = require(name)})
end

local function err_handler(err) return
  {err = err, traceback = debug.traceback()} end

function module.call_for_each(f, optional)
  for _, v in ipairs(module.modules) do
    if not optional and v.module[f] == nil then
      log.error("Fuction " .. f .. " does not exist!")

    elseif not optional or v.module[f] ~= nil then
      local ok, err = xpcall(v.module[f], err_handler)
      if not ok then
        log.error(" ")
        log.error("Error while loading layer " .. v.name .. " / " .. f)
        log.error(
          "================================================================================")
        log.error(err.err)
        log.error(" ")
        log.error("Traceback")
        log.error(
          "================================================================================")
        log.error(err.traceback)
        log.error(" ")
      end
    end
  end
end

function module.finish_add()
  plugman.init()
  module.call_for_each("register_plugins", true)
  plugman.done()
  module.call_for_each("init", false)
end

return module
