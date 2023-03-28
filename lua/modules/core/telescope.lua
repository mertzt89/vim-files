local M = {}

local function grep_operator(t, ...)
    local regsave = vim.fn.getreg("@")
    local selsave = vim.o.selection
    local selvalid = true

    vim.o.selection = "inclusive"

    if t == "v" or t == "V" then
        vim.api.nvim_command('silent execute "normal! gvy"')
    elseif t == "line" then
        vim.api.nvim_command("silent execute \"normal! '[V']y\"")
    elseif t == "char" then
        vim.api.nvim_command('silent execute "normal! `[v`]y"')
    else
        require("lib.log").error("Unsupported selection mode!")
        selvalid = false
    end

    vim.o.selection = selsave
    if selvalid then
        local query = vim.fn.getreg("@")
        require("telescope.builtin").grep_string({ search = query })
    end

    vim.fn.setreg("@", regsave)
end

function M.register(use)
    -- Telescope
    use({
        "nvim-telescope/telescope.nvim",
        requires = {
            { "nvim-lua/popup.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        },
        config = function()
            local actions = require("telescope.actions")
            local wk = require("which-key")

            require("telescope").setup({
                defaults = {
                    cache_picker = { num_pickers = 10 },
                    vimgrep_arguments = {
                        "rg",
                        "-L",
                        "--hidden",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                    },
                    file_sorter = require("telescope.sorters").get_fuzzy_file,
                    extensions = {
                        fzf = {
                            fuzzy = true, -- false will only do exact matching
                            override_generic_sorter = true, -- override the generic sorter
                            override_file_sorter = true, -- override the file sorter
                            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                            -- the default case_mode is "smart_case"
                        },
                    },
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

                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-l>"] = actions.complete_tag,
                        },

                        n = {
                            ["<esc>"] = actions.close,
                            ["q"] = actions.close,
                            ["<CR>"] = actions.select_default + actions.center,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,

                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
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
                            ["<C-d>"] = actions.preview_scrolling_down,
                        },
                    },
                },
            }) -- end telescope setup

            -- To get fzf loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("fzf")

            wk.register({
                ["<C-p>"] = {
                    function()
                        require("telescope.builtin").find_files({ find_command = { "fd", "--type", "f",
                            "--strip-cwd-prefix",
                            "--hidden", "--follow", "--exclude", ".git" } })
                    end,
                    "Find Files",
                },
                ["<F3>"] = {
                    function()
                        require("telescope.builtin").buffers({ show_all_buffers = true })
                    end,
                    "Switch Buffer",
                },
                ["<leader>t"] = {
                    name = "+Telescope",
                    u = {
                        function()
                            require("telescope.builtin").resume()
                        end,
                        "Resume",
                    },
                    h = {
                        function()
                            require("telescope.builtin").pickers()
                        end,
                        "Pickers",
                    },
                    s = {
                        function()
                            vim.ui.input({ prompt = " Grep" }, function(s)
                                if not s or s == "" then
                                    return
                                end
                                require("telescope.builtin").grep_string({ search = s })
                            end)
                        end,
                        " Grep",
                    },
                },
                ["gs"] = {
                    function()
                        vim.go.operatorfunc = "v:lua.telescope_grep_op"
                        vim.api.nvim_feedkeys("g@", "n", false)
                    end,
                    "Grep Operator",
                },
            })

            wk.register({
                ["gs"] = {
                    ":<c-u>call v:lua.telescope_grep_op(visualmode())<CR>",
                    "Grep Operator",
                    mode = "x",
                },
            })
        end,
    })

    _G.telescope_grep_op = function(t, ...)
        grep_operator(t, ...)
    end
end

return M
