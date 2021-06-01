--
-- init.lua
--
local autocmd = require 'lib.autocmd'
local command = require 'lib.command'
local file = require 'lib.file'
local keybind = require 'lib.keybind'
local log = require 'lib.log'
local plug = require 'lib.plug'

local module = {}

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_buf_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function() vim.bo[name] = value end)
end

function module.register_plugins()
  plug.use({
    'lambdalisue/fern.vim',
    config = function()
      local keybind = require 'lib.keybind'
      local plug = require 'lib.plug'

      keybind.bind_command(keybind.mode.NORMAL, "<F6>",
                           ":Fern . -drawer -toggle<CR>",
                           {noremap = true, silent = true})

      if plug.has_plugin('fern-renderer-nerdfont.vim') then
        vim.g['fern#renderer'] = "nerdfont"
      end
    end
  })
  plug.use({
    'lambdalisue/fern-renderer-nerdfont.vim',
    requires = {{'lambdalisue/nerdfont.vim'}}
  })

  -- Multiple cursors
  plug.use({'terryma/vim-multiple-cursors'})

  -- Snippets
  plug.use({
    'norcalli/snippets.nvim',
    config = function()
      local keybind = require 'lib.keybind'
      local snippets = require 'snippets'

      _G.advance_snippet = snippets.advance_snippet
      _G.expand_or_advance_snippet = snippets.expand_or_advance
      keybind.bind_command(keybind.mode.INSERT, "<C-j>",
                           "pumvisible() ? '<C-n>' : v:lua.advance_snippet(-1) ? '' : '<C-j>'",
                           {noremap = true, expr = true})
      keybind.bind_command(keybind.mode.INSERT, "<C-k>",
                           "pumvisible() ? '<C-p>' : v:lua.expand_or_advance_snippet(1) ? '' : '<C-k>'",
                           {noremap = true, expr = true})
    end
  })

  -- Git signs
  plug.use({'mhinz/vim-signify'})

  -- Tag bar
  plug.use({
    'majutsushi/tagbar',
    config = function()
      local keybind = require 'lib.keybind'
      keybind.bind_command(keybind.mode.NORMAL, "<F5>", "<cmd>TagbarToggle<CR>",
                           {noremap = true, silent = true})
    end
  })

  -- Extra filetypes/syntax definitions
  plug.use({'sheerun/vim-polyglot'})

  -- Git integration
  plug.use({'tpope/vim-fugitive'})

  -- Sneak (easy motion alternative)
  plug.use({'justinmk/vim-sneak'})

  -- Fuzzy grepping, file finding, etc..
  local t = require 'modules.core.telescope'
  t.register_telescope()

  -- Quickfix reflector
  --  Allows the quickfix window to be modifiable and changes
  --  are saved to the respective files.
  plug.use {'stefandtw/quickfix-reflector.vim'}

  -- ISwap
  --  Interactively swap elements using tree-sitter
  plug.use {'mizlan/iswap.nvim'}
end

function module.init()
  vim.g.mapleader = ","

  vim.cmd("filetype plugin on")

  vim.o.viminfo = "'100,<500,s10,h,!"

  -- Default indentation options
  set_default_buf_opt("tabstop", 4)
  set_default_buf_opt("softtabstop", 4)

  set_default_buf_opt("shiftwidth", 4)
  vim.o.shiftround = true

  vim.o.backspace = "indent,eol,start"
  set_default_buf_opt("expandtab", true)
  set_default_buf_opt("autoindent", true)

  -- Menu
  vim.o.wildmenu = true
  vim.o.wildmode = "list:longest"

  vim.o.virtualedit = "all"
  vim.o.laststatus = 2

  -- No wrapping
  vim.o.wrap = false

  -- Highlight search
  vim.o.hlsearch = true

  -- Incremental search
  vim.o.incsearch = true
  vim.o.inccommand = "split"

  -- Enable mouse support
  vim.o.mouse = "ar"

  -- Faster redrawing
  vim.o.lazyredraw = true

  -- Use the clipboard register when yanking/put'ing
  vim.o.clipboard = "unnamedplus"

  -- Window navigation key bindings
  keybind.bind_command(keybind.mode.NORMAL, "<leader>wh", "<C-w>h",
                       {noremap = true})
  keybind.bind_command(keybind.mode.NORMAL, "<leader>wj", "<C-w>j",
                       {noremap = true})
  keybind.bind_command(keybind.mode.NORMAL, "<leader>wk", "<C-w>k",
                       {noremap = true})
  keybind.bind_command(keybind.mode.NORMAL, "<leader>wl", "<C-w>l",
                       {noremap = true})

  -- Tab navigation key bindings
  keybind.bind_command(keybind.mode.NORMAL, "th", ":tabprevious<CR>",
                       {noremap = true, silent = true})
  keybind.bind_command(keybind.mode.NORMAL, "tl", ":tabnext<CR>",
                       {noremap = true, silent = true})

  -- Remove trailing whitespace
  autocmd.bind("BufWritePre *", function() vim.cmd(":%s/\\s\\+$//e") end)

  if file.is_readable("./.nvim.lua") then dofile("./.nvim.lua") end
end

return module

