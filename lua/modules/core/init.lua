--
-- init.lua
--

local autocmd = require'lib.autocmd'
local command = require'lib.command'
local file = require'lib.file'
local keybind = require'lib.keybind'
local log = require'lib.log'
local plugman = require'lib.plugman'

local module = {}


-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_buf_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function()
    vim.bo[name] = value
  end)
end

function _G.grep_operator(t, ...)
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
    
    require'telescope.builtin'.grep_string({search=query})
end

local function register_telescope()
    -- Telescope
    plugman.use({'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/popup.nvim'},
            {'nvim-lua/plenary.nvim'}
        },
        config = function()
            local actions = require'telescope.actions'
            local keybind = require'lib.keybind'

            require'telescope'.setup {
                defaults = {
                    file_sorter = require'telescope.sorters'.get_fuzzy_file,
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-n>"] = actions.move_selection_next,
                            ["<Down>"] = actions.move_selection_next,

                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<Up>"] = actions.move_selection_previous,

                            ["<C-c>"] = actions.close,

                            ["<CR>"] = actions.goto_file_selection_edit + actions.center,
                            ["<C-x>"] = actions.goto_file_selection_split,
                            ["<C-v>"] = actions.goto_file_selection_vsplit,
                            ["<C-t>"] = actions.goto_file_selection_tabedit,

                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },

                        n = {
                            ["<esc>"] = actions.close,
                            ["q"] = actions.close,
                            ["<CR>"] = actions.goto_file_selection_edit + actions.center,
                            ["<C-x>"] = actions.goto_file_selection_split,
                            ["<C-v>"] = actions.goto_file_selection_vsplit,
                            ["<C-t>"] = actions.goto_file_selection_tabedit,

                            ["j"] = actions.move_selection_next,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-n>"] = actions.move_selection_next,
                            ["<Down>"] = actions.move_selection_next,

                            ["k"] = actions.move_selection_previous,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-p>"] = actions.move_selection_previous,
                            ["<Up>"] = actions.move_selection_previous,

                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },
                    }
                }
            } -- end telescope setup
        keybind.bind_command(keybind.mode.NORMAL, "<C-p>", ":Telescope find_files find_command=rg,--files,-L,--no-ignore-vcs,--hidden<CR>", { noremap = true, silent = true })
        keybind.bind_command(keybind.mode.NORMAL, "<F3>", ":Telescope buffers show_all_buffers=true<CR>", { noremap = true, silent = true })
        end
    })
end

function module.register_plugins()
    -- File tree
    --plugman.use({'kyazdani42/nvim-web-devicons'})
    --plugman.use({'kyazdani42/nvim-tree.lua', config = function()
    --    local keybind = require'lib.keybind'
    --    keybind.bind_command(keybind.mode.NORMAL, "<F6>", ":LuaTreeToggle<CR>", { noremap = true, silent = true })
    --end})
    plugman.use({'lambdalisue/fern.vim', config = function()
        local keybind = require'lib.keybind'
        local plugman = require'lib.plugman'

        keybind.bind_command(keybind.mode.NORMAL, "<F6>", ":Fern . -drawer -toggle<CR>", { noremap = true, silent = true })

        if plugman.has_plugin('fern-renderer-nerdfont.vim') then
            vim.g['fern#renderer'] = "nerdfont"
        end
    end})
    plugman.use({'lambdalisue/fern-renderer-nerdfont.vim', requires = {
                {'lambdalisue/nerdfont.vim'}
        }})

    -- Multiple cursors
    plugman.use({'terryma/vim-multiple-cursors'})

    -- Snippets
    plugman.use({'norcalli/snippets.nvim', config = function()
        local keybind = require'lib.keybind'
        local snippets = require'snippets'

        _G.advance_snippet = snippets.advance_snippet
        _G.expand_or_advance_snippet = snippets.expand_or_advance
        keybind.bind_command(keybind.mode.INSERT, "<C-j>", "pumvisible() ? '<C-n>' : v:lua.advance_snippet(-1) ? '' : '<C-j>'", { noremap = true, expr = true })
        keybind.bind_command(keybind.mode.INSERT, "<C-k>", "pumvisible() ? '<C-p>' : v:lua.expand_or_advance_snippet(1) ? '' : '<C-k>'", { noremap = true, expr = true })
    end})

    -- Git signs
    plugman.use({'mhinz/vim-signify'})

    -- Tag bar
    plugman.use({'majutsushi/tagbar', config = function ()
        local keybind = require'lib.keybind'
        keybind.bind_command(keybind.mode.NORMAL, "<F5>", "<cmd>TagbarToggle<CR>", { noremap = true, silent = true })
    end})

    -- Extra filetypes/syntax definitions
    plugman.use({'sheerun/vim-polyglot'})

    -- Git integration
    plugman.use({'tpope/vim-fugitive'})

    -- Fuzzy grepping, file finding, etc..
    register_telescope()
end

function module.init()
    vim.g.mapleader = ","

    vim.cmd("filetype plugin on")

    vim.o.viminfo = "'100,<500,s10,h,!"

    --keybind.bind_command(keybind.mode.NORMAL, "gs", ":set opfunc=v:lua.require'modules.core'.grep_operator<CR>g@")
    keybind.bind_command(keybind.mode.NORMAL, "gs", ":set opfunc=v:lua.grep_operator<CR>g@", { silent = true } )
    keybind.bind_command(keybind.mode.VISUAL, "gs", ":<c-u>call v:lua.grep_operator(visualmode())<CR>", { silent = true } )

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
    keybind.bind_command(keybind.mode.NORMAL, "<leader>wh", "<C-w>h", { noremap = true })
    keybind.bind_command(keybind.mode.NORMAL, "<leader>wj", "<C-w>j", { noremap = true })
    keybind.bind_command(keybind.mode.NORMAL, "<leader>wk", "<C-w>k", { noremap = true })
    keybind.bind_command(keybind.mode.NORMAL, "<leader>wl", "<C-w>l", { noremap = true })

    -- Tab navigation key bindings
    keybind.bind_command(keybind.mode.NORMAL, "th", ":tabprevious<CR>", { noremap = true, silent = true })
    keybind.bind_command(keybind.mode.NORMAL, "tl", ":tabnext<CR>", { noremap = true, silent = true })

    if file.is_readable("./.project.lua") then
        dofile("./.project.lua")
    end
end


return module


