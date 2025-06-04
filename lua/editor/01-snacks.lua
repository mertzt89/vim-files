local add = MiniDeps.add

--- @class LazygitOpts
--- @param opts? LazygitOpts
--- @return snacks.lazygit.Config
local function lazygit_config(opts)
  opts = opts or {}
  return {
    config = {
      os = {
        editPreset = "nvim-remote",
      },
    },
    cwd = opts.cwd,
  }
end

local function terminal()
  Snacks.terminal(nil, {
    win = {
      on_buf = function(_self)
        vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { buffer = true, desc = "Enter Normal Mode" })
        vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { buffer = true, desc = "Hide Terminal" })
        vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { buffer = true, desc = "which_key_ignore" })
        vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>", { buffer = true, desc = "go to left window" })
        vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { buffer = true, desc = "Go to lower window" })
        vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { buffer = true, desc = "Go to upper window" })
        vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { buffer = true, desc = "Go to right window" })
      end,
    },
  })
end

add({
  source = "folke/snacks.nvim",
})
-- priority = 1000,
-- lazy = false,
-- ---@type snacks.Config
require("snacks").setup({
  bigfile = { enabled = true },
  -- dashboard = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true }, -- Wrap notifications
    },
  },
})

vim.keymap.set("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })
-- vim.keymap.set("n",
--   )
vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>nh", function()
  Snacks.notifier.show_history()
end)

vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit(lazygit_config({ cwd = vim.fn.expand("%:p:h") }))
end, { desc = "Lazygit" })

vim.keymap.set("n", "<leader>gG", function()
  Snacks.lazygit(lazygit_config())
end, { desc = "Lazygit (cwd)" })

vim.keymap.set("n", "<leader>gb", function()
  Snacks.git.blame_line()
end, { desc = "Git Blame Line" })

vim.keymap.set("n", "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })

vim.keymap.set("n", "<leader>gf", function()
  Snacks.lazygit.log_file(lazygit_config())
end, { desc = "Lazygit Current File History" })

vim.keymap.set("n", "<leader>gl", function()
  Snacks.lazygit.log(lazygit_config({ cwd = vim.fn.expand("%:p:h") }))
end, { desc = "Lazygit Log" })

vim.keymap.set("n", "<leader>gL", function()
  Snacks.lazygit.log(lazygit_config())
end, { desc = "Lazygit Log (cwd)" })

vim.keymap.set("n", "<leader>cR", function()
  Snacks.rename.rename_file()
end, { desc = "Rename File" })

vim.keymap.set("n", "<c-/>", terminal, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<c-_>", terminal, { desc = "which_key_ignore" })

vim.keymap.set({ "n", "t" }, "]r", function()
  Snacks.words.jump(vim.v.count1)
end, { desc = "Next Reference" })

vim.keymap.set({ "n", "t" }, "[r", function()
  Snacks.words.jump(-vim.v.count1)
end, { desc = "Prev Reference" })

vim.keymap.set("n", "<leader>N", function()
  Snacks.win({
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6,
    height = 0.6,
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
  })
end, { desc = "Neovim News" })

-- Setup some globals for debugging (lazy-loaded)
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd -- Override print to use snacks for `:=` command

-- Create some toggle mappings
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
  :map("<leader>uc")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.inlay_hints():map("<leader>uh")
