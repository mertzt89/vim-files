local is_win = require("util").is_win()

local cword_w = ""
local cword_a = ""

local feedkeys_escaped = function(keys)
  local escaped = require("fzf-lua.utils").rg_escape(vim.api.nvim_replace_termcodes(keys, true, true, true))
  return vim.api.nvim_feedkeys(escaped, "n", true)
end

-- FZF command wrapper that merges common configurations
local fzf_cmd = function(fzf_command, opts)
  opts = opts or {}

  opts = vim.tbl_deep_extend("keep", opts, {
    winopts = {
      on_create = function()
        local b = vim.api.nvim_get_current_buf()

        -- Access vim registers from FZF prompt
        vim.keymap.set("t", "<C-r>", function()
          vim.schedule(function()
            local char = vim.fn.getchar() -- get character code

            if char == 23 then -- <C-w>
              feedkeys_escaped(cword_w)
            elseif char == 1 then -- <C-a>
              feedkeys_escaped(cword_a)
            else
              local key = vim.fn.nr2char(char) -- convert to key
              feedkeys_escaped(vim.fn.getreg(key))
            end
          end)
        end, { buffer = b, expr = true })
      end,
    },
  })

  return function()
    cword_w = vim.fn.expand("<cword>")
    cword_a = vim.fn.expand("<cWORD>")
    require("fzf-lua")[fzf_command](opts)
  end
end

-- Custom find files command handling
local find_files_command = function(extra_args, opts)
  extra_args = extra_args or {}
  opts = opts or {}

  local cmd = vim.list_extend({ "rg", "--color", "never", "--files" }, extra_args)
  opts = vim.tbl_deep_extend("keep", opts, { cmd = table.concat(cmd, " ") })

  return fzf_cmd("files", opts)
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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      { "junegunn/fzf", build = is_win and "powershell ./install.ps1" or "./install --bin" },
    },
    keys = function()
      local fzf = require("fzf-lua")
      return {
        -- Buffer
        { "<leader><space>", fzf_cmd("buffers"), { desc = "Buffers" } },

        -- Commands
        { "<leader>sa", fzf_cmd("autocmds"), desc = "Auto Commands" },
        { "<leader>sC", fzf_cmd("commands"), desc = "Commands" },
        { "<leader>sc", fzf_cmd("command_history"), desc = "Command History" },

        -- Diagnostics
        { "<leader>sD", fzf_cmd("diagnostics_workspace"), desc = "Workspace diagnostics" },
        { "<leader>sd", fzf_cmd("diagnostics_document"), { desc = "Diagnostics" } },

        -- Find Files
        { "<leader>?", fzf_cmd("oldfiles"), { desc = "Recent Files" } },
        {
          "<leader>ff",
          find_files.no_ignore_vcs,
          { desc = "Find Files (--no-ignore-vcs)" },
        },
        { "<leader>fF", find_files.default, { desc = "Find Files" } },
        { "<leader>fa", find_files.all, { desc = "Find Files (ALL)" } },
        { "<leader>fs", fzf_cmd("lgrep_curbuf"), { desc = "Find in Buffer" } },

        -- Grep
        {
          "<leader>fg",
          fzf_cmd("live_grep_glob", { rg_opts = "--no-ignore-vcs " .. fzf.defaults.grep.rg_opts }),
          { desc = "Live Grep" },
        },
        {
          "<leader>fG",
          fzf_cmd("live_grep_glob"),
          { desc = "Live Grep" },
        },
        {
          "gS",
          require("util").grep_operator(function(query)
            local opts = { rg_opts = "--no-ignore-vcs " .. fzf.defaults.grep.rg_opts, search = query }
            fzf_cmd("grep", opts)()
          end),
          mode = { "n", "x" },
        },
        {
          "gs",
          require("util").grep_operator(function(query)
            fzf_cmd("grep", { search = query })()
          end),
          mode = { "n", "x" },
        },

        -- LSP
        { "<leader>ss", fzf_cmd("lsp_document_symbols"), { desc = "Goto Symbol" } },
        { "<leader>sS", fzf_cmd("lsp_live_workspace_symbols"), { desc = "Goto Symbol (Workspace)" } },

        -- Misc
        { "<leader>sr", fzf_cmd("resume"), { desc = "Resume" } },
      }
    end,
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
  },
}
