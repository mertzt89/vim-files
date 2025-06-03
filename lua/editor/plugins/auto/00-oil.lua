local add = MiniDeps.add

add({
  source = "stevearc/oil.nvim",
  depends = { "nvim-tree/nvim-web-devicons" }
})

require("oil").setup()

vim.keymap.set("n",
      "-",
      function()
        require("oil").open()
      end,
      { desc = "Oil", silent=true }
    )
