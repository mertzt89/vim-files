local log = require 'lib.log'

local plug = {}
plug.plugins = {}

local function require_packer()
  local execute = vim.api.nvim_command
  local fn = vim.fn

  local install_path = fn.stdpath('data') ..
                         '/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
              install_path)
  end

  execute 'packadd packer.nvim'
  return require 'packer'
end
local packer = require_packer()

function plug.use(plugin)
  if plugin[1] == vim.NIL or plugin[1] == nil then
    log.warning('Nil plugin name provided!')
    return
  end

  table.insert(plug.plugins, plugin[1])

  packer.use(plugin)
end

function plug.has_plugin(plugin)
  if _G.packer_plugins ~= nil then
    return _G.packer_plugins[plugin] ~= nil
  else
    return false
  end
end

function plug.register_plugins(use) use {'wbthomason/packer.nvim'} end

function plug.init() end

local function err_handler(err) return
  {err = err, traceback = debug.traceback()} end

function plug.startup(func) packer.startup(func) end

function plug.done() end

return plug
