return {
  require("util").opt_in("copilot", { import = "plugins.code.copilot" }),
  { import = "plugins.code.lang" },
  { import = "plugins.code.lsp" },
}
