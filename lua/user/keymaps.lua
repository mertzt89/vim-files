-- Space as leader key
vim.g.mapleader = " "

-- Window Navigation
vim.keymap.set({ "n", "x", "o" }, "<C-h>", "<C-w>h")
vim.keymap.set({ "n", "x", "o" }, "<C-j>", "<C-w>j")
vim.keymap.set({ "n", "x", "o" }, "<C-k>", "<C-w>k")
vim.keymap.set({ "n", "x", "o" }, "<C-l>", "<C-w>l")

-- Other window keybinds
vim.keymap.set("n", "<leader>wq", "<C-w>q", { desc = "Close window" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Buffer manipulation
vim.keymap.set("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bp<cr>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>buffer #<cr>", { desc = "Last Buffer" })
vim.keymap.set("n", "<leader>bo", '<cmd>%bdelete|edit #|bdelete #|normal`"<cr>', { desc = "Close Other Buffers" })

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

---@param at_root? boolean
local open_term = function(at_root)
  local cwd = at_root and require("util.dirs").root() or require("util.dirs").cwd()
  require("util.terminal")(nil, { cwd = cwd })
end
vim.keymap.set("n", "<leader>ft", open_term, { desc = "Terminal (pwd)" })
vim.keymap.set("n", "<leader>fT", function()
  open_term(true)
end, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<c-/>", open_term, { desc = "Terminal (pwd)" })
vim.keymap.set("n", "<c-_>", open_term, { desc = "which_key_ignore" })

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
vim.keymap.set("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.set("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
vim.keymap.set("t", "<esc>l", function()
  vim.notify("Clearing Scrollback", "info", { timeout = 500 })
  local current_scrollback = vim.o.scrollback
  vim.o.scrollback = 1
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-l>", true, false, true), "n")
  vim.o.scrollback = current_scrollback
end, { desc = "Clear Scrollback" })
