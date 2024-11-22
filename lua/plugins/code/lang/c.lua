local CONFIG_KEY = "lsp.clangd"

local defaults = {
  command = {
    "clangd",
    "--background-index",
    "--clang-tidy=false",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=none",
  },
  extra_args = {},
  detect_query_driver = true,
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function()
    -- User function to sort function prototypes, works for most
    -- cases, but the expression may need to be adjusted as less
    -- common cases are encountered.
    vim.api.nvim_buf_create_user_command(
      0,
      "SortPrototypes",
      [['<,'>sort /^\(\w\+\s\)\+\*\?/]],
      { desc = "Sort Prototypes", range = true }
    )
  end,
})

local function get_clangd_command()
  local config = require("neoconf").get(CONFIG_KEY, defaults)
  local cmd = config.command

  -- Append extra arguments
  cmd = vim.list_extend(cmd, config.extra_args)

  -- Auto detect query-driver for OE toolchains
  if config.detect_query_driver and vim.env.OECORE_NATIVE_SYSROOT ~= nil and vim.env.OECORE_TARGET_ARCH ~= nil then
    table.insert(cmd, "--query-driver=" .. vim.env.OECORE_NATIVE_SYSROOT .. "/**/" .. vim.env.OECORE_TARGET_ARCH .. "*")
  end

  return cmd
end

return {
  -- Treesitter
  require("util.spec").ts_ensure_installed({ "c", "cpp" }),

  -- Neoconf
  require("util.spec").neoconf_plugin({
    name = "Clangd",
    on_schema = function(schema)
      schema:import(CONFIG_KEY, defaults)
    end,
  }),

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.clangd = {
        keys = {
          { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        root_dir = function(fname)
          return require("lspconfig.util").root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
          )(fname) or require("lspconfig.util").root_pattern(
            ".clangd",
            "compile_commands.json",
            "compile_flags.txt"
          )(fname) or require("lspconfig.util").find_git_ancestor(fname)
        end,
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = get_clangd_command(),
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }
    end,
  },

  -- DAP
  require("util.spec").mason_ensure_installed("cpptools"),
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("dap.ext.vscode").load_launchjs(nil, { cppdbg = { "c", "cpp" } })
    end,
  },
}
