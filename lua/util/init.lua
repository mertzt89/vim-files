local M = {}

function M.is_win()
  return vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
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

function M.setup()
  require("util.events").setup()
end

return M
