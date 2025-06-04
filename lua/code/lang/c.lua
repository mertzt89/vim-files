require("util.mason").ensure("clangd")
require("util.treesitter").ensure({ "c", "cpp" })

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

local function get_clangd_command()
  local config = defaults
  local cmd = config.command

  -- Append extra arguments
  cmd = vim.list_extend(cmd, config.extra_args)

  -- Auto detect query-driver for OE toolchains
  if config.detect_query_driver and vim.env.OECORE_NATIVE_SYSROOT ~= nil and vim.env.OECORE_TARGET_ARCH ~= nil then
    table.insert(cmd, "--query-driver=" .. vim.env.OECORE_NATIVE_SYSROOT .. "/**/" .. vim.env.OECORE_TARGET_ARCH .. "*")
  end

  return cmd
end

vim.lsp.config("lua_ls", {})
