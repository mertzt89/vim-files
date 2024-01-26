-- Custom find files command handling
local find_files_command = function(extra_args, opts)
  extra_args = extra_args or {}
  opts = opts or {}

  local cmd = vim.list_extend({ "rg", "--color", "never", "--files" }, extra_args)
  opts = vim.tbl_deep_extend("keep", opts, { cmd = table.concat(cmd, " ") })

  return function()
    local b = require("fzf-lua")
    b.files(opts)
  end
end

-- Different "find files" commands to be bound
local find_files = {
  default = find_files_command(),
  no_ignore_vcs = find_files_command({ "--no-ignore-vcs" }),
  all = find_files_command({ "-uu" }),
}

return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons", { "junegunn/fzf", build = "./install --bin" } },
    keys = function()
      local fzf = require("fzf-lua")
      return {
        -- Buffer
        { "<leader><space>", fzf.buffers, { desc = "Buffers" } },
        { "<leader>sb", fzf.blines, desc = "Find in Buffer" },
        { "<leader>fs", fzf.blines, { desc = "Find in Buffer" } },

        -- Commands
        { "<leader>sa", fzf.autocmds, desc = "Auto Commands" },
        { "<leader>sC", fzf.commands, desc = "Commands" },
        { "<leader>sc", fzf.command_history, desc = "Command History" },

        -- Diagnostics
        { "<leader>sD", fzf.diagnostics_workspace, desc = "Workspace diagnostics" },
        { "<leader>sd", fzf.diagnostics_document, { desc = "Diagnostics" } },

        -- Find Files
        { "<leader>?", fzf.oldfiles, { desc = "Recent Files" } },
        {
          "<leader>ff",
          find_files.no_ignore_vcs,
          { desc = "Find Files (--no-ignore-vcs)" },
        },
        { "<leader>fF", find_files.default, { desc = "Find Files" } },
        { "<leader>fa", find_files.all, { desc = "Find Files (ALL)" } },

        -- Grep
        {
          "<leader>fg",
          function()
            fzf.live_grep({ rg_opts = "--no-ignore-vcs " .. fzf.defaults.grep.rg_opts })
          end,
          { desc = "Live Grep" },
        },
        {
          "<leader>fG",
          fzf.live_grep,
          { desc = "Live Grep" },
        },
        {
          "gS",
          require("util").grep_operator(function(query)
            local opts = { rg_opts = "--no-ignore-vcs " .. fzf.defaults.grep.rg_opts, search = query }
            fzf.grep(opts)
          end),
          mode = { "n", "x" },
        },
        {
          "gs",
          require("util").grep_operator(function(query)
            fzf.grep({ search = query })
          end),
          mode = { "n", "x" },
        },

        -- LSP
        { "<leader>ss", fzf.lsp_document_symbols, { desc = "Goto Symbol" } },
        { "<leader>sS", fzf.lsp_live_workspace_symbols, { desc = "Goto Symbol (Workspace)" } },

        -- Misc
        { "<leader>sr", fzf.resume, { desc = "Resume" } },
      }
    end,
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
  },
}
