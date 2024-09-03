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

return {
  -- Treesitter
  require("util.spec").ts_ensure_installed({ "c", "cpp" }),

  -- LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
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
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=none",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
    },
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
