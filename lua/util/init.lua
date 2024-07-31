local M = {}

function M.list_contains(list, element)
  if not list then
    return false
  end

  for _, e in pairs(list) do
    if e == element then
      return true
    end
  end

  return false
end

function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.fg(name)
  ---@type {foreground?:number}?
  ---@diagnostic disable-next-line: deprecated
  local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name }) or vim.api.nvim_get_hl_by_name(name, true)
  ---@diagnostic disable-next-line: undefined-field
  local fg = hl and (hl.fg or hl.foreground)
  return fg and { fg = string.format("#%06x", fg) } or nil
end

function M.lsp_on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf ---@type number
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.lsp_get_clients(opts)
  local ret = {} ---@type lsp.Client[]
  if vim.lsp.get_clients then
    ret = vim.lsp.get_clients(opts)
  else
    ---@diagnostic disable-next-line: deprecated
    ret = vim.lsp.get_active_clients(opts)
    if opts and opts.method then
      ---@param client lsp.Client
      ret = vim.tbl_filter(function(client)
        return client.supports_method(opts.method, { bufnr = opts.bufnr })
      end, ret)
    end
  end
  return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
end

function M.is_win()
  return vim.loop.os_uname().sysname:find("Windows") ~= nil
end

function M.nvim_config_path()
  return vim.env.MYVIMRC
end

function M.nvim_config_dir()
  local ret = vim.fs.dirname(M.nvim_config_path()) .. "/"
  return ret
end

function M.grep_operator(callback)
  local set_opfunc = vim.fn[vim.api.nvim_exec(
    [[
      func s:set_opfunc(val)
        let &opfunc = a:val
      endfunc
      echon get(function('s:set_opfunc'), 'name')
    ]],
    true
  )]

  return function()
    local op = function(t, ...)
      local regsave = vim.fn.getreg("@")
      local selsave = vim.o.selection
      local selvalid = true

      vim.o.selection = "inclusive"

      if t == "v" or t == "V" then
        vim.api.nvim_command('silent execute "normal! gvy"')
      elseif t == "line" then
        vim.api.nvim_command("silent execute \"normal! '[V']y\"")
      elseif t == "char" then
        vim.api.nvim_command('silent execute "normal! `[v`]y"')
      else
        selvalid = false
      end

      vim.o.selection = selsave
      if selvalid then
        local query = vim.fn.getreg("@")
        callback(query)
      end

      vim.fn.setreg("@", regsave)
    end

    set_opfunc(op)
    vim.api.nvim_feedkeys("g@", "n", false)
  end
end

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

function M.opt_in(key, spec)
  local enabled_file = M.nvim_config_dir() .. "/.enable-" .. key
  local file = io.open(enabled_file, "rb")
  if not file then
    return {}
  end

  return spec
end

-- LazyFile event support
-- From: https://github.com/LazyVim/LazyVim/blob/12818a6cb499456f4903c5d8e68af43753ebc869/lua/lazyvim/util/plugin.lua
M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

function M.lazy_file()
  -- This autocmd will only trigger when a file was loaded from the cmdline.
  -- It will render the file as quickly as possible.
  vim.api.nvim_create_autocmd("BufReadPost", {
    once = true,
    callback = function(event)
      -- Skip if we already entered vim
      if vim.v.vim_did_enter == 1 then
        return
      end

      -- Try to guess the filetype (may change later on during Neovim startup)
      local ft = vim.filetype.match({ buf = event.buf })
      if ft then
        -- Add treesitter highlights and fallback to syntax
        local lang = vim.treesitter.language.get_lang(ft)
        if not (lang and pcall(vim.treesitter.start, event.buf, lang)) then
          vim.bo[event.buf].syntax = ft
        end

        -- Trigger early redraw
        vim.cmd([[redraw]])
      end
    end,
  })

  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

function M.setup()
  M.lazy_file()
  require("util.root").setup()
end

return M
