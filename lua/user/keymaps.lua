-- Space as leader key
vim.g.mapleader = " "

-- Window Navigation
vim.keymap.set({ "n", "x", "o" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "x", "o" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "x", "o" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "x", "o" }, "<C-l>", "<C-w>l")

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer switching
vim.keymap.set("n", "<S-l>", "<cmd>bn<cr>")
vim.keymap.set("n", "<S-h>", "<cmd>bp<cr>")
vim.keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>")

-- Commands vim.keymap.set("n", "<leader>w", "<cmd>write<cr>")
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>")

-- Toggles
vim.keymap.set("n", "<leader>uf", ":set foldenable!<CR>", { silent = true }) -- Toggle Folding
vim.keymap.set("n", "<leader>un", ":set relativenumber!<CR>", { silent = true }) -- Toggle Relative Number

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- lazy
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- Next/Prev quickfix items
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- Terminal Mappings
local util = require("util")
local term = function()
  require("util.terminal")(nil, { cwd = require("util.root").get() })
end
vim.keymap.set("n", "<leader>ft", term, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<leader>fT", function()
  util.terminal()
end, { desc = "Terminal (cwd)" })
vim.keymap.set("n", "<c-/>", term, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<c-_>", term, { desc = "which_key_ignore" })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    -- Skip bindings for lazygit
    if vim.bo.filetype ~= "lazygit" then
      vim.keymap.set("t", "<c-h>", "<cmd>wincmd h<cr>", { buffer = true, desc = "go to left window" })
      vim.keymap.set("t", "<C-j>", "<cmd>wincmd j<cr>", { buffer = true, desc = "Go to lower window" })
      vim.keymap.set("t", "<C-k>", "<cmd>wincmd k<cr>", { buffer = true, desc = "Go to upper window" })
      vim.keymap.set("t", "<C-l>", "<cmd>wincmd l<cr>", { buffer = true, desc = "Go to right window" })
    end
  end,
})
