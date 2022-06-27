--
-- init.lua
--
local file = require 'lib.file'

local module = {}

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_buf_opt(name, value)
  vim.o[name] = value
  vim.api.nvim_create_autocmd("VimEnter", {
    -- pattern = "*"
    callback = function() vim.bo[name] = value end
  })
end

function module.register_plugins(use)
  use({
    'lambdalisue/fern.vim',
    config = function()
      local keybind = require 'lib.keybind'

      keybind.bind_command(keybind.mode.NORMAL, "<F6>",
                           ":Fern . -drawer -toggle<CR>",
                           {noremap = true, silent = true})

      if require'lib.plug'.has_plugin('fern-renderer-nerdfont.vim') then
        vim.g['fern#renderer'] = "nerdfont"
      end
    end
  })
  use({
    'lambdalisue/fern-renderer-nerdfont.vim',
    requires = {{'lambdalisue/nerdfont.vim'}}
  })

  -- Multiple cursors
  use({'terryma/vim-multiple-cursors'})

  -- vsnip
  use {'hrsh7th/vim-vsnip'}
  use {'hrsh7th/vim-vsnip-integ'}

  -- Block Commenting
  use {
    'numToStr/Comment.nvim',
    config = function() require('Comment').setup() end
  }

  -- Git signs
  use({'mhinz/vim-signify'})

  -- Vista
  -- File outline
  use {
    'liuchengxu/vista.vim',
    config = function()
      local keybind = require 'lib.keybind'
      vim.g.vista_default_executive = "nvim_lsp"
      keybind.bind_command(keybind.mode.NORMAL, "<F5>", "<cmd>Vista!!<CR>",
                           {noremap = true, silent = true})
    end
  }

  -- Extra filetypes/syntax definitions
  use({'sheerun/vim-polyglot'})

  -- Git integration
  use({'tpope/vim-fugitive'})

  -- Hop (like easymotion)
  use({
    'phaazon/hop.nvim',
    branch = 'v1', -- optional but strongly recommended
    config = function()
      local keybind = require 'lib.keybind'
      -- you can configure Hop the way you like here; see :h hop-config
      -- require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

      require'hop'.setup()

      keybind.bind_command(keybind.mode.NORMAL, '<leader>,w',
                           "<cmd>lua require'hop'.hint_words()<cr>", {})
    end
  })

  -- Fuzzy grepping, file finding, etc..
  require'modules.core.telescope'.register(use)

  -- Quickfix reflector
  --  Allows the quickfix window to be modifiable and changes
  --  are saved to the respective files.
  use {'stefandtw/quickfix-reflector.vim'}

  -- ISwap
  --  Interactively swap elements using tree-sitter
  use {'mizlan/iswap.nvim'}

  -- Enhanced diffing
  --  Adds additional diffing algorithms and the ability to
  --  switch between them.
  use {'chrisbra/vim-diff-enhanced'}

  -- Visual Star Search
  --  Allows using visual selection for search term when using '*' or '#'
  use {'nelstrom/vim-visual-star-search'}
end

function module.init()
  local keybind = require 'lib.keybind'

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
  vim.o.laststatus = 3 -- last window

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
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function() vim.cmd(":%s/\\s\\+$//e") end
  })

  if file.is_readable("./.nvim.lua") then dofile("./.nvim.lua") end
end

return module
