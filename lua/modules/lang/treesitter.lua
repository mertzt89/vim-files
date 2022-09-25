local module = {}
local plug = require("lib.plug")

function module.register_plugins(use)
    -- Tresitter
    use({
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                ignore_install = { "comment" }, -- List of parsers to ignore installing
                highlight = {
                    enable = true, -- false will disable the whole extension
                    disable = { "comment" }, -- list of language that will be disabled
                },
            })
        end,
        run = ":TSUpdate",
    })

    use({
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = { ["]]"] = "@function.outer" },
                        goto_next_end = { ["]["] = "@function.outer" },
                        goto_previous_start = { ["[["] = "@function.outer" },
                        goto_previous_end = { ["[]"] = "@function.outer" },
                    },
                },
            })
        end,
    })
end

function module.init() end

function module.context(width, separator)
    separator = separator or " -> "

    if not plug.has_plugin("nvim-treesitter") then
        return " "
    end
    local type_patterns = {
        "class",
        "function",
        "method",
        "interface",
        "type_spec",
        "table",
        "if_statement",
        "for_statement",
        "for_in_statement",
        "call_expression",
        "comment",
        "switch_statement",
        "case_statement",
    }

    if vim.o.ft == "json" then
        type_patterns = { "object", "pair" }
    end

    local context = require("nvim-treesitter").statusline({
        indicator_size = width,
        type_patterns = type_patterns,
        separator = separator,
    })
    return context or ""
end

return module
