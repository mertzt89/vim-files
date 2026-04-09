------------------------------------------------------------
-- Plugin: Treesitter
------------------------------------------------------------

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "*" },
  callback = function(args)
    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft)

    if not vim.treesitter.language.add(lang) then
      local available = vim.g.ts_available
          or require("nvim-treesitter").get_available()
      if not vim.g.ts_available then
        vim.g.ts_available = available
      end
      if vim.tbl_contains(available, lang) then
        require("nvim-treesitter").install(lang)
      end
    end

    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(args.buf, lang)
      vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.wo[0][0].foldmethod = "expr"
    end
  end,
})

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- dependencies = {
    --   "nvim-treesitter/nvim-treesitter-textobjects",
    -- },
    event = "LazyFile",
    opts = {
      ensure_installed = {},
      highlight = {
        enable = true,
        disable = function(_, bufnr)
          return vim.api.nvim_buf_line_count(bufnr) > 50000
        end,
      },
      -- :help nvim-treesitter-textobjects-modules
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    opts_extend = { "ensure_installed" },
    config = function(_, opts)
      require("nvim-treesitter").setup({
        install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
      })

      -- Install the specified parsers
      require("nvim-treesitter").install(opts["ensure_installed"])
    end,
  },
}
