--
-- init.lua
--
local file = require("lib.file")

local module = {}

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_buf_opt(name, value)
    vim.o[name] = value
    vim.api.nvim_create_autocmd("VimEnter", {
        -- pattern = "*"
        callback = function()
            vim.bo[name] = value
        end,
    })
end

function module.register_plugins(use)
    use({
        "kyazdani42/nvim-tree.lua",
        requires = {
            "kyazdani42/nvim-web-devicons", -- optional, for file icons
        },
        tag = "nightly", -- optional, updated every week. (see issue #1193)
        config = function()
            require("nvim-tree").setup({
                view = {
                    mappings = {
                        list = {
                            { key = "l", action = "edit" },
                            { key = "h", action = "close_node" },
                        },
                    },
                },
            })

            require("which-key").register({
                ["<F6>"] = { "<cmd>NvimTreeFindFileToggle<cr>", "Toggle Nvim Tree" },
            })
        end,
    })

    -- Multiple cursors
    use({ "terryma/vim-multiple-cursors" })

    -- vsnip
    use({ "hrsh7th/vim-vsnip" })
    use({ "hrsh7th/vim-vsnip-integ" })

    -- Block Commenting
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    })

    -- Vista
    -- File outline
    use({
        "liuchengxu/vista.vim",
        config = function()
            local wk = require("which-key")

            vim.g.vista_default_executive = "nvim_lsp"

            wk.register({ ["<F5>"] = { "<cmd>Vista!!<CR>", "Vista Toggle" } })
        end,
    })

    -- Hop (like easymotion)
    use({
        "phaazon/hop.nvim",
        branch = "master",
        config = function()
            local wk = require("which-key")
            -- you can configure Hop the way you like here; see :h hop-config
            -- require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }

            require("hop").setup()

            wk.register({
                ["<leader>,"] = {
                    name = "+Hop",
                    w = { "<cmd>lua require'hop'.hint_words()<cr>", "Hop" },
                },
            })
        end,
    })

    -- Quickfix reflector
    --  Allows the quickfix window to be modifiable and changes
    --  are saved to the respective files.
    use({ "stefandtw/quickfix-reflector.vim" })

    -- Enhanced diffing
    --  Adds additional diffing algorithms and the ability to
    --  switch between them.
    use({ "chrisbra/vim-diff-enhanced" })

    -- Visual Star Search
    --  Allows using visual selection for search term when using '*' or '#'
    use({ "nelstrom/vim-visual-star-search" })

    -- Yanky
    use({
        "gbprod/yanky.nvim",
        config = function()
            local utils = require("yanky.utils")
            local mapping = require("yanky.telescope.mapping")
            require("yanky").setup({
                picker = {
                    telescope = {
                        mappings = {
                            default = mapping.put("p"),
                            i = {
                                ["<c-p>"] = mapping.put("p"),
                                ["<c-o>"] = mapping.put("P"),
                                ["<c-x>"] = mapping.delete(),
                                ["<c-r>"] = mapping.set_register(utils.get_default_register()),
                            },
                            n = {
                                p = mapping.put("p"),
                                P = mapping.put("P"),
                                d = mapping.delete(),
                                r = mapping.set_register(utils.get_default_register()),
                            },
                        },
                    },
                },
            })

            require("telescope").load_extension("yank_history")

            require("which-key").register({
                ["<leader>ty"] = { "<cmd>Telescope yank_history<cr>", "Yank History" },
            })
        end,
    })

    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    })

    use({
        "max397574/colortils.nvim",
        config = function()
            require("colortils").setup()

            local wk = require("which-key")
            wk.register({
                ["<leader>c"] = {
                    name = "+Color",
                    ["p"] = { "<cmd>Colortils picker<cr>", "Picker" },
                    ["l"] = { "<cmd>Colortils lighten<cr>", "Lighten" },
                    ["d"] = { "<cmd>Colortils darken<cr>", "Darken" },
                    ["e"] = { "<cmd>Colortils greyscale<cr>", "Greyscale" },
                    ["g"] = { "<cmd>Colortils gradient<cr>", "Gradient" },
                    ["L"] = { "<cmd>Colortils css list<cr>", "CSS Color List" },
                },
            })
        end,
    })

    use({
        "chrisbra/Colorizer",
        config = function()
            vim.g.colorizer_auto_filetype = "css,scss,html,sass,ts,js"
        end,
    })

    use({
        "echasnovski/mini.nvim",
        config = function()
            require("mini.align").setup({
                mappings = { start = "<leader>a", start_with_preview = "<leader>A" },
            })

            require("mini.indentscope").setup()
        end,
    })

    -- Auto pairs for (['" etc..
    use({
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    })

    use { "akinsho/toggleterm.nvim", tag = '*', config = function()
        require("toggleterm").setup {
            auto_scroll = false,
            open_mapping = [[<c-\>]],
            direction = 'float'
        }
    end }

    -- Fuzzy grepping, file finding, etc..
    require("modules.core.telescope").register(use)

    -- Git integrations
    require("modules.core.git").register(use)
end

function module.init()
    local wk = require("which-key")

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
    wk.register({
        ["<leader>w"] = {
            name = "+Window",
            h = { "<C-w>h", "Move Left" },
            j = { "<C-w>j", "Move Down" },
            k = { "<C-w>k", "Move Up" },
            l = { "<C-w>l", "Move Right" },
        },
    })

    -- Remove trailing whitespace
    vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
            if require("lib.project").config.trim_whitespace then
                vim.cmd(":%s/\\s\\+$//e")
            end
        end,
    })

    if file.is_readable("./.nvim.lua") then
        dofile("./.nvim.lua")
    end
end

return module
