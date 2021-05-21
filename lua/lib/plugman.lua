local log = require'lib.log'

local plugman = {}
local plugins = {}

local function require_packer()
    local execute = vim.api.nvim_command
    local fn = vim.fn

    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

    if fn.empty(fn.glob(install_path)) > 0 then
        execute('!git clone https://github.com/wbthomason/packer.nvim '..install_path)
    end

    execute 'packadd packer.nvim'
    return require'packer'
end
local packer = require_packer()

function plugman.use(plugin)
    if plugin[1] == vim.NIL or plugin[1] == nil then
        log.warning('Nil plugin name provided!')
        return
    end

    table.insert(plugins, plugin[1])

    packer.use(plugin)
end

function plugman.has_plugin(plugin)
  plugin = "/" .. plugin

  for _, v in pairs(plugins) do
    if type(v) == "string" then
      if vim.endswith(v, plugin) then return true end
      if vim.endswith(v, plugin .. ".git") then return true end
    elseif type(v) == "table" then
      if vim.endswith(v[1], plugin) then return true end
      if vim.endswith(v[1], plugin .. ".git") then return true end
    end
  end

  return false
end

local function err_handler(err)
    return {
        err = err,
        traceback = debug.traceback(),
    }
end

function plugman.init()
    packer.init({auto_reload_compiled = false})
    packer.reset()

    packer.use{'wbthomason/packer.nvim'}
end

function plugman.done()
end

return plugman
