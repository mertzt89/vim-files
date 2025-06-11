------------------------------------------------------------
-- Markdown language support
------------------------------------------------------------

------------------------------------------------------------
-- Treesitter
------------------------------------------------------------
return {
  -- Treesitter: Markdown support
  { "nvim-treesitter/nvim-treesitter", opts = {
    ensure_installed = {
      "markdown",
    },
  } },
}
