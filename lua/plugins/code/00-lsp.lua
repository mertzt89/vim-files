------------------------------------------------------------
-- Language Server Protocol (LSP) Plugins
------------------------------------------------------------

---@param pkg_name string
local function _mason_ensure_server(pkg_name)
  if not pkg_name or type(pkg_name) ~= "string" then
    vim.notify("Invalid package name '" .. tostring(pkg_name) .. "'", vim.log.levels.ERROR)
    return
  end

  local pkg = require("mason-registry").get_package(pkg_name)
  if not pkg then
    vim.notify("Package not found in Mason registry '" .. pkg_name .. "'", vim.log.levels.ERROR, { title = "Mason" })
    return
  end

  if not pkg:is_installed() then
    vim.notify("Installing package '" .. pkg_name .. "'", vim.log.levels.INFO, { title = "Mason" })
    pkg:install({}, function(install_success, err)
      if not install_success then
        vim.notify(
          "Failed to install package '" .. pkg_name .. "' - " .. tostring(err),
          vim.log.levels.ERROR,
          { title = "Mason" }
        )
        return
      end

      vim.notify("Package installed successfully '" .. pkg_name .. "'", vim.log.levels.INFO, { title = "Mason" })
    end)
  end
end

---@param pkgs string | string[]
local function mason_ensure(pkgs)
  local ensure = {}
  if type(pkgs) == "string" then
    ensure = { pkgs }
  elseif type(pkgs) == "table" then
    ensure = pkgs
  else
    vim.notify("Invalid type for ensure_installed, expected string or table", vim.log.levels.ERROR)
  end

  local registry = require("mason-registry")
  registry.refresh(function(success, reg)
    if not success then
      vim.notify("Failed to refresh Mason registry: " .. tostring(reg), vim.log.levels.ERROR, { title = "Mason" })
      return
    end

    for _, server in ipairs(ensure) do
      _mason_ensure_server(server)
    end
  end)
end

return {
  {
    "neovim/nvim-lspconfig",
  },
  {
    "williamboman/mason.nvim",
    opts = {
      -- Custom extension to ensure specific LSP servers are installed,
      -- config() will read the `ensure_installed` option and
      -- remove it from the options before passing them to Mason.
      ---@type string[]
      ensure_installed = {},
    },
    opts_extend = { "ensure_installed" },
    config = function(_, opts)
      local ensure = opts.ensure_installed or {}
      opts.ensure_installed = nil

      require("mason").setup(opts)

      mason_ensure(ensure)
    end,
  },
}
