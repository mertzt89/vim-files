------------------------------------------------------------
-- C/C++ language support
------------------------------------------------------------

------------------------------------------------------------
-- LSP
------------------------------------------------------------
local function get_clangd_command()
  local cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy=false",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=none",
  }

  -- Auto detect query-driver for OE toolchains
  if vim.env.OECORE_NATIVE_SYSROOT ~= nil and vim.env.OECORE_TARGET_ARCH ~= nil then
    table.insert(cmd, "--query-driver=" .. vim.env.OECORE_NATIVE_SYSROOT .. "/**/" .. vim.env.OECORE_TARGET_ARCH .. "*")
  end

  return cmd
end

vim.lsp.config("clangd", {
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
  cmd = get_clangd_command(),
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
})

vim.lsp.enable("clangd")

------------------------------------------------------------
-- Autocommands
------------------------------------------------------------

-- Create command to sort function prototypes in C/C++ files
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
  -- Mason: Install clangd
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "clangd" },
    },
  },

  -- Treesitter: C/C++ support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = { "c", "cpp" },
  } },
}
