------------------------------------------------------------
-- Plugin: Snacks
------------------------------------------------------------

--- @class LazygitOpts: snacks.lazygit.Config
--- @param opts? LazygitOpts
--- @return snacks.lazygit.Config
local function lazygit_config(opts)
  ---@type snacks.lazygit.Config
  ---@diagnostic disable-next-line: missing-fields
  local defaults = {
    config = {
      os = {
        editPreset = "nvim-remote",
      },
    },
  }

  return vim.tbl_deep_extend("force", defaults, opts or {})
end

local function terminal()
  Snacks.terminal(nil, {
    win = {
      on_buf = function(_)
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

local function pick(source, opts)
  local DEFAULT_OPTS = {
    ignored = true,
    exclude = require("util").ignore.get_exclude(),
    include = require("util").ignore.get_include(),
  }

  opts = opts or {}
  opts = vim.tbl_deep_extend("force", DEFAULT_OPTS, opts)

  Snacks.picker.pick(source, opts)
end

local function grep(opts)
  pick("grep", opts)
end

local function files(opts)
  pick("files", opts)
end

local function set_indent_hl()
  -- create custom HL groups for indent scope
  vim.api.nvim_set_hl(0, "MySnacksIndentScope", { link = "LineNr" })

  local indent = Util.color.adjust_brightness("MySnacksIndentScope", 0.6)
  if not indent then
    indent = { link = "MySnacksIndentScope" }
  end

  vim.api.nvim_set_hl(0, "MySnacksIndent", indent)
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = {},
    indent = {
      enabled = true,
      animate = {
        enabled = false,
      },
      indent = {
        hl = "MySnacksIndent",
      },
      scope = {
        hl = "MySnacksIndentScope",
      },
    },
    input = {
      enabled = true,
    },
    picker = {
      enabled = true,
    },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      ---@diagnostic disable-next-line: missing-fields
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
  },

  keys = {
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      { desc = "Dismiss All Notifications" },
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      { desc = "Delete Buffer" },
    },
    {
      "<leader>nh",
      function()
        Snacks.notifier.show_history()
      end,
    },
    {
      "<leader>gg",
      function()
        ---@diagnostic disable-next-line: missing-fields
        Snacks.lazygit(lazygit_config({ cwd = vim.fn.expand("%:p:h") }))
      end,
      { desc = "Lazygit" },
    },
    {
      "<leader>gG",
      function()
        Snacks.lazygit(lazygit_config())
      end,
      { desc = "Lazygit (cwd)" },
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      { desc = "Git Blame Line" },
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      { desc = "Git Browse" },
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      { desc = "Rename File" },
    },
    { "<c-/>", terminal, { desc = "Toggle Terminal" } },
    { "<c-_>", terminal, { desc = "which_key_ignore" } },
    {
      "]r",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      { desc = "Next Reference" },
    },
    {
      "[r",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      { desc = "Prev Reference" },
    },
    {
      "<leader>N",
      function()
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
      end,
      { desc = "Neovim News" },
    },

    -- Top Pickers & Explorer
    {
      "<leader><space>",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>,",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>/",
      function()
        grep()
      end,
      desc = "Grep",
    },
    {
      "gS",
      require("util").grep_operator(function(query)
        grep({ search = query, include = {}, exclude = {} })
      end),
      mode = { "n", "x" },
    },
    {
      "gs",
      require("util").grep_operator(function(query)
        grep({ search = query })
      end),
      mode = { "n", "x" },
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>np",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification History (Picker)",
    },
    {
      "<leader>e",
      function()
        ---@diagnostic disable-next-line: missing-fields
        pick("explorer")
      end,
      desc = "File Explorer",
    },
    {
      "<leader>E",
      function()
        ---@diagnostic disable-next-line: missing-fields
        pick("explorer", { include = {}, exclude = {} })
      end,
      desc = "File Explorer",
    },
    -- find
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>fc",
      function()
        files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
    {
      "<leader>ff",
      function()
        files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fF",
      function()
        files({ exclude = {}, include = {} })
      end,
      desc = "Find Files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Projects",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent",
    },
    -- git
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git Branches",
    },
    {
      "<leader>gl",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git Log",
    },
    {
      "<leader>gL",
      function()
        Snacks.picker.git_log_line()
      end,
      desc = "Git Log Line",
    },
    {
      "<leader>gs",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git Status",
    },
    {
      "<leader>gS",
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git Stash",
    },
    {
      "<leader>gd",
      function()
        Snacks.picker.git_diff()
      end,
      desc = "Git Diff (Hunks)",
    },
    {
      "<leader>gf",
      function()
        Snacks.picker.git_log_file()
      end,
      desc = "Git Log File",
    },
    -- Grep
    {
      "<leader>sb",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>sB",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>sg",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>sw",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
    -- search
    {
      '<leader>s"',
      function()
        Snacks.picker.registers()
      end,
      desc = "Registers",
    },
    {
      "<leader>s/",
      function()
        Snacks.picker.search_history()
      end,
      desc = "Search History",
    },
    {
      "<leader>sa",
      function()
        Snacks.picker.autocmds()
      end,
      desc = "Autocmds",
    },
    {
      "<leader>sc",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>sC",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>sd",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>sD",
      function()
        Snacks.picker.diagnostics_buffer()
      end,
      desc = "Buffer Diagnostics",
    },
    {
      "<leader>sh",
      function()
        Snacks.picker.help()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sH",
      function()
        Snacks.picker.highlights()
      end,
      desc = "Highlights",
    },
    {
      "<leader>si",
      function()
        Snacks.picker.icons()
      end,
      desc = "Icons",
    },
    {
      "<leader>sj",
      function()
        Snacks.picker.jumps()
      end,
      desc = "Jumps",
    },
    {
      "<leader>sk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Keymaps",
    },
    {
      "<leader>sl",
      function()
        Snacks.picker.loclist()
      end,
      desc = "Location List",
    },
    {
      "<leader>sm",
      function()
        Snacks.picker.marks()
      end,
      desc = "Marks",
    },
    {
      "<leader>sM",
      function()
        Snacks.picker.man()
      end,
      desc = "Man Pages",
    },
    {
      "<leader>sp",
      function()
        Snacks.picker.lazy()
      end,
      desc = "Search for Plugin Spec",
    },
    {
      "<leader>sq",
      function()
        Snacks.picker.qflist()
      end,
      desc = "Quickfix List",
    },
    {
      "<leader>sR",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>su",
      function()
        Snacks.picker.undo()
      end,
      desc = "Undo History",
    },
    {
      "<leader>uC",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Colorschemes",
    },
    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Goto Definition",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations()
      end,
      desc = "Goto Declaration",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Goto Implementation",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "<leader>ss",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>sS",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "LSP Workspace Symbols",
    },
  },

  init = function()
    set_indent_hl()

    -- Register autocmd to re-configure hl upon color scheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = set_indent_hl,
    })
  end,

  config = function(_, opts)
    require("snacks").setup(opts)

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
  end,
}
