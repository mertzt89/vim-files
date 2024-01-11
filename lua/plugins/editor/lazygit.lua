if vim.fn.has("nvim") and vim.fn.executable("nvr") then
  local command = "nvr -cc split --servername " .. vim.v.servername .. " --remote-wait +'set bufhidden=wipe'"
  vim.env.GIT_EDITOR = command
  vim.env.EDITOR = command
  vim.env.VISUAL = command
end

return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyLoad",
        callback = function(ev)
          if ev.data == "lazygit.nvim" then
            vim.g.lazygit_use_custom_config_file_path = 1
            vim.g.lazygit_config_file_path = require("util").nvim_config_dir() .. "/lazygit.nvr.yml"
            vim.keymap.set("n", "<leader>gg", "<cmd>LazyGitCurrentFile<cr>", { desc = "Lazygit" })
            vim.keymap.set("n", "<leader>gG", "<cmd>LazyGit<cr>", { desc = "Lazygit" })
          end
        end,
      })
    end,
  },
}
