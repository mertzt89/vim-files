local plug = require 'lib.plug'

local M = {}

local function grep_operator(t, ...)
  local regsave = vim.fn.getreg("@")
  local selsave = vim.o.selection

  vim.o.selection = 'inclusive'

  if t == 'v' or t == 'V' then
    vim.api.nvim_command('silent execute "normal! gvy"')
  elseif t == 'line' then
    vim.api.nvim_command('silent execute "normal! \'[V\']y"')
  else
    vim.api.nvim_command('silent execute "normal! `[v`]y"')
  end

  vim.o.selection = selsave
  local query = vim.fn.getreg("@")

  vim.fn.setreg("@", regsave)
  print(query)

  require'telescope.builtin'.grep_string({
    find_command = "rg,--no-ignore,--hidden,--no-heading,--vimgrep",
    search = query
  })
end

function M.register_telescope()
  -- Telescope
  plug.use({
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}},
    config = function()
      local actions = require 'telescope.actions'
      local keybind = require 'lib.keybind'

      require'telescope'.setup {
        defaults = {
          vimgrep_arguments = {
            'rg', '--color=never', '--no-heading', '--with-filename',
            '--line-number', '--column', '--smart-case', '--no-ignore-vcs'
          },
          file_sorter = require'telescope.sorters'.get_fuzzy_file,
          mappings = {
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-j>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-k>"] = actions.move_selection_previous,

              ["<C-c>"] = actions.close,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<CR>"] = actions.select_default + actions.center,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,

              ["<Tab>"] = actions.toggle_selection +
                actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection +
                actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag
            },

            n = {
              ["<esc>"] = actions.close,
              ["q"] = actions.close,
              ["<CR>"] = actions.select_default + actions.center,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,

              ["<Tab>"] = actions.toggle_selection +
                actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection +
                actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

              -- TODO: This would be weird if we switch the ordering.
              ["j"] = actions.move_selection_next,
              ["<C-j>"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["<C-k>"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,

              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,

              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down
            }
          }
        }
      } -- end telescope setup
      keybind.bind_command(keybind.mode.NORMAL, "<C-p>",
                           ":Telescope find_files find_command=rg,--files,-L,--no-ignore-vcs,--hidden<CR>",
                           {noremap = true, silent = true})
      keybind.bind_command(keybind.mode.NORMAL, "<F3>",
                           ":Telescope buffers show_all_buffers=true<CR>",
                           {noremap = true, silent = true})


      -- Grep operator
      keybind.bind_command(keybind.mode.NORMAL, "gs",
                          ":set opfunc=v:lua.telescope_grep_op<CR>g@", {silent = true})
      keybind.bind_command(keybind.mode.VISUAL, "gs",
                          ":<c-u>call v:lua.telescope_grep_op(visualmode())<CR>",
                          {silent = true})

    end
  })

  _G.telescope_grep_op = function(t, ...) grep_operator(t,...) end
end

return M